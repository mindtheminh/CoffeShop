package controller;

import com.google.gson.Gson;
import config.PayOSConfig;
import dao.CartDao;
import dao.CartDaoJdbc;
import dao.OrderDao;
import dao.OrderDaoJdbc;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Order;
import model.OrderItem;
import model.UserDto;
import vn.payos.PayOS;
import vn.payos.type.ItemData;
import vn.payos.type.PaymentData;
import vn.payos.type.CheckoutResponseData;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import vn.payos.type.PaymentLinkData;
/**
 * Payment Servlet - Handles PayOS payment integration
 *
 * Routes: GET /payment/success - Payment success callback GET /payment/cancel -
 * Payment cancel callback GET /payment/debug - Debug page POST
 * /payment/create-payment-link - Create PayOS payment link POST
 * /payment/webhook - PayOS webhook callback POST /payment/verify-payment -
 * Verify payment status
 *
 * Note: Servlet is configured in web.xml, not using @WebServlet annotation
 */
public class PaymentServlet extends HttpServlet {

    // Constants
    private static final String FREE_SHIPPING_THRESHOLD = "500000";
    private static final BigDecimal SHIPPING_FEE = new BigDecimal("30000");
    private static final int MAX_DESCRIPTION_LENGTH = 25;
    private static final int MAX_PRODUCT_NAME_LENGTH = 100;
    private static final String SESSION_ORDER_CODE_PREFIX = "paymentOrderCode_";

    // Dependencies
    private final CartDao cartDao = new CartDaoJdbc();
    private final OrderDao orderDao = new OrderDaoJdbc();
    private final Gson gson = new Gson();

    // ==================== HTTP Methods ====================
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String pathInfo = req.getPathInfo();

        if (pathInfo == null) {
            sendNotFound(resp);
            return;
        }

        switch (pathInfo) {
            case "/success":
                handlePaymentSuccess(req, resp);
                break;
            case "/cancel":
                handlePaymentCancel(req, resp);
                break;
            case "/debug":
                req.getRequestDispatcher("/WEB-INF/view/customer/payment-debug.jsp").forward(req, resp);
                break;
            default:
                sendNotFound(resp);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String pathInfo = req.getPathInfo();

        if (pathInfo == null) {
            sendNotFound(resp);
            return;
        }

        switch (pathInfo) {
            case "/create-payment-link":
                handleCreatePaymentLink(req, resp);
                break;
            case "/webhook":
                handleWebhook(req, resp);
                break;
            case "/verify-payment":
                handleVerifyPayment(req, resp);
                break;
            default:
                sendNotFound(resp);
                break;
        }
    }

