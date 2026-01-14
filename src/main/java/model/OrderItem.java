/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.math.BigDecimal;
import java.time.OffsetDateTime;

/**
 *
 * @author Asus
 */
public class OrderItem {
    private int orderItemId; // tương ứng order_item_id INT GENERATED
    private String orderId;
    private String productId;
    private int quantity;
    private BigDecimal unitPrice;
    private BigDecimal subtotal;
    private String note;
    private OffsetDateTime createdAt;
    private String ProductName;
    private String ProductImageUrl;

    public OrderItem() {
    }

    public OrderItem(int orderItemId, String orderId, String productId, int quantity, BigDecimal unitPrice, BigDecimal subtotal, String note, OffsetDateTime createdAt) {
        this.orderItemId = orderItemId;
        this.orderId = orderId;
        this.productId = productId;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.subtotal = subtotal;
        this.note = note;
        this.createdAt = createdAt;
    }

    public int getOrderItemId() {
        return orderItemId;
    }

    public void setOrderItemId(int orderItemId) {
        this.orderItemId = orderItemId;
    }


    public String getOrderId() {
        return orderId;
    }

    public void setOrderId(String orderId) {
        this.orderId = orderId;
    }

    public String getProductId() {
        return productId;
    }

    public void setProductId(String productId) {
        this.productId = productId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public BigDecimal getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(BigDecimal unitPrice) {
        this.unitPrice = unitPrice;
    }

    public BigDecimal getSubtotal() {
        return subtotal;
    }

    public void setSubtotal(BigDecimal subtotal) {
        this.subtotal = subtotal;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public OffsetDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(OffsetDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public String getProductName() {
        return ProductName;
    }

    public String getProductImageUrl() {
        return ProductImageUrl;
    }

    public void setProductImageUrl(String ProductImageUrl) {
        this.ProductImageUrl = ProductImageUrl;
    }

    public void setProductName(String ProductName) {
        this.ProductName = ProductName;
    }

}
