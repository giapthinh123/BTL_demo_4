package com.bqa.model;

public class reviews {
    private int reviewid;
    private int productid;
    private int userid;
    private int rating;
    private String comment;
    private String created_at;
    private int status;
    private String username;

    public reviews() {}
    public reviews(int reviewid, int productid, int userid, int rating, String comment, String date, int status, String username) {
        this.reviewid = reviewid;
        this.productid = productid;
        this.userid = userid;
        this.rating = rating;
        this.comment = comment;
        this.created_at = created_at;
        this.status = status;
        this.username = username;
    }
    public reviews(int reviewid, int productid, int userid, int rating, String comment, String created_at, int status) {
        this.reviewid = reviewid;
        this.productid = productid;
        this.userid = userid;
        this.rating = rating;
        this.comment = comment;
        this.created_at = created_at;
        this.status = status;
    }

    public int getReviewid() {
        return reviewid;
    }

    public int getProductid() {
        return productid;
    }

    public int getUserid() {
        return userid;
    }

    public int getRating() {
        return rating;
    }

    public String getComment() {
        return comment;
    }

    public String getCreated_at() {
        return created_at;
    }

    public int getStatus() {
        return status;
    }

    public void setReviewid(int reviewid) {
        this.reviewid = reviewid;
    }
    
    public void setProductid(int productid) {
        this.productid = productid;
    }

    public void setUserid(int userid) {
        this.userid = userid;
    }
    
    public void setRating(int rating) {
        this.rating = rating;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public void setCreated_at(String created_at) {
        this.created_at = created_at;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getUsername() {
        return username;
    }

    @Override
    public String toString() {
        return "reviews{" +
                "reviewid=" + reviewid +
                ", productid=" + productid +
                ", userid=" + userid +
                ", rating=" + rating +
                ", comment=" + comment +
                ", created_at=" + created_at +
                ", status=" + status +
                '}';
    }

}