    // ==================== Payment Link Creation ====================
    /**
     * Create PayOS payment link
     */
  private void handleCreatePaymentLink(HttpServletRequest req, HttpServletResponse resp)
        throws ServletException, IOException {

    setJsonResponse(resp);

    try {
        // 1. Kiểm tra đăng nhập
        UserDto authUser = getAuthenticatedUser(req);
        if (authUser == null) {
            sendErrorResponse(resp, "User not logged in");
            return;
        }

        int userId = Integer.parseInt(authUser.getUserId());

        // 2. Lấy cart
        Order cart = cartDao.findOrCreateCart(userId);
        if (cart == null) {
            sendErrorResponse(resp, "Cart not found");
            return;
        }

        List<OrderItem> cartItems = cartDao.getCartItems(cart.getOrderId());
        if (cartItems.isEmpty()) {
            sendErrorResponse(resp, "Cart is empty");
            return;
        }

        // 3. Tính tiền
        OrderTotals totals = calculateOrderTotals(cartItems, cart.getOrderId());
        logOrderCalculation(cart.getOrderId(), totals);

        // 4. Đảm bảo order vẫn là cart và có items
        Optional<Order> orderOpt = orderDao.findById(cart.getOrderId());
        if (!orderOpt.isPresent()) {
            System.err.println("Cart validation failed: Order not found!");
            sendErrorResponse(resp, "Cart not found");
            return;
        }
        
        Order currentOrder = orderOpt.get();
        if (!currentOrder.isCart()) {
            System.err.println("Cart validation failed: Order is not a cart! Status: " + currentOrder.getStatus());
            sendErrorResponse(resp, "Invalid cart state. Order already processed.");
            return;
        }

        System.out.println("Cart validated successfully for payment: " + cart.getOrderId());

        // 5. Build PayOS payment data
        PaymentData paymentData = buildPaymentData(cart, cartItems, totals, req);

        // 6. Check amount = sum(items)
        int calculatedItemsTotal = paymentData.getItems().stream()
                .mapToInt(item -> item.getPrice() * item.getQuantity())
                .sum();

        if (paymentData.getAmount() != calculatedItemsTotal) {
            System.err.println("ERROR: Amount mismatch!");
            System.err.println("Payment Amount: " + paymentData.getAmount());
            System.err.println("Items Total: " + calculatedItemsTotal);
            System.err.println("Difference: " + Math.abs(paymentData.getAmount() - calculatedItemsTotal));
            sendErrorResponse(resp, "Lỗi tính toán: Số tiền không khớp với tổng sản phẩm. Vui lòng thử lại.");
            return;
        }

        // 7. Gọi PayOS.createPaymentLink
        PayOS payOS = PayOSConfig.getPayOS();

        System.out.println("=== CREATING PAYOS PAYMENT LINK ===");
        System.out.println("Order Code: " + paymentData.getOrderCode());
        System.out.println("Amount: " + paymentData.getAmount());
        System.out.println("Items Count: " + paymentData.getItems().size());
        System.out.println("Description: " + paymentData.getDescription());
        System.out.println("Return URL: " + paymentData.getReturnUrl());
        System.out.println("Cancel URL: " + paymentData.getCancelUrl());

        System.out.println("Items detail:");
        int itemsTotalCheck = 0;
        for (ItemData item : paymentData.getItems()) {
            int itemTotal = item.getPrice() * item.getQuantity();
            itemsTotalCheck += itemTotal;
            System.out.println("  - " + item.getName() + ": " + item.getPrice() + " x "
                    + item.getQuantity() + " = " + itemTotal);
        }
        System.out.println("Items Total (calculated): " + itemsTotalCheck);
        System.out.println("Payment Amount: " + paymentData.getAmount());
        System.out.println("Amount Match: " + (paymentData.getAmount() == itemsTotalCheck));

        if (paymentData.getAmount() != itemsTotalCheck) {
            System.err.println("CRITICAL ERROR: Amount mismatch detected right before PayOS call!");
            System.err.println("  Payment Amount: " + paymentData.getAmount());
            System.err.println("  Items Total: " + itemsTotalCheck);
            sendErrorResponse(resp, "Lỗi tính toán: Số tiền không khớp. Vui lòng thử lại.");
            return;
        }

        CheckoutResponseData paymentLinkResponse;

        try {
            System.out.println("Calling PayOS.createPaymentLink()...");
            paymentLinkResponse = payOS.createPaymentLink(paymentData);
            System.out.println("=== PAYOS PAYMENT LINK CREATED SUCCESSFULLY ===");
            System.out.println("Checkout URL: " + paymentLinkResponse.getCheckoutUrl());

        } catch (Exception e) {
            String errorMessage = e.getMessage() != null ? e.getMessage() : "";
            System.err.println("=== PAYOS SDK ERROR (createPaymentLink) ===");
            System.err.println("Error type: " + e.getClass().getName());
            System.err.println("Error message: " + errorMessage);

            // Xử lý riêng lỗi "Đơn thanh toán đã tồn tại"
            if (errorMessage.contains("Đơn thanh toán đã tồn tại")
                    || errorMessage.toLowerCase().contains("order existed")
                    || errorMessage.toLowerCase().contains("order already exists")) {

                System.err.println("PayOS báo đơn thanh toán đã tồn tại với orderCode: " + paymentData.getOrderCode());
                System.err.println("Tạo orderCode mới và thử lại...");

                try {
                    // Tạo orderCode mới và build lại payment data
                    long newOrderCode = generateUniqueOrderCode();
                    System.out.println("Generated new orderCode: " + newOrderCode);
                    
                    // Build lại payment data với orderCode mới
                    PaymentData newPaymentData = PaymentData.builder()
                            .orderCode(newOrderCode)
                            .amount(paymentData.getAmount())
                            .description(paymentData.getDescription())
                            .items(paymentData.getItems())
                            .returnUrl(paymentData.getReturnUrl())
                            .cancelUrl(paymentData.getCancelUrl())
                            .build();

                    // Thử tạo link với orderCode mới
                    paymentLinkResponse = payOS.createPaymentLink(newPaymentData);
                    System.out.println("=== PAYOS PAYMENT LINK CREATED SUCCESSFULLY (with new orderCode) ===");
                    System.out.println("Checkout URL: " + paymentLinkResponse.getCheckoutUrl());
                    
                    // Lưu orderCode mới vào session
                    HttpSession session = req.getSession();
                    session.setAttribute(SESSION_ORDER_CODE_PREFIX + cart.getOrderId(), newOrderCode);
                    session.setAttribute("paymentOrderId_" + cart.getOrderId(), cart.getOrderId());
                    session.setAttribute("paymentAmount_" + cart.getOrderId(), totals.getFinalAmount());
                    
                    // Trả kết quả cho FE
                    resp.getWriter().write(gson.toJson(paymentLinkResponse));
                    return;

                } catch (Exception ex2) {
                    System.err.println("Không thể tạo payment link với orderCode mới: " + ex2.getMessage());
                    ex2.printStackTrace();
                    sendErrorResponse(resp, "Không thể tạo link thanh toán. Vui lòng thử lại sau.");
                    return;
                }
            }

            // Các lỗi khác: dùng handler chung
            handleException(e, resp, "Error creating payment link");
            return;
        }

        // 8. Lưu thông tin thanh toán vào session (khi tạo link mới thành công)
        HttpSession session = req.getSession();
        session.setAttribute(SESSION_ORDER_CODE_PREFIX + cart.getOrderId(), paymentData.getOrderCode());
        session.setAttribute("paymentOrderId_" + cart.getOrderId(), cart.getOrderId());
        session.setAttribute("paymentAmount_" + cart.getOrderId(), totals.getFinalAmount());

        // 9. Trả kết quả cho FE
        resp.getWriter().write(gson.toJson(paymentLinkResponse));

    } catch (Exception e) {
        handleException(e, resp, "Error creating payment link");
    }
}


