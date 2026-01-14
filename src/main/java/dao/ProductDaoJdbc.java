package dao;

import model.Product;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;
import model.ProductDto;

public class ProductDaoJdbc implements ProductDao {

    // Lay danh sach san pham va sap xep theo ma giam dan
    @Override
    public List<Product> findAll() {
        System.out.println("DEBUG: ProductDaoJdbc.findAll called");
        List<Product> list = new ArrayList<>();
        String sql = "SELECT product_id, name, category, description, price, is_bestseller, status, image_url, stock_quantity, note FROM products ORDER BY product_id DESC";

        DBConnect db = new DBConnect();
        Connection con = db.getConnection();

        if (con == null) {
            System.err.println("Database connection is null in ProductDaoJdbc.findAll()");
            return list; // Return empty list instead of throwing exception
        }

        try (PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            System.out.println("DEBUG: Executing findAll query");
            while (rs.next()) {
                Product product = mapRow(rs);
                System.out.println("DEBUG: Found product: " + product.getProductId() + " - " + product.getName());
                list.add(product);
            }
            System.out.println("DEBUG: Total products found: " + list.size());
        } catch (Exception e) {
            System.out.println("DEBUG: Exception in findAll: " + e.getMessage());
            e.printStackTrace();
            // Don't throw exception, just return empty list
        } finally {
            db.close();
        }
        return list;
    }

    // Tim san pham theo ma va tra ve DTO
    @Override
    public ProductDto findById(String productId) {
        String sql = "SELECT product_id, name, category, description, price, is_bestseller, "
                + "       status, image_url, stock_quantity, note, created_at, updated_at "
                + "FROM products "
                + "WHERE product_id=?";
        DBConnect db = new DBConnect();

        try (Connection conn = db.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, productId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    ProductDto p = new ProductDto();

                    // === BẮT ĐẦU ÁNH XẠ ĐẦY ĐỦ CÁC TRƯỜNG ===
                    p.setProductId(rs.getString("product_id"));
                    p.setName(rs.getString("name"));
                    p.setCategory(rs.getString("category"));
                    p.setDescription(rs.getString("description"));
                    p.setPrice(rs.getBigDecimal("price"));
                    p.setIsBestseller(rs.getBoolean("is_bestseller")); // boolean
                    p.setStatus(rs.getString("status"));
                    p.setImageUrl(rs.getString("image_url"));
                    p.setStockQuantity(rs.getInt("stock_quantity")); // int
                    p.setNote(rs.getString("note"));
                    p.setCreated_at(rs.getTimestamp("created_at"));
                    p.setUpdated_at(rs.getTimestamp("updated_at"));
                    // (Không cần set SKU vì DB của bạn không có SKU)

                    return p;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            db.close();
        }
        return null;
    }

