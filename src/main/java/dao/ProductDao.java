package dao;

import model.Product;
import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;
import model.ProductDto;

public interface ProductDao {
    List<Product> findAll();
    ProductDto findById(String productId);
    void insert(Product product);
    void update(Product product);
    void delete(String id);
    List<Product> findByCategory(String category);
    List<Product> findByStatus(String status);
    
    // New methods for Product Details page
    void updateDetails(Product product);
    void updatePrice(String id, BigDecimal newPrice);
    void updateImage(String id, String imageUrl);
    void toggleStatus(String id);
}
