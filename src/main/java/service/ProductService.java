package service;

import java.util.List;
import model.ProductDto;

public interface ProductService {

    List<ProductDto> getAllProducts();

    ProductDto getProductById(String id);

    void insertProduct(ProductDto p);

    void updateProduct(ProductDto p);

    void deleteProduct(String id);
}
