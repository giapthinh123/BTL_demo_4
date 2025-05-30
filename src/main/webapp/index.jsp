<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang chủ - Fashion Shop</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
<!-- Header -->
<jsp:include page="page/header.jsp" />

<!-- Main Content -->
<main>
    <!-- Hero Banner -->
    <section class="hero-banner">
        <div id="heroCarousel" class="carousel slide" data-bs-ride="carousel">
            <div class="carousel-inner">
                <img src="${pageContext.request.contextPath}/assets/images/banner_main.png" class="d-block w-100" alt="Summer Collection">
            </div>
        </div>
    </section>

    <!-- Featured Categories -->
    <section class="featured-categories py-5">
        <div class="container">
            <h2 class="text-center mb-4">Danh mục nổi bật</h2>
            <div class="row g-4">
                <div class="col-md-4">
                    <div class="card category-card h-100">
                        <img src="${pageContext.request.contextPath}/assets/images/banner_nam.png" class="card-img-top" alt="Men's Fashion">
                        <div class="card-body text-center">
                            <h3 class="card-title">Thời trang nam</h3>
                            <a href="${pageContext.request.contextPath}/products/category?category=1" class="btn btn-outline-primary">Xem ngay</a>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card category-card h-100">
                        <img src="${pageContext.request.contextPath}/assets/images/banner_nu.png" class="card-img-top" alt="Women's Fashion">
                        <div class="card-body text-center">
                            <h3 class="card-title">Thời trang nữ</h3>
                            <a href="${pageContext.request.contextPath}/products/category?category=2" class="btn btn-outline-primary">Xem ngay</a>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card category-card h-100">
                        <img src="${pageContext.request.contextPath}/assets/images/banner_tre_em.png" class="card-img-top" alt="Kids' Fashion">
                        <div class="card-body text-center">
                            <h3 class="card-title">Thời trang trẻ em</h3>
                            <a href="${pageContext.request.contextPath}/products/category?category=3" class="btn btn-outline-primary">Xem ngay</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- New Arrivals -->
    <section class="new-arrivals py-5 bg-light">
        <div class="container">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2>Sản phẩm</h2>
                <a href="${pageContext.request.contextPath}/products/category" class="btn btn-outline-primary">Xem tất cả</a>
            </div>
            <div class="row g-4">
                <jsp:useBean id="products" scope="request" type="java.util.List" />
                <c:forEach items="${products}" var="product">
                    <div class="col-md-3">
                        <div class="card product-card h-100">
                            <a href="${pageContext.request.contextPath}/products/view?id=${product.productId}">
                                <img src="${pageContext.request.contextPath}/${product.thumbnail}" class="card-img-top" alt="${product.name}">
                            </a>
                            <div class="card-body">
                                <h5 class="card-title">
                                    <a href="${pageContext.request.contextPath}/products/view?id=${product.productId}" class="text-decoration-none text-dark">${product.name}</a>
                                </h5>
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <span class="fw-bold">${product.price}₫</span>
                                    </div>
                                </div>
                            </div>
                            <div class="card-footer bg-white border-top-0">
                                <div class="d-grid">
                                    <a href="${pageContext.request.contextPath}/products/view?id=${product.productId}" class="btn btn-primary">
                                        <i class="fas fa-shopping-cart me-2"></i>Thêm vào giỏ
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </section>

    <!-- Features -->
    <section class="features py-5 bg-light">
        <div class="container">
            <div class="row g-4">
                <div class="col-md-3">
                    <div class="feature-item text-center">
                        <div class="feature-icon mb-3">
                            <i class="fas fa-truck fa-3x text-primary"></i>
                        </div>
                        <h4>Giao hàng miễn phí</h4>
                        <p class="text-muted">Cho đơn hàng từ 500.000đ</p>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="feature-item text-center">
                        <div class="feature-icon mb-3">
                            <i class="fas fa-undo fa-3x text-primary"></i>
                        </div>
                        <h4>Đổi trả dễ dàng</h4>
                        <p class="text-muted">Trong vòng 30 ngày</p>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="feature-item text-center">
                        <div class="feature-icon mb-3">
                            <i class="fas fa-lock fa-3x text-primary"></i>
                        </div>
                        <h4>Thanh toán an toàn</h4>
                        <p class="text-muted">Bảo mật thông tin</p>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="feature-item text-center">
                        <div class="feature-icon mb-3">
                            <i class="fas fa-headset fa-3x text-primary"></i>
                        </div>
                        <h4>Hỗ trợ 24/7</h4>
                        <p class="text-muted">Luôn sẵn sàng hỗ trợ</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

</main>

<!-- Footer -->
<jsp:include page="page/footer.jsp" />

<!-- Scripts -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Product card hover effect
    document.querySelectorAll('.product-card').forEach(card => {
        card.addEventListener('mouseenter', () => {
            card.classList.add('shadow-lg');
            card.style.transform = 'translateY(-5px)';
            card.style.transition = 'transform 0.3s ease, box-shadow 0.3s ease';
        });

        card.addEventListener('mouseleave', () => {
            card.classList.remove('shadow-lg');
            card.style.transform = 'translateY(0)';
        });
    });
</script>
</body>
</html>
