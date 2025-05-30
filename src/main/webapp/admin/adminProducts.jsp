<%@ page import="com.bqa.dao.productDao" %>
  <%@ page import="java.util.List" %>
    <%@ page import="com.bqa.model.Product" %>
      <%@ page import="java.util.ArrayList" %>
        <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

          <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

            <!DOCTYPE html>
            <html lang="vi">

            <head>
              <meta charset="UTF-8">
              <meta name="viewport" content="width=device-width, initial-scale=1.0">
              <title>Quản lý Sản phẩm - Fashion Shop</title>
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

                  <!-- Products Content -->
                  <div class="container-fluid p-4">
                    <div class="row mb-4">
                      <div class="col">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                          <h2>Quản lý Sản phẩm</h2>
                          <a href="${pageContext.request.contextPath}/admin/products/new" class="btn btn-primary">
                            <i class="fas fa-plus me-2"></i>Thêm sản phẩm mới
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
                        <!-- Search and Filter -->
                        <div class="card mb-4">
                          <div class="card-body">
                            <form action="${pageContext.request.contextPath}/admin/products" method="get"
                              class="row g-3">
                              <div class="col-md-3">
                                <select class="form-select" name="category">
                                  <option value="">Tất cả danh mục</option>
                                  <jsp:useBean id="categories" scope="request" type="java.util.List" />
                                  <c:forEach items="${categories}" var="category">
                                    <option value="${category.categoryId}" ${param.category==category.categoryId
                                      ? 'selected' : '' }>${category.name}</option>
                                  </c:forEach>
                                </select>
                              </div>
                              <%-- trạng thái --%>
                                <div class="col-md-3">
                                  <select class="form-select" name="status">
                                    <option value="">Tất cả trạng thái</option>
                                    <option value="active" ${param.status=='active' ? 'selected' : '' }>Đang bán
                                    </option>
                                    <option value="inactive" ${param.status=='inactive' ? 'selected' : '' }>Ngừng bán
                                    </option>
                                    1
                                  </select>
                                </div>
                                <div class="col-md-4">
                                  <div class="input-group">
                                    <input type="text" class="form-control" placeholder="Tìm kiếm sản phẩm..."
                                      name="search" value="${param.search}">
                                    <button class="btn btn-outline-secondary" type="submit">
                                      <i class="fas fa-search"></i>
                                    </button>
                                  </div>
                                </div>
                            </form>
                          </div>
                        </div>

                        <!-- Products Table -->
                        <div class="card">
                          <div class="card-body">
                            <div class="table-responsive">
                              <table class="table table-hover align-middle">
                                <thead class="table-light">
                                  <tr>
                                    <th scope="col">ID</th>
                                    <th scope="col">Hình ảnh</th>
                                    <th scope="col">Tên sản phẩm</th>
                                    <th scope="col">Danh mục</th>
                                    <th scope="col">Giá</th>
                                    <th scope="col">Tồn kho</th>
                                    <th scope="col">Trạng thái</th>
                                    <th scope="col" class="text-center">Thao tác</th>
                                  </tr>
                                </thead>
                                <tbody>
                                  <jsp:useBean id="products" scope="request" type="java.util.List" />
                                  <c:forEach items="${products}" var="product">
                                    <jsp:useBean id="categoryMap" scope="request" type="java.util.Map" />
                                    <tr>
                                      <td>${product.productId}</td>
                                      <td>
                                        <img src="${pageContext.request.contextPath}/${product.thumbnail}"
                                          class="img-thumbnail" alt="${product.name}" width="50">
                                      </td>
                                      <td>${product.name}</td>
                                      <td>${categoryMap[product.categoryId]}</td>
                                      <td>${product.price}</td>
                                      <td>
                                        <c:choose>
                                          <c:when test="${product.stock <= 0}">
                                            <span class="text-danger">Hết hàng</span>
                                          </c:when>
                                          <c:when test="${product.stock < 10}">
                                            <span class="text-warning">${product.stock}</span>
                                          </c:when>
                                          <c:otherwise>
                                            ${product.stock}
                                          </c:otherwise>
                                        </c:choose>
                                      </td>
                                      <td>
                                        <c:choose>
                                          <c:when test="${product.active}">
                                            <span class="badge bg-success">Đang bán</span>
                                          </c:when>
                                          <c:otherwise>
                                            <span class="badge bg-secondary">Ngừng bán</span>
                                          </c:otherwise>
                                        </c:choose>
                                      </td>
                                      <td class="text-center">
                                        <div class="btn-group" role="group">
                                          <a href="${pageContext.request.contextPath}/admin/products/edit?id=${product.productId}"
                                            class="btn btn-sm btn-outline-primary" title="Sửa">
                                            <i class="fas fa-edit"></i>
                                          </a>
                                          <button type="button" class="btn btn-sm btn-outline-danger" title="Xóa"
                                            onclick="confirmDelete(${product.productId}, '${product.name}')">
                                            <i class="fas fa-trash"></i>
                                          </button>
                                        </div>
                                      </td>
                                    </tr>
                                  </c:forEach>
                                </tbody>
                              </table>
                            </div>

                            <!-- Pagination -->
                            <nav class="mt-4">
                              <ul class="pagination justify-content-center">
                                <c:if test="${currentPage > 1}">
                                  <li class="page-item">
                                    <a class="page-link"
                                      href="${pageContext.request.contextPath}/admin/products?page=${currentPage - 1}&search=${param.search}&category=${param.category}&status=${param.status}"
                                      aria-label="Previous">
                                      <span aria-hidden="true">&laquo;</span>
                                    </a>
                                  </li>
                                </c:if>

                                <c:forEach begin="1" end="${totalPages}" var="i">
                                  <li class="page-item ${currentPage == i ? 'active' : ''}">
                                    <a class="page-link"
                                      href="${pageContext.request.contextPath}/admin/products?page=${i}&search=${param.search}&category=${param.category}&status=${param.status}">${i}</a>
                                  </li>
                                </c:forEach>

                                <c:if test="${currentPage < totalPages}">
                                  <li class="page-item">
                                    <a class="page-link"
                                      href="${pageContext.request.contextPath}/admin/products?page=${currentPage + 1}&search=${param.search}&category=${param.category}&status=${param.status}"
                                      aria-label="Next">
                                      <span aria-hidden="true">&raquo;</span>
                                    </a>
                                  </li>
                                </c:if>
                              </ul>
                            </nav>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>

              <!-- Delete Confirmation Modal -->
              <div class="modal fade" id="deleteModal" tabindex="-1" aria-labelledby="deleteModalLabel"
                aria-hidden="true">
                <div class="modal-dialog">
                  <div class="modal-content">
                    <div class="modal-header">
                      <h5 class="modal-title" id="deleteModalLabel">Xác nhận xóa</h5>
                      <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                      <p>Bạn có chắc chắn muốn xóa sản phẩm <span id="productName" class="fw-bold"></span>?</p>
                      <p class="text-danger">Lưu ý: Hành động này không thể hoàn tác!</p>
                    </div>
                    <div class="modal-footer">
                      <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                      <form id="deleteForm" action="${pageContext.request.contextPath}/admin/products/delete"
                        method="post">
                        <input type="hidden" id="productId" name="productId" value="">
                        <button type="submit" class="btn btn-danger">Xóa</button>
                      </form>
                    </div>
                  </div>
                </div>
              </div>

              <!-- Scripts -->
              <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
              <script>
                // Toggle sidebar
                document.getElementById('sidebarToggle').addEventListener('click', function (e) {
                  e.preventDefault();
                  document.getElementById('wrapper').classList.toggle('toggled');
                });

                // Delete confirmation
                function confirmDelete(id, name) {
                  document.getElementById('productId').value = id;
                  document.getElementById('productName').textContent = name;

                  const deleteModal = new bootstrap.Modal(document.getElementById('deleteModal'));
                  deleteModal.show();
                }
              </script>
            </body>

            </html>