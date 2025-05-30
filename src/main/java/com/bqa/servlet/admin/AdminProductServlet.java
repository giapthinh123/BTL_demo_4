package com.bqa.servlet.admin;

import com.bqa.model.Category;
import com.bqa.model.Product;
import com.bqa.service.categoryService;
import com.bqa.service.productServiece;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.*;
import java.util.stream.Collectors;

@WebServlet("/admin/products/*")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1 MB
    maxFileSize = 1024 * 1024 * 10,  // 10 MB
    maxRequestSize = 1024 * 1024 * 15 // 15 MB
)
public class AdminProductServlet extends HttpServlet {
    private productServiece  productServiece;
    private categoryService  categoryService;
    public AdminProductServlet() {
        productServiece = new productServiece();
        categoryService = new categoryService();
    }
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
    protected  void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getPathInfo();
        try {
            if (action == null) {
                action = "/list"; // Default action
            }
//        try { // This try is already present
            switch (action) {
                case "/new":
                    showNewForm(request, response);
                    break;
                case "/save":
                    insertProduct(request, response);
                    break;
                case "/delete":
                    deleteProduct(request, response);
                    break;
                case "/saveEdit":
                    EditProduct(request, response);
                    break;
                case "/edit":
                    viewEditProduct(request, response);
                    break;
                case "/list":
                default:
                    listProducts(request, response);
                    break;
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }
    private void listProducts(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        // Get search parameters
        String search = request.getParameter("search");
        String category = request.getParameter("category");
        String status = request.getParameter("status");

        int status_seen = -1;
        if(Objects.equals(status, "active")){
            status_seen = 1;
        }
        else if(Objects.equals(status, "inactive")){
            status_seen = 0;
        }

        int page = 1;
        int recordsPerPage = 10;

        if (request.getParameter("page") != null) {
            page = Integer.parseInt(request.getParameter("page"));
        }

        List<Product> products = productServiece.getAllProducts(search, category, status_seen,(page - 1) * recordsPerPage, recordsPerPage);
        Map<Integer, String> categoryMap = new HashMap<>();

        for (Category c : categoryService.getAllCategories()) {
            categoryMap.put(c.getCategoryId(), c.getName());
        }

        for (Product p : products) {
            p.setStock(productServiece.getallVacantProductsWithid(p.getProductId()));
        }

        int totalProducts = productServiece.getTotalProducts(search, category, status_seen);

        int totalPages = (int) Math.ceil((double) totalProducts / recordsPerPage);

        List<Category> categories = categoryService.getAllCategories();

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

        request.setAttribute("products", products);
        request.setAttribute("categoryMap", categoryMap);
        request.setAttribute("categories", categories);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("category", category);
        request.setAttribute("status", status);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/adminProducts.jsp");
        dispatcher.forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        // Get all categories for dropdown
        List<Category> categories = categoryService.getAllCategories();
        request.setAttribute("categories", categories);
        Product product = new Product();

        request.setAttribute("product", product);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/product-form.jsp");
        dispatcher.forward(request, response);
    }

    private void insertProduct(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        // Get form data
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String priceStr = request.getParameter("price");
        String categoryIdStr = request.getParameter("categoryId");
        String active = request.getParameter("active");
        int status = Integer.parseInt(String.valueOf(Objects.equals(active, "on") ? 1 : 0));
        int indexProductnew = productServiece.getindexProduct() + 1 ;

        // Handle file upload
        String thumbnailPath = null;
        Part thumbnailPart = request.getPart("thumbnailFile");

        if (thumbnailPart != null && thumbnailPart.getSize() > 0) {
            // Get the file name
            String fileName = System.currentTimeMillis() + "_" + getSubmittedFileName(thumbnailPart);

            String uploadPath = getServletContext().getRealPath("/uploads");
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdir();
            }

            // Save the file
            String filePath = uploadPath + File.separator + fileName;
            thumbnailPart.write(filePath);

            // Save the relative path to database
            thumbnailPath = "uploads/" + fileName;
        }
        Collection<Part> fileParts = request.getParts().stream()
                .filter(part -> "imageFiles".equals(part.getName()))
                .toList();

        List<Map<String, String>> variants = new ArrayList<>();
        int index = 0;

        while (true) {
            String size = request.getParameter("variants[" + index + "].size");
            String color = request.getParameter("variants[" + index + "].color");
            String stock = request.getParameter("variants[" + index + "].quantity");

            if (size == null) break; // No more variants

            Map<String, String> variant = new HashMap<>();
            variant.put("size", size);
            variant.put("color", color);
            variant.put("stock", stock);
            variants.add(variant);
            index++;
        }

        // Parse numeric values
        double price = Double.parseDouble(priceStr);
        int categoryId = Integer.parseInt(categoryIdStr);

        // Create new product
        Product product = new Product();
        product.setName(name);
        product.setDescription(description);
        product.setPrice(new BigDecimal(price));
        product.setCategoryId(categoryId);
        product.setThumbnail(thumbnailPath);
        product.setStatus(status);

        // Insert product
        productServiece.addProduct(product);

        for (Part filePart : fileParts) {
            String fileName = System.currentTimeMillis() + "_" + getSubmittedFileName(filePart);
            String uploadPath = getServletContext().getRealPath("/uploads");
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdir();
            }
            String filePath = uploadPath + File.separator + fileName;
            filePart.write(filePath);
            String image_path = "uploads/" + fileName;
            productServiece.addImageProduct(indexProductnew, image_path);
        }

        for (Map<String, String> variant : variants) {
            productServiece.addProductVariant(indexProductnew, variant.get("size"), variant.get("color"), Integer.parseInt(variant.get("stock")));
            System.out.println(variant);
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/products");
        dispatcher.forward(request, response);
    }

    private void viewEditProduct(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        String productId = request.getParameter("id");
        Product product = productServiece.getProductById(Integer.parseInt(productId));
        List<Category> categories = categoryService.getAllCategories();
        List<Map<String, String>> variantIds = new ArrayList<>();
        variantIds = productServiece.getProductVariantById(Integer.parseInt(productId));
        List<String> image_url = productServiece.getImageProduct(Integer.parseInt(productId));

        
        request.setAttribute("product", product);
        request.setAttribute("categories", categories);
        request.setAttribute("variants", variantIds);
        request.setAttribute("image_url", image_url);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/product-form.jsp");
        dispatcher.forward(request, response);
    }

    private void EditProduct(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        String productIdStr = request.getParameter("productId");
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String priceStr = request.getParameter("price");
        String categoryIdStr = request.getParameter("categoryId");
        String active = request.getParameter("active");
        String oldThumbnail = request.getParameter("oldThumbnail");

        String[] oldImages = request.getParameterValues("oldImages");

        Collection<Part> fileParts = request.getParts().stream()
                .filter(part -> "imageFiles".equals(part.getName()) && part.getSize() > 0)
                .collect(Collectors.toList());

        String thumbnailPath = null;
        try {
            Part thumbnailPart = request.getPart("thumbnailFile");
            if (thumbnailPart != null && thumbnailPart.getSize() > 0) {
                // Get the file name
                String fileName = System.currentTimeMillis() + "_" + getSubmittedFileName(thumbnailPart);

                // Create upload directory if it doesn't exist
                String uploadPath = getServletContext().getRealPath("/uploads");
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdir();
                }

                // Save the file
                String filePath = uploadPath + File.separator + fileName;
                thumbnailPart.write(filePath);

                // Save the relative path to database
                thumbnailPath = "uploads/" + fileName;
            }
        } catch (Exception e) {
            System.out.println("Error uploading file: " + e.getMessage());
            e.printStackTrace();
        }

        // Get variants data
        List<Map<String, String>> variants_edit = new ArrayList<>();
        int index = 0;
        while (true) {
            String variantId = request.getParameter("variants[" + index + "].id");
            String size = request.getParameter("variants[" + index + "].size");
            String color = request.getParameter("variants[" + index + "].color");
            String stock = request.getParameter("variants[" + index + "].quantity");

            if (variantId == null){
                break;
            }

            Map<String, String> variant = new HashMap<>();
            variant.put("varianId", variantId);
            variant.put("size", size);
            variant.put("color", color);
            variant.put("stock", stock);
            variants_edit.add(variant);
            index++;
        }

        double price = Double.parseDouble(priceStr);
        int categoryId = Integer.parseInt(categoryIdStr);
        int producId = Integer.parseInt(productIdStr);
        int status = Integer.parseInt(String.valueOf(Objects.equals(active, "on") ? 1 : 0));
        List<String> image_url = productServiece.getImageProduct(producId);

        // Create new product
        Product product = new Product();
        product.setProductId(producId);
        product.setName(name);
        product.setDescription(description);
        product.setPrice(new BigDecimal(price));
        product.setCategoryId(categoryId);
        product.setStatus(status);
        List<String> variantIds = productServiece.getallVariantId(producId);

        for (String image : image_url) {
            if(!Arrays.asList(oldImages).contains(image)){
                productServiece.deleteImageProduct(producId, image);
            }
        }

        for(String variant : variantIds){
            boolean found = false;
            for(Map<String, String> variant_edit : variants_edit) {
                if(variant_edit.get("varianId").equals(variant)) {
                    found = true;
                    break;
                }
            }
            if(!found) {
                productServiece.deleteProductVariant(Integer.parseInt(variant));
            }
        }


        
        for(Part filePart : fileParts){
            String fileName =  System.currentTimeMillis() + "_" + getSubmittedFileName(filePart);
            String uploadPath = getServletContext().getRealPath("/uploads");
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdir();
            }
            String filePath = uploadPath + File.separator + fileName;
            filePart.write(filePath);String image_path = "uploads/" + fileName;
            productServiece.addImageProduct(producId, image_path);
        }

        if(thumbnailPath == null){
            product.setThumbnail(oldThumbnail);
        }
        else {
            product.setThumbnail(thumbnailPath);
        }

        for (Map<String, String> variant : variants_edit) {
            if (variant.get("varianId").equals("-1")){
                //new vari
                productServiece.addProductVariant(producId, variant.get("size"), variant.get("color"), Integer.parseInt(variant.get("stock")));
            }
            else {
                //edit vari
                productServiece.editProductVariant(Integer.parseInt(variant.get("varianId")),
                        variant.get("size"),
                        variant.get("color"),
                        Integer.parseInt(variant.get("stock")));
            }
        }
        request.setAttribute("message", "Sản phẩm đã được cập nhật thành công");
        productServiece.editProduct(product);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/products");
        dispatcher.forward(request, response);
    }

    private void deleteProduct(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        // Get all categories for dropdown
        String productId = request.getParameter("productId");
        productServiece.deleteProduct(Integer.parseInt(productId));
        request.setAttribute("message", "Sản phẩm đã được xoá thành công");

        RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/products");
        dispatcher.forward(request, response);
    }
    // Helper method to get the submitted file name
    private String getSubmittedFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] tokens = contentDisp.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return "";
    }
}
