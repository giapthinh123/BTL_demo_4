package com.bqa.model;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 * Cart entity class
 */
public class Cart {
    private int cartId;
    private int userId;

    private List<CartItem> items = new ArrayList<>();

    // Constructors
    public Cart() {
    }
    
    public Cart(int cartId, int userId, Timestamp createdAt, Timestamp updatedAt) {
        this.cartId = cartId;
        this.userId = userId;
    }
    
    // Getters and Setters
    public int getCartId() {
        return cartId;
    }
    
    public void setCartId(int cartId) {
        this.cartId = cartId;
    }
    
    public int getUserId() {
        return userId;
    }
    
    public void setUserId(int userId) {
        this.userId = userId;
    }

    public List<CartItem> getItems() {
        return items;
    }
    
    public void setItems(List<CartItem> items) {
        this.items = items;
    }
    
    @Override
    public String toString() {
        return "Cart{" +
                "cartId=" + cartId +
                ", userId=" + userId +
                '}';
    }
}
