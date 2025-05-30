package com.bqa.servlet;

import com.bqa.model.Category;
import com.bqa.model.Product;
import com.bqa.model.reviews;
import com.bqa.service.UserService;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.bqa.service.productServiece;
import com.bqa.service.categoryService;
import java.io.IOException;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.*;

@WebServlet("/products/*")
public class ProductServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private productServiece productServiece;
    private categoryService categoryService;
    private UserService userService;

    public void init() {
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
            action = "/list";
        }

        try {
            switch (action) {
                case "/detail":
                case "/view":
                    viewProduct(request, response);
                    break;
                case "/category":
                    listProductsByCategory(request, response);
                    break;
               case "/review":
                   addReview(request, response);
                   break;
                default:
                    listProducts(request, response);
                    break;
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }
    private void addReview(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        int productId = Integer.parseInt(request.getParameter("productId"));
        int userId = Integer.parseInt(request.getParameter("userid"));
        int rating = Integer.parseInt(request.getParameter("rating"));
        String comment = request.getParameter("comment");
        String date = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
        int status = 1;
        reviews review = new reviews(0, productId, userId, rating, comment, date, status);
        productServiece.addReview(review);
        response.sendRedirect(request.getContextPath() + "/products/detail?id=" + productId);
    }
    
    private void viewProduct(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        int id = Integer.parseInt(request.getParameter("id"));
        List<Category> categories_nam = categoryService.getAllCategoriesByParentIdWithOn(1);

        List<Category> categories_nu = categoryService.getAllCategoriesByParentIdWithOn(2);

        List<Category> categories_treem = categoryService.getAllCategoriesByParentIdWithOn(3);
        List<reviews> reviews = productServiece.getReviewsByProductId(id);
        for (reviews review : reviews) {
            review.setUsername(userService.getUserById(review.getUserid()).getUsername());
        }
        Product product = productServiece.getProductById(id);
        List<Map<String, String>> variant = new ArrayList<>();
        variant = productServiece.getProductVariantById(id);

        product.setStock(productServiece.getallVacantProductsWithid(product.getProductId()));

        List<String> image_url = productServiece.getImageProduct(id);

        request.setAttribute("product", product);
        request.setAttribute("variants", variant);
        request.setAttribute("image_url", image_url);
        request.setAttribute("reviews", reviews);
        request.setAttribute("categories_nam", categories_nam);
        request.setAttribute("categories_nu", categories_nu);
        request.setAttribute("categories_treem", categories_treem);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/product-detail.jsp");
        dispatcher.forward(request, response);
    }

    private void listProducts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        List<Category> categories_nam = categoryService.getAllCategoriesByParentIdWithOn(1);

        List<Category> categories_nu = categoryService.getAllCategoriesByParentIdWithOn(2);

        List<Category> categories_treem = categoryService.getAllCategoriesByParentIdWithOn(3);
        int page = 1;
        int recordsPerPage = 12;

        if (request.getParameter("page") != null) {
            page = Integer.parseInt(request.getParameter("page"));
        }

        List<Product> products = productServiece.getAllProductsWithOn((page - 1) * recordsPerPage, recordsPerPage);

        int totalProducts = productServiece.getTotalProducts();
        int totalPages = (int) Math.ceil((double) totalProducts / recordsPerPage);

        request.setAttribute("products", products);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("categories_nam", categories_nam);
        request.setAttribute("categories_nu", categories_nu);
        request.setAttribute("categories_treem", categories_treem);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/index.jsp");
        dispatcher.forward(request, response);
    }

    private void listProductsByCategory(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        String search = request.getParameter("search");
        String categoryId = request.getParameter("category");
        String priceRange = request.getParameter("priceRange");
        String size = request.getParameter("size");
        String color = request.getParameter("color");

        if (color != null) {
            switch (color.toLowerCase()) {
                case "red":
                    color = "đỏ";
                    break;
                case "blue": 
                    color = "xanh dương";
                    break;
                case "green":
                    color = "xanh lá";
                    break;
                case "yellow":
                    color = "vàng";
                    break;
                case "black":
                    color = "đen";
                    break;
                case "white":
                    color = "trắng";
                    break;
                case "pink":
                    color = "hồng";
                    break;
                case "purple":
                    color = "tím";
                    break;
                case "orange":
                    color = "cam";
                    break;
                case "brown":
                    color = "nâu";
                    break;
                case "gray":
                    color = "xám";
                    break;
            }
        }
        List<Category> categories_nam = categoryService.getAllCategoriesByParentIdWithOn(1);

        List<Category> categories_nu = categoryService.getAllCategoriesByParentIdWithOn(2);

        List<Category> categories_treem = categoryService.getAllCategoriesByParentIdWithOn(3);
        if(Objects.equals(categoryId, "")){
            categoryId = null;
        }
        if (Objects.equals(priceRange, "")){
            priceRange = null;
        }
        // Get pagination parameters
        int page = 1;
        int recordsPerPage = 12; // Show more products per page for customers

        if (request.getParameter("page") != null) {
            page = Integer.parseInt(request.getParameter("page"));
        }
        Double minPrice = null;
        Double maxPrice = null;
        if (priceRange != null) {
            if (!priceRange.isEmpty()) {
                String[] prices = priceRange.split("-");
                if (prices.length == 2) {
                    try {
                        minPrice = Double.parseDouble(prices[0]);
                        maxPrice = Double.parseDouble(prices[1]);
                    } catch (NumberFormatException e) {
                        // Invalid price range, ignore
                    }
                }
            }
        }



        List<Product> products = productServiece.getAllProductsWithOn(search, categoryId, minPrice,maxPrice ,size ,color ,(page - 1) * recordsPerPage, recordsPerPage);

        List<Category> categories = categoryService.getAllCategoriesWithOn();

        int totalProducts = productServiece.getTotalProductsWithOn(search,categoryId);

        int totalPages = (int) Math.ceil((double) totalProducts / recordsPerPage);

        request.setAttribute("products", products);
        request.setAttribute("categories", categories);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("search", search);
        request.setAttribute("categories_nam", categories_nam);
        request.setAttribute("categories_nu", categories_nu);
        request.setAttribute("categories_treem", categories_treem);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/product-list.jsp");
        dispatcher.forward(request, response);
    }
}