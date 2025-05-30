package com.bqa.model;

import java.math.BigDecimal;

/**
 * CartItem entity class
 */
public class CartItem {
    private int itemId;
    private int cartId;
    private int productId;
    private Integer variantId;
    private int quantity;
    private java.sql.Timestamp addedAt;
    
    // Additional fields for display
    private String productName;
    private String productImage;
    private BigDecimal price;
    private String variantSize;
    private String variantColor;
    
    // Constructors
    public CartItem() {
    }
    
    public CartItem(int itemId, int cartId, int productId, Integer variantId,
                    int quantity, java.sql.Timestamp addedAt) {
        this.itemId = itemId;
        this.cartId = cartId;
        this.productId = productId;
        this.variantId = variantId;
        this.quantity = quantity;
        this.addedAt = addedAt;
    }
    
    // Getters and Setters
    public int getItemId() {
        return itemId;
    }
    
    public void setItemId(int itemId) {
        this.itemId = itemId;
    }
    
    public int getCartId() {
        return cartId;
    }
    
    public void setCartId(int cartId) {
        this.cartId = cartId;
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
    
    public java.sql.Timestamp getAddedAt() {
        return addedAt;
    }
    
    public void setAddedAt(java.sql.Timestamp addedAt) {
        this.addedAt = addedAt;
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
    
    public BigDecimal getPrice() {
        return price;
    }
    
    public void setPrice(BigDecimal price) {
        this.price = price;
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
        return "CartItem{" +
                "itemId=" + itemId +
                ", cartId=" + cartId +
                ", productId=" + productId +
                ", quantity=" + quantity +
                ", productName='" + productName + '\'' +
                '}';
    }
}
