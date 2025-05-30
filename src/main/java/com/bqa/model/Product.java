package com.bqa.model;

import java.math.BigDecimal;

/**
 * Product entity class
 */
public class Product {
    private int productId;
    private int categoryId;
    private String name;
    private String description;
    private BigDecimal price;
    private String thumbnail;
    private int status;
    private int featured;

    private int stock;
    // Constructors
    public Product() {
    }
    
    public Product(int productId, int categoryId, String name, String description,
                   BigDecimal price, String thumbnail,
                   int status, int featured,int stock) {
        this.productId = productId;
        this.categoryId = categoryId;
        this.name = name;
        this.description = description;
        this.price = price;
        this.thumbnail = thumbnail;
        this.status = status;
        this.featured = featured;
        this.stock = stock;
    }
    
    // Getters and Setters
    public int getProductId() {
        return productId;
    }
    
    public void setProductId(int productId) {
        this.productId = productId;
    }
    
    public int getCategoryId() {
        return categoryId;
    }
    
    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public BigDecimal getPrice() {
        return price;
    }
    
    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public String getThumbnail() {
        return thumbnail;
    }
    
    public void setThumbnail(String thumbnail) {
        this.thumbnail = thumbnail;
    }

    public int getStatus() {
        return status;
    }
    
    public void setStatus(int status) {
        this.status = status;
    }
    
    public int getFeatured() {
        return featured;
    }
    
    public void setFeatured(int featured) {
        this.featured = featured;
    }
    
    public boolean isActive() {
        return this.status == 1;
    }

    public int getStock() {
        return stock;
    }
    public void setStock(int stock) {
        this.stock = stock;
    }
    @Override
    public String toString() {
        return "Product{" +
                "productId=" + productId +
                ", categoryId=" + categoryId +
                ", name='" + name + '\'' +
                ", price=" + price +
                ", thumbnail='" + thumbnail + '\'' +
                ", status=" + status +
                ", featured=" + featured +
                '}';
    }
}
