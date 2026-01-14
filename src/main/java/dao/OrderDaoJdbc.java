package dao;

import java.math.BigDecimal;
import model.Order;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import model.OrderDto;
import model.OrderMapper;

/**
 * OrderDaoJdbc - JDBC implementation of OrderDao
 *
 * @author Asus
 */
public class OrderDaoJdbc implements OrderDao {

    @Override
    public List<Order> findAll() {
        List<Order> list = new ArrayList<>();
        // TODO: Implement when database schema is ready
        // String sql = "SELECT * FROM orders ORDER BY created_at DESC";
        // DBConnect db = new DBConnect();
        // Connection con = db.getConnection();
        // ... execute query and map results
        return list;
    }

    @Override
    public Optional<Order> findById(String id) {
        String sql = "SELECT * FROM orders WHERE order_id = ?";
        DBConnect db = new DBConnect();

        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return Optional.of(OrderMapper.fromResultSet(rs));
            }

        } catch (SQLException e) {
            System.err.println("Error finding order by ID: " + e.getMessage());
            e.printStackTrace();
        } finally {
            db.close();
        }

        return Optional.empty();
    }

    @Override
    public String create(Order order, int userId) {
        String generatedId = null;

        String sqlGetMaxId = "SELECT order_id FROM orders ORDER BY order_id DESC LIMIT 1";
        String sqlInsert = """
        INSERT INTO orders (
            order_id, user_id, order_type, status, total_amount, discount_amount,
            pay_method, note, promotion_id, expires_at, is_cart,
            shipping_address, phone_contact, payment_amount, payment_status,
            payment_date, transaction_code, payment_reference
        )
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """;

        DBConnect db = new DBConnect();

        try (Connection conn = db.getConnection()) {
            conn.setAutoCommit(true); // đảm bảo insert được commit ngay

            // 1) Lấy order_id cuối
            try (PreparedStatement psMax = conn.prepareStatement(sqlGetMaxId); ResultSet rs = psMax.executeQuery()) {

                if (rs.next()) {
                    String lastId = rs.getString("order_id"); // ví dụ: ORD012
                    int num = Integer.parseInt(lastId.substring(3)); // 012 -> 12
                    generatedId = String.format("ORD%03d", num + 1); // ORD00001 -> ORD99999
                } else {
                    generatedId = "ORD00001"; // nếu chưa có đơn nào
                }
            }

            // 2) Gán ID cho order
            order.setOrderId(generatedId);

            // 3) INSERT
            try (PreparedStatement ps = conn.prepareStatement(sqlInsert)) {

                ps.setString(1, order.getOrderId());

                ps.setInt(2, userId);
                ps.setString(3, order.getOrderType());
                ps.setString(4, order.getStatus());
                ps.setBigDecimal(5, order.getTotalAmount() != null ? order.getTotalAmount() : BigDecimal.ZERO);
                ps.setBigDecimal(6, order.getDiscountAmount() != null ? order.getDiscountAmount() : BigDecimal.ZERO);
                ps.setString(7, order.getPayMethod());
                ps.setString(8, order.getNote());
                ps.setString(9, order.getPromotionId());

                if (order.getExpiresAt() != null) {
                    ps.setTimestamp(10, Timestamp.from(order.getExpiresAt().toInstant()));
                } else {
                    ps.setNull(10, Types.TIMESTAMP);
                }

                ps.setBoolean(11, order.isCart());
                ps.setString(12, order.getShippingAddress());
                ps.setString(13, order.getPhoneContact());
                ps.setBigDecimal(14, order.getPaymentAmount());
                ps.setString(15, order.getPaymentStatus());

                if (order.getPaymentDate() != null) {
                    ps.setTimestamp(16, Timestamp.from(order.getPaymentDate().toInstant()));
                } else {
                    ps.setNull(16, Types.TIMESTAMP);
                }

                ps.setString(17, order.getTransactionCode());
                ps.setString(18, order.getPaymentReference());

                ps.executeUpdate();
            }

        } catch (SQLException e) {
            e.printStackTrace();
            return null; // tạo thất bại
        }

        return generatedId;
    }

    @Override
    public boolean update(Order order) {
        String sql = "UPDATE orders SET status = ?, payment_status = ?, pay_method = ?, "
                + "total_amount = ?, payment_amount = ?, note = ?, shipping_address = ?, phone_contact = ?, order_type = ?, updated_at = CURRENT_TIMESTAMP "
                + "WHERE order_id = ?";

        DBConnect db = new DBConnect();
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, order.getStatus());
            ps.setString(2, order.getPaymentStatus());
            ps.setString(3, order.getPayMethod());
            ps.setBigDecimal(4, order.getTotalAmount());
            ps.setBigDecimal(5, order.getPaymentAmount());
            ps.setString(6, order.getNote());
            ps.setString(7, order.getShippingAddress());
            ps.setString(8, order.getPhoneContact());
            ps.setString(9, order.getOrderType());

            ps.setString(10, order.getOrderId());

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("Error updating order: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            db.close();
        }
    }

    @Override
    public boolean updateNote(String orderId, String note) {
        String sql = "UPDATE orders SET note = ?, updated_at = CURRENT_TIMESTAMP WHERE order_id = ?";
        DBConnect db = new DBConnect();
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, note);
            ps.setString(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            db.close();
        }
    }

    @Override
    public boolean updatePayAmount(String orderId, BigDecimal payAmount) {
        String sql = "UPDATE orders SET payment_amount = ?, updated_at = CURRENT_TIMESTAMP WHERE order_id = ?";
        DBConnect db = new DBConnect();
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setBigDecimal(1, payAmount);
            ps.setString(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            db.close();
        }
    }

    @Override
    public boolean deleteById(String id) {
        // TODO: Implement when database schema is ready
        return false;
    }

    @Override
    public List<Order> findByCustomerId(String customerId) {
        List<Order> list = new ArrayList<>();
        // Use is_cart = FALSE for PostgreSQL boolean (not 0 or 1)
        // Also exclude carts that are still active (is_cart = TRUE)
        String sql = "SELECT * FROM orders WHERE user_id = ? AND is_cart = FALSE ORDER BY created_at DESC";

        DBConnect db = new DBConnect();
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            int userId = Integer.parseInt(customerId);
            ps.setInt(1, userId);
            
            System.out.println("DEBUG: Querying orders for user_id: " + userId);
            System.out.println("DEBUG: SQL: " + sql);
            
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Order order = OrderMapper.fromResultSet(rs);
                System.out.println("DEBUG: Found order: " + order.getOrderId() + 
                    ", is_cart: " + rs.getBoolean("is_cart") + 
                    ", status: " + order.getStatus());
                list.add(order);
            }
            
            System.out.println("DEBUG: Total orders found: " + list.size());

        } catch (SQLException e) {
            System.err.println("Error finding orders by customer ID: " + e.getMessage());
            e.printStackTrace();
        } catch (NumberFormatException e) {
            System.err.println("Error parsing customer ID: " + customerId);
            e.printStackTrace();
        } finally {
            db.close();
        }

        return list;
    }

    @Override
    public List<Order> findByStatus(String status) {
        // TODO: Implement when database schema is ready
        return new ArrayList<>();
    }

    public List<OrderDto> getAllOrders() {
        List<OrderDto> list = new ArrayList<>();

        String sql = "SELECT * FROM orders ";
        DBConnect db = new DBConnect();

        try (Connection conn = db.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Order entity = OrderMapper.fromResultSet(rs);
                OrderDto dto = OrderMapper.toDto(entity, ""); // có thể join thêm tên KH
                list.add(dto);
            }

        } catch (SQLException e) {
            System.err.println("❌ Lỗi truy vấn getAllActiveOrders(): " + e.getMessage());
        }

        return list;
    }
    // Phiên bản chi tiết log từng cột để debug
