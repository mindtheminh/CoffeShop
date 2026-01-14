package dao;

import model.Order;
import model.OrderItem;
import java.math.BigDecimal;
import java.sql.*;
import java.time.OffsetDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 * CartDaoJdbc - JDBC implementation of CartDao
 *
 * @author Asus
 */
public class CartDaoJdbc implements CartDao {

    @Override
    public Order findOrCreateCart(int userId) {
        Optional<Order> existingCart = getCartByUserId(userId);
        if (existingCart.isPresent()) {
            return existingCart.get();
        }

        // Create new cart
        String orderId = generateOrderId();

        String sql = "INSERT INTO orders (order_id, user_id, status, is_cart, total_amount, discount_amount, created_at, updated_at) "
                + "VALUES (?, ?, 'Pending', TRUE, 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)";

        DBConnect db = new DBConnect();
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, orderId);
            ps.setInt(2, userId);
            ps.executeUpdate();

            Order cart = new Order();
            cart.setOrderId(orderId);
            cart.setUserId(userId);
            cart.setStatus("Pending");
            cart.setCart(true);
            cart.setTotalAmount(BigDecimal.ZERO);
            cart.setDiscountAmount(BigDecimal.ZERO);

            return cart;

        } catch (SQLException e) {
            System.err.println("Error creating cart: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Failed to create cart", e);
        } finally {
            db.close();
        }
    }

    @Override
    public Optional<Order> getCartByUserId(int userId) {
        String sql = "SELECT * FROM orders WHERE user_id = ? AND is_cart = TRUE";

        DBConnect db = new DBConnect();
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Order cart = new Order();
                    cart.setOrderId(rs.getString("order_id"));
                    cart.setUserId(rs.getInt("user_id"));
                    cart.setOrderType(rs.getString("order_type"));
                    cart.setStatus(rs.getString("status"));
                    cart.setTotalAmount(rs.getBigDecimal("total_amount"));
                    cart.setDiscountAmount(rs.getBigDecimal("discount_amount"));
                    cart.setPayMethod(rs.getString("pay_method"));
                    cart.setNote(rs.getString("note"));
                    cart.setPromotionId(rs.getString("promotion_id"));
                    cart.setCart(rs.getBoolean("is_cart"));
                    cart.setShippingAddress(rs.getString("shipping_address"));
                    cart.setPhoneContact(rs.getString("phone_contact"));
                    cart.setPaymentAmount(rs.getBigDecimal("payment_amount"));
                    cart.setPaymentStatus(rs.getString("payment_status"));

                    return Optional.of(cart);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting cart: " + e.getMessage());
            e.printStackTrace();
        } finally {
            db.close();
        }
        return Optional.empty();
    }

    @Override
    public List<OrderItem> getCartItems(String orderId) {
        List<OrderItem> items = new ArrayList<>();
        // Query to get order items with product info
        // If there are duplicate order_items (shouldn't happen, but handle it), use DISTINCT
        String sql = "SELECT DISTINCT oi.order_item_id, oi.order_id, oi.product_id, "
                + "oi.quantity, oi.unit_price, oi.subtotal, oi.note, oi.created_at, "
                + "p.name as product_name, p.image_url as product_image_url "
                + "FROM order_items oi "
                + "JOIN products p ON oi.product_id = p.product_id "
                + "WHERE oi.order_id = ? "
                + "ORDER BY oi.order_item_id";

        DBConnect db = new DBConnect();
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, orderId);
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
                    item.setCreatedAt(rs.getObject("created_at", OffsetDateTime.class));

                    item.setProductName(rs.getString("product_name"));
                    item.setProductImageUrl(rs.getString("product_image_url"));
                    items.add(item);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting cart items: " + e.getMessage());
            e.printStackTrace();
        } finally {
            db.close();
        }

        return items;
    }

    @Override
    public boolean addItemToCart(OrderItem orderItem) {
        // Validate input
        if (orderItem.getOrderId() == null || orderItem.getOrderId().trim().isEmpty()) {
            return false;
        }

        if (orderItem.getProductId() == null || orderItem.getProductId().trim().isEmpty()) {
            return false;
        }

        String checkSql = "SELECT order_item_id, quantity FROM order_items WHERE order_id = ? AND product_id = ? FOR UPDATE";
        String insertSql = "INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal, created_at) "
                + "VALUES (?, ?, ?, ?, ?, CURRENT_TIMESTAMP)";
        String updateSql = "UPDATE order_items SET quantity = ?, subtotal = ? WHERE order_id = ? AND product_id = ?";

        DBConnect db = new DBConnect();
        Connection con = null;

        try {
            con = db.getConnection();

            if (con == null) {
                return false;
            }

            // Disable auto-commit to use transaction with lock
            con.setAutoCommit(false);
            
            // Set transaction isolation level to prevent dirty reads
            con.setTransactionIsolation(Connection.TRANSACTION_REPEATABLE_READ);

            try {
                // Check if item exists WITH LOCK (FOR UPDATE)
                // This locks the row to prevent concurrent modifications
                try (PreparedStatement ps = con.prepareStatement(checkSql)) {
                    ps.setString(1, orderItem.getOrderId());
                    ps.setString(2, orderItem.getProductId());

                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            // Item exists, update quantity
                            int existingQty = rs.getInt("quantity");
                            int newQty = existingQty + orderItem.getQuantity();
                            BigDecimal newSubtotal = orderItem.getUnitPrice().multiply(BigDecimal.valueOf(newQty));

                            try (PreparedStatement updatePs = con.prepareStatement(updateSql)) {
                                updatePs.setInt(1, newQty);
                                updatePs.setBigDecimal(2, newSubtotal);
                                updatePs.setString(3, orderItem.getOrderId());
                                updatePs.setString(4, orderItem.getProductId());

                                int updated = updatePs.executeUpdate();
                                
                                // Commit transaction
                                con.commit();
                                
                                return updated > 0;
                            }
                        } else {
                            // Item doesn't exist, try to insert new
                            // Note: Even with FOR UPDATE, if row doesn't exist, concurrent inserts are possible
                            // So we need to handle potential duplicate key errors
                            try (PreparedStatement insertPs = con.prepareStatement(insertSql)) {
                                insertPs.setString(1, orderItem.getOrderId());
                                insertPs.setString(2, orderItem.getProductId());
                                insertPs.setInt(3, orderItem.getQuantity());
                                insertPs.setBigDecimal(4, orderItem.getUnitPrice());
                                insertPs.setBigDecimal(5, orderItem.getSubtotal());

                                int inserted = insertPs.executeUpdate();
                                
                                if (inserted > 0) {
                                    // Commit transaction
                                    con.commit();
                                    return true;
                                } else {
                                    // If insert failed, check again (another transaction might have inserted)
                                    // Re-check with lock
                                    try (PreparedStatement recheckPs = con.prepareStatement(checkSql)) {
                                        recheckPs.setString(1, orderItem.getOrderId());
                                        recheckPs.setString(2, orderItem.getProductId());
                                        
                                        try (ResultSet recheckRs = recheckPs.executeQuery()) {
                                            if (recheckRs.next()) {
                                                // Item was inserted by another transaction, update it
                                                int existingQty = recheckRs.getInt("quantity");
                                                int newQty = existingQty + orderItem.getQuantity();
                                                BigDecimal newSubtotal = orderItem.getUnitPrice().multiply(BigDecimal.valueOf(newQty));

                                                try (PreparedStatement updatePs = con.prepareStatement(updateSql)) {
                                                    updatePs.setInt(1, newQty);
                                                    updatePs.setBigDecimal(2, newSubtotal);
                                                    updatePs.setString(3, orderItem.getOrderId());
                                                    updatePs.setString(4, orderItem.getProductId());

                                                    int updated = updatePs.executeUpdate();
                                                    con.commit();
                                                    return updated > 0;
                                                }
                                            } else {
                                                // Still no item, rollback and return false
                                                con.rollback();
                                                return false;
                                            }
                                        }
                                    }
                                }
                            } catch (SQLException insertEx) {
                                // If insert failed due to duplicate key or constraint violation
                                // This can happen in race conditions when two requests try to add the same product simultaneously
                                String errorMsg = insertEx.getMessage() != null ? insertEx.getMessage().toLowerCase() : "";
                                String sqlState = insertEx.getSQLState() != null ? insertEx.getSQLState() : "";
                                
                                if (errorMsg.contains("duplicate") || 
                                    errorMsg.contains("unique") ||
                                    errorMsg.contains("violation") ||
                                    sqlState.startsWith("23")) {
                                    
                                    // Rollback the failed insert
                                    con.rollback();
                                    
                                    // Re-check with lock to see if item was inserted by another transaction
                                    try (PreparedStatement recheckPs = con.prepareStatement(checkSql)) {
                                        recheckPs.setString(1, orderItem.getOrderId());
                                        recheckPs.setString(2, orderItem.getProductId());
                                        
                                        try (ResultSet recheckRs = recheckPs.executeQuery()) {
                                            if (recheckRs.next()) {
                                                // Item exists now (inserted by another transaction), update it
                                                int existingQty = recheckRs.getInt("quantity");
                                                int newQty = existingQty + orderItem.getQuantity();
                                                BigDecimal newSubtotal = orderItem.getUnitPrice().multiply(BigDecimal.valueOf(newQty));

                                                try (PreparedStatement updatePs = con.prepareStatement(updateSql)) {
                                                    updatePs.setInt(1, newQty);
                                                    updatePs.setBigDecimal(2, newSubtotal);
                                                    updatePs.setString(3, orderItem.getOrderId());
                                                    updatePs.setString(4, orderItem.getProductId());

                                                    int updated = updatePs.executeUpdate();
                                                    con.commit();
                                                    return updated > 0;
                                                }
                                            } else {
                                                // Still no item, this shouldn't happen but handle it
                                                con.rollback();
                                                System.err.println("WARNING: Duplicate key error but item not found on recheck. OrderId: " + orderItem.getOrderId() + ", ProductId: " + orderItem.getProductId());
                                                return false;
                                            }
                                        }
                                    }
                                } else {
                                    // Other SQL errors, rollback and rethrow
                                    con.rollback();
                                    throw insertEx;
                                }
                            }
                        }
                    }
                }
            } catch (SQLException e) {
                // Rollback on error
                if (con != null) {
                    try {
                        con.rollback();
                    } catch (SQLException rollbackEx) {
                        System.err.println("Error rolling back transaction: " + rollbackEx.getMessage());
                    }
                }
                throw e;
            }

        } catch (SQLException e) {
            System.err.println("Error adding item to cart: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            if (con != null) {
                try {
                    con.setAutoCommit(true); // Reset auto-commit
                    con.close();
                } catch (SQLException e) {
                    System.err.println("Error closing connection: " + e.getMessage());
                }
            }
            db.close();
        }
    }

    @Override
    public boolean updateItemQuantity(String orderId, String productId, int quantity) {
        if (quantity <= 0) {
            return removeItemFromCart(orderId, productId);
        }

        String sql = "UPDATE order_items SET quantity = ?, subtotal = unit_price * ? WHERE order_id = ? AND product_id = ?";

        DBConnect db = new DBConnect();
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, quantity);
            ps.setInt(2, quantity);
            ps.setString(3, orderId);
            ps.setString(4, productId);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("Error updating item quantity: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            db.close();
        }
    }

    @Override
    public boolean removeItemFromCart(String orderId, String productId) {
        String sql = "DELETE FROM order_items WHERE order_id = ? AND product_id = ?";

        DBConnect db = new DBConnect();
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, orderId);
            ps.setString(2, productId);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("Error removing item from cart: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            db.close();
        }
    }

    @Override
    public boolean clearCart(String orderId) {
        String sql = "DELETE FROM order_items WHERE order_id = ?";

        DBConnect db = new DBConnect();
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, orderId);
            ps.executeUpdate();
            return true;

        } catch (SQLException e) {
            System.err.println("Error clearing cart: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            db.close();
        }
    }

    @Override
    public boolean checkoutCart(String orderId, BigDecimal totalAmount, String initialStatus) {
        // Use provided initialStatus, default to "Processing" if null
        String status = (initialStatus != null && !initialStatus.trim().isEmpty()) 
            ? initialStatus.trim() 
            : "Processing";
        
        String sql = "UPDATE orders SET status = ?, is_cart = FALSE, total_amount = ?, "
                + "payment_status = 'Pending', updated_at = CURRENT_TIMESTAMP WHERE order_id = ?";

        DBConnect db = new DBConnect();
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setBigDecimal(2, totalAmount);
            ps.setString(3, orderId);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("Error checking out cart: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            db.close();
        }
    }
    
    // Backward compatibility - keep old method signature
    public boolean checkoutCart(String orderId, BigDecimal totalAmount) {
        return checkoutCart(orderId, totalAmount, "Processing");
    }

    @Override
    public String generateOrderId() {
        String sql = "SELECT order_id FROM orders WHERE order_id LIKE 'ORD%' ORDER BY order_id DESC LIMIT 1";

        DBConnect db = new DBConnect();
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                String lastId = rs.getString("order_id");
                int num = Integer.parseInt(lastId.substring(3)) + 1;
                return String.format("ORD%03d", num);
            } else {
                return "ORD001";
            }

        } catch (SQLException e) {
            System.err.println("Error generating order ID: " + e.getMessage());
            e.printStackTrace();
            return "ORD001";
        } finally {
            db.close();
        }
    }
}
