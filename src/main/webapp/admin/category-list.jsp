<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
        <jsp:useBean id="categories" scope="request" type="java.util.List" />
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Quản lý Danh mục - Fashion Shop</title>
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
                            class="list-group-item list-group-item-action bg-transparent text-white">
                            <i class="fas fa-tshirt me-2"></i>Sản phẩm
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/categories"
                            class="list-group-item list-group-item-action bg-transparent text-white active">
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

                    <!-- Categories Content -->
                    <div class="container-fluid p-4">
                        <div class="row mb-4">
                            <div class="col">
                                <div class="d-flex justify-content-between align-items-center mb-4">
                                    <h2>Quản lý Danh mục</h2>
                                    <button type="button" class="btn btn-primary" data-bs-toggle="modal"
                                        data-bs-target="#addCategoryModal">
                                        <i class="fas fa-plus me-2"></i>Thêm danh mục mới
                                    </button>
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
                                <!-- Categories Table -->
                                <div class="card">
                                    <div class="card-body">
                                        <div class="table-responsive">
                                            <table class="table table-hover align-middle">
                                                <thead class="table-light">
                                                    <tr>
                                                        <th scope="col">ID</th>
                                                        <th scope="col">Tên danh mục</th>
                                                        <th scope="col">Mô tả</th>
                                                        <th scope="col">Danh mục cha</th>
                                                        <th scope="col">Số sản phẩm</th>
                                                        <th scope="col">Trạng thái</th>
                                                        <th scope="col" class="text-center">Thao tác</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach items="${categories}" var="category">
                                                        <tr>
                                                            <td>${category.categoryId}</td>
                                                            <td>${category.name}</td>
                                                            <td>
                                                                <c:if test="${not empty category.description}">
                                                                    <span class="text-truncate d-inline-block"
                                                                        style="max-width: 200px;"
                                                                        title="${category.description}">
                                                                        ${category.description}
                                                                    </span>
                                                                </c:if>
                                                                <c:if test="${empty category.description}">
                                                                    <span class="text-muted">Không có mô tả</span>
                                                                </c:if>
                                                            </td>
                                                            <td>
                                                                <c:if test="${not empty category.parentName}">
                                                                    ${category.parentName}
                                                                </c:if>
                                                                <c:if test="${empty category.parentName}">
                                                                    <span class="text-muted">Không có</span>
                                                                </c:if>
                                                            </td>
                                                            <td>${category.productCount}</td>
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${category.status == 1}">
                                                                        <span class="badge bg-success">Hiển thị</span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="badge bg-secondary">Ẩn</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td class="text-center">
                                                                <div class="btn-group" role="group">
                                                                    <button type="button"
                                                                        class="btn btn-sm btn-outline-primary editCategoryBtn"
                                                                        data-id="${category.categoryId}"
                                                                        data-name="${category.name}"
                                                                        data-description="${category.description}"
                                                                        data-parent-id="${category.parentId}"
                                                                        data-status="${category.status}">
                                                                        <i class="fas fa-edit"></i>
                                                                    </button>
                                                                    <button type="button"
                                                                        class="btn btn-sm btn-outline-danger"
                                                                        onclick="confirmDelete(${category.categoryId}, '${category.name}', ${category.productCount})">
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
                                        <c:if test="${totalPages > 1}">
                                            <nav class="mt-4">
                                                <ul class="pagination justify-content-center">
                                                    <c:if test="${currentPage > 1}">
                                                        <li class="page-item">
                                                            <a class="page-link"
                                                                href="${pageContext.request.contextPath}/admin/categories?page=${currentPage - 1}"
                                                                aria-label="Previous">
                                                                <span aria-hidden="true">&laquo;</span>
                                                            </a>
                                                        </li>
                                                    </c:if>

                                                    <c:forEach begin="1" end="${totalPages}" var="i">
                                                        <li class="page-item ${currentPage == i ? 'active' : ''}">
                                                            <a class="page-link"
                                                                href="${pageContext.request.contextPath}/admin/categories?page=${i}">${i}</a>
                                                        </li>
                                                    </c:forEach>

                                                    <c:if test="${currentPage < totalPages}">
                                                        <li class="page-item">
                                                            <a class="page-link"
                                                                href="${pageContext.request.contextPath}/admin/categories?page=${currentPage + 1}"
                                                                aria-label="Next">
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

            <!-- Add Category Modal -->
            <div class="modal fade" id="addCategoryModal" tabindex="-1" aria-labelledby="addCategoryModalLabel"
                aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <form action="${pageContext.request.contextPath}/admin/categories/insert" method="post">
                            <div class="modal-header">
                                <h5 class="modal-title" id="addCategoryModalLabel">Thêm danh mục mới</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"
                                    aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <div class="mb-3">
                                    <label for="name" class="form-label">Tên danh mục <span
                                            class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="name" name="name" required>
                                </div>

                                <div class="mb-3">
                                    <label for="description" class="form-label">Mô tả</label>
                                    <textarea class="form-control" id="description" name="description"
                                        rows="3"></textarea>
                                </div>

                                <div class="mb-3">
                                    <label for="parentId" class="form-label">Danh mục cha</label>
                                    <select class="form-select" id="parentId" name="parentId">
                                        <option value="">Không có</option>
                                        <c:forEach items="${categories}" var="parent">
                                            <option value="${parent.categoryId}">${parent.name}</option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <div class="form-check form-switch">
                                    <input class="form-check-input" type="checkbox" id="status" name="status" checked>
                                    <label class="form-check-label" for="status">Hiển thị danh mục</label>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                                <button type="submit" class="btn btn-primary">Thêm danh mục</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Edit Category Modal -->
            <div class="modal fade" id="editCategoryModal" tabindex="-1" aria-labelledby="editCategoryModalLabel"
                aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <form action="${pageContext.request.contextPath}/admin/categories/update" method="post">
                            <input type="hidden" id="editCategoryId" name="categoryId">
                            <div class="modal-header">
                                <h5 class="modal-title" id="editCategoryModalLabel">Chỉnh sửa danh mục</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"
                                    aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <div class="mb-3">
                                    <label for="editName" class="form-label">Tên danh mục <span
                                            class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="editName" name="name" required>
                                </div>

                                <div class="mb-3">
                                    <label for="editDescription" class="form-label">Mô tả</label>
                                    <textarea class="form-control" id="editDescription" name="description"
                                        rows="3"></textarea>
                                </div>

                                <div class="mb-3">
                                    <label for="editParentId" class="form-label">Danh mục cha</label>
                                    <select class="form-select" id="editParentId" name="parentId">
                                        <option value="0">Không có</option>
                                        <c:forEach items="${categories}" var="parent">
                                            <option value="${parent.categoryId}">${parent.name}</option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <div class="form-check form-switch">
                                    <input class="form-check-input" type="checkbox" id="editStatus" name="status">
                                    <label class="form-check-label" for="editStatus">Hiển thị danh mục</label>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                                <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Delete Confirmation Modal -->
            <div class="modal fade" id="deleteCategoryModal" tabindex="-1" aria-labelledby="deleteCategoryModalLabel"
                aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="deleteCategoryModalLabel">Xác nhận xóa</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <p>Bạn có chắc chắn muốn xóa danh mục <span id="categoryName" class="fw-bold"></span>?</p>
                            <div id="categoryHasProducts" class="alert alert-warning d-none">
                                <i class="fas fa-exclamation-triangle me-2"></i>
                                Danh mục này hiện có <span id="productCount" class="fw-bold"></span> sản phẩm. Nếu xóa,
                                tất cả sản phẩm sẽ bị xóa khỏi danh mục này.
                            </div>
                            <p class="text-danger">Lưu ý: Hành động này không thể hoàn tác!</p>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                            <form id="deleteCategoryForm"
                                action="${pageContext.request.contextPath}/admin/categories/delete" method="post">
                                <input type="hidden" id="deleteCategoryId" name="categoryId" value="">
                                <button type="submit" class="btn btn-danger">Xóa</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Scripts -->
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            <script>
                // Edit category
                document.querySelectorAll('.editCategoryBtn').forEach(button => {
                    button.addEventListener('click', function () {
                        const id = this.getAttribute('data-id');
                        const name = this.getAttribute('data-name');
                        const description = this.getAttribute('data-description');
                        const parentId = this.getAttribute('data-parent-id');
                        let status = this.getAttribute('data-status');

                        if (status == 1) {
                            status = true;
                        } else {
                            status = false;
                        }

                        document.getElementById('editCategoryId').value = id;
                        document.getElementById('editName').value = name;
                        document.getElementById('editDescription').value = description;
                        document.getElementById('editParentId').value = parentId || '0';
                        document.getElementById('editStatus').checked = status;

                        const editCategoryModal = new bootstrap.Modal(document.getElementById('editCategoryModal'));
                        editCategoryModal.show();
                    });
                });

                // Delete confirmation
                function confirmDelete(id, name, productCount) {
                    document.getElementById('deleteCategoryId').value = id;
                    document.getElementById('categoryName').textContent = name;

                    const categoryHasProducts = document.getElementById('categoryHasProducts');
                    if (productCount > 0) {
                        categoryHasProducts.classList.remove('d-none');
                        document.getElementById('productCount').textContent = productCount;
                    } else {
                        categoryHasProducts.classList.add('d-none');
                    }

                    const deleteCategoryModal = new bootstrap.Modal(document.getElementById('deleteCategoryModal'));
                    deleteCategoryModal.show();
                }

                // Form validation
                document.querySelector('#addCategoryModal form').addEventListener('submit', function (event) {
                    const name = document.getElementById('name').value.trim();

                    if (!name) {
                        event.preventDefault();
                        alert('Vui lòng nhập tên danh mục!');
                    }
                });

                document.querySelector('#editCategoryModal form').addEventListener('submit', function (event) {
                    const name = document.getElementById('editName').value.trim();

                    if (!name) {
                        event.preventDefault();
                        alert('Vui lòng nhập tên danh mục!');
                    }
                });
            </script>
        </body>

        </html>