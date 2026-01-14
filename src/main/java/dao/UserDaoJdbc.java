package dao;

import model.User;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class UserDaoJdbc implements UserDao {

    private static final String INSERT_SQL =
        "INSERT INTO users (email, password_hash, full_name, role, status, note) VALUES (?, ?, ?, ?, ?, ?)";

    private static final String FIND_BY_EMAIL_SQL =
        "SELECT user_id, email, password_hash, full_name, role, status, note, created_at FROM users WHERE email = ?";

    // Nếu DB bạn KHÔNG có cột reset_token thì câu lệnh này sẽ fail.
    // O duoi minh da boc try/catch va chi log canh bao de khong chan flow khac.
    private static final String CLEAR_RESET_TOKEN_SQL =
        "UPDATE users SET reset_token = NULL WHERE user_id = ?";
    
    private static final String SAVE_RESET_TOKEN_SQL =
        "UPDATE users SET reset_token = ? WHERE email = ?";

    @Override
    public void insert(User u) {
        DBConnect db = new DBConnect();
        Connection con = null;
        PreparedStatement ps = null;
        
        try {
            con = db.getConnection();
            if (con == null) {
                throw new RuntimeException("Cannot get database connection");
            }
            
            ps = con.prepareStatement(INSERT_SQL, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, u.getEmail());
            ps.setString(2, u.getPasswordHash());
            ps.setString(3, u.getFullName());
            ps.setString(4, u.getRole());
            ps.setString(5, u.getStatus());
            ps.setString(6, u.getNote());
            
            int rowsAffected = ps.executeUpdate();
            
            // Get the generated user_id and set it back to the User object
            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        int generatedId = generatedKeys.getInt(1);
                        u.setUserId(String.valueOf(generatedId));
                    }
                }
            }
            if (ps != null) ps.close();

        } catch (SQLException e) {
            // Check if it's a primary key violation
            if (e.getErrorCode() == 2627 || e.getMessage().contains("PRIMARY KEY") || e.getMessage().contains("duplicate key")) {
                System.err.println("[ERROR] Primary key violation detected: " + e.getMessage());
                System.err.println("[INFO] IDENTITY seed may be out of sync. Attempting to auto-fix...");
                
                // Close current statement if open
                if (ps != null) {
                    try { ps.close(); } catch (SQLException ignore) {}
                }
                
                // Try to auto-fix the IDENTITY seed and retry
                boolean isConValid = false;
                try {
                    isConValid = (con != null && !con.isClosed());
                } catch (SQLException ex) {
                    isConValid = false;
                }
                
                if (isConValid) {
                    try {
                        // Fix IDENTITY seed
                        fixIdentitySeed(con);
                        System.err.println("[INFO] IDENTITY seed fixed successfully. Retrying insert...");
                        
                        // Retry the insert after fixing the seed
                        PreparedStatement retryPs = con.prepareStatement(INSERT_SQL, Statement.RETURN_GENERATED_KEYS);
                        retryPs.setString(1, u.getEmail());
                        retryPs.setString(2, u.getPasswordHash());
                        retryPs.setString(3, u.getFullName());
                        retryPs.setString(4, u.getRole());
                        retryPs.setString(5, u.getStatus());
                        retryPs.setString(6, u.getNote());
                        
                        int rowsAffected = retryPs.executeUpdate();
                        
                        if (rowsAffected > 0) {
                            try (ResultSet generatedKeys = retryPs.getGeneratedKeys()) {
                                if (generatedKeys.next()) {
                                    int generatedId = generatedKeys.getInt(1);
                                    u.setUserId(String.valueOf(generatedId));
                                    System.err.println("[INFO] User created successfully with ID: " + generatedId);
                                }
                            }
                        }
                        retryPs.close();
                        db.close(); // Close connection before returning
                        return; // Success!
                    } catch (Exception fixException) {
                        System.err.println("[WARN] Could not auto-fix IDENTITY seed: " + fixException.getMessage());
                        fixException.printStackTrace();
                        // Fall through to throw original exception
                    }
                } else {
                    // Connection is closed, create new one for retry
                    try {
                        db.close(); // Close old connection
                        DBConnect retryDb = new DBConnect();
                        Connection retryCon = retryDb.getConnection();
                        
                        if (retryCon != null) {
                            fixIdentitySeed(retryCon);
                            System.err.println("[INFO] IDENTITY seed fixed. Retrying insert with new connection...");
                            
                            PreparedStatement retryPs = retryCon.prepareStatement(INSERT_SQL, Statement.RETURN_GENERATED_KEYS);
                            retryPs.setString(1, u.getEmail());
                            retryPs.setString(2, u.getPasswordHash());
                            retryPs.setString(3, u.getFullName());
                            retryPs.setString(4, u.getRole());
                            retryPs.setString(5, u.getStatus());
                            retryPs.setString(6, u.getNote());
                            
                            int rowsAffected = retryPs.executeUpdate();
                            
                            if (rowsAffected > 0) {
                                try (ResultSet generatedKeys = retryPs.getGeneratedKeys()) {
                                    if (generatedKeys.next()) {
                                        int generatedId = generatedKeys.getInt(1);
                                        u.setUserId(String.valueOf(generatedId));
                                        System.err.println("[INFO] User created successfully with ID: " + generatedId);
                                    }
                                }
                            }
                            retryPs.close();
                            retryDb.close();
                            return; // Success!
                        }
                    } catch (Exception retryException) {
                        System.err.println("[WARN] Retry with new connection failed: " + retryException.getMessage());
                        retryException.printStackTrace();
                    }
                }
                
                throw new RuntimeException("Failed to create user: IDENTITY seed conflict. The system attempted to fix it automatically but failed. Please contact administrator or run: DBCC CHECKIDENT ('[dbo].[users]', RESEED)", e);
            }
            System.err.println("[ERROR] Insert user failed: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Insert user failed: " + e.getMessage(), e);
        } catch (Exception e) {
            System.err.println("[ERROR] Insert user failed: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Insert user failed: " + e.getMessage(), e);
        } finally {
            if (ps != null) {
                try { ps.close(); } catch (SQLException ignore) {}
            }
            db.close();
        }
    }

    @Override
    public Optional<User> findByEmail(String email) {
        DBConnect db = new DBConnect();
        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(FIND_BY_EMAIL_SQL)) {

            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return Optional.empty();

                User u = new User();
                u.setUserId(rs.getString("user_id"));
                u.setEmail(rs.getString("email"));
                u.setPasswordHash(rs.getString("password_hash"));
                u.setFullName(rs.getString("full_name"));
                u.setRole(rs.getString("role"));
                u.setStatus(rs.getString("status"));
                u.setNote(rs.getString("note"));
                u.setCreatedAt(rs.getObject("created_at", java.time.OffsetDateTime.class));
                return Optional.of(u);
            }

        } catch (Exception e) {
            throw new RuntimeException("Find user by email failed", e);
        } finally {
            db.close();
        }
    }

    @Override
    public void clearResetToken(int userId) {
        DBConnect db = new DBConnect();
        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(CLEAR_RESET_TOKEN_SQL)) {

            ps.setInt(1, userId);
            ps.executeUpdate();

        } catch (Exception e) {
            // DB không có cột reset_token? –> chỉ cảnh báo, không ném lỗi để tránh 500.
            System.err.println("[WARN] clearResetToken skipped: " + e.getMessage());
        } finally {
            db.close();
        }
    }

    @Override
    public void saveResetToken(String email, String token, long expiryTime) {
        DBConnect db = new DBConnect();
        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(SAVE_RESET_TOKEN_SQL)) {

            // Encode expiry time into token itself: token + "|" + expiryTime
            String tokenWithExpiry = token + "|" + expiryTime;
            ps.setString(1, tokenWithExpiry);
            ps.setString(2, email);
            int rows = ps.executeUpdate();
            
            if (rows == 0) {
                System.err.println("[WARN] No user found with email: " + email);
            }

        } catch (Exception e) {
            System.err.println("[ERROR] saveResetToken failed: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Failed to save reset token", e);
        } finally {
            db.close();
        }
    }

    @Override
    public Optional<User> findByResetToken(String token) {
        DBConnect db = new DBConnect();
        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement("SELECT user_id, email, password_hash, full_name, role, status, note, reset_token, created_at FROM users WHERE reset_token LIKE ?")) {

            // Search for token that starts with the given token (before |)
            ps.setString(1, token + "|%");
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return Optional.empty();

                User u = new User();
                u.setUserId(rs.getString("user_id"));
                u.setEmail(rs.getString("email"));
                u.setPasswordHash(rs.getString("password_hash"));
                u.setFullName(rs.getString("full_name"));
                u.setRole(rs.getString("role"));
                u.setStatus(rs.getString("status"));
                u.setNote(rs.getString("note"));
                
                // Extract token and expiry from stored value
                String storedToken = rs.getString("reset_token");
                if (storedToken != null && storedToken.contains("|")) {
                    String[] parts = storedToken.split("\\|");
                    u.setResetToken(parts[0]); // actual token
                    u.setResetTokenExpiry(Long.parseLong(parts[1])); // expiry time
                } else {
                    u.setResetToken(storedToken);
                    u.setResetTokenExpiry(null);
                }
                u.setCreatedAt(rs.getObject("created_at", java.time.OffsetDateTime.class));
                
                return Optional.of(u);
            }

        } catch (Exception e) {
            System.err.println("[ERROR] findByResetToken failed: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Find user by reset token failed", e);
        } finally {
            db.close();
        }
    }

    @Override
    public List<User> findAll() {
        System.out.println("=== DEBUG: UserDaoJdbc.findAll() called ===");
        List<User> list = new ArrayList<>();
        String sql = "SELECT user_id, email, password_hash, full_name, role, status, note, created_at FROM users ORDER BY user_id";
        
        DBConnect db = new DBConnect();
        Connection con = db.getConnection();
        
        if (con == null) {
            System.err.println("Database connection is null in UserDaoJdbc.findAll()");
            return list; // Return empty list instead of throwing exception
        }
        
        System.out.println("DEBUG: Database connection successful");
        
        try (PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            System.out.println("DEBUG: SQL query executed successfully");
            int count = 0;
            while (rs.next()) {
                list.add(mapRow(rs));
                count++;
            }
            System.out.println("DEBUG: Found " + count + " users in database");
        } catch (Exception e) {
            System.err.println("Error in UserDaoJdbc.findAll(): " + e.getMessage());
            e.printStackTrace();
            // Don't throw exception, just return empty list
        } finally {
            db.close();
        }
        System.out.println("DEBUG: Returning " + list.size() + " users from DAO");
        return list;
    }

    @Override
    public Optional<User> findById(int userId) {
        String sql = "SELECT user_id, email, password_hash, full_name, role, status, note, created_at FROM users WHERE user_id = ?";
        
        DBConnect db = new DBConnect();
        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapRow(rs));
                }
            }
        } catch (Exception e) {
            throw new RuntimeException("Error finding user by id", e);
        } finally {
            db.close();
        }
        return Optional.empty();
    }

    @Override
    public void update(User u) {
        String sql = "UPDATE users SET email=?, password_hash=?, full_name=?, role=?, status=?, note=? WHERE user_id=?";
        
        DBConnect db = new DBConnect();
        Connection con = null;
        try {
            con = db.getConnection();
            if (con == null) {
                throw new RuntimeException("Cannot get database connection");
            }
            
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                System.out.println("DEBUG: Updating user - ID: " + u.getUserId() + ", Email: " + u.getEmail() + ", Role: " + u.getRole() + ", Status: " + u.getStatus());
                
                ps.setString(1, u.getEmail());
                ps.setString(2, u.getPasswordHash());
                ps.setString(3, u.getFullName());
                ps.setString(4, u.getRole());
                ps.setString(5, u.getStatus());
                ps.setString(6, u.getNote() != null ? u.getNote() : "");
                
                // Fix: user_id is INT in database, need to parse String to int
                int userId = Integer.parseInt(u.getUserId());
                ps.setInt(7, userId);
                
                int rowsAffected = ps.executeUpdate();
                System.out.println("DEBUG: Update completed - Rows affected: " + rowsAffected);
                
                if (rowsAffected == 0) {
                    throw new RuntimeException("No rows updated. User may not exist with ID: " + userId);
                }
            }
            
        } catch (NumberFormatException e) {
            System.err.println("ERROR: Invalid user_id format: " + u.getUserId());
            e.printStackTrace();
            throw new RuntimeException("Invalid user_id format: " + u.getUserId(), e);
        } catch (SQLException e) {
            System.err.println("ERROR: SQL Exception in update: " + e.getMessage());
            System.err.println("ERROR: SQL State: " + e.getSQLState() + ", Error Code: " + e.getErrorCode());
            e.printStackTrace();
            throw new RuntimeException("Error updating user: " + e.getMessage(), e);
        } catch (Exception e) {
            System.err.println("ERROR: Exception in update: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Error updating user: " + e.getMessage(), e);
        } finally {
            db.close();
        }
    }

    @Override
    public void delete(int userId) {
        String sql = "DELETE FROM users WHERE user_id=?";
        
        DBConnect db = new DBConnect();
        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ps.executeUpdate();
            
        } catch (Exception e) {
            throw new RuntimeException("Error deleting user", e);
        } finally {
            db.close();
        }
    }

    @Override
    public List<User> findByRole(String role) {
        List<User> list = new ArrayList<>();
        String sql = "SELECT user_id, email, password_hash, full_name, role, status, note, created_at FROM users WHERE role=?";
        
        DBConnect db = new DBConnect();
        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, role);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (Exception e) {
            throw new RuntimeException("Error finding users by role", e);
        } finally {
            db.close();
        }
        return list;
    }

    @Override
    public List<User> findByStatus(String status) {
        List<User> list = new ArrayList<>();
        String sql = "SELECT user_id, email, password_hash, full_name, role, status, note, created_at FROM users WHERE status=?";
        
        DBConnect db = new DBConnect();
        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (Exception e) {
            throw new RuntimeException("Error finding users by status", e);
        } finally {
            db.close();
        }
        return list;
    }

    private User mapRow(ResultSet rs) throws SQLException {
        User u = new User();
        u.setUserId(rs.getString("user_id"));
        u.setEmail(rs.getString("email"));
        u.setPasswordHash(rs.getString("password_hash"));
        u.setFullName(rs.getString("full_name"));
        u.setRole(rs.getString("role"));
        u.setStatus(rs.getString("status"));
        u.setNote(rs.getString("note"));
        u.setCreatedAt(rs.getObject("created_at", java.time.OffsetDateTime.class));
        return u;
    }

    /**
     * Fixes the IDENTITY seed for users table by setting it to the maximum user_id
     */
    private void fixIdentitySeed(Connection con) throws SQLException {
        if (con == null || con.isClosed()) {
            throw new SQLException("Connection is null or closed");
        }
        
        // Get the maximum user_id from the table
        String maxIdSql = "SELECT COALESCE(MAX(user_id), 0) FROM users";
        int maxId = 0;
        
        try (PreparedStatement ps = con.prepareStatement(maxIdSql);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                maxId = rs.getInt(1);
            }
        }
        
        System.err.println("[DEBUG] Current MAX(user_id) = " + maxId);
        
        // Reset IDENTITY seed to maxId (next insert will be maxId + 1)
        // DBCC CHECKIDENT cannot use parameters, so we construct the SQL string
        // Note: DBCC CHECKIDENT returns a result set, so we need to handle it
        // Reset sequence for PostgreSQL (assumes default naming convention users_user_id_seq)
        String seqSql = "SELECT pg_get_serial_sequence('users', 'user_id')";
        String sequenceName = null;
        try (PreparedStatement ps = con.prepareStatement(seqSql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                sequenceName = rs.getString(1);
            }
        }

        if (sequenceName != null) {
            String reseedSql = String.format("SELECT setval('%s', %d)", sequenceName, maxId);
            System.err.println("[DEBUG] Executing: " + reseedSql);
            try (Statement stmt = con.createStatement()) {
                stmt.execute(reseedSql);
                System.err.println("[DEBUG] Sequence " + sequenceName + " reset to " + maxId + " (next ID will be " + (maxId + 1) + ")");
            }
        } else {
            System.err.println("[WARN] Could not determine sequence for users table. Please reseed manually.");
        }
    }

    @Override
    public int countAll() {
        String sql = "SELECT COUNT(*) FROM users";
        DBConnect db = new DBConnect();
        try (Connection conn = db.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            return 0;
        } catch (Exception e) {
            System.err.println("Error counting all users: " + e.getMessage());
            e.printStackTrace();
            return 0;
        }
    }

    @Override
    public int countByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM users WHERE status = ?";
        DBConnect db = new DBConnect();
        try (Connection conn = db.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, status);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
                return 0;
            }
        } catch (Exception e) {
            System.err.println("Error counting users by status: " + e.getMessage());
            e.printStackTrace();
            return 0;
        }
    }

    @Override
    public int countNewHiresThisMonth() {
        String sql = "SELECT COUNT(*) FROM users WHERE DATE_TRUNC('month', created_at) = DATE_TRUNC('month', CURRENT_DATE)";
        DBConnect db = new DBConnect();
        try (Connection conn = db.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            return 0;
        } catch (Exception e) {
            System.err.println("Error counting new hires this month: " + e.getMessage());
            e.printStackTrace();
            return 0;
        }
    }

    @Override
    public List<User> findRecent(int limit) {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users ORDER BY created_at DESC LIMIT ?";
        
        DBConnect db = new DBConnect();
        try (Connection conn = db.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, limit);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    users.add(mapResultSetToUser(rs));
                }
            }
        } catch (Exception e) {
            System.err.println("Error finding recent users: " + e.getMessage());
            e.printStackTrace();
        }
        return users;
    }

    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User u = new User();
        u.setUserId(rs.getString("user_id"));
        u.setEmail(rs.getString("email"));
        u.setPasswordHash(rs.getString("password_hash"));
        u.setFullName(rs.getString("full_name"));
        u.setRole(rs.getString("role"));
        u.setStatus(rs.getString("status"));
        u.setNote(rs.getString("note"));
        u.setCreatedAt(rs.getObject("created_at", java.time.OffsetDateTime.class));
        return u;
    }
}