    // ==================== Payment Callbacks ====================
    /**
     * Handle payment success callback
     */
    private void handlePaymentSuccess(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String orderId = req.getParameter("orderId");

        if (orderId == null || orderId.isEmpty()) {
            System.err.println("Payment success callback: orderId is missing");
            redirectToCart(req, resp);
            return;
        }

        try {
            Optional<Order> orderOpt = orderDao.findById(orderId);
            if (!orderOpt.isPresent()) {
                System.err.println("Payment success callback: Order not found: " + orderId);
                redirectToCart(req, resp);
                return;
            }

            Order order = orderOpt.get();
            System.out.println("Payment success callback for order: " + orderId);
            System.out.println("Current order status: " + order.getStatus() + ", isCart: " + order.isCart());

            // Kiểm tra xem order đã được xử lý chưa (tránh xử lý nhiều lần)
            // Pending, Processing hoặc Completed đều được coi là đã xử lý (không còn là cart)
            if (!order.isCart() && ("Pending".equals(order.getStatus()) || "Processing".equals(order.getStatus()) || "Completed".equals(order.getStatus())) && "Paid".equals(order.getPaymentStatus())) {
                System.out.println("Order already processed. Redirecting to success page.");
                HttpSession session = req.getSession();
                session.setAttribute("paymentSuccess", true);
                session.setAttribute("successMessage", "Thanh toán thành công! Đơn hàng #" + orderId);
                session.setAttribute("successOrderId", orderId);
                req.setAttribute("orderId", orderId);
                req.getRequestDispatcher("/WEB-INF/view/home/payment-success.jsp").forward(req, resp);
                return;
            }

            // Chỉ checkout nếu order vẫn là cart
            if (order.isCart()) {
                // Calculate final totals (with discount) for checkout
                List<OrderItem> orderItems = cartDao.getCartItems(orderId);
                if (orderItems.isEmpty()) {
                    System.err.println("Payment success callback: Cart items not found for order: " + orderId);
                    redirectToCart(req, resp);
                    return;
                }

                OrderTotals finalTotals = calculateOrderTotals(orderItems, orderId);

                // Checkout cart now that payment is confirmed
                // For online orders, start with Pending status (cashier will confirm later)
                if (!cartDao.checkoutCart(orderId, finalTotals.getTotal(), "Pending")) {
                    System.err.println("Failed to checkout cart after payment!");
                    redirectToCart(req, resp);
                    return;
                }

                // Reload order after checkout
                orderOpt = orderDao.findById(orderId);
                if (orderOpt.isPresent()) {
                    order = orderOpt.get();
                    // Mark as online order
                    order.setOrderType("Online");
                    orderDao.update(order);
                } else {
                    System.err.println("Failed to reload order after checkout!");
                    redirectToCart(req, resp);
                    return;
                }
            }

            // Update order payment status (chỉ nếu chưa được cập nhật)
            // Đơn từ public page sẽ ở status Pending, thu ngân sẽ xác nhận sau
            // Payment status is Paid (đã thanh toán qua PayOS), nhưng order status vẫn là Pending
            if (!"Paid".equals(order.getPaymentStatus()) || !"PayOS".equals(order.getPayMethod())) {
                // Keep status as Pending, only update payment status to Paid and method to PayOS
                order.setPaymentStatus("Paid");
                order.setPayMethod("PayOS");
                order.setStatus("Pending"); // Keep as Pending for cashier to confirm
                orderDao.update(order);
            }

            // Create new cart for user (chỉ nếu chưa có cart mới)
            createNewCartForUser(req);

            // Set success message
            HttpSession session = req.getSession();
            session.setAttribute("paymentSuccess", true);
            session.setAttribute("successMessage", "Thanh toán thành công! Đơn hàng #" + orderId);
            session.setAttribute("successOrderId", orderId);
            req.setAttribute("orderId", orderId);

            // Forward to success page
            req.getRequestDispatcher("/WEB-INF/view/home/payment-success.jsp").forward(req, resp);

        } catch (Exception e) {
            System.err.println("Error in handlePaymentSuccess: " + e.getMessage());
            e.printStackTrace();
            redirectToCart(req, resp);
        }
    }

