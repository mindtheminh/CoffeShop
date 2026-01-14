package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.MultipartConfig;
import service.SettingService;
import service.SettingServiceImpl;
import service.PromotionService;
import service.PromotionServiceImpl;
import service.UserService;
import service.UserServiceImpl;
import service.ProductService;
import service.ProductServiceImpl;
import dao.PromotionDaoJdbc;
import dao.DBConnect;
import jakarta.servlet.annotation.WebServlet;
import model.SettingDto;
import model.PromotionDto;
import model.UserDto;
import model.ProductDto;
import model.OrderDto;
import dao.OrderDaoJdbc;
import service.OrderService;
import service.OrderServiceImpl;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@MultipartConfig
public class SettingControllerServlet extends HttpServlet {

    private SettingService settingService;
    private PromotionService promotionService;
    private UserService userService;
    private ProductService productService;
    private OrderDaoJdbc orderDao;
    private OrderService orderService;

    @Override
    public void init() throws ServletException {
        super.init();
        try {
            settingService = new SettingServiceImpl();
        } catch (Exception e) {
            e.printStackTrace();
        }
        try {
            promotionService = new PromotionServiceImpl(new PromotionDaoJdbc(new DBConnect().getConnection()));
        } catch (Exception e) {
            e.printStackTrace();
            promotionService = null;
        }
        try {
            orderDao = new OrderDaoJdbc();
            orderService = new OrderServiceImpl();
        } catch (Exception e) {
            e.printStackTrace();
            orderDao = null;
            orderService = null;
        }
        try {
            userService = new UserServiceImpl();
        } catch (Exception e) {
            e.printStackTrace();
            userService = null;
        }
        try {
            productService = new ProductServiceImpl();
        } catch (Exception e) {
            e.printStackTrace();
            productService = null;
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String path = req.getServletPath();
        System.out.println("SettingControllerServlet doGet - Path: " + path);

        try {
            switch (path) {
                case "/admin-dashboard":
                    handleAdminDashboard(req, resp);
                    break;
                case "/setting-list":
                    handleList(req, resp);
                    break;
                case "/setting-new":
                    handleNew(req, resp);
                    break;
                case "/setting-detail":
                    handleDetail(req, resp);
                    break;
                case "/setting-edit":
                    handleEdit(req, resp);
                    break;
                default:
                    resp.sendError(HttpServletResponse.SC_NOT_FOUND);
                    break;
            }
        } catch (Exception e) {
            System.err.println("Error in SettingControllerServlet doGet: " + e.getMessage());
            e.printStackTrace();
            req.setAttribute("error", "An error occurred: " + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/view/error/error.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Xóa dòng "String action" không cần thiết
        String path = req.getServletPath();
        System.out.println("SettingControllerServlet doPost - Path: " + path);

        try {
            // Check if this is an update request from setting-detail page
            if ("/setting-detail".equals(path)) {
                String action = req.getParameter("action");
                if ("update".equals(action)) {
                    handleUpdateFromDetail(req, resp);
                    return;
                }
            }
            
            switch (path) {
                case "/setting-new":
                    handleCreate(req, resp);
                    break;

                case "/setting-edit":
                    handleUpdate(req, resp);
                    break;

                case "/setting/toggle-status":
                    handleToggleStatus(req, resp);
                    break;

                case "/setting-delete":
                    handleDelete(req, resp);
                    break;

                default:
                    resp.sendError(HttpServletResponse.SC_NOT_FOUND);
                    break;
            }
        } catch (Exception e) {
            System.err.println("Error in SettingControllerServlet doPost: " + e.getMessage());
            e.printStackTrace();
            req.setAttribute("error", "An error occurred: " + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/view/error/error.jsp").forward(req, resp);
        }
    }

    private void handleAdminDashboard(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            // Initialize defaults
            int totalUsers = 0;
            int activeUsers = 0;
            int inactiveUsers = 0;
            int totalProducts = 0;
            int activeProducts = 0;
            long totalCategories = 0;
            int totalOrders = 0;
            int totalPromotions = 0;
            int activePromotions = 0;
            long totalSettings = 0;
            String roleCountsJson = "[0,0,0,0,0]"; // [Customer, Staff, Cashier, Marketer, HR, Admin] - but we'll use 5 roles

            // Get user statistics
            if (userService != null) {
                try {
                    List<UserDto> allUsers = userService.getAllUsers();
                    totalUsers = allUsers.size();
                    activeUsers = (int) allUsers.stream()
                            .filter(user -> "ACTIVE".equals(user.getStatus()) || "Active".equals(user.getStatus()))
                            .count();
                    inactiveUsers = totalUsers - activeUsers;

                    // Count by role [Admin, HR, Cashier, Marketer, Customer]
                    int adminCount = (int) allUsers.stream().filter(user -> "ADMIN".equals(user.getRole())).count();
                    int hrCount = (int) allUsers.stream().filter(user -> "HR".equals(user.getRole())).count();
                    int cashierCount = (int) allUsers.stream().filter(user -> "CASHIER".equals(user.getRole())).count();
                    int marketerCount = (int) allUsers.stream().filter(user -> "MARKETER".equals(user.getRole())).count();
                    int customerCount = (int) allUsers.stream().filter(user -> "CUSTOMER".equals(user.getRole())).count();

                    // Create JSON data for role chart [Admin, HR, Cashier, Marketer, Customer]
                    roleCountsJson = String.format("[%d,%d,%d,%d,%d]", 
                        adminCount, hrCount, cashierCount, marketerCount, customerCount);
                } catch (Exception e) {
                    System.err.println("Error getting user statistics: " + e.getMessage());
                }
            }

            // Get product statistics
            if (productService != null) {
                try {
                    List<ProductDto> allProducts = productService.getAllProducts();
                    totalProducts = allProducts != null ? allProducts.size() : 0;
                    activeProducts = allProducts != null ? (int) allProducts.stream()
                            .filter(p -> "Activate".equals(p.getStatus()))
                            .count() : 0;
                    totalCategories = allProducts != null ? allProducts.stream()
                            .map(ProductDto::getCategory)
                            .distinct()
                            .count() : 0;
                } catch (Exception e) {
                    System.err.println("Error getting product statistics: " + e.getMessage());
                }
            }

            // Get promotion statistics
            if (promotionService != null) {
                try {
                    List<PromotionDto> allPromotions = promotionService.getAllPromotions();
                    totalPromotions = allPromotions != null ? allPromotions.size() : 0;
                    activePromotions = allPromotions != null ? (int) allPromotions.stream()
                            .filter(p -> {
                                // Check if promotion is active based on status and date
                                try {
                                    LocalDate today = LocalDate.now();
                                    if (p.getStartDate() != null && p.getEndDate() != null) {
                                        // Convert java.util.Date to LocalDate
                                        LocalDate startDate = p.getStartDate().toInstant()
                                                .atZone(ZoneId.systemDefault()).toLocalDate();
                                        LocalDate endDate = p.getEndDate().toInstant()
                                                .atZone(ZoneId.systemDefault()).toLocalDate();
                                        return !today.isBefore(startDate) && !today.isAfter(endDate);
                                    }
                                } catch (Exception e) {
                                    // If date conversion fails, skip this promotion
                                }
                                return false;
                            })
                            .count() : 0;
                } catch (Exception e) {
                    System.err.println("Error getting promotion statistics: " + e.getMessage());
                }
            }

            // Get setting statistics
            if (settingService != null) {
                try {
                    List<SettingDto> allSettings = settingService.getAllSettings();
                    totalSettings = allSettings.size();
                } catch (Exception e) {
                    System.err.println("Error getting setting statistics: " + e.getMessage());
                }
            }

            // Get order statistics - CHỈ LẤY CÁC ĐƠN KHÔNG PHẢI CART (is_cart = FALSE)
            if (orderDao != null) {
                try {
                    // Query directly from database to count only non-cart orders
                    String sql = "SELECT COUNT(*) FROM orders WHERE is_cart = FALSE";
                    DBConnect db = new DBConnect();
                    try (var conn = db.getConnection(); 
                         var ps = conn.prepareStatement(sql); 
                         var rs = ps.executeQuery()) {
                        if (rs.next()) {
                            totalOrders = rs.getInt(1);
                        }
                    }
                    db.close();
                } catch (Exception e) {
                    System.err.println("Error getting order statistics: " + e.getMessage());
                    e.printStackTrace();
                    // Fallback: use getAllOrders and filter
                    try {
                        List<OrderDto> allOrders = orderDao.getAllOrders();
                        totalOrders = allOrders != null ? 
                            (int) allOrders.stream()
                                .filter(order -> {
                                    try {
                                        var orderOpt = orderDao.findById(order.getOrderId());
                                        if (orderOpt.isPresent()) {
                                            return !orderOpt.get().isCart();
                                        }
                                    } catch (Exception ex) {
                                        System.err.println("Error checking cart status for order " + order.getOrderId() + ": " + ex.getMessage());
                                    }
                                    return false;
                                })
                                .count() : 0;
                    } catch (Exception ex2) {
                        System.err.println("Fallback also failed: " + ex2.getMessage());
                    }
                }
            }

            // Set all attributes
            req.setAttribute("totalUsers", totalUsers);
            req.setAttribute("activeUsers", activeUsers);
            req.setAttribute("inactiveUsers", inactiveUsers);
            req.setAttribute("totalProducts", totalProducts);
            req.setAttribute("activeProducts", activeProducts);
            req.setAttribute("totalCategories", totalCategories);
            req.setAttribute("totalOrders", totalOrders);
            req.setAttribute("totalPromotions", totalPromotions);
            req.setAttribute("activePromotions", activePromotions);
            req.setAttribute("totalSettings", totalSettings);
            req.setAttribute("roleCountsJson", roleCountsJson);

            req.getRequestDispatcher("/WEB-INF/view/dashboard/AdminDashboard.jsp").forward(req, resp);

        } catch (Exception e) {
            System.err.println("Error in handleAdminDashboard: " + e.getMessage());
            e.printStackTrace();
            req.setAttribute("error", "Failed to load admin dashboard: " + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/view/dashboard/AdminDashboard.jsp").forward(req, resp);
        }
    }

    private void handleList(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            if (settingService == null) {
                throw new RuntimeException("SettingService not initialized");
            }

            // Get all settings
            List<SettingDto> allSettings = settingService.getAllSettings();

            // Get filter parameters
            String search = trim(req.getParameter("search"));
            String category = trim(req.getParameter("category"));
            String status = trim(req.getParameter("status"));
            String sort = trim(req.getParameter("sort"));
            String sortColumn = trim(req.getParameter("sortColumn"));
            String sortDirection = trim(req.getParameter("sortDirection"));

            // Filter settings
            List<SettingDto> filteredSettings = new ArrayList<>(allSettings);

            // Search filter
            if (search != null && !search.isEmpty()) {
                final String searchLower = search.toLowerCase();
                filteredSettings = filteredSettings.stream()
                    .filter(s -> (s.getName() != null && s.getName().toLowerCase().contains(searchLower)) ||
                                 (s.getValue() != null && s.getValue().toLowerCase().contains(searchLower)))
                    .collect(java.util.stream.Collectors.toList());
            }

            // Category filter
            if (category != null && !category.isEmpty()) {
                filteredSettings = filteredSettings.stream()
                    .filter(s -> category.equals(s.getCategory()))
                    .collect(java.util.stream.Collectors.toList());
            }

            // Status filter
            if (status != null && !status.isEmpty()) {
                filteredSettings = filteredSettings.stream()
                    .filter(s -> status.equalsIgnoreCase(s.getStatus()))
                    .collect(java.util.stream.Collectors.toList());
            }

            // Sorting
            if (sortColumn != null && !sortColumn.isEmpty()) {
                final int colIndex = Integer.parseInt(sortColumn);
                final boolean isAsc = !"desc".equalsIgnoreCase(sortDirection);
                
                filteredSettings.sort((s1, s2) -> {
                    int result = 0;
                    switch (colIndex) {
                        case 0: // ID
                            result = (s1.getSettingId() != null ? s1.getSettingId() : "").compareTo(s2.getSettingId() != null ? s2.getSettingId() : "");
                            break;
                        case 1: // Name
                            result = (s1.getName() != null ? s1.getName() : "").compareTo(s2.getName() != null ? s2.getName() : "");
                            break;
                        case 2: // Value
                            result = (s1.getValue() != null ? s1.getValue() : "").compareTo(s2.getValue() != null ? s2.getValue() : "");
                            break;
                        case 3: // Datatype
                            result = (s1.getDatatype() != null ? s1.getDatatype() : "").compareTo(s2.getDatatype() != null ? s2.getDatatype() : "");
                            break;
                        case 4: // Category
                            result = (s1.getCategory() != null ? s1.getCategory() : "").compareTo(s2.getCategory() != null ? s2.getCategory() : "");
                            break;
                        case 5: // Status
                            result = (s1.getStatus() != null ? s1.getStatus() : "").compareTo(s2.getStatus() != null ? s2.getStatus() : "");
                            break;
                    }
                    return isAsc ? result : -result;
                });
            } else if (sort != null && !sort.isEmpty()) {
                // Legacy sort parameter
                switch (sort) {
                    case "name_asc":
                        filteredSettings.sort((s1, s2) -> (s1.getName() != null ? s1.getName() : "").compareTo(s2.getName() != null ? s2.getName() : ""));
                        break;
                    case "name_desc":
                        filteredSettings.sort((s1, s2) -> (s2.getName() != null ? s2.getName() : "").compareTo(s1.getName() != null ? s1.getName() : ""));
                        break;
                    case "category_asc":
                        filteredSettings.sort((s1, s2) -> (s1.getCategory() != null ? s1.getCategory() : "").compareTo(s2.getCategory() != null ? s2.getCategory() : ""));
                        break;
                    case "status_asc":
                        filteredSettings.sort((s1, s2) -> (s1.getStatus() != null ? s1.getStatus() : "").compareTo(s2.getStatus() != null ? s2.getStatus() : ""));
                        break;
                }
            }

            // Pagination
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

            int totalItems = filteredSettings.size();
            int totalPages = (int) Math.ceil((double) totalItems / pageSize);

            if (currentPage > totalPages && totalPages > 0) {
                currentPage = totalPages;
            }

            int startIndex = (currentPage - 1) * pageSize;
            int endIndex = Math.min(startIndex + pageSize, totalItems);

            List<SettingDto> paginatedSettings = filteredSettings.subList(startIndex, endIndex);

            req.setAttribute("settingList", paginatedSettings);
            req.setAttribute("search", search);
            req.setAttribute("category", category);
            req.setAttribute("status", status);
            req.setAttribute("sort", sort);
            req.setAttribute("sortColumn", sortColumn);
            req.setAttribute("sortDirection", sortDirection);
            req.setAttribute("currentPage", currentPage);
            req.setAttribute("totalPages", totalPages);
            req.setAttribute("totalItems", totalItems);
            req.setAttribute("pageSize", pageSize);

            System.out.println("Settings loaded: " + paginatedSettings.size() + " of " + totalItems);

            req.getRequestDispatcher("/WEB-INF/view/setting/SettingList.jsp").forward(req, resp);

        } catch (Exception e) {
            System.err.println("Error in handleList: " + e.getMessage());
            e.printStackTrace();
            req.setAttribute("error", "Failed to load settings: " + e.getMessage());
            req.setAttribute("settingList", List.of());
            req.setAttribute("currentPage", 1);
            req.setAttribute("totalPages", 1);
            req.setAttribute("totalItems", 0);
            req.setAttribute("pageSize", 10);
            req.getRequestDispatcher("/WEB-INF/view/setting/SettingList.jsp").forward(req, resp);
        }
    }

    private void handleNew(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.getRequestDispatcher("/WEB-INF/view/setting/SettingNew.jsp").forward(req, resp);
    }

    private void handleDetail(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            String id = req.getParameter("id");
            if (id == null || id.trim().isEmpty()) {
                req.setAttribute("error", "Setting ID is required");
                req.getRequestDispatcher("/WEB-INF/view/setting/SettingDetail.jsp").forward(req, resp);
                return;
            }

            if (settingService == null) {
                throw new RuntimeException("SettingService not initialized");
            }

            SettingDto setting = settingService.getSettingById(id);

            if (setting == null) {
                req.setAttribute("error", "Setting not found");
            } else {
                req.setAttribute("setting", setting);
            }

            // Get success/error messages from session
            HttpSession session = req.getSession();
            String success = (String) session.getAttribute("success");
            if (success != null) {
                req.setAttribute("success", success);
                session.removeAttribute("success");
            }

            String error = (String) session.getAttribute("error");
            if (error != null) {
                req.setAttribute("error", error);
                session.removeAttribute("error");
            }

            req.getRequestDispatcher("/WEB-INF/view/setting/SettingDetail.jsp").forward(req, resp);

        } catch (Exception e) {
            System.err.println("Error in handleDetail: " + e.getMessage());
            e.printStackTrace();
            req.setAttribute("error", "Failed to load setting details: " + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/view/setting/SettingDetail.jsp").forward(req, resp);
        }
    }

    private void handleUpdateFromDetail(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            String id = req.getParameter("settingId");
            String status = trim(req.getParameter("status"));
            String note = trim(req.getParameter("note"));

            if (id == null || id.isEmpty()) {
                HttpSession session = req.getSession();
                session.setAttribute("error", "Setting ID is required");
                resp.sendRedirect(req.getContextPath() + "/setting-list");
                return;
            }

            if (settingService == null) {
                throw new RuntimeException("SettingService not initialized");
            }

            // Get existing setting
            SettingDto setting = settingService.getSettingById(id);
            if (setting == null) {
                HttpSession session = req.getSession();
                session.setAttribute("error", "Setting not found");
                resp.sendRedirect(req.getContextPath() + "/setting-list");
                return;
            }

            // Only update status and note - preserve other fields
            setting.setStatus(status != null ? status : setting.getStatus());
            setting.setNote(note != null ? note : "");

            settingService.updateSetting(setting);

            HttpSession session = req.getSession();
            session.setAttribute("success", "Cập nhật cấu hình thành công!");
            resp.sendRedirect(req.getContextPath() + "/setting-detail?id=" + id);

        } catch (Exception e) {
            System.err.println("Error in handleUpdateFromDetail: " + e.getMessage());
            e.printStackTrace();
            HttpSession session = req.getSession();
            session.setAttribute("error", "Lỗi khi cập nhật cấu hình: " + e.getMessage());
            String id = req.getParameter("settingId");
            if (id != null && !id.isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/setting-detail?id=" + id);
            } else {
                resp.sendRedirect(req.getContextPath() + "/setting-list");
            }
        }
    }

    private void handleEdit(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            // 1️⃣ Lấy ID từ request
            String id = req.getParameter("id");
            if (id == null || id.trim().isEmpty()) {
                req.setAttribute("error", "⚠️ Thiếu ID cấu hình.");
                forwardToErrorPage(req, resp);
                return;
            }

            // 2️⃣ Kiểm tra service
            if (settingService == null) {
                throw new IllegalStateException("SettingService chưa được khởi tạo");
            }

            // 3️⃣ Lấy dữ liệu cấu hình
            SettingDto setting = settingService.getSettingById(id.trim());

            if (setting == null) {
                req.setAttribute("error", "⚠️ Không tìm thấy cấu hình với ID: " + id);
                setting = new SettingDto(); // tạo object trống để tránh null
            }

            // 5️⃣ Convert LocalDateTime -> Date để JSP dùng fmt:formatDate
            if (setting.getCreatedAt() != null) {
                Date createdAtDate = Date.from(setting.getCreatedAt()
                        .atZone(ZoneId.systemDefault()).toInstant());
                req.setAttribute("createdAtDate", createdAtDate);
            }

            if (setting.getUpdatedAt() != null) {
                Date updatedAtDate = Date.from(setting.getUpdatedAt()
                        .atZone(ZoneId.systemDefault()).toInstant());
                req.setAttribute("updatedAtDate", updatedAtDate);
            }

            // 6️⃣ Gửi dữ liệu sang JSP
            req.setAttribute("setting", setting);
            req.getRequestDispatcher("/WEB-INF/view/setting/SettingEdit.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace(System.err);
            req.setAttribute("error", "Đã xảy ra lỗi khi tải cấu hình: " + e.getMessage());
            forwardToErrorPage(req, resp);
        }
    }

    /**
     * Helper method để forward tới trang lỗi mặc định.
     */
    private void forwardToErrorPage(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/view/setting/SettingEdit.jsp").forward(req, resp);
    }

    private void handleCreate(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            String name = req.getParameter("name");
            String value = req.getParameter("value");
            String datatype = req.getParameter("datatype");
            String category = req.getParameter("category");
            String status = req.getParameter("status");
            String description = req.getParameter("description");
            String note = req.getParameter("note");
            String updatedByStr = req.getParameter("updatedBy");

            // Validation
            if (isBlank(name) || isBlank(value) || isBlank(datatype) || isBlank(category) || isBlank(status)) {
                req.setAttribute("error", "All required fields must be filled");
                req.setAttribute("name", name);
                req.setAttribute("value", value);
                req.setAttribute("datatype", datatype);
                req.setAttribute("category", category);
                req.setAttribute("status", status);
                req.setAttribute("description", description);
                req.getRequestDispatcher("/WEB-INF/view/setting/SettingNew.jsp").forward(req, resp);
                return;
            }

            // Parse updatedBy (int)
            Integer updatedBy = null;
            if (updatedByStr != null && !updatedByStr.isEmpty()) {
                try {
                    updatedBy = Integer.parseInt(updatedByStr);
                } catch (NumberFormatException e) {
                    System.err.println("Invalid updatedBy value: " + updatedByStr);
                }
            }

            // Create SettingDto
            SettingDto settingDto = new SettingDto();
            settingDto.setName(trim(name));
            settingDto.setValue(trim(value));
            settingDto.setDatatype(trim(datatype));
            settingDto.setCategory(trim(category));
            settingDto.setStatus(trim(status));
            settingDto.setDescription(trim(description));
            settingDto.setNote(note != null ? trim(note) : "");
            settingDto.setUpdatedBy(updatedBy);

            // Insert setting
            settingService.insertSetting(settingDto);

            req.setAttribute("success", "Setting created successfully");
            resp.sendRedirect(req.getContextPath() + "/setting-list");

        } catch (Exception e) {
            System.err.println("Error in handleCreate: " + e.getMessage());
            e.printStackTrace();
            req.setAttribute("error", "Failed to create setting: " + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/view/setting/SettingNew.jsp").forward(req, resp);
        }
    }

    private void handleUpdate(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            String id = req.getParameter("settingId");
            String name = req.getParameter("name");
            String value = req.getParameter("value");
            String datatype = req.getParameter("datatype");
            String category = req.getParameter("category");
            String status = req.getParameter("status");
            String description = req.getParameter("description");
            String note = req.getParameter("note");
            String updatedBy = req.getParameter("updatedBy");

            // Validation
            if (isBlank(id) || isBlank(name) || isBlank(value) || isBlank(datatype) || isBlank(category) || isBlank(status)) {
                req.setAttribute("error", "All required fields must be filled");
                req.getRequestDispatcher("/WEB-INF/view/setting/SettingEdit.jsp").forward(req, resp);
                return;
            }

            // Create SettingDto
            SettingDto settingDto = new SettingDto();
            settingDto.setSettingId(id);
            settingDto.setName(trim(name));
            settingDto.setValue(trim(value));
            settingDto.setDatatype(trim(datatype));
            settingDto.setCategory(trim(category));
            settingDto.setStatus(trim(status));
            settingDto.setDescription(trim(description));
            settingDto.setNote(note != null ? trim(note) : "");
            settingDto.setUpdatedBy(updatedBy != null && !updatedBy.isEmpty() ? Integer.parseInt(updatedBy) : null);

            // Update setting
            settingService.updateSetting(settingDto);

            req.setAttribute("success", "Setting updated successfully");
            resp.sendRedirect(req.getContextPath() + "/setting-detail?id=" + id);

        } catch (Exception e) {
            System.err.println("Error in handleUpdate: " + e.getMessage());
            e.printStackTrace();
            req.setAttribute("error", "Failed to update setting: " + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/view/setting/SettingEdit.jsp").forward(req, resp);
        }
    }

    private void handleToggleStatus(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            String id = req.getParameter("id");
            String status = req.getParameter("status");

            if (isBlank(id) || isBlank(status)) {
                req.setAttribute("error", "Setting ID and status are required");
                resp.sendRedirect(req.getContextPath() + "/setting-list");
                return;
            }

            SettingDto setting = settingService.getSettingById(id);

            if (setting == null) {
                req.setAttribute("error", "Setting not found");
                resp.sendRedirect(req.getContextPath() + "/setting-list");
                return;
            }

            // Update status
            setting.setStatus(status);
            settingService.updateSetting(setting);

            String action = "ACTIVE".equals(status) ? "activated" : "deactivated";
            req.setAttribute("success", "Setting " + action + " successfully");
            resp.sendRedirect(req.getContextPath() + "/setting-list");

        } catch (Exception e) {
            System.err.println("Error in handleToggleStatus: " + e.getMessage());
            e.printStackTrace();
            req.setAttribute("error", "Failed to toggle setting status: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/setting-list");
        }
    }

    private void handleDelete(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            // SỬA 1: Lấy đúng tên param "settingId"
            String id = req.getParameter("settingId");

            // SỬA 2: Xoá bỏ việc kiểm tra "action" không cần thiết.
            // Servlet này chỉ có một nhiệm vụ là xoá.
            if (isBlank(id)) {
                // Nếu không có ID, chỉ cần quay về
                resp.sendRedirect(req.getContextPath() + "/setting-list");
                return;
            }

            settingService.deleteSetting(id);

            // SỬA 3: Dùng SESSION (Flash Message) để lưu thông báo
            req.getSession().setAttribute("success", "Setting deleted successfully");
            resp.sendRedirect(req.getContextPath() + "/setting-list");

        } catch (Exception e) {
            System.err.println("Error in handleDelete: " + e.getMessage());
            e.printStackTrace();

            // SỬA 3 (Tương tự): Dùng SESSION cho thông báo lỗi
            req.getSession().setAttribute("error", "Failed to delete setting: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/setting-list");
        }
    }

    private boolean isBlank(String str) {
        return str == null || str.trim().isEmpty();
    }

    private String trim(String str) {
        return str != null ? str.trim() : null;
    }
}
