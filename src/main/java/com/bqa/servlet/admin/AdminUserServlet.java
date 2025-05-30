package com.bqa.servlet.admin;

import com.bqa.model.User;
import com.bqa.service.UserService;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import javax.management.relation.Role;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * AdminUserServlet handles all user management operations for admin
 */
@WebServlet("/admin/users/*")
public class AdminUserServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserService userService;

    public void init() {
        userService = new UserService();
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
                case "/new":
                    showNewForm(request, response);
                    break;
                case "/save":
                    insertUser(request, response);
                    break;
                case "/delete":
                    deleteUser(request, response);
                    break;
                case "/edit":
                    showEditForm(request, response);
                    break;
                case "/update":
                    updateUser(request, response);
                    break;
                default:
                    listUsers(request, response);
                    break;
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    private void listUsers(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        String search = request.getParameter("search");
        String role = request.getParameter("role");
        String status = request.getParameter("status");
        
        int page = 1;
        int recordsPerPage = 10;
        
        if (request.getParameter("page") != null) {
            page = Integer.parseInt(request.getParameter("page"));
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
        List<User> users = userService.getAllUsers(search, role, status, (page - 1) * recordsPerPage, recordsPerPage);
        int totalUsers = userService.getTotalUsers(search, role, status);
        int totalPages = (int) Math.ceil((double) totalUsers / recordsPerPage);

        int customerCount = userService.getTotalUsers(search, "CUSTOMER", "1");
        int adminCount = userService.getTotalUsers(search, "ADMIN", "1");

        request.setAttribute("users", users);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("search", search);
        request.setAttribute("role", role);
        request.setAttribute("status", status);
        request.setAttribute("customerCount", customerCount);
        request.setAttribute("adminCount", adminCount);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/user-list.jsp");
        dispatcher.forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = new User();
        List<String> roles = new ArrayList<String>();

        roles.add("ADMIN");
        roles.add("CUSTOMER");

        request.setAttribute("roles", roles);
        request.setAttribute("user", user);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/user-form.jsp");
        dispatcher.forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        User existingUser = userService.getUserById(id);
        List<String> roles = new ArrayList<String>();

        roles.add("ADMIN");
        roles.add("CUSTOMER");
        request.setAttribute("roles", roles);
        request.setAttribute("user", existingUser);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/user-form.jsp");
        dispatcher.forward(request, response);
    }

    private void insertUser(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        // Get form data
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String role = request.getParameter("role");
        boolean active = "on".equals(request.getParameter("active"));
        
        // Validate data
        if (username == null || username.isEmpty() || password == null || password.isEmpty() || 
            email == null || email.isEmpty() || fullName == null || fullName.isEmpty()) {
            request.setAttribute("error", "Vui lòng điền đầy đủ thông tin bắt buộc");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/user-form.jsp");
            dispatcher.forward(request, response);
            return;
        }
        
        // Check if username or email already exists
        if (userService.isUsernameExists(username) || userService.isEmailExists(email)) {
            request.setAttribute("error", "Tên đăng nhập hoặc email đã tồn tại");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/user-form.jsp");
            dispatcher.forward(request, response);
            return;
        }
        
        // Create new user
        User newUser = new User();
        newUser.setUsername(username);
        newUser.setPassword(password); // Password should be hashed in service/DAO layer
        newUser.setEmail(email);
        newUser.setFullName(fullName);
        newUser.setPhone(phone);
        newUser.setAddress(address);
        newUser.setRole(role);
        newUser.setActive(active);
        
        // Insert user
        boolean success = userService.insertUser(newUser);
        
        if (success) {
            // Set success message
            HttpSession session = request.getSession();
            session.setAttribute("message", "Người dùng đã được tạo thành công");
            response.sendRedirect(request.getContextPath() + "/admin/users");
        } else {
            request.setAttribute("error", "Có lỗi xảy ra khi tạo người dùng");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/user-form.jsp");
            dispatcher.forward(request, response);
        }
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
            
            RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/user-form.jsp");
            dispatcher.forward(request, response);
            return;
        }
        
        // Check if email already exists for other users
        if (userService.isEmailExistsForOtherUser(email, id)) {
            request.setAttribute("error", "Email đã tồn tại cho người dùng khác");
            
            // Get existing user to repopulate form
            User existingUser = userService.getUserById(id);
            request.setAttribute("user", existingUser);
            
            RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/user-form.jsp");
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
        user.setRole(role);
        user.setActive(active);
        
        // Update user
        boolean success = userService.updateUser(user);
        
        if (success) {
            request.setAttribute("message", "Người dùng đã được cập nhật thành công");
            response.sendRedirect(request.getContextPath() + "/admin/users");
        } else {
            request.setAttribute("error", "Có lỗi xảy ra khi cập nhật người dùng");
            request.setAttribute("user", user);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/user-form.jsp");
            dispatcher.forward(request, response);
        }
    }

    private void deleteUser(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("userId"));
        
        // Check if user exists
        User user = userService.getUserById(id);
        if (user == null) {
            HttpSession session = request.getSession();
            session.setAttribute("error", "Người dùng không tồn tại");
            response.sendRedirect(request.getContextPath() + "/admin/users");
            return;
        }
        
        // Delete user
        boolean success = userService.deleteUser(id);
        
        HttpSession session = request.getSession();
        if (success) {
            session.setAttribute("message", "Người dùng đã được xóa thành công");
        } else {
            session.setAttribute("error", "Có lỗi xảy ra khi xóa người dùng");
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/users");
    }
}
