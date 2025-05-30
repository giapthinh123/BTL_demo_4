package com.bqa.service;

import com.bqa.model.Product;
import  com.bqa.dao.productDao;
import com.bqa.model.reviews;

import java.util.List;
import java.util.Map;

public class productServiece {
    private productDao productDAO;

    public productServiece() {
        this.productDAO = new productDao();
    }

    public List<Product> getAllProducts() {
        return productDAO.getAllProducts();
    }

    public List<Product> getAllProducts(String search, String category, int status, int offset, int limit) {
        return productDAO.getAllProducts(search, category, status, offset, limit);
    }

    public List<Product> getAllProductsWithOn(String search, String category,Double minPrice,Double maxPrice,String size,String color , int offset, int limit) {
        return productDAO.getAllProductsWithOn(search, category,minPrice, maxPrice,size ,color, offset, limit);
    }

    public List<Product> getAllProductsWithOn(int offset, int limit) {
        return productDAO.getAllProductsWithOn(offset, limit);
    }


    public Product getProductById(int id) {
        return productDAO.getProductById(id);
    }

    public int getTotalProducts(String search, String category, int status) {
        return productDAO.getTotalProducts(search, category, status);
    }

    public int getTotalProductsWithOn(String search, String category) {
        return productDAO.getTotalProductsWithOn(search, category);
    }
    public int getTotalProducts() {
        return productDAO.getTotalProducts();
    }

    public int getallVacantProductsWithid(int id){
        return productDAO.getallVacantProductsWithid(id);
    }

    public List<String> getallVariantId(int productId){
        return productDAO.getallVariantId(productId);
    }

    public boolean addProduct(Product product) {
        // Validate product data
        if (product.getName() == null || product.getName().trim().isEmpty()) {
            return false;
        }

        if (product.getPrice() == null || product.getPrice().doubleValue() <= 0) {
            return false;
        }

        if (product.getStock() < 0) {
            return false;
        }

        return productDAO.addProduct(product);
    }

    public int getindexProduct() {
        return productDAO.getindexProduct();
    }

    public List<Map<String, String>> getProductVariantById(int id){
        return productDAO.getProductVariantById(id);
    }

    public boolean addProductVariant(int product_id, String size, String color, int stock) {
        return productDAO.addProductVariant(product_id, size, color, stock);
    }

    public boolean editProductVariant(int variant_id, String size, String color, int stock) {
        return productDAO.editProductVariant(variant_id, size, color, stock);
    }

    public boolean addImageProduct(int product_id, String image_url) {
        return productDAO.addImageProduct(product_id,image_url);
    }

    public List<String> getImageProduct(int product_id) {
        return productDAO.getImageProduct(product_id);
    }

    public boolean deleteImageProduct(int product_id, String image_url) {
        return productDAO.deleteImageProduct(product_id, image_url);
    }

    public boolean deleteProductVariant(int variant_id) {
        return productDAO.deleteProductVariant(variant_id);
    }

    public boolean deleteProduct(int product_id) {
        return productDAO.deleteProduct(product_id);
    }

    public List<Product> getProductsByCategory(int categoryId) {
        return productDAO.getProductsByCategory(categoryId);
    }

    public boolean editProduct(Product product) {
        return productDAO.editProduct(product);
    }

    public boolean addReview(reviews review) {
        return productDAO.addReview(review);
    }

    public List<reviews> getReviewsByProductId(int productId) {
        return productDAO.getReviewsByProductId(productId);
    }
}