    /**
     * Handle payment cancel callback
     */
    private void handlePaymentCancel(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String orderId = req.getParameter("orderId");

        HttpSession session = req.getSession();
        session.setAttribute("paymentCancelled", true);
        session.setAttribute("errorMessage", "Thanh toán đã bị hủy");

        // Redirect to checkout or cart
        if (orderId != null && !orderId.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/home/cart/checkout");
        } else {
            redirectToCart(req, resp);
        }
    }

    // ==================== Payment Verification ====================
    /**
     * Verify payment status from PayOS
     */
    private void handleVerifyPayment(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        setJsonResponse(resp);

        try {
            String orderId = req.getParameter("orderId");
            if (orderId == null || orderId.isEmpty()) {
                sendErrorResponse(resp, "Order ID is required");
                return;
            }

            // Get order code from session
            HttpSession session = req.getSession();
            Long orderCode = (Long) session.getAttribute(SESSION_ORDER_CODE_PREFIX + orderId);

            if (orderCode == null) {
                System.err.println("ERROR: Payment session not found for orderId: " + orderId);
                sendErrorResponse(resp, "Payment session not found. Please try again.");
                return;
            }

            // Get payment info from PayOS
            PayOS payOS = PayOSConfig.getPayOS();
            PaymentLinkData paymentInfo = payOS.getPaymentLinkInformation(orderCode);
            
            System.out.println("Payment status from PayOS: " + paymentInfo.getStatus());
            System.out.println("Payment amount: " + paymentInfo.getAmount());

            // Handle payment status
            handlePaymentStatus(orderId, paymentInfo.getStatus(), session, resp);

        } catch (Exception e) {
            handleException(e, resp, "Error verifying payment");
        }
    }

    /**
     * Handle PayOS webhook callback
     */
    private void handleWebhook(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        setJsonResponse(resp);

        try {
            String webhookData = readRequestBody(req);
            System.out.println("=== PAYOS WEBHOOK RECEIVED ===");
            System.out.println("Webhook data: " + webhookData);

            com.google.gson.JsonObject jsonObject = gson.fromJson(webhookData, com.google.gson.JsonObject.class);

            if (jsonObject.has("data")) {
                com.google.gson.JsonObject data = jsonObject.getAsJsonObject("data");
                long orderCode = data.get("orderCode").getAsLong();
                String status = data.get("status").getAsString();

                System.out.println("Webhook - OrderCode: " + orderCode + ", Status: " + status);

                // Tìm orderId từ orderCode trong session
                HttpSession session = req.getSession();
                String orderId = findOrderIdByOrderCode(session, orderCode);

                if (orderId != null && "PAID".equals(status)) {
                    System.out.println("Webhook: Processing PAID status for orderId: " + orderId);
                    
                    Optional<Order> orderOpt = orderDao.findById(orderId);
                    if (orderOpt.isPresent()) {
                        Order order = orderOpt.get();
                        
                        // Chỉ xử lý nếu order chưa được xử lý
                        if (order.isCart() || !"Paid".equals(order.getPaymentStatus())) {
                            // Checkout nếu vẫn là cart
                            if (order.isCart()) {
                                List<OrderItem> orderItems = cartDao.getCartItems(orderId);
                                if (!orderItems.isEmpty()) {
                                    OrderTotals finalTotals = calculateOrderTotals(orderItems, orderId);
                                    cartDao.checkoutCart(orderId, finalTotals.getTotal(), "Pending");
                                    
                                    // Reload order
                                    orderOpt = orderDao.findById(orderId);
                                    if (orderOpt.isPresent()) {
                                        order = orderOpt.get();
                                    }
                                }
                            }
                            
                            // Update payment status
                            if (!"Paid".equals(order.getPaymentStatus())) {
                                // Đơn từ public page sẽ ở status Pending, thu ngân sẽ xác nhận sau
                                order.setPaymentStatus("Paid");
                                order.setPayMethod("PayOS");
                                order.setStatus("Pending"); // Keep as Pending for cashier to confirm
                                order.setOrderType("Online");
                                orderDao.update(order);
                                System.out.println("Webhook: Updated order " + orderId + " to Pending status (Paid via PayOS, waiting for cashier confirmation)");
                            }
                        } else {
                            System.out.println("Webhook: Order " + orderId + " already processed");
                        }
                    } else {
                        System.err.println("Webhook: Order not found for orderId: " + orderId);
                    }
                } else if (orderId == null) {
                    System.err.println("Webhook: Could not find orderId for orderCode: " + orderCode);
                }

                // Luôn trả success cho PayOS (để PayOS không retry)
                Map<String, Object> response = new HashMap<>();
                response.put("success", true);
                response.put("message", "Webhook received and processed");
                resp.getWriter().write(gson.toJson(response));
            } else {
                System.err.println("Webhook: Invalid webhook data structure");
                resp.getWriter().write("{\"success\":false,\"message\":\"Invalid webhook data\"}");
            }

        } catch (Exception e) {
            System.err.println("Webhook error: " + e.getMessage());
            e.printStackTrace();
            // Vẫn trả success để PayOS không retry liên tục
            resp.getWriter().write("{\"success\":true,\"message\":\"Webhook received but error occurred: " + e.getMessage() + "\"}");
        }
    }

