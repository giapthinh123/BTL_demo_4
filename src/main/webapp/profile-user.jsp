<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
        <%--<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>--%>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Thêm/Sửa Sản phẩm - Fashion Shop</title>
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-style.css">
            </head>

            <body>
                <jsp:include page="page/header.jsp" />

                <!-- Product Form Content -->
                <div class="container-fluid p-4">
                    <c:if test="${not empty message}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                                ${message}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"
                                    aria-label="Close"></button>
                        </div>
                    </c:if>

                    <!-- Alert for errors -->
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                ${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"
                                    aria-label="Close"></button>
                        </div>
                    </c:if>
                    <div class="row mb-4">
                        <div class="col">
                            <div class="d-flex justify-content-between align-items-center mb-4">
                                <h2>Thông tin người dùng</h2>
                                <a href="${pageContext.request.contextPath}/products" class="btn btn-outline-secondary">
                                    <i class="fas fa-arrow-left me-2"></i>Quay lại
                                </a>
                            </div>
                            <!-- Product Form -->
                            <div class="card">
                                <div class="card-body">
                                    <form action="${pageContext.request.contextPath}/account/update"
                                          method="post" id="userForm">
                                    <input type="hidden" name="userId" value="${user.userId}">
                                    <div class="row g-4">
                                        <!-- Basic Information -->
                                        <div class="col-lg-8">
                                            <div class="card mb-4">
                                                <div class="card-header">
                                                    <h5 class="mb-0">Thông tin cơ bản</h5>
                                                </div>
                                                <div class="card-body">
                                                    <div class="mb-3">
                                                        <label for="username" class="form-label">Tên đăng nhập <span
                                                                class="text-danger">*</span></label>
                                                        <input type="text" class="form-control" id="username"
                                                            name="username" value="${user.username}" required>
                                                    </div>

                                                    <div class="mb-3">
                                                        <label for="password" class="form-label">Mật khẩu <span
                                                                class="text-danger">*</span></label>
                                                        <input type="password" class="form-control" id="password"
                                                            name="password" ${empty user.userId ? 'required' : '' }>
                                                        <small class="text-muted">${not empty user.userId ?
                                                        'Nhập vào đây nếu muốn thay đổi mật khẩu' : ''}</small>
                                                    </div>

                                                    <div class="mb-3">
                                                        <label for="email" class="form-label">Email <span
                                                                class="text-danger">*</span></label>
                                                        <input type="email" class="form-control" id="email" name="email"
                                                            value="${user.email}" required>
                                                    </div>

                                                    <div class="mb-3">
                                                        <label for="fullName" class="form-label">Họ và tên <span
                                                                class="text-danger">*</span></label>
                                                        <input type="text" class="form-control" id="fullName"
                                                            name="fullName" value="${user.fullName}" required>
                                                    </div>

                                                    <div class="mb-3">
                                                        <label for="phone" class="form-label">Số điện thoại</label>
                                                        <input type="tel" class="form-control" id="phone" name="phone"
                                                            value="${user.phone}">
                                                    </div>

                                                    <div class="mb-3">
                                                        <label for="address" class="form-label">Địa chỉ</label>
                                                        <textarea class="form-control" id="address" name="address"
                                                            rows="2">${user.address}</textarea>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Sidebar -->
                                        <div class="col-lg-4">
                                            <!-- User Status -->
                                            <div class="card mb-4">
                                                <div class="card-header">
                                                    <h5 class="mb-0">Trạng thái</h5>
                                                </div>
                                                <div class="card-body">
                                                    <div class="form-check form-switch mb-3">
                                                        <input class="form-check-input" type="checkbox" id="active"
                                                            name="active" ${user.active ? 'checked' : '' }>
                                                        <label class="form-check-label" for="active">Đang hoạt
                                                            động</label>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="d-flex justify-content-end mt-4">
                                        <a href="${pageContext.request.contextPath}/products"
                                            class="btn btn-secondary me-2">Hủy</a>
                                        <button type="submit" class="btn btn-primary">Lưu tài khoản</button>
                                    </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <jsp:include page="page/footer.jsp" />
                <!-- Scripts -->
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                <script src="https://cdn.tiny.cloud/1/no-api-key/tinymce/5/tinymce.min.js"
                    referrerpolicy="origin"></script>
            </body>

            </html>