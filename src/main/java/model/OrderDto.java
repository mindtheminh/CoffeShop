/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.math.BigDecimal;
import java.time.OffsetDateTime;
import java.util.Date;

/**
 *
 * @author Asus
 */
public class OrderDto {

    private String orderId;
    private String customerName;
    private String status;
    private BigDecimal totalAmount;
    private BigDecimal paymentAmount;
    private String paymentStatus;
    private OffsetDateTime createdAt;
    private OffsetDateTime updatedAt;
    private String note;
    private String shippingAddress;
    private String phoneContact;
    private String orderType;

    public String getNote() {
        return note;
    }
    
    public String getOrderType() {
        return orderType;
    }

    public void setOrderType(String orderType) {
        this.orderType = orderType;
    }

    public void setNote(String note) {
        this.note = note;
    }
    
    public String getShippingAddress() {
        return shippingAddress;
    }

    public void setShippingAddress(String shippingAddress) {
        this.shippingAddress = shippingAddress;
    }

    public String getPhoneContact() {
        return phoneContact;
    }

    public void setPhoneContact(String phoneContact) {
        this.phoneContact = phoneContact;
    }
    
    private String payMethod;

    public OffsetDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(OffsetDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public OrderDto(String orderId, String customerName, String status, BigDecimal totalAmount, BigDecimal paymentAmount, String paymentStatus, OffsetDateTime createdAt, String payMethod) {
        this.orderId = orderId;
        this.customerName = customerName;
        this.status = status;
        this.totalAmount = totalAmount;
        this.paymentAmount = paymentAmount;
        this.paymentStatus = paymentStatus;
        this.createdAt = createdAt;
        this.payMethod = payMethod;
    }

    public OrderDto() {
    }

    public String getOrderId() {
        return orderId;
    }

    public void setOrderId(String orderId) {
        this.orderId = orderId;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    public BigDecimal getPaymentAmount() {
        return paymentAmount;
    }

    public void setPaymentAmount(BigDecimal paymentAmount) {
        this.paymentAmount = paymentAmount;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public OffsetDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(OffsetDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public String getPayMethod() {
        return payMethod;
    }

    public void setPayMethod(String payMethod) {
        this.payMethod = payMethod;
    }

    @Override
    public String toString() {
        return "OrderDto{" + "orderId=" + orderId + ", customerName=" + customerName + ", status=" + status + ", totalAmount=" + totalAmount + ", paymentAmount=" + paymentAmount + ", paymentStatus=" + paymentStatus + ", createdAt=" + createdAt + ", updatedAt=" + updatedAt + ", payMethod=" + payMethod + '}';
    }

//getter phụ 
    public Date getCreatedAtAsDate() {
        if (createdAt != null) {
            return Date.from(createdAt.toInstant());
        }
        return null;
    }

    public Date getUpdatedAtAsDate() {
        if (updatedAt != null) {
            return Date.from(updatedAt.toInstant());
        }
        return null;
    }
}
