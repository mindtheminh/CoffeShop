package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.MultipartConfig;
import service.ProductService;
import service.ProductServiceImpl;
import service.PromotionService;
import service.PromotionServiceImpl;
import dao.PromotionDaoJdbc;
import dao.DBConnect;
import model.ProductDto;
import model.PromotionDto;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.math.BigDecimal;
import java.util.stream.Collectors;

@MultipartConfig
public class ProductControllerServlet extends HttpServlet {

    private ProductService productService;
    private PromotionService promotionService;
    private static final String PRODUCT_FORM_VIEW = "/WEB-INF/view/product/ProductNew.jsp";
    private static final long MAX_UPLOAD_SIZE = 5L * 1024 * 1024;

    // Khoi tao service san pham va khuyen mai
    @Override
    public void init() throws ServletException {
        super.init();
        try {
            productService = new ProductServiceImpl();
        } catch (Exception e) {
            e.printStackTrace();
        }
        try {
            promotionService = new PromotionServiceImpl(new PromotionDaoJdbc(new DBConnect().getConnection()));
        } catch (Exception e) {
            e.printStackTrace();
            promotionService = null;
        }
    }

    // Xu ly cac request GET cho marketer
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getRequestURI().substring(req.getContextPath().length());

        switch (path) {
            case "/marketer-dashboard":
                handleDashboard(req, resp);
                break;
            case "/product-list":
                handleList(req, resp);
                break;
            case "/product-new":
            case "/products/new":
                handleNew(req, resp);
                break;
            case "/product-detail":
                handleDetail(req, resp);
                break;
            case "/product-edit":
                // Redirect old edit route to detail page with edit mode
                resp.sendRedirect(req.getContextPath() + "/product-detail?id=" + req.getParameter("id") + "&mode=edit");
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/marketer-dashboard");
                break;
        }
    }

    // Xu ly cac request POST cho marketer
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getRequestURI().substring(req.getContextPath().length());

        switch (path) {
            case "/product-new":
                handleCreate(req, resp);
                break;
            case "/product-edit":
                handleUpdate(req, resp);
                break;
            case "/product/toggle-status":
                handleToggleStatus(req, resp);
                break;
            case "/product-delete":
                handleDelete(req, resp);
                break;
            case "/product/update-details":
                handleUpdateDetails(req, resp);
                break;
            case "/product/update-price":
                handleUpdatePrice(req, resp);
                break;
            case "/product/update-image":
                handleUpdateImage(req, resp);
                break;
            case "/product/update-status":
                handleUpdateStatus(req, resp);
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/marketer-dashboard");
                break;
        }
    }

    // Tong hop so lieu cho trang dashboard marketer
    private void handleDashboard(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        System.out.println("DEBUG: handleDashboard called");
        
        try {
            // Get product statistics
            System.out.println("DEBUG: Getting products from service...");
            List<ProductDto> allProducts = productService.getAllProducts();
            System.out.println("DEBUG: Retrieved " + (allProducts != null ? allProducts.size() : 0) + " products");
            
            int totalProducts = allProducts != null ? allProducts.size() : 0;
            int activeProducts = allProducts != null ? (int) allProducts.stream().filter(p -> "Activate".equals(p.getStatus())).count() : 0;
            int inactiveProducts = totalProducts - activeProducts;

            // Get unique categories
            long totalCategories = allProducts != null ? allProducts.stream().map(ProductDto::getCategory).distinct().count() : 0;

            // Get recent products (last 10)
            List<ProductDto> recentProducts = allProducts != null ? allProducts.stream().limit(10).toList() : List.of();

            // Category data for chart
            long coffeeCount = allProducts != null ? allProducts.stream().filter(p -> "Cà phê".equals(p.getCategory())).count() : 0;
            long teaCount = allProducts != null ? allProducts.stream().filter(p -> "Trà".equals(p.getCategory())).count() : 0;
            long juiceCount = allProducts != null ? allProducts.stream().filter(p -> "Nước ép".equals(p.getCategory())).count() : 0;
            long cakeCount = allProducts != null ? allProducts.stream().filter(p -> "Bánh ngọt".equals(p.getCategory())).count() : 0;
            long otherCount = allProducts != null ? allProducts.stream().filter(p -> "Khác".equals(p.getCategory())).count() : 0;

            // Get promotion statistics
            int totalPromotions = 0;
            try {
                List<PromotionDto> allPromotions = (promotionService != null) ? promotionService.getAllPromotions() : List.of();
                totalPromotions = (allPromotions != null) ? allPromotions.size() : 0;
            } catch (Exception e) {
                System.out.println("DEBUG: Failed to load promotions: " + e.getMessage());
            }

            req.setAttribute("totalProducts", totalProducts);
            req.setAttribute("activeProducts", activeProducts);
            req.setAttribute("inactiveProducts", inactiveProducts);
            req.setAttribute("totalCategories", totalCategories);
            req.setAttribute("totalPromotions", totalPromotions);
            req.setAttribute("recentProducts", recentProducts);
            req.setAttribute("categoryData", String.format("[%d,%d,%d,%d,%d]", coffeeCount, teaCount, juiceCount, cakeCount, otherCount));
            
            System.out.println("DEBUG: Set attributes - totalProducts: " + totalProducts + ", activeProducts: " + activeProducts + ", totalPromotions: " + totalPromotions);

        } catch (Exception e) {
            System.err.println("ERROR in handleDashboard: " + e.getMessage());
            e.printStackTrace();
            // Set default values if service fails
            req.setAttribute("totalProducts", 0);
            req.setAttribute("activeProducts", 0);
            req.setAttribute("inactiveProducts", 0);
            req.setAttribute("totalCategories", 0);
            req.setAttribute("recentProducts", List.of());
            req.setAttribute("categoryData", "[0,0,0,0,0]");
            req.setAttribute("error", "Không thể tải dữ liệu: " + e.getMessage());
        }

        System.out.println("DEBUG: Forwarding to MarketerDashboard.jsp");
        req.getRequestDispatcher("/WEB-INF/view/dashboard/MarketerDashboard.jsp").forward(req, resp);
    }

    // Hien danh sach san pham kem tim kiem sap xep va phan trang
    private void handleList(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            if (productService == null) {
                req.setAttribute("products", List.of());
                req.setAttribute("currentPage", 1);
                req.setAttribute("totalPages", 1);
                req.setAttribute("totalItems", 0);
            } else {
                // Get all products first
                List<ProductDto> allProducts = productService.getAllProducts();
                
                // Apply filters
                String search = req.getParameter("search");
                String category = req.getParameter("category");
                String status = req.getParameter("status");
                String bestseller = req.getParameter("bestseller");
                
                // Get sorting parameters
                String sortColumn = req.getParameter("sortColumn");
                String sortDirection = req.getParameter("sortDirection");
                
                List<ProductDto> filteredProducts = allProducts;
                
                // Search filter
                if (search != null && !search.trim().isEmpty()) {
                    String searchLower = search.toLowerCase().trim();
                    filteredProducts = filteredProducts.stream()
                            .filter(p -> (p.getName() != null && p.getName().toLowerCase().contains(searchLower))
                                    || (p.getDescription() != null && p.getDescription().toLowerCase().contains(searchLower))
                                    || (p.getProductId() != null && p.getProductId().toLowerCase().contains(searchLower)))
                            .collect(Collectors.toList());
                }
                
                // Category filter
                if (category != null && !category.trim().isEmpty()) {
                    filteredProducts = filteredProducts.stream()
                            .filter(p -> p.getCategory() != null && p.getCategory().equals(category))
                            .collect(Collectors.toList());
                }
                
                // Status filter
                if (status != null && !status.trim().isEmpty()) {
                    filteredProducts = filteredProducts.stream()
                            .filter(p -> p.getStatus() != null && p.getStatus().equals(status))
                            .collect(Collectors.toList());
                }
                
                // Bestseller filter
                if (bestseller != null && !bestseller.trim().isEmpty()) {
                    boolean isBestseller = Boolean.parseBoolean(bestseller);
                    filteredProducts = filteredProducts.stream()
                            .filter(p -> p.getIsBestseller() == isBestseller)
                            .collect(Collectors.toList());
                }
                
                // Apply sorting to all filtered data
                if (sortColumn != null && !sortColumn.trim().isEmpty() && sortDirection != null && !sortDirection.trim().isEmpty()) {
                    final String finalSortColumn = sortColumn.trim();
                    final boolean ascending = "asc".equalsIgnoreCase(sortDirection.trim());
                    
                    filteredProducts = filteredProducts.stream().sorted((p1, p2) -> {
                        int result = 0;
                        switch (finalSortColumn) {
                            case "0": // ID
                                result = (p1.getProductId() != null && p2.getProductId() != null) 
                                        ? p1.getProductId().compareTo(p2.getProductId()) : 0;
                                break;
                            case "1": // Name
                                result = (p1.getName() != null && p2.getName() != null) 
                                        ? p1.getName().compareTo(p2.getName()) : 0;
                                break;
                            case "2": // Category
                                result = (p1.getCategory() != null && p2.getCategory() != null) 
                                        ? p1.getCategory().compareTo(p2.getCategory()) : 0;
                                break;
                            case "3": // Price
                                result = (p1.getPrice() != null && p2.getPrice() != null) 
                                        ? p1.getPrice().compareTo(p2.getPrice()) : 0;
                                break;
                            case "4": // Bestseller
                                boolean b1 = p1.getIsBestseller();
                                boolean b2 = p2.getIsBestseller();
                                result = Boolean.compare(b1, b2);
                                break;
                            case "5": // Stock
                                int s1 = p1.getStockQuantity() != null ? p1.getStockQuantity() : 0;
                                int s2 = p2.getStockQuantity() != null ? p2.getStockQuantity() : 0;
                                result = Integer.compare(s1, s2);
                                break;
                            case "6": // Status
                                result = (p1.getStatus() != null && p2.getStatus() != null) 
                                        ? p1.getStatus().compareTo(p2.getStatus()) : 0;
                                break;
                            default:
                                result = 0;
                        }
                        return ascending ? result : -result;
                    }).collect(Collectors.toList());
                }
                
                // Pagination logic - phan trang
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
                
                int totalItems = filteredProducts.size();
                int totalPages = (int) Math.ceil((double) totalItems / pageSize);
                
                if (currentPage > totalPages && totalPages > 0) {
                    currentPage = totalPages;
                }
                
                // Get products for current page
                int startIndex = (currentPage - 1) * pageSize;
                int endIndex = Math.min(startIndex + pageSize, totalItems);
                
                List<ProductDto> paginatedProducts = filteredProducts.subList(startIndex, endIndex);
                
                req.setAttribute("products", paginatedProducts);
                req.setAttribute("search", search);
                req.setAttribute("category", category);
                req.setAttribute("status", status);
                req.setAttribute("bestseller", bestseller);
                req.setAttribute("sortColumn", sortColumn);
                req.setAttribute("sortDirection", sortDirection);
                req.setAttribute("currentPage", currentPage);
                req.setAttribute("totalPages", totalPages);
                req.setAttribute("totalItems", totalItems);
                req.setAttribute("pageSize", pageSize);
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("products", List.of());
            req.setAttribute("currentPage", 1);
            req.setAttribute("totalPages", 1);
            req.setAttribute("totalItems", 0);
        }
        req.getRequestDispatcher("WEB-INF/view/product/ProductList.jsp").forward(req, resp);
    }

    // Hien form tao san pham moi
    private void handleNew(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (req.getAttribute("productDto") == null) {
            ProductDto defaultProduct = new ProductDto();
            defaultProduct.setStatus("Activate");
            defaultProduct.setStockQuantity(0);
            req.setAttribute("productDto", defaultProduct);
        }
        forwardToProductForm(req, resp);
    }

    // Hien chi tiet san pham
    private void handleDetail(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String idStr = req.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/product-list");
            return;
        }

        try {
            ProductDto product = productService.getProductById(idStr);
            if (product == null) {
                resp.sendRedirect(req.getContextPath() + "/product-list");
                return;
            }

            req.setAttribute("product", product);
            req.getRequestDispatcher("WEB-INF/view/product/productDetails.jsp").forward(req, resp);
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/product-list");
        }
    }

    private void handleEdit(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // Edit is now handled by modal in ProductList.jsp, redirect to product list
        resp.sendRedirect(req.getContextPath() + "/product-list");
    }

    // Xu ly tao san pham moi
    private void handleCreate(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        ProductDto formData = new ProductDto();
        List<String> validationErrors = new ArrayList<>();

        String productName = trim(req.getParameter("productName"));
        formData.setName(productName);
        if (isBlank(productName)) {
            validationErrors.add("Tên sản phẩm là bắt buộc.");
        }

        String category = trim(req.getParameter("category"));
        formData.setCategory(category);
        if (isBlank(category)) {
            validationErrors.add("Danh mục là bắt buộc.");
        }

        String status = trim(req.getParameter("status"));
        formData.setStatus(status);
        if (isBlank(status)) {
            validationErrors.add("Vui lòng chọn trạng thái.");
        }

        String description = trim(req.getParameter("description"));
        formData.setDescription(description);

        String note = trim(req.getParameter("note"));
        formData.setNote(note);

        boolean isBestseller = req.getParameter("isBestseller") != null;
        formData.setIsBestseller(isBestseller);

        String priceStr = trim(req.getParameter("price"));
        BigDecimal price = null;
        if (isBlank(priceStr)) {
            validationErrors.add("Giá bán là bắt buộc.");
        } else {
            try {
                price = new BigDecimal(priceStr);
                if (price.compareTo(BigDecimal.ZERO) <= 0) {
                    validationErrors.add("Giá bán phải lớn hơn 0.");
                }
            } catch (NumberFormatException e) {
                validationErrors.add("Giá bán phải là số hợp lệ.");
            }
        }

        String stockQuantityStr = trim(req.getParameter("stockQuantity"));
        Integer stockQuantity = null;
        if (isBlank(stockQuantityStr)) {
            validationErrors.add("Số lượng tồn kho là bắt buộc.");
        } else {
            try {
                stockQuantity = Integer.parseInt(stockQuantityStr);
                if (stockQuantity < 0) {
                    validationErrors.add("Số lượng tồn kho phải lớn hơn hoặc bằng 0.");
                }
            } catch (NumberFormatException e) {
                validationErrors.add("Số lượng tồn kho phải là số hợp lệ.");
            }
        }

        Part imagePart = req.getPart("productImage");
        boolean hasImage = imagePart != null && imagePart.getSize() > 0;
        if (hasImage) {
            try {
                validateImagePart(imagePart);
            } catch (IllegalArgumentException ex) {
                validationErrors.add("Định dạng hoặc kích thước ảnh không hợp lệ.");
            }
        }

        if (!validationErrors.isEmpty()) {
            req.setAttribute("errorMessage", "Vui lòng kiểm tra lại thông tin bắt buộc. Một số trường còn thiếu hoặc không hợp lệ.");
            req.setAttribute("validationErrors", validationErrors);
            req.setAttribute("productDto", formData);
            forwardToProductForm(req, resp);
            return;
        }

        if (price != null) {
            formData.setPrice(price);
        }
        if (stockQuantity != null) {
            formData.setStockQuantity(stockQuantity);
        }

        if (hasImage) {
            try {
                String imageUrl = saveUploadedImage(imagePart, req);
                formData.setImageUrl(imageUrl);
            } catch (IOException e) {
                req.setAttribute("errorMessage", "Định dạng hoặc kích thước ảnh không hợp lệ.");
                validationErrors.add("Định dạng hoặc kích thước ảnh không hợp lệ.");
                req.setAttribute("validationErrors", validationErrors);
                req.setAttribute("productDto", formData);
                forwardToProductForm(req, resp);
                return;
            }
        }

        try {
            productService.insertProduct(formData);
            ProductDto clearedForm = new ProductDto();
            clearedForm.setStatus("Activate");
            clearedForm.setStockQuantity(0);
            req.setAttribute("successMessage", "Thêm sản phẩm thành công! Dữ liệu đã được lưu vào hệ thống.");
            req.setAttribute("productDto", clearedForm);
            forwardToProductForm(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "Thêm sản phẩm thất bại! Đã có lỗi xảy ra trong quá trình lưu dữ liệu.");
            req.setAttribute("productDto", formData);
            forwardToProductForm(req, resp);
        }
    }

    // Chuyen tiep ve form tao san pham kem danh muc
    private void forwardToProductForm(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("categories", getDefaultCategories());
        req.getRequestDispatcher(PRODUCT_FORM_VIEW).forward(req, resp);
    }

    // Lay danh sach danh muc mac dinh
    private List<String> getDefaultCategories() {
        return List.of("Cà phê", "Trà", "Trà sữa", "Nước ép", "Bánh ngọt", "Khác");
    }

    // Kiem tra hop le cua file anh upload
    private void validateImagePart(Part imagePart) {
        if (imagePart == null || imagePart.getSize() == 0) {
            return;
        }

        if (imagePart.getSize() > MAX_UPLOAD_SIZE) {
            throw new IllegalArgumentException("File size exceeds limit");
        }

        String fileName = getFileName(imagePart);
        if (fileName == null || !fileName.contains(".")) {
            throw new IllegalArgumentException("Invalid file name");
        }

        String extension = fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();
        List<String> allowedExtensions = List.of("jpg", "jpeg", "png", "gif");
        if (!allowedExtensions.contains(extension)) {
            throw new IllegalArgumentException("Invalid file extension");
        }

        String contentType = imagePart.getContentType();
        if (contentType != null) {
            String normalizedType = contentType.toLowerCase();
            List<String> allowedContentTypes = List.of("image/jpeg", "image/png", "image/gif", "image/jpg");
            if (!allowedContentTypes.contains(normalizedType)) {
                throw new IllegalArgumentException("Invalid content type");
            }
        }
    }

    // Cap nhat san pham tu danh sach
    private void handleUpdate(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String idStr = req.getParameter("productId");
        String productName = trim(req.getParameter("productName"));
        String priceStr = trim(req.getParameter("price"));
        String category = trim(req.getParameter("category"));
        String status = trim(req.getParameter("status"));
        String description = trim(req.getParameter("description"));
        String note = trim(req.getParameter("note"));
        String sku = trim(req.getParameter("sku"));
        String isBestsellerStr = trim(req.getParameter("isBestseller"));
        String stockQuantityStr = trim(req.getParameter("stockQuantity"));

        if (idStr == null || idStr.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/product-list");
            return;
        }

        try {
            ProductDto product = productService.getProductById(idStr);
            if (product == null) {
                resp.sendRedirect(req.getContextPath() + "/product-list");
                return;
            }

            // Handle file upload
            Part imagePart = req.getPart("productImage");
            String imageUrl = null;
            try {
                imageUrl = saveUploadedImage(imagePart, req);
            } catch (IOException e) {
                HttpSession session = req.getSession();
                session.setAttribute("error", "Lỗi khi upload ảnh: " + e.getMessage());
                resp.sendRedirect(req.getContextPath() + "/product-list");
                return;
            }

            StringBuilder errors = new StringBuilder();

            if (isBlank(productName)) {
                errors.append("Product name is required. ");
            }
            if (isBlank(priceStr)) {
                errors.append("Price is required. ");
            } else {
                try {
                    double price = Double.parseDouble(priceStr);
                    if (price < 0) {
                        errors.append("Price must be positive. ");
                    }
                } catch (NumberFormatException e) {
                    errors.append("Price must be a valid number. ");
                }
            }
            if (isBlank(category)) {
                errors.append("Category is required. ");
            }
            if (isBlank(status)) {
                errors.append("Status is required. ");
            }
            if (isBlank(stockQuantityStr)) {
                errors.append("Stock quantity is required. ");
            } else {
                try {
                    int sq = Integer.parseInt(stockQuantityStr);
                    if (sq < 0) {
                        errors.append("Stock quantity must be non-negative. ");
                    }
                } catch (NumberFormatException e) {
                    errors.append("Stock quantity must be a valid number. ");
                }
            }

            // Image is optional - no validation needed as file upload handles it

            if (errors.length() > 0) {
                HttpSession session = req.getSession();
                session.setAttribute("error", errors.toString());
                resp.sendRedirect(req.getContextPath() + "/product-list");
                return;
            }

            product.setName(productName);
            product.setPrice(new BigDecimal(priceStr));
            product.setCategory(category);
            product.setStatus(status);
            product.setDescription(description);
            product.setNote(note);
            product.setSku(sku);
            // Update image URL only if a new file was uploaded
            if (imageUrl != null && !imageUrl.isEmpty()) {
                product.setImage_url(imageUrl);
            }
            product.setIs_bestseller("true".equals(isBestsellerStr));
            try {
                product.setStock_quantity(Integer.parseInt(stockQuantityStr));
            } catch (NumberFormatException ignored) {}

            productService.updateProduct(product);

            HttpSession session = req.getSession();
            session.setAttribute("success", "✅ Cập nhật sản phẩm thành công!");
            resp.sendRedirect(req.getContextPath() + "/product-list");
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/product-list");
        }
    }

    // Dao trang thai san pham tren danh sach
    private void handleToggleStatus(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String idStr = req.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/product-list");
            return;
        }

        try {
            ProductDto product = productService.getProductById(idStr);

            if (product != null) {
                // Toggle status
                String newStatus = "ACTIVE".equals(product.getStatus()) ? "INACTIVE" : "ACTIVE";
                product.setStatus(newStatus);
                productService.updateProduct(product);
            }

            resp.sendRedirect(req.getContextPath() + "/product-list");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/product-list");
        }
    }

    // Xoa san pham
    private void handleDelete(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String idStr = req.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/product-list");
            return;
        }

        try {
            productService.deleteProduct(idStr);

            HttpSession session = req.getSession();
            session.setAttribute("success", "Product deleted successfully!");
        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = req.getSession();
            session.setAttribute("error", "Failed to delete product: " + e.getMessage());
        }

        resp.sendRedirect(req.getContextPath() + "/product-list");
    }

    // Cat khoang trang o dau va cuoi chuoi
    private static String trim(String s) {
        return s == null ? null : s.trim();
    }

    // Kiem tra chuoi rong hoac chi co khoang trang
    private static boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }

    /**
     * Helper method to save uploaded image file and return the URL path
     */
    // Luu file anh duoc upload va tra ve URL tuong ung
    private String saveUploadedImage(Part filePart, HttpServletRequest req) throws IOException {
        System.out.println("DEBUG: saveUploadedImage called, filePart: " + (filePart != null ? "exists" : "null"));
        if (filePart == null || filePart.getSize() == 0) {
            System.out.println("DEBUG: filePart is null or size is 0, returning null");
            return null;
        }

        // Get file name and validate
        String fileName = getFileName(filePart);
        System.out.println("DEBUG: extracted fileName: " + fileName);
        if (fileName == null || fileName.isEmpty()) {
            System.out.println("DEBUG: fileName is null or empty, returning null");
            return null;
        }

        // Validate file type
        String contentType = filePart.getContentType();
        System.out.println("DEBUG: contentType: " + contentType);
        if (contentType == null || !contentType.startsWith("image/")) {
            throw new IOException("Invalid file type. Only image files are allowed.");
        }

        // Validate file size (5MB max)
        long fileSize = filePart.getSize();
        System.out.println("DEBUG: fileSize: " + fileSize);
        if (fileSize > 5 * 1024 * 1024) {
            throw new IOException("File size too large. Maximum size is 5MB.");
        }

        // Get the real path of the web application
        String appPath = req.getServletContext().getRealPath("");
        String uploadDir = appPath + "assets/img/products";
        System.out.println("DEBUG: appPath: " + appPath);
        System.out.println("DEBUG: uploadDir: " + uploadDir);

        // Create directory if it doesn't exist
        Path uploadPath = Paths.get(uploadDir);
        if (!Files.exists(uploadPath)) {
            System.out.println("DEBUG: Creating directory: " + uploadPath);
            Files.createDirectories(uploadPath);
        }

        // Generate unique file name to avoid conflicts
        int dotIndex = fileName.lastIndexOf(".");
        if (dotIndex < 0) {
            throw new IOException("Invalid file name");
        }
        String fileExtension = fileName.substring(dotIndex);
        String uniqueFileName = UUID.randomUUID().toString() + fileExtension;
        Path filePath = uploadPath.resolve(uniqueFileName);
        System.out.println("DEBUG: Saving file to: " + filePath);

        // Save the file
        try (InputStream inputStream = filePart.getInputStream()) {
            Files.copy(inputStream, filePath, StandardCopyOption.REPLACE_EXISTING);
        }

        // Return the URL path (relative to context)
        String url = req.getContextPath() + "/assets/img/products/" + uniqueFileName;
        System.out.println("DEBUG: Returning URL: " + url);
        return url;
    }

    /**
     * Extract file name from Part header
     */
    // Tach ten file tu header multipart
    private String getFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        if (contentDisposition == null) {
            return null;
        }
        
        String[] tokens = contentDisposition.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return null;
    }

    // New handlers for Product Details page
    // Cap nhat chi tiet san pham tren trang detail
    private void handleUpdateDetails(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String idStr = req.getParameter("productId");
        String name = trim(req.getParameter("name"));
        String category = trim(req.getParameter("category"));
        String description = trim(req.getParameter("description"));
        String note = trim(req.getParameter("note"));

        if (idStr == null || idStr.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/product-list");
            return;
        }

        try {
            ProductDto product = productService.getProductById(idStr);
            if (product == null) {
                resp.sendRedirect(req.getContextPath() + "/product-list");
                return;
            }

            // Preserve existing values when fields are not provided (e.g., only note form submitted)
            if (name != null) product.setName(name);
            if (category != null) product.setCategory(category);
            if (description != null) product.setDescription(description);
            if (note != null) product.setNote(note);
            
            productService.updateProduct(product);

            HttpSession session = req.getSession();
            session.setAttribute("success", "Product details updated successfully!");
            resp.sendRedirect(req.getContextPath() + "/product-detail?id=" + idStr);
        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = req.getSession();
            session.setAttribute("error", "Failed to update product details: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/product-detail?id=" + idStr);
        }
    }

    // Cap nhat gia san pham tren trang detail
    private void handleUpdatePrice(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String idStr = req.getParameter("productId");
        String priceStr = trim(req.getParameter("price"));

        if (idStr == null || idStr.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/product-list");
            return;
        }

        try {
            ProductDto product = productService.getProductById(idStr);
            if (product == null) {
                resp.sendRedirect(req.getContextPath() + "/product-list");
                return;
            }

            if (isBlank(priceStr)) {
                HttpSession session = req.getSession();
                session.setAttribute("error", "Price is required.");
                resp.sendRedirect(req.getContextPath() + "/product-detail?id=" + idStr);
                return;
            }

            BigDecimal newPrice = new BigDecimal(priceStr);
            if (newPrice.compareTo(BigDecimal.ZERO) < 0) {
                HttpSession session = req.getSession();
                session.setAttribute("error", "Price must be positive.");
                resp.sendRedirect(req.getContextPath() + "/product-detail?id=" + idStr);
                return;
            }

            product.setPrice(newPrice);
            productService.updateProduct(product);

            HttpSession session = req.getSession();
            session.setAttribute("success", "✅ Product price updated successfully.");
            resp.sendRedirect(req.getContextPath() + "/product-detail?id=" + idStr);
        } catch (NumberFormatException e) {
            HttpSession session = req.getSession();
            session.setAttribute("error", "Invalid price format.");
            resp.sendRedirect(req.getContextPath() + "/product-detail?id=" + idStr);
        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = req.getSession();
            session.setAttribute("error", "Failed to update price: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/product-detail?id=" + idStr);
        }
    }

    // Cap nhat anh san pham tren trang detail
    private void handleUpdateImage(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String idStr = req.getParameter("productId");
        System.out.println("DEBUG: handleUpdateImage called with productId: " + idStr);

        if (idStr == null || idStr.isEmpty()) {
            System.out.println("DEBUG: No product ID provided");
            resp.sendRedirect(req.getContextPath() + "/product-list");
            return;
        }

        try {
            ProductDto product = productService.getProductById(idStr);
            if (product == null) {
                System.out.println("DEBUG: Product not found: " + idStr);
                resp.sendRedirect(req.getContextPath() + "/product-list");
                return;
            }

            // Handle file upload
            Part imagePart = req.getPart("productImage");
            System.out.println("DEBUG: imagePart: " + (imagePart != null ? "exists, size: " + imagePart.getSize() : "null"));
            String imageUrl = null;
            try {
                imageUrl = saveUploadedImage(imagePart, req);
                System.out.println("DEBUG: saveUploadedImage returned: " + imageUrl);
            } catch (IOException e) {
                System.out.println("DEBUG: IOException in saveUploadedImage: " + e.getMessage());
                HttpSession session = req.getSession();
                session.setAttribute("error", "Lỗi khi upload ảnh: " + e.getMessage());
                resp.sendRedirect(req.getContextPath() + "/product-detail?id=" + idStr);
                return;
            }

            // Update image URL if file was uploaded
            if (imageUrl != null && !imageUrl.isEmpty()) {
                System.out.println("DEBUG: Updating product with imageUrl: " + imageUrl);
                product.setImage_url(imageUrl);
                productService.updateProduct(product);
                System.out.println("DEBUG: Product updated successfully");
                
                HttpSession session = req.getSession();
                session.setAttribute("success", "Cập nhật ảnh sản phẩm thành công!");
            } else {
                System.out.println("DEBUG: No image URL to update (null or empty)");
                HttpSession session = req.getSession();
                session.setAttribute("error", "Vui lòng chọn ảnh để upload.");
            }
            
            resp.sendRedirect(req.getContextPath() + "/product-detail?id=" + idStr);
        } catch (Exception e) {
            System.out.println("DEBUG: Exception in handleUpdateImage: " + e.getMessage());
            e.printStackTrace();
            HttpSession session = req.getSession();
            session.setAttribute("error", "Không thể cập nhật ảnh: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/product-detail?id=" + idStr);
        }
    }

    // Cap nhat trang thai san pham tren trang detail
    private void handleUpdateStatus(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String idStr = req.getParameter("productId");

        if (idStr == null || idStr.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/product-list");
            return;
        }

        try {
            ProductDto product = productService.getProductById(idStr);
            if (product == null) {
                resp.sendRedirect(req.getContextPath() + "/product-list");
                return;
            }

            // Toggle status to match DB values
            String newStatus = "Activate".equals(product.getStatus()) ? "Deactivate" : "Activate";
            product.setStatus(newStatus);
            productService.updateProduct(product);

            HttpSession session = req.getSession();
            session.setAttribute("success", "Product status updated to " + newStatus + "!");
            resp.sendRedirect(req.getContextPath() + "/product-detail?id=" + idStr);
        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = req.getSession();
            session.setAttribute("error", "Failed to update status: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/product-detail?id=" + idStr);
        }
    }
}
