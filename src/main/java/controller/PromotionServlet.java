package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import service.PromotionService;
import service.PromotionServiceImpl;
import dao.PromotionDaoJdbc;
import dao.DBConnect;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.Date;
import model.PromotionDto;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;
import java.sql.Connection;
import service.ProductService;
import service.ProductServiceImpl;
import model.ProductDto;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import java.util.Arrays;
import java.time.format.DateTimeParseException;
import java.util.stream.Collectors;

/**
 * PromotionServlet - Controller for Promotion management
 * @author Asus
 */
public class PromotionServlet extends HttpServlet {
   
    private PromotionService promotionService;
    private PromotionDaoJdbc promotionDao;

    // Khoi tao PromotionService va DAO
    @Override
    public void init() throws ServletException {
        super.init();
        try {
            DBConnect dbConnect = new DBConnect();
            Connection connection = dbConnect.getConnection();
            if (connection == null) {
                throw new RuntimeException("Failed to get database connection");
            }
            promotionDao = new PromotionDaoJdbc(connection);
            promotionService = new PromotionServiceImpl(promotionDao);
            System.out.println("PromotionServlet initialized successfully");
        } catch (Exception e) {
            System.err.println("Error initializing PromotionServlet: " + e.getMessage());
            e.printStackTrace();
            throw new ServletException("Failed to initialize PromotionServlet", e);
        }
    }

    // Xu ly cac request GET cho module khuyen mai
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
    throws ServletException, IOException {
        String path = req.getRequestURI().substring(req.getContextPath().length());

        System.out.println("PromotionServlet GET: " + path);

        switch (path) {
            case "/promotion-list":
                handleList(req, resp);
                break;
            case "/promotion-detail":
                handleDetail(req, resp);
                break;
            case "/promotion-new":
                handleNew(req, resp);
                break;
            case "/promotion-edit":
                handleEdit(req, resp);
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/promotion-list");
                break;
        }
    }

    // Xu ly cac request POST cho module khuyen mai
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getRequestURI().substring(req.getContextPath().length());

        System.out.println("PromotionServlet POST: " + path);

