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
                <div class="d-flex" id="wrapper">
                    <!-- Sidebar -->
                    <div class="bg-dark text-white" id="sidebar-wrapper">
                        <div class="sidebar-heading p-3 border-bottom">
                            <h4 class="mb-0">Fashion Shop</h4>
                            <div class="small">Hệ thống quản trị</div>
                        </div>
                        <div class="list-group list-group-flush">
                            <a href="${pageContext.request.contextPath}/admin/reports/dashboard"
                                class="list-group-item list-group-item-action bg-transparent text-white">
                                <i class="fas fa-tachometer-alt me-2"></i>Tổng quan
                            </a>
                            <a href="${pageContext.request.contextPath}/admin/products"
                                class="list-group-item list-group-item-action bg-transparent text-white active">
                                <i class="fas fa-tshirt me-2"></i>Sản phẩm
                            </a>
                            <a href="${pageContext.request.contextPath}/admin/categories"
                                class="list-group-item list-group-item-action bg-transparent text-white">
                                <i class="fas fa-list me-2"></i>Danh mục
                            </a>
                            <a href="${pageContext.request.contextPath}/admin/orders"
                                class="list-group-item list-group-item-action bg-transparent text-white">
                                <i class="fas fa-shopping-cart me-2"></i>Đơn hàng
                            </a>
                            <a href="${pageContext.request.contextPath}/admin/users"
                                class="list-group-item list-group-item-action bg-transparent text-white">
                                <i class="fas fa-users me-2"></i>Người dùng
                            </a>
                        </div>
                    </div>

                    <!-- Page Content -->
                    <div id="page-content-wrapper">
                        <!-- Top Navigation -->
                        <nav class="navbar navbar-expand-lg navbar-light bg-light border-bottom">
                            <div class="container-fluid">
                                <div class="ms-auto d-flex">
                                    <div class="dropdown ms-3">
                                        <a class="nav-link dropdown-toggle" href="#" role="button" id="userDropdown"
                                           data-bs-toggle="dropdown" aria-expanded="false">
                                            <span class="ms-2 d-none d-lg-inline">Admin</span>
                                        </a>
                                        <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout"><i
                                                    class="fas fa-sign-out-alt me-2"></i>Đăng xuất</a></li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </nav>

                        <!-- Product Form Content -->
                        <div class="container-fluid p-4">
                            <div class="row mb-4">
                                <div class="col">
                                    <div class="d-flex justify-content-between align-items-center mb-4">
                                        <h2>${user.userId == 0 ? 'Thêm mới' : 'Chỉnh sửa'} Người dùng</h2>
                                        <a href="${pageContext.request.contextPath}/admin/users"
                                            class="btn btn-outline-secondary">
                                            <i class="fas fa-arrow-left me-2"></i>Quay lại
                                        </a>
                                    </div>
                                    <!-- Product Form -->
                                    <div class="card">
                                        <div class="card-body">
                                            <c:choose>
                                                <c:when test="${user.userId == 0}">
                                                    <form
                                                        action="${pageContext.request.contextPath}/admin/users/save"
                                                        method="post" id="userForm">
                                                </c:when>
                                                <c:otherwise>
                                                    <form
                                                        action="${pageContext.request.contextPath}/admin/users/update"
                                                        method="post" id="userForm">
                                                </c:otherwise>
                                            </c:choose>
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
                                                                    name="password" ${empty user.userId ? 'required' : ''}>
                                                                <small class="text-muted">${not empty user.userId ? 'Để trống nếu không muốn thay đổi mật khẩu' : ''}</small>
                                                            </div>

                                                            <div class="mb-3">
                                                                <label for="email" class="form-label">Email <span
                                                                        class="text-danger">*</span></label>
                                                                <input type="email" class="form-control" id="email"
                                                                    name="email" value="${user.email}" required>
                                                            </div>

                                                            <div class="mb-3">
                                                                <label for="fullName" class="form-label">Họ và tên <span
                                                                        class="text-danger">*</span></label>
                                                                <input type="text" class="form-control" id="fullName"
                                                                    name="fullName" value="${user.fullName}" required>
                                                            </div>

                                                            <div class="mb-3">
                                                                <label for="phone" class="form-label">Số điện thoại</label>
                                                                <input type="tel" class="form-control" id="phone"
                                                                    name="phone" value="${user.phone}">
                                                            </div>

                                                            <div class="mb-3">
                                                                <label for="address" class="form-label">Địa chỉ</label>
                                                                <textarea class="form-control" id="address"
                                                                    name="address" rows="2">${user.address}</textarea>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- Sidebar -->
                                                <div class="col-lg-4">
                                                    <!-- User Role -->
                                                    <div class="card mb-4">
                                                        <div class="card-header">
                                                            <h5 class="mb-0">Vai trò</h5>
                                                        </div>
                                                        <div class="card-body">
                                                            <div class="mb-3">
                                                                <select class="form-select" id="role" name="role" required>
                                                                    <option value="">Chọn vai trò</option>
                                                                    <c:forEach items="${roles}" var="role">
                                                                        <option value="${role}"
                                                                            ${user.role == role ? 'selected' : ''}>
                                                                            ${role}
                                                                        </option>
                                                                    </c:forEach>
                                                                </select>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <!-- User Status -->
                                                    <div class="card mb-4">
                                                        <div class="card-header">
                                                            <h5 class="mb-0">Trạng thái</h5>
                                                        </div>
                                                        <div class="card-body">
                                                            <div class="form-check form-switch mb-3">
                                                                <input class="form-check-input" type="checkbox"
                                                                    id="active" name="active" ${user.active ? 'checked' : ''}>
                                                                <label class="form-check-label" for="active">Đang hoạt động</label>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="d-flex justify-content-end mt-4">
                                                <a href="${pageContext.request.contextPath}/admin/users"
                                                    class="btn btn-secondary me-2">Hủy</a>
                                                <button type="submit" class="btn btn-primary">Lưu người dùng</button>
                                            </div>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Scripts -->
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                <script src="https://cdn.tiny.cloud/1/no-api-key/tinymce/5/tinymce.min.js"
                    referrerpolicy="origin"></script>
                <script>
                </script>
            </body>

            </html>