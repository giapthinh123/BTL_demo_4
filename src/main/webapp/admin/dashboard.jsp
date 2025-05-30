<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Quản trị - Fashion Shop</title>
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
                            class="list-group-item list-group-item-action bg-transparent text-white active">
                            <i class="fas fa-tachometer-alt me-2"></i>Tổng quan
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/products"
                            class="list-group-item list-group-item-action bg-transparent text-white">
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

                    <!-- Dashboard Content -->
                    <div class="container-fluid p-4">
                        <div class="row mb-4">
                            <div class="col">
                                <h2 class="mb-4">Tổng quan</h2>

                                <!-- Stats Cards -->
                                <div class="row g-4 mb-4">
                                    <div class="col-xl-3 col-md-6">
                                        <div class="card bg-primary text-white h-100">
                                            <div class="card-body">
                                                <div class="d-flex justify-content-between align-items-center">
                                                    <div>
                                                        <h6 class="text-uppercase">Đơn hàng</h6>
                                                        <h2 class="mb-0"><fmt:formatNumber value="${totalOrders}" type="number"/></h2>
                                                    </div>
                                                    <div>
                                                        <i class="fas fa-shopping-cart fa-3x opacity-50"></i>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="card-footer d-flex align-items-center justify-content-between">
                                                <a href="${pageContext.request.contextPath}/admin/orders"
                                                    class="text-white-50 text-decoration-none">Xem chi tiết</a>
                                                <div class="small text-white"><i class="fas fa-angle-right"></i></div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="col-xl-3 col-md-6">
                                        <div class="card bg-success text-white h-100">
                                            <div class="card-body">
                                                <div class="d-flex justify-content-between align-items-center">
                                                    <div>
                                                        <h6 class="text-uppercase">Doanh thu</h6>
                                                        <h2 class="mb-0"><fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="₫"/></h2>
                                                    </div>
                                                    <div>
                                                        <i class="fas fa-money-bill-wave fa-3x opacity-50"></i>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="card-footer d-flex align-items-center justify-content-between">
                                                <a href="${pageContext.request.contextPath}/admin/reports"
                                                    class="text-white-50 text-decoration-none">Xem chi tiết</a>
                                                <div class="small text-white"><i class="fas fa-angle-right"></i></div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="col-xl-3 col-md-6">
                                        <div class="card bg-warning text-white h-100">
                                            <div class="card-body">
                                                <div class="d-flex justify-content-between align-items-center">
                                                    <div>
                                                        <h6 class="text-uppercase">Sản phẩm</h6>
                                                        <h2 class="mb-0"><fmt:formatNumber value="${totalProducts}" type="number"/></h2>
                                                    </div>
                                                    <div>
                                                        <i class="fas fa-tshirt fa-3x opacity-50"></i>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="card-footer d-flex align-items-center justify-content-between">
                                                <a href="${pageContext.request.contextPath}/admin/products"
                                                    class="text-white-50 text-decoration-none">Xem chi tiết</a>
                                                <div class="small text-white"><i class="fas fa-angle-right"></i></div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="col-xl-3 col-md-6">
                                        <div class="card bg-danger text-white h-100">
                                            <div class="card-body">
                                                <div class="d-flex justify-content-between align-items-center">
                                                    <div>
                                                        <h6 class="text-uppercase">Khách hàng</h6>
                                                        <h2 class="mb-0"><fmt:formatNumber value="${totalCustomers}" type="number"/></h2>
                                                    </div>
                                                    <div>
                                                        <i class="fas fa-users fa-3x opacity-50"></i>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="card-footer d-flex align-items-center justify-content-between">
                                                <a href="${pageContext.request.contextPath}/admin/users"
                                                    class="text-white-50 text-decoration-none">Xem chi tiết</a>
                                                <div class="small text-white"><i class="fas fa-angle-right"></i></div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Recent Orders & Sales Chart -->
                                <div class="row g-4 mb-4">
                                    <div class="col-xl-8">
                                        <div class="card h-100">
                                            <div class="card-header d-flex justify-content-between align-items-center">
                                                <h5 class="mb-0">Doanh thu theo thời gian</h5>
                                                <div class="dropdown">
                                                    <button class="btn btn-sm btn-outline-secondary dropdown-toggle"
                                                        type="button" id="chartTimeRange" data-bs-toggle="dropdown"
                                                        aria-expanded="false">
                                                        <span id="chartTimeRangeText">Hôm nay</span>
                                                    </button>
                                                    <ul class="dropdown-menu dropdown-menu-end"
                                                        aria-labelledby="chartTimeRange">
                                                        <li><button class="dropdown-item" onclick="submitTimeRange('day'); return false;">Hôm nay</button></li>
                                                        <li><button class="dropdown-item" onclick="submitTimeRange('week'); return false;">7 ngày qua</button></li>
                                                        <li><button class="dropdown-item" onclick="submitTimeRange('month'); return false;">Tháng này</button></li>
                                                        <li><button class="dropdown-item" onclick="submitTimeRange('quarter'); return false;">Quý này</button></li>
                                                        <li><button class="dropdown-item" onclick="submitTimeRange('year'); return false;">Năm nay</button></li>
                                                    </ul>
                                                </div>
                                            </div>
                                            <div class="card-body" style="height: 400px;">
                                                <canvas id="salesChart" style="display: block; box-sizing: border-box; height: 100%;"></canvas>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Scripts -->
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
            <script>
                function submitTimeRange(range) {
                    const form = document.createElement('form');
                    form.method = 'GET';
                    form.action = '${pageContext.request.contextPath}/admin/reports/dashboard';
                    
                    const input = document.createElement('input');
                    input.type = 'hidden';
                    input.name = 'timeRange';
                    input.value = range;
                    
                    form.appendChild(input);
                    document.body.appendChild(form);
                    form.submit();
                }

                // Add click handlers only for chartTimeRange dropdown items
                document.querySelectorAll('#chartTimeRange + .dropdown-menu .dropdown-item').forEach(item => {
                    item.addEventListener('click', function(e) {
                        e.preventDefault();
                        const text = this.textContent;
                        document.getElementById('chartTimeRangeText').textContent = text;
                        const range = this.getAttribute('onclick').match(/'([^']+)'/)[1];
                        submitTimeRange(range);
                    });
                });

                // Initialize the chart
                const salesChart = new Chart(document.getElementById('salesChart'), {
                    type: 'line',
                    data: {
                        labels: [
                            <c:forEach items="${salesData}" var="item" varStatus="status">
                                '${item.date}'${!status.last ? ',' : ''}
                            </c:forEach>
                        ],
                        datasets: [{
                            label: 'Doanh thu',
                            data: [
                                <c:forEach items="${salesData}" var="item" varStatus="status">
                                    ${item.total}${!status.last ? ',' : ''}
                                </c:forEach>
                            ],
                            borderColor: 'rgba(75, 192, 192, 1)',
                            borderWidth: 2,
                            fill: false
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        scales: {
                            y: {
                                beginAtZero: true,
                                ticks: {
                                    callback: function(value) {
                                        return new Intl.NumberFormat('vi-VN', {
                                            style: 'currency',
                                            currency: 'VND'
                                        }).format(value);
                                    }
                                }
                            }
                        }
                    }
                });

            </script>
        </body>

        </html>