        switch (path) {
            case "/promotion-new":
                handleCreate(req, resp);
                break;
            case "/promotion-edit":
                handleUpdate(req, resp);
                break;
            case "/promotion-delete":
                handleDelete(req, resp);
                break;
            case "/promotion/toggle-status":
                handleToggleStatus(req, resp);
                break;
            case "/promotion/update-details":
                handleUpdateDetails(req, resp);
                break;
            case "/promotion/update-value":
                handleUpdateValue(req, resp);
                break;
            case "/promotion/update-dates":
                handleUpdateDates(req, resp);
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/promotion-list");
                break;
        }
    }

    // [GET] Show promotion list
    // Hien danh sach khuyen mai kem loc sap xep va phan trang
    private void handleList(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            List<PromotionDto> allPromotions = promotionService.getAllPromotions();
            
            // Apply filters
            String search = req.getParameter("search");
            String status = req.getParameter("status");
            String type = req.getParameter("type");
            
            // Get sorting parameters
            String sortColumn = req.getParameter("sortColumn");
            String sortDirection = req.getParameter("sortDirection");
            
            List<PromotionDto> filteredPromotions = allPromotions;
            
            // Search filter
            if (search != null && !search.trim().isEmpty()) {
                String searchLower = search.toLowerCase().trim();
                filteredPromotions = filteredPromotions.stream()
                        .filter(p -> (p.getName() != null && p.getName().toLowerCase().contains(searchLower))
                                || (p.getCode() != null && p.getCode().toLowerCase().contains(searchLower))
                                || (p.getDescription() != null && p.getDescription().toLowerCase().contains(searchLower)))
                        .collect(Collectors.toList());
            }
            
            // Status filter
            if (status != null && !status.trim().isEmpty()) {
                filteredPromotions = filteredPromotions.stream()
                        .filter(p -> p.getStatus() != null && p.getStatus().equals(status))
                        .collect(Collectors.toList());
            }
            
            // Type filter
            if (type != null && !type.trim().isEmpty()) {
                filteredPromotions = filteredPromotions.stream()
                        .filter(p -> p.getType() != null && p.getType().equals(type))
                        .collect(Collectors.toList());
            }
            
            // Apply sorting to all filtered data
            if (sortColumn != null && !sortColumn.trim().isEmpty() && sortDirection != null && !sortDirection.trim().isEmpty()) {
                final String finalSortColumn = sortColumn.trim();
                final boolean ascending = "asc".equalsIgnoreCase(sortDirection.trim());
                
                filteredPromotions = filteredPromotions.stream().sorted((p1, p2) -> {
                    int result = 0;
                    switch (finalSortColumn) {
                        case "0": // ID
                            result = (p1.getPromotionId() != null && p2.getPromotionId() != null) 
                                    ? p1.getPromotionId().compareTo(p2.getPromotionId()) : 0;
                            break;
                        case "1": // Code
                            result = (p1.getCode() != null && p2.getCode() != null) 
                                    ? p1.getCode().compareTo(p2.getCode()) : 0;
                            break;
                        case "2": // Name
                            result = (p1.getName() != null && p2.getName() != null) 
                                    ? p1.getName().compareTo(p2.getName()) : 0;
                            break;
                        case "3": // Type
                            result = (p1.getType() != null && p2.getType() != null) 
                                    ? p1.getType().compareTo(p2.getType()) : 0;
                            break;
                        case "4": // Value
                            result = (p1.getValue() != null && p2.getValue() != null) 
                                    ? p1.getValue().compareTo(p2.getValue()) : 0;
                            break;
                        case "5": // Status
                            result = (p1.getStatus() != null && p2.getStatus() != null) 
                                    ? p1.getStatus().compareTo(p2.getStatus()) : 0;
                            break;
                        case "6": // Start Date
                            if (p1.getStartDate() != null && p2.getStartDate() != null) {
                                result = p1.getStartDate().compareTo(p2.getStartDate());
                            } else if (p1.getStartDate() != null) result = 1;
                            else if (p2.getStartDate() != null) result = -1;
                            break;
                        case "7": // End Date
                            if (p1.getEndDate() != null && p2.getEndDate() != null) {
                                result = p1.getEndDate().compareTo(p2.getEndDate());
                            } else if (p1.getEndDate() != null) result = 1;
                            else if (p2.getEndDate() != null) result = -1;
                            break;
                        default:
                            result = 0;
                    }
                    return ascending ? result : -result;
                }).collect(java.util.stream.Collectors.toList());
            }
            
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
            
            int totalItems = filteredPromotions.size();
            int totalPages = (int) Math.ceil((double) totalItems / pageSize);
            
            if (currentPage > totalPages && totalPages > 0) {
                currentPage = totalPages;
            }
            
            // Get promotions for current page
            int startIndex = (currentPage - 1) * pageSize;
            int endIndex = Math.min(startIndex + pageSize, totalItems);
            
            List<PromotionDto> paginatedPromotions = filteredPromotions.subList(startIndex, endIndex);
            
            req.setAttribute("promotionList", paginatedPromotions);
            req.setAttribute("search", search);
            req.setAttribute("status", status);
            req.setAttribute("type", type);
            req.setAttribute("sortColumn", sortColumn);
            req.setAttribute("sortDirection", sortDirection);
            req.setAttribute("currentPage", currentPage);
            req.setAttribute("totalPages", totalPages);
            req.setAttribute("totalItems", totalItems);
            req.setAttribute("pageSize", pageSize);
            req.setAttribute("pageTitle", "Promotion List");
            
            req.getRequestDispatcher("WEB-INF/view/promotion/PromotionList.jsp").forward(req, resp);
        } catch (Exception e) {
            System.err.println("Error in handleList: " + e.getMessage());
            e.printStackTrace();
            req.setAttribute("error", "Error loading promotions: " + e.getMessage());
            req.setAttribute("promotionList", List.of());
            req.setAttribute("currentPage", 1);
            req.setAttribute("totalPages", 1);
            req.setAttribute("totalItems", 0);
            req.getRequestDispatcher("WEB-INF/view/promotion/PromotionList.jsp").forward(req, resp);
        }
    }

    // [GET] Show promotion details
    // Hien chi tiet mot khuyen mai
    private void handleDetail(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String promotionId = req.getParameter("id");
        
        if (promotionId == null || promotionId.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/promotion-list");
            return;
        }

        try {
            PromotionDto promotion = promotionService.getPromotionById(promotionId);
            if (promotion == null) {
                resp.sendRedirect(req.getContextPath() + "/promotion-list");
                return;
            }
            
            req.setAttribute("promotion", promotion);
            req.setAttribute("pageTitle", "Promotion Details");
            
            // Load products for product selection
            try {
                ProductService productService = new ProductServiceImpl();
                List<ProductDto> allProducts = productService.getAllProducts();
                req.setAttribute("allProducts", allProducts);
                
                // Load selected product IDs for this promotion
                List<String> selectedProductIds = promotionDao.getProductIdsByPromotionId(promotionId);
                req.setAttribute("selectedProductIds", selectedProductIds);
            } catch (Exception e) {
                System.err.println("Error loading products: " + e.getMessage());
                req.setAttribute("allProducts", new ArrayList<>());
                req.setAttribute("selectedProductIds", new ArrayList<>());
            }
            
            req.getRequestDispatcher("WEB-INF/view/promotion/PromotionDetails.jsp").forward(req, resp);
        } catch (Exception e) {
            System.err.println("Error in handleDetail: " + e.getMessage());
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/promotion-list");
        }
    }

    // [GET] Show new promotion form
    // Hien form tao khuyen mai moi
    private void handleNew(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        PromotionDto promotion = (PromotionDto) req.getAttribute("promotionDto");
        if (promotion == null) {
            promotion = createDefaultPromotionDto();
        }
        @SuppressWarnings("unchecked")
        List<String> selectedIds = (List<String>) req.getAttribute("selectedProductIds");
        if (selectedIds == null) {
            selectedIds = new ArrayList<>();
        }
        preparePromotionForm(req, promotion, selectedIds);
        req.getRequestDispatcher("WEB-INF/view/promotion/PromotionNew.jsp").forward(req, resp);
    }

    // [POST] Create new promotion
    // Xu ly tao moi khuyen mai
    private void handleCreate(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        PromotionDto promotion = new PromotionDto();
        Map<String, String> fieldErrors = new HashMap<>();
        List<String> selectedIds = parseSelectedProductIds(req);

        String name = trim(req.getParameter("name"));
        if (name == null || name.isEmpty()) {
            fieldErrors.put("name", "Tên khuyến mãi là bắt buộc.");
        } else {
            promotion.setName(name);
        }

        String code = trim(req.getParameter("code"));
        if (code == null || code.isEmpty()) {
            fieldErrors.put("code", "Mã khuyến mãi là bắt buộc.");
        } else {
            code = code.toUpperCase();
            PromotionDto existing = promotionService.getPromotionByCode(code);
            if (existing != null) {
                fieldErrors.put("code", "Mã khuyến mãi đã tồn tại trong hệ thống.");
            }
            promotion.setCode(code);
        }

        String type = trim(req.getParameter("type"));
        if (type == null || type.isEmpty()) {
            fieldErrors.put("type", "Vui lòng chọn loại khuyến mãi.");
        }
        promotion.setType(type);

        String valueStr = trim(req.getParameter("value"));
        if ("free_shipping".equals(type)) {
            promotion.setValue(BigDecimal.ZERO);
        } else {
            if (valueStr == null || valueStr.isEmpty()) {
                fieldErrors.put("value", "Giá trị khuyến mãi là bắt buộc.");
            } else {
                try {
                    BigDecimal value = new BigDecimal(valueStr);
                    if (value.compareTo(BigDecimal.ZERO) <= 0) {
                        fieldErrors.put("value", "Giá trị khuyến mãi phải lớn hơn 0.");
                    } else if ("percentage".equals(type) && value.compareTo(new BigDecimal("100")) > 0) {
                        fieldErrors.put("value", "Giá trị phần trăm phải ≤ 100.");
                    } else {
                    promotion.setValue(value);
                    }
                } catch (NumberFormatException e) {
                    fieldErrors.put("value", "Giá trị khuyến mãi không hợp lệ.");
                }
            }
        }

        String minOrderValueStr = trim(req.getParameter("minOrderValue"));
        if (minOrderValueStr != null && !minOrderValueStr.isEmpty()) {
            try {
                BigDecimal minOrder = new BigDecimal(minOrderValueStr);
                if (minOrder.compareTo(BigDecimal.ZERO) < 0) {
                    fieldErrors.put("minOrderValue", "Đơn hàng tối thiểu phải ≥ 0.");
                } else {
                    promotion.setMinOrderValue(minOrder);
                }
                } catch (NumberFormatException e) {
                fieldErrors.put("minOrderValue", "Đơn hàng tối thiểu không hợp lệ.");
            }
        }

        String status = trim(req.getParameter("status"));
        if (status == null || status.isEmpty()) {
            fieldErrors.put("status", "Vui lòng chọn trạng thái.");
        } else {
            promotion.setStatus(status);
        }

        String description = trim(req.getParameter("description"));
        if (description == null || description.isEmpty()) {
            fieldErrors.put("description", "Mô tả khuyến mãi là bắt buộc.");
                        } else {
            promotion.setDescription(description);
        }

        String note = trim(req.getParameter("note"));
        promotion.setNote(note);

        String startDateStr = trim(req.getParameter("startDate"));
        String endDateStr = trim(req.getParameter("endDate"));
        java.sql.Date startDate = null;
        java.sql.Date endDate = null;
        if (startDateStr == null || startDateStr.isEmpty()) {
            fieldErrors.put("startDate", "Ngày bắt đầu là bắt buộc.");
        } else {
            try {
                startDate = java.sql.Date.valueOf(LocalDate.parse(startDateStr));
                promotion.setStartDate(startDate);
            } catch (DateTimeParseException e) {
                fieldErrors.put("startDate", "Ngày bắt đầu không hợp lệ.");
            }
        }
        if (endDateStr == null || endDateStr.isEmpty()) {
            fieldErrors.put("endDate", "Ngày kết thúc là bắt buộc.");
                        } else {
            try {
                endDate = java.sql.Date.valueOf(LocalDate.parse(endDateStr));
                promotion.setEndDate(endDate);
            } catch (DateTimeParseException e) {
                fieldErrors.put("endDate", "Ngày kết thúc không hợp lệ.");
            }
        }
        if (startDate != null && endDate != null && startDate.after(endDate)) {
            fieldErrors.put("endDate", "Ngày kết thúc phải sau hoặc bằng ngày bắt đầu.");
        }

        String scope = trim(req.getParameter("productScope"));
        boolean applyToAll = scope == null || !"selected".equals(scope);
        promotion.setApplyToAll(applyToAll);
        if (!applyToAll && selectedIds.isEmpty()) {
            fieldErrors.put("productScope", "Vui lòng chọn ít nhất một sản phẩm áp dụng.");
        }

        if (!fieldErrors.isEmpty()) {
            req.setAttribute("fieldErrors", fieldErrors);
            req.setAttribute("errorMessage", "Một số trường còn thiếu hoặc không hợp lệ.");
            preparePromotionForm(req, promotion, selectedIds);
                    req.getRequestDispatcher("WEB-INF/view/promotion/PromotionNew.jsp").forward(req, resp);
                    return;
        }

        try {
            String promotionId = promotionService.createPromotion(promotion);
            if (promotionId != null && !promotion.getApplyToAll() && !selectedIds.isEmpty()) {
                promotionDao.addProductsToPromotion(promotionId, selectedIds);
            }
            if (promotionId != null) {
                req.setAttribute("successMessage", "Thêm khuyến mãi thành công! Dữ liệu đã được lưu vào hệ thống.");
                req.setAttribute("fieldErrors", null);
                preparePromotionForm(req, createDefaultPromotionDto(), Collections.emptyList());
            } else {
                req.setAttribute("errorMessage", "Thêm khuyến mãi thất bại! Đã có lỗi xảy ra trong quá trình lưu dữ liệu.");
                req.setAttribute("fieldErrors", fieldErrors);
                preparePromotionForm(req, promotion, selectedIds);
            }
        } catch (Exception e) {
            System.err.println("=== ERROR IN handleCreate ===");
            e.printStackTrace();
            String lowerMsg = e.getMessage() != null ? e.getMessage().toLowerCase() : "";
            if (lowerMsg.contains("duplicate") || lowerMsg.contains("unique") || lowerMsg.contains("constraint")) {
                fieldErrors.put("code", "Mã khuyến mãi đã tồn tại. Vui lòng nhập mã khác.");
                req.setAttribute("errorMessage", "Không thể lưu vì mã khuyến mãi đã tồn tại.");
            } else {
                req.setAttribute("errorMessage", "Thêm khuyến mãi thất bại! Đã có lỗi xảy ra trong quá trình lưu dữ liệu.");
            }
            req.setAttribute("fieldErrors", fieldErrors);
            preparePromotionForm(req, promotion, selectedIds);
        }

        req.getRequestDispatcher("WEB-INF/view/promotion/PromotionNew.jsp").forward(req, resp);
    }

    // Chuan bi du lieu cho form khuyen mai (san pham duoc chon va danh muc)
    private void preparePromotionForm(HttpServletRequest req, PromotionDto promotion, List<String> selectedIds) {
        List<String> safeIds = selectedIds != null ? new ArrayList<>(selectedIds) : new ArrayList<>();
        req.setAttribute("promotionDto", promotion);
        req.setAttribute("selectedProductIds", safeIds);
        req.setAttribute("selectedProductIdsCsv", safeIds.isEmpty() ? "" : String.join(",", safeIds));
        try {
            ProductService productService = new ProductServiceImpl();
            List<ProductDto> allProducts = productService.getAllProducts();
            req.setAttribute("allProducts", allProducts);
            List<ProductDto> selectedDetails = allProducts.stream()
                    .filter(p -> safeIds.contains(p.getProductId()))
                    .collect(Collectors.toList());
            req.setAttribute("selectedProductDetails", selectedDetails);
        } catch (Exception e) {
            System.err.println("Error loading products: " + e.getMessage());
            req.setAttribute("allProducts", new ArrayList<>());
            req.setAttribute("selectedProductDetails", new ArrayList<>());
        }
        req.setAttribute("pageTitle", "Create New Promotion");
    }

    // Tach danh sach ma san pham duoc chon tu request
    private List<String> parseSelectedProductIds(HttpServletRequest req) {
        String raw = req.getParameter("selectedProductIds");
        if (raw == null || raw.trim().isEmpty()) {
            return new ArrayList<>();
        }
        return Arrays.stream(raw.split(","))
                .map(String::trim)
                .filter(s -> !s.isEmpty())
                .collect(Collectors.toList());
    }

    // Tao doi tuong DTO mac dinh cho form khuyen mai
    private PromotionDto createDefaultPromotionDto() {
        PromotionDto dto = new PromotionDto();
        dto.setApplyToAll(Boolean.TRUE);
        dto.setStatus("Activate");
        return dto;
    }

    private String trim(String value) {
        return value == null ? null : value.trim();
    }

    // [GET] Show edit promotion form - Redirect to detail page with edit mode
    // Chuyen huong sang trang chi tiet o che do edit
    private void handleEdit(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String promotionId = req.getParameter("id");
        
        if (promotionId == null || promotionId.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/promotion-list");
            return;
        }

        // Redirect to detail page with edit mode
        resp.sendRedirect(req.getContextPath() + "/promotion-detail?id=" + promotionId + "&mode=edit");
    }

    // [POST] Update promotion
    // Cap nhat thong tin khuyen mai tu trang chi tiet
    private void handleUpdate(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            String promotionId = req.getParameter("promotionId");
            if (promotionId == null || promotionId.trim().isEmpty()) {
                req.getSession().setAttribute("error", "❌ Không tìm thấy ID khuyến mãi");
                resp.sendRedirect(req.getContextPath() + "/promotion-list");
                return;
            }
            
            PromotionDto promotion = promotionService.getPromotionById(promotionId);
            if (promotion == null) {
                req.getSession().setAttribute("error", "❌ Không tìm thấy khuyến mãi với ID: " + promotionId);
                resp.sendRedirect(req.getContextPath() + "/promotion-list");
                return;
            }
            
            // Update promotion data
            promotion.setName(req.getParameter("name"));
            promotion.setType(req.getParameter("type"));
            promotion.setDescription(req.getParameter("description"));
            
            String valueStr = req.getParameter("value");
            if (valueStr != null && !valueStr.trim().isEmpty()) {
                try {
                    promotion.setValue(new BigDecimal(valueStr.trim()));
                } catch (NumberFormatException e) {
                    req.getSession().setAttribute("error", "❌ Giá trị khuyến mãi không hợp lệ");
                    resp.sendRedirect(req.getContextPath() + "/promotion-detail?id=" + promotionId);
                    return;
                }
            }
            
            String minOrderValueStr = req.getParameter("minOrderValue");
            if (minOrderValueStr != null && !minOrderValueStr.trim().isEmpty()) {
                try {
                    promotion.setMinOrderValue(new BigDecimal(minOrderValueStr.trim()));
                } catch (NumberFormatException e) {
                    req.getSession().setAttribute("error", "❌ Đơn hàng tối thiểu không hợp lệ");
                    resp.sendRedirect(req.getContextPath() + "/promotion-detail?id=" + promotionId);
                    return;
                }
            }
            
            String startDateStr = req.getParameter("startDate");
            if (startDateStr != null && !startDateStr.trim().isEmpty()) {
                try {
                Date sd = java.sql.Date.valueOf(LocalDate.parse(startDateStr.trim()));
                promotion.setStartDate(sd);
                } catch (Exception e) {
                    req.getSession().setAttribute("error", "❌ Định dạng ngày bắt đầu không hợp lệ");
                    resp.sendRedirect(req.getContextPath() + "/promotion-detail?id=" + promotionId);
                    return;
                }
            }
            
            String endDateStr = req.getParameter("endDate");
            if (endDateStr != null && !endDateStr.trim().isEmpty()) {
                try {
                Date ed = java.sql.Date.valueOf(LocalDate.parse(endDateStr.trim()));
                promotion.setEndDate(ed);
                } catch (Exception e) {
                    req.getSession().setAttribute("error", "❌ Định dạng ngày kết thúc không hợp lệ");
                    resp.sendRedirect(req.getContextPath() + "/promotion-detail?id=" + promotionId);
                    return;
                }
            }
            
            promotion.setStatus(req.getParameter("status"));
            promotion.setCode(req.getParameter("code"));
            
            // Handle product scope (all or selected)
            String productScope = req.getParameter("productScope");
            boolean applyToAll = "all".equals(productScope);
            promotion.setApplyToAll(applyToAll);
            
            promotion.setNote(req.getParameter("note"));
            
            String maxUsesStr = req.getParameter("maxUses");
            if (maxUsesStr != null && !maxUsesStr.trim().isEmpty()) {
                try {
                    promotion.setMaxUses(Integer.parseInt(maxUsesStr.trim()));
                } catch (NumberFormatException e) {
                    req.getSession().setAttribute("error", "❌ Số lần sử dụng tối đa không hợp lệ");
                    resp.sendRedirect(req.getContextPath() + "/promotion-detail?id=" + promotionId);
                    return;
                }
            }
            
            // Update promotion
            System.out.println("Attempting to update promotion: " + promotionId);
            System.out.println("Promotion data: " + promotion.toString());
            System.out.println("ProductScope: " + productScope);
            
            boolean success = promotionService.updatePromotion(promotion);
            
            // Update product associations
            if (success) {
                if ("selected".equals(productScope)) {
                    String selectedProductIdsStr = req.getParameter("selectedProductIds");
                    if (selectedProductIdsStr != null && !selectedProductIdsStr.trim().isEmpty()) {
                        try {
                            List<String> productIds = new ArrayList<>();
                            String[] ids = selectedProductIdsStr.split(",");
                            for (String id : ids) {
                                String trimmed = id.trim();
                                if (!trimmed.isEmpty()) {
                                    productIds.add(trimmed);
                                }
                            }
                            promotionDao.addProductsToPromotion(promotionId, productIds);
                            System.out.println("Updated " + productIds.size() + " products for promotion " + promotionId);
                        } catch (Exception e) {
                            System.err.println("Error updating products for promotion: " + e.getMessage());
                            e.printStackTrace();
                        }
                    }
                } else {
                    // If applyToAll is true, clear promotion_products
                    try {
                        promotionDao.deleteProductsFromPromotion(promotionId);
                    } catch (Exception e) {
                        System.err.println("Error clearing products from promotion: " + e.getMessage());
                    }
                }
            }
            
            System.out.println("Update result: " + success);
            
            if (success) {
                req.getSession().setAttribute("success", "✅ Cập nhật khuyến mãi thành công!");
                resp.sendRedirect(req.getContextPath() + "/promotion-detail?id=" + promotionId);
            } else {
                req.getSession().setAttribute("error", "❌ Không thể cập nhật khuyến mãi. Vui lòng thử lại!");
                resp.sendRedirect(req.getContextPath() + "/promotion-detail?id=" + promotionId);
            }
        } catch (Exception e) {
            System.err.println("Error in handleUpdate: " + e.getMessage());
            e.printStackTrace();
            req.getSession().setAttribute("error", "❌ Lỗi khi cập nhật khuyến mãi: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/promotion-detail?id=" + req.getParameter("promotionId"));
        }
    }

    // [POST] Delete promotion
    // Xoa khuyen mai
    private void handleDelete(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            String promotionId = req.getParameter("id");
            if (promotionId == null || promotionId.trim().isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/promotion-list");
                return;
            }
            
            boolean success = promotionService.deletePromotion(promotionId);
            
            if (success) {
                req.getSession().setAttribute("success", "Promotion deleted successfully!");
            } else {
                req.getSession().setAttribute("error", "Failed to delete promotion");
            }
            
            resp.sendRedirect(req.getContextPath() + "/promotion-list");
        } catch (Exception e) {
            System.err.println("Error in handleDelete: " + e.getMessage());
            e.printStackTrace();
            req.getSession().setAttribute("error", "Error deleting promotion: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/promotion-list");
        }
    }

    // [POST] Toggle promotion status
    // Dao trang thai hoat dong cua khuyen mai
    private void handleToggleStatus(HttpServletRequest req, HttpServletResponse resp)
    throws ServletException, IOException {
        try {
            String promotionId = req.getParameter("promotionId");
            String newStatus = req.getParameter("status");
            
            if (promotionId == null || promotionId.trim().isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/promotion-list");
                return;
            }
            
            PromotionDto promotion = promotionService.getPromotionById(promotionId);
            if (promotion == null) {
                resp.sendRedirect(req.getContextPath() + "/promotion-list");
                return;
            }
            
            // Set the new status
            promotion.setStatus(newStatus);
            
            boolean success = promotionService.updatePromotion(promotion);
            
            if (success) {
                req.getSession().setAttribute("success", "Trạng thái khuyến mãi đã được cập nhật thành " + newStatus + "!");
            } else {
                req.getSession().setAttribute("error", "Không thể cập nhật trạng thái khuyến mãi");
            }
            
            resp.sendRedirect(req.getContextPath() + "/promotion-list");
        } catch (Exception e) {
            System.err.println("Error in handleToggleStatus: " + e.getMessage());
            e.printStackTrace();
            req.getSession().setAttribute("error", "Lỗi khi cập nhật trạng thái khuyến mãi: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/promotion-list");
        }
    }

    // [POST] Update promotion details
    // Cap nhat ten ma va mo ta khuyen mai
    private void handleUpdateDetails(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            String promotionId = req.getParameter("promotionId");
            String name = req.getParameter("name");
            String code = req.getParameter("code");
            String description = req.getParameter("description");
            
            if (promotionId == null || promotionId.trim().isEmpty()) {
                req.getSession().setAttribute("error", "Promotion ID is required");
                resp.sendRedirect(req.getContextPath() + "/promotion-list");
                return;
            }
            
            // Update promotion details
            boolean success = promotionService.updatePromotionDetails(promotionId, name, code, description);
            
            if (success) {
                req.getSession().setAttribute("success", "Promotion details updated successfully!");
            } else {
                req.getSession().setAttribute("error", "Failed to update promotion details");
            }
            
        } catch (Exception e) {
            System.err.println("Error in handleUpdateDetails: " + e.getMessage());
            e.printStackTrace();
            req.getSession().setAttribute("error", "Error updating promotion details: " + e.getMessage());
        }
        
        resp.sendRedirect(req.getContextPath() + "/promotion-detail?id=" + req.getParameter("promotionId"));
    }

    // [POST] Update promotion value
    // Cap nhat gia tri giam gia cua khuyen mai
    private void handleUpdateValue(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            String promotionId = req.getParameter("promotionId");
            String valueStr = req.getParameter("value");
            
            if (promotionId == null || promotionId.trim().isEmpty()) {
                req.getSession().setAttribute("error", "Promotion ID is required");
                resp.sendRedirect(req.getContextPath() + "/promotion-list");
                return;
            }
            
            if (valueStr == null || valueStr.trim().isEmpty()) {
                req.getSession().setAttribute("error", "Value is required");
                resp.sendRedirect(req.getContextPath() + "/promotion-detail?id=" + promotionId);
                return;
            }
            
            double value = Double.parseDouble(valueStr);
            
            // Update promotion value
            boolean success = promotionService.updatePromotionValue(promotionId, value);
            
            if (success) {
                req.getSession().setAttribute("success", "Promotion value updated successfully!");
            } else {
                req.getSession().setAttribute("error", "Failed to update promotion value");
            }
            
        } catch (NumberFormatException e) {
            req.getSession().setAttribute("error", "Invalid value format");
        } catch (Exception e) {
            System.err.println("Error in handleUpdateValue: " + e.getMessage());
            e.printStackTrace();
            req.getSession().setAttribute("error", "Error updating promotion value: " + e.getMessage());
        }
        
        resp.sendRedirect(req.getContextPath() + "/promotion-detail?id=" + req.getParameter("promotionId"));
    }

    // [POST] Update promotion dates
    // Cap nhat ngay bat dau va ket thuc khuyen mai
    private void handleUpdateDates(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            String promotionId = req.getParameter("promotionId");
            String startDateStr = req.getParameter("startDate");
            String endDateStr = req.getParameter("endDate");
            
            if (promotionId == null || promotionId.trim().isEmpty()) {
                req.getSession().setAttribute("error", "Promotion ID is required");
                resp.sendRedirect(req.getContextPath() + "/promotion-list");
                return;
            }
            
            if (startDateStr == null || startDateStr.trim().isEmpty() || 
                endDateStr == null || endDateStr.trim().isEmpty()) {
                req.getSession().setAttribute("error", "Start date and end date are required");
                resp.sendRedirect(req.getContextPath() + "/promotion-detail?id=" + promotionId);
                return;
            }
            
            // Parse dates
            LocalDateTime startDate = LocalDateTime.parse(startDateStr + "T00:00:00");
            LocalDateTime endDate = LocalDateTime.parse(endDateStr + "T23:59:59");
            
            // Update promotion dates
            boolean success = promotionService.updatePromotionDates(promotionId, startDate, endDate);
            
            if (success) {
                req.getSession().setAttribute("success", "Promotion dates updated successfully!");
            } else {
                req.getSession().setAttribute("error", "Failed to update promotion dates");
            }
            
        } catch (Exception e) {
            System.err.println("Error in handleUpdateDates: " + e.getMessage());
            e.printStackTrace();
            req.getSession().setAttribute("error", "Error updating promotion dates: " + e.getMessage());
        }
        
        resp.sendRedirect(req.getContextPath() + "/promotion-detail?id=" + req.getParameter("promotionId"));
    }

    // Mo ta ngan gon ve servlet
    @Override
    public String getServletInfo() {
        return "PromotionServlet handles promotion management operations";
    }
}