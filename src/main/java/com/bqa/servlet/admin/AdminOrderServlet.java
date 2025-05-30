package com.bqa.servlet.admin;

import com.bqa.model.*;
import com.bqa.service.OrderService;
import com.bqa.service.productServiece;
import com.bqa.service.UserService;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * AdminOrderServlet handles all order management operations for admin
 */
@WebServlet("/admin/orders/*")
public class AdminOrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private OrderService orderService;
    private UserService userService;
    private productServiece productServiece;

    public void init() {
        orderService = new OrderService();
        userService = new UserService();
        productServiece = new productServiece();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getPathInfo();
        if (action == null) {
            action = "/list";
        }

        try {
            switch (action) {
                case "/detail":
                    viewOrderDetail(request, response);
                    break;
                case "/update-status":
                    updateOrderStatus(request, response);
                    break;
                default:
                    listOrders(request, response);
                    break;
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    private void listOrders(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        // Get filter parameters
        String search = request.getParameter("search");
        String status = request.getParameter("status");
        String startDateStr = request.getParameter("fromDate");
        String paymentStatus = request.getParameter("payment");
        String endDateStr = request.getParameter("toDate");

        // Parse dates if provided
        Date startDate = null;
        Date endDate = null;
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        
        try {
            if (startDateStr != null && !startDateStr.isEmpty()) {
                startDate = dateFormat.parse(startDateStr);
            }
            
            if (endDateStr != null && !endDateStr.isEmpty()) {
                endDate = dateFormat.parse(endDateStr);
            }
        } catch (ParseException e) {
            request.setAttribute("error", "Định dạng ngày không hợp lệ. Vui lòng sử dụng định dạng YYYY-MM-DD.");
        }

        // Get pagination parameters
        int page = 1;
        int recordsPerPage = 10;
        
        if (request.getParameter("page") != null) {
            page = Integer.parseInt(request.getParameter("page"));
        }
        
        // Get orders with pagination and filters
        List<Order> orders = orderService.getAllOrders(search, status, startDate, endDate, paymentStatus,
                                                     (page - 1) * recordsPerPage, recordsPerPage);
        
        List<User> users = new ArrayList<>();
        for (Order order : orders) {
            User user = userService.getUserById(order.getUserId());
            if (user != null) {
                users.add(user);
            }
        }
        HttpSession session = request.getSession();
        String message = (String) session.getAttribute("message");
        String error = (String) session.getAttribute("error");

        if (message != null) {
            request.setAttribute("message", message);
            session.removeAttribute("message");
        }

        if (error != null) {
            request.setAttribute("error", error);
            session.removeAttribute("error");
        }

        int totalOrders = orderService.getTotalOrders(search, status, startDate, endDate, paymentStatus);
        int totalPages = (int) Math.ceil((double) totalOrders / recordsPerPage);
        
        // Get order statistics
        int pendingOrders = orderService.getOrderCountByStatus("pending") + orderService.getOrderCountByStatus("shipping") + orderService.getOrderCountByStatus("confirmed");

        int completedOders = orderService.getOrderCountByStatus("completed");

        int cancelledOrders = orderService.getOrderCountByStatus("cancelled");
        
        // Set attributes for JSP
        request.setAttribute("orders", orders);
        request.setAttribute("users", users);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("search", search);
        request.setAttribute("status", status);
        request.setAttribute("startDate", startDateStr);
        request.setAttribute("endDate", endDateStr);
        
        // Set order statistics
        request.setAttribute("pendingOrders", pendingOrders);
        request.setAttribute("completedOders", completedOders);
        request.setAttribute("cancelledOrders", cancelledOrders);
        
        // Forward to order list page
        RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/order-list.jsp");
        dispatcher.forward(request, response);
    }

    private void viewOrderDetail(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        String orderIdStr = request.getParameter("id");
        if (orderIdStr == null || orderIdStr.trim().isEmpty()) {
            HttpSession session = request.getSession();
            session.setAttribute("error", "Mã đơn hàng không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/admin/orders");
            return;
        }

        try {
            int id = Integer.parseInt(orderIdStr);
            
            // Get order details
            Order order = orderService.getOrderById(id);
            if (order == null) {
                HttpSession session = request.getSession();
                session.setAttribute("error", "Đơn hàng không tồn tại");
                response.sendRedirect(request.getContextPath() + "/admin/orders");
                return;
            }
            
            // Get order items
            List<OrderItem> orderItems = orderService.getOrderItems(id);

            // Calculate order summary
            BigDecimal subtotal = BigDecimal.ZERO;
            for (OrderItem item : orderItems) {
                subtotal = subtotal.add(item.getPrice().multiply(new BigDecimal(item.getQuantity())));
            }
            List<Map<String, String>> variants_for_jsp = new ArrayList<>();

            for (OrderItem item : orderItems) {
                Product product = productServiece.getProductById(item.getProductId());
                if (product != null) {
                    variants_for_jsp = productServiece.getProductVariantById(product.getProductId());
                }
            }
            request.setAttribute("order", order);
            request.setAttribute("orderItems", orderItems);
            request.setAttribute("variant", variants_for_jsp);
            request.setAttribute("subtotal", subtotal);

            RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/order-detail.jsp");
            dispatcher.forward(request, response);
        } catch (NumberFormatException e) {
            HttpSession session = request.getSession();
            session.setAttribute("error", "Mã đơn hàng không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/admin/orders");
        }
    }

    private void updateOrderStatus(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException ,ServletException{
        int id = Integer.parseInt(request.getParameter("orderId"));
        String status = request.getParameter("status");
        String notes = request.getParameter("note");
        
        if (status == null || status.isEmpty()) {
            request.setAttribute("error", "Vui lòng chọn trạng thái đơn hàng");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/orders");
            dispatcher.forward(request, response);
            return;
        }
        
        Order order = orderService.getOrderById(id);
        if (order == null) {
            request.setAttribute("error", "Đơn hàng không tồn tại");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/orders");
            dispatcher.forward(request, response);
            return;
        }

        if (!isValidStatusTransition(order.getOrderStatus().toLowerCase(), status)) {
            request.setAttribute("error", "Không thể chuyển từ trạng thái " + order.getOrderStatus() + " sang " + status);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/orders");
            dispatcher.forward(request, response);
            return;
        }
        // Update order status
        order.setOrderStatus(status);
        if (notes != null && !notes.isEmpty()) {
            order.setNote(notes);
        }
        // If status is "cancelled", handle inventory
        if ("cancelled".equals(status)) {
            // Get order items
            List<OrderItem> orderItems = orderService.getOrderItems(id);
            updateProductQuantities(orderItems);
        }
        
        // Update order
        boolean success = orderService.updateOrder(order);
        
        HttpSession session = request.getSession();
        if (success) {
            session.setAttribute("message", "Trạng thái đơn hàng đã được cập nhật thành công");
        } else {
            session.setAttribute("error", "Có lỗi xảy ra khi cập nhật trạng thái đơn hàng");
        }
        // Forward to category list page
        RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/orders");
        dispatcher.forward(request, response);
    }

    private void updateProductQuantities(List<OrderItem> orderItems) {
        if (orderItems != null) {
            for (OrderItem item : orderItems) {
                if (item.getVariantId() != null) {
                    List<Map<String, String>> variants = productServiece.getProductVariantById(item.getProductId());
                    for (Map<String, String> variant : variants) {
                        if (variant.get("variant_id").equals(String.valueOf(item.getVariantId()))) {
                            int currentQuantity = Integer.parseInt(variant.get("quantity"));
                            int newQuantity = currentQuantity - item.getQuantity();
                            if (newQuantity >= 0) {
                                // Update variant quantity
                                productServiece.editProductVariant(
                                        item.getVariantId(),
                                        variant.get("size"),
                                        variant.get("color"),
                                        newQuantity
                                );
                            }
                            break;
                        }
                    }
                }
            }
        }
    }

    private boolean isValidStatusTransition(String currentStatus, String newStatus) {
        // Define valid status transitions
        switch (currentStatus) {
            case "pending":
                return newStatus.equals("confirmed") || newStatus.equals("cancelled");
            case "confirmed":
                return newStatus.equals("shipping") || newStatus.equals("cancelled");
            case "shipping":
                return newStatus.equals("completed") || newStatus.equals("cancelled");
            case "completed":
                return false;
            case "cancelled":
                return false;
            default:
                return false;
        }
    }

}
