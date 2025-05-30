package com.bqa.dao;

import com.bqa.model.Category;
import com.bqa.service.DBconn;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class categoryDao {

    public List<Category> getAllCategories() {
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        List<Category> categories = new ArrayList<>();

        try {
            conn = DBconn.getConnection();
            stmt = conn.createStatement();
            String sql = "SELECT * FROM categories ORDER BY category_id";
            rs = stmt.executeQuery(sql);

            while (rs.next()) {
                Category category = mapResultSetToCategory(rs);
                categories.add(category);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, rs);
        }

        return categories;
    }

    public List<Category> getAllCategoriesWithOn() {
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        List<Category> categories = new ArrayList<>();

        try {
            conn = DBconn.getConnection();
            stmt = conn.createStatement();
            String sql = "SELECT * FROM categories WHERE status = 1";
            rs = stmt.executeQuery(sql);

            while (rs.next()) {
                Category category = mapResultSetToCategory(rs);
                categories.add(category);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, rs);
        }

        return categories;
    }

    public List<Category> getAllCategoriesByParentIdWithOn(int parentId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Category> categories = new ArrayList<>();
        try {
            conn = DBconn.getConnection();
            String sql = "SELECT * FROM categories WHERE parent_id = ? AND status = 1";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, parentId);
            rs = stmt.executeQuery();
            while (rs.next()) {
                Category category = mapResultSetToCategory(rs);
                categories.add(category);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, rs);
        }
        return categories;
    }

    public Category getCategoryById(int categoryId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        Category category = null;

        try {
            conn = DBconn.getConnection();
            String sql = "SELECT * FROM categories WHERE category_id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, categoryId);
            rs = stmt.executeQuery();

            if (rs.next()) {
                category = mapResultSetToCategory(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, rs);
        }

        return category;
    }

    public List<Category> getAllCategories(int offset, int limit) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Category> categories = new ArrayList<>();
        
        try {
            conn = DBconn.getConnection();
            String sql = "SELECT * FROM categories ORDER BY category_id LIMIT ? OFFSET ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, limit);
            stmt.setInt(2, offset);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                Category category = mapResultSetToCategory(rs);
                categories.add(category);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, rs);
        }
        
        return categories;
    }

    public boolean addCategory(Category category) {
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = DBconn.getConnection();
            String sql = "INSERT INTO categories (name, description, parent_id, status) VALUES (?, ?, ?, ?)";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, category.getName());
            stmt.setString(2, category.getDescription());
            if (category.getCategoryId() == 0) {
                stmt.setNull(3, Types.INTEGER);
            } else {
                stmt.setInt(3, category.getParentId());
            }
            stmt.setInt(4, category.getStatus());
            stmt.executeUpdate();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources(conn, stmt, null);
        }
    }

    public boolean deleteCategory(int id) {
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = DBconn.getConnection();
            String sql = "DELETE FROM categories WHERE category_id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            stmt.executeUpdate();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources(conn, stmt, null);
        }
    }
    
    public boolean updateCategory(Category category) {
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = DBconn.getConnection();
            String sql = "UPDATE categories SET name = ?, description = ?, parent_id = ?, status = ? WHERE category_id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, category.getName());
            stmt.setString(2, category.getDescription());
            stmt.setInt(3, category.getParentId());
            stmt.setInt(4, category.getStatus());
            stmt.setInt(5, category.getCategoryId());
            stmt.executeUpdate();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources(conn, stmt, null);
        }
    }

    private Category mapResultSetToCategory(ResultSet rs) throws SQLException {
        Category category = new Category();
        category.setCategoryId(rs.getInt("category_id"));
        category.setName(rs.getString("name"));
        category.setDescription(rs.getString("description"));
        category.setParentId(rs.getInt("parent_id"));
        category.setStatus(rs.getInt("status"));
        return category;
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
