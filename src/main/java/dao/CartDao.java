package dao;

import model.Order;
import model.OrderItem;
import java.util.List;
import java.util.Optional;

/**
 * CartDao interface - Data Access Object for Cart operations
 * @author Asus
 */
public interface CartDao {
    
    /**
     * Find or create cart for user
     * @param userId User ID
     * @return Cart order (is_cart = 1)
     */
    Order findOrCreateCart(int userId);
    
    /**
     * Get cart by user ID
     * @param userId User ID
     * @return Optional containing cart if found
     */
    Optional<Order> getCartByUserId(int userId);
    
    /**
     * Get all items in cart
     * @param orderId Order ID (cart)
     * @return List of order items
     */
    List<OrderItem> getCartItems(String orderId);
    
    /**
     * Add item to cart
     * @param orderItem Order item to add
     * @return true if successful
     */
    boolean addItemToCart(OrderItem orderItem);
    
    /**
     * Update item quantity in cart
     * @param orderId Order ID
     * @param productId Product ID
     * @param quantity New quantity
     * @return true if successful
     */
    boolean updateItemQuantity(String orderId, String productId, int quantity);
    
    /**
     * Remove item from cart
     * @param orderId Order ID
     * @param productId Product ID
     * @return true if successful
     */
    boolean removeItemFromCart(String orderId, String productId);
    
    /**
     * Clear all items from cart
     * @param orderId Order ID
     * @return true if successful
     */
    boolean clearCart(String orderId);
    
    /**
     * Convert cart to order (checkout)
     * @param orderId Order ID
     * @param totalAmount Total amount
     * @param initialStatus Initial status for the order (e.g., "Pending" or "Processing")
     * @return true if successful
     */
    boolean checkoutCart(String orderId, java.math.BigDecimal totalAmount, String initialStatus);
    
    /**
     * Generate new order ID
     * @return New order ID in format ORD001, ORD002, etc.
     */
    String generateOrderId();
}

