package com.bqa.service;

import com.bqa.dao.OrderDAO;
import com.bqa.model.Cart;
import com.bqa.model.CartItem;
import com.bqa.model.Order;
import com.bqa.model.OrderItem;

import java.util.*;

/**
 * Service class for Order-related operations
 */
public class OrderService {
    private OrderDAO orderDAO;
    
    public OrderService() {
        this.orderDAO = new OrderDAO();
    }

    public Order getOrderById(int orderId) {
        return orderDAO.getOrderById(orderId);
    }

    public List<Order> getAllOrders() {
        return orderDAO.getAllOrders();
    }
    public int createOrder(Order order, List<OrderItem> items) {
        // Validate order data
        if (order.getUserId() <= 0 || order.getTotalAmount() == null || 
            order.getShippingAddress() == null || order.getShippingPhone() == null || 
            order.getShippingName() == null || order.getPaymentMethod() == null) {
            return -1;
        }
        
        // Set default values if not specified
        if (order.getPaymentStatus() == null) {
            order.setPaymentStatus("PENDING");
        }
        
        if (order.getOrderStatus() == null) {
            order.setOrderStatus("PENDING");
        }
        
        // Create order
        int orderId = orderDAO.addOrder(order);
        
        if (orderId > 0 && items != null && !items.isEmpty()) {
            // Add order items
            for (OrderItem item : items) {
                item.setOrderId(orderId);
                orderDAO.addOrderItem(item);
            }
        }
        
        return orderId;
    }

    public boolean updateOrder(Order order) {
        // Validate order data
        if (order.getOrderId() <= 0 || order.getUserId() <= 0 || 
            order.getTotalAmount() == null || order.getShippingAddress() == null || 
            order.getShippingPhone() == null || order.getShippingName() == null || 
            order.getPaymentMethod() == null) {
            return false;
        }
        
        // Check if order exists
        Order existingOrder = orderDAO.getOrderById(order.getOrderId());
        if (existingOrder == null) {
            return false;
        }
        
        return orderDAO.updateOrder(order);
    }

    public boolean updateOrderStatus(int orderId, String status) {
        // Validate status
        if (status == null || !isValidOrderStatus(status)) {
            return false;
        }
        
        return orderDAO.updateOrderStatus(orderId, status);
    }

    public boolean updatePaymentStatus(int orderId, String status) {
        // Validate status
        if (status == null || !isValidPaymentStatus(status)) {
            return false;
        }
        
        return orderDAO.updatePaymentStatus(orderId, status);
    }

    public List<OrderItem> getOrderItems(int orderId) {
        return orderDAO.getOrderItems(orderId);
    }

    public Order getOrder(int orderId) {
        return orderDAO.getOrderById(orderId);
    }

    public List<OrderItem> createOrderItemsFromCart(Cart cart) {
        List<OrderItem> orderItems = new ArrayList<>();
        if (cart != null && cart.getItems() != null) {
            for (CartItem cartItem : cart.getItems()) {
                OrderItem orderItem = new OrderItem();
                orderItem.setProductId(cartItem.getProductId());
                orderItem.setQuantity(cartItem.getQuantity());
                orderItem.setPrice(cartItem.getPrice()); 
                orderItem.setSubtotal(cartItem.getPrice().multiply(new java.math.BigDecimal(cartItem.getQuantity())));
                // Assuming variantId, productName, etc., might be needed from CartItem if OrderItem stores them
                // For now, basic mapping.
                orderItems.add(orderItem);
            }
        }
        return orderItems;
    }
    
    public List<Order> getAllOrders(String search, String status, Date startDate, Date endDate,String paymentStatus, int offset, int limit) {
        java.sql.Date sqlStartDate = startDate != null ? new java.sql.Date(startDate.getTime()) : null;
        java.sql.Date sqlEndDate = endDate != null ? new java.sql.Date(endDate.getTime()) : null;
        
        return orderDAO.getAllOrders(search, status, sqlStartDate, sqlEndDate, offset, limit, paymentStatus);
    }

    public List<Order> getAllOrders(int userId,String search, String status, Date startDate, Date endDate,String paymentStatus, int offset, int limit) {
        java.sql.Date sqlStartDate = startDate != null ? new java.sql.Date(startDate.getTime()) : null;
        java.sql.Date sqlEndDate = endDate != null ? new java.sql.Date(endDate.getTime()) : null;

        return orderDAO.getAllOrders(userId,search, status, sqlStartDate, sqlEndDate, offset, limit, paymentStatus);
    }

    public int getTotalOrders(String search, String status, Date startDate, Date endDate, String paymentStatus) {
        java.sql.Date sqlStartDate = startDate != null ? new java.sql.Date(startDate.getTime()) : null;
        java.sql.Date sqlEndDate = endDate != null ? new java.sql.Date(endDate.getTime()) : null;
        return orderDAO.getTotalOrders(search, status, sqlStartDate, sqlEndDate, paymentStatus );
    }

    public int getTotalOrders(int userId,String search, String status, Date startDate, Date endDate, String paymentStatus) {
        java.sql.Date sqlStartDate = startDate != null ? new java.sql.Date(startDate.getTime()) : null;
        java.sql.Date sqlEndDate = endDate != null ? new java.sql.Date(endDate.getTime()) : null;
        return orderDAO.getTotalOrders(userId,search, status, sqlStartDate, sqlEndDate, paymentStatus);
    }

    public int getOrderCountByStatus(String status) {
        return orderDAO.getOrderCountByStatus(status);
    }

    private boolean isValidOrderStatus(String status) {
        return status.equals("PENDING") || status.equals("PROCESSING") || 
               status.equals("SHIPPED") || status.equals("DELIVERED") || 
               status.equals("CANCELLED");
    }

    private boolean isValidPaymentStatus(String status) {
        return status.equals("PENDING") || status.equals("PAID") || 
               status.equals("FAILED") || status.equals("REFUNDED");
    }

    public double getTotalRevenue() {
        return orderDAO.getTotalRevenue();
    }

    public List<Map<String, Object>> getSalesData(java.sql.Date startDate, java.sql.Date endDate) {
        java.sql.Date sqlStartDate = startDate != null ? new java.sql.Date(startDate.getTime()) : null;
        java.sql.Date sqlEndDate = endDate != null ? new java.sql.Date(endDate.getTime()) : null;
        return orderDAO.getSalesData(sqlStartDate, sqlEndDate);
    }
}
