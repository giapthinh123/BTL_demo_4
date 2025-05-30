<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết sản phẩm - Fashion Shop</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
    <!-- Header -->
    <jsp:include page="page/header.jsp" />

    <!-- Product Detail Section -->
    <section class="container my-5">
        <div class="card">
            <div class="card-body p-4">
                <div class="row">
                    <!-- Product Images -->
                    <div class="col-md-6 mb-4">
                        <div class="product-images">
                            <!-- Main Image -->
                            <div class="main-image mb-3">
                                <img src="${pageContext.request.contextPath}/${product.thumbnail}" class="img-fluid rounded" id="mainImage" alt="${product.name}">
                            </div>
                            <!-- Thumbnail Images -->
                            <div class="thumbnail-images d-flex">
                                <c:forEach items="${image_url}" var="image" varStatus="status">
                                    <div class="thumbnail-item me-2">
                                       <img src="${pageContext.request.contextPath}/${image}" class="img-thumbnail"
                                            onclick="changeMainImage('${pageContext.request.contextPath}/${image}')" alt="${product.name} ${status.index + 1}">
                                   </div>
                              </c:forEach>
                            </div>
                        </div>
                    </div>

                    <!-- Product Info -->
                    <div class="col-md-6">
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/products">Trang chủ</a></li>
                                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/products/category">Sản phẩm</a></li>
                                <li class="breadcrumb-item active" aria-current="page">${product.name}</li>
                            </ol>
                        </nav>

                        <h2 class="product-title mb-3">${product.name}</h2>

                        <div class="product-price mb-3">
                            <span class="current-price fs-3 fw-bold">${product.price}</span>
                        </div>

                        <div class="product-description mb-4">
                            <p>${product.description}</p>
                        </div>

                        <div class="product-availability mb-3">
                            <c:choose>
                                <c:when test="${product.stock > 0}">
                                    <span class="badge bg-success">Còn hàng</span>
                                    <span class="ms-2">${product.stock} sản phẩm có sẵn</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-danger">Hết hàng</span>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <form action="${pageContext.request.contextPath}/cart/add" method="post" class="mb-4">
                            <input type="hidden" name="productId" value="${product.productId}">
                            <input type="hidden" name="source" value="product">

                            <!-- Size Selection -->
                            <div class="mb-3">
                                <label class="form-label fw-bold">Phân loại:</label>
                                <div class="d-flex flex-wrap gap-2">
                                    <c:forEach items="${variants}" var="variant">
                                        <div class="form-check form-check-inline">
                                            <input class="form-check-input" type="radio" name="variantId"
                                                   value="${variant.variant_id}" id="variant${variant.variant_id}" required>
                                            <label class="form-check-label" for="variant${variant.variant_id}">
                                                ${variant.size} - 
                                                <span class="color-circle" style="background-color: ${variant.color}"></span>
                                                ${variant.color}
                                            </label>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>

                            <!-- Quantity -->
                            <div class="mb-4">
                                <label for="quantity" class="form-label fw-bold">Số lượng:</label>
                                <div class="input-group" style="width: 150px;">
                                    <button class="btn btn-outline-secondary" type="button" id="decreaseQuantity">-</button>
                                    <input type="number" class="form-control text-center" id="quantity" name="quantity" value="1" min="1" max="${product.stock}" required>
                                    <button class="btn btn-outline-secondary" type="button" id="increaseQuantity">+</button>
                                </div>
                            </div>

                            <!-- Add to Cart Button -->
                            <div class="d-grid gap-2 d-md-flex">
                                <button type="submit" class="btn btn-primary btn-lg flex-grow-1" ${product.stock <= 0 ? 'disabled' : ''}>
                                    <i class="fas fa-shopping-cart me-2"></i> Thêm vào giỏ hàng
                                </button>
                                <button type="button" class="btn btn-outline-danger btn-lg" id="addToWishlist">
                                    <i class="fas fa-heart"></i>
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <!-- Product Details Tabs -->
        <div class="card mt-4">
            <div class="card-body">
                <div class="tab-content p-4">
                    <!-- Reviews Tab -->
                    <div class="tab-pane active show" id="reviews" role="tabpanel" aria-labelledby="reviews-tab">
                        <c:if test="${reviews.size() > 0}">
                            <c:set var="itemsPerPage" value="3" />
                            <c:set var="currentPage" value="${param.page != null ? param.page : 1}" />
                            <c:set var="startIndex" value="${(currentPage - 1) * itemsPerPage}" />
                            <c:set var="endIndex" value="${startIndex + itemsPerPage - 1}" />
                            <c:set var="totalPages" value="${Math.ceil(reviews.size() / itemsPerPage)}" />

                            <c:forEach items="${reviews}" var="review" begin="${startIndex}" end="${endIndex < reviews.size() - 1 ? endIndex : reviews.size() - 1}">
                                <div class="review-item border-bottom pb-3 mb-3">
                                    <div class="d-flex justify-content-between">
                                        <div>
                                            <h5 class="mb-1">${review.username}</h5>
                                            <div class="product-rating mb-2">
                                                <c:forEach begin="1" end="5" var="i">
                                                    <i class="fas fa-star ${i <= review.rating ? 'text-warning' : 'text-secondary'}"></i>
                                                </c:forEach>
                                            </div>
                                        </div>
                                        <div class="text-muted small">
                                            <span><fmt:parseDate value="${review.created_at}" pattern="yyyy-MM-dd" var="parsedDate" type="date" />
                                            <fmt:formatDate value="${parsedDate}" pattern="dd/MM/yyyy"/></span>
                                        </div>
                                    </div>
                                    <p class="mb-1">${review.comment}</p>
                                </div>
                            </c:forEach>

                            <!-- Pagination -->
                            <c:if test="${reviews.size() > itemsPerPage}">
                                <nav aria-label="Review pagination">
                                    <ul class="pagination justify-content-center">
                                        <c:forEach begin="1" end="${totalPages}" var="pageNum">
                                            <li class="page-item ${pageNum == currentPage ? 'active' : ''}">
                                                <a class="page-link" href="?id=${product.productId}&page=${pageNum}">${pageNum}</a>
                                            </li>
                                        </c:forEach>
                                    </ul>
                                </nav>
                            </c:if>
                        </c:if>
                        <c:if test="${reviews.size() == 0}">
                            <p>Không có đánh giá nào</p>
                        </c:if>
                        <!-- Write Review Form -->
                        <div class="write-review">
                            <h4 class="mb-3">Viết đánh giá</h4>
                            <form action="${pageContext.request.contextPath}/products/review" method="post">
                                <input type="hidden" name="productId" value="${product.productId}">
                                <input type="hidden" name="userid" value="${user.userId}">
                                <div class="mb-3">
                                    <label class="form-label">Đánh giá</label>
                                    <div class="rating-input">
                                        <div class="form-check form-check-inline">
                                            <input class="form-check-input" type="radio" name="rating" id="rating5" value="5" required>
                                            <label class="form-check-label" for="rating5">5 <i class="fas fa-star text-warning"></i></label>
                                        </div>
                                        <div class="form-check form-check-inline">
                                            <input class="form-check-input" type="radio" name="rating" id="rating4" value="4">
                                            <label class="form-check-label" for="rating4">4 <i class="fas fa-star text-warning"></i></label>
                                        </div>
                                        <div class="form-check form-check-inline">
                                            <input class="form-check-input" type="radio" name="rating" id="rating3" value="3">
                                            <label class="form-check-label" for="rating3">3 <i class="fas fa-star text-warning"></i></label>
                                        </div>
                                        <div class="form-check form-check-inline">
                                            <input class="form-check-input" type="radio" name="rating" id="rating2" value="2">
                                            <label class="form-check-label" for="rating2">2 <i class="fas fa-star text-warning"></i></label>
                                        </div>
                                        <div class="form-check form-check-inline">
                                            <input class="form-check-input" type="radio" name="rating" id="rating1" value="1">
                                            <label class="form-check-label" for="rating1">1 <i class="fas fa-star text-warning"></i></label>
                                        </div>
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label for="reviewComment" class="form-label">Nội dung đánh giá</label>
                                    <textarea class="form-control" id="reviewComment" name="comment" rows="4" required></textarea>
                                </div>

                                <button type="submit" class="btn btn-primary">Gửi đánh giá</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        </section>
    </section>

    <jsp:include page="page/footer.jsp" />

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
    <script>
        // Change main image
        function changeMainImage(imageSrc) {
            document.getElementById('mainImage').src = imageSrc;
        }

        // Quantity buttons
        document.getElementById('decreaseQuantity').addEventListener('click', function() {
            const quantityInput = document.getElementById('quantity');
            const currentValue = parseInt(quantityInput.value);
            if (currentValue > 1) {
                quantityInput.value = currentValue - 1;
            }
        });

        document.getElementById('increaseQuantity').addEventListener('click', function() {
            const quantityInput = document.getElementById('quantity');
            const currentValue = parseInt(quantityInput.value);
            const maxValue = parseInt(quantityInput.getAttribute('max'));
            if (currentValue < maxValue) {
                quantityInput.value = currentValue + 1;
            }
        });

        // Add to wishlist
        document.getElementById('addToWishlist').addEventListener('click', function() {
            alert('Đã thêm sản phẩm vào danh sách yêu thích!');
        });
    </script>
</body>
</html>
