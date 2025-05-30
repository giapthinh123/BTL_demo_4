<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Người dùng - Fashion Shop</title>
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
                <a href="${pageContext.request.contextPath}/admin/products" class="list-group-item list-group-item-action bg-transparent text-white">
                    <i class="fas fa-tshirt me-2"></i>Sản phẩm
                </a>
                <a href="${pageContext.request.contextPath}/admin/categories" class="list-group-item list-group-item-action bg-transparent text-white">
                    <i class="fas fa-list me-2"></i>Danh mục
                </a>
                <a href="${pageContext.request.contextPath}/admin/orders" class="list-group-item list-group-item-action bg-transparent text-white">
                    <i class="fas fa-shopping-cart me-2"></i>Đơn hàng
                </a>
                <a href="${pageContext.request.contextPath}/admin/users" class="list-group-item list-group-item-action bg-transparent text-white active">
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
            
            <!-- Users Content -->
            <div class="container-fluid p-4">
                <div class="row mb-4">
                    <div class="col">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h2>Quản lý Người dùng</h2>
                            <a href="${pageContext.request.contextPath}/admin/users/new" class="btn btn-primary">
                                <i class="fas fa-plus me-2"></i>Thêm người dùng mới
                            </a>
                        </div>
                        
                        <!-- Alert for messages -->
                        <c:if test="${not empty message}">
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                ${message}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>
                        
                        <!-- Alert for errors -->
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                ${error}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>
                        
                        <!-- User Stats -->
                        <div class="row g-4 mb-4">
                            <div class="col-xl-3 col-md-6">
                                <div class="card bg-primary text-white h-100">
                                    <div class="card-body">
                                        <div class="d-flex justify-content-between align-items-center">
                                            <div>
                                                <h6 class="text-uppercase">Tổng người dùng</h6>
                                                <h2 class="mb-0">${totalUsers != null ? totalUsers : '120'}</h2>
                                            </div>
                                            <div>
                                                <i class="fas fa-users fa-3x opacity-50"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="col-xl-3 col-md-6">
                                <div class="card bg-success text-white h-100">
                                    <div class="card-body">
                                        <div class="d-flex justify-content-between align-items-center">
                                            <div>
                                                <h6 class="text-uppercase">Khách hàng</h6>
                                                <h2 class="mb-0">${customerCount != null ? customerCount : '110'}</h2>
                                            </div>
                                            <div>
                                                <i class="fas fa-user fa-3x opacity-50"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="col-xl-3 col-md-6">
                                <div class="card bg-info text-white h-100">
                                    <div class="card-body">
                                        <div class="d-flex justify-content-between align-items-center">
                                            <div>
                                                <h6 class="text-uppercase">Quản trị viên</h6>
                                                <h2 class="mb-0">${adminCount != null ? adminCount : '10'}</h2>
                                            </div>
                                            <div>
                                                <i class="fas fa-user-shield fa-3x opacity-50"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Search and Filter -->
                        <div class="card mb-4">
                            <div class="card-body">
                                <form action="${pageContext.request.contextPath}/admin/users" method="get" class="row g-3">
                                    <div class="col-md-4">
                                        <div class="input-group">
                                            <input type="text" class="form-control" placeholder="Tìm kiếm người dùng..." name="search" value="${param.search}">
                                            <button class="btn btn-outline-secondary" type="submit">
                                                <i class="fas fa-search"></i>
                                            </button>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <select class="form-select" name="role">
                                            <option value="">Tất cả vai trò</option>
                                            <option value="admin" ${param.role == 'admin' ? 'selected' : ''}>Quản trị viên</option>
                                            <option value="customer" ${param.role == 'customer' ? 'selected' : ''}>Khách hàng</option>
                                        </select>
                                    </div>
                                    <div class="col-md-3">
                                        <select class="form-select" name="status">
                                            <option value="">Tất cả trạng thái</option>
                                            <option value="active" ${param.status == 'active' ? 'selected' : ''}>Hoạt động</option>
                                            <option value="inactive" ${param.status == 'inactive' ? 'selected' : ''}>Không hoạt động</option>
                                        </select>
                                    </div>
                                    <div class="col-md-2">
                                        <button type="submit" class="btn btn-primary w-100">Lọc</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                        
                        <!-- Users Table -->
                        <div class="card">
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-hover align-middle">
                                        <thead class="table-light">
                                            <tr>
                                                <th scope="col">ID</th>
                                                <th scope="col">Người dùng</th>
                                                <th scope="col">Email</th>
                                                <th scope="col">Số điện thoại</th>
                                                <th scope="col">Vai trò</th>
                                                <th scope="col">Trạng thái</th>
                                                <th scope="col" class="text-center">Thao tác</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${users}" var="user">
                                                <tr>
                                                    <td>${user.userId}</td>
                                                    <td>
                                                        <div class="d-flex align-items-center">
                                                            <div class="avatar-placeholder bg-secondary text-white rounded-circle me-2 d-flex align-items-center justify-content-center" style="width: 40px; height: 40px;">
                                                                <span>${fn:substring(user.fullName, 0, 1)}</span>
                                                            </div>
                                                            <div>
                                                                <div class="fw-bold">${user.fullName}</div>
                                                                <div class="small text-muted">@${user.username}</div>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td>${user.email}</td>
                                                    <td><c:choose>
                                                        <c:when test="${empty user.phone}">trống</c:when>
                                                        <c:otherwise>
                                                            ${user.phone}
                                                        </c:otherwise>
                                                    </c:choose>

                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${user.role == 'ADMIN'}">
                                                                <span class="badge bg-primary">Quản trị viên</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-secondary">Khách hàng</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${user.status == '1'}">
                                                                <span class="badge bg-success">Hoạt động</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-danger">Không hoạt động</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td class="text-center">
                                                        <div class="btn-group" role="group">
                                                            <a href="${pageContext.request.contextPath}/admin/users/edit?id=${user.userId}" class="btn btn-sm btn-outline-success" title="Chỉnh sửa">
                                                                <i class="fas fa-edit"></i>
                                                            </a>
                                                            <button type="button" class="btn btn-sm btn-outline-danger deleteUserBtn" 
                                                                    data-id="${user.userId}"
                                                                    data-name="${user.fullName}"
                                                                    title="Xóa">
                                                                <i class="fas fa-trash-alt"></i>
                                                            </button>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                                
                                <!-- Pagination -->
                                <c:if test="${totalPages > 1}">
                                    <nav class="mt-4">
                                        <ul class="pagination justify-content-center">
                                            <c:if test="${currentPage > 1}">
                                                <li class="page-item">
                                                    <a class="page-link" href="${pageContext.request.contextPath}/admin/users?page=${currentPage - 1}${not empty param.search ? '&search=' + param.search : ''}${not empty param.role ? '&role=' + param.role : ''}${not empty param.status ? '&status=' + param.status : ''}" aria-label="Previous">
                                                        <span aria-hidden="true">&laquo;</span>
                                                    </a>
                                                </li>
                                            </c:if>
                                            
                                            <c:forEach begin="1" end="${totalPages}" var="i">
                                                <li class="page-item ${currentPage == i ? 'active' : ''}">
                                                    <a class="page-link" href="${pageContext.request.contextPath}/admin/users?page=${i}${not empty param.search ? '&search=' + param.search : ''}${not empty param.role ? '&role=' + param.role : ''}${not empty param.status ? '&status=' + param.status : ''}">${i}</a>
                                                </li>
                                            </c:forEach>
                                            
                                            <c:if test="${currentPage < totalPages}">
                                                <li class="page-item">
                                                    <a class="page-link" href="${pageContext.request.contextPath}/admin/users?page=${currentPage + 1}${not empty param.search ? '&search=' + param.search : ''}${not empty param.role ? '&role=' + param.role : ''}${not empty param.status ? '&status=' + param.status : ''}" aria-label="Next">
                                                        <span aria-hidden="true">&raquo;</span>
                                                    </a>
                                                </li>
                                            </c:if>
                                        </ul>
                                    </nav>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Delete User Modal -->
    <div class="modal fade" id="deleteUserModal" tabindex="-1" aria-labelledby="deleteUserModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <form action="${pageContext.request.contextPath}/admin/users/delete" method="post">
                    <input type="hidden" id="deleteUserId" name="userId">
                    <div class="modal-header">
                        <h5 class="modal-title" id="deleteUserModalLabel">Xác nhận xóa người dùng</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <p>Bạn có chắc chắn muốn xóa người dùng <span id="deleteUserName" class="fw-bold"></span>?</p>
                        <p class="text-danger">Lưu ý: Hành động này không thể hoàn tác và sẽ xóa tất cả dữ liệu liên quan đến người dùng này.</p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-danger">Xóa</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Toggle sidebar
        document.getElementById('sidebarToggle').addEventListener('click', function(e) {
            e.preventDefault();
            document.getElementById('wrapper').classList.toggle('toggled');
        });
        
        // Delete user confirmation
        document.querySelectorAll('.deleteUserBtn').forEach(button => {
            button.addEventListener('click', function() {
                const id = this.getAttribute('data-id');
                const name = this.getAttribute('data-name');
                
                document.getElementById('deleteUserId').value = id;
                document.getElementById('deleteUserName').textContent = name;
                
                const deleteUserModal = new bootstrap.Modal(document.getElementById('deleteUserModal'));
                deleteUserModal.show();
            });
        });
    </script>
</body>
</html>
