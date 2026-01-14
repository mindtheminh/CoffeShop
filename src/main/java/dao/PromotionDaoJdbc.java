package dao;

import model.Promotion;

import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDateTime;
import java.time.OffsetDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class PromotionDaoJdbc implements PromotionDao {
    private final Connection con;
    
    public PromotionDaoJdbc(Connection con) { this.con = con; }

    // Loc danh sach khuyen mai theo tu khoa loai trang thai va pham vi
    public List<Promotion> findAll(String search, String type, String status, String applyToAll) throws SQLException {
        StringBuilder sql = new StringBuilder(
            "SELECT promotion_id, promotion_code, name, type, value, min_order_value, " +
            "start_date, end_date, status, apply_to_all, max_uses, uses_count, " +
            "description, note, created_at, updated_at " +
            "FROM promotions WHERE 1=1 "
        );
        List<Object> params = new ArrayList<>();

        if (search != null && !search.isBlank()) {
            sql.append(" AND (LOWER(name) LIKE ? OR LOWER(promotion_code) LIKE ? OR LOWER(description) LIKE ?) ");
            String kw = "%" + search.toLowerCase().trim() + "%";
            params.add(kw); params.add(kw); params.add(kw);
        }
        if (type != null && !type.isBlank()) { sql.append(" AND type = ? "); params.add(type); }
        if (status != null && !status.isBlank()) { sql.append(" AND status = ? "); params.add(status); }
        if (applyToAll != null && !applyToAll.isBlank()) {
            sql.append(" AND apply_to_all = ? ");
            params.add(Boolean.parseBoolean(applyToAll));
        }
        sql.append(" ORDER BY created_at DESC, promotion_id DESC");

        try (PreparedStatement ps = con.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) ps.setObject(i + 1, params.get(i));
            try (ResultSet rs = ps.executeQuery()) {
                List<Promotion> list = new ArrayList<>();
                while (rs.next()) list.add(mapRow(rs));
                return list;
            }
        }
    }

    // Chuyen dong du lieu ResultSet thanh doi tuong Promotion
    private Promotion mapRow(ResultSet rs) throws SQLException {
        Promotion p = new Promotion();
        p.setPromotionId(rs.getString("promotion_id"));
        p.setCode(rs.getString("promotion_code"));
        p.setName(rs.getString("name"));
        p.setType(rs.getString("type"));

        p.setValue((BigDecimal) rs.getObject("value"));               // giữ null nếu null
        p.setMinOrderValue((BigDecimal) rs.getObject("min_order_value"));

        Date sd = rs.getDate("start_date");                           // DATE -> LocalDate
        Date ed = rs.getDate("end_date");
        p.setStartDate(sd == null ? null : sd.toLocalDate());
        p.setEndDate(ed == null ? null : ed.toLocalDate());

        p.setStatus(rs.getString("status"));
        p.setApplyToAll((Boolean) rs.getObject("apply_to_all"));      // BIT -> Boolean (null-safe)

        p.setMaxUses((Integer) rs.getObject("max_uses"));
        p.setUsesCount((Integer) rs.getObject("uses_count"));
        p.setDescription(rs.getString("description"));
        p.setNote(rs.getString("note"));

        OffsetDateTime cat = rs.getObject("created_at", OffsetDateTime.class);
        OffsetDateTime uat = rs.getObject("updated_at", OffsetDateTime.class);
        p.setCreatedAt(cat);
        p.setUpdatedAt(uat);

        return p;
    }

    @Override
    // Lay tat ca khuyen mai sap xep theo thoi gian tao
    public List<Promotion> findAll() {
        String sql = "SELECT promotion_id, promotion_code, name, type, value, min_order_value, start_date, end_date, status, apply_to_all, max_uses, uses_count, description, note, created_at, updated_at FROM promotions ORDER BY created_at DESC";
        List<Promotion> list = new ArrayList<>();
        try (PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            throw new RuntimeException("Error loading promotions", e);
        }
        return list;
    }

    @Override
    // Tim khuyen mai theo ma
    public Optional<Promotion> findById(String id) {
        String sql = "SELECT promotion_id, promotion_code, name, type, value, min_order_value, start_date, end_date, status, apply_to_all, max_uses, uses_count, description, note, created_at, updated_at FROM promotions WHERE promotion_id = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return Optional.of(mapRow(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding promotion by id", e);
        }
        return Optional.empty();
    }

    @Override
    // Tao moi khuyen mai va tra ve ma vua tao
    public String create(Promotion promotion) {
        String sql = "INSERT INTO promotions (promotion_id, promotion_code, name, type, value, min_order_value, start_date, end_date, status, apply_to_all, max_uses, uses_count, description, note, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)";
        String newId = generateId();
        
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            if (con == null) {
                throw new RuntimeException("Database connection is null");
            }
            
            // Log promotion data for debugging
            System.out.println("Creating promotion with ID: " + newId);
            System.out.println("Code: " + promotion.getCode());
            System.out.println("Name: " + promotion.getName());
            System.out.println("Type: " + promotion.getType());
            System.out.println("Value: " + promotion.getValue());
            System.out.println("MinOrderValue: " + promotion.getMinOrderValue());
            System.out.println("StartDate: " + promotion.getStartDate());
            System.out.println("EndDate: " + promotion.getEndDate());
            System.out.println("Status: " + promotion.getStatus());
            System.out.println("ApplyToAll: " + promotion.getApplyToAll());
            System.out.println("MaxUses: " + promotion.getMaxUses());
            System.out.println("UsesCount: " + (promotion.getUsesCount() != null ? promotion.getUsesCount() : 0));
            System.out.println("Description: " + promotion.getDescription());
            System.out.println("Note: " + promotion.getNote());
            
            ps.setString(1, newId);
            ps.setString(2, promotion.getCode());
            ps.setString(3, promotion.getName());
            ps.setString(4, promotion.getType());
            if (promotion.getValue() != null) {
                ps.setBigDecimal(5, promotion.getValue());
            } else {
                ps.setNull(5, Types.NUMERIC);
            }
            if (promotion.getMinOrderValue() != null) {
                ps.setBigDecimal(6, promotion.getMinOrderValue());
            } else {
                ps.setNull(6, Types.NUMERIC);
            }
            ps.setDate(7, promotion.getStartDate() == null ? null : java.sql.Date.valueOf(promotion.getStartDate()));
            ps.setDate(8, promotion.getEndDate() == null ? null : java.sql.Date.valueOf(promotion.getEndDate()));
            ps.setString(9, promotion.getStatus());
            if (promotion.getApplyToAll() != null) {
                ps.setBoolean(10, promotion.getApplyToAll());
            } else {
                ps.setNull(10, Types.BOOLEAN);
            }
            if (promotion.getMaxUses() != null) {
                ps.setInt(11, promotion.getMaxUses());
            } else {
                ps.setNull(11, Types.INTEGER);
            }
            ps.setInt(12, promotion.getUsesCount() != null ? promotion.getUsesCount() : 0);
            ps.setString(13, promotion.getDescription());
            ps.setString(14, promotion.getNote());
            
            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("Promotion created successfully with ID: " + newId);
                return newId;
            } else {
                throw new RuntimeException("No rows affected when creating promotion");
            }
        } catch (SQLException e) {
            String sqlMessage = e.getMessage();
            String sqlState = e.getSQLState();
            int errorCode = e.getErrorCode();
            
            System.err.println("=== SQL ERROR ===");
            System.err.println("Message: " + sqlMessage);
            System.err.println("SQL State: " + sqlState);
            System.err.println("Error Code: " + errorCode);
            e.printStackTrace();
            
            // Build detailed error message
            StringBuilder errorMsg = new StringBuilder("SQL Error");
            if (sqlMessage != null && !sqlMessage.isEmpty()) {
                errorMsg.append(": ").append(sqlMessage);
            } else {
                errorMsg.append(" (Code: ").append(errorCode).append(", State: ").append(sqlState).append(")");
            }
            
            throw new RuntimeException(errorMsg.toString(), e);
        } catch (Exception e) {
            String errorMsg = e.getMessage();
            System.err.println("=== UNEXPECTED ERROR ===");
            System.err.println("Exception type: " + e.getClass().getName());
            System.err.println("Message: " + errorMsg);
            e.printStackTrace();
            
            // Build error message
            String finalMsg = "Unexpected error";
            if (errorMsg != null && !errorMsg.isEmpty()) {
                finalMsg = "Error: " + errorMsg;
            } else {
                finalMsg = "Error: " + e.getClass().getSimpleName();
            }
            
            throw new RuntimeException(finalMsg, e);
        }
    }

    // Tao ma khuyen mai moi dang PRxxx tang dan
    private String generateId() {
        // Tạo ID tăng dần theo thứ tự: PR001, PR002, PR003, ..., PR021, PR022...
        String sql = "SELECT promotion_id FROM promotions WHERE promotion_id LIKE 'PR%' ORDER BY CAST(SUBSTRING(promotion_id FROM 3) AS INTEGER) DESC LIMIT 1";
        
        try (PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            int nextNumber = 1;
            
            if (rs.next()) {
                String lastId = rs.getString("promotion_id");
                if (lastId != null && lastId.startsWith("PR") && lastId.length() > 2) {
                    try {
                        String numberPart = lastId.substring(2); // Lấy phần số sau "PR"
                        int lastNumber = Integer.parseInt(numberPart);
                        nextNumber = lastNumber + 1;
                    } catch (NumberFormatException e) {
                        // Nếu không parse được, bắt đầu từ 1
                        System.err.println("Warning: Could not parse last promotion ID: " + lastId);
                        nextNumber = 1;
                    }
                }
            }
            
            // Format ID với leading zeros: PR001, PR002, ..., PR999
            return String.format("PR%03d", nextNumber);
            
        } catch (SQLException e) {
            System.err.println("Error generating promotion ID: " + e.getMessage());
            e.printStackTrace();
            // Fallback: sử dụng timestamp nếu có lỗi
            return "PR" + String.valueOf(System.currentTimeMillis()).substring(7);
        }
    }

    @Override
    // Cap nhat khuyen mai
    public boolean update(Promotion promotion) {
        String sql = "UPDATE promotions SET promotion_code=?, name=?, type=?, value=?, min_order_value=?, start_date=?, end_date=?, status=?, apply_to_all=?, max_uses=?, description=?, note=?, updated_at=CURRENT_TIMESTAMP WHERE promotion_id=?";
        
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            if (con == null) {
                throw new RuntimeException("Database connection is null");
            }
            
            System.out.println("Updating promotion: " + promotion.getPromotionId());
            System.out.println("Code: " + promotion.getCode());
            System.out.println("Name: " + promotion.getName());
            System.out.println("Type: " + promotion.getType());
            System.out.println("Value: " + promotion.getValue());
            System.out.println("MinOrderValue: " + promotion.getMinOrderValue());
            System.out.println("StartDate: " + promotion.getStartDate());
            System.out.println("EndDate: " + promotion.getEndDate());
            System.out.println("Status: " + promotion.getStatus());
            System.out.println("ApplyToAll: " + promotion.getApplyToAll());
            System.out.println("MaxUses: " + promotion.getMaxUses());
            System.out.println("Description: " + promotion.getDescription());
            System.out.println("Note: " + promotion.getNote());
            
            ps.setString(1, promotion.getCode());
            ps.setString(2, promotion.getName());
            ps.setString(3, promotion.getType());
            if (promotion.getValue() != null) {
                ps.setBigDecimal(4, promotion.getValue());
            } else {
                ps.setNull(4, Types.NUMERIC);
            }
            if (promotion.getMinOrderValue() != null) {
                ps.setBigDecimal(5, promotion.getMinOrderValue());
            } else {
                ps.setNull(5, Types.NUMERIC);
            }
            ps.setDate(6, promotion.getStartDate() == null ? null : java.sql.Date.valueOf(promotion.getStartDate()));
            ps.setDate(7, promotion.getEndDate() == null ? null : java.sql.Date.valueOf(promotion.getEndDate()));
            ps.setString(8, promotion.getStatus());
            if (promotion.getApplyToAll() != null) {
                ps.setBoolean(9, promotion.getApplyToAll());
            } else {
                ps.setNull(9, Types.BOOLEAN);
            }
            if (promotion.getMaxUses() != null) {
                ps.setInt(10, promotion.getMaxUses());
            } else {
                ps.setNull(10, Types.INTEGER);
            }
            ps.setString(11, promotion.getDescription());
            ps.setString(12, promotion.getNote());
            ps.setString(13, promotion.getPromotionId());
            
            int rowsAffected = ps.executeUpdate();
            System.out.println("Rows affected: " + rowsAffected);
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("SQL Error updating promotion: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Error updating promotion: " + e.getMessage(), e);
        }
    }

    @Override
    public boolean deleteById(String id) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public List<Promotion> findByStatus(String status) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public List<Promotion> findActivePromotions() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public Optional<Promotion> findByCode(String code) {
        String sql = "SELECT promotion_id, promotion_code, name, type, value, min_order_value, start_date, end_date, status, apply_to_all, max_uses, uses_count, description, note, created_at, updated_at FROM promotions WHERE LOWER(promotion_code) = LOWER(?)";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, code);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding promotion by code", e);
        }
        return Optional.empty();
    }

    @Override
    public List<Promotion> findByType(String type) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public boolean incrementUsageCount(String promotionId) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public List<Promotion> findExpiringPromotions(int days) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public boolean updatePromotionDetails(String promotionId, String name, String code, String description) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public boolean updatePromotionValue(String promotionId, double value) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public boolean updatePromotionDates(String promotionId, LocalDateTime startDate, LocalDateTime endDate) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
    
    // Methods for managing promotion_products
    // Gan danh sach san pham cho khuyen mai
    public void addProductsToPromotion(String promotionId, List<String> productIds) throws SQLException {
        if (productIds == null || productIds.isEmpty()) {
            return;
        }
        
        // Delete existing products for this promotion
        deleteProductsFromPromotion(promotionId);
        
        // Insert new products
        String sql = "INSERT INTO promotion_products (promotion_id, product_id) VALUES (?, ?)";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            for (String productId : productIds) {
                ps.setString(1, promotionId);
                ps.setString(2, productId);
                ps.addBatch();
            }
            ps.executeBatch();
            System.out.println("Added " + productIds.size() + " products to promotion " + promotionId);
        }
    }
    
    // Xoa tat ca san pham gan voi khuyen mai
    public void deleteProductsFromPromotion(String promotionId) throws SQLException {
        String sql = "DELETE FROM promotion_products WHERE promotion_id = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, promotionId);
            int deleted = ps.executeUpdate();
            System.out.println("Deleted " + deleted + " products from promotion " + promotionId);
        }
    }
    
    // Lay danh sach ma san pham thuoc khuyen mai
    public List<String> getProductIdsByPromotionId(String promotionId) throws SQLException {
        List<String> productIds = new ArrayList<>();
        String sql = "SELECT product_id FROM promotion_products WHERE promotion_id = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, promotionId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    productIds.add(rs.getString("product_id"));
                }
            }
        }
        return productIds;
    }
}
