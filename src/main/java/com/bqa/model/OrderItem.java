package com.bqa.model;

import java.math.BigDecimal;

/**
 * OrderItem entity class
 */
public class OrderItem {
    private int itemId;
    private int orderId;
    private int productId;
    private Integer variantId;
    private int quantity;
    private BigDecimal price;
    private BigDecimal subtotal;
    
    // Additional fields for display
    private String productName;
    private String productImage;
    private String variantSize;
    private String variantColor;
    
    // Constructors
    public OrderItem() {
    }
    
    public OrderItem(int itemId, int orderId, int productId, Integer variantId,
                     int quantity, BigDecimal price, BigDecimal subtotal) {
        this.itemId = itemId;
        this.orderId = orderId;
        this.productId = productId;
        this.variantId = variantId;
        this.quantity = quantity;
        this.price = price;
        this.subtotal = subtotal;
    }
    
    // Getters and Setters
    public int getItemId() {
        return itemId;
    }
    
    public void setItemId(int itemId) {
        this.itemId = itemId;
    }
    
    public int getOrderId() {
        return orderId;
    }
    
    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }
    
    public int getProductId() {
        return productId;
    }
    
    public void setProductId(int productId) {
        this.productId = productId;
    }
    
    public Integer getVariantId() {
        return variantId;
    }
    
    public void setVariantId(Integer variantId) {
        this.variantId = variantId;
    }
    
    public int getQuantity() {
        return quantity;
    }
    
    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
    
    public BigDecimal getPrice() {
        return price;
    }
    
    public void setPrice(BigDecimal price) {
        this.price = price;
    }
    
    public BigDecimal getSubtotal() {
        return subtotal;
    }
    
    public void setSubtotal(BigDecimal subtotal) {
        this.subtotal = subtotal;
    }
    
    public String getProductName() {
        return productName;
    }
    
    public void setProductName(String productName) {
        this.productName = productName;
    }
    
    public String getProductImage() {
        return productImage;
    }
    
    public void setProductImage(String productImage) {
        this.productImage = productImage;
    }
    
    public String getVariantSize() {
        return variantSize;
    }
    
    public void setVariantSize(String variantSize) {
        this.variantSize = variantSize;
    }
    
    public String getVariantColor() {
        return variantColor;
    }
    
    public void setVariantColor(String variantColor) {
        this.variantColor = variantColor;
    }
    
    @Override
    public String toString() {
        return "OrderItem{" +
                "itemId=" + itemId +
                ", orderId=" + orderId +
                ", productId=" + productId +
                ", quantity=" + quantity +
                ", price=" + price +
                ", subtotal=" + subtotal +
                '}';
    }
}
