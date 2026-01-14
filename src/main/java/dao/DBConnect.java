
package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.ResultSet;

public class DBConnect {
    // ====== Cấu hình PostgreSQL ======
    // ⚠️ QUAN TRỌNG: Cập nhật PASSWORD cho đúng với mật khẩu PostgreSQL của bạn!
    // Nếu gặp lỗi "password authentication failed", hãy:
    // 1. Kiểm tra mật khẩu PostgreSQL trong pgAdmin hoặc psql
    // 2. Hoặc reset mật khẩu: ALTER USER postgres WITH PASSWORD 'mật_khẩu_mới';
    private static final String HOST     = "localhost";
    private static final int    PORT     = 5432;
    private static final String DB_NAME  = "CoffeShop";

    private static final String USERNAME = "postgres";
    private static final String PASSWORD = "123"; // ⚠️ CẬP NHẬT MẬT KHẨU Ở ĐÂY!

    // PostgreSQL không cần instance name
    // Tham số tùy chọn (UTF-8 + timeout)
    private static final String PARAMS = "characterEncoding=UTF-8&loginTimeout=10";
    // ==================================

    private static final String JDBC_URL = buildJdbcUrl();

    protected Connection connection;

    public DBConnect() {
        try {
            // 1) Nạp driver PostgreSQL
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
            throw new IllegalStateException("Chưa có JDBC driver. Hãy thêm postgresql-42.x.x.jar vào Libraries.", e);
        }
    }

    private static String buildJdbcUrl() {
        // jdbc:postgresql://host:port/database?params
        return String.format(
            "jdbc:postgresql://%s:%d/%s?%s",
            HOST, PORT, DB_NAME, PARAMS
        );
    }

    /** Lấy Connection để DAO khác dùng */
    public Connection getConnection() {
        try {
            if (connection == null || connection.isClosed()) {
                connection = DriverManager.getConnection(JDBC_URL, USERNAME, PASSWORD);
            }
            return connection;
        } catch (SQLException e) {
            throw new IllegalStateException("Không thể lấy kết nối PostgreSQL. Kiểm tra cấu hình và server.", e);
        }
    }

    /** Đóng kết nối khi không dùng nữa */
    public void close() {
        if (connection != null) {
            try { connection.close(); } catch (SQLException ignore) {}
            connection = null;
        }
    }
    
    

    // Test nhanh
    public static void main(String[] args) {
        DBConnect d = new DBConnect();
        Connection c = d.getConnection();

        if (c != null) {
            System.out.println("Kết nối cơ sở dữ liệu thành công.");
            try (Statement st = c.createStatement();
                 ResultSet rs = st.executeQuery("SELECT current_database()")) {
                if (rs.next()) {
                    System.out.println("Đang dùng DB: " + rs.getString(1));
                }
            } catch (SQLException e) {
                System.err.println("Test query lỗi: " + e.getMessage());
            } finally {
                d.close();
            }
        } else {
            System.out.println("Không thể kết nối đến cơ sở dữ liệu.");
        }
    }
}