<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>


            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Giỏ hàng - Fashion Shop</title>
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
            </head>

            <body>
                <!-- Header -->
                <jsp:include page="page/header.jsp" />

                <!-- Cart Section -->
                <section class="container my-5">
                    <h2 class="mb-4">Giỏ hàng của bạn</h2>

                    <c:choose>
                        <c:when test="${empty cart_items}">
                            <!-- Empty Cart -->
                            <div class="text-center py-5">
                                <i class="fas fa-shopping-cart fa-4x mb-3 text-muted"></i>
                                <h3>Giỏ hàng của bạn đang trống</h3>
                                <p class="mb-4">Hãy thêm sản phẩm vào giỏ hàng để tiếp tục mua sắm</p>
                                <a href="${pageContext.request.contextPath}/products" class="btn btn-primary">Tiếp tục
                                    mua sắm</a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <!-- Cart Items -->
                            <div class="row">
                                <div class="col-lg-8">
                                    <div class="card mb-4">
                                        <div class="card-body">
                                            <div class="table-responsive">
                                                <table class="table table-hover align-middle">
                                                    <thead>
                                                        <tr>
                                                            <th scope="col" width="100">Sản phẩm</th>
                                                            <th scope="col">Mô tả</th>
                                                            <th scope="col" class="text-center">Giá</th>
                                                            <th scope="col" class="text-center">Số lượng</th>
                                                            <th scope="col" class="text-center">Tổng</th>
                                                            <th scope="col" class="text-center">Thao tác</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:forEach items="${products}" var="item"
                                                            varStatus="loopStatus">
                                                            <tr>
                                                                <td>
                                                                    <img src="${pageContext.request.contextPath}/${item.thumbnail}"
                                                                        class="img-thumbnail" alt="${item.name}"
                                                                        width="80">
                                                                </td>
                                                                <td>
                                                                    <h6 class="mb-0">${item.name}</h6>
                                                                    <small class="text-muted">

                                                                    </small>
                                                                </td>
                                                                <td class="text-center">${item.price}</td>
                                                                <td class="text-center">
                                                                    <form
                                                                        action="${pageContext.request.contextPath}/cart"
                                                                        method="post" class="d-inline">
                                                                        <input type="hidden" name="action"
                                                                            value="update">
                                                                        <input type="hidden" name="itemId"
                                                                            value="${item.productId}">
                                                                        <div class="input-group input-group-sm"
                                                                            style="width: 100px;">
                                                                            <input type="number"
                                                                                class="form-control text-center"
                                                                                name="quantity"
                                                                                value="${cart_items[loopStatus.index].quantity}"
                                                                                min="1" max="${item.stock}" readonly>
                                                                        </div>
                                                                    </form>
                                                                </td>
                                                                <td class="text-center">
                                                                        ${item.price * cart_items[loopStatus.index].quantity}
                                                                </td>
                                                                <td class="text-center">
                                                                    <form
                                                                        action="${pageContext.request.contextPath}/cart/remove"
                                                                        method="post" class="d-inline">
                                                                        <input type="hidden" name="itemId"
                                                                            value="${item.productId}">
                                                                        <button type="submit"
                                                                            class="btn btn-sm btn-outline-danger"
                                                                            title="Xóa">
                                                                            <i class="fas fa-trash"></i>
                                                                        </button>
                                                                    </form>
                                                                </td>
                                                            </tr>
                                                        </c:forEach>

                                                    </tbody>
                                                </table>
                                            </div>

                                            <div class="d-flex justify-content-between mt-3">
                                                <a href="${pageContext.request.contextPath}/products"
                                                    class="btn btn-outline-primary">
                                                    <i class="fas fa-arrow-left me-2"></i>Tiếp tục mua sắm
                                                </a>
                                                <form action="${pageContext.request.contextPath}/cart/clear" method="post">
                                                    <button type="submit" class="btn btn-outline-danger"
                                                        onclick="return confirm('Bạn có chắc chắn muốn xóa tất cả sản phẩm khỏi giỏ hàng?')">
                                                        <i class="fas fa-trash me-2"></i>Xóa giỏ hàng
                                                    </button>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Cart Summary -->
                                <div class="col-lg-4">
                                    <div class="card">
                                        <div class="card-header bg-primary text-white">
                                            <h5 class="mb-0">Tóm tắt đơn hàng</h5>
                                        </div>
                                        <div class="card-body">
                                            <div class="d-flex justify-content-between mb-4">
                                                <strong>Tổng cộng:</strong>
                                                <strong class="text-primary">${finalTotal}</strong>
                                            </div>

                                            <div class="d-grid">
                                                <a href="${pageContext.request.contextPath}/checkout"
                                                    class="btn btn-primary">
                                                    Tiến hành thanh toán
                                                </a>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Payment Methods -->
                                    <div class="card mt-3">
                                        <div class="card-body">
                                            <h6 class="mb-3">Chúng tôi chấp nhận:</h6>
                                            <div class="d-flex gap-2">
                                                <img src="${pageContext.request.contextPath}/assets/images/LogoVNPAY.png"
                                                    alt="VNpay" height="30">
                                                <img src="${pageContext.request.contextPath}/assets/images/LogoMoMo.png"
                                                    alt="Momo" height="30">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </section>

                <!-- Footer -->
                <jsp:include page="page/footer.jsp" />

                <!-- Scripts -->
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
                <script>
                    // Apply coupon
                    document.getElementById('applyCoupon').addEventListener('click', function () {
                        const couponCode = document.getElementById('couponCode').value.trim();
                        if (couponCode) {
                            // Submit form with coupon code
                            const form = document.createElement('form');
                            form.method = 'POST';
                            form.action = '${pageContext.request.contextPath}/cart';

                            const actionInput = document.createElement('input');
                            actionInput.type = 'hidden';
                            actionInput.name = 'action';
                            actionInput.value = 'applyCoupon';

                            const couponInput = document.createElement('input');
                            couponInput.type = 'hidden';
                            couponInput.name = 'couponCode';
                            couponInput.value = couponCode;

                            form.appendChild(actionInput);
                            form.appendChild(couponInput);
                            document.body.appendChild(form);
                            form.submit();
                        } else {
                            alert('Vui lòng nhập mã giảm giá!');
                        }
                    });
                </script>
            </body>

            </html>