package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

import dao.CartDao;
import dao.CartDaoJdbc;
import dao.OrderDao;
import dao.OrderDaoJdbc;
import model.Order;
import model.OrderItem;
import model.UserDto;
import service.UserService;
import service.UserServiceImpl;

/**
 * CustomerServlet:
 *  - /customer/my-profile          : xem & cập nhật thông tin tài khoản
 *  - /customer/my-orders           : xem danh sách đơn hàng của customer
 *  - /customer/my-order-details    : xem chi tiết 1 đơn
 *  - /customer/change-password     : đổi mật khẩu
 */
public class CustomerServlet extends HttpServlet {

    private UserService userService;
    private OrderDao orderDao;
    private CartDao cartDao;

    @Override
    public void init() throws ServletException {
        try {
            userService = new UserServiceImpl();
            orderDao = new OrderDaoJdbc();
            cartDao = new CartDaoJdbc();
            System.out.println("CustomerServlet: Services initialized successfully");
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Failed to initialize services", e);
        }
    }

    // =====================================================================
    //  PATH ROUTING
    // =====================================================================

    /** Ghép servletPath + pathInfo để luôn ra /customer/xxx dù map /customer/* hay /customer/my-profile */
    private String getPath(HttpServletRequest req) {
        String servletPath = req.getServletPath();   // ví dụ: /customer
        String pathInfo = req.getPathInfo();         // ví dụ: /my-orders
        if (pathInfo != null) {
            return servletPath + pathInfo;           // => /customer/my-orders
        }
        return servletPath;                          // trường hợp map trực tiếp /customer/my-profile
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = getPath(request);
        System.out.println("CustomerServlet GET path = " + path);

        switch (path) {
            case "/customer/my-profile":
                handleViewProfile(request, response);
                break;
            case "/customer/my-orders":
                handleMyOrders(request, response);
                break;
            case "/customer/my-order-details":
                handleOrderDetails(request, response);
                break;
            case "/customer/change-password":
                handleChangePasswordPage(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = getPath(request);
        System.out.println("CustomerServlet POST path = " + path);

        switch (path) {
            case "/customer/my-profile":
                handleUpdateProfile(request, response);
                break;
            case "/customer/change-password":
                handleChangePassword(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }

    // =====================================================================
    //  GET LOGGED-IN USER
    // =====================================================================

    /** Lấy user đang đăng nhập từ session (ưu tiên loggedUser, fallback authUser) */
    private UserDto getLoggedInUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return null;

        UserDto user = (UserDto) session.getAttribute("loggedUser");
        if (user == null) {
            user = (UserDto) session.getAttribute("authUser");
        }
        return user;
    }

    // =====================================================================
    //  [GET] MY PROFILE
    // =====================================================================

    private void handleViewProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        UserDto loggedInUser = getLoggedInUser(request);
        if (loggedInUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Lấy thông tin mới nhất từ DB
        UserDto freshUser = userService.getUserById(Integer.parseInt(loggedInUser.getUserId()));
        request.setAttribute("user", freshUser);

        // Lấy số điện thoại từ order gần nhất (nếu có)
        String phone = getLatestPhoneFromOrders(Integer.parseInt(loggedInUser.getUserId()));
        request.setAttribute("phone", phone);

        request.getRequestDispatcher("/WEB-INF/view/customer/MyProfile.jsp")
               .forward(request, response);
    }

    // =====================================================================
    //  [POST] UPDATE PROFILE
    // =====================================================================

    private void handleUpdateProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        UserDto loggedInUser = getLoggedInUser(request);

        if (loggedInUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String fullName = trim(request.getParameter("fullName"));
        String email = trim(request.getParameter("email"));
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        StringBuilder errors = new StringBuilder();

        if (isBlank(fullName)) errors.append("Full name is required. ");
        if (isBlank(email)) errors.append("Email is required. ");
        if (!isBlank(newPassword) && !newPassword.equals(confirmPassword)) {
            errors.append("Passwords do not match. ");
        }

        if (errors.length() > 0) {
            request.setAttribute("error", errors.toString());
            request.setAttribute("user", loggedInUser);
            request.getRequestDispatcher("/WEB-INF/view/customer/MyProfile.jsp")
                   .forward(request, response);
            return;
        }

        // Cập nhật thông tin
        loggedInUser.setFullName(fullName);
        loggedInUser.setEmail(email);
        if (!isBlank(newPassword)) {
            loggedInUser.setPassword(newPassword);
        }

        userService.updateUser(loggedInUser);

        // Cập nhật lại session user
        if (session != null) {
            session.setAttribute("loggedUser", loggedInUser);
            // nếu vẫn dùng authUser chỗ khác thì update luôn cho chắc
            session.setAttribute("authUser", loggedInUser);
            session.setAttribute("success", "Profile updated successfully!");
        }

        response.sendRedirect(request.getContextPath() + "/customer/my-profile");
    }

    // =====================================================================
    //  [GET] MY ORDERS
    // =====================================================================

    private void handleMyOrders(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        UserDto loggedInUser = getLoggedInUser(request);
        if (loggedInUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        System.out.println("Loading orders for user: " + loggedInUser.getUserId());
        System.out.println("User ID type: " + loggedInUser.getUserId().getClass().getName());

        // Lấy danh sách đơn hàng (không phải cart)
        List<Order> orders = orderDao.findByCustomerId(loggedInUser.getUserId());
        System.out.println("Found " + orders.size() + " orders");

        // Debug: in ra ID đơn
        if (orders.isEmpty()) {
            System.out.println("WARNING: No orders found for user ID: " + loggedInUser.getUserId());
            System.out.println("Checking if orders exist in database...");
        } else {
            System.out.println("Order IDs found:");
            for (Order order : orders) {
                System.out.println("  - " + order.getOrderId()
                        + " (is_cart: " + order.isCart()
                        + ", status: " + order.getStatus() + ")");
            }
        }

        // Lấy danh sách item cho từng đơn
        for (Order order : orders) {
            List<OrderItem> items = cartDao.getCartItems(order.getOrderId());
            request.setAttribute("items_" + order.getOrderId(), items);
        }

        request.setAttribute("orders", orders);
        request.getRequestDispatcher("/WEB-INF/view/customer/myOrders.jsp")
               .forward(request, response);
    }

    // =====================================================================
    //  [GET] ORDER DETAILS
    // =====================================================================

    private void handleOrderDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        UserDto loggedInUser = getLoggedInUser(request);
        if (loggedInUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String orderId = request.getParameter("id");
        if (orderId == null || orderId.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/customer/my-orders");
            return;
        }

        try {
            // Lấy order
            Order order = orderDao.findById(orderId).orElse(null);
            if (order == null) {
                response.sendRedirect(request.getContextPath() + "/customer/my-orders");
                return;
            }

            // Lấy items
            List<OrderItem> items = cartDao.getCartItems(orderId);

            request.setAttribute("order", order);
            request.setAttribute("items", items);
            request.getRequestDispatcher("/WEB-INF/view/customer/MyOrderDetail.jsp")
                   .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/customer/my-orders");
        }
    }

    // =====================================================================
    //  [GET] CHANGE PASSWORD PAGE
    // =====================================================================

    private void handleChangePasswordPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        UserDto loggedInUser = getLoggedInUser(request);
        if (loggedInUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.getRequestDispatcher("/WEB-INF/view/auth/passwordChange.jsp")
               .forward(request, response);
    }

    // =====================================================================
    //  [POST] CHANGE PASSWORD
    // =====================================================================

    private void handleChangePassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        UserDto loggedInUser = getLoggedInUser(request);

        if (loggedInUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        StringBuilder errors = new StringBuilder();

        if (isBlank(currentPassword)) {
            errors.append("Vui lòng nhập mật khẩu hiện tại. ");
        }
        if (isBlank(newPassword)) {
            errors.append("Vui lòng nhập mật khẩu mới. ");
        } else if (!userService.isStrongPassword(newPassword)) {
            errors.append("Mật khẩu mới phải có ít nhất 8 ký tự, gồm chữ hoa, chữ thường và số. ");
        }
        if (isBlank(confirmPassword) || !confirmPassword.equals(newPassword)) {
            errors.append("Xác nhận mật khẩu không khớp. ");
        }

        if (errors.length() > 0) {
            request.setAttribute("error", errors.toString());
            request.getRequestDispatcher("/WEB-INF/view/auth/passwordChange.jsp")
                   .forward(request, response);
            return;
        }

        try {
            // Kiểm tra mật khẩu hiện tại
            UserDto authCheck = userService.authenticate(loggedInUser.getEmail(), currentPassword);
            if (authCheck == null) {
                request.setAttribute("error", "Mật khẩu hiện tại không đúng.");
                request.getRequestDispatcher("/WEB-INF/view/auth/passwordChange.jsp")
                       .forward(request, response);
                return;
            }

            // Cập nhật mật khẩu
            loggedInUser.setPassword(newPassword);
            userService.updateUser(loggedInUser);

            // cập nhật lại user trong session
            if (session != null) {
                session.setAttribute("loggedUser", loggedInUser);
                session.setAttribute("authUser", loggedInUser);
            }

            request.setAttribute("success", "Đổi mật khẩu thành công!");
            request.getRequestDispatcher("/WEB-INF/view/auth/passwordChange.jsp")
                   .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi đổi mật khẩu. Vui lòng thử lại.");
            request.getRequestDispatcher("/WEB-INF/view/auth/passwordChange.jsp")
                   .forward(request, response);
        }
    }

    // =====================================================================
    //  HELPER: LẤY PHONE GẦN NHẤT TỪ ORDERS
    // =====================================================================

    private String getLatestPhoneFromOrders(int userId) {
        try {
            OrderDao orderDao = new OrderDaoJdbc();
            List<Order> orders = orderDao.findByCustomerId(String.valueOf(userId));

            // Tìm order gần nhất có phone_contact
            for (Order order : orders) {
                if (order.getPhoneContact() != null && !order.getPhoneContact().trim().isEmpty()) {
                    return order.getPhoneContact().trim();
                }
            }
        } catch (Exception e) {
            System.err.println("Error getting phone from orders: " + e.getMessage());
        }
        return null;
    }

    // =====================================================================
    //  COMMON UTIL
    // =====================================================================

    private static String trim(String s) {
        return (s == null) ? null : s.trim();
    }

    private static boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }

    @Override
    public String getServletInfo() {
        return "CustomerServlet handles customer profile, orders, and password change";
    }
}
