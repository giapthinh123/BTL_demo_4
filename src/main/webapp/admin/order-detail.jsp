<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết Đơn hàng - Fashion Shop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <div class="container py-5">
        <div class="row mb-4">
            <div class="col">
                <div class="d-flex justify-content-between align-items-center">
                    <h2>Chi tiết Đơn hàng #${order.orderId != null ? order.orderId : '1234'}</h2>
                    <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-outline-secondary">
                        <i class="fas fa-arrow-left me-2"></i>Quay lại
                    </a>
                </div>
            </div>
        </div>

        <div class="row g-4">
            <!-- Thông tin khách hàng -->
            <div class="col-md-4">
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0">Thông tin khách hàng</h5>
                    </div>
                    <div class="card-body">
                        <div class="mb-3">
                            <p class="mb-1 text-muted">Họ tên</p>
                            <p class="fw-bold">${order.shippingName != null ? order.shippingName : 'Nguyễn Văn A'}</p>
                        </div>
                        <div class="mb-3">
                            <p class="mb-1 text-muted">Email</p>
                            <p class="fw-bold">${order.shippingEmail != null ? order.shippingEmail : 'nguyenvana@example.com'}</p>
                        </div>
                        <div class="mb-3">
                            <p class="mb-1 text-muted">Số điện thoại</p>
                            <p class="fw-bold">${order.shippingPhone != null ? order.shippingPhone : '0987654321'}</p>
                        </div>
                        <div class="mb-3">
                            <p class="mb-1 text-muted">Địa chỉ giao hàng</p>
                            <p class="fw-bold">${order.shippingAddress != null ? order.shippingAddress : '123 Đường Lê Lợi, Phường Bến Nghé, Quận 1, TP. Hồ Chí Minh'}</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Chi tiết đơn hàng -->
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0">Chi tiết đơn hàng</h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>Sản phẩm</th>
                                        <th>Đơn giá</th>
                                        <th>Số lượng</th>
                                        <th class="text-end">Thành tiền</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${orderItems}" var="item" varStatus="loopStatus">
                                        <tr>
                                            <td>
                                                <div class="d-flex align-items-center">
                                                    <img src="${pageContext.request.contextPath}/${item.productImage}" class="img-thumbnail me-3" alt="${item.productName}" width="50">
                                                    <div>
                                                        <div class="fw-bold">${item.productName}</div>
                                                        <div class="small text-muted">
                                                            <small class="text-muted">${variant[loopStatus.index].size} ${variant[loopStatus.index].color}</small>
                                                        </div>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>${item.price}</td>
                                            <td>${item.quantity}</td>
                                            <td class="text-end">${item.subtotal}</td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
