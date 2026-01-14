package dao;

import model.Setting;
import java.sql.*;
import java.time.OffsetDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class SettingDaoJdbc implements SettingDao {

    @Override
    public List<Setting> findAll() {
        List<Setting> list = new ArrayList<>();
        String sql = "SELECT setting_id, name, value, datatype, category, status, description, note, updated_by, created_at, updated_at FROM settings ORDER BY category, name";

        DBConnect db = new DBConnect();
        try (Connection con = db.getConnection()) {
            if (con == null) {
                System.err.println("Database connection is null in SettingDaoJdbc.findAll()");
                return list;
            }

            try (PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

                System.out.println("Executing query: " + sql);
                int count = 0;
                while (rs.next()) {
                    list.add(mapRow(rs));
                    count++;
                }
                System.out.println("Found " + count + " settings in database");
            }
        } catch (Exception e) {
            System.err.println("Error finding all settings: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Error finding all settings", e);
        } finally {
            db.close();
        }
        return list;
    }

    @Override
    public Optional<Setting> findById(String id) {
        String sql = "SELECT setting_id, name, value, datatype, category, status, description, note, updated_by, created_at, updated_at FROM settings WHERE setting_id = ?";

        DBConnect db = new DBConnect();
        try (Connection con = db.getConnection()) {
            if (con == null) {
                System.err.println("Database connection is null in SettingDaoJdbc.findById()");
                return Optional.empty();
            }

            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, id);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        System.out.println("Found setting with ID: " + id);
                        return Optional.of(mapRow(rs));
                    } else {
                        System.out.println("No setting found with ID: " + id);
                    }
                }
            }
        } catch (Exception e) {
            System.err.println("Error finding setting by id: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Error finding setting by id", e);
        } finally {
            db.close();
        }
        return Optional.empty();
    }

    @Override
    public void insert(Setting setting) {
        String sql = "INSERT INTO settings (setting_id, name, value, datatype, category, status, description, note, updated_by) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        DBConnect db = new DBConnect();
        Connection con = null;
        try {
            con = db.getConnection();
            if (con == null) {
                throw new RuntimeException("Database connection is null");
            }
            
            // Set auto-commit to false for transaction control
            con.setAutoCommit(false);

            // Generate new setting ID in format ST001, ST002, etc.
            String newId = generateNextSettingId(con);
            System.out.println("DEBUG: Generated setting ID: " + newId);
            setting.setSettingId(newId);

            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, newId);
                ps.setString(2, setting.getName());
                ps.setString(3, setting.getValue());
                ps.setString(4, setting.getDatatype());
                ps.setString(5, setting.getCategory());
                ps.setString(6, setting.getStatus());
                ps.setString(7, setting.getDescription());
                ps.setString(8, setting.getNote() != null ? setting.getNote() : "");
                
                if (setting.getUpdatedBy() != null) {
                    ps.setInt(9, setting.getUpdatedBy());
                } else {
                    ps.setNull(9, java.sql.Types.INTEGER);
                }

                ps.executeUpdate();
                con.commit();
                System.out.println("DEBUG: Setting inserted successfully with ID: " + newId);
            }

        } catch (Exception e) {
            if (con != null) {
                try {
                    con.rollback();
                } catch (SQLException ex) {
                    System.err.println("Error rolling back transaction: " + ex.getMessage());
                }
            }
            e.printStackTrace();
            throw new RuntimeException("Error inserting setting", e);
        } finally {
            if (con != null) {
                try {
                    con.setAutoCommit(true);
                } catch (SQLException e) {
                    System.err.println("Error resetting auto-commit: " + e.getMessage());
                }
            }
            db.close();
        }
    }

    @Override
    public void update(Setting setting) {
        String sql = "UPDATE settings SET name=?, value=?, datatype=?, category=?, status=?, description=?, note=?, updated_by=?, updated_at=GETDATE() WHERE setting_id=?";

        DBConnect db = new DBConnect();
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, setting.getName());
            ps.setString(2, setting.getValue());
            ps.setString(3, setting.getDatatype());
            ps.setString(4, setting.getCategory());
            ps.setString(5, setting.getStatus());
            ps.setString(6, setting.getDescription());
            ps.setString(7, setting.getNote() != null ? setting.getNote() : "");
            
            if (setting.getUpdatedBy() != null) {
                ps.setInt(8, setting.getUpdatedBy());
            } else {
                ps.setNull(8, java.sql.Types.INTEGER);
            }
            
            ps.setString(9, setting.getSettingId());
            ps.executeUpdate();

        } catch (Exception e) {
            throw new RuntimeException("Error updating setting", e);
        } finally {
            db.close();
        }
    }

    @Override
    public void delete(String id) {
        String sql = "DELETE FROM settings WHERE setting_id=?";

        DBConnect db = new DBConnect();
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, id);
            ps.executeUpdate();

        } catch (Exception e) {
            throw new RuntimeException("Error deleting setting", e);
        } finally {
            db.close();
        }
    }

    @Override
    public List<Setting> findByCategory(String category) {
        List<Setting> list = new ArrayList<>();
        String sql = "SELECT setting_id, name, value, datatype, category, status, description, note, updated_by, created_at, updated_at FROM settings WHERE category=? ORDER BY name";

        DBConnect db = new DBConnect();
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, category);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (Exception e) {
            throw new RuntimeException("Error finding settings by category", e);
        } finally {
            db.close();
        }
        return list;
    }

    @Override
    public String generateNextSettingId() {
        DBConnect db = new DBConnect();
        Connection con = null;
        try {
            con = db.getConnection();
            if (con == null) {
                throw new RuntimeException("Database connection is null");
            }
            return generateNextSettingId(con);
        } finally {
            db.close();
        }
    }

    private String generateNextSettingId(Connection con) {
        // Find the highest existing setting ID and increment it
        String sql = "SELECT MAX(setting_id) FROM settings WHERE setting_id LIKE 'ST%'";

        try (PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                String maxId = rs.getString(1);
                if (maxId != null && maxId.startsWith("ST")) {
                    try {
                        int num = Integer.parseInt(maxId.substring(2));
                        return String.format("ST%03d", num + 1);
                    } catch (NumberFormatException e) {
                        // If parsing fails, start from ST001
                        System.err.println("Warning: Could not parse last setting ID: " + maxId);
                    }
                }
            }
        } catch (Exception e) {
            System.err.println("Error generating setting ID: " + e.getMessage());
            e.printStackTrace();
            // If query fails, start from ST001
        }

        // Default to ST001 if no settings exist or query fails
        return "ST001";
    }

    private Setting mapRow(ResultSet rs) throws SQLException {
        Setting s = new Setting();

        s.setSettingId(rs.getString("setting_id"));
        s.setName(rs.getString("name"));
        s.setValue(rs.getString("value"));
        s.setDatatype(rs.getString("datatype"));
        s.setCategory(rs.getString("category"));
        s.setStatus(rs.getString("status"));
        s.setDescription(rs.getString("description"));
        s.setNote(rs.getString("note"));

        // ✅ Đọc updated_by an toàn cho kiểu int nullable
        int upd = rs.getInt("updated_by");
        if (rs.wasNull()) {
            s.setUpdatedBy(null);
        } else {
            s.setUpdatedBy(upd);
        }

        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            s.setCreatedAt(createdAt.toLocalDateTime());
        }
        
        Timestamp updatedAt = rs.getTimestamp("updated_at");
        if (updatedAt != null) {
            s.setUpdatedAt(updatedAt.toLocalDateTime());
        }

        return s;
    }
}
