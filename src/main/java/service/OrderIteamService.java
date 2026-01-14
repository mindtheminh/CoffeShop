/*1
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 *0zzzzzzzzzzzzzz Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dao.OrderDaoJdbc;
import dao.OrderItemDao;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import model.Order;
import model.OrderItem;
import model.OrderItemDto;

/**
 *
 * @author Acer
 */
public class OrderIteamService {

    private final OrderItemDao orderItemDao = new OrderItemDao();
    private final OrderDaoJdbc orderDao = new OrderDaoJdbc();

    // Thêm OrderItem vào Order hiện tại
    public void addOrderItemToOrderOffline(OrderItem newItem, String currentOrderId) {
        // Lấy OrderItem cua
        List<OrderItem> orderItems = orderItemDao.getOrderItemsByOrderId(currentOrderId);

        boolean found = false;

        for (OrderItem existingItem : orderItems) {
            if (existingItem.getProductId().equals(newItem.getProductId())) {
                // Nếu đã tồn tại sản phẩm, cập nhật quantity và subtotal
                int updatedQuantity = existingItem.getQuantity() + newItem.getQuantity();
                existingItem.setQuantity(updatedQuantity);
                existingItem.setSubtotal(existingItem.getUnitPrice().multiply(new BigDecimal(updatedQuantity)));

                // Cập nhật lại vào DB
                orderItemDao.update(existingItem);
                found = true;
                break;
            }
        }

        // Nếu chưa tồn tại, thêm mới
        if (!found) {
            orderItemDao.create(newItem, currentOrderId);
        }

        // Lấy lại danh sách orderItems cập nhật
        List<OrderItem> updatedOrderItems = orderItemDao.getOrderItemsByOrderId(currentOrderId);

        // Tính tổng tiền
        BigDecimal totalAmount = calculateTotalAmount(updatedOrderItems);
        BigDecimal payAmount = calculatePayAmount(updatedOrderItems);

        // Cập nhật tổng tiền vào Order
        Order order = orderDao.findById(currentOrderId)
                .orElseThrow(() -> new RuntimeException("Order không tồn tại!"));
        order.setTotalAmount(totalAmount);
        order.setPaymentAmount(payAmount);

        orderDao.update(order);
    }

    public BigDecimal calculateTotalAmount(List<OrderItem> orderItems) {
        return orderItems.stream()
                .map(OrderItem::getSubtotal)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    private BigDecimal calculatePayAmount(List<OrderItem> orderItems) {
        return orderItems.stream()
                .map(OrderItem::getSubtotal)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

//    public static void main(String[] args) {
//        OrderIteamService service = new OrderIteamService();
//        OrderDaoJdbc orderDao = new OrderDaoJdbc();
//
//        try {
//            // 1. Tạo Order mới
//            Order order = new Order();
//            order.setUserId(1); // giả sử user_id = 1 tồn tại
//            order.setStatus("Pending");
//            order.setTotalAmount(BigDecimal.ZERO);
//
//            String orderId = orderDao.create(order, userId);
//            System.out.println("Created Order ID: " + orderId);
//
//            // 2. Tạo OrderItem demo
//            OrderItem item = new OrderItem();
//            item.setProductId("P001");
//            item.setQuantity(2);
//            item.setUnitPrice(new BigDecimal("120000"));
//            item.setSubtotal(item.getUnitPrice().multiply(BigDecimal.valueOf(item.getQuantity())));
//            item.setNote("Test nhanh");
//
//            // 3. Thêm vào order
//            service.addOrderItemToOrderOffline(item, orderId);
//
//            // 4. Lấy order để check
//            Order updated = orderDao.findById(orderId).orElseThrow();
//            System.out.println("Updated Order Total: " + updated.getTotalAmount());
//
//        } catch (Exception e) {
//            System.err.println("❌ Lỗi test nhanh: " + e.getMessage());
//            e.printStackTrace();
//        }
//    }
}
