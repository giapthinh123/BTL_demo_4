<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Đơn hàng - Fashion Shop</title>
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
                <a href="${pageContext.request.contextPath}/admin/orders" class="list-group-item list-group-item-action bg-transparent text-white active">
                    <i class="fas fa-shopping-cart me-2"></i>Đơn hàng
                </a>
                <a href="${pageContext.request.contextPath}/admin/users" class="list-group-item list-group-item-action bg-transparent text-white">
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
            
            <!-- Orders Content -->
            <div class="container-fluid p-4">
                <div class="row mb-4">
                    <div class="col">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h2>Quản lý Đơn hàng</h2>
                        </div>
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
                        <!-- Order Stats -->
                        <div class="row g-4 mb-4">
                            <div class="col-xl-3 col-md-6">
                                <div class="card bg-primary text-white h-100">
                                    <div class="card-body">
                                        <div class="d-flex justify-content-between align-items-center">
                                            <div>
                                                <h6 class="text-uppercase">Tổng đơn hàng</h6>
                                                <h2 class="mb-0">${totalOrders != null ? totalOrders : '150'}</h2>
                                            </div>
                                            <div>
                                                <i class="fas fa-shopping-cart fa-3x opacity-50"></i>
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
                                                <h6 class="text-uppercase">Đơn hoàn thành</h6>
                                                <h2 class="mb-0">${completedOders != null ? completedOders : '0'}</h2>
                                            </div>
                                            <div>
                                                <i class="fas fa-check-circle fa-3x opacity-50"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="col-xl-3 col-md-6">
                                <div class="card bg-warning text-white h-100">
                                    <div class="card-body">
                                        <div class="d-flex justify-content-between align-items-center">
                                            <div>
                                                <h6 class="text-uppercase">Đơn đang xử lý</h6>
                                                <h2 class="mb-0">${pendingOrders != null ? pendingOrders : '0'}</h2>
                                            </div>
                                            <div>
                                                <i class="fas fa-clock fa-3x opacity-50"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="col-xl-3 col-md-6">
                                <div class="card bg-danger text-white h-100">
                                    <div class="card-body">
                                        <div class="d-flex justify-content-between align-items-center">
                                            <div>
                                                <h6 class="text-uppercase">Đơn đã hủy</h6>
                                                <h2 class="mb-0">${cancelledOrders != null ? cancelledOrders : '0'}</h2>
                                            </div>
                                            <div>
                                                <i class="fas fa-times-circle fa-3x opacity-50"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Search and Filter -->
                        <div class="card mb-4">
                            <div class="card-body">
                                <form action="${pageContext.request.contextPath}/admin/orders" method="get" class="row g-3">
                                    <div class="col-md-3">
                                        <div class="input-group">
                                            <input type="text" class="form-control" placeholder="Tìm kiếm đơn hàng..." name="search" value="${param.search}">
                                            <button class="btn btn-outline-secondary" type="submit">
                                                <i class="fas fa-search"></i>
                                            </button>
                                        </div>
                                    </div>
                                    <div class="col-md-2">
                                        <select class="form-select" name="status">
                                            <option value="">Tất cả trạng thái</option>
                                            <option value="pending" ${param.status == 'pending' ? 'selected' : ''}>Chờ xác nhận</option>
                                            <option value="confirmed" ${param.status == 'confirmed' ? 'selected' : ''}>Đã xác nhận</option>
                                            <option value="shipping" ${param.status == 'shipping' ? 'selected' : ''}>Đang giao</option>
                                            <option value="completed" ${param.status == 'completed' ? 'selected' : ''}>Hoàn thành</option>
                                            <option value="cancelled" ${param.status == 'cancelled' ? 'selected' : ''}>Đã hủy</option>
                                        </select>
                                    </div>
                                    <div class="col-md-2">
                                        <select class="form-select" name="payment">
                                            <option value="">Tất cả phương thức</option>
                                            <option value="cod" ${param.payment == 'cod' ? 'selected' : ''}>Tiền mặt (COD)</option>
                                            <option value="VNPAY" ${param.payment == 'VNPAY' ? 'selected' : ''}>Thẻ tín dụng</option>
                                        </select>
                                    </div>
                                    <div class="col-md-2">
                                        <input type="date" class="form-control" name="fromDate" value="${param.fromDate}" placeholder="Từ ngày">
                                    </div>
                                    <div class="col-md-2">
                                        <input type="date" class="form-control" name="toDate" value="${param.toDate}" placeholder="Đến ngày">
                                    </div>
                                    <div class="col-md-1">
                                        <button type="submit" class="btn btn-primary w-100">Lọc</button>
                                    </div>
                                </form>
                            </div>
                        </div>

                        <!-- Orders Table -->
                        <div class="card">
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-hover align-middle">
                                        <thead class="table-light">
                                            <tr>
                                                <th scope="col">Mã đơn</th>
                                                <th scope="col">Khách hàng</th>
                                                <th scope="col">Ngày đặt</th>
                                                <th scope="col">Tổng tiền</th>
                                                <th scope="col">Thanh toán</th>
                                                <th scope="col">Trạng thái</th>
                                                <th scope="col" class="text-center">Thao tác</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${orders}" var="order">
                                                <tr>
                                                    <td><a href="${pageContext.request.contextPath}/admin/orders/detail?id=${order.orderId}" class="text-decoration-none">#${order.orderId}</a></td>
                                                    <td>${order.shippingName}</td>
                                                    <td>${order.orderDate}</td>
                                                    <td>${order.totalAmount}</td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${order.paymentMethod == 'cod'}">
                                                                <span class="badge bg-secondary">Tiền mặt (COD)</span>
                                                            </c:when>
                                                            <c:when test="${order.paymentMethod == 'VNPAY'}">
                                                                <span class="badge bg-primary">Thẻ tín dụng</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-secondary">${order.paymentMethod}</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${order.orderStatus == 'pending'}">
                                                                <span class="badge bg-primary">Chờ xác nhận</span>
                                                            </c:when>
                                                            <c:when test="${order.orderStatus == 'confirmed'}">
                                                                <span class="badge bg-info text-dark">Đã xác nhận</span>
                                                            </c:when>
                                                            <c:when test="${order.orderStatus == 'shipping'}">
                                                                <span class="badge bg-warning text-dark">Đang giao</span>
                                                            </c:when>
                                                            <c:when test="${order.orderStatus == 'completed'}">
                                                                <span class="badge bg-success">Hoàn thành</span>
                                                            </c:when>
                                                            <c:when test="${order.orderStatus == 'cancelled'}">
                                                                <span class="badge bg-danger">Đã hủy</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-secondary">${order.orderStatus}</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td class="text-center">
                                                        <div class="btn-group" role="group">
                                                            <a href="${pageContext.request.contextPath}/admin/orders/detail?id=${order.orderId}" class="btn btn-sm btn-outline-primary" title="Xem chi tiết">
                                                                <i class="fas fa-eye"></i>
                                                            </a>
                                                            <button type="button" class="btn btn-sm btn-outline-success updateStatusBtn" 
                                                                    data-bs-toggle="modal"
                                                                    data-bs-target="#updateStatusModal"
                                                                    data-id="${order.orderId}"
                                                                    data-code="${order.orderId}"
                                                                    data-status="${order.orderStatus}"
                                                                    onclick="updateOrderStatus(this)"
                                                                    title="Cập nhật trạng thái">
                                                                <i class="fas fa-edit"></i>
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
                                                    <c:set var="prevPageUrl" value="${pageContext.request.contextPath}/admin/orders?page=${currentPage - 1}"/>
                                                    <c:if test="${not empty param.search}"><c:set var="prevPageUrl" value="${prevPageUrl}&search=${param.search}"/></c:if>
                                                    <c:if test="${not empty param.status}"><c:set var="prevPageUrl" value="${prevPageUrl}&status=${param.status}"/></c:if>
                                                    <c:if test="${not empty param.payment}"><c:set var="prevPageUrl" value="${prevPageUrl}&payment=${param.payment}"/></c:if>
                                                    <c:if test="${not empty param.fromDate and param.fromDate != ''}"><c:set var="prevPageUrl" value="${prevPageUrl}&fromDate=${param.fromDate}"/></c:if>
                                                    <c:if test="${not empty param.toDate and param.toDate != ''}"><c:set var="prevPageUrl" value="${prevPageUrl}&toDate=${param.toDate}"/></c:if>
                                                    <a class="page-link" href="${prevPageUrl}" aria-label="Previous">
                                                        <span aria-hidden="true">&laquo;</span>
                                                    </a>
                                                </li>
                                            </c:if>

                                            <c:forEach begin="1" end="${totalPages}" var="i">
                                                <li class="page-item ${currentPage == i ? 'active' : ''}">
                                                    <c:set var="pageUrl" value="${pageContext.request.contextPath}/admin/orders?page=${i}"/>
                                                    <c:if test="${not empty param.search}"><c:set var="pageUrl" value="${pageUrl}&search=${param.search}"/></c:if>
                                                    <c:if test="${not empty param.status}"><c:set var="pageUrl" value="${pageUrl}&status=${param.status}"/></c:if>
                                                    <c:if test="${not empty param.payment}"><c:set var="pageUrl" value="${pageUrl}&payment=${param.payment}"/></c:if>
                                                    <c:if test="${not empty param.fromDate and param.fromDate != ''}"><c:set var="pageUrl" value="${pageUrl}&fromDate=${param.fromDate}"/></c:if>
                                                    <c:if test="${not empty param.toDate and param.toDate != ''}"><c:set var="pageUrl" value="${pageUrl}&toDate=${param.toDate}"/></c:if>
                                                    <a class="page-link" href="${pageUrl}">${i}</a>
                                                </li>
                                            </c:forEach>

                                            <c:if test="${currentPage < totalPages}">
                                                <li class="page-item">
                                                    <c:set var="nextPageUrl" value="${pageContext.request.contextPath}/admin/orders?page=${currentPage + 1}"/>
                                                    <c:if test="${not empty param.search}"><c:set var="nextPageUrl" value="${nextPageUrl}&search=${param.search}"/></c:if>
                                                    <c:if test="${not empty param.status}"><c:set var="nextPageUrl" value="${nextPageUrl}&status=${param.status}"/></c:if>
                                                    <c:if test="${not empty param.payment}"><c:set var="nextPageUrl" value="${nextPageUrl}&payment=${param.payment}"/></c:if>
                                                    <c:if test="${not empty param.fromDate and param.fromDate != ''}"><c:set var="nextPageUrl" value="${nextPageUrl}&fromDate=${param.fromDate}"/></c:if>
                                                    <c:if test="${not empty param.toDate and param.toDate != ''}"><c:set var="nextPageUrl" value="${nextPageUrl}&toDate=${param.toDate}"/></c:if>
                                                    <a class="page-link" href="${nextPageUrl}" aria-label="Next">
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

    <!-- Update Status Modal -->
    <div class="modal fade" id="updateStatusModal" tabindex="-1" aria-labelledby="updateStatusModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <form action="${pageContext.request.contextPath}/admin/orders/update-status" method="post">
                    <input type="hidden" id="orderId" name="orderId">
                    <div class="modal-header">
                        <h5 class="modal-title" id="updateStatusModalLabel">Cập nhật trạng thái đơn hàng #<span id="orderCode"></span></h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <label for="status" class="form-label">Trạng thái đơn hàng</label>
                            <select class="form-select" id="status" name="status" required>
                                <option value="pending">Chờ xác nhận</option>
                                <option value="confirmed">Đã xác nhận</option>
                                <option value="shipping">Đang giao</option>
                                <option value="completed">Hoàn thành</option>
                                <option value="cancelled">Đã hủy</option>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label for="note" class="form-label">Ghi chú</label>
                            <textarea class="form-control" id="note" name="note" rows="3"></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-primary">Cập nhật</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function updateOrderStatus(button) {
            const id = button.getAttribute('data-id');
            const code = button.getAttribute('data-code');
            const status = button.getAttribute('data-status');

            console.log('Button clicked - Order ID:', id);
            console.log('Button clicked - Order Code:', code);
            console.log('Button clicked - Status:', status);

            // Set the order ID in the hidden input
            document.getElementById('orderId').value = id;
            console.log('Hidden input value set to:', document.getElementById('orderId').value);
            
            // Set the order code in the modal title
            document.getElementById('orderCode').textContent = code;
            console.log('Modal title span set to:', document.getElementById('orderCode').textContent);
            
            // Set the current status in the select
            if (status) {
                document.getElementById('status').value = status;
                console.log('Status select set to:', document.getElementById('status').value);
            }

            // Show/hide email notification option based on status
            const sendEmailContainer = document.getElementById('sendEmailContainer');
            if (status === 'cancelled') {
                sendEmailContainer.classList.remove('d-none');
            } else {
                sendEmailContainer.classList.remove('d-none');
            }

            const updateStatusModal = new bootstrap.Modal(document.getElementById('updateStatusModal'));
            updateStatusModal.show();
        }

        // Toggle sidebar
        document.getElementById('sidebarToggle').addEventListener('click', function(e) {
            e.preventDefault();
            document.getElementById('wrapper').classList.toggle('toggled');
        });

        // Date range validation
        const fromDateInput = document.querySelector('input[name="fromDate"]');
        const toDateInput = document.querySelector('input[name="toDate"]');

        toDateInput.addEventListener('change', function() {
            if (fromDateInput.value && this.value) {
                if (new Date(this.value) < new Date(fromDateInput.value)) {
                    alert('Ngày kết thúc không thể trước ngày bắt đầu!');
                    this.value = '';
                }
            }
        });

        fromDateInput.addEventListener('change', function() {
            if (toDateInput.value && this.value) {
                if (new Date(toDateInput.value) < new Date(this.value)) {
                    alert('Ngày bắt đầu không thể sau ngày kết thúc!');
                    this.value = '';
                }
            }
        });
    </script>
</body>
</html>
