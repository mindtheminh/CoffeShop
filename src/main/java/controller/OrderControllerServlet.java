package controller;

import dao.DBConnect;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import dao.OrderDao;
import dao.OrderDaoJdbc;
import dao.OrderItemDao;
import dao.ProductDaoJdbc;
import dao.UserDao;
import dao.UserDaoJdbc;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.time.LocalDate;
import java.time.OffsetDateTime;
import java.time.ZoneId;
import java.util.Comparator;
import model.Order;
import model.OrderDto;
import model.OrderItem;
import model.OrderMapper;
import model.ProductDto;
import model.User;
import model.UserDto;
import service.OrderService;
import service.OrderServiceImpl;
import dao.ProductDao;
import dao.ProductDaoJdbc;
import dao.PromotionDao;
import dao.PromotionDaoJdbc;
import java.math.BigDecimal;
import java.util.Optional;
import model.Promotion;
import model.PromotionDto;
import service.PromotionService;
import service.PromotionServiceImpl;

/**
 * OrderControllerServlet - Controller for Order management
 *
 * @author Asus
 */
public class OrderControllerServlet extends HttpServlet {

    private OrderService orderService;
    private OrderDaoJdbc orderDao = new OrderDaoJdbc();
    private PromotionDaoJdbc promotionDao;

    @Override
    public void init() throws ServletException {

        super.init();
        try {
            orderService = new OrderServiceImpl();
            System.out.println("OrderControllerServlet initialized successfully");
        } catch (Exception e) {
            System.err.println("Error initializing OrderControllerServlet: " + e.getMessage());
            e.printStackTrace();
        }
        DBConnect db = new DBConnect();
        promotionDao = new PromotionDaoJdbc(db.getConnection());
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getRequestURI().substring(req.getContextPath().length());

        System.out.println("OrderControllerServlet GET: " + path);

        switch (path) {
            case "/orders":
                handleList(req, resp);
                break;
            case "/order-details":
                handleDetail(req, resp);
                break;
            case "/checkout":
                handleCheckout(req, resp);
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/orders");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getRequestURI().substring(req.getContextPath().length());

        System.out.println("OrderControllerServlet POST: " + path);

        switch (path) {
            case "/checkout":
                handleCreate(req, resp);
                break;
            case "/editOrder":
                handleEdit(req, resp);
                break;
            case "/orders/confirm":
                handleConfirm(req, resp);
                break;
            case "/orders/accept":
                handleAccept(req, resp);
                break;
            case "/invoice":
                handleInvoice(req, resp);
                break;
            case "/cancelledOrder":
                handleCancelled(req, resp);
                break;
            case "/orderItem-delete":
                handleDeleted(req, resp);
                break;
            case "/applyDiscount":
                handlePromotion(req, resp);
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/orders");
                break;
        }
    }

    // [GET] Show order list
    private void handleList(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            // --- Lấy tất cả đơn hàng ---
            List<OrderDto> orders = orderDao.getAllOrders();

            // --- Lấy tham số trạng thái và ngày ---
            String status = req.getParameter("status");
            String filterDateStr = req.getParameter("filterDate");

            // --- Filter theo trạng thái nếu có ---
            if (status != null && !status.isEmpty()) {
                orders = orderService.getOrdersByStatus(orders, status);
            }

            // --- Filter theo ngày nếu có ---
            if (filterDateStr != null && !filterDateStr.isEmpty()) {
                LocalDate filterDate = LocalDate.parse(filterDateStr);
                ZoneId systemZone = ZoneId.systemDefault();
                OffsetDateTime startOfFilter = filterDate.atStartOfDay(systemZone).toOffsetDateTime();
                OffsetDateTime endOfFilter = filterDate.plusDays(1).atStartOfDay(systemZone).toOffsetDateTime();

                List<OrderDto> ordersByDate = new ArrayList<>();
                for (OrderDto o : orders) {
                    if (o.getCreatedAt() != null
                            && !o.getCreatedAt().isBefore(startOfFilter)
                            && o.getCreatedAt().isBefore(endOfFilter)) {
                        ordersByDate.add(o);
                    }
                }
                orders = ordersByDate;
            }

            // --- Sắp xếp giảm dần theo thời gian ---
            orders.sort(Comparator.comparing(OrderDto::getCreatedAt).reversed());

            // --- Đếm các loại đơn ---
            List<OrderDto> orderCompleted = orderService.getOrdersByStatus(orders, "Completed");
            List<OrderDto> orderPending = orderService.getOrdersByStatus(orders, "Pending");
            List<OrderDto> orderProcessing = orderService.getOrdersByStatus(orders, "Processing");
            List<OrderDto> orderCancelled = orderService.getOrdersByStatus(orders, "Cancelled");

            int orderCountCompleted = (orderCompleted != null) ? orderCompleted.size() : 0;
            int orderCountPending = (orderPending != null) ? orderPending.size() : 0;
            int orderCountProcessing = (orderProcessing != null) ? orderProcessing.size() : 0;
            int orderCountCancelled = (orderCancelled != null) ? orderCancelled.size() : 0;
            int orderCount = (orders != null) ? orders.size() : 0;

            // --- Phân trang ---
            int pageSize = 15;
            String pageParam = req.getParameter("page");
            int currentPage = 1;
            if (pageParam != null) {
                try {
                    currentPage = Integer.parseInt(pageParam);
                } catch (NumberFormatException e) {
                    currentPage = 1;
                }
            }

            int orderCountFiltered = (orders != null) ? orders.size() : 0;
            int totalPages = (int) Math.ceil((double) orderCountFiltered / pageSize);
            int fromIndex = Math.min((currentPage - 1) * pageSize, orderCountFiltered);
            int toIndex = Math.min(fromIndex + pageSize, orderCountFiltered);
            List<OrderDto> ordersPage = orders.subList(fromIndex, toIndex);

            // --- Gửi sang JSP ---
            req.setAttribute("orders", ordersPage);
            req.setAttribute("currentPage", currentPage);
            req.setAttribute("totalPages", totalPages);
            req.setAttribute("status", status);
            req.setAttribute("filterDate", filterDateStr);

            req.setAttribute("orderCountCompleted", orderCountCompleted);
            req.setAttribute("orderCountPending", orderCountPending);
            req.setAttribute("orderCountProcessing", orderCountProcessing);
            req.setAttribute("orderCountCancelled", orderCountCancelled);
            req.setAttribute("orderCount", orderCount);

            req.getRequestDispatcher("WEB-INF/view/order/OrderList.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Error loading orders: " + e.getMessage());
            req.setAttribute("orders", List.of());
            req.getRequestDispatcher("WEB-INF/view/order/OrderList.jsp").forward(req, resp);
        }
    }

