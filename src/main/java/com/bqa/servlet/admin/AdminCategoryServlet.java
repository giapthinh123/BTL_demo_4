package com.bqa.servlet.admin;

import com.bqa.service.categoryService;
import com.bqa.service.productServiece;
import com.bqa.model.Category;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Objects;

/**
 * AdminCategoryServlet handles all category management operations for admin
 */
@WebServlet("/admin/categories/*")
public class AdminCategoryServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private categoryService categoryService;
    private productServiece productService;

    public void init() {
        categoryService = new categoryService();
        productService = new productServiece();
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
                case "/insert":
                    insertCategory(request, response);
                    break;
                case "/delete":
                    deleteCategory(request, response);
                    break;
                case "/update":
                    updateCategory(request, response);
                    break;
                default:
                    listCategories(request, response);
                    break;
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    private void listCategories(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        // Get pagination parameters
        int page = 1;
        int recordsPerPage = 10;

        if (request.getParameter("page") != null) {
            page = Integer.parseInt(request.getParameter("page"));
        }

        // Get categories with pagination and search
        List<Category> categories = categoryService.getCategoriesWithInfo((page - 1) * recordsPerPage, recordsPerPage);
        int totalCategories = categoryService.getAllCategories().size();
        int totalPages = (int) Math.ceil((double) totalCategories / recordsPerPage);

        // Set attributes for JSP
        request.setAttribute("categories", categories);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalCategories", totalCategories);

        // Get session messages and remove them after setting to request
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

        // Forward to category list page
        RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/category-list.jsp");
        dispatcher.forward(request, response);
    }

    private void insertCategory(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        // Get form data
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String parentIdStr = request.getParameter("parentId");
        boolean active = "on".equals(request.getParameter("status"));

        int status_seen;
        if(active){
            status_seen = 1;
        }
        else {
            status_seen = 2;
        }

        Category category = new Category();
        category.setName(name);
        category.setParentId(parentIdStr.isEmpty() ? null : Integer.parseInt(parentIdStr));
        category.setDescription(description);
        category.setStatus(status_seen);


        boolean success = categoryService.addCategory(category);

        if(success){
            request.setAttribute("message", "Danh mục đã được thêm thành công");
        }
        else {
            request.setAttribute("error", "Có lỗi xảy ra khi thêm danh mục");
        }
        RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/categories");
        dispatcher.forward(request, response);
    }

    private void updateCategory(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        String categoryId  = request.getParameter("categoryId");
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String parentIdStr = request.getParameter("parentId");
        boolean active = "on".equals(request.getParameter("status"));

        int status_seen;
        if(active){
            status_seen = 1;
        }
        else {
            status_seen = 2;
        }

        Category category_edit = new Category();
        category_edit.setCategoryId(Integer.parseInt(categoryId));
        category_edit.setName(name);
        category_edit.setDescription(description);
        category_edit.setStatus(status_seen);
        category_edit.setParentId(Integer.parseInt(parentIdStr));
        // kiem tra ko dc la danh muc con cua chinh no
        if (category_edit.getCategoryId() == Integer.parseInt(parentIdStr)) {
            request.setAttribute("error", "Danh mục không thể là danh mục cha của chính nó");

            RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/categories");
            dispatcher.forward(request, response);
            return;
        }
        boolean success = categoryService.updateCategory(category_edit);

        if (success) {
            request.setAttribute("message", "Danh mục đã được cập nhật thành công");
            response.sendRedirect(request.getContextPath() + "/admin/categories");
        } else {

            request.setAttribute("error", "Có lỗi xảy ra khi cập nhật danh mục");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/categories");
            dispatcher.forward(request, response);
            }
    }

    private void deleteCategory(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        int id = Integer.parseInt(request.getParameter("categoryId"));

        // Check if category exists
        Category category = categoryService.getCategoryById(id);
        if (category == null) {
            request.setAttribute("error", "Danh mục không tồn tại");
            response.sendRedirect(request.getContextPath() + "/admin/categories");
            return;
        }

        // Check if category has child categories
        if (categoryService.hasChildCategories(id)) {
            request.setAttribute("error", "Không thể xóa danh mục có danh mục con. Vui lòng xóa các danh mục con trước.");
            response.sendRedirect(request.getContextPath() + "/admin/categories");
            return;
        }

        // Check if category has products
        if (categoryService.hasProductsInCategory(id)) {
            request.setAttribute("error", "Không thể xóa danh mục có sản phẩm. Vui lòng xóa hoặc di chuyển các sản phẩm trước.");
            response.sendRedirect(request.getContextPath() + "/admin/categories");
            return;
        }

        // Delete category
        boolean success = categoryService.deleteCategory(id);

        if (success) {
            request.setAttribute("message", "Danh mục đã được xoá thành công");
        } else {
            request.setAttribute("error", "Có lỗi xảy ra khi xóa danh mục");
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/categories");
        dispatcher.forward(request, response);
    }
}
