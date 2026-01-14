package controller;

import dao.ProductDaoJdbc;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.stream.Collectors;

import service.PromotionService;
import model.ProductDto;
import model.PromotionDto;

public class HomeControllerServlet extends HttpServlet {
    
    private ProductDaoJdbc productDAO;
    private PromotionService promotionService;
    
    @Override
    public void init() throws ServletException {
        productDAO = new ProductDaoJdbc();
        // Khởi tạo service với DAO hợp lệ để tránh lỗi constructor không tham số
        try {
            promotionService = new service.PromotionServiceImpl(new dao.PromotionDaoJdbc(new dao.DBConnect().getConnection()));
        } catch (Exception e) {
            promotionService = null;
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        String path = req.getRequestURI().substring(req.getContextPath().length());
        
        // Handle public products page
        if (path.equals("/home/public-products")) {
            handlePublicProducts(req, resp);
            return;
        }
        
        // Handle public promotions page
        if (path.equals("/home/public-promotions")) {
            handlePublicPromotions(req, resp);
            return;
        }
        
        try {
            String searchQuery = req.getParameter("search");
            String categoryFilter = req.getParameter("category");
            String sortBy = req.getParameter("sort");

            List<ProductDto> products = productDAO.getAllProductsActive();

            List<PromotionDto> activePromotions = new ArrayList<>();
            try {
                activePromotions = promotionService.getAllPromotions().stream()
                        .filter(p -> "Activate".equalsIgnoreCase(p.getStatus()))
                        .collect(Collectors.toList());
            } catch (Exception e) {
                System.err.println("Error loading promotions: " + e.getMessage());
            }

            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                String query = searchQuery.toLowerCase().trim();
                products = products.stream()
                        .filter(p -> (p.getName() != null && p.getName().toLowerCase().contains(query))
                                || (p.getDescription() != null && p.getDescription().toLowerCase().contains(query))
                                || (p.getCategory() != null && p.getCategory().toLowerCase().contains(query)))
                        .collect(Collectors.toList());
            }

            if (categoryFilter != null && !categoryFilter.trim().isEmpty()) {
                products = products.stream()
                        .filter(p -> p.getCategory() != null && p.getCategory().equalsIgnoreCase(categoryFilter))
                        .collect(Collectors.toList());
            }

            if (sortBy != null && !sortBy.trim().isEmpty()) {
                switch (sortBy) {
                    case "bestseller":
                        products.sort((p1, p2) -> {
                            if (Boolean.TRUE.equals(p1.getIsBestseller()) && !Boolean.TRUE.equals(p2.getIsBestseller())) return -1;
                            if (!Boolean.TRUE.equals(p1.getIsBestseller()) && Boolean.TRUE.equals(p2.getIsBestseller())) return 1;
                            return p1.getName().compareTo(p2.getName());
                        });
                        break;
                    case "name_asc":
                        products.sort(Comparator.comparing(ProductDto::getName));
                        break;
                    case "name_desc":
                        products.sort(Comparator.comparing(ProductDto::getName).reversed());
                        break;
                    case "price_asc":
                        products.sort(Comparator.comparing(ProductDto::getPrice));
                        break;
                    case "price_desc":
                        products.sort(Comparator.comparing(ProductDto::getPrice).reversed());
                        break;
                }
            }

            List<ProductDto> bestSellers = products.stream()
                    .filter(p -> Boolean.TRUE.equals(p.getIsBestseller()))
                    .limit(4)
                    .collect(Collectors.toList());

            if (bestSellers.size() < 4) {
                List<ProductDto> regularProducts = products.stream()
                        .filter(p -> !Boolean.TRUE.equals(p.getIsBestseller()))
                        .limit(4 - bestSellers.size())
                        .collect(Collectors.toList());
                bestSellers.addAll(regularProducts);
            }

            req.setAttribute("products", products);
            req.setAttribute("bestSellers", bestSellers);
            req.setAttribute("activePromotions", activePromotions);
            req.setAttribute("searchQuery", searchQuery);
            req.setAttribute("categoryFilter", categoryFilter);
            req.setAttribute("sortBy", sortBy);
        } catch (Exception ex) {
            // Always render home even if data fails
            System.err.println("[HOME] Fallback due to error: " + ex.getMessage());
        }

        // Forward to home page
        req.getRequestDispatcher("/WEB-INF/view/home/home.jsp").forward(req, resp);
    }
    
