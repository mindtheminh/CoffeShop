package controller;

import config.Routes;
import jakarta.mail.MessagingException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.UserDto;
import service.UserService;
import service.UserServiceImpl;
import util.GoogleUtils;
import org.json.JSONObject;

import java.io.IOException;
import java.util.Random;
import java.util.logging.Level;
import java.util.logging.Logger;
import util.EmailUtils;

@WebServlet(name = "AuthControllerServlet", urlPatterns = {Routes.AUTH_BASE})
public class AuthControllerServlet extends HttpServlet {

    private UserService userService;

    @Override
    public void init() throws ServletException {
        userService = new UserServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String p = req.getPathInfo(); // /login, /register, /reset, /logout, /google-login, /google-callback
        String servletPath = req.getServletPath(); // /login or /auth
        
        // Handle shortcut URLs: /login, /register, /logout
        if ("/login".equals(servletPath) || p == null || "/login".equals(p)) {
            req.getRequestDispatcher("/WEB-INF/view/auth/login.jsp").forward(req, resp);
            return;
        }
        if ("/register".equals(servletPath) || "/register".equals(p)) {
            req.getRequestDispatcher("/WEB-INF/view/auth/register.jsp").forward(req, resp);
            return;
        }
        if ("/reset".equals(p)) {
            req.getRequestDispatcher("/WEB-INF/view/auth/PasswordReset.jsp").forward(req, resp);
            return;
        }
        if ("/reset-password/confirm".equals(p)) {
            handleResetPasswordConfirmPage(req, resp);
            return;
        }
        if ("/logout".equals(servletPath) || "/logout".equals(p)) {
            HttpSession s = req.getSession(false);
            if (s != null) {
                s.invalidate();
            }
            resp.sendRedirect(req.getContextPath() + "/");
            return;
        }
        if ("/google-login".equals(p)) {
            String googleLoginUrl = GoogleUtils.getGoogleLoginUrl();
            resp.sendRedirect(googleLoginUrl);
            return;
        }
        if ("/google-callback".equals(p)) {
            handleGoogleCallback(req, resp);
            return;
        }
        resp.sendError(HttpServletResponse.SC_NOT_FOUND);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String p = req.getPathInfo();
        String servletPath = req.getServletPath();
        
        if ("/login".equals(servletPath) || "/login".equals(p)) {
            handleLogin(req, resp);
            return;
        }
        if ("/verify".equals(p)) {
            handleVerity(req, resp);
            return;
        }
        if ("/register".equals(servletPath) || "/register".equals(p)) {
            try {
                handleRegister(req, resp);
            } catch (MessagingException ex) {
                Logger.getLogger(AuthControllerServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
            return;
        }
        if ("/reset-password".equals(p)) {
            handleForgotPassword(req, resp);
            return;
        }
        if ("/reset-password/confirm".equals(p)) {
            handleResetPasswordConfirm(req, resp);
            return;
        }
        resp.sendError(HttpServletResponse.SC_NOT_FOUND);
    }

    // ===================== LOGIN =====================
    private void handleLogin(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        String email = trim(req.getParameter("email"));
        String password = req.getParameter("password");

        if (isBlank(email) || isBlank(password)) {
            req.setAttribute("error", "Email và mật khẩu không được để trống.");
            req.getRequestDispatcher("/WEB-INF/view/auth/login.jsp").forward(req, resp);
            return;
        }

        // ==================== FAKE LOGIN FOR TESTING ====================
        // Comment lại phần xác thực thật để test
        UserDto dto = userService.authenticate(email, password);
        if (dto == null) {
            req.setAttribute("error", "Sai email hoặc mật khẩu.");
            req.getRequestDispatcher("/WEB-INF/view/auth/login.jsp").forward(req, resp);
            return;
        }

        // Kiểm tra trạng thái tài khoản
        if ("Inactive".equalsIgnoreCase(dto.getStatus())) {
            req.setAttribute("error", "Tài khoản của bạn đã bị vô hiệu hóa. Vui lòng liên hệ quản trị viên.");
            req.getRequestDispatcher("/WEB-INF/view/auth/login.jsp").forward(req, resp);
            return;
        }

//
//        // FAKE LOGIN - Tạo user giả để test
//        UserDto dto = new UserDto();
//
//        // Kiểm tra email để quyết định role
//        if ("admin@test.com".equalsIgnoreCase(email)) {
//            // Fake ADMIN
//            dto.setUserId("1");
//            dto.setFullName("Admin Test");
//            dto.setEmail("admin@test.com");
//            dto.setRole("ADMIN");
//            dto.setStatus("Active");
//        } else if ("user@test.com".equalsIgnoreCase(email)) {
//            // Fake USER/CUSTOMER
//            dto.setUserId("2");
//            dto.setFullName("User Test");
//            dto.setEmail("user@test.com");
//            dto.setRole("CUSTOMER");
//            dto.setStatus("Active");
//        } else if ("marketer@test.com".equalsIgnoreCase(email)) {
//            // Fake MARKETER
//            dto.setUserId("3");
//            dto.setFullName("Marketer Test");
//            dto.setEmail("marketer@test.com");
//            dto.setRole("MARKETER");
//            dto.setStatus("Active");
//        } else if ("hr@test.com".equalsIgnoreCase(email)) {
//            // Fake HR
//            dto.setUserId("4");
//            dto.setFullName("HR Test");
//            dto.setEmail("hr@test.com");
//            dto.setRole("HR");
//            dto.setStatus("Active");
//        } else if ("cashier@test.com".equalsIgnoreCase(email)) {
//            // Fake CASHIER
//            dto.setUserId("5");
//            dto.setFullName("Cashier Test");
//            dto.setEmail("cashier@test.com");
//            dto.setRole("CASHIER");
//            dto.setStatus("Active");
//        } else {
//            // Email không hợp lệ
//            req.setAttribute("error", "Sử dụng email test: admin@test.com, user@test.com, marketer@test.com, hr@test.com, hoặc cashier@test.com");
//            req.getRequestDispatcher("/WEB-INF/view/auth/login.jsp").forward(req, resp);
//            return;
//        }
//        // ==================== END FAKE LOGIN ====================
        HttpSession session = req.getSession(true);
        session.setAttribute("authUser", dto);
        session.setAttribute("loggedUser", dto); // Also set loggedUser for consistency
        session.setAttribute("userRole", dto.getRole());

        // Điều hướng theo vai trò
        String role = dto.getRole();
        if ("ADMIN".equals(role)) {
            resp.sendRedirect(req.getContextPath() + "/admin-dashboard");
        } else if ("MARKETER".equals(role)) {
            resp.sendRedirect(req.getContextPath() + "/marketer-dashboard");
        } else if ("HR".equals(role)) {
            resp.sendRedirect(req.getContextPath() + "/hr-dashboard");
        } else if ("CASHIER".equals(role)) {
            resp.sendRedirect(req.getContextPath() + "/cashier-dashboard");
        } else {
            resp.sendRedirect(req.getContextPath() + Routes.HOME);
        }
    }

    // ===================== REGISTER =====================
    private void handleRegister(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException, MessagingException {
        String fullName = trim(req.getParameter("fullName"));
        String email = trim(req.getParameter("email"));
        String password = req.getParameter("password");
        String confirm = req.getParameter("confirm");

        StringBuilder errors = new StringBuilder();

        if (isBlank(fullName)) {
            errors.append("Họ tên không được để trống. ");
        }
        if (fullName.length() > 30) {
            errors.append("Tên quá dài, vui lòng nhập lại");
        }
        if (isBlank(email)) {
            errors.append("Email không được để trống. ");
        } else if (!email.matches("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")) {
            errors.append("Email không hợp lệ. ");
        }
        if (isBlank(password)) {
            errors.append("Mật khẩu không được để trống. ");
        } else if (!userService.isStrongPassword(password)) {
            errors.append("Mật khẩu phải có ít nhất 8 ký tự, gồm chữ hoa, chữ thường và số. ");
        }
        if (confirm == null || !confirm.equals(password)) {
            errors.append("Xác nhận mật khẩu không khớp. ");
        }

        if (errors.length() > 0) {
            req.setAttribute("error", errors.toString());
            req.setAttribute("fullName", fullName);
            req.setAttribute("email", email);
            req.getRequestDispatcher("/WEB-INF/view/auth/register.jsp").forward(req, resp);
            return;
        }

        if (userService.existsByEmail(email)) {
            req.setAttribute("error", "Email này đã được sử dụng. Vui lòng chọn email khác.");
            req.setAttribute("fullName", fullName);
            req.setAttribute("email", email);
            req.getRequestDispatcher("/WEB-INF/view/auth/register.jsp").forward(req, resp);
            return;
        }
//tạo captcha
        AuthControllerServlet auth = new AuthControllerServlet();
        String verificationCode = auth.generateVerificationCode();

        try {
            EmailUtils.sendVerificationEmail(email, verificationCode);
        } catch (Exception e) {
            e.printStackTrace();
            if (email == null) {
                req.setAttribute("error", "Không có email " + email + " Vui lòng thử lại.");
                req.getRequestDispatcher("/WEB-INF/view/auth/register.jsp").forward(req, resp);
                return;
            }
            req.setAttribute("error", "Không thể gửi email xác nhận tới địa chỉ " + email + ". Vui lòng thử lại.");
            req.getRequestDispatcher("/WEB-INF/view/auth/register.jsp").forward(req, resp);
            return;
        }

//        
        HttpSession session = req.getSession();
        session.setAttribute("pendingName", fullName);
        session.setAttribute("pendingEmail", email);
        session.setAttribute("pendingPassword", password);
        session.setAttribute("verificationCode", verificationCode);
        session.setAttribute("codeTimestamp", System.currentTimeMillis());

        req.getRequestDispatcher("/WEB-INF/view/auth/verify.jsp").forward(req, resp);
    }

    // ===================== GOOGLE LOGIN =====================
    private void handleGoogleCallback(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {
        System.out.println("=== Google Callback Handler ===");
        String code = req.getParameter("code");
        System.out.println("Code received: " + (code != null ? code.substring(0, Math.min(20, code.length())) + "..." : "null"));

        if (code == null || code.isEmpty()) {
            System.err.println("No code received from Google");
            req.setAttribute("error", "Đăng nhập Google thất bại. Vui lòng thử lại.");
            req.getRequestDispatcher("/WEB-INF/view/auth/login.jsp").forward(req, resp);
            return;
        }

        try {
            // 1. Lấy access token
            String accessToken = GoogleUtils.getToken(code);

            // 2. Lấy thông tin người dùng từ Google
            JSONObject userInfo = GoogleUtils.getUserInfo(accessToken);
            String email = userInfo.getString("email");
            String name = userInfo.optString("name", "Google User");

            // 3. Kiểm tra người dùng đã tồn tại hay chưa
            UserDto user = userService.findByEmail(email);
            if (user == null) {
                user = new UserDto();
                user.setEmail(email);
                user.setFullName(name);
                user.setRole("CUSTOMER");
                user.setStatus("Active");
                user.setPassword(null);
                userService.register(user);
                user = userService.findByEmail(email);
            }

            // 4. Kiểm tra trạng thái tài khoản
            if ("Inactive".equalsIgnoreCase(user.getStatus())) {
                req.setAttribute("error", "Tài khoản Google của bạn đã bị vô hiệu hóa. Vui lòng liên hệ quản trị viên.");
                req.getRequestDispatcher("/WEB-INF/view/auth/login.jsp").forward(req, resp);
                return;
            }

            // ✅ THÊM SESSION Ở ĐÂY
            HttpSession session = req.getSession(true);
            session.setAttribute("authUser", user);
            session.setAttribute("loggedUser", user); // Also set loggedUser for consistency
            session.setAttribute("userRole", user.getRole());

            // 5. Điều hướng theo vai trò
            String role = user.getRole();
            if ("ADMIN".equals(role)) {
                resp.sendRedirect(req.getContextPath() + "/admin-dashboard");
            } else if ("MARKETER".equals(role)) {
                resp.sendRedirect(req.getContextPath() + "/marketer-dashboard");
            } else if ("HR".equals(role)) {
                resp.sendRedirect(req.getContextPath() + "/hr-dashboard");
            } else if ("CASHIER".equals(role)) {
                resp.sendRedirect(req.getContextPath() + "/cashier-dashboard");
            } else {
                resp.sendRedirect(req.getContextPath() + Routes.HOME);
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi hệ thống khi đăng nhập bằng Google. Vui lòng thử lại.");
            req.getRequestDispatcher("/WEB-INF/view/auth/login.jsp").forward(req, resp);
        }
    }

    private void handleVerity(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/register");
            return;
        }

        String inputCode = trim(req.getParameter("code"));
        String storedCode = (String) session.getAttribute("verificationCode");
        String email = (String) session.getAttribute("pendingEmail");
        String fullName = (String) session.getAttribute("pendingName");
        String password = (String) session.getAttribute("pendingPassword");
        Long codeTimestamp = (Long) session.getAttribute("codeTimestamp");

        // 1. Kiểm tra mã xác nhận có hợp lệ không
        if (isBlank(inputCode) || !inputCode.equals(storedCode)) {
            req.setAttribute("error", "Mã xác nhận không hợp lệ. Vui lòng kiểm tra lại.");
            req.setAttribute("pendingEmail", email); // Giữ email để hiển thị lại trên trang verify
            req.getRequestDispatcher("/WEB-INF/view/auth/verify.jsp").forward(req, resp);
            return;
        }

        //Đăng kí
        UserDto dto = new UserDto();
        dto.setFullName(fullName);
        dto.setEmail(email);
        dto.setPassword(password); // lấy pass session
        dto.setRole("CUSTOMER");
        dto.setStatus("Activate");

        try {
            //Hash pass ưord
            userService.register(dto);

            //xóa
            session.removeAttribute("pendingName");
            session.removeAttribute("pendingEmail");
            session.removeAttribute("pendingPassword");
            session.removeAttribute("verificationCode");
            session.removeAttribute("codeTimestamp");

            // Chuyển hướng thành công
            session.setAttribute("registerSuccess", "Đăng ký thành công! Vui lòng đăng nhập.");
            resp.sendRedirect(req.getContextPath() + "/auth/login");

        } catch (Exception ex) {
            Logger.getLogger(AuthControllerServlet.class.getName()).log(Level.SEVERE, "Registration failed", ex);
            //
            session.invalidate();
            req.setAttribute("error", "Lỗi hệ thống khi đăng ký. Vui lòng thử lại: " + ex.getMessage());
            req.getRequestDispatcher("/WEB-INF/view/auth/register.jsp").forward(req, resp);
        }
    }

    // ===================== TIỆN ÍCH =====================
    private static String trim(String s) {
        return s == null ? null : s.trim();
    }

    private static boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }

    //ham tao OTP 6 so
    private String generateVerificationCode() {
        Random random = new Random();
        int otp = 100000 + random.nextInt(900000); // 100000-999999
        return String.valueOf(otp);
    }

    // ===================== PASSWORD RESET WITH OTP =====================
    /**
     * Handle forgot password - send OTP email
     */
    private void handleForgotPassword(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        String email = trim(req.getParameter("email"));
        String otp = req.getParameter("otp");
        String newPassword = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");
        
        // Step 1: User requests OTP
        if (otp == null && newPassword == null) {
            if (isBlank(email)) {
                req.setAttribute("error", "Vui lòng nhập địa chỉ email.");
                req.getRequestDispatcher("/WEB-INF/view/auth/PasswordReset.jsp").forward(req, resp);
                return;
            }
            
            // Check if user exists
            if (!userService.existsByEmail(email)) {
                // For security: don't reveal if email exists or not
                req.setAttribute("message", "Nếu email này tồn tại, bạn sẽ nhận được mã OTP.");
                req.setAttribute("email", email);
                req.getRequestDispatcher("/WEB-INF/view/auth/PasswordReset.jsp").forward(req, resp);
                return;
            }
            
            // Generate 6-digit OTP
            String generatedOTP = generateOTP();
            
            // Send OTP via email
            try {
                EmailUtils.sendPasswordResetOTP(email, generatedOTP);
                
                // Store OTP in session
                HttpSession session = req.getSession(true);
                session.setAttribute("resetOTP", generatedOTP);
                session.setAttribute("resetEmail", email);
                session.setAttribute("otpTimestamp", System.currentTimeMillis());
                
                req.setAttribute("message", "Mã OTP đã được gửi đến email của bạn. Vui lòng kiểm tra hộp thư.");
                req.setAttribute("email", email);
                req.setAttribute("showOTPForm", true);
                req.getRequestDispatcher("/WEB-INF/view/auth/PasswordReset.jsp").forward(req, resp);
                
            } catch (Exception e) {
                Logger.getLogger(AuthControllerServlet.class.getName()).log(Level.SEVERE, "Send OTP failed", e);
                req.setAttribute("error", "Có lỗi xảy ra khi gửi email. Vui lòng thử lại sau.");
                req.getRequestDispatcher("/WEB-INF/view/auth/PasswordReset.jsp").forward(req, resp);
            }
            return;
        }
        
        // Step 2: User submits OTP and new password
        HttpSession session = req.getSession(false);
        if (session == null) {
            req.setAttribute("error", "Phiên làm việc đã hết hạn. Vui lòng thử lại.");
            req.getRequestDispatcher("/WEB-INF/view/auth/PasswordReset.jsp").forward(req, resp);
            return;
        }
        
        String storedOTP = (String) session.getAttribute("resetOTP");
        String storedEmail = (String) session.getAttribute("resetEmail");
        Long otpTimestamp = (Long) session.getAttribute("otpTimestamp");
        
        StringBuilder errors = new StringBuilder();
        
        // Validate OTP
        if (isBlank(otp) || storedOTP == null || !otp.equals(storedOTP)) {
            errors.append("Mã OTP không đúng. ");
        }
        
        // Check OTP expiry (5 minutes)
        if (otpTimestamp == null || System.currentTimeMillis() - otpTimestamp > 5 * 60 * 1000) {
            errors.append("Mã OTP đã hết hạn. ");
        }
        
        // Validate email match
        if (email == null || !email.equals(storedEmail)) {
            errors.append("Email không khớp. ");
        }
        
        // Validate password
        if (isBlank(newPassword)) {
            errors.append("Mật khẩu mới không được để trống. ");
        } else if (!userService.isStrongPassword(newPassword)) {
            errors.append("Mật khẩu phải có ít nhất 8 ký tự, gồm chữ hoa, chữ thường và số. ");
        }
        
        if (isBlank(confirmPassword) || !confirmPassword.equals(newPassword)) {
            errors.append("Xác nhận mật khẩu không khớp. ");
        }
        
        if (errors.length() > 0) {
            req.setAttribute("error", errors.toString());
            req.setAttribute("email", email);
            req.setAttribute("showOTPForm", true);
            req.getRequestDispatcher("/WEB-INF/view/auth/PasswordReset.jsp").forward(req, resp);
            return;
        }
        
        // Update password
        try {
            UserDto user = userService.findByEmail(storedEmail);
            if (user == null) {
                req.setAttribute("error", "Không tìm thấy tài khoản.");
                req.getRequestDispatcher("/WEB-INF/view/auth/PasswordReset.jsp").forward(req, resp);
                return;
            }
            
            user.setPassword(newPassword);
            userService.updateUser(user);
            
            // Clear OTP from session
            session.removeAttribute("resetOTP");
            session.removeAttribute("resetEmail");
            session.removeAttribute("otpTimestamp");
            
            // Success
            session.setAttribute("registerSuccess", "Mật khẩu đã được đặt lại thành công! Vui lòng đăng nhập.");
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            
        } catch (Exception e) {
            Logger.getLogger(AuthControllerServlet.class.getName()).log(Level.SEVERE, "Reset password failed", e);
            req.setAttribute("error", "Có lỗi xảy ra. Vui lòng thử lại.");
            req.setAttribute("email", email);
            req.setAttribute("showOTPForm", true);
            req.getRequestDispatcher("/WEB-INF/view/auth/PasswordReset.jsp").forward(req, resp);
        }
    }
    
    /**
     * Generate 6-digit OTP
     */
    private String generateOTP() {
        Random random = new Random();
        int otp = 100000 + random.nextInt(900000);
        return String.valueOf(otp);
    }
    
    /**
     * Not used anymore - keeping for compatibility
     */
    private void handleResetPasswordConfirmPage(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        resp.sendRedirect(req.getContextPath() + "/auth/reset");
    }
    
    /**
     * Not used anymore - keeping for compatibility
     */
    private void handleResetPasswordConfirm(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        resp.sendRedirect(req.getContextPath() + "/auth/reset");
    }

}
