<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sản phẩm - Fashion Shop</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
    <jsp:include page="page/header.jsp" />

    <!-- Products Section -->
    <section class="container my-5">
        <div class="row">
            <!-- Sidebar Filters -->
            <div class="col-lg-3 mb-4">
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">Bộ lọc sản phẩm</h5>
                    </div>
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/products/category" method="get" id="filterForm">
                            <input name="search"  value="${search}" type="hidden">
                            <!-- Categories -->
                            <div class="mb-4">
                                <h6 class="fw-bold">Danh mục</h6>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="category" value="" id="category" checked>
                                    <label class="form-check-label" for="category">Tất cả</label>
                                </div>
                                <c:forEach items="${categories}" var="category">
                                    <div class="form-check">
                                        <input class="form-check-input" type="radio" name="category" value="${category.categoryId}" id="category${category.categoryId}" ${param.category == category.categoryId ? 'checked' : ''}>
                                        <label class="form-check-label" for="category${category.categoryId}">${category.name}</label>
                                    </div>
                                </c:forEach>
                            </div>
                            
                            <!-- Price Range -->
                            <div class="mb-4">
                                <h6 class="fw-bold">Khoảng giá</h6>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="priceRange" value="" id="price" checked>
                                    <label class="form-check-label" for="price">Tất cả</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="priceRange" value="0-200000" id="price1" ${param.priceRange == '0-200000' ? 'checked' : ''}>
                                    <label class="form-check-label" for="price1">
                                        Dưới 200.000₫
                                    </label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="priceRange" value="200000-500000" id="price2" ${param.priceRange == '200000-500000' ? 'checked' : ''}>
                                    <label class="form-check-label" for="price2">
                                        200.000₫ - 500.000₫
                                    </label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="priceRange" value="500000-1000000" id="price3" ${param.priceRange == '500000-1000000' ? 'checked' : ''}>
                                    <label class="form-check-label" for="price3">
                                        500.000₫ - 1.000.000₫
                                    </label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="priceRange" value="1000000-0" id="price4" ${param.priceRange == '1000000-0' ? 'checked' : ''}>
                                    <label class="form-check-label" for="price4">
                                        Trên 1.000.000₫
                                    </label>
                                </div>
                            </div>
                            
                            <!-- Size -->
                            <div class="mb-4">
                                <h6 class="fw-bold">Kích cỡ</h6>
                                <div class="d-flex flex-wrap gap-2">
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="checkbox" name="size" value="S" id="sizeS" ${param.size == 'S' ? 'checked' : ''}>
                                        <label class="form-check-label" for="sizeS">S</label>
                                    </div>
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="checkbox" name="size" value="M" id="sizeM" ${param.size == 'M' ? 'checked' : ''}>
                                        <label class="form-check-label" for="sizeM">M</label>
                                    </div>
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="checkbox" name="size" value="L" id="sizeL" ${param.size == 'L' ? 'checked' : ''}>
                                        <label class="form-check-label" for="sizeL">L</label>
                                    </div>
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="checkbox" name="size" value="XL" id="sizeXL" ${param.size == 'XL' ? 'checked' : ''}>
                                        <label class="form-check-label" for="sizeXL">XL</label>
                                    </div>
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="checkbox" name="size" value="XXL" id="sizeXXL" ${param.size == 'XXL' ? 'checked' : ''}>
                                        <label class="form-check-label" for="sizeXXL">XXL</label>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Color -->
                            <div class="mb-4">
                                <h6 class="fw-bold">Màu sắc</h6>
                                <div class="d-flex flex-wrap gap-2">
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="checkbox" name="color" value="black" id="colorBlack" ${param.color == 'black' ? 'checked' : ''}>
                                        <label class="form-check-label" for="colorBlack">Đen</label>
                                    </div>
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="checkbox" name="color" value="white" id="colorWhite" ${param.color == 'white' ? 'checked' : ''}>
                                        <label class="form-check-label" for="colorWhite">Trắng</label>
                                    </div>
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="checkbox" name="color" value="pink" id="colorPink" ${param.color == 'pink' ? 'checked' : ''}>
                                        <label class="form-check-label" for="colorPink">Hồng</label>
                                    </div>
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="checkbox" name="color" value="red" id="colorRed" ${param.color == 'red' ? 'checked' : ''}>
                                        <label class="form-check-label" for="colorRed">Đỏ</label>
                                    </div>
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="checkbox" name="color" value="yellow" id="colorYellow" ${param.color == 'yellow' ? 'checked' : ''}>
                                        <label class="form-check-label" for="colorYellow">Vàng</label>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="d-grid gap-2">
                                <button type="submit" class="btn btn-primary">Áp dụng</button>
                                <button type="reset" class="btn btn-outline-secondary">Đặt lại</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
            
            <!-- Product Listing -->
            <div class="col-lg-9">
                <!-- Search and Sort -->
