package controller;

import dao.CartDao;
import dao.CartDaoJdbc;
import dao.OrderDao;
import dao.OrderDaoJdbc;
import dao.ProductDao;
import dao.ProductDaoJdbc;
import dao.PromotionDao;
import dao.PromotionDaoJdbc;
import dao.DBConnect;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Order;
import model.OrderItem;
import model.ProductDto;
import model.UserDto;
import model.Promotion;
import service.PromotionService;
import service.PromotionServiceImpl;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@MultipartConfig
public class CartControllerServlet extends HttpServlet {

    private CartDao cartDao;
    private ProductDao productDao;

    @Override
    public void init() throws ServletException {
        cartDao = new CartDaoJdbc();
        productDao = new ProductDaoJdbc();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String pathInfo = req.getPathInfo();

        // Check if user is logged in
        HttpSession session = req.getSession();
        UserDto authUser = (UserDto) session.getAttribute("authUser");

        if (authUser == null) {
            // Redirect to login if not authenticated
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        // Get user ID
        int userId = Integer.parseInt(authUser.getUserId());

        // Handle different actions
        if (pathInfo == null || "/".equals(pathInfo)) {
            // View cart
            viewCart(req, resp, userId);
        } else if ("/checkout".equals(pathInfo)) {
            // Checkout page
            showCheckout(req, resp, userId);
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void viewCart(HttpServletRequest req, HttpServletResponse resp, int userId)
            throws ServletException, IOException {

        // Get or create cart for user
        Order cart = cartDao.findOrCreateCart(userId);

        // Get cart items
        List<OrderItem> cartItems = cartDao.getCartItems(cart.getOrderId());

        // Calculate totals
        BigDecimal subtotal = cartItems.stream()
                .map(OrderItem::getSubtotal)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        BigDecimal shipping = subtotal.compareTo(new BigDecimal("500000")) > 0
                ? BigDecimal.ZERO
                : new BigDecimal("30000");

        BigDecimal total = subtotal.add(shipping);

        // Set attributes for JSP
        req.setAttribute("cart", cart);
        req.setAttribute("cartItems", cartItems);
        req.setAttribute("subtotal", subtotal);
        req.setAttribute("shipping", shipping);
        req.setAttribute("total", total);

        // Forward to cart JSP
        req.getRequestDispatcher("/WEB-INF/view/home/cart.jsp").forward(req, resp);
    }

    private void showCheckout(HttpServletRequest req, HttpServletResponse resp, int userId)
            throws ServletException, IOException {

        // Get cart
        Order cart = cartDao.findOrCreateCart(userId);
        List<OrderItem> cartItems = cartDao.getCartItems(cart.getOrderId());

        if (cartItems.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/home/cart");
            return;
        }

        // Calculate totals
        BigDecimal subtotal = cartItems.stream()
                .map(OrderItem::getSubtotal)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        BigDecimal shipping = subtotal.compareTo(new BigDecimal("500000")) > 0
                ? BigDecimal.ZERO
                : new BigDecimal("30000");

        BigDecimal discountAmount = cart.getDiscountAmount() != null ? cart.getDiscountAmount() : BigDecimal.ZERO;
        BigDecimal total = subtotal.add(shipping).subtract(discountAmount);

        // Get user info for form pre-fill
        HttpSession session = req.getSession();
        UserDto authUser = (UserDto) session.getAttribute("authUser");
        
        // Get user full name from UserDto (already in session)
        String fullName = authUser != null ? authUser.getFullName() : "";
        
        // Get existing order info if available
        String shippingAddress = cart.getShippingAddress() != null ? cart.getShippingAddress() : "";
        String phoneContact = cart.getPhoneContact() != null ? cart.getPhoneContact() : "";

        // Set attributes
        req.setAttribute("cart", cart);
        req.setAttribute("cartItems", cartItems);
        req.setAttribute("subtotal", subtotal);
        req.setAttribute("shipping", shipping);
        req.setAttribute("discountAmount", discountAmount);
        req.setAttribute("total", total);
        req.setAttribute("fullName", fullName);
        req.setAttribute("shippingAddress", shippingAddress);
        req.setAttribute("phoneContact", phoneContact);
        req.setAttribute("promotionCode", cart.getPromotionId() != null ? cart.getPromotionId() : "");

        // Forward to checkout page
        req.getRequestDispatcher("/WEB-INF/view/home/checkout.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String pathInfo = req.getPathInfo();
        String action = req.getParameter("action");

        // Check if user is logged in
        HttpSession session = req.getSession();
        UserDto authUser = (UserDto) session.getAttribute("authUser");

        if (authUser == null) {
            if ("XMLHttpRequest".equals(req.getHeader("X-Requested-With"))) {
                resp.setContentType("application/json");
                resp.setCharacterEncoding("UTF-8");
                resp.getWriter().write("{\"success\": false, \"message\": \"Bạn cần đăng nhập để tiếp tục.\"}");
            } else {
                resp.sendRedirect(req.getContextPath() + "/auth/login");
            }
            return;
        }

        int userId = Integer.parseInt(authUser.getUserId());
        Order cart = cartDao.findOrCreateCart(userId);

        try {
            // Handle checkout form submission (from /checkout path)
            if ("/checkout".equals(pathInfo)) {
                if ("save-info".equals(action)) {
                    handleSaveCheckoutInfo(req, resp, cart);
                    return;
                } else {
                    // Regular form submission - save info and proceed
                    handleSaveCheckoutInfo(req, resp, cart);
                    // Then handle checkout based on payment method
                    String paymentMethod = req.getParameter("paymentMethod");
                    if ("Cash".equals(paymentMethod)) {
                        handleCheckout(req, resp, cart, userId);
                    } else {
                        // PayOS will be handled by frontend
                        resp.setStatus(HttpServletResponse.SC_OK);
                    }
                    return;
                }
            }
            
            // Handle apply promotion code
            if ("/apply-promo".equals(pathInfo)) {
                handleApplyPromotion(req, resp, cart);
                return;
            }

            if ("add".equals(action)) {
                // Add item to cart
                handleAddToCart(req, resp, cart);

            } else if ("update".equals(action)) {
                // Update item quantity
                handleUpdateQuantity(req, resp, cart);

            } else if ("remove".equals(action)) {
                // Remove item from cart
                handleRemoveItem(req, resp, cart);

            } else if ("checkout".equals(action)) {
                // Checkout cart
                handleCheckout(req, resp, cart, userId);

            } else {
                if ("XMLHttpRequest".equals(req.getHeader("X-Requested-With"))) {
                    resp.setContentType("application/json");
                    resp.setCharacterEncoding("UTF-8");
                    resp.getWriter().write("{\"success\": false, \"message\": \"Invalid action\"}");
                } else {
                    resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
                }
            }
        } catch (Exception e) {
            System.err.println("Error in cart operation: " + e.getMessage());
            e.printStackTrace();

            if ("XMLHttpRequest".equals(req.getHeader("X-Requested-With"))) {
                resp.setContentType("application/json");
                resp.setCharacterEncoding("UTF-8");
                resp.getWriter().write("{\"success\": false, \"message\": \"Server error\"}");
            } else {
                resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }
        }
    }

    private void handleAddToCart(HttpServletRequest req, HttpServletResponse resp, Order cart)
            throws IOException {

        String productId = req.getParameter("productId");
        String quantityStr = req.getParameter("quantity");

        // Validate input
        if (productId == null || productId.trim().isEmpty()) {
            if ("XMLHttpRequest".equals(req.getHeader("X-Requested-With"))) {
                resp.setContentType("application/json");
                resp.setCharacterEncoding("UTF-8");
                resp.getWriter().write("{\"success\": false, \"message\": \"Product ID is required\"}");
            } else {
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Product ID is required");
            }
            return;
        }

        if (quantityStr == null || quantityStr.trim().isEmpty()) {
            if ("XMLHttpRequest".equals(req.getHeader("X-Requested-With"))) {
                resp.setContentType("application/json");
                resp.setCharacterEncoding("UTF-8");
                resp.getWriter().write("{\"success\": false, \"message\": \"Quantity is required\"}");
            } else {
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Quantity is required");
            }
            return;
        }

        int quantity;
        try {
            quantity = Integer.parseInt(quantityStr);
            if (quantity <= 0) {
                throw new NumberFormatException("Quantity must be positive");
            }
        } catch (NumberFormatException e) {
            if ("XMLHttpRequest".equals(req.getHeader("X-Requested-With"))) {
                resp.setContentType("application/json");
                resp.setCharacterEncoding("UTF-8");
                resp.getWriter().write("{\"success\": false, \"message\": \"Invalid quantity\"}");
            } else {
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid quantity");
            }
            return;
        }

        // Stock guard: always load product details to reference inventory info
        ProductDto product = productDao.findById(productId);
        if (product == null) {
            if ("XMLHttpRequest".equals(req.getHeader("X-Requested-With"))) {
                resp.setContentType("application/json");
                resp.setCharacterEncoding("UTF-8");
                resp.getWriter().write("{\"success\": false, \"message\": \"Product not found\"}");
            } else {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Product not found");
            }
            return;
        }

        // Stock guard: prevent cart quantity from exceeding warehouse stock
        //thong bao het hang
        List<OrderItem> existingItems = cartDao.getCartItems(cart.getOrderId());
        int existingQuantity = existingItems.stream()
                .filter(it -> productId.equals(it.getProductId()))
                .mapToInt(OrderItem::getQuantity)
                .findFirst()
                .orElse(0);
        int requestedTotal = existingQuantity + quantity;
        if (requestedTotal > product.getStock_quantity()) {
            int available = Math.max(product.getStock_quantity() - existingQuantity, 0);
            String message = available > 0
                    ? "Chỉ còn " + available + " sản phẩm trong kho."
                    : "Sản phẩm đã hết trong kho.";

            if ("XMLHttpRequest".equals(req.getHeader("X-Requested-With"))) {
                resp.setContentType("application/json");
                resp.setCharacterEncoding("UTF-8");
                resp.getWriter().write("{\"success\": false, \"message\": \"" + message + "\"}");
            } else {
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST, message);
            }
            return;
        }

        // Create order item
        OrderItem item = new OrderItem();
        item.setOrderId(cart.getOrderId());
        item.setProductId(productId);
        item.setQuantity(quantity);
        item.setUnitPrice(product.getPrice());
        item.setSubtotal(product.getPrice().multiply(BigDecimal.valueOf(quantity)));

        // Add to cart
        boolean success = cartDao.addItemToCart(item);

        // For AJAX requests
        if ("XMLHttpRequest".equals(req.getHeader("X-Requested-With"))) {
            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");

            List<OrderItem> cartItems = cartDao.getCartItems(cart.getOrderId());
            int cartCount = cartItems.stream().mapToInt(OrderItem::getQuantity).sum();

            if (success) {
                // Success message
                String successMessage = "Thêm vào giỏ hàng thành công";
                resp.getWriter().write("{\"success\": true, \"message\": \"" + successMessage + "\", \"cartCount\": " + cartCount + "}");
            } else {
                resp.getWriter().write("{\"success\": false, \"message\": \"Không thể thêm sản phẩm vào giỏ hàng!\"}");
            }
            return;
        }

        // Redirect back to previous page or cart
        String referer = req.getHeader("Referer");
        if (referer != null && !referer.isEmpty()) {
            resp.sendRedirect(referer);
        } else {
            resp.sendRedirect(req.getContextPath() + "/home/cart");
        }
    }

    private void handleUpdateQuantity(HttpServletRequest req, HttpServletResponse resp, Order cart)
            throws IOException {

        String productId = req.getParameter("productId");
        String quantityStr = req.getParameter("quantity");
        int quantity;

        try {
            quantity = Integer.parseInt(quantityStr);
        } catch (NumberFormatException ex) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid quantity");
            return;
        }

        if (quantity <= 0) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Quantity must be positive");
            return;
        }

        // Stock guard: validate requested quantity against warehouse availability
        ProductDto product = productDao.findById(productId);
        if (product == null) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Product not found");
            return;
        }

        if (quantity > product.getStock_quantity()) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST,
                    "Chi co " + product.getStock_quantity() + " san pham trong kho.");
            return;
        }

        cartDao.updateItemQuantity(cart.getOrderId(), productId, quantity);

        resp.sendRedirect(req.getContextPath() + "/home/cart");
    }

    private void handleRemoveItem(HttpServletRequest req, HttpServletResponse resp, Order cart)
            throws IOException {

        String productId = req.getParameter("productId");

        cartDao.removeItemFromCart(cart.getOrderId(), productId);

        resp.sendRedirect(req.getContextPath() + "/home/cart");
    }

    private void handleCheckout(HttpServletRequest req, HttpServletResponse resp, Order cart, int userId)
            throws IOException {

        // Get cart items
        List<OrderItem> cartItems = cartDao.getCartItems(cart.getOrderId());

        if (cartItems.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/home/cart");
            return;
        }

        // Calculate total
        BigDecimal subtotal = cartItems.stream()
                .map(OrderItem::getSubtotal)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        BigDecimal shipping = subtotal.compareTo(new BigDecimal("500000")) > 0
                ? BigDecimal.ZERO
                : new BigDecimal("30000");

        BigDecimal discountAmount = cart.getDiscountAmount() != null ? cart.getDiscountAmount() : BigDecimal.ZERO;
        BigDecimal total = subtotal.add(shipping).subtract(discountAmount);

        // Get payment method
        String paymentMethod = req.getParameter("paymentMethod");
        if (paymentMethod == null) {
            paymentMethod = "Cash"; // Default
        }
        
        // Normalize payment method: COD should be saved as "Cash"
        if ("COD".equalsIgnoreCase(paymentMethod)) {
            paymentMethod = "Cash";
        }

        // Reload order to ensure we have latest data (including shipping address and phone)
        OrderDao orderDao = new OrderDaoJdbc();
        Optional<Order> orderOpt = orderDao.findById(cart.getOrderId());
        if (!orderOpt.isPresent()) {
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Order not found");
            return;
        }
        
        Order order = orderOpt.get();
        
        // Update order with payment method and totals BEFORE checkout
        // Ensure payment method is correctly set before converting cart to order
        order.setPayMethod(paymentMethod);
        order.setTotalAmount(total);
        order.setPaymentAmount(total);
        // Mark as online order (has shipping address/phone)
        order.setOrderType("Online");
        // Also ensure shipping address and phone are preserved
        if (order.getShippingAddress() == null) {
            order.setShippingAddress(cart.getShippingAddress());
        }
        if (order.getPhoneContact() == null) {
            order.setPhoneContact(cart.getPhoneContact());
        }
        orderDao.update(order);

        // Checkout cart (convert to order) - This sets is_cart = FALSE
        // For online orders, start with Pending status (not Processing)
        boolean success = cartDao.checkoutCart(cart.getOrderId(), total, "Pending");

        if (success) {
            // Reload order after checkout to ensure we have latest data
            orderOpt = orderDao.findById(cart.getOrderId());
            if (orderOpt.isPresent()) {
                order = orderOpt.get();
                
                // CRITICAL: Must set payment method again after checkoutCart() because 
                // checkoutCart() doesn't preserve payment method
                order.setPayMethod(paymentMethod);
                
                // For online orders: Start with Pending status (cashier will confirm later)
                // Payment status depends on payment method
                if ("Cash".equalsIgnoreCase(paymentMethod)) {
                    order.setStatus("Pending"); // Changed from Processing to Pending
                    order.setPaymentStatus("Pending");
                } else if ("PayOS".equalsIgnoreCase(paymentMethod)) {
                    order.setStatus("Pending"); // Will be updated to Processing after payment
                    order.setPaymentStatus("Pending");
                }
                
                // Update with payment method and status
                orderDao.update(order);
                
                // Create new cart for user
                cartDao.findOrCreateCart(userId);
                
                // Redirect to payment success page for both Cash and PayOS (status is Pending for both)
                resp.sendRedirect(req.getContextPath() + "/payment/success?orderId=" + cart.getOrderId());
                return;
            }
        } else {
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Checkout failed");
        }
    }

    /**
     * Save checkout information (name, address, phone) to order
     */
    private void handleSaveCheckoutInfo(HttpServletRequest req, HttpServletResponse resp, Order cart)
            throws IOException {
        
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        try {
            String fullName = req.getParameter("fullName");
            String phoneContact = req.getParameter("phoneContact");
            String shippingAddress = req.getParameter("shippingAddress");
            String paymentMethod = req.getParameter("paymentMethod");

            // Validate required fields
            if (fullName == null || fullName.trim().isEmpty() ||
                phoneContact == null || phoneContact.trim().isEmpty() ||
                shippingAddress == null || shippingAddress.trim().isEmpty()) {
                resp.getWriter().write("{\"success\": false, \"message\": \"Vui lòng điền đầy đủ thông tin\"}");
                return;
            }

            // Get note
            String note = req.getParameter("note");
            
            // Update order with customer info
            OrderDao orderDao = new OrderDaoJdbc();
            Optional<Order> orderOpt = orderDao.findById(cart.getOrderId());
            
            if (orderOpt.isPresent()) {
                Order order = orderOpt.get();
                order.setShippingAddress(shippingAddress.trim());
                order.setPhoneContact(phoneContact.trim());
                if (note != null) {
                    order.setNote(note.trim());
                }
                if (paymentMethod != null) {
                    order.setPayMethod(paymentMethod);
                }
                orderDao.update(order);
                
                resp.getWriter().write("{\"success\": true, \"message\": \"Đã lưu thông tin\"}");
            } else {
                resp.getWriter().write("{\"success\": false, \"message\": \"Không tìm thấy đơn hàng\"}");
            }

        } catch (Exception e) {
            e.printStackTrace();
            resp.getWriter().write("{\"success\": false, \"message\": \"Lỗi khi lưu thông tin: " + e.getMessage() + "\"}");
        }
    }

    /**
     * Apply promotion code to cart
     */
    private void handleApplyPromotion(HttpServletRequest req, HttpServletResponse resp, Order cart)
            throws IOException {
        
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        try {
            String promotionCode = req.getParameter("promotionCode");
            
            if (promotionCode == null || promotionCode.trim().isEmpty()) {
                resp.getWriter().write("{\"success\": false, \"message\": \"Vui lòng nhập mã khuyến mãi\"}");
                return;
            }

            promotionCode = promotionCode.trim().toUpperCase();

            // Get promotion from database
            DBConnect db = new DBConnect();
            PromotionDao promotionDao = new PromotionDaoJdbc(db.getConnection());
            Optional<Promotion> promoOpt = promotionDao.findByCode(promotionCode);

            if (promoOpt.isEmpty()) {
                resp.getWriter().write("{\"success\": false, \"message\": \"Mã khuyến mãi không tồn tại\"}");
                db.close();
                return;
            }

            Promotion promotion = promoOpt.get();

            // Check if promotion is active
            if (!"Activate".equalsIgnoreCase(promotion.getStatus()) && !"ACTIVE".equalsIgnoreCase(promotion.getStatus())) {
                resp.getWriter().write("{\"success\": false, \"message\": \"Mã khuyến mãi đã hết hạn\"}");
                db.close();
                return;
            }

            // Check date validity
            LocalDate now = LocalDate.now();
            LocalDate startDate = promotion.getStartDate();
            LocalDate endDate = promotion.getEndDate();
            
            if (now.isBefore(startDate) || now.isAfter(endDate)) {
                resp.getWriter().write("{\"success\": false, \"message\": \"Mã khuyến mãi đã hết hạn\"}");
                db.close();
                return;
            }

            // Get cart items to calculate subtotal
            List<OrderItem> cartItems = cartDao.getCartItems(cart.getOrderId());
            BigDecimal subtotal = cartItems.stream()
                    .map(OrderItem::getSubtotal)
                    .reduce(BigDecimal.ZERO, BigDecimal::add);

            // Calculate shipping
            BigDecimal shipping = subtotal.compareTo(new BigDecimal("500000")) > 0
                    ? BigDecimal.ZERO
                    : new BigDecimal("30000");
            
            // Total before discount (subtotal + shipping)
            BigDecimal totalBeforeDiscount = subtotal.add(shipping);

            // Check minimum order value (check against subtotal + shipping)
            if (promotion.getMinOrderValue() != null && 
                totalBeforeDiscount.compareTo(promotion.getMinOrderValue()) < 0) {
                resp.getWriter().write("{\"success\": false, \"message\": \"Đơn hàng tối thiểu " + 
                    promotion.getMinOrderValue() + "₫ để áp dụng mã này\"}");
                db.close();
                return;
            }

            // Apply promotion - calculate discount based on subtotal (not including shipping)
            PromotionService promotionService = new PromotionServiceImpl(promotionDao);
            BigDecimal discountAmount = BigDecimal.ZERO;

            if ("fixed_amount".equalsIgnoreCase(promotion.getType())) {
                // Fixed amount: discount is the promotion value, but not more than subtotal
                discountAmount = promotion.getValue().min(subtotal);
                promotionService.useFixedPromotion(promotion, cart);
            } else if ("percentage".equalsIgnoreCase(promotion.getType())) {
                // Percentage: discount is percentage of subtotal
                discountAmount = subtotal.multiply(promotion.getValue())
                        .divide(BigDecimal.valueOf(100), 2, java.math.RoundingMode.HALF_UP);
                promotionService.usePercentPromotion(promotion, cart);
            }

            // Update order with promotion
            OrderDao orderDao = new OrderDaoJdbc();
            Optional<Order> orderOpt = orderDao.findById(cart.getOrderId());
            if (orderOpt.isPresent()) {
                Order order = orderOpt.get();
                order.setPromotionId(promotion.getPromotionId());
                order.setDiscountAmount(discountAmount);
                orderDao.update(order);
            }

            db.close();

            // Format discount amount for response
            String discountFormatted = String.format("%.0f", discountAmount.doubleValue());
            resp.getWriter().write("{\"success\": true, \"message\": \"Áp dụng mã khuyến mãi thành công! Giảm " + 
                discountFormatted + "₫\", \"discountAmount\": " + discountAmount + "}");

        } catch (Exception e) {
            e.printStackTrace();
            resp.getWriter().write("{\"success\": false, \"message\": \"Lỗi khi áp dụng mã khuyến mãi: " + e.getMessage() + "\"}");
        }
    }
}
