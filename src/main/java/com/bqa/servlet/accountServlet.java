package com.bqa.servlet;

import com.bqa.model.Order;
import com.bqa.model.User;
import com.bqa.service.OrderService;
import com.bqa.service.UserService;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@WebServlet("/account/*")
public class accountServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserService userService;
    private OrderService orderService;
    public void init() {
        userService = new UserService();
        orderService = new OrderService();
    }
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String action = request.getPathInfo();
            if (action == null) {
                action = "/profile";
            }

            switch (action) {
                case "/update":
                    updateUser(request, response);
                    break;
                case "/orders":
                    order(request, response);
                    break;
                default:
                    profile(request, response);
                    break;
            }
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }

    private void profile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException{

            RequestDispatcher dispatcher = request.getRequestDispatcher("/profile-user.jsp");
            dispatcher.forward(request, response);
    }

    private void updateUser(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        // Get form data
        int id = Integer.parseInt(request.getParameter("userId"));
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String role = request.getParameter("role");
        boolean active = "on".equals(request.getParameter("active"));

        // Validate data
        if (username == null || username.isEmpty() || email == null || email.isEmpty() || 
            fullName == null || fullName.isEmpty()) {
            request.setAttribute("error", "Vui lòng điền đầy đủ thông tin bắt buộc");
            
            // Get existing user to repopulate form
            User existingUser = userService.getUserById(id);
            request.setAttribute("user", existingUser);
            
            RequestDispatcher dispatcher = request.getRequestDispatcher("/account/profile");
            dispatcher.forward(request, response);
            return;
        }

        // Check if email already exists for other users
        if (userService.isEmailExistsForOtherUser(email, id)) {
            request.setAttribute("error", "Email đã tồn tại cho người dùng khác");
            
            // Get existing user to repopulate form
            User existingUser = userService.getUserById(id);
            request.setAttribute("user", existingUser);
            
            RequestDispatcher dispatcher = request.getRequestDispatcher("/account/profile");
            dispatcher.forward(request, response);
            return;
        }

        // Get existing user
        User user = userService.getUserById(id);

        // Update user data
        user.setUsername(username);
        // Only update password if provided
        if (password != null && !password.isEmpty()) {
            user.setPassword(password); // Password should be hashed in service/DAO layer
        }
        user.setEmail(email);
        user.setFullName(fullName);
        user.setPhone(phone);
        user.setAddress(address);
        user.setRole("CUSTOMER");
        user.setActive(active);

        // Update user
        boolean success = userService.updateUser(user);

        if (success) {
            request.setAttribute("message", "Người dùng đã được cập nhật thành công");
            request.setAttribute("user", user);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/account/profile");
            dispatcher.forward(request, response);
        } else {
            request.setAttribute("error", "Có lỗi xảy ra khi cập nhật người dùng");
            request.setAttribute("user", user);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/account/profile");
            dispatcher.forward(request, response);
        }
    }

    private void order(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        int userId = user.getUserId();
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

        List<Order> orders = orderService.getAllOrders(userId,search, status, startDate, endDate, paymentStatus,
                (page - 1) * recordsPerPage, recordsPerPage);

        int totalOrders = orderService.getTotalOrders(userId,search, status, startDate, endDate, paymentStatus);
        int totalPages = (int) Math.ceil((double) totalOrders / recordsPerPage);

        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", page);
        request.setAttribute("orders", orders);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/order-user.jsp");
        dispatcher.forward(request, response);
    }
}
