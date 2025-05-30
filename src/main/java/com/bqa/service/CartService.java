package com.bqa.service;

import com.bqa.dao.CartDAO;
import com.bqa.model.Cart;
import com.bqa.model.CartItem;

import java.util.List;

public class CartService {
    private CartDAO cartDAO;
    
    public CartService() {
        this.cartDAO = new CartDAO();
    }

    public Cart getOrCreateCart(int userId) {
        Cart cart = cartDAO.getCartByUserId(userId);
        
        if (cart == null) {
            int cartId = cartDAO.createCart(userId);
            if (cartId > 0) {
                cart = cartDAO.getCartByUserId(userId);
            }
        }
        
        return cart;
    }

    public List<CartItem> getCartItems(int cartId) {
        return cartDAO.getCartItems(cartId);
    }
    public boolean removeCartItem(int itemId, int cartId) {
        return cartDAO.removeCartItem(itemId, cartId);
    }

    public boolean clearCart(int cartId) {
        return cartDAO.clearCart(cartId);
    }

    public boolean saveCart(Cart cart) {
        if (cart == null || cart.getUserId() <= 0) {
            return false; // Cart must have a user ID
        }

        // Ensure cart header exists and get/set cartId
        Cart existingCart = cartDAO.getCartByUserId(cart.getUserId());
        if (existingCart == null) {
            int cartId = cartDAO.createCart(cart.getUserId());
            if (cartId > 0) {
                cart.setCartId(cartId);
            } else {
                return false; // Failed to create cart header
            }
        } else {
            cart.setCartId(existingCart.getCartId());
        }

        // Clear existing items for this cart
        boolean cleared = cartDAO.clearCart(cart.getCartId());
        if (!cleared) {
            // Log error or handle, but proceed to try adding items
            System.err.println("Failed to clear cart items for cartId: " + cart.getCartId());
        }

        // Add all current items from the cart object
        if (cart.getItems() != null) {
            for (CartItem item : cart.getItems()) {
                item.setCartId(cart.getCartId()); // Ensure item has correct cartId
                if (!cartDAO.addCartItem(item)) {
                    // Log error for specific item, but attempt to continue
                    System.err.println("Failed to add cart item: " + item.getProductId() + " to cartId: " + cart.getCartId());
                    // Optionally, collect failures and return a more detailed status
                }
            }
        }
        // Consider the operation successful if cart header is managed and items are attempted to be saved.
        // A more robust implementation might track individual addCartItem failures.
        return true; 
    }
}