<%--                <div class="d-flex justify-content-between align-items-center mb-4">--%>
<%--                    --%>
<%--                    <div class="d-flex align-items-center">--%>
<%--                        <label for="sortSelect" class="me-2">Sắp xếp:</label>--%>
<%--                        <select class="form-select" id="sortSelect" style="width: auto;">--%>
<%--                            <option value="newest" ${param.sort == 'newest' ? 'selected' : ''}>Mới nhất</option>--%>
<%--                            <option value="price-asc" ${param.sort == 'price-asc' ? 'selected' : ''}>Giá tăng dần</option>--%>
<%--                            <option value="price-desc" ${param.sort == 'price-desc' ? 'selected' : ''}>Giá giảm dần</option>--%>
<%--                            <option value="name-asc" ${param.sort == 'name-asc' ? 'selected' : ''}>Tên A-Z</option>--%>
<%--                            <option value="name-desc" ${param.sort == 'name-desc' ? 'selected' : ''}>Tên Z-A</option>--%>
<%--                        </select>--%>
<%--                    </div>--%>
<%--                </div>--%>
                
                <!-- Product Grid -->
                <div class="row g-4">
                    <!-- Products will be dynamically generated here -->
                    <c:forEach items="${products}" var="product">
                        <div class="col-md-4">
                            <div class="card product-card h-100">
                                <img src="${pageContext.request.contextPath}/${product.thumbnail}" class="card-img-top" alt="${product.name}">
                                <div class="card-body d-flex flex-column">
                                    <h5 class="card-title">${product.name}</h5>
                                    <div class="d-flex justify-content-between align-items-center mt-auto">
                                        <div class="price-box">
                                            <span class="current-price">${product.price}</span>
                                        </div>
                                        <a href="${pageContext.request.contextPath}/products/view?id=${product.productId}" class="btn btn-sm btn-primary">Chi tiết</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
                <!-- Pagination -->
                <nav class="mt-5">
                    <ul class="pagination justify-content-center">
                        <c:if test="${currentPage > 1}">
                            <li class="page-item">
                                <a class="page-link" href="${pageContext.request.contextPath}/products/category?page=${currentPage - 1}" aria-label="Previous">
                                    <span aria-hidden="true">&laquo;</span>
                                </a>
                            </li>
                        </c:if>
                        
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/products/category?page=${i}">${i}</a>
                            </li>
                        </c:forEach>
                        
                        <c:if test="${currentPage < totalPages}">
                            <li class="page-item">
                                <a class="page-link" href="${pageContext.request.contextPath}/products/category?page=${currentPage + 1}" aria-label="Next">
                                    <span aria-hidden="true">&raquo;</span>
                                </a>
                            </li>
                        </c:if>
                    </ul>
                </nav>
            </div>
        </div>
    </section>

<!-- Footer -->
    <jsp:include page="page/footer.jsp" />
    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Search functionality
        document.getElementById('searchButton').addEventListener('click', function() {
            const searchValue = document.getElementById('searchInput').value.trim();
            if (searchValue) {
                window.location.href = '${pageContext.request.contextPath}/products?search=' + encodeURIComponent(searchValue);
            }
        });
        
        // Enter key for search
        document.getElementById('searchInput').addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                document.getElementById('searchButton').click();
            }
        });
        
        // Sort functionality
        document.getElementById('sortSelect').addEventListener('change', function() {
            const currentUrl = new URL(window.location.href);
            currentUrl.searchParams.set('sort', this.value);
            window.location.href = currentUrl.toString();
        });
        
        // Reset button functionality
        document.querySelector('button[type="reset"]').addEventListener('click', function() {
            window.location.href = '${pageContext.request.contextPath}/products';
        });
    </script>
</body>
</html>
