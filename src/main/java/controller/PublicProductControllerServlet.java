package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.ProductDto;
import service.ProductService;
import service.ProductServiceImpl;

public class PublicProductControllerServlet extends HttpServlet {

    private final ProductService productService = new ProductServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getRequestURI().substring(request.getContextPath().length());
        
        // Handle public product details
        if (path.equals("/public-product-details") || path.startsWith("/public-product-details")) {
            handleDetail(request, response);
            return;
        }
        
        // This should never be reached if configured correctly
        // Default handler for any other paths
        try {
            List<ProductDto> allProducts = productService.getAllProducts();
            // Filter only active products
            List<ProductDto> products = allProducts.stream()
                    .filter(p -> p.getStatus() != null && p.getStatus().equalsIgnoreCase("Activate"))
                    .collect(java.util.stream.Collectors.toList());
            request.setAttribute("products", products);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/view/home/PublicProducts.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Không thể tải danh sách sản phẩm.");
        }
    }
    
    private void handleDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String productId = request.getParameter("id");
        if (productId == null || productId.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/home/public-products");
            return;
        }
        
        try {
            ProductDto product = productService.getProductById(productId);
            if (product == null) {
                response.sendRedirect(request.getContextPath() + "/home/public-products");
                return;
            }
            
            // Get related products from same category, excluding current product
            List<ProductDto> allProducts = productService.getAllProducts();
            List<ProductDto> relatedProducts = allProducts.stream()
                    .filter(p -> p.getCategory() != null && p.getCategory().equals(product.getCategory()))
                    .filter(p -> !p.getProductId().equals(productId))
                    .filter(p -> p.getStatus() != null && p.getStatus().equalsIgnoreCase("Activate"))
                    .limit(4)
                    .collect(java.util.stream.Collectors.toList());
            
            request.setAttribute("product", product);
            request.setAttribute("relatedProducts", relatedProducts);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/view/home/PublicProductDetails.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/home/public-products");
        }
    }
}
