<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<header>
  <!-- Top Bar -->
  <div class="top-bar bg-dark text-white py-2">
    <div class="container">
      <div class="row">
        <div class="col-md-6">
          <ul class="list-inline mb-0">
            <li class="list-inline-item me-3">
              <i class="fas fa-phone-alt me-1"></i> 0987 654 321
            </li>
            <li class="list-inline-item">
              <i class="fas fa-envelope me-1"></i> info@fashionshop.com
            </li>
          </ul>
        </div>
        <div class="col-md-6 text-end">
          <ul class="list-inline mb-0">
            <li class="list-inline-item me-3">
              <a href="#" class="text-white"><i class="fab fa-facebook-f"></i></a>
            </li>
            <li class="list-inline-item me-3">
              <a href="#" class="text-white"><i class="fab fa-instagram"></i></a>
            </li>
            <li class="list-inline-item">
              <a href="#" class="text-white"><i class="fab fa-tiktok"></i></a>
            </li>
          </ul>
        </div>
      </div>
    </div>
  </div>

  <!-- Main Header -->
  <div class="main-header py-3">
    <div class="container">
      <div class="row align-items-center">
        <div class="col-md-3">
          <a href="${pageContext.request.contextPath}/products" class="text-decoration-none">
            <h1 class="mb-0 text-primary">Fashion Shop</h1>
          </a>
        </div>
        <div class="col-md-6">
          <form action="${pageContext.request.contextPath}/products/category" method="get" class="search-form">
            <div class="input-group">
              <input type="text" class="form-control" placeholder="Tìm kiếm sản phẩm..." name="search" value="${search}">
              <button class="btn btn-primary" type="submit">
                <i class="fas fa-search"></i>
              </button>
            </div>
          </form>
        </div>
        <div class="col-md-3 text-end">
          <div class="d-flex justify-content-end">
            <div class="dropdown me-3">
              <a href="#" class="text-dark text-decoration-none dropdown-toggle" id="userDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                <i class="fas fa-user-circle fs-4"></i>
              </a>
              <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                <c:choose>
                  <c:when test="${empty sessionScope.user}">
                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/login">Đăng nhập</a></li>
                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/register">Đăng ký</a></li>
                  </c:when>
                  <c:otherwise>
                    <li><h6 class="dropdown-header">Xin chào, ${sessionScope.user.fullName}!</h6></li>
                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/account/profile">Tài khoản của tôi</a></li>
                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/account/orders">Đơn hàng của tôi</a></li>
                    <li><hr class="dropdown-divider"></li>
                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">Đăng xuất</a></li>
                  </c:otherwise>
                </c:choose>
              </ul>
            </div>
            <a href="${pageContext.request.contextPath}/cart" class="text-dark text-decoration-none position-relative">
              <i class="fas fa-shopping-cart fs-4"></i>
              <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                ${sessionScope.cart != null && sessionScope.cart.items != null ? sessionScope.cart.items.size() : 0}
              </span>
            </a>
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- Navigation -->
  <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
    <div class="container">
      <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarMain" aria-controls="navbarMain" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
      </button>
      <div class="collapse navbar-collapse" id="navbarMain">
        <ul class="navbar-nav me-auto">
          <li class="nav-item">
            <a class="nav-link active" href="${pageContext.request.contextPath}/products">Trang chủ</a>
          </li>
          <li class="nav-item dropdown">
            <a class="nav-link dropdown-toggle" href="#" id="navbarDropdownMen" role="button" data-bs-toggle="dropdown" aria-expanded="false">
              Nam
            </a>
            <ul class="dropdown-menu" aria-labelledby="navbarDropdownMen">
              <c:forEach var="category" items="${categories_nam}">
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/products/category?category=${category.categoryId}">${category.name}</a></li>
              </c:forEach>
              <li><hr class="dropdown-divider"></li>
              <li><a class="dropdown-item" href="${pageContext.request.contextPath}/products/category?category=1">Tất cả sản phẩm nam</a></li>
            </ul>
          </li>
          <li class="nav-item dropdown">
            <a class="nav-link dropdown-toggle" href="#" id="navbarDropdownWomen" role="button" data-bs-toggle="dropdown" aria-expanded="false">
              Nữ
            </a>
            <ul class="dropdown-menu" aria-labelledby="navbarDropdownWomen">
              <c:forEach var="category" items="${categories_nu}">
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/products/category?category=${category.categoryId}">${category.name}</a></li>
              </c:forEach>
              <li><hr class="dropdown-divider"></li>
              <li><a class="dropdown-item" href="${pageContext.request.contextPath}/products/category?category=2">Tất cả sản phẩm nữ</a></li>
            </ul>
          </li>
          <li class="nav-item dropdown">
            <a class="nav-link dropdown-toggle" href="#" id="navbarDropdownKids" role="button" data-bs-toggle="dropdown" aria-expanded="false">
              Trẻ em
            </a>
            <ul class="dropdown-menu" aria-labelledby="navbarDropdownKids">
              <c:forEach var="category" items="${categories_treem}">
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/products/category?category=${category.categoryId}">${category.name}</a></li>
              </c:forEach>
              <li><hr class="dropdown-divider"></li>
              <li><a class="dropdown-item" href="${pageContext.request.contextPath}/products/category?category=3">Tất cả sản phẩm trẻ em</a></li>
            </ul>
          </li>
          <li class="nav-item">
            <a class="nav-link" href="${pageContext.request.contextPath}/about">Giới thiệu</a>
          </li>
          <li class="nav-item">
            <a class="nav-link" href="${pageContext.request.contextPath}/contact">Liên hệ</a>
          </li>
        </ul>
      </div>
    </div>
  </nav>
</header>