    /**
     * Tìm orderId từ orderCode trong session
     */
    private String findOrderIdByOrderCode(HttpSession session, long orderCode) {
        // Tìm trong tất cả session attributes
        java.util.Enumeration<String> attrNames = session.getAttributeNames();
        while (attrNames.hasMoreElements()) {
            String attrName = attrNames.nextElement();
            if (attrName.startsWith(SESSION_ORDER_CODE_PREFIX)) {
                Long storedOrderCode = (Long) session.getAttribute(attrName);
                if (storedOrderCode != null && storedOrderCode.equals(orderCode)) {
                    // Extract orderId from attribute name
                    String orderId = attrName.substring(SESSION_ORDER_CODE_PREFIX.length());
                    System.out.println("Found orderId " + orderId + " for orderCode " + orderCode);
                    return orderId;
                }
            }
        }
        return null;
    }

    // ==================== Helper Methods - Order Calculation ====================
    /**
     * Calculate order totals (subtotal, shipping, discount, total)
     */
    private OrderTotals calculateOrderTotals(List<OrderItem> cartItems, String orderId) {
        // Calculate subtotal
        BigDecimal subtotal = cartItems.stream()
                .map(OrderItem::getSubtotal)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        // Calculate shipping
        BigDecimal shipping = calculateShipping(subtotal);

        // Get discount from order
        BigDecimal discountAmount = getDiscountAmount(orderId);

        // Calculate total
        BigDecimal total = subtotal.add(shipping).subtract(discountAmount);

        return new OrderTotals(subtotal, shipping, discountAmount, total);
    }

    /**
     * Calculate shipping fee based on subtotal
     */
    private BigDecimal calculateShipping(BigDecimal subtotal) {
        if (subtotal.compareTo(new BigDecimal(FREE_SHIPPING_THRESHOLD)) > 0) {
            return BigDecimal.ZERO;
        }
        return SHIPPING_FEE;
    }

    /**
     * Get discount amount from order
     */
    private BigDecimal getDiscountAmount(String orderId) {
        Optional<Order> orderOpt = orderDao.findById(orderId);
        if (orderOpt.isPresent()) {
            Order order = orderOpt.get();
            return order.getDiscountAmount() != null ? order.getDiscountAmount() : BigDecimal.ZERO;
        }
        return BigDecimal.ZERO;
    }

    // ==================== Helper Methods - Payment Data Building ====================
    /**
     * Build PayOS PaymentData from cart and items
     */
    private PaymentData buildPaymentData(Order cart,
            List<OrderItem> cartItems,
            OrderTotals totals,
            HttpServletRequest req) {
        // Tạo orderCode duy nhất cho PayOS (KHÔNG dùng orderId trong DB)
        long orderCode = generateUniqueOrderCode();
        System.out.println("Generated PayOS orderCode = " + orderCode
                + " for orderId = " + cart.getOrderId());

        // Build items list for PayOS
        List<ItemData> itemsList = buildPayOSItems(cartItems, totals);

        // CRITICAL: Calculate amount from items list to ensure exact match
        // PayOS requires amount = sum of (price * quantity) for all items EXACTLY
        int calculatedAmount = itemsList.stream()
                .mapToInt(item -> item.getPrice() * item.getQuantity())
                .sum();

        System.out.println("=== PAYMENT DATA AMOUNT CALCULATION ===");
        System.out.println("Calculated from items: " + calculatedAmount);
        System.out.println("Totals final amount: " + totals.getFinalAmount().intValue());

        // Luôn dùng số tiền tính từ items để khớp với PayOS
        int paymentAmount = calculatedAmount;

        // Get URLs - Use request to get actual context path
        String baseUrl = PayOSConfig.getBaseUrl(req);
        String returnUrl = baseUrl + "/payment/success?orderId=" + cart.getOrderId();
        String cancelUrl = baseUrl + "/payment/cancel?orderId=" + cart.getOrderId();

        System.out.println("Return URL: " + returnUrl);
        System.out.println("Cancel URL: " + cancelUrl);

        // Create description
        String description = createDescription(cart.getOrderId());

        // Build payment data
        PaymentData paymentData = PaymentData.builder()
                .orderCode(orderCode)
                .amount(paymentAmount) // phải đúng = tổng items
                .description(description)
                .items(itemsList)
                .returnUrl(returnUrl)
                .cancelUrl(cancelUrl)
                .build();

        // Debug logging
        logPaymentData(paymentData, totals, itemsList.size());

        return paymentData;
    }

