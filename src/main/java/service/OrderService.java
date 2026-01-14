package service;

import model.Order;
import model.OrderDto;
import java.util.List;

/**
 * OrderService interface - Business logic for Order management
 *
 * @author Asus
 */
public interface OrderService {

    /**
     * Get all orders
     *
     * @return List of all orders as DTOs
     */
    List<OrderDto> getAllOrders();

    /**
     * Get order by ID
     *
     * @param id Order ID
     * @return OrderDto if found, null otherwise
     */
    OrderDto getOrderById(String id);

    /**
     * Create new order
     *
     * @param orderDto Order data to create
     * @return Created order ID
     */
//    String createOrder(OrderDto orderDto);

    /**
     * Update existing order
     *
     * @param orderDto Order data to update
     * @return true if update successful
     */
    boolean updateOrder(OrderDto orderDto);

    /**
     * Delete order by ID
     *
     * @param id Order ID to delete
     * @return true if delete successful
     */
    boolean deleteOrder(String id);

    /**
     * Get orders by customer ID
     *
     * @param customerId Customer ID
     * @return List of orders for the customer
     */
    List<OrderDto> getOrdersByCustomerId(String customerId);

    /**
     * Get orders by status
     *
     * @param status Order status
     * @return List of orders with the given status
     */
    List<OrderDto> getOrdersByStatus(List<OrderDto> order, String status);
    
    /**
     * 
     * @param orderId 
     */
    void createInvoiceCash(String orderId);
    
     public void createInvoiceBank(String orderId) ;
}
