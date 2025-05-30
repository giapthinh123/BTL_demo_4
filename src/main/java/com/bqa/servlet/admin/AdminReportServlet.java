package com.bqa.servlet.admin;

import com.bqa.model.Category;
import com.bqa.model.Order;
import com.bqa.model.Product;
import com.bqa.service.categoryService;
import com.bqa.service.OrderService;
import com.bqa.service.productServiece;
import com.bqa.service.UserService;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * AdminReportServlet handles all reporting and analytics operations for admin
 */
@WebServlet("/admin/reports/*")
public class AdminReportServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private OrderService orderService;
    private productServiece productServiece;
    private categoryService categoryService;
    private UserService userService;

    public void init() {
        orderService = new OrderService();
        productServiece = new productServiece();
        categoryService = new categoryService();
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
            action = "/dashboard";
        }

        try {
            switch (action) {
                default:
                    showDashboard(request, response);
                    break;
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        // Get time range parameter
        String timeRange = request.getParameter("timeRange");
        if (timeRange == null) {
            timeRange = "day"; // Default to today
        }

        Calendar cal = Calendar.getInstance();
        Date endDate = cal.getTime();
        Date startDate = null;

        // Calculate start date based on time range
        switch (timeRange) {
            case "day":
                cal.set(Calendar.HOUR_OF_DAY, 0);
                cal.set(Calendar.MINUTE, 0);
                cal.set(Calendar.SECOND, 0);
                startDate = cal.getTime();
                break;
            case "week":
                cal.add(Calendar.DAY_OF_MONTH, -7);
                startDate = cal.getTime();
                break;
            case "month":
                cal.set(Calendar.DAY_OF_MONTH, 1);
                cal.set(Calendar.HOUR_OF_DAY, 0);
                cal.set(Calendar.MINUTE, 0);
                cal.set(Calendar.SECOND, 0);
                startDate = cal.getTime();
                break;
            case "quarter":
                cal.set(Calendar.DAY_OF_MONTH, 1);
                cal.set(Calendar.HOUR_OF_DAY, 0);
                cal.set(Calendar.MINUTE, 0);
                cal.set(Calendar.SECOND, 0);
                int currentMonth = cal.get(Calendar.MONTH);
                int quarterStartMonth = (currentMonth / 3) * 3;
                cal.set(Calendar.MONTH, quarterStartMonth);
                startDate = cal.getTime();
                break;
            case "year":
                cal.set(Calendar.DAY_OF_YEAR, 1);
                cal.set(Calendar.HOUR_OF_DAY, 0);
                cal.set(Calendar.MINUTE, 0);
                cal.set(Calendar.SECOND, 0);
                startDate = cal.getTime();
                break;
            default:
                cal.add(Calendar.DAY_OF_MONTH, -30);
                startDate = cal.getTime();
                break;
        }

        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        String startDateStr = dateFormat.format(startDate);
        String endDateStr = dateFormat.format(endDate);

        double totalRevenue = orderService.getTotalRevenue();
        int totalOrders = orderService.getAllOrders().size();
        int totalCustomers = userService.getActiveCustomers();
        int totalProducts = productServiece.getTotalProducts();

        List<Map<String, Object>> salesData = orderService.getSalesData(
            new java.sql.Date(startDate.getTime()),
            new java.sql.Date(endDate.getTime())
        );
        System.out.println("Total sales data: " + salesData);

        request.setAttribute("timeRange", timeRange);
        request.setAttribute("startDate", startDateStr);
        request.setAttribute("endDate", endDateStr);
        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("totalCustomers", totalCustomers);
        request.setAttribute("totalProducts", totalProducts);
        request.setAttribute("salesData", salesData);
        // Forward to dashboard page
        RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/dashboard.jsp");
        dispatcher.forward(request, response);
    }
}
