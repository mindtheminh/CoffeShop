package dao;

import java.math.BigDecimal;
import model.Order;
import java.util.List;
import java.util.Optional;

/**
 * OrderDao interface - Data Access Object for Order
 *
 * @author Asus
 */
public interface OrderDao {

    boolean updateNote(String orderId, String note);

    /**
     * Find all orders
     *
     * @return List of all orders
     */
    
    boolean updatePayAmount(String orderId, BigDecimal payAmount);

    List<Order> findAll ();

    /**
     * Find order by ID
     *
     * @param id Order ID
     * @return Optional containing the order if found
     */
    Optional<Order> findById(String id);

    /**
     * Create new order
     *
     * @param order Order to create
     * @return Created order ID
     */
    String create(Order order, int userId);

    /**
     * Update existing order
     *
     * @param order Order to update
     * @return true if update successful
     */
    boolean update(Order order);

    /**
     * Delete order by ID
     *
     * @param id Order ID to delete
     * @return true if delete successful
     */
    boolean deleteById(String id);

    /**
     * Find orders by customer ID
     *
     * @param customerId Customer ID
     * @return List of orders for the customer
     */
    List<Order> findByCustomerId(String customerId);

    /**
     * Find orders by status
     *
     * @param status Order status
     * @return List of orders with the given status
     */
    List<Order> findByStatus(String status);
}