    // [GET] Show order details
    private void handleDetail(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String orderId = req.getParameter("orderId"); // Lấy Order ID từ request

        if (orderId == null || orderId.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/orders");
            return;
        }

        // 1. Lấy Order Items
        List<OrderItem> orderItem = OrderItemDao.getOrderItemsByOrderId(orderId);

        Order order = orderDao.findById(orderId).orElse(null);

        // Kiểm tra nếu không tìm thấy Order
        if (order == null) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Order not found with ID: " + orderId);
            return;
        }

        OrderDto orderDto = new OrderDto();

        User u = new User();
        UserDao uDao = new UserDaoJdbc();
        u = uDao.findById(order.getUserId()).orElseThrow();
        orderDto = OrderMapper.toDto(order, u.getFullName());

        // 3. Lấy Product List (nếu cần cho các chức năng khác, nếu chỉ để xem chi tiết thì có thể không cần)
        // Giả định bạn cần nó cho chức năng khác.
        List<ProductDto> prodsuctList = new ArrayList<>();
        ProductDaoJdbc p = new ProductDaoJdbc();
        prodsuctList = p.getAllProductsActive();

        // Check for success/error messages from query parameters
        String successMsg = req.getParameter("success");
        String errorMsg = req.getParameter("error");

        // Pass both orderDto and order entity to JSP
        req.setAttribute("order", orderDto); // Gửi đối tượng Order DTO
        req.setAttribute("orderEntity", order); // Gửi order entity để có thêm thông tin (orderType)
        req.setAttribute("orderItems", orderItem);
        req.setAttribute("orderId", orderId); // Gửi ID (mặc dù đã có trong object order)
        req.setAttribute("prodsuctList", prodsuctList);
        req.setAttribute("user", u);
        if (successMsg != null) {
            req.setAttribute("successMessage", successMsg);
        }
        if (errorMsg != null) {
            req.setAttribute("errorMessage", errorMsg);
        }

