package com.bqa.service;

import com.bqa.dao.categoryDao;
import com.bqa.model.Category;
import com.bqa.model.Product;
import com.bqa.service.productServiece;
import java.util.List;

public class categoryService {

    private categoryDao categoryDAO;
    private productServiece productServiece;

    public categoryService() {
        this.categoryDAO = new categoryDao();
        this.productServiece = new productServiece();
    }

    public List<Category> getCategoriesWithInfo(int offset, int limit) {
        List<Category> categories = categoryDAO.getAllCategories(offset, limit);

        // Add product count and parent name to each category
        for (Category category : categories) {
            // Get product count
            int productCount = productServiece.getProductsByCategory(category.getCategoryId()).size();
            category.setProductCount(productCount);

            // Get parent name if exists
            if (category.getParentId() != null) {
                Category parent = categoryDAO.getCategoryById(category.getParentId());
                if (parent != null) {
                    category.setParentName(parent.getName());
                }
            }
        }

        return categories;
    }

    public List<Category> getAllCategoriesByParentIdWithOn(int parentId) {
        return categoryDAO.getAllCategoriesByParentIdWithOn(parentId);
    }

    public boolean addCategory(Category category) {
        return categoryDAO.addCategory(category);
    }
    
    public boolean hasChildCategories(int id) {
        List<Category> categories = categoryDAO.getAllCategories();
        for (Category category : categories) {
            if (category.getParentId() == id) {
                return true;
            }
        }
        return false;
    }

    public boolean hasProductsInCategory(int id) {
        List<Product> products = productServiece.getProductsByCategory(id);
        return !products.isEmpty();
    }

    public Category getCategoryById(int id) {
        return categoryDAO.getCategoryById(id);
    }

    public boolean updateCategory(Category category) {
        return categoryDAO.updateCategory(category);
    }

    public boolean deleteCategory(int id) {
        return categoryDAO.deleteCategory(id);
    }


    public List<Category> getAllCategories() {
        return categoryDAO.getAllCategories();
    }

    public List<Category> getAllCategoriesWithOn() {
        return categoryDAO.getAllCategoriesWithOn();
    }

}
