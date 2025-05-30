<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<footer class="bg-dark text-white pt-5 pb-4">
    <div class="container">
        <div class="row">
            <div class="col-md-3 mb-4">
                <h5 class="mb-3">Fashion Shop</h5>
                <p>Thời trang cho mọi người, mọi phong cách</p>
                <div class="social-links">
                    <a href="#" class="text-white me-2"><i class="fab fa-facebook-f"></i></a>
                    <a href="#" class="text-white me-2"><i class="fab fa-instagram"></i></a>
                    <a href="#" class="text-white me-2"><i class="fab fa-tiktok"></i></a>
                    <a href="#" class="text-white"><i class="fab fa-youtube"></i></a>
                </div>
            </div>
            <div class="col-md-3 mb-4">
                <h5 class="mb-3">Danh mục</h5>
                <ul class="list-unstyled">
                    <li><a href="${pageContext.request.contextPath}/category/men" class="text-white text-decoration-none mb-2 d-inline-block">Thời trang nam</a></li>
                    <li><a href="${pageContext.request.contextPath}/category/women" class="text-white text-decoration-none mb-2 d-inline-block">Thời trang nữ</a></li>
                    <li><a href="${pageContext.request.contextPath}/category/kids" class="text-white text-decoration-none mb-2 d-inline-block">Thời trang trẻ em</a></li>
                    <li><a href="${pageContext.request.contextPath}/category/accessories" class="text-white text-decoration-none mb-2 d-inline-block">Phụ kiện</a></li>
                    <li><a href="${pageContext.request.contextPath}/sale" class="text-white text-decoration-none d-inline-block">Khuyến mãi</a></li>
                </ul>
            </div>
            <div class="col-md-3 mb-4">
                <h5 class="mb-3">Thông tin</h5>
                <ul class="list-unstyled">
                    <li><a href="${pageContext.request.contextPath}/about" class="text-white text-decoration-none mb-2 d-inline-block">Giới thiệu</a></li>
                    <li><a href="${pageContext.request.contextPath}/contact" class="text-white text-decoration-none mb-2 d-inline-block">Liên hệ</a></li>
                    <li><a href="${pageContext.request.contextPath}/blog" class="text-white text-decoration-none mb-2 d-inline-block">Blog</a></li>
                    <li><a href="${pageContext.request.contextPath}/faq" class="text-white text-decoration-none mb-2 d-inline-block">FAQ</a></li>
                    <li><a href="${pageContext.request.contextPath}/policy" class="text-white text-decoration-none d-inline-block">Chính sách</a></li>
                </ul>
            </div>
            <div class="col-md-3 mb-4">
                <h5 class="mb-3">Liên hệ</h5>
                <ul class="list-unstyled">
                    <li class="mb-2"><i class="fas fa-map-marker-alt me-2"></i> 123 Đường Lê Lợi, Quận 1, TP. HCM</li>
                    <li class="mb-2"><i class="fas fa-phone-alt me-2"></i> 0987 654 321</li>
                    <li class="mb-2"><i class="fas fa-envelope me-2"></i> info@fashionshop.com</li>
                    <li><i class="fas fa-clock me-2"></i> 8:00 - 20:00, Thứ 2 - Chủ nhật</li>
                </ul>
            </div>
        </div>
        <hr class="my-4">
        <div class="row align-items-center">
            <div class="col-md-6 text-center text-md-start">
                <p class="mb-md-0">© 2025 Fashion Shop. Tất cả quyền được bảo lưu.</p>
            </div>
        </div>
    </div>
</footer>
