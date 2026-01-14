/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.OffsetDateTime;
import java.time.ZoneOffset;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import model.OrderItem;

/**
 *
 * @author Acer
 */
public class OrderItemDao {

    /**
     *
     * @param orderId
     * @return list order items with orderId
     */
    static public List<OrderItem> getOrderItemsByOrderId(String orderId) {
        List<OrderItem> list = new ArrayList<>();
        String sql = "SELECT * FROM order_items WHERE order_id = ?";
        DBConnect db = new DBConnect();

        try (Connection conn = db.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setObject(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderItem item = new OrderItem();
                    item.setOrderItemId(rs.getInt("order_item_id"));
                    item.setOrderId(rs.getString("order_id"));
                    item.setProductId(rs.getString("product_id"));
                    item.setQuantity(rs.getInt("quantity"));
                    item.setUnitPrice(rs.getBigDecimal("unit_price"));
                    item.setSubtotal(rs.getBigDecimal("subtotal"));
                    item.setNote(rs.getString("note"));
                    list.add(item);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            db.close();
        }

        return list;
    }

    public void deleteById(String orderItemId) {
        String sql = "DELETE FROM order_items WHERE order_item_id = ?";

        DBConnect db = new DBConnect();

        int idToDelete = -1;

        try {
            try {
                idToDelete = Integer.parseInt(orderItemId);
            } catch (NumberFormatException e) {
                throw new IllegalArgumentException("Order Item ID '" + orderItemId + "' must be a valid integer.", e);
            }
            // ------------------------------------------

            try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setInt(1, idToDelete);

                int affectedRows = ps.executeUpdate();

                if (affectedRows == 0) {
                    System.out.println("No OrderItem found with ID: " + orderItemId + " to delete.");
                }

            } catch (Exception e) {
                // Bắt và ném lại lỗi SQL, sử dụng thông báo lỗi khớp với Stack Trace
                throw new RuntimeException("Error deleting oItem", e);
            }

        } finally {
            // Đóng DBConnect sau khi hoàn thành mọi thao tác
            db.close();
        }
    }

    
    public boolean update(OrderItem orderItem) {
        // Cập nhật quantity, subtotal, và note dựa trên order_item_id
        String SQL = "UPDATE order_items SET "
                   + "quantity = ?, "
                   + "subtotal = ?, "
                   + "note = ? "
                   + "WHERE order_item_id = ?";
        
        DBConnect dbConnect = new DBConnect();
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = dbConnect.getConnection();
            ps = conn.prepareStatement(SQL);

            // Set parameters
            // 1. quantity
            ps.setInt(1, orderItem.getQuantity());

            // 2. subtotal
            ps.setBigDecimal(2, orderItem.getSubtotal());

            // 3. note
            ps.setString(3, orderItem.getNote());

            // WHERE clause: order_item_id
            ps.setInt(4, orderItem.getOrderItemId());

            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Error when updating OrderItem with ID: " + orderItem.getOrderItemId(), e);
        } finally {
            // Đóng PreparedStatement
            if (ps != null) {
                try {
                    ps.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            // Đóng Connection bằng phương thức close() của DBConnect
            // Lưu ý: Nếu DBConnect.close() chỉ đóng riêng Connection, thì đây là cách đúng.
            // Nếu DBConnect.close() là để dọn dẹp chung, hãy đảm bảo nó hoạt động như mong muốn.
            dbConnect.close();
        }
    }
    
    
    public void create(OrderItem orderiteams, String currenOrderId) {
        String sql = "INSERT INTO order_items(order_id, product_id, quantity, unit_price, subtotal, note, created_at) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        DBConnect DBConnect = new DBConnect();
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setObject(1, currenOrderId);
            ps.setString(2, orderiteams.getProductId());
            ps.setInt(3, orderiteams.getQuantity());
            ps.setBigDecimal(4, orderiteams.getUnitPrice());
            ps.setBigDecimal(5, orderiteams.getSubtotal());
            ps.setString(6, orderiteams.getNote());

            // Nếu createdAt null thì lấy thời điểm hiện tại
            OffsetDateTime createdAt = orderiteams.getCreatedAt();
            if (createdAt == null) {
                createdAt = OffsetDateTime.now();
                orderiteams.setCreatedAt(createdAt);
            }
            ps.setTimestamp(7, Timestamp.valueOf(createdAt.toLocalDateTime()));

            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Error when inserting OrderItem", e);
        } finally {
            DBConnect.close();;
        }

    }
/**
     * Tìm OrderItem theo order_item_id (kiểu String)
     *
     * @param orderItemId mã order_item_id
     * @return OrderItem nếu tìm thấy, ngược lại trả về null
     */
    public OrderItem findById(String orderItemId) {
        String sql = """
            SELECT order_item_id, order_id, product_id, quantity, 
                   unit_price, subtotal, note, created_at
            FROM order_items
            WHERE order_item_id = ?
        """;

        DBConnect db = new DBConnect();

        try (Connection conn = db.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, Integer.parseInt(orderItemId)); // ép về int vì cột là SERIAL

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    OrderItem item = new OrderItem();
                    item.setOrderItemId(rs.getInt("order_item_id"));
                    item.setOrderId(rs.getString("order_id"));
                    item.setProductId(rs.getString("product_id"));
                    item.setQuantity(rs.getInt("quantity"));
                    item.setUnitPrice(rs.getBigDecimal("unit_price"));
                    item.setSubtotal(rs.getBigDecimal("subtotal"));
                    item.setNote(rs.getString("note"));

                    OffsetDateTime createdAt = rs.getObject("created_at", OffsetDateTime.class);
                    item.setCreatedAt(createdAt);

                    // trên lỗi mới vào đấy
                    if (item.getCreatedAt() == null && rs.getTimestamp("created_at") != null) {
                        item.setCreatedAt(rs.getTimestamp("created_at").toInstant().atOffset(ZoneOffset.UTC));
                    }

                    return item;
                }
            }

        } catch (SQLException e) {
            System.err.println("Lỗi khi truy vấn order_item_id = " + orderItemId);
            e.printStackTrace();
        } finally {
            db.close();
        }

        return null;
    }

    public static void main(String[] args) {
        OrderItemDao dao = new OrderItemDao();
        OrderItem item = dao.findById("142");

        if (item != null) {
            System.out.println("🟢 OrderItem #" + item.getOrderItemId());
            System.out.println("Sản phẩm: " + item.getProductId());
            System.out.println("Tạo lúc: " + item.getCreatedAt());
            System.out.println("Số tiền đơn:" + item.getUnitPrice());// in ra OffsetDateTime
            System.out.println("Số tiền tổng:" + item.getSubtotal());// in ra OffsetDateTime
        } else {
            System.out.println("🔴 Không tìm thấy order item.");
        }
    }
}