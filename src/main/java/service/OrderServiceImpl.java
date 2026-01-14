package service;

import dao.OrderDao;
import dao.OrderDaoJdbc;
import java.util.ArrayList;
import model.Order;
import model.OrderDto;
import model.OrderMapper;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

/**
 * OrderServiceImpl - Implementation of OrderService
 *
 * @author Asus
 */
public class OrderServiceImpl implements OrderService {

    private final OrderDao orderDao;

    public OrderServiceImpl() {
        this.orderDao = new OrderDaoJdbc();
    }

    @Override
    public List<OrderDto> getAllOrders() {
        try {
            List<Order> orders = orderDao.findAll();
            return orders.stream()
                    .map(order -> OrderMapper.toDto(order, "Unknown Customer"))
                    .collect(Collectors.toList());
        } catch (Exception e) {
            System.err.println("Error getting all orders: " + e.getMessage());
            e.printStackTrace();
            return List.of(); // Return empty list on error
        }
    }

    @Override
    public OrderDto getOrderById(String id) {
        try {
            Optional<Order> order = orderDao.findById(id);
            return order.map(o -> OrderMapper.toDto(o, "Unknown Customer")).orElse(null);
        } catch (Exception e) {
            System.err.println("Error getting order by ID: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

//    @Override
//    public String createOrder(OrderDto orderDto) {
//        try {
//            Order order = OrderMapper.toEntity(orderDto, 1); // Default user ID
//            return orderDao.create(order, userId);
//        } catch (Exception e) {
//            System.err.println("Error creating order: " + e.getMessage());
//            e.printStackTrace();
//            return null;
//        }
//    }

    @Override
    public boolean updateOrder(OrderDto orderDto) {
        try {
            Order order = OrderMapper.toEntity(orderDto, 1); // Default user ID
            return orderDao.update(order);
        } catch (Exception e) {
            System.err.println("Error updating order: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean deleteOrder(String id) {
        try {
            return orderDao.deleteById(id);
        } catch (Exception e) {
            System.err.println("Error deleting order: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public List<OrderDto> getOrdersByCustomerId(String customerId) {
        try {
            List<Order> orders = orderDao.findByCustomerId(customerId);
            return orders.stream()
                    .map(order -> OrderMapper.toDto(order, "Unknown Customer"))
                    .collect(Collectors.toList());
        } catch (Exception e) {
            System.err.println("Error getting orders by customer ID: " + e.getMessage());
            e.printStackTrace();
            return List.of();
        }
    }

    @Override
    public List<OrderDto> getOrdersByStatus(List<OrderDto> order, String status) {
//        List<OrderDto> order = o.getAllOrders();
        List<OrderDto> orderWithStatus = new ArrayList<>();
        for (OrderDto o : order) {
            if (o.getStatus() != null && o.getStatus().equalsIgnoreCase(status)) {
                orderWithStatus.add(o);
            }
        }
        return orderWithStatus;
    }

    @Override
    public void createInvoiceCash(String orderId) {
//        OrderService o = new OrderServiceImpl();
        OrderDto order = this.getOrderById(orderId);

        order.setStatus("Completed");
        order.setPayMethod("Cash");

        orderDao.update(OrderMapper.toEntity(order, 1));
    }
    
    @Override
    public void createInvoiceBank(String orderId) {
//        OrderService o = new OrderServiceImpl();
        OrderDto order = this.getOrderById(orderId);

        order.setStatus("Completed");
        order.setPayMethod("Online Bankking");

        orderDao.update(OrderMapper.toEntity(order, 1));
    }
}
