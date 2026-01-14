package service;

import dao.ProductDao;
import dao.ProductDaoJdbc;
import model.Product;
import model.ProductDto;
import model.ProductMapper;

import java.util.List;
import java.util.stream.Collectors;

public class ProductServiceImpl implements ProductService {

    private final ProductDao productDao = new ProductDaoJdbc();

    // Lay toan bo san pham va chuyen sang DTO
    @Override
    public List<ProductDto> getAllProducts() {
        System.out.println("DEBUG: ProductServiceImpl.getAllProducts called");
        List<Product> products = productDao.findAll();
        System.out.println("DEBUG: Found " + products.size() + " products from DAO");
        
        List<ProductDto> dtos = products.stream()
                .map(ProductMapper::toDto)
                .collect(Collectors.toList());
        
        System.out.println("DEBUG: Mapped to " + dtos.size() + " DTOs");
        return dtos;
    }

    // Lay san pham theo ma
    @Override
    public ProductDto getProductById(String id) {
        return productDao.findById(id);
    }

    // Tao moi san pham tu du lieu DTO
    @Override
    public void insertProduct(ProductDto dto) {
        System.out.println("DEBUG: ProductServiceImpl.insertProduct called");
        System.out.println("DEBUG: ProductDto name: " + dto.getName());
        System.out.println("DEBUG: ProductDto price: " + dto.getPrice());
        System.out.println("DEBUG: ProductDto category: " + dto.getCategory());
        
        Product product = ProductMapper.toEntity(dto);
        System.out.println("DEBUG: Product entity created");
        
        productDao.insert(product);
        System.out.println("DEBUG: Product inserted to database");
        
        dto.setProduct_id(product.getProductId());
        System.out.println("DEBUG: Product ID set to: " + product.getProductId());
    }

    // Cap nhat san pham tu DTO
    @Override
    public void updateProduct(ProductDto dto) {
        System.out.println("DEBUG: ProductServiceImpl.updateProduct called for productId: " + dto.getProduct_id());
        System.out.println("DEBUG: dto.getImage_url(): " + dto.getImage_url());
        Product product = ProductMapper.toEntity(dto);
        System.out.println("DEBUG: product.getImageUrl(): " + product.getImageUrl());
        productDao.update(product);
    }

    // Xoa san pham theo ma
    @Override
    public void deleteProduct(String id) {
        productDao.delete(id);
    }
}
