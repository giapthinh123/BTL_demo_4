<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Quản lý Đơn hàng - Fashion Shop</title>
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        </head>

        <body>
            <jsp:include page="page/header.jsp" />
            <div class="d-flex" id="wrapper">

                <!-- Orders Content -->
                <div class="container-fluid p-4">
                    <div class="row mb-4">
                        <div class="col">
                            <div class="d-flex justify-content-between align-items-center mb-4">
                                <h2>Theo dõi Đơn hàng</h2>
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
                            <!-- Search and Filter -->
                            <div class="card mb-4">
                                <div class="card-body">
                                    <form action="${pageContext.request.contextPath}/account/orders" method="get"
                                        class="row g-3">
                                        <div class="col-md-3">
                                            <div class="input-group">
                                                <input type="text" class="form-control"
                                                    placeholder="Tìm kiếm đơn hàng..." name="search"
                                                    value="${param.search}">
                                                <button class="btn btn-outline-secondary" type="submit">
                                                    <i class="fas fa-search"></i>
                                                </button>
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <select class="form-select" name="status">
                                                <option value="">Tất cả trạng thái</option>
                                                <option value="pending" ${param.status=='pending' ? 'selected' : '' }>
                                                    Chờ xác nhận</option>
                                                <option value="confirmed" ${param.status=='confirmed' ? 'selected' : ''
                                                    }>Đã xác nhận</option>
                                                <option value="shipping" ${param.status=='shipping' ? 'selected' : '' }>
                                                    Đang giao</option>
                                                <option value="completed" ${param.status=='completed' ? 'selected' : ''
                                                    }>Hoàn thành</option>
                                                <option value="cancelled" ${param.status=='cancelled' ? 'selected' : ''
                                                    }>Đã hủy</option>
                                            </select>
                                        </div>
                                        <div class="col-md-2">
                                            <select class="form-select" name="payment">
                                                <option value="">Tất cả phương thức</option>
                                                <option value="cod" ${param.payment=='cod' ? 'selected' : '' }>Tiền mặt
                                                    (COD)</option>
                                                <option value="VNPAY" ${param.payment=='VNPAY' ? 'selected' : '' }>Thẻ
                                                    tín dụng</option>
                                            </select>
                                        </div>
                                        <div class="col-md-2">
                                            <input type="date" class="form-control" name="fromDate"
                                                value="${param.fromDate}" placeholder="Từ ngày">
                                        </div>
                                        <div class="col-md-2">
                                            <input type="date" class="form-control" name="toDate"
                                                value="${param.toDate}" placeholder="Đến ngày">
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
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach items="${orders}" var="order">
                                                    <tr>
                                                        <td>${order.orderId}</td>
                                                        <td>${order.shippingName}</td>
                                                        <td>${order.orderDate}</td>
                                                        <td>${order.totalAmount}</td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${order.paymentMethod == 'cod'}">
                                                                    <span class="badge bg-secondary">Tiền mặt
                                                                        (COD)</span>
                                                                </c:when>
                                                                <c:when test="${order.paymentMethod == 'VNPAY'}">
                                                                    <span class="badge bg-primary">Thẻ tín dụng</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span
                                                                        class="badge bg-secondary">${order.paymentMethod}</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${order.orderStatus == 'pending'}">
                                                                    <span class="badge bg-primary">Chờ xác nhận</span>
                                                                </c:when>
                                                                <c:when test="${order.orderStatus == 'confirmed'}">
                                                                    <span class="badge bg-info text-dark">Đã xác
                                                                        nhận</span>
                                                                </c:when>
                                                                <c:when test="${order.orderStatus == 'shipping'}">
                                                                    <span class="badge bg-warning text-dark">Đang
                                                                        giao</span>
                                                                </c:when>
                                                                <c:when test="${order.orderStatus == 'completed'}">
                                                                    <span class="badge bg-success">Hoàn thành</span>
                                                                </c:when>
                                                                <c:when test="${order.orderStatus == 'cancelled'}">
                                                                    <span class="badge bg-danger">Đã hủy</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span
                                                                        class="badge bg-secondary">${order.orderStatus}</span>
                                                                </c:otherwise>
                                                            </c:choose>
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
                                                        <c:set var="prevPageUrl"
                                                            value="${pageContext.request.contextPath}/account/orders?page=${currentPage - 1}" />
                                                        <c:if test="${not empty param.search}">
                                                            <c:set var="prevPageUrl"
                                                                value="${prevPageUrl}&search=${param.search}" />
                                                        </c:if>
                                                        <c:if test="${not empty param.status}">
                                                            <c:set var="prevPageUrl"
                                                                value="${prevPageUrl}&status=${param.status}" />
                                                        </c:if>
                                                        <c:if test="${not empty param.payment}">
                                                            <c:set var="prevPageUrl"
                                                                value="${prevPageUrl}&payment=${param.payment}" />
                                                        </c:if>
                                                        <c:if
                                                            test="${not empty param.fromDate and param.fromDate != ''}">
                                                            <c:set var="prevPageUrl"
                                                                value="${prevPageUrl}&fromDate=${param.fromDate}" />
                                                        </c:if>
                                                        <c:if test="${not empty param.toDate and param.toDate != ''}">
                                                            <c:set var="prevPageUrl"
                                                                value="${prevPageUrl}&toDate=${param.toDate}" />
                                                        </c:if>
                                                        <a class="page-link" href="${prevPageUrl}"
                                                            aria-label="Previous">
                                                            <span aria-hidden="true">&laquo;</span>
                                                        </a>
                                                    </li>
                                                </c:if>

                                                <c:forEach begin="1" end="${totalPages}" var="i">
                                                    <li class="page-item ${currentPage == i ? 'active' : ''}">
                                                        <c:set var="pageUrl"
                                                            value="${pageContext.request.contextPath}/account/orders?page=${i}" />
                                                        <c:if test="${not empty param.search}">
                                                            <c:set var="pageUrl"
                                                                value="${pageUrl}&search=${param.search}" />
                                                        </c:if>
                                                        <c:if test="${not empty param.status}">
                                                            <c:set var="pageUrl"
                                                                value="${pageUrl}&status=${param.status}" />
                                                        </c:if>
                                                        <c:if test="${not empty param.payment}">
                                                            <c:set var="pageUrl"
                                                                value="${pageUrl}&payment=${param.payment}" />
                                                        </c:if>
                                                        <c:if
                                                            test="${not empty param.fromDate and param.fromDate != ''}">
                                                            <c:set var="pageUrl"
                                                                value="${pageUrl}&fromDate=${param.fromDate}" />
                                                        </c:if>
                                                        <c:if test="${not empty param.toDate and param.toDate != ''}">
                                                            <c:set var="pageUrl"
                                                                value="${pageUrl}&toDate=${param.toDate}" />
                                                        </c:if>
                                                        <a class="page-link" href="${pageUrl}">${i}</a>
                                                    </li>
                                                </c:forEach>

                                                <c:if test="${currentPage < totalPages}">
                                                    <li class="page-item">
                                                        <c:set var="nextPageUrl"
                                                            value="${pageContext.request.contextPath}/account/orders?page=${currentPage + 1}" />
                                                        <c:if test="${not empty param.search}">
                                                            <c:set var="nextPageUrl"
                                                                value="${nextPageUrl}&search=${param.search}" />
                                                        </c:if>
                                                        <c:if test="${not empty param.status}">
                                                            <c:set var="nextPageUrl"
                                                                value="${nextPageUrl}&status=${param.status}" />
                                                        </c:if>
                                                        <c:if test="${not empty param.payment}">
                                                            <c:set var="nextPageUrl"
                                                                value="${nextPageUrl}&payment=${param.payment}" />
                                                        </c:if>
                                                        <c:if
                                                            test="${not empty param.fromDate and param.fromDate != ''}">
                                                            <c:set var="nextPageUrl"
                                                                value="${nextPageUrl}&fromDate=${param.fromDate}" />
                                                        </c:if>
                                                        <c:if test="${not empty param.toDate and param.toDate != ''}">
                                                            <c:set var="nextPageUrl"
                                                                value="${nextPageUrl}&toDate=${param.toDate}" />
                                                        </c:if>
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
            <jsp:include page="page/footer.jsp" />
            <!-- Scripts -->
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            <script>

                // Toggle sidebar
                document.getElementById('sidebarToggle').addEventListener('click', function (e) {
                    e.preventDefault();
                    document.getElementById('wrapper').classList.toggle('toggled');
                });

                // Date range validation
                const fromDateInput = document.querySelector('input[name="fromDate"]');
                const toDateInput = document.querySelector('input[name="toDate"]');

                toDateInput.addEventListener('change', function () {
                    if (fromDateInput.value && this.value) {
                        if (new Date(this.value) < new Date(fromDateInput.value)) {
                            alert('Ngày kết thúc không thể trước ngày bắt đầu!');
                            this.value = '';
                        }
                    }
                });

                fromDateInput.addEventListener('change', function () {
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