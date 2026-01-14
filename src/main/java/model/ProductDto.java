package model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class ProductDto {
    private String product_id;
    private String sku;
    private String name;
    private String category;
    private String description;
    private BigDecimal price;
    private boolean is_bestseller;
    private String status;
    private String image_url;
    private int stock_quantity;
    private String note;
    private Timestamp created_at;
    private Timestamp updated_at;

    public ProductDto() {
    }

    public ProductDto(String product_id, String sku, String name, String category, String description,
                      BigDecimal price, boolean is_bestseller, String status,
                      Timestamp created_at, Timestamp updated_at) {
        this.product_id = product_id;
        this.sku = sku;
        this.name = name;
        this.category = category;
        this.description = description;
        this.price = price;
        this.is_bestseller = is_bestseller;
        this.status = status;
        this.created_at = created_at;
        this.updated_at = updated_at;
    }

    public String getProduct_id() {
        return product_id;
    }

    public void setProduct_id(String product_id) {
        this.product_id = product_id;
    }

    // Alias for JSP compatibility
    public String getProductId() {
        return product_id;
    }

    public void setProductId(String productId) {
        this.product_id = productId;
    }

    public String getSku() {
        return sku;
    }

    public void setSku(String sku) {
        this.sku = sku;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public boolean isIs_bestseller() {
        return is_bestseller;
    }

    public void setIs_bestseller(boolean is_bestseller) {
        this.is_bestseller = is_bestseller;
    }

    // Alias for JSP compatibility
    public boolean getIsBestseller() {
        return is_bestseller;
    }

    public void setIsBestseller(boolean isBestseller) {
        this.is_bestseller = isBestseller;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCreated_at() {
        return created_at;
    }

    public void setCreated_at(Timestamp created_at) {
        this.created_at = created_at;
    }

    public Timestamp getUpdated_at() {
        return updated_at;
    }

    public void setUpdated_at(Timestamp updated_at) {
        this.updated_at = updated_at;
    }

    // Alias for JSP compatibility
    public Timestamp getCreatedAt() {
        return created_at;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.created_at = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updated_at;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updated_at = updatedAt;
    }

    // Format price for display
    public String getPriceFormatted() {
        if (price != null) {
            return String.format("%,.0f VND", price.doubleValue());
        }
        return "0 VND";
    }

    public String getImage_url() {
        return image_url;
    }

    public void setImage_url(String image_url) {
        this.image_url = image_url;
    }

    // Aliases for JSP compatibility
    public String getImageUrl() {
        return image_url;
    }

    public void setImageUrl(String imageUrl) {
        this.image_url = imageUrl;
    }

    public int getStock_quantity() {
        return stock_quantity;
    }

    public void setStock_quantity(int stock_quantity) {
        this.stock_quantity = stock_quantity;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    // Aliases for JSP compatibility
    public Integer getStockQuantity() {
        return stock_quantity;
    }

    public void setStockQuantity(int stockQuantity) {
        this.stock_quantity = stockQuantity;
    }

    // (keep single alias methods only; avoid duplicates)

    @Override
    public String toString() {
        return "ProductDto{" + "product_id=" + product_id + ", sku=" + sku + ", name=" + name + ", category=" + category + ", description=" + description + ", price=" + price + ", is_bestseller=" + is_bestseller + ", status=" + status + ", image_url=" + image_url + ", stock_quantity=" + stock_quantity + ", note=" + note + ", created_at=" + created_at + ", updated_at=" + updated_at + '}';
    }

}
