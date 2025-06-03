package com.bqa.dao;

import com.bqa.model.Cart;
import com.bqa.model.CartItem;
import com.bqa.util.DBconn;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CartDAO {

    public Cart getCartByUserId(int userId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        Cart cart = null;
        
        try {
            conn = DBconn.getConnection();
            String sql = "SELECT * FROM carts WHERE user_id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                cart = mapResultSetToCart(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, rs);
        }
        
        return cart;
    }

    public int createCart(int userId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        int cartId = -1;
        
        try {
            conn = DBconn.getConnection();
            String sql = "INSERT INTO carts (user_id) VALUES (?)";
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stmt.setInt(1, userId);
            
            int rowsAffected = stmt.executeUpdate();
            
            if (rowsAffected > 0) {
                rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    cartId = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, rs);
        }
        
        return cartId;
    }

    public List<CartItem> getCartItems(int cartId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<CartItem> items = new ArrayList<>();
        
        try {
            conn = DBconn.getConnection();
            String sql = "SELECT ci.*, p.name as product_name, p.thumbnail as product_image, " +
                         "p.price as price, pv.size as variant_size, pv.color as variant_color " +
                         "FROM cart_items ci " +
                         "LEFT JOIN products p ON ci.product_id = p.product_id " +
                         "LEFT JOIN product_variants pv ON ci.variant_id = pv.variant_id " +
                         "WHERE ci.cart_id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, cartId);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                CartItem item = new CartItem();
                item.setItemId(rs.getInt("item_id"));
                item.setCartId(rs.getInt("cart_id"));
                item.setProductId(rs.getInt("product_id"));
                
                int variantId = rs.getInt("variant_id");
                if (!rs.wasNull()) {
                    item.setVariantId(variantId);
                }
                
                item.setQuantity(rs.getInt("quantity"));
                
                // Additional display fields
                item.setProductName(rs.getString("product_name"));
                item.setProductImage(rs.getString("product_image"));
                item.setPrice(rs.getBigDecimal("price"));
                item.setVariantSize(rs.getString("variant_size"));
                item.setVariantColor(rs.getString("variant_color"));
                
                items.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, rs);
        }
        
        return items;
    }

    public boolean addCartItem(CartItem item) {
        Connection conn = null;
        PreparedStatement stmt = null;
        boolean success = false;
        
        try {
            conn = DBconn.getConnection();
            
            // Check if item already exists in cart
            String checkSql = "SELECT * FROM cart_items WHERE cart_id = ? AND product_id = ? AND " +
                             "(variant_id = ? OR (variant_id IS NULL AND ? IS NULL))";
            PreparedStatement checkStmt = conn.prepareStatement(checkSql);
            checkStmt.setInt(1, item.getCartId());
            checkStmt.setInt(2, item.getProductId());
            
            if (item.getVariantId() != null) {
                checkStmt.setInt(3, item.getVariantId());
                checkStmt.setInt(4, item.getVariantId());
            } else {
                checkStmt.setNull(3, Types.INTEGER);
                checkStmt.setNull(4, Types.INTEGER);
            }
            
            ResultSet rs = checkStmt.executeQuery();
            
            if (rs.next()) {
                // Item exists, update quantity
                int existingItemId = rs.getInt("item_id");
                int existingQuantity = rs.getInt("quantity");
                int newQuantity = existingQuantity + item.getQuantity();
                
                String updateSql = "UPDATE cart_items SET quantity = ? WHERE item_id = ?";
                PreparedStatement updateStmt = conn.prepareStatement(updateSql);
                updateStmt.setInt(1, newQuantity);
                updateStmt.setInt(2, existingItemId);
                
                int rowsAffected = updateStmt.executeUpdate();
                success = (rowsAffected > 0);
                
                updateStmt.close();
            } else {
                // Item doesn't exist, insert new item
                String insertSql = "INSERT INTO cart_items (cart_id, product_id, variant_id, quantity) " +
                                  "VALUES (?, ?, ?, ?)";
                PreparedStatement insertStmt = conn.prepareStatement(insertSql);
                insertStmt.setInt(1, item.getCartId());
                insertStmt.setInt(2, item.getProductId());
                
                if (item.getVariantId() != null) {
                    insertStmt.setInt(3, item.getVariantId());
                } else {
                    insertStmt.setNull(3, Types.INTEGER);
                }
                
                insertStmt.setInt(4, item.getQuantity());
                
                int rowsAffected = insertStmt.executeUpdate();
                success = (rowsAffected > 0);
                
                insertStmt.close();
            }
            
            rs.close();
            checkStmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, null);
        }
        
        return success;
    }

    public boolean removeCartItem(int itemId, int cartId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        boolean success = false;
        
        try {
            conn = DBconn.getConnection();
            String deleteSql = "DELETE FROM cart_items WHERE product_id = ? AND cart_id = ?";
            stmt = conn.prepareStatement(deleteSql);
            stmt.setInt(1, itemId);
            stmt.setInt(2, cartId);
            stmt.executeUpdate();
            success = true;
            stmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, null);
        }
        
        return success;
    }

    public boolean clearCart(int cartId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        boolean success = false;
        
        try {
            conn = DBconn.getConnection();
            
            // Delete all items
            String deleteSql = "DELETE FROM cart_items WHERE cart_id = ?";
            stmt = conn.prepareStatement(deleteSql);
            stmt.setInt(1, cartId);
            
            stmt.executeUpdate();
            stmt.close();
            success = true;

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, null);
        }
        
        return success;
    }

    private Cart mapResultSetToCart(ResultSet rs) throws SQLException {
        Cart cart = new Cart();
        cart.setCartId(rs.getInt("cart_id"));
        cart.setUserId(rs.getInt("user_id"));
        return cart;
    }

    private void closeResources(Connection conn, Statement stmt, ResultSet rs) {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) DBconn.closeConnection(conn);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