    private void handlePublicProducts(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            String searchQuery = req.getParameter("search");
            String categoryFilter = req.getParameter("category");
            String sortBy = req.getParameter("sort");

            List<ProductDto> products = productDAO.getAllProductsActive();

            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                String query = searchQuery.toLowerCase().trim();
                products = products.stream()
                        .filter(p -> (p.getName() != null && p.getName().toLowerCase().contains(query))
                                || (p.getDescription() != null && p.getDescription().toLowerCase().contains(query))
                                || (p.getCategory() != null && p.getCategory().toLowerCase().contains(query)))
                        .collect(Collectors.toList());
            }

            if (categoryFilter != null && !categoryFilter.trim().isEmpty()) {
                products = products.stream()
                        .filter(p -> p.getCategory() != null && p.getCategory().equalsIgnoreCase(categoryFilter))
                        .collect(Collectors.toList());
            }

            if (sortBy != null && !sortBy.trim().isEmpty()) {
                switch (sortBy) {
                    case "bestseller":
                        products.sort((p1, p2) -> {
                            if (Boolean.TRUE.equals(p1.getIsBestseller()) && !Boolean.TRUE.equals(p2.getIsBestseller())) return -1;
                            if (!Boolean.TRUE.equals(p1.getIsBestseller()) && Boolean.TRUE.equals(p2.getIsBestseller())) return 1;
                            return p1.getName().compareTo(p2.getName());
                        });
                        break;
                    case "name_asc":
                        products.sort(Comparator.comparing(ProductDto::getName));
                        break;
                    case "name_desc":
                        products.sort(Comparator.comparing(ProductDto::getName).reversed());
                        break;
                    case "price_asc":
                        products.sort(Comparator.comparing(ProductDto::getPrice));
                        break;
                    case "price_desc":
                        products.sort(Comparator.comparing(ProductDto::getPrice).reversed());
                        break;
                }
            }

            req.setAttribute("products", products);
            req.setAttribute("searchQuery", searchQuery);
            req.setAttribute("categoryFilter", categoryFilter);
            req.setAttribute("sortBy", sortBy);
        } catch (Exception ex) {
            System.err.println("[HOME] Error loading public products: " + ex.getMessage());
            req.setAttribute("products", new ArrayList<>());
            req.setAttribute("error", "Không thể tải danh sách sản phẩm");
        }

        req.getRequestDispatcher("/WEB-INF/view/home/PublicProducts.jsp").forward(req, resp);
    }
    
    private void handlePublicPromotions(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            List<PromotionDto> promotions = new ArrayList<>();
            if (promotionService != null) {
                promotions = promotionService.getAllPromotions().stream()
                        .filter(p -> "Activate".equalsIgnoreCase(p.getStatus()))
                        .collect(Collectors.toList());
            }
            
            req.setAttribute("promotions", promotions);
            req.getRequestDispatcher("/WEB-INF/view/home/PublicPromotions.jsp").forward(req, resp);
        } catch (Exception e) {
            System.err.println("[HOME] Error loading public promotions: " + e.getMessage());
            e.printStackTrace();
            req.setAttribute("error", "Không thể tải danh sách khuyến mãi");
            req.setAttribute("promotions", new ArrayList<>());
            req.getRequestDispatcher("/WEB-INF/view/home/PublicPromotions.jsp").forward(req, resp);
        }
    }

}