    /**
     * Build PayOS items list from cart items IMPORTANT: PayOS requires items
     * total to match amount exactly CRITICAL: Amount must equal sum of (price *
     * quantity) for all items
     */
    private List<ItemData> buildPayOSItems(List<OrderItem> cartItems, OrderTotals totals) {
        List<ItemData> itemsList = new java.util.ArrayList<>();
        BigDecimal itemsTotal = BigDecimal.ZERO;

        // Add product items
        for (OrderItem item : cartItems) {
            String productName = sanitizeProductName(item.getProductName(), item.getProductId());

            // CRITICAL: Use int values for PayOS (amounts in VND, no decimals)
            int itemPrice = item.getUnitPrice().intValue();
            int itemQuantity = item.getQuantity();

            // Validate price and quantity
            if (itemPrice <= 0 || itemQuantity <= 0) {
                System.err.println("WARNING: Invalid item price or quantity - Price: " + itemPrice + ", Quantity: " + itemQuantity);
                continue;
            }

            ItemData itemData = ItemData.builder()
                    .name(productName)
                    .quantity(itemQuantity)
                    .price(itemPrice)
                    .build();
            itemsList.add(itemData);

            // Calculate item total: price * quantity
            BigDecimal itemTotal = BigDecimal.valueOf(itemPrice).multiply(BigDecimal.valueOf(itemQuantity));
            itemsTotal = itemsTotal.add(itemTotal);

            System.out.println("Item: " + productName + " - Price: " + itemPrice + " x " + itemQuantity + " = " + itemTotal.intValue());
        }

        // Add shipping as separate item if shipping > 0
        if (totals.getShipping().compareTo(BigDecimal.ZERO) > 0) {
            int shippingAmount = totals.getShipping().intValue();
            ItemData shippingItem = ItemData.builder()
                    .name("Phí giao hàng")
                    .quantity(1)
                    .price(shippingAmount)
                    .build();
            itemsList.add(shippingItem);
            itemsTotal = itemsTotal.add(BigDecimal.valueOf(shippingAmount));
            System.out.println("Shipping: " + shippingAmount);
        }

        // CRITICAL: PayOS signature validation requires amount = items total EXACTLY
        // We cannot use discount in PayOS payment because:
        // 1. PayOS doesn't support negative prices
        // 2. Amount must equal sum of all items
        // Solution: amount = itemsTotal (subtotal + shipping)
        // Discount will be applied to order total in DB, not in PayOS payment
        // Ensure amount matches items total exactly (no rounding errors)
        int finalAmount = itemsTotal.intValue();
        totals.setFinalAmount(BigDecimal.valueOf(finalAmount));

        System.out.println("=== PAYOS ITEMS CALCULATION ===");
        System.out.println("Items Total: " + itemsTotal.intValue());
        System.out.println("Final Amount: " + finalAmount);
        System.out.println("Items Count: " + itemsList.size());
        System.out.println("Amount matches Items Total: " + (finalAmount == itemsTotal.intValue()));

        return itemsList;
    }

    /**
     * Sanitize product name for PayOS
     */
    private String sanitizeProductName(String productName, String productId) {
        if (productName == null || productName.trim().isEmpty()) {
            return "Sản phẩm " + productId;
        }
        if (productName.length() > MAX_PRODUCT_NAME_LENGTH) {
            return productName.substring(0, MAX_PRODUCT_NAME_LENGTH);
        }
        return productName;
    }

    /**
     * Create description for PayOS (max 25 characters)
     */
    private String createDescription(String orderId) {
        String description = "DH" + orderId;
        if (description.length() > MAX_DESCRIPTION_LENGTH) {
            description = description.substring(0, MAX_DESCRIPTION_LENGTH);
        }
        return description;
    }


    /**
     * Tạo orderCode duy nhất dạng số cho PayOS.
     * Không dùng orderId trong DB để tránh trùng giữa các lần thanh toán.
     * Sử dụng timestamp + random để đảm bảo unique
     */
    private long generateUniqueOrderCode() {
        long timestamp = System.currentTimeMillis(); // 13 chữ số
        int random = (int)(Math.random() * 1000); // 0-999
        long code = timestamp * 1000L + random; // 16 chữ số
        System.out.println("Generated unique orderCode for PayOS = " + code);
        return code;
    }


    // ==================== Helper Methods - Order Management ====================
    /**
     * Update order payment status
     */
    private void updateOrderPaymentStatus(Order order, String status, String paymentStatus, String payMethod) {
        order.setStatus(status);
        order.setPaymentStatus(paymentStatus);
        order.setPayMethod(payMethod);
        orderDao.update(order);
        System.out.println("Order updated to " + status + "/" + paymentStatus);
    }

    /**
     * Create new cart for authenticated user
     */
    private void createNewCartForUser(HttpServletRequest req) {
        HttpSession session = req.getSession();
        UserDto authUser = (UserDto) session.getAttribute("authUser");
        if (authUser == null) {
            authUser = (UserDto) session.getAttribute("loggedUser");
        }

        if (authUser != null) {
            int userId = Integer.parseInt(authUser.getUserId());
            cartDao.findOrCreateCart(userId);
            System.out.println("Created new cart for user: " + userId);
        } else {
            System.err.println("WARNING: No user in session!");
        }
    }

    /**
     * Handle payment status from PayOS
     */
    private void handlePaymentStatus(String orderId, String status, HttpSession session, HttpServletResponse resp)
            throws IOException {

        if ("PAID".equals(status)) {
            System.out.println("Payment verification: Status is PAID for orderId: " + orderId);

            Optional<Order> orderOpt = orderDao.findById(orderId);
            if (!orderOpt.isPresent()) {
                System.err.println("ERROR: Order not found in database: " + orderId);
                sendErrorResponse(resp, "Order not found");
                return;
            }

            Order order = orderOpt.get();
            System.out.println("Found order: " + order.getOrderId());
            System.out.println("Current status: " + order.getStatus());
            System.out.println("Current payment status: " + order.getPaymentStatus());
            System.out.println("Is cart: " + order.isCart());

            // Kiểm tra xem đã được xử lý chưa (Pending, Processing hoặc Completed đều được coi là đã xử lý)
            if (!order.isCart() && ("Pending".equals(order.getStatus()) || "Processing".equals(order.getStatus()) || "Completed".equals(order.getStatus())) && "Paid".equals(order.getPaymentStatus())) {
                System.out.println("Order already processed. Returning success.");
                sendSuccessResponse(resp, "PAID", "Payment already verified");
                return;
            }

            // If order is still a cart, checkout first
            if (order.isCart()) {
                List<OrderItem> orderItems = cartDao.getCartItems(orderId);
                if (orderItems.isEmpty()) {
                    System.err.println("ERROR: Cart items not found for order: " + orderId);
                    sendErrorResponse(resp, "Cart items not found");
                    return;
                }

                OrderTotals finalTotals = calculateOrderTotals(orderItems, orderId);

                if (!cartDao.checkoutCart(orderId, finalTotals.getTotal(), "Pending")) {
                    System.err.println("ERROR: Failed to checkout cart for order: " + orderId);
                    sendErrorResponse(resp, "Failed to checkout cart");
                    return;
                }

                // Reload order after checkout
                orderOpt = orderDao.findById(orderId);
                if (orderOpt.isPresent()) {
                    order = orderOpt.get();
                    // Mark as online order
                    order.setOrderType("Online");
                    orderDao.update(order);
                } else {
                    System.err.println("ERROR: Failed to reload order after checkout: " + orderId);
                    sendErrorResponse(resp, "Failed to reload order");
                    return;
                }
            }

            // Update payment status (chỉ nếu chưa được cập nhật)
            // Đơn từ public page sẽ ở status Pending, thu ngân sẽ xác nhận sau
            if (!"Paid".equals(order.getPaymentStatus()) || !"PayOS".equals(order.getPayMethod())) {
                // Keep status as Pending, only update payment status to Paid and method to PayOS
                order.setPaymentStatus("Paid");
                order.setPayMethod("PayOS");
                order.setStatus("Pending"); // Keep as Pending for cashier to confirm
                orderDao.update(order);
            }

            // Create new cart for user
            createNewCartForUserFromSession(session);

            session.setAttribute("paymentSuccess", true);
            session.setAttribute("successMessage", "Thanh toán thành công! Đơn hàng #" + orderId);

            sendSuccessResponse(resp, "PAID", "Payment verified successfully");
        } else if ("CANCELLED".equals(status)) {
            System.out.println("Payment verification: Status is CANCELLED for orderId: " + orderId);
            sendStatusResponse(resp, false, "CANCELLED", "Payment was cancelled");
        } else {
            System.out.println("Payment verification: Status is " + status + " for orderId: " + orderId);
            sendStatusResponse(resp, false, status, "Payment is " + status);
        }
    }

    /**
     * Create new cart for user from session
     */
    private void createNewCartForUserFromSession(HttpSession session) {
        UserDto authUser = (UserDto) session.getAttribute("authUser");
        if (authUser == null) {
            authUser = (UserDto) session.getAttribute("loggedUser");
        }

        if (authUser != null) {
            int userId = Integer.parseInt(authUser.getUserId());
            cartDao.findOrCreateCart(userId);
            System.out.println("Created new cart for user: " + userId);
        } else {
            System.err.println("WARNING: No user found in session!");
        }
    }

    // ==================== Helper Methods - Response Handling ====================
    /**
     * Set JSON response headers
     */
    private void setJsonResponse(HttpServletResponse resp) {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
    }

    /**
     * Send error response
     */
    private void sendErrorResponse(HttpServletResponse resp, String message) throws IOException {
        Map<String, Object> errorResponse = new HashMap<>();
        errorResponse.put("success", false);
        errorResponse.put("message", message);
        resp.getWriter().write(gson.toJson(errorResponse));
    }

    /**
     * Send success response
     */
    private void sendSuccessResponse(HttpServletResponse resp, String status, String message) throws IOException {
        Map<String, Object> successResponse = new HashMap<>();
        successResponse.put("success", true);
        successResponse.put("status", status);
        successResponse.put("message", message);
        resp.getWriter().write(gson.toJson(successResponse));
    }

    /**
     * Send status response
     */
    private void sendStatusResponse(HttpServletResponse resp, boolean success, String status, String message)
            throws IOException {
        Map<String, Object> response = new HashMap<>();
        response.put("success", success);
        response.put("status", status);
        response.put("message", message);
        resp.getWriter().write(gson.toJson(response));
    }

    /**
     * Send 404 Not Found
     */
    private void sendNotFound(HttpServletResponse resp) throws IOException {
        resp.sendError(HttpServletResponse.SC_NOT_FOUND);
    }

    /**
     * Redirect to cart
     */
    private void redirectToCart(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.sendRedirect(req.getContextPath() + "/home/cart");
    }

    /**
     * Handle exception
     */
    private void handleException(Exception e, HttpServletResponse resp, String context) throws IOException {
        e.printStackTrace();
        sendErrorResponse(resp, context + ": " + e.getMessage());
    }

    // ==================== Helper Methods - Request Handling ====================
    /**
     * Get authenticated user from session
     */
    private UserDto getAuthenticatedUser(HttpServletRequest req) {
        HttpSession session = req.getSession();
        return (UserDto) session.getAttribute("authUser");
    }

    /**
     * Read request body as string
     */
    private String readRequestBody(HttpServletRequest req) throws IOException {
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = req.getReader().readLine()) != null) {
            sb.append(line);
        }
        return sb.toString();
    }

    // ==================== Helper Methods - Logging ====================
    /**
     * Log order calculation details
     */
    private void logOrderCalculation(String orderId, OrderTotals totals) {
        System.out.println("Creating payment link for order: " + orderId);
        System.out.println("Subtotal: " + totals.getSubtotal());
        System.out.println("Shipping: " + totals.getShipping());
        System.out.println("Discount: " + totals.getDiscount());
        System.out.println("Total: " + totals.getTotal());
    }

    /**
     * Log payment data for debugging
     */
    private void logPaymentData(PaymentData paymentData, OrderTotals totals, int itemsCount) {
        System.out.println("PayOS Request Data:");
        System.out.println("OrderCode: " + paymentData.getOrderCode());
        System.out.println("Amount: " + paymentData.getAmount());
        System.out.println("Items Total: " + totals.getFinalAmount().intValue());
        System.out.println("Shipping: " + totals.getShipping().intValue());
        System.out.println("Discount: " + totals.getDiscount().intValue());
        System.out.println("Items count: " + itemsCount);
        System.out.println(gson.toJson(paymentData));
    }

    // ==================== Inner Classes ====================
    /**
     * Data class to hold order totals
     */
    private static class OrderTotals {

        private final BigDecimal subtotal;
        private final BigDecimal shipping;
        private final BigDecimal discount;
        private final BigDecimal total;
        private BigDecimal finalAmount; // Amount that matches items total for PayOS

        public OrderTotals(BigDecimal subtotal, BigDecimal shipping, BigDecimal discount, BigDecimal total) {
            this.subtotal = subtotal;
            this.shipping = shipping;
            this.discount = discount;
            this.total = total;
            this.finalAmount = total;
        }

        public BigDecimal getSubtotal() {
            return subtotal;
        }

        public BigDecimal getShipping() {
            return shipping;
        }

        public BigDecimal getDiscount() {
            return discount;
        }

        public BigDecimal getTotal() {
            return total;
        }

        public BigDecimal getFinalAmount() {
            return finalAmount;
        }

        public void setFinalAmount(BigDecimal finalAmount) {
            this.finalAmount = finalAmount;
        }
    }
}