        req.getRequestDispatcher("WEB-INF/view/order/OrderDetails.jsp").forward(req, resp);
    }

    // [GET] Show checkout form
    private void handleCheckout(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("pageTitle", "Checkout");
        req.getRequestDispatcher("/WEB-INF/view/home/checkout.jsp").forward(req, resp);
    }

    // [POST] Create new order
    private void handleCreate(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            // TODO: Parse order data from request and create order
            // For now, just redirect back to list
            resp.sendRedirect(req.getContextPath() + "/orders");
        } catch (Exception e) {
            System.err.println("Error in handleCreate: " + e.getMessage());
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/orders");
        }
    }

    @Override
    public String getServletInfo() {
        return "OrderControllerServlet handles order management operations";
    }

    private void handleEdit(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {

            String orderIdEdit = req.getParameter("orderId");

            //list menu
            List<ProductDto> productList = new ArrayList<>();
            ProductDaoJdbc p = new ProductDaoJdbc();
            productList = p.getAllProductsActive();

            // load đơn ra
            OrderDao order = new OrderDaoJdbc();
            Order orderEdit = orderDao.findById(orderIdEdit).orElseThrow();
            List<OrderItem> orderItem = OrderItemDao.getOrderItemsByOrderId(orderIdEdit);

            req.setAttribute("pendingOrder", orderEdit);
            req.setAttribute("productList", productList);
            req.setAttribute("orderItems", orderItem);
            req.setAttribute("orderId", orderIdEdit);

            req.getRequestDispatcher("/WEB-INF/view/order/OrderCashier.jsp").forward(req, resp);
        } catch (Exception e) {
            System.err.println("Error in handleCreate: " + e.getMessage());
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/orders");
        }
    }

    private void handleInvoice(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String orderId = req.getParameter("orderID");

        String paymethod = req.getParameter("paymethod");
        if (paymethod.equals("Tiền mặt")) {
            orderService.createInvoiceCash(orderId);
        }
        if (paymethod.equals("PayOS")) {
            orderService.createInvoiceBank(orderId);
        }

        //lấy danh sách orderItems của order
        OrderItemDao o = new OrderItemDao();
        List<OrderItem> orderItem = OrderItemDao.getOrderItemsByOrderId(orderId);

        //lấy order 
        Order orderConfirm = new Order();
        orderConfirm = orderDao.findById(orderId).orElseThrow();

        //lấy sản phẩm để in ra tên
        List<ProductDto> productList = new ArrayList<>(); // Tên chuẩn: productList
        ProductDaoJdbc p = new ProductDaoJdbc();
        productList = p.getAllProductsActive();

        java.util.Date currentDateTime = new java.util.Date(); // Sử dụng java.util.Date

        HttpSession session = req.getSession(false);
        if (session != null) {
            UserDto authUser = (UserDto) session.getAttribute("authUser");
            if (authUser != null) {
                String cashhierName = authUser.getFullName();
                // hoặc set attribute để JSP dùng
                req.setAttribute("cashhierName", cashhierName);
            }
        } else {
            resp.sendRedirect(req.getContextPath() + "/login");
        }

        req.setAttribute("pendingOrder", orderConfirm);
        req.setAttribute("orderItems", orderItem);
        req.setAttribute("orderId", orderId);
        req.setAttribute("productList", productList); // <-- ĐÃ SỬA TÊN THUỘC TÍNH THÀNH "productList"
        req.setAttribute("currentTime", currentDateTime);
        req.getRequestDispatcher("WEB-INF/view/order/invoice.jsp").forward(req, resp);
    }

    private void handleCancelled(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String orderId = req.getParameter("orderId");

        Order order = orderDao.findById(orderId).orElseThrow();

        order.setStatus("Cancelled");

        orderDao.update(order);

        //lấy danh sách orderItems của order
        OrderItemDao o = new OrderItemDao();
        List<OrderItem> orderItem = OrderItemDao.getOrderItemsByOrderId(orderId);

        //lấy order 
        Order orderConfirm = new Order();
        orderConfirm = orderDao.findById(orderId).orElseThrow();

        //
        List<ProductDto> prodsuctList = new ArrayList<>();
        ProductDaoJdbc p = new ProductDaoJdbc();
        prodsuctList = p.getAllProductsActive();

        req.setAttribute("pendingOrder", orderConfirm);
        req.setAttribute("orderItems", orderItem);
        req.setAttribute("orderId", orderId);
        req.setAttribute("productList", prodsuctList);

        req.getRequestDispatcher("WEB-INF/view/order/Cancelled.jsp").forward(req, resp);
    }

    private void handleDeleted(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String orderItemId = req.getParameter("orderItemId");

        String orderId = req.getParameter("orderId");
        if (orderItemId == null || orderItemId.trim().isEmpty()) {
            throw new IllegalArgumentException("Order Item ID is missing.");
        }

        int itemId;

        try {
            itemId = Integer.parseInt(orderItemId.trim());
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Order Item ID must be a valid integer.", e);
        }

        OrderItemDao o = new OrderItemDao();
        OrderItem item = new OrderItem();
        item = o.findById(orderItemId);
        //Lấy tổng tiền và phải phải trả trước
        Order orderUpdate = orderDao.findById(orderId).orElseThrow();

        //giảm đi đúng bằng subtotoal
        BigDecimal totalAmount = orderUpdate.getTotalAmount().subtract(item.getSubtotal());
        BigDecimal paymentAmount = orderUpdate.getPaymentAmount().subtract(item.getSubtotal());
        if (paymentAmount.compareTo(BigDecimal.ZERO) <= 0) {
            paymentAmount = BigDecimal.ZERO;
        }

        orderUpdate.setTotalAmount(totalAmount);
        orderUpdate.setPaymentAmount(paymentAmount);
        orderDao.update(orderUpdate);

        o.deleteById(orderItemId);

        //trả dữ liệu lại về trang order cũ
        List<ProductDto> productList = new ArrayList<>();
        ProductDaoJdbc p = new ProductDaoJdbc();
        productList = p.getAllProductsActive();

        OrderDao order = new OrderDaoJdbc();
        Order orderEdit = orderDao.findById(orderId).orElseThrow();

        req.setAttribute("productList", productList);

        List<OrderItem> orderItem = OrderItemDao.getOrderItemsByOrderId(orderId);

        req.setAttribute("pendingOrder", orderEdit);
        req.setAttribute("productList", productList);
        req.setAttribute("orderItems", orderItem);
        req.setAttribute("orderId", orderId);
        req.getRequestDispatcher("WEB-INF/view/order/OrderCashier.jsp").forward(req, resp);
    }

    private void handlePromotion(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String inputPromotionCode = req.getParameter("discountCode");

        //trả dữ liệu lại về trang order cũ
        String orderId = req.getParameter("orderId");
        req.setAttribute("orderId", orderId);

        List<ProductDto> productList = new ArrayList<>();

        //trả menu
        ProductDaoJdbc p = new ProductDaoJdbc();
        productList = p.getAllProductsActive();

        //lấy order hiện tại
        OrderDao order = new OrderDaoJdbc();
        Order orderApply = orderDao.findById(orderId).orElseThrow();

        // trả sản phẩm trong đơn
        List<OrderItem> orderItem = OrderItemDao.getOrderItemsByOrderId(orderId);
        req.setAttribute("orderItems", orderItem);

        //check nhập tr
        if (inputPromotionCode.isEmpty() || inputPromotionCode == null) {
            req.setAttribute("error", "Vui lòng nhập mã giảm giá");
            req.setAttribute("productList", productList);
            req.setAttribute("pendingOrder", orderApply);
            req.getRequestDispatcher("WEB-INF/view/order/OrderCashier.jsp").forward(req, resp);
            return;
        }

        //kiểm tra mã tồn tại
        Optional<Promotion> optPromo = promotionDao.findByCode(inputPromotionCode);
        if (optPromo.isEmpty()) {
            req.setAttribute("error", "Không tìm thấy mã khuyến mãi: " + inputPromotionCode);
            req.setAttribute("productList", productList);
            req.setAttribute("pendingOrder", orderApply);
            req.getRequestDispatcher("WEB-INF/view/order/OrderCashier.jsp").forward(req, resp);
            System.out.println(optPromo.toString());
            return;
        }
        Promotion promotion = optPromo.get();

        //Check hoạt động
        if (!promotion.getStatus().equalsIgnoreCase("Activate")) {
            req.setAttribute("error", inputPromotionCode + " đã hết hạn");
            req.setAttribute("productList", productList);
            req.setAttribute("pendingOrder", orderApply);
            req.getRequestDispatcher("WEB-INF/view/order/OrderCashier.jsp").forward(req, resp);
            return;
        }

        //check thời hạn
        LocalDate now = LocalDate.now();
        LocalDate proStart = promotion.getStartDate();
        LocalDate proEnd = promotion.getEndDate();
        if (now.isAfter(proEnd) || now.isBefore(proStart)) {
            req.setAttribute("error", "Mã giảm giá đã hết hạn");
            req.setAttribute("productList", productList);
            req.setAttribute("pendingOrder", orderApply);
            req.getRequestDispatcher("WEB-INF/view/order/OrderCashier.jsp").forward(req, resp);
            return;
        }

        //loại deal gi
        PromotionService service = new PromotionServiceImpl(promotionDao);
        if (promotion.getType().equalsIgnoreCase("fixed_amount")) {
            service.useFixedPromotion(promotion, orderApply);
            req.setAttribute("error", "Áp dụng thành công, giảm " + promotion.getValue() + "VND");
        }
        if (promotion.getType().equalsIgnoreCase("percentage")) {
            service.usePercentPromotion(promotion, orderApply);
            req.setAttribute("error", "Áp dụng thành công, giảm " + promotion.getValue() + "%");
        }

        Order o = orderDao.findById(orderId).orElseThrow();
        req.setAttribute("pendingOrder", o);
        req.setAttribute("productList", productList);

        req.getRequestDispatcher("WEB-INF/view/order/OrderCashier.jsp").forward(req, resp);
    }

    /**
     * Handle order acceptance - Update status from Pending to Processing (for online orders)
     */
    private void handleAccept(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            String orderId = req.getParameter("orderId");
            
            if (orderId == null || orderId.trim().isEmpty()) {
                req.setAttribute("error", "Order ID is required");
                resp.sendRedirect(req.getContextPath() + "/orders");
                return;
            }

            // Get order
            Optional<Order> orderOpt = orderDao.findById(orderId);
            if (orderOpt.isEmpty()) {
                req.setAttribute("error", "Order not found: " + orderId);
                resp.sendRedirect(req.getContextPath() + "/orders");
                return;
            }

            Order order = orderOpt.get();
            
            // Only allow acceptance if order is in Pending status
            if (!"Pending".equals(order.getStatus())) {
                req.setAttribute("error", "Chỉ có thể xác nhận đơn hàng đang ở trạng thái Pending. Đơn hàng hiện tại: " + order.getStatus());
                resp.sendRedirect(req.getContextPath() + "/order-details?orderId=" + orderId);
                return;
            }

            // Update status to Processing
            order.setStatus("Processing");
            boolean success = orderDao.update(order);

            if (success) {
                // Redirect back to order details with success message
                resp.sendRedirect(req.getContextPath() + "/order-details?orderId=" + orderId + "&success=Đã xác nhận đơn hàng, chuyển sang trạng thái Processing");
            } else {
                req.setAttribute("error", "Không thể cập nhật trạng thái đơn hàng");
                resp.sendRedirect(req.getContextPath() + "/order-details?orderId=" + orderId);
            }

        } catch (Exception e) {
            System.err.println("Error in handleAccept: " + e.getMessage());
            e.printStackTrace();
            req.setAttribute("error", "Lỗi khi xác nhận đơn hàng: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/orders");
        }
    }

    /**
     * Handle order confirmation - Update status from Processing to Completed
     */
    private void handleConfirm(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            String orderId = req.getParameter("orderId");
            
            if (orderId == null || orderId.trim().isEmpty()) {
                req.setAttribute("error", "Order ID is required");
                resp.sendRedirect(req.getContextPath() + "/orders");
                return;
            }

            // Get order
            Optional<Order> orderOpt = orderDao.findById(orderId);
            if (orderOpt.isEmpty()) {
                req.setAttribute("error", "Order not found: " + orderId);
                resp.sendRedirect(req.getContextPath() + "/orders");
                return;
            }

            Order order = orderOpt.get();
            
            // Only allow confirmation if order is in Processing status
            if (!"Processing".equals(order.getStatus())) {
                req.setAttribute("error", "Chỉ có thể xác nhận đơn hàng đang ở trạng thái Processing. Đơn hàng hiện tại: " + order.getStatus());
                resp.sendRedirect(req.getContextPath() + "/order-details?orderId=" + orderId);
                return;
            }

            // Update status to Completed
            order.setStatus("Completed");
            boolean success = orderDao.update(order);

            if (success) {
                // Redirect back to order details with success message
                resp.sendRedirect(req.getContextPath() + "/order-details?orderId=" + orderId + "&success=Xác nhận đơn hàng thành công");
            } else {
                req.setAttribute("error", "Không thể cập nhật trạng thái đơn hàng");
                resp.sendRedirect(req.getContextPath() + "/order-details?orderId=" + orderId);
            }

        } catch (Exception e) {
            System.err.println("Error in handleConfirm: " + e.getMessage());
            e.printStackTrace();
            req.setAttribute("error", "Lỗi khi xác nhận đơn hàng: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/orders");
        }
    }

}
