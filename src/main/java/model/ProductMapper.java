package model;

public class ProductMapper {
    
    public static ProductDto toDto(Product product) {
        if (product == null) return null;
        
        ProductDto dto = new ProductDto();
        dto.setProduct_id(product.getProductId());
        dto.setSku(product.getSku());
        dto.setName(product.getName());
        dto.setCategory(product.getCategory());
        dto.setDescription(product.getDescription());
        dto.setPrice(product.getPrice());
        dto.setIs_bestseller(product.getIsBestseller());
        dto.setStatus(product.getStatus());
        dto.setImage_url(product.getImageUrl());
        dto.setStock_quantity(product.getStockQuantity());
        dto.setNote(product.getNote());
        dto.setCreated_at(product.getCreatedAt());
        dto.setUpdated_at(product.getUpdatedAt());
        return dto;
    }
    
    public static Product toEntity(ProductDto dto) {
        if (dto == null) return null;
        
        Product product = new Product();
        product.setProductId(dto.getProduct_id());
        product.setSku(dto.getSku());
        product.setName(dto.getName());
        product.setCategory(dto.getCategory());
        product.setDescription(dto.getDescription());
        product.setPrice(dto.getPrice());
        product.setIsBestseller(dto.isIs_bestseller());
        product.setStatus(dto.getStatus());
        product.setImageUrl(dto.getImage_url());
        product.setStockQuantity(dto.getStock_quantity());
        product.setNote(dto.getNote());
        product.setCreatedAt(dto.getCreated_at());
        product.setUpdatedAt(dto.getUpdated_at());
        return product;
    }
}