//    public static List<OrderDto> getAllOrdersDetailed() {
//        List<OrderDto> list = new java.util.ArrayList<>();
//
//        String sql = "SELECT * FROM orders";
//        DBConnect db = new DBConnect();
//
//        try (Connection conn = db.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
//
//            while (rs.next()) {
//                try {
//                    // Log từng cột trực tiếp từ ResultSet
//                    System.out.println("DEBUG: order_id=" + rs.getString("order_id"));
//                    System.out.println("DEBUG: created_at=" + rs.getObject("created_at"));
//                    System.out.println("DEBUG: updated_at=" + rs.getObject("updated_at"));
//                    System.out.println("DEBUG: status=" + rs.getString("status"));
//                    System.out.println("DEBUG: total_amount=" + rs.getBigDecimal("total_amount"));
//
//                    // Map entity
//                    Order entity = OrderMapper.fromResultSet(rs);
//
//                    // Log entity
//                    System.out.println("Mapped entity updatedAt=" + entity.getUpdatedAt());
//
//                    // Map DTO
//                    OrderDto dto = OrderMapper.toDto(entity, "");
//                    list.add(dto);
//
//                } catch (Exception e) {
//                    System.err.println("❌ Error mapping order: " + e.getMessage());
//                    e.printStackTrace();
//                }
//            }
//
//        } catch (SQLException e) {
//            System.err.println("❌ SQL error in getAllOrders: " + e.getMessage());
//            e.printStackTrace();
//        } finally {
//            db.close();
//        }
//
//        return list;
//    }

    public static void main(String[] args) {
        System.out.println("===== TEST getAllOrders =====");
        OrderDaoJdbc o = new OrderDaoJdbc();
        // Gọi DAO
        o.updateNote("ORD082", "123");

        System.out.println("===== TEST DONE =====");
    }
}
