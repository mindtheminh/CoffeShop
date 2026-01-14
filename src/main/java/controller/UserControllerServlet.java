package controller;

import config.Routes;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import model.UserDto;
import service.UserService;
import service.UserServiceImpl;
import service.ProductService;
import service.ProductServiceImpl;

import java.io.IOException;
import java.util.List;
import java.util.ArrayList;

public class UserControllerServlet extends HttpServlet {
   
    private UserService userService;
    private ProductService productService;

    @Override 
    public void init() throws ServletException {
        try {
            userService = new UserServiceImpl();
            System.out.println("UserService initialized successfully");
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Failed to initialize UserService", e);
        }
        
        try {
            productService = new ProductServiceImpl();
            System.out.println("ProductService initialized successfully");
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("ProductService initialization failed, will use mock data");
            productService = null;
        }
    }

    @Override 
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        String servletPath = req.getServletPath();

        // HR Dashboard
        if (servletPath.equals("/hr-dashboard")) {
            handleHRDashboard(req, resp);
            return;
        }

        // List users
        if (servletPath.equals("/user-list")) {
            handleList(req, resp);
            return;
        }

        // New user form
        if (servletPath.equals("/user-new")) {
            req.getRequestDispatcher("WEB-INF/view/user/NewUser.jsp").forward(req, resp);
            return;
        }

        // User details
        if (servletPath.equals("/user-detail")) {
            handleDetail(req, resp);
            return;
        }

        // Edit user form
        if (servletPath.equals("/user-edit")) {
            handleEdit(req, resp);
            return;
        }

        resp.sendError(HttpServletResponse.SC_NOT_FOUND);
    }

    @Override 
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        String servletPath = req.getServletPath();
        String action = req.getParameter("action");

        // Handle toggle status
        if (servletPath.equals("/user/toggle-status")) {
            handleToggleStatus(req, resp);
            return;
        }

        // Handle all other POST actions based on action parameter
        if ("create".equals(action)) {
            handleCreate(req, resp);
        } else if ("update".equals(action)) {
            handleUpdate(req, resp);
        } else if ("delete".equals(action)) {
            handleDelete(req, resp);
        } else {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
        }
    }

    private void handleList(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        try {
            System.out.println("=== DEBUG: handleList called ===");
            
            // Get all users first
            List<UserDto> allUsers = userService.getAllUsers();
            System.out.println("DEBUG: Total users from service: " + (allUsers != null ? allUsers.size() : "null"));
            
            // If no users found, create some test data
            if (allUsers == null || allUsers.isEmpty()) {
                System.out.println("DEBUG: No users found, creating test data");
                allUsers = createTestUsers();
            }
            
            // Apply filters
            String search = req.getParameter("search");
            String role = req.getParameter("role");
            String status = req.getParameter("status");
            String sort = req.getParameter("sort");
            
            // Get sorting parameters
            String sortColumn = req.getParameter("sortColumn");
            String sortDirection = req.getParameter("sortDirection");
            
            System.out.println("DEBUG: search=" + search + ", role=" + role + ", status=" + status + ", sort=" + sort);
            
            List<UserDto> filteredUsers = allUsers;
            
            // Search filter
            if (search != null && !search.trim().isEmpty()) {
                String searchLower = search.toLowerCase().trim();
                filteredUsers = filteredUsers.stream()
                        .filter(u -> (u.getFullName() != null && u.getFullName().toLowerCase().contains(searchLower))
                                || (u.getEmail() != null && u.getEmail().toLowerCase().contains(searchLower)))
                        .toList();
            }
            
            // Role filter
            if (role != null && !role.trim().isEmpty()) {
                filteredUsers = filteredUsers.stream()
                        .filter(u -> u.getRole() != null && u.getRole().equals(role))
                        .toList();
            }
            
            // Status filter
            if (status != null && !status.trim().isEmpty()) {
                filteredUsers = filteredUsers.stream()
                        .filter(u -> u.getStatus() != null && u.getStatus().equals(status))
                        .toList();
            }
            
            // Apply sorting to all filtered data
            if (sortColumn != null && !sortColumn.trim().isEmpty() && sortDirection != null && !sortDirection.trim().isEmpty()) {
                final String finalSortColumn = sortColumn.trim();
                final boolean ascending = "asc".equalsIgnoreCase(sortDirection.trim());
                
                filteredUsers = filteredUsers.stream().sorted((u1, u2) -> {
                    int result = 0;
                    switch (finalSortColumn) {
                        case "0": // ID
                            try {
                                int id1 = Integer.parseInt(u1.getUserId());
                                int id2 = Integer.parseInt(u2.getUserId());
                                result = Integer.compare(id1, id2);
                            } catch (NumberFormatException e) {
                                result = 0;
                            }
                            break;
                        case "1": // Name
                            result = (u1.getFullName() != null && u2.getFullName() != null) 
                                    ? u1.getFullName().compareToIgnoreCase(u2.getFullName()) : 0;
                            break;
                        case "2": // Email
                            result = (u1.getEmail() != null && u2.getEmail() != null) 
                                    ? u1.getEmail().compareToIgnoreCase(u2.getEmail()) : 0;
                            break;
                        case "3": // Role
                            result = (u1.getRole() != null && u2.getRole() != null) 
                                    ? u1.getRole().compareToIgnoreCase(u2.getRole()) : 0;
                            break;
                        case "4": // Status
                            result = (u1.getStatus() != null && u2.getStatus() != null) 
                                    ? u1.getStatus().compareToIgnoreCase(u2.getStatus()) : 0;
                            break;
                        default:
                            result = 0;
                    }
                    return ascending ? result : -result;
                }).toList();
            } else {
                // Legacy sort parameter support
                if (sort != null && !sort.trim().isEmpty()) {
                    switch (sort) {
                        case "created_at_desc":
                            // Sort by ID descending (newest first)
                            filteredUsers = filteredUsers.stream()
                                    .sorted((u1, u2) -> {
                                        try {
                                            return Integer.compare(Integer.parseInt(u2.getUserId()), Integer.parseInt(u1.getUserId()));
                                        } catch (NumberFormatException e) {
                                            return 0;
                                        }
                                    })
                                    .toList();
                            break;
                        case "created_at_asc":
                            // Sort by ID ascending (oldest first)
                            filteredUsers = filteredUsers.stream()
                                    .sorted((u1, u2) -> {
                                        try {
                                            return Integer.compare(Integer.parseInt(u1.getUserId()), Integer.parseInt(u2.getUserId()));
                                        } catch (NumberFormatException e) {
                                            return 0;
                                        }
                                    })
                                    .toList();
                            break;
                        case "name_asc":
                            filteredUsers = filteredUsers.stream()
                                    .sorted((u1, u2) -> u1.getFullName().compareToIgnoreCase(u2.getFullName()))
                                    .toList();
                            break;
                        case "name_desc":
                            filteredUsers = filteredUsers.stream()
                                    .sorted((u1, u2) -> u2.getFullName().compareToIgnoreCase(u1.getFullName()))
                                    .toList();
                            break;
                    }
                }
            }
            
            System.out.println("DEBUG: Final filtered users count: " + (filteredUsers != null ? filteredUsers.size() : "null"));
            
            // Pagination logic
            int pageSize = 10;
            int currentPage = 1;
            String pageParam = req.getParameter("page");
            if (pageParam != null && !pageParam.trim().isEmpty()) {
                try {
                    currentPage = Integer.parseInt(pageParam);
                    if (currentPage < 1) currentPage = 1;
                } catch (NumberFormatException e) {
                    currentPage = 1;
                }
            }
            
            int totalItems = filteredUsers.size();
            int totalPages = (int) Math.ceil((double) totalItems / pageSize);
            
            if (currentPage > totalPages && totalPages > 0) {
                currentPage = totalPages;
            }
            
            // Get users for current page
            int startIndex = (currentPage - 1) * pageSize;
            int endIndex = Math.min(startIndex + pageSize, totalItems);
            
            List<UserDto> paginatedUsers = filteredUsers.subList(startIndex, endIndex);
            
            // Debug: Print first user if exists
            if (paginatedUsers != null && !paginatedUsers.isEmpty()) {
                System.out.println("DEBUG: First user on page: " + paginatedUsers.get(0).getFullName() + " (" + paginatedUsers.get(0).getEmail() + ")");
            }
            
            req.setAttribute("users", paginatedUsers);
            req.setAttribute("search", search);
            req.setAttribute("role", role);
            req.setAttribute("status", status);
            req.setAttribute("sort", sort);
            req.setAttribute("sortColumn", sortColumn);
            req.setAttribute("sortDirection", sortDirection);
            req.setAttribute("currentPage", currentPage);
            req.setAttribute("totalPages", totalPages);
            req.setAttribute("totalItems", totalItems);
            req.setAttribute("pageSize", pageSize);
            
        } catch (Exception e) {
            System.out.println("=== DEBUG: Exception in handleList ===");
            e.printStackTrace();
            req.setAttribute("users", List.of());
            req.setAttribute("currentPage", 1);
            req.setAttribute("totalPages", 1);
            req.setAttribute("totalItems", 0);
            req.setAttribute("pageSize", 10);
        }
        
        req.getRequestDispatcher("WEB-INF/view/user/UserList.jsp").forward(req, resp);
    }
    
    private List<UserDto> createTestUsers() {
        List<UserDto> testUsers = new ArrayList<>();

        UserDto user1 = new UserDto();
        user1.setUserId("1");
        user1.setFullName("Nguyễn Văn Admin");
        user1.setEmail("admin@yencoffee.com");
        user1.setRole("ADMIN");
        user1.setStatus("ACTIVE");
        testUsers.add(user1);

        UserDto user2 = new UserDto();
        user2.setUserId("2");
        user2.setFullName("Trần Thị HR");
        user2.setEmail("hr@yencoffee.com");
        user2.setRole("HR");
        user2.setStatus("ACTIVE");
        testUsers.add(user2);

        UserDto user3 = new UserDto();
        user3.setUserId("3");
        user3.setFullName("Lê Văn Cashier");
        user3.setEmail("cashier@yencoffee.com");
        user3.setRole("CASHIER");
        user3.setStatus("ACTIVE");
        testUsers.add(user3);

        UserDto user4 = new UserDto();
        user4.setUserId("4");
        user4.setFullName("Phạm Thị Customer");
        user4.setEmail("customer@yencoffee.com");
        user4.setRole("CUSTOMER");
        user4.setStatus("INACTIVE");
        testUsers.add(user4);

        System.out.println("DEBUG: Created " + testUsers.size() + " test users");
        return testUsers;
    }

    private void handleDetail(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        String idStr = req.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/user-list");
            return;
        }

        try {
            int userId = Integer.parseInt(idStr);
            System.out.println("=== DEBUG: handleDetail called with userId=" + userId + " ===");
            
            UserDto user = userService.getUserById(userId);
            System.out.println("DEBUG: User loaded: " + (user != null ? "YES" : "NULL"));
            
            if (user != null) {
                System.out.println("DEBUG: User details - ID: " + user.getUserId() + ", Name: " + user.getFullName() + ", Email: " + user.getEmail());
            }
            
            if (user == null) {
                System.out.println("DEBUG: User not found, redirecting to user-list");
                req.setAttribute("error", "Không tìm thấy người dùng");
                resp.sendRedirect(req.getContextPath() + "/user-list");
                return;
            }

            // Get success message from session
            HttpSession session = req.getSession();
            String success = (String) session.getAttribute("success");
            if (success != null) {
                req.setAttribute("success", success);
                session.removeAttribute("success");
            }

            // Get error from session
            String error = (String) session.getAttribute("error");
            if (error != null) {
                req.setAttribute("error", error);
                session.removeAttribute("error");
            }
            
            // Get error from parameter (for edit mode)
            String errorParam = req.getParameter("error");
            if (errorParam != null) {
                req.setAttribute("error", errorParam);
            }

            req.setAttribute("user", user);
            System.out.println("DEBUG: Forwarding to UserDetails.jsp with user object");
            req.getRequestDispatcher("WEB-INF/view/user/UserDetails.jsp").forward(req, resp);
        } catch (NumberFormatException e) {
            System.out.println("DEBUG: Invalid user ID format: " + idStr);
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/user-list");
        } catch (Exception e) {
            System.out.println("DEBUG: Exception in handleDetail: " + e.getMessage());
            e.printStackTrace();
            req.setAttribute("error", "Lỗi khi tải thông tin người dùng: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/user-list");
        }
    }

    private void handleEdit(HttpServletRequest req, HttpServletResponse resp) 
    throws ServletException, IOException {
        // Redirect to user-detail with mode=edit
        String idStr = req.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/user-list");
            return;
        }
        resp.sendRedirect(req.getContextPath() + "/user-detail?id=" + idStr + "&mode=edit");
    }


    private void handleUpdate(HttpServletRequest req, HttpServletResponse resp) 
    throws ServletException, IOException {
        String idStr = req.getParameter("userId");
        // Only allow updating role, status, and note - not fullName or email
        String role = trim(req.getParameter("role"));
        String status = trim(req.getParameter("status"));
        String note = trim(req.getParameter("note"));

        if (idStr == null || idStr.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/user-list");
            return;
        }

        try {
            int userId = Integer.parseInt(idStr);
            System.out.println("=== DEBUG: handleUpdate called ===");
            System.out.println("DEBUG: userId=" + userId);
            System.out.println("DEBUG: role=" + role);
            System.out.println("DEBUG: status=" + status);
            System.out.println("DEBUG: note=" + note);
            
            UserDto user = userService.getUserById(userId);
            if (user == null) {
                System.out.println("DEBUG: User not found with ID: " + userId);
                resp.sendRedirect(req.getContextPath() + "/user-list");
                return;
            }

            System.out.println("DEBUG: Existing user - Email: " + user.getEmail() + ", FullName: " + user.getFullName());
            System.out.println("DEBUG: Existing user - Role: " + user.getRole() + ", Status: " + user.getStatus());

            StringBuilder errors = new StringBuilder();
            
            // Validate required fields
            if (isBlank(role)) {
                errors.append("Vai trò là bắt buộc. ");
            }
            if (isBlank(status)) {
                errors.append("Trạng thái là bắt buộc. ");
            }

            if (errors.length() > 0) {
                System.out.println("DEBUG: Validation errors: " + errors.toString());
                HttpSession session = req.getSession();
                session.setAttribute("error", errors.toString());
                resp.sendRedirect(req.getContextPath() + "/user-detail?id=" + userId + "&mode=edit");
                return;
            }

            // Only update role, status, and note - keep existing fullName and email
            user.setRole(role);
            user.setStatus(status);
            user.setNote(note != null ? note : "");

            System.out.println("DEBUG: Calling updateUser with - Role: " + user.getRole() + ", Status: " + user.getStatus());
            userService.updateUser(user);
            System.out.println("DEBUG: updateUser completed successfully");

            HttpSession session = req.getSession();
            session.setAttribute("success", "Cập nhật người dùng thành công!");
            resp.sendRedirect(req.getContextPath() + "/user-detail?id=" + userId);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/user-list");
        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = req.getSession();
            session.setAttribute("error", "Lỗi khi cập nhật người dùng: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/user-detail?id=" + idStr);
        }
    }

    private void handleDelete(HttpServletRequest req, HttpServletResponse resp) 
            throws IOException {
        String idStr = req.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/user-list");
            return;
        }

        try {
            int userId = Integer.parseInt(idStr);
            userService.deleteUser(userId);

            HttpSession session = req.getSession();
            session.setAttribute("success", "User deleted successfully!");
            resp.sendRedirect(req.getContextPath() + "/user-list");
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/user-list");
        }
    }

    private void handleHRDashboard(HttpServletRequest req, HttpServletResponse resp) 
    throws ServletException, IOException {
        try {
            List<UserDto> allUsers = userService.getAllUsers();
            System.out.println("DEBUG: Retrieved " + allUsers.size() + " users from database");
            
            // Calculate user statistics
            int totalUsers = allUsers.size();
            int activeUsers = (int) allUsers.stream().filter(user -> "ACTIVE".equals(user.getStatus())).count();
            int inactiveUsers = totalUsers - activeUsers;
            
            // Count by role
            int adminCount = (int) allUsers.stream().filter(user -> "ADMIN".equals(user.getRole())).count();
            int managerCount = (int) allUsers.stream().filter(user -> "MANAGER".equals(user.getRole())).count();
            int customerCount = (int) allUsers.stream().filter(user -> "CUSTOMER".equals(user.getRole())).count();
            int cashierCount = (int) allUsers.stream().filter(user -> "CASHIER".equals(user.getRole())).count();
            int staffCount = (int) allUsers.stream().filter(user -> "STAFF".equals(user.getRole())).count();
            int hrCount = (int) allUsers.stream().filter(user -> "HR".equals(user.getRole())).count();
            int marketerCount = (int) allUsers.stream().filter(user -> "MARKETER".equals(user.getRole())).count();
            
            System.out.println("DEBUG: Role counts - Admin: " + adminCount + ", Manager: " + managerCount + 
                             ", Customer: " + customerCount + ", Cashier: " + cashierCount + 
                             ", Staff: " + staffCount + ", HR: " + hrCount + ", Marketer: " + marketerCount);
            
            // Get product and order statistics
            int totalProducts = 0;
            int totalOrders = 0; // Mock data for now since OrderService is not implemented
            
            if (productService != null) {
                try {
                    totalProducts = productService.getAllProducts().size();
                } catch (Exception e) {
                    System.out.println("Error getting product count: " + e.getMessage());
                }
            } else {
                System.out.println("ProductService is null, using mock data");
                totalProducts = 25; // Mock data
            }
            
            // Mock order count for now
            totalOrders = 0;
            
            // Generate user registration data (mock for now)
            String userRegistrationData = generateUserRegistrationData();
            
            // Create JSON data for role chart [CUSTOMER, STAFF, CASHIER, MARKETER, HR, ADMIN]
            String roleCountsJson = String.format("[%d,%d,%d,%d,%d,%d]", 
                customerCount, staffCount, cashierCount, marketerCount, hrCount, adminCount);
            
            // Set user statistics
            req.setAttribute("totalUsers", totalUsers);
            req.setAttribute("activeUsers", activeUsers);
            req.setAttribute("inactiveUsers", inactiveUsers);
            req.setAttribute("totalProducts", totalProducts);
            req.setAttribute("totalOrders", totalOrders);
            
            // Set recent users (limit to 7 as requested)
            List<UserDto> recentUsers = allUsers.stream()
                .limit(7)
                .collect(java.util.stream.Collectors.toList());
            req.setAttribute("recentUsers", recentUsers);
            
            System.out.println("DEBUG: Set totalUsers = " + totalUsers + " to request attribute");
            System.out.println("DEBUG: Set recentUsers = " + recentUsers.size() + " users to request attribute");
            
            // Chart data
            req.setAttribute("userRegistrationData", userRegistrationData);
            req.setAttribute("roleCountsJson", roleCountsJson);
            req.setAttribute("adminCount", adminCount);
            req.setAttribute("managerCount", managerCount);
            req.setAttribute("customerCount", customerCount);
            req.setAttribute("cashierCount", cashierCount);
            req.setAttribute("staffCount", staffCount);
            req.setAttribute("hrCount", hrCount);
            req.setAttribute("marketerCount", marketerCount);
            
            req.getRequestDispatcher("WEB-INF/view/dashboard/HRDashboard.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/user-list");
        }
    }
    
    private void handleCreate(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        System.out.println("=== DEBUG: handleCreate called ===");
        
        String fullName = trim(req.getParameter("fullName"));
        String email = trim(req.getParameter("email"));
        String role = trim(req.getParameter("role"));
        String status = trim(req.getParameter("status"));
        String note = trim(req.getParameter("note"));

        System.out.println("DEBUG: fullName=" + fullName);
        System.out.println("DEBUG: email=" + email);
        System.out.println("DEBUG: role=" + role);
        System.out.println("DEBUG: status=" + status);
        System.out.println("DEBUG: note=" + note);

        StringBuilder errors = new StringBuilder();
        
        // Validation
        if (isBlank(fullName)) {
            errors.append("Full name is required. ");
        }
        if (isBlank(email)) {
            errors.append("Email is required. ");
        } else if (!email.matches("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")) {
            errors.append("Email format is invalid. ");
        }
        if (isBlank(role)) {
            errors.append("Role is required. ");
        }
        if (isBlank(status)) {
            errors.append("Status is required. ");
        }

        // Check if email already exists
        if (errors.length() == 0 && userService.existsByEmail(email)) {
            errors.append("Email already exists. ");
        }

        if (errors.length() > 0) {
            req.setAttribute("error", errors.toString());
            // Keep form data for user to retry
            UserDto user = new UserDto();
            user.setFullName(fullName);
            user.setEmail(email);
            user.setRole(role);
            user.setStatus(status);
            user.setNote(note);
            req.setAttribute("user", user);
            req.getRequestDispatcher("WEB-INF/view/user/NewUser.jsp").forward(req, resp);
            return;
        }

        try {
            // Generate random password for HR-created accounts
            String randomPassword = common.PasswordUtils.generateRandomPassword();
            System.out.println("DEBUG: Generated random password for user: " + email);
            
            UserDto newUser = new UserDto();
            newUser.setFullName(fullName);
            newUser.setEmail(email);
            newUser.setPassword(randomPassword); // Random password, will be hashed in service
            newUser.setRole(role);
            newUser.setStatus(status);
            newUser.setNote(note);

            userService.register(newUser);
            
            // Redirect to user list with success message
            resp.sendRedirect(req.getContextPath() + "/user-list?success=User created successfully! Password has been generated and user needs to use 'Forgot Password' to set their password.");
            
        } catch (Exception e) {
            System.out.println("=== DEBUG: Exception in handleCreate ===");
            e.printStackTrace();
            System.out.println("DEBUG: Exception message: " + e.getMessage());
            req.setAttribute("error", "Failed to create user: " + e.getMessage());
            req.getRequestDispatcher("WEB-INF/view/user/NewUser.jsp").forward(req, resp);
        }
    }
    
    private String generateUserRegistrationData() {
        // Generate mock monthly user registration data
        // In real app, you'd query database for actual data
        return "10, 15, 8, 22, 18, 25, 30, 28, 35, 20, 15, 12";
    }

    private void handleToggleStatus(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        String idStr = req.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/user-list");
            return;
        }

        try {
            int userId = Integer.parseInt(idStr);
            UserDto user = userService.getUserById(userId);
            
            if (user != null) {
                // Toggle status
                String newStatus = "ACTIVE".equals(user.getStatus()) ? "INACTIVE" : "ACTIVE";
                user.setStatus(newStatus);
                userService.updateUser(user);
            }
            
            resp.sendRedirect(req.getContextPath() + "/user-list");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/user-list");
        }
    }

    private static String trim(String s){ return s == null ? null : s.trim(); }
    private static boolean isBlank(String s){ return s == null || s.trim().isEmpty(); }
}