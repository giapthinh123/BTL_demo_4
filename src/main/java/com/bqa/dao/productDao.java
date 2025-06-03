package com.bqa.dao;

import com.bqa.model.Product;
import com.bqa.util.DBconn;
import com.bqa.model.reviews;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

public class productDao {

    public List<Product> getAllProducts(String search, String category, int status, int offset, int limit) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Product> products = new ArrayList<>();

        try {
            conn = DBconn.getConnection();
            StringBuilder sql = new StringBuilder("SELECT * FROM products WHERE 1=1");
            List<Object> params = new ArrayList<>();

            if (search != null && !search.isEmpty()) {
                sql.append(" AND (name LIKE ? OR description LIKE ?)");
                params.add("%" + search + "%");
                params.add("%" + search + "%");
            }

            if (category != null && !category.isEmpty()) {
                sql.append(" AND category_id = ?");
                params.add(Integer.parseInt(category));
            }

            if(status != -1){
                sql.append(" AND status = ?");
                params.add(status);
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
                Product product = mapResultSetToProduct(rs);
                products.add(product);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, rs);
        }

        return products;
    }

    public List<Product> getAllProducts() {
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        List<Product> products = new ArrayList<>();

        try {
            conn = DBconn.getConnection();
            stmt = conn.createStatement();
            String sql = "SELECT * FROM products ORDER BY product_id";
            rs = stmt.executeQuery(sql);

            while (rs.next()) {
                Product product = mapResultSetToProduct(rs);
                products.add(product);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, rs);
        }

        return products;
    }

    public List<Product> getAllProductsWithOn(String search, String category,Double minPrice, Double maxPrice, String size,String color ,int offset, int limit) {
        List<Product> products = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT DISTINCT p.* FROM products p ");
        List<Object> params = new ArrayList<>();

        // Join with product_variants if color or size filter is applied
        if ((color != null && !color.isEmpty()) || (size != null && !size.isEmpty())) {
            sql.append(" JOIN product_variants pv ON p.product_id = pv.product_id ");
        }

        sql.append(" WHERE p.status = 1 "); // Active products only

        if (search != null && !search.isEmpty()) {
            sql.append(" AND (p.name LIKE ? OR p.description LIKE ?) ");
            params.add("%" + search + "%");
            params.add("%" + search + "%");
        }
        if (category != null) {
            sql.append(" AND p.category_id = ? ");
            params.add(category);
        }
        if (minPrice != null) {
            sql.append(" AND p.price >= ? ");
            params.add(minPrice);
        }
        if (maxPrice != null) {
            sql.append(" AND p.price <= ? ");
            params.add(maxPrice);
        }
        if (color != null && !color.isEmpty()) {
            sql.append(" AND pv.color = ? ");
            params.add(color);
        }
        if (size != null && !size.isEmpty()) {
            sql.append(" AND pv.size = ? ");
            params.add(size);
        }

        sql.append(" LIMIT ? OFFSET ? ");
        params.add(limit);
        params.add(offset);

        try (Connection conn = DBconn.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                products.add(mapResultSetToProduct(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }

    public List<Product> getAllProductsWithOn(int offset, int limit) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Product> products = new ArrayList<>();

        try {
            conn = DBconn.getConnection();
            StringBuilder sql = new StringBuilder("SELECT * FROM products WHERE 1=1 AND status = 1");
            List<Object> params = new ArrayList<>();

            sql.append(" LIMIT ? OFFSET ?");
            params.add(limit);
            params.add(offset);

            stmt = conn.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }

            rs = stmt.executeQuery();
            while (rs.next()) {
                Product product = mapResultSetToProduct(rs);
                products.add(product);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, rs);
        }

        return products;
    }

    public int getTotalProductsWithOn(String search, String category) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        int total = 0;

        try {
            conn = DBconn.getConnection();
            StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM products WHERE 1=1 AND status = 1 ");
            List<Object> params = new ArrayList<>();

            if (search != null && !search.isEmpty()) {
                sql.append(" AND (name LIKE ? OR description LIKE ?)");
                params.add("%" + search + "%");
                params.add("%" + search + "%");
            }

            if (category != null && !category.isEmpty()) {
                sql.append(" AND category_id = ?");
                params.add(Integer.parseInt(category));
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

    public Product getProductById(int productId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        Product product = null;

        try {
            conn = DBconn.getConnection();
            String sql = "SELECT * FROM products WHERE product_id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, productId);
            rs = stmt.executeQuery();

            if (rs.next()) {
                product = mapResultSetToProduct(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, rs);
        }
        return product;
    }

    public int getTotalProducts(String search, String category, int status) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        int total = 0;

        try {
            conn = DBconn.getConnection();
            StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM products WHERE 1=1");
            List<Object> params = new ArrayList<>();

            if (search != null && !search.isEmpty()) {
                sql.append(" AND (name LIKE ? OR description LIKE ?)");
                params.add("%" + search + "%");
                params.add("%" + search + "%");
            }

            if (category != null && !category.isEmpty()) {
                sql.append(" AND category_id = ?");
                params.add(Integer.parseInt(category));
            }

            if(status != -1){
                sql.append(" AND status = ?");
                params.add(status);
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

    public int getTotalProducts() {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        int total = 0;

        try {
            conn = DBconn.getConnection();
            StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM products WHERE 1=1");
            List<Object> params = new ArrayList<>();

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

    public List<Map<String, String>> getProductVariantById(int productId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Map<String, String>> variants = new ArrayList<>();
        try {
            conn = DBconn.getConnection();
            String sql = "SELECT * FROM product_variants WHERE product_id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, productId);
            rs = stmt.executeQuery();
            while (rs.next()) {
                Map<String, String> variant = new HashMap<>();
                variant.put("variant_id", rs.getString("variant_id"));
                variant.put("size", rs.getString("size"));
                variant.put("color", rs.getString("color"));
                variant.put("quantity", String.valueOf(rs.getInt("quantity")));
                variants.add(variant);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, rs);
        }
        return variants;
    }

    public List<String> getallVariantId(int productId){
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<String> variantIds = new ArrayList<>();
        try {
            conn = DBconn.getConnection();
            String sql = "SELECT variant_id FROM product_variants WHERE product_id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, productId);
            rs = stmt.executeQuery();
            while (rs.next()) {
                variantIds.add(rs.getString("variant_id"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, rs);
        }
        return variantIds;
    }

    public int getallVacantProductsWithid(int id) {
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        int total = 0;
        try {
            conn = DBconn.getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery("SELECT product_id, SUM(quantity) AS total_quantity FROM product_variants WHERE product_id =" + id );
            while (rs.next()) {
                total = rs.getInt("total_quantity");
                return total;
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return total;
    }
    
    public int getindexProduct() {
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        int index = 0;
        String sql = "SELECT product_id FROM products ORDER BY product_id DESC LIMIT 1";
        try {
            conn = DBconn.getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);
            if (rs.next()) {
                index = rs.getInt(1);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return index;
    }

    public boolean addProduct(Product product) {
        Connection conn = null;
        PreparedStatement stmt = null;
        boolean success = false;

        try {
            conn = DBconn.getConnection();
            String sql = "INSERT INTO products (category_id, name, description, price, thumbnail, status, featured) VALUES (?, ?, ?, ?, ?, ?, ?)";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, product.getCategoryId());
            stmt.setString(2, product.getName());
            stmt.setString(3, product.getDescription());
            stmt.setBigDecimal(4, product.getPrice());
            stmt.setString(5, product.getThumbnail());
            stmt.setInt(6, product.getStatus());
            stmt.setInt(7, product.getFeatured());

            int rowsAffected = stmt.executeUpdate();
            success = (rowsAffected > 0);
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, null);
        }

        return success;
    }

    public boolean addProductVariant(int product_id, String size, String color, int stock) {
        Connection conn = null;
        PreparedStatement stmt = null;
        boolean success = false;

        try {
            conn = DBconn.getConnection();
            String sql = "INSERT INTO product_variants (product_id, size, color, quantity) VALUES (?, ?, ?, ?)";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, product_id);
            stmt.setString(2, size);
            stmt.setString(3, color);
            stmt.setInt(4, stock);

            int rowsAffected = stmt.executeUpdate();
            success = (rowsAffected > 0);
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, null);
        }

        return success;
    }

    public boolean editProduct(Product product) {
        Connection conn = null;
        PreparedStatement stmt = null;
        boolean success = false;
        try {
            conn = DBconn.getConnection();
            String sql = "UPDATE `products` SET `category_id`='"+ product.getCategoryId()
                            +"',`name`='"+ product.getName()
                            +"',`description`='"+ product.getDescription()
                            +"',`price`='"+product.getPrice()
                            +"',`thumbnail`='"+product.getThumbnail()
                            +"',`status`='"+product.getStatus()
                            +"',`featured`='"+product.getFeatured()
                            +"' WHERE product_id = "+ product.getProductId();
            stmt = conn.prepareStatement(sql);
            int rowsAffected = stmt.executeUpdate();
            success = (rowsAffected > 0);
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, null);
        }

        return success;
    }

    public boolean editProductVariant(int variant_id, String size, String color, int stock) {
        Connection conn = null;
        PreparedStatement stmt = null;
        boolean success = false;
        try {
            conn = DBconn.getConnection();

            String sql ="UPDATE product_variants SET size = ?,color= ? ,quantity= ? WHERE variant_id= ? ";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, size);
            stmt.setString(2, color);
            stmt.setInt(3, stock);
            stmt.setInt(4, variant_id);
            int rowsAffected = stmt.executeUpdate();
            success = (rowsAffected > 0);
        }
        catch (Exception e) {
            e.printStackTrace();
        }
        return  success;
    }

    public boolean addImageProduct(int product_id,String url) {
        boolean success = false;
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = DBconn.getConnection();
            String sql = "INSERT INTO product_images (product_id, image_url) VALUES (?, ?)";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, product_id);
            stmt.setString(2, url);
            int rowsAffected = stmt.executeUpdate();
            success = (rowsAffected > 0);
        }
        catch (Exception e) {
            e.printStackTrace();
        }
        return success;
    }

    public List<String> getImageProduct(int product_id) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<String> images = new ArrayList<>();
        try {
            conn = DBconn.getConnection();
            String sql = "SELECT image_url FROM product_images WHERE product_id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, product_id);
            rs = stmt.executeQuery();
            while (rs.next()) {
                images.add(rs.getString("image_url"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, rs);
        }
        return images;
    }

    private Product mapResultSetToProduct(ResultSet rs) throws SQLException {
        Product product = new Product();
        product.setProductId(rs.getInt("product_id"));
        product.setCategoryId(rs.getInt("category_id"));
        product.setName(rs.getString("name"));
        product.setDescription(rs.getString("description"));
        product.setPrice(rs.getBigDecimal("price"));
        product.setThumbnail(rs.getString("thumbnail"));
        product.setStatus(rs.getInt("status"));
        product.setFeatured(rs.getInt("featured"));
        return product;
    }

    public boolean deleteImageProduct(int product_id, String image_url) {
        Connection conn = null;
        PreparedStatement stmt = null;
        boolean success = false;
        try {
            conn = DBconn.getConnection();
            String sql = "DELETE FROM product_images WHERE product_id = ? AND image_url = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, product_id);
            stmt.setString(2, image_url);
            int rowsAffected = stmt.executeUpdate();
            success = (rowsAffected > 0);
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, null);
        }
        return success;
    }

    public boolean deleteProduct(int product_id) {
        Connection conn = null;
        PreparedStatement stmt = null;
        boolean success = false;
        
        try {
            conn = DBconn.getConnection();
            String sql = "DELETE FROM products WHERE product_id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, product_id);
            int rowsAffected = stmt.executeUpdate();
            success = (rowsAffected > 0);
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, null);
        }
        return success;
    }

    public boolean deleteProductVariant(int variant_id) {
        Connection conn = null;
        PreparedStatement stmt = null;
        boolean success = false;

        try {
            conn = DBconn.getConnection();
            String sql = "DELETE FROM product_variants WHERE variant_id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, variant_id);
            int rowsAffected = stmt.executeUpdate();
            success = (rowsAffected > 0);
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, null);
        }
        return success;
    }

    public List<Product> getProductsByCategory(int categoryId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Product> products = new ArrayList<>();

        try {
            conn = DBconn.getConnection();
            String sql = "SELECT * FROM products WHERE category_id = ? ORDER BY product_id";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, categoryId);
            rs = stmt.executeQuery();

            while (rs.next()) {
                Product product = mapResultSetToProduct(rs);
                products.add(product);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, rs);
        }

        return products;
    }
    
    public boolean addReview(reviews review) {
        Connection conn = null;
        PreparedStatement stmt = null;
        boolean success = false;
        try {
            conn = DBconn.getConnection();
            String sql = "INSERT INTO reviews (product_id, user_id, rating, comment, created_at, status) VALUES (?, ?, ?, ?, ?, ?)";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, review.getProductid());
            stmt.setInt(2, review.getUserid());
            stmt.setInt(3, review.getRating());
            stmt.setString(4, review.getComment());
            stmt.setString(5, review.getCreated_at());
            stmt.setInt(6, review.getStatus());
            int rowsAffected = stmt.executeUpdate();
            success = (rowsAffected > 0);
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, null);
        }
        return success;
    }

    public List<reviews> getReviewsByProductId(int productId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<reviews> reviews = new ArrayList<>();
        try {
            conn = DBconn.getConnection();
            String sql = "SELECT * FROM reviews WHERE product_id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, productId);
            rs = stmt.executeQuery();
            while (rs.next()) {
                reviews review = mapResultSetToReview(rs);
                reviews.add(review);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, rs);
        }
        return reviews;
    }

    private reviews mapResultSetToReview(ResultSet rs) throws SQLException {
        reviews review = new reviews();
        review.setReviewid(rs.getInt("review_id"));
        review.setProductid(rs.getInt("product_id"));
        review.setUserid(rs.getInt("user_id"));
        review.setRating(rs.getInt("rating"));
        review.setComment(rs.getString("comment"));
        review.setCreated_at(rs.getString("created_at"));
        review.setStatus(rs.getInt("status"));
        return review;
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
