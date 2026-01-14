package model;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.OffsetDateTime;

/**
 * OrderMapper - Maps between Order entity and OrderDto
 *
 * @author Asus
 */
public class OrderMapper {

    /**
     * Convert Order entity to OrderDto
     * @param o
     * @param customerName
     * @return 
     */
    public static OrderDto toDto(Order o, String customerName) {
        OrderDto dto = new OrderDto();
        dto.setOrderId(o.getOrderId());
        dto.setCustomerName(customerName);
        dto.setStatus(o.getStatus());
        dto.setTotalAmount(o.getTotalAmount());
        dto.setPaymentAmount(o.getPaymentAmount());
        dto.setPaymentStatus(o.getPaymentStatus());
        dto.setCreatedAt(o.getCreatedAt());
        dto.setUpdatedAt(o.getUpdatedAt());
        dto.setPayMethod(o.getPayMethod());
        dto.setNote(o.getNote());
        dto.setShippingAddress(o.getShippingAddress());
        dto.setPhoneContact(o.getPhoneContact());
        dto.setOrderType(o.getOrderType());
        return dto;
    }

    public static Order toEntity(OrderDto dto, int userId) {
        Order o = new Order();
        o.setOrderId(dto.getOrderId());
        o.setUserId(userId);
        o.setStatus(dto.getStatus());
        o.setTotalAmount(dto.getTotalAmount());
        o.setPaymentAmount(dto.getPaymentAmount());
        o.setPaymentStatus(dto.getPaymentStatus());
        o.setCreatedAt(dto.getCreatedAt());
        o.setUpdatedAt(dto.getUpdatedAt());
        o.setPayMethod(dto.getPayMethod());
        return o;
    }

    public static Order fromResultSet(ResultSet rs) throws SQLException {
        Order o = new Order();

        o.setOrderId(rs.getString("order_id"));
        o.setUserId(rs.getInt("user_id"));
        o.setStatus(rs.getString("status"));
        o.setOrderType(rs.getString("order_type"));
        o.setTotalAmount(rs.getBigDecimal("total_amount"));
        o.setDiscountAmount(rs.getBigDecimal("discount_amount"));
        o.setPayMethod(rs.getString("pay_method"));
        o.setNote(rs.getString("note"));
        o.setPromotionId(rs.getString("promotion_id"));
        o.setPaymentStatus(rs.getString("payment_status"));
        o.setPaymentAmount(rs.getBigDecimal("payment_amount"));
        o.setTransactionCode(rs.getString("transaction_code"));
        o.setPaymentReference(rs.getString("payment_reference"));
        o.setShippingAddress(rs.getString("shipping_address"));
        o.setPhoneContact(rs.getString("phone_contact"));
        o.setCart(rs.getBoolean("is_cart"));

        o.setCreatedAt(rs.getObject("created_at", OffsetDateTime.class));
        o.setUpdatedAt(rs.getObject("updated_at", OffsetDateTime.class));
        o.setPaymentDate(rs.getObject("payment_date", OffsetDateTime.class));
        o.setExpiresAt(rs.getObject("expires_at", OffsetDateTime.class));
        return o;
    }
}