    // Chen san pham moi vao co so du lieu
    @Override
    public void insert(Product product) {
        System.out.println("DEBUG: ProductDaoJdbc.insert called for product: " + product.getName());
        String sql = "INSERT INTO products (product_id, name, category, description, price, is_bestseller, status, image_url, stock_quantity, note) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        DBConnect db = new DBConnect();
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = db.getConnection();
            if (con == null) {
                throw new RuntimeException("Database connection is null");
            }

            con.setAutoCommit(false);

            String newId = generateProductId(con);
            System.out.println("DEBUG: Generated product ID: " + newId);
            product.setProductId(newId);

            ps = con.prepareStatement(sql);
            ps.setString(1, newId);
            ps.setString(2, product.getName());
            ps.setString(3, product.getCategory());
            ps.setString(4, product.getDescription());
            ps.setBigDecimal(5, product.getPrice());
            ps.setBoolean(6, product.getIsBestseller());
            ps.setString(7, product.getStatus());
            ps.setString(8, product.getImageUrl());
            ps.setInt(9, product.getStockQuantity());
            ps.setString(10, product.getNote());

            System.out.println("DEBUG: Executing insert query...");
            System.out.println("DEBUG: SQL: " + sql);
            System.out.println("DEBUG: Parameters: " + newId + ", " + product.getName() + ", " + product.getCategory() + ", " + product.getDescription() + ", " + product.getPrice() + ", " + product.getIsBestseller() + ", " + product.getStatus() + ", " + product.getImageUrl() + ", " + product.getStockQuantity() + ", " + product.getNote());

            int rowsAffected = ps.executeUpdate();
            System.out.println("DEBUG: Insert successful! Rows affected: " + rowsAffected);

            con.commit();
            System.out.println("DEBUG: Transaction committed");
        } catch (Exception e) {
            System.err.println("DEBUG: Error inserting product: " + e.getMessage());
            e.printStackTrace();
            if (con != null) {
                try {
                    con.rollback();
                    System.out.println("DEBUG: Transaction rolled back");
                } catch (SQLException rollbackEx) {
                    System.err.println("DEBUG: Error rolling back transaction: " + rollbackEx.getMessage());
                }
            }
            throw new RuntimeException("Error inserting product: " + e.getMessage(), e);
        } finally {
            if (ps != null) {
                try { ps.close(); } catch (SQLException ignore) {}
            }
            db.close();
        }
    }

    // Cap nhat thong tin san pham
    @Override
    public void update(Product product) {
        String sql = "UPDATE products SET name=?, category=?, description=?, price=?, is_bestseller=?, status=?, image_url=?, stock_quantity=?, note=?, updated_at=CURRENT_TIMESTAMP WHERE product_id=?";
        System.out.println("DEBUG: ProductDaoJdbc.update called for product: " + product.getProductId());

        DBConnect db = new DBConnect();
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, product.getName());
            ps.setString(2, product.getCategory());
            ps.setString(3, product.getDescription());
            ps.setBigDecimal(4, product.getPrice());
            ps.setBoolean(5, product.getIsBestseller());
            ps.setString(6, product.getStatus());
            ps.setString(7, product.getImageUrl());
            ps.setInt(8, product.getStockQuantity());
            ps.setString(9, product.getNote());
            ps.setString(10, product.getProductId());

            System.out.println("DEBUG: Executing update with imageUrl: " + product.getImageUrl());
            int rowsAffected = ps.executeUpdate();
            System.out.println("DEBUG: Update successful! Rows affected: " + rowsAffected);

        } catch (Exception e) {
            System.err.println("DEBUG: Error updating product: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Error updating product", e);
        } finally {
            db.close();
        }
    }

    // Xoa san pham theo ma
    @Override
    public void delete(String id) {
        String sql = "DELETE FROM products WHERE product_id=?";

        DBConnect db = new DBConnect();
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, id);
            ps.executeUpdate();

        } catch (Exception e) {
            throw new RuntimeException("Error deleting product", e);
        } finally {
            db.close();
        }
    }

    // Loc san pham theo danh muc
    @Override
    public List<Product> findByCategory(String category) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT product_id, name, category, description, price, is_bestseller, status, image_url, stock_quantity, note FROM products WHERE category=? ORDER BY product_id DESC";

        DBConnect db = new DBConnect();
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, category);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (Exception e) {
            throw new RuntimeException("Error finding products by category", e);
        } finally {
            db.close();
        }
        return list;
    }

    // Loc san pham theo trang thai
    @Override
    public List<Product> findByStatus(String status) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT product_id, name, category, description, price, is_bestseller, status, image_url, stock_quantity, note FROM products WHERE status=? ORDER BY product_id DESC";

        DBConnect db = new DBConnect();
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (Exception e) {
            throw new RuntimeException("Error finding products by status", e);
        } finally {
            db.close();
        }
        return list;
    }

    // Chuyen dong du lieu thanh doi tuong Product
    private Product mapRow(ResultSet rs) throws SQLException {
        Product p = new Product();

        p.setProductId(rs.getString("product_id"));
        p.setSku("");
        p.setName(rs.getString("name"));
        p.setCategory(rs.getString("category"));
        p.setDescription(rs.getString("description"));
        p.setPrice(rs.getBigDecimal("price"));
        p.setIsBestseller(rs.getBoolean("is_bestseller"));
        p.setStatus(rs.getString("status"));
        p.setImageUrl(rs.getString("image_url")); // Add image_url mapping
        p.setStockQuantity(rs.getInt("stock_quantity")); // Add stock_quantity mapping
        p.setNote(rs.getString("note"));
        p.setCreatedAt(new java.sql.Timestamp(System.currentTimeMillis())); // Default timestamp
        p.setUpdatedAt(new java.sql.Timestamp(System.currentTimeMillis())); // Default timestamp
        return p;
    }

    // Tao ma san pham moi dang Pxxx
    private String generateProductId(Connection con) {
        // Find the highest existing product ID and increment it
        String sql = "SELECT MAX(product_id) FROM products WHERE product_id LIKE 'P%'";

        try (PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                String maxId = rs.getString(1);
                if (maxId != null && maxId.startsWith("P")) {
                    try {
                        int num = Integer.parseInt(maxId.substring(1));
                        return String.format("P%03d", num + 1);
                    } catch (NumberFormatException e) {
                        // If parsing fails, start from P001
                    }
                }
            }
        } catch (Exception e) {
            System.err.println("DEBUG: Error generating product ID: " + e.getMessage());
            // If query fails, start from P001
        }

        // Default to P001 if no products exist or query fails
        return "P001";
    }

    // Lay danh sach san pham dang trang thai Activate
    public List<ProductDto> getAllProductsActive() {
        List<ProductDto> products = new ArrayList<>();
//bỏ sku đi vì db ở máy người code hiện k có sku
        String sql = "SELECT product_id,  name, category, description, price, "
                + "is_bestseller, status, image_url, stock_quantity, note, created_at, updated_at "
                + "FROM products "
                + "WHERE status = 'Activate'";

        DBConnect db = new DBConnect();

        try (Connection conn = db.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                ProductDto p = new ProductDto();
                p.setProduct_id(rs.getString("product_id"));
//                p.setSku(rs.getString("sku"));
                p.setName(rs.getString("name"));
                p.setCategory(rs.getString("category"));
                p.setDescription(rs.getString("description"));
                p.setPrice(rs.getBigDecimal("price"));
                p.setIsBestseller(rs.getBoolean("is_bestseller"));
                p.setStatus(rs.getString("status"));
                p.setImage_url(rs.getString("image_url"));
                p.setStock_quantity(rs.getInt("stock_quantity"));
                p.setNote(rs.getString("note"));
                p.setCreated_at(rs.getTimestamp("created_at"));
                p.setUpdated_at(rs.getTimestamp("updated_at"));
                products.add(p);
            }

        } catch (SQLException e) {
            System.err.println("Lỗi truy vấn getAllActiveProducts(): " + e.getMessage());
        } finally {
            db.close();
        }

        return products;
    }

    // New methods for Product Details page
    // Cap nhat thong tin chi tiet san pham tren trang detail
    @Override
    public void updateDetails(Product product) {
        String sql = "UPDATE products SET name=?, category=?, description=?, note=?, updated_at=CURRENT_TIMESTAMP WHERE product_id=?";

        DBConnect db = new DBConnect();
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, product.getName());
            ps.setString(2, product.getCategory());
            ps.setString(3, product.getDescription());
            ps.setString(4, product.getNote());
            ps.setString(5, product.getProductId());
            ps.executeUpdate();

        } catch (Exception e) {
            throw new RuntimeException("Error updating product details", e);
        } finally {
            db.close();
        }
    }

    // Cap nhat gia san pham
    @Override
    public void updatePrice(String id, BigDecimal newPrice) {
        String sql = "UPDATE products SET price=?, updated_at=CURRENT_TIMESTAMP WHERE product_id=?";

        DBConnect db = new DBConnect();
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setBigDecimal(1, newPrice);
            ps.setString(2, id);
            ps.executeUpdate();

        } catch (Exception e) {
            throw new RuntimeException("Error updating product price", e);
        } finally {
            db.close();
        }
    }

    // Cap nhat anh san pham
    @Override
    public void updateImage(String id, String imageUrl) {
        String sql = "UPDATE products SET image_url=?, updated_at=CURRENT_TIMESTAMP WHERE product_id=?";

        DBConnect db = new DBConnect();
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, imageUrl);
            ps.setString(2, id);
            ps.executeUpdate();

        } catch (Exception e) {
            throw new RuntimeException("Error updating product image", e);
        } finally {
            db.close();
        }
    }

    // Dao trang thai Activate va Deactivate cua san pham
    @Override
    public void toggleStatus(String id) {
        String sql = "UPDATE products SET status = CASE WHEN status = 'Activate' THEN 'Deactivate' ELSE 'Activate' END, updated_at=CURRENT_TIMESTAMP WHERE product_id=?";

        DBConnect db = new DBConnect();
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, id);
            ps.executeUpdate();

        } catch (Exception e) {
            throw new RuntimeException("Error toggling product status", e);
        } finally {
            db.close();
        }
    }

    // Lay danh sach san pham ban chay nhat
    public List<ProductDto> getBestSaleProducts() {
        ProductDaoJdbc pro = new ProductDaoJdbc();
        List<ProductDto> products = pro.getAllProductsActive();
        List<ProductDto> bestSellers = products.stream()
                // Chỉ đơn giản là kiểm tra nếu giá trị boolean là true
                .filter(p -> p.getIsBestseller())
                .limit(4)
                .collect(Collectors.toList());
        return bestSellers;
    }

    public static void main(String[] args) {
        ProductDaoJdbc dao = new ProductDaoJdbc();

        System.out.println("=== TEST best sale product() ===");

        List<ProductDto> products = dao.getBestSaleProducts();
        if (products == null || products.isEmpty()) {
            System.out.println("Không có sản phẩm nào được kích hoạt (Activate).");
        } else {
            for (ProductDto p : products) {
                System.out.println("----------------------------");
                System.out.println("Mã SP: " + p.getProduct_id());
                System.out.println("SKU: " + p.getSku());
                System.out.println("Tên: " + p.getName());
                System.out.println("Loại: " + p.getCategory());
                System.out.println("Mô tả: " + p.getDescription());
                System.out.println("Giá: " + p.getPrice());
                System.out.println("Bán chạy: " + p.getIsBestseller());
                System.out.println("Trạng thái: " + p.getStatus());
                System.out.println("Tạo lúc: " + p.getCreated_at());
                System.out.println("Cập nhật: " + p.getUpdated_at());
            }
        }
        System.out.println("=== Kết thúc test ===");
    }

}
