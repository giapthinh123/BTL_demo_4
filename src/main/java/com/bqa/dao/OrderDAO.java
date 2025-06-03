package com.bqa.dao;

import com.bqa.model.Order;
import com.bqa.model.OrderItem;
import com.bqa.util.DBconn;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class OrderDAO {

    public List<Order> getOrdersByUserId(int userId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Order> orders = new ArrayList<>();

        try {
            conn = DBconn.getConnection();
            String sql = "SELECT * FROM orders WHERE user_id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            rs = stmt.executeQuery();

            while (rs.next()) {
                Order order = mapResultSetToOrder(rs);
                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, rs);
        }
        
        return orders;
    }

    public Order getOrderById(int orderId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        Order order = null;
        
        try {
            conn = DBconn.getConnection();
            String sql = "SELECT * FROM orders WHERE order_id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, orderId);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                order = mapResultSetToOrder(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, rs);
        }
        
        return order;
    }

    public List<Order> getAllOrders() {
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        List<Order> orders = new ArrayList<>();
        
        try {
            conn = DBconn.getConnection();
            stmt = conn.createStatement();
            String sql = "SELECT * FROM orders ORDER BY order_date DESC";
            rs = stmt.executeQuery(sql);
            
            while (rs.next()) {
                Order order = mapResultSetToOrder(rs);
                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, rs);
        }
        
        return orders;
    }

    public int addOrder(Order order) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        int orderId = -1;
        
        try {
            conn = DBconn.getConnection();
            String sql = "INSERT INTO orders (user_id, total_amount, shipping_address, shipping_phone, " +
                         "shipping_name, payment_method, payment_status, order_status, note) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stmt.setInt(1, order.getUserId());
            stmt.setBigDecimal(2, order.getTotalAmount());
            stmt.setString(3, order.getShippingAddress());
            stmt.setString(4, order.getShippingPhone());
            stmt.setString(5, order.getShippingName());
            stmt.setString(6, order.getPaymentMethod());
            stmt.setString(7, order.getPaymentStatus());
            stmt.setString(8, order.getOrderStatus());
            stmt.setString(9, order.getNote());
            
            int rowsAffected = stmt.executeUpdate();
            
            if (rowsAffected > 0) {
                rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    orderId = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, rs);
        }
        
        return orderId;
    }

    public boolean updateOrder(Order order) {
        Connection conn = null;
        PreparedStatement stmt = null;
        boolean success = false;
        
        try {
            conn = DBconn.getConnection();
            String sql = "UPDATE orders SET user_id = ?, total_amount = ?, shipping_address = ?, " +
                         "shipping_phone = ?, shipping_name = ?, payment_method = ?, " +
                         "payment_status = ?, order_status = ?, note = ? WHERE order_id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, order.getUserId());
            stmt.setBigDecimal(2, order.getTotalAmount());
            stmt.setString(3, order.getShippingAddress());
            stmt.setString(4, order.getShippingPhone());
            stmt.setString(5, order.getShippingName());
            stmt.setString(6, order.getPaymentMethod());
            stmt.setString(7, order.getPaymentStatus());
            stmt.setString(8, order.getOrderStatus());
            stmt.setString(9, order.getNote());
            stmt.setInt(10, order.getOrderId());

            int rowsAffected = stmt.executeUpdate();
            success = (rowsAffected > 0);
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, null);
        }
        
        return success;
    }

    public boolean updateOrderStatus(int orderId, String status) {
        Connection conn = null;
        PreparedStatement stmt = null;
        boolean success = false;
        
        try {
            conn = DBconn.getConnection();
            String sql = "UPDATE orders SET order_status = ? WHERE order_id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, status);
            stmt.setInt(2, orderId);
            
            int rowsAffected = stmt.executeUpdate();
            success = (rowsAffected > 0);
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, null);
        }
        
        return success;
    }

    public boolean updatePaymentStatus(int orderId, String status) {
        Connection conn = null;
        PreparedStatement stmt = null;
        boolean success = false;
        
        try {
            conn = DBconn.getConnection();
            String sql = "UPDATE orders SET payment_status = ? WHERE order_id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, status);
            stmt.setInt(2, orderId);
            
            int rowsAffected = stmt.executeUpdate();
            success = (rowsAffected > 0);
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, null);
        }
        
        return success;
    }

    public List<OrderItem> getOrderItems(int orderId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<OrderItem> items = new ArrayList<>();
        
        try {
            conn = DBconn.getConnection();
            String sql = "SELECT oi.*, p.name as product_name, p.thumbnail as product_image, " +
                         "pv.size as variant_size, pv.color as variant_color " +
                         "FROM order_items oi " +
                         "LEFT JOIN products p ON oi.product_id = p.product_id " +
                         "LEFT JOIN product_variants pv ON oi.variant_id = pv.variant_id " +
                         "WHERE oi.order_id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, orderId);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                OrderItem item = new OrderItem();
                item.setItemId(rs.getInt("item_id"));
                item.setOrderId(rs.getInt("order_id"));
                item.setProductId(rs.getInt("product_id"));
                
                int variantId = rs.getInt("variant_id");
                if (!rs.wasNull()) {
                    item.setVariantId(variantId);
                }
                
                item.setQuantity(rs.getInt("quantity"));
                item.setPrice(rs.getBigDecimal("price"));
                item.setSubtotal(rs.getBigDecimal("subtotal"));
                
                // Additional display fields
                item.setProductName(rs.getString("product_name"));
                item.setProductImage(rs.getString("product_image"));
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

    public boolean addOrderItem(OrderItem item) {
        Connection conn = null;
        PreparedStatement stmt = null;
        boolean success = false;
        
        try {
            conn = DBconn.getConnection();
            String sql = "INSERT INTO order_items (order_id, product_id, variant_id, quantity, price, subtotal) " +
                         "VALUES (?, ?, ?, ?, ?, ?)";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, item.getOrderId());
            stmt.setInt(2, item.getProductId());
            
            if (item.getVariantId() != null) {
                stmt.setInt(3, item.getVariantId());
            } else {
                stmt.setNull(3, Types.INTEGER);
            }
            
            stmt.setInt(4, item.getQuantity());
            stmt.setBigDecimal(5, item.getPrice());
            stmt.setBigDecimal(6, item.getSubtotal());
            
            int rowsAffected = stmt.executeUpdate();
            success = (rowsAffected > 0);
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, null);
        }
        
        return success;
    }

    public List<Order> getAllOrders(String search, String status, Date startDate, Date endDate, int offset, int limit, String paymentStatus) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Order> orders = new ArrayList<>();
        
        try {
            conn = DBconn.getConnection();
            StringBuilder sql = new StringBuilder("SELECT * FROM orders WHERE 1=1");
            List<Object> params = new ArrayList<>();
            
            if (search != null && !search.isEmpty()) {
                sql.append(" AND (shipping_name LIKE ? OR shipping_phone LIKE ? OR shipping_address LIKE ?)");
                String searchPattern = "%" + search + "%";
                params.add(searchPattern);
                params.add(searchPattern);
                params.add(searchPattern);
            }
            
            if (status != null && !status.isEmpty()) {
                sql.append(" AND order_status = ?");
                params.add(status);
            }
            
            if (paymentStatus != null && !paymentStatus.isEmpty()) {
                sql.append(" AND payment_method = ?");
                params.add(paymentStatus);
            }

            if (startDate != null) {
                sql.append(" AND order_date >= ?");
                params.add(new Timestamp(startDate.getTime()));
            }
            
            if (endDate != null) {
                sql.append(" AND order_date <= ?");
                params.add(new Timestamp(endDate.getTime()));
            }
            
            sql.append(" LIMIT ? OFFSET ?");
            params.add(limit);
            params.add(offset);
            
            stmt = conn.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            
            rs = stmt.executeQuery();
            while (rs.next()) {
                Order order = mapResultSetToOrder(rs);
                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, rs);
        }
        
        return orders;
    }

    public List<Order> getAllOrders(int userId,String search, String status, Date startDate, Date endDate, int offset, int limit, String paymentStatus) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Order> orders = new ArrayList<>();
        
        try {
            conn = DBconn.getConnection();
            StringBuilder sql = new StringBuilder("SELECT * FROM orders WHERE user_id = " + userId);
            List<Object> params = new ArrayList<>();
            
            if (search != null && !search.isEmpty()) {
                sql.append(" AND (shipping_name LIKE ? OR shipping_phone LIKE ? OR shipping_address LIKE ?)");
                String searchPattern = "%" + search + "%";
                params.add(searchPattern);
                params.add(searchPattern);
                params.add(searchPattern);
            }
            
            if (status != null && !status.isEmpty()) {
                sql.append(" AND order_status = ?");
                params.add(status);
            }
            
            if (paymentStatus != null && !paymentStatus.isEmpty()) {
                sql.append(" AND payment_method = ?");
                params.add(paymentStatus);
            }

            if (startDate != null) {
                sql.append(" AND order_date >= ?");
                params.add(new Timestamp(startDate.getTime()));
            }
            
            if (endDate != null) {
                sql.append(" AND order_date <= ?");
                params.add(new Timestamp(endDate.getTime()));
            }
            
            sql.append(" LIMIT ? OFFSET ?");
            params.add(limit);
            params.add(offset);
            
            stmt = conn.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            
            rs = stmt.executeQuery();
            while (rs.next()) {
                Order order = mapResultSetToOrder(rs);
                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, rs);
        }
        
        return orders;
    }
    
    public int getTotalOrders(String search, String status, Date startDate, Date endDate, String paymentStatus) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        int total = 0;
        
        try {
            conn = DBconn.getConnection();
            StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM orders WHERE 1=1");
            List<Object> params = new ArrayList<>();
            
            if (search != null && !search.isEmpty()) {
                sql.append(" AND (shipping_name LIKE ? OR shipping_phone LIKE ? OR shipping_address LIKE ?)");
                String searchPattern = "%" + search + "%";
                params.add(searchPattern);
                params.add(searchPattern);
                params.add(searchPattern);
            }
            
            if (status != null && !status.isEmpty()) {
                sql.append(" AND order_status = ?");
                params.add(status);
            }

            if (paymentStatus != null && !paymentStatus.isEmpty()) {
                sql.append(" AND payment_method = ?");
                params.add(paymentStatus);
            }
            
            if (startDate != null) {
                sql.append(" AND order_date >= ?");
                params.add(new Timestamp(startDate.getTime()));
            }
            
            if (endDate != null) {
                sql.append(" AND order_date <= ?");
                params.add(new Timestamp(endDate.getTime()));
            }
            
            stmt = conn.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            
            rs = stmt.executeQuery();
            if (rs.next()) {
                total = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, rs);
        }
        
        return total;
    }

    public int getTotalOrders(int userId,String search, String status, Date startDate, Date endDate, String paymentStatus) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        int total = 0;
        
        try {
            conn = DBconn.getConnection();
            StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM orders WHERE user_id = " + userId);
            List<Object> params = new ArrayList<>();
            
            if (search != null && !search.isEmpty()) {
                sql.append(" AND (shipping_name LIKE ? OR shipping_phone LIKE ? OR shipping_address LIKE ?)");
                String searchPattern = "%" + search + "%";
                params.add(searchPattern);
                params.add(searchPattern);
                params.add(searchPattern);
            }
            
            if (status != null && !status.isEmpty()) {
                sql.append(" AND order_status = ?");
                params.add(status);
            }

            if (paymentStatus != null && !paymentStatus.isEmpty()) {
                sql.append(" AND payment_method = ?");
                params.add(paymentStatus);
            }
            
            if (startDate != null) {
                sql.append(" AND order_date >= ?");
                params.add(new Timestamp(startDate.getTime()));
            }
            
            if (endDate != null) {
                sql.append(" AND order_date <= ?");
                params.add(new Timestamp(endDate.getTime()));
            }
            
            stmt = conn.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            
            rs = stmt.executeQuery();
            if (rs.next()) {
                total = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, rs);
        }
        
        return total;
    }

    public int getOrderCountByStatus(String status) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        int count = 0;
        
        try {
            conn = DBconn.getConnection();
            String sql = "SELECT COUNT(*) FROM orders WHERE order_status = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, status);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, rs);
        }
        
        return count;
    }

    private Order mapResultSetToOrder(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setOrderId(rs.getInt("order_id"));
        order.setUserId(rs.getInt("user_id"));
        order.setOrderDate(rs.getTimestamp("order_date"));
        order.setTotalAmount(rs.getBigDecimal("total_amount"));
        order.setShippingAddress(rs.getString("shipping_address"));
        order.setShippingPhone(rs.getString("shipping_phone"));
        order.setShippingName(rs.getString("shipping_name"));
        order.setPaymentMethod(rs.getString("payment_method"));
        order.setPaymentStatus(rs.getString("payment_status"));
        order.setOrderStatus(rs.getString("order_status"));
        order.setNote(rs.getString("note"));
        return order;
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

    public double getTotalRevenue() {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        double total = 0.0;
        
        try {
            conn = DBconn.getConnection();
            String sql = "SELECT COALESCE(SUM(total_amount), 0) FROM orders";
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            if (rs.next()) {
                total = rs.getDouble(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, rs);
        }
        
        return total;
    }

    public List<Map<String, Object>> getSalesData(Date startDate, Date endDate) {
        List<Map<String, Object>> sales = new ArrayList<>();
        String sql = "SELECT DATE(order_date) as date, COALESCE(SUM(total_amount), 0) as total " +
                    "FROM orders WHERE order_status NOT IN ('cancelled', 'failed', 'refunded')";
        List<Object> params = new ArrayList<>();
        
        if (startDate != null) {
            sql += " AND order_date >= ?";
            params.add(startDate);
        }
        if (endDate != null) {
            sql += " AND order_date <= ?";
            params.add(endDate);
        }
        
        sql += " GROUP BY DATE(order_date) ORDER BY date";
        
        try (Connection conn = DBconn.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> saleData = new HashMap<>();
                saleData.put("date", rs.getDate("date"));
                saleData.put("total", rs.getDouble("total"));
                sales.add(saleData);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return sales;
    }

}
