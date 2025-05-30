<jsp:useBean id="product" scope="request" type="com.bqa.model.Product" />
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
                                        <h2>${product.productId != null ? 'Chỉnh sửa' : 'Thêm mới'} Sản phẩm</h2>
                                        <a href="${pageContext.request.contextPath}/admin/products"
                                            class="btn btn-outline-secondary">
                                            <i class="fas fa-arrow-left me-2"></i>Quay lại
                                        </a>
                                    </div>
                                    <!-- Product Form -->
                                    <div class="card">
                                        <div class="card-body">
                                            <c:choose>
                                                <c:when test="${product.productId == 0}">
                                                    <form
                                                        action="${pageContext.request.contextPath}/admin/products/save"
                                                        method="post" id="productForm" enctype="multipart/form-data">
                                                </c:when>
                                                <c:otherwise>
                                                    <form
                                                        action="${pageContext.request.contextPath}/admin/products/saveEdit"
                                                        method="post" id="productForm" enctype="multipart/form-data">
                                                </c:otherwise>
                                            </c:choose>
                                            <input type="hidden" name="productId" value="${product.productId}">
                                            <div class="row g-4">
                                                <!-- Basic Information -->
                                                <div class="col-lg-8">
                                                    <div class="card mb-4">
                                                        <div class="card-header">
                                                            <h5 class="mb-0">Thông tin cơ bản</h5>
                                                        </div>
                                                        <div class="card-body">
                                                            <div class="mb-3">
                                                                <label for="name" class="form-label">Tên sản phẩm <span
                                                                        class="text-danger">*</span></label>
                                                                <input type="text" class="form-control" id="name"
                                                                    name="name" value="${product.name}" required>
                                                            </div>

                                                            <div class="row mb-3">
                                                                <div class="col-md-6">
                                                                    <label for="categoryId" class="form-label">Danh mục
                                                                        <span class="text-danger">*</span></label>
                                                                    <select class="form-select" id="categoryId"
                                                                        name="categoryId" required>
                                                                        <option value="">Chọn danh mục</option>
                                                                        <jsp:useBean id="categories" scope="request"
                                                                            type="java.util.List" />
                                                                        <c:choose>
                                                                            <c:when
                                                                                test="${not empty product.productId}">
                                                                                <c:forEach items="${categories}"
                                                                                    var="category">
                                                                                    <option
                                                                                        value="${category.categoryId}"
                                                                                        <c:if
                                                                                        test="${product.categoryId == category.categoryId}">
                                                                                        selected</c:if>
                                                                                        >${category.name}</option>
                                                                                </c:forEach>
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <c:forEach items="${categories}"
                                                                                    var="category">
                                                                                    <option
                                                                                        value="${category.categoryId}">
                                                                                        ${category.name}</option>
                                                                                </c:forEach>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </select>
                                                                </div>
                                                            </div>

                                                            <div class="mb-3">
                                                                <label for="Description" class="form-label">Mô tả
                                                                    ngắn</label>
                                                                <textarea class="form-control" id="shortDescription"
                                                                    name="description"
                                                                    rows="2">${product.description}</textarea>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <!-- Pricing Information -->
                                                    <div class="card mb-4">
                                                        <div class="card-header">
                                                            <h5 class="mb-0">Thông tin giá</h5>
                                                        </div>
                                                        <div class="card-body">
                                                            <div class="row mb-3">
                                                                <div class="col-md-6">
                                                                    <label for="price" class="form-label">Giá bán <span
                                                                            class="text-danger">*</span></label>
                                                                    <div class="input-group">
                                                                        <input type="number" class="form-control"
                                                                            id="price" name="price"
                                                                            value="${product.price}" min="0" step="1000"
                                                                            required>
                                                                        <span class="input-group-text">₫</span>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <!-- Product Variants -->
                                                    <div class="card mb-4">
                                                        <div
                                                            class="card-header d-flex justify-content-between align-items-center">
                                                            <h5 class="mb-0">Biến thể sản phẩm</h5>
                                                            <button type="button" class="btn btn-sm btn-outline-primary"
                                                                id="addVariantBtn">
                                                                <i class="fas fa-plus me-1"></i>Thêm biến thể
                                                            </button>
                                                        </div>
                                                        <div class="card-body">
                                                            <div class="table-responsive">
                                                                <table class="table table-bordered" id="variantsTable">
                                                                    <thead class="table-light">
                                                                        <tr>
                                                                            <th>Kích cỡ</th>
                                                                            <th>Màu sắc</th>
                                                                            <th>Số lượng</th>
                                                                            <th>Thao tác</th>
                                                                        </tr>
                                                                    </thead>
                                                                    <tbody>
                                                                        <c:choose>
                                                                            <c:when test="${product.productId == 0}">
                                                                                <!-- Default row for new product -->
                                                                                <tr>
                                                                                    <input type="hidden"
                                                                                        name="variants[0].id"
                                                                                        value="-1">
                                                                                    <td>
                                                                                        <select class="form-select"
                                                                                            name="variants[0].size">
                                                                                            <option value="S">S</option>
                                                                                            <option value="M">M</option>
                                                                                            <option value="L">L</option>
                                                                                            <option value="XL">XL
                                                                                            </option>
                                                                                            <option value="XXL">XXL
                                                                                            </option>
                                                                                        </select>
                                                                                    </td>
                                                                                    <td>
                                                                                        <select class="form-select"
                                                                                            name="variants[0].color">
                                                                                            <option value="Đen">Đen
                                                                                            </option>
                                                                                            <option value="Trắng">Trắng
                                                                                            </option>
                                                                                            <option value="Đỏ">Đỏ
                                                                                            </option>
                                                                                            <option value="Xanh">Xanh
                                                                                            </option>
                                                                                            <option value="Vàng">Vàng
                                                                                            </option>
                                                                                        </select>
                                                                                    </td>
                                                                                    <td>
                                                                                        <input type="number"
                                                                                            class="form-control"
                                                                                            name="variants[0].quantity"
                                                                                            value="0" min="0">
                                                                                    </td>
                                                                                    <td>
                                                                                        <button type="button"
                                                                                            class="btn btn-sm btn-outline-danger removeVariantBtn">
                                                                                            <i class="fas fa-trash"></i>
                                                                                        </button>
                                                                                    </td>
                                                                                </tr>
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <!-- Show all variants for existing product -->
                                                                                <c:forEach items="${variants}"
                                                                                    var="variant" varStatus="status">
                                                                                    <tr>
                                                                                        <td>
                                                                                            <input type="hidden"
                                                                                                name="variants[${status.index}].id"
                                                                                                value="${variant.variant_id}">
                                                                                            <select class="form-select"
                                                                                                name="variants[${status.index}].size">
                                                                                                <option value="S"
                                                                                                    ${variant.size=='S'
                                                                                                    ? 'selected' : '' }>
                                                                                                    S</option>
                                                                                                <option value="M"
                                                                                                    ${variant.size=='M'
                                                                                                    ? 'selected' : '' }>
                                                                                                    M</option>
                                                                                                <option value="L"
                                                                                                    ${variant.size=='L'
                                                                                                    ? 'selected' : '' }>
                                                                                                    L</option>
                                                                                                <option value="XL"
                                                                                                    ${variant.size=='XL'
                                                                                                    ? 'selected' : '' }>
                                                                                                    XL</option>
                                                                                                <option value="XXL"
                                                                                                    ${variant.size=='XXL'
                                                                                                    ? 'selected' : '' }>
                                                                                                    XXL</option>
                                                                                            </select>
                                                                                        </td>
                                                                                        <td>
                                                                                            <select class="form-select"
                                                                                                name="variants[${status.index}].color">
                                                                                                <option value="Đen"
                                                                                                    ${variant.color=='Đen'
                                                                                                    ? 'selected' : '' }>
                                                                                                    Đen</option>
                                                                                                <option value="Trắng"
                                                                                                    ${variant.color=='Trắng'
                                                                                                    ? 'selected' : '' }>
                                                                                                    Trắng</option>
                                                                                                <option value="Đỏ"
                                                                                                    ${variant.color=='Đỏ'
                                                                                                    ? 'selected' : '' }>
                                                                                                    Đỏ</option>
                                                                                                <option value="Xanh"
                                                                                                    ${variant.color=='Xanh'
                                                                                                    ? 'selected' : '' }>
                                                                                                    Xanh</option>
                                                                                                <option value="Vàng"
                                                                                                    ${variant.color=='Vàng'
                                                                                                    ? 'selected' : '' }>
                                                                                                    Vàng</option>
                                                                                            </select>
                                                                                        </td>
                                                                                        <td>
                                                                                            <input type="number"
                                                                                                class="form-control"
                                                                                                name="variants[${status.index}].quantity"
                                                                                                value="${variant.quantity}"
                                                                                                min="0">
                                                                                        </td>
                                                                                        <td>
                                                                                            <button type="button"
                                                                                                class="btn btn-sm btn-outline-danger removeVariantBtn">
                                                                                                <i
                                                                                                    class="fas fa-trash"></i>
                                                                                            </button>
                                                                                        </td>
                                                                                    </tr>
                                                                                </c:forEach>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </tbody>
                                                                </table>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- Sidebar -->
                                                <div class="col-lg-4">
                                                    <!-- Product Status -->
                                                    <div class="card mb-4">
                                                        <div class="card-header">
                                                            <h5 class="mb-0">Trạng thái</h5>
                                                        </div>
                                                        <div class="card-body">
                                                            <div class="form-check form-switch mb-3">
                                                                <input class="form-check-input" type="checkbox"
                                                                    id="active" name="active" ${product.active
                                                                    ? 'checked' : '' }>
                                                                <label class="form-check-label" for="active">Đang
                                                                    bán</label>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <!-- Product Images -->
                                                    <div class="card mb-4">
                                                        <div class="card-header">
                                                            <h5 class="mb-0">Hình ảnh sản phẩm</h5>
                                                        </div>
                                                        <div class="card-body">
                                                            <div class="mb-3">
                                                                <label for="thumbnailFile" class="form-label">Ảnh đại
                                                                    diện <span class="text-danger">*</span></label>
                                                                <c:choose>
                                                                    <c:when test="${product.productId == 0}">
                                                                        <input type="file" class="form-control"
                                                                            id="thumbnailFile" name="thumbnailFile"
                                                                            accept="image/*">
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <div class="mt-2">
                                                                            <input type="file" class="form-control"
                                                                                id="thumbnailFile" name="thumbnailFile"
                                                                                accept="image/*">
                                                                            <img src="${pageContext.request.contextPath}/${product.thumbnail}"
                                                                                class="img-thumbnail" alt="Thumbnail"
                                                                                style="max-height: 100px;">
                                                                            <input type="hidden" name="oldThumbnail"
                                                                                value="${product.thumbnail}">
                                                                        </div>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </div>

                                                            <div class="mb-3">
                                                                <label for="imageFiles" class="form-label">Ảnh chi
                                                                    tiết</label>
                                                                <c:choose>
                                                                    <c:when test="${product.productId == 0}">
                                                                        <input type="file" class="form-control"
                                                                            id="imageFiles" name="imageFiles"
                                                                            accept="image/*" multiple>
                                                                        <div class="form-text">Có thể chọn nhiều ảnh
                                                                            cùng lúc</div>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <input type="file" class="form-control"
                                                                            id="imageFiles" name="imageFiles"
                                                                            accept="image/*" multiple>
                                                                        <div class="form-text">Có thể chọn nhiều ảnh
                                                                            cùng lúc</div>
                                                                        <jsp:useBean id="image_url" scope="request"
                                                                            type="java.util.List" />
                                                                        <div class="mt-2 d-flex flex-wrap gap-2">
                                                                            <c:forEach items="${image_url}" var="image"
                                                                                varStatus="status">
                                                                                <div class="position-relative">
                                                                                    <img src="${pageContext.request.contextPath}/${image}"
                                                                                        class="img-thumbnail"
                                                                                        alt="Image ${status.index + 1}"
                                                                                        style="height: 80px; width: 80px; object-fit: cover;">
                                                                                    <input type="hidden"
                                                                                        name="oldImages"
                                                                                        value="${image}">
                                                                                    <button type="button"
                                                                                        class="btn btn-sm btn-danger position-absolute top-0 end-0 removeImageBtn"
                                                                                        data-index="${status.index}">
                                                                                        <i class="fas fa-times"></i>
                                                                                    </button>
                                                                                </div>
                                                                            </c:forEach>
                                                                        </div>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="d-flex justify-content-end mt-4">
                                                <a href="${pageContext.request.contextPath}/admin/products"
                                                    class="btn btn-secondary me-2">Hủy</a>
                                                <button type="submit" class="btn btn-primary">Lưu sản phẩm</button>
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
                    // Add variant
                    document.getElementById('addVariantBtn').addEventListener('click', function () {
                        const tbody = document.querySelector('#variantsTable tbody');
                        const rowCount = tbody.rows.length;
                        const newIndex = rowCount;

                        const newRow = document.createElement('tr');
                        newRow.innerHTML = `
                <input type="hidden" name="variants[`+ newIndex + `].id" value="-1">
                <td>
                    <select class="form-select" name="variants[` + newIndex + `].size">
                        <option value="S">S</option>
                        <option value="M">M</option>
                        <option value="L">L</option>
                        <option value="XL">XL</option>
                        <option value="XXL">XXL</option>
                    </select>
                </td>
                <td>
                    <select class="form-select" name="variants[` + newIndex + `].color">
                        <option value="Đen">Đen</option>
                        <option value="Trắng">Trắng</option>
                        <option value="Đỏ">Đỏ</option>
                        <option value="Xanh">Xanh</option>
                        <option value="Vàng">Vàng</option>
                    </select>
                </td>
                <td>
                    <input type="number" class="form-control" name="variants[` + newIndex + `].quantity" value="0" min="0">
                </td>
                <td>
                    <button type="button" class="btn btn-sm btn-outline-danger removeVariantBtn">
                        <i class="fas fa-trash"></i>
                    </button>
                </td>
            `;

                        tbody.appendChild(newRow);

                        // Add event listener to the new remove button
                        newRow.querySelector('.removeVariantBtn').addEventListener('click', removeVariant);

                    });

                    // Remove variant
                    document.querySelectorAll('.removeVariantBtn').forEach(button => {
                        button.addEventListener('click', removeVariant);
                    });

                    function removeVariant(e) {
                        const row = e.target.closest('tr');
                        if (document.querySelectorAll('#variantsTable tbody tr').length > 1) {
                            row.remove();
                            updateVariantIndexes();
                        } else {
                            alert('Phải có ít nhất một biến thể sản phẩm!');
                        }
                    }

                    function updateVariantIndexes() {
                        const rows = document.querySelectorAll('#variantsTable tbody tr');
                        rows.forEach((row, index) => {
                            // Update hidden input id
                            const hiddenInput = row.querySelector('input[type="hidden"]');
                            if (hiddenInput) {
                                hiddenInput.name = `variants[` + index + `].id`;
                            }

                            // Update size select
                            const sizeSelect = row.querySelector('select[name^="variants["]');
                            if (sizeSelect) {
                                sizeSelect.name = `variants[` + index + `].size`;
                            }

                            // Update color select
                            const colorSelect = row.querySelectorAll('select[name^="variants["]')[1];
                            if (colorSelect) {
                                colorSelect.name = `variants[` + index + `].color`;
                            }

                            // Update quantity input
                            const quantityInput = row.querySelector('input[type="number"]');
                            if (quantityInput) {
                                quantityInput.name = `variants[` + index + `].quantity`;
                            }
                        });
                    }

                    // Remove image
                    document.querySelectorAll('.removeImageBtn').forEach(button => {
                        button.addEventListener('click', function () {
                            this.closest('.position-relative').remove();
                        });
                    });

                    // Form validation
                    document.getElementById('productForm').addEventListener('submit', function (event) {
                        const name = document.getElementById('name').value.trim();
                        const price = document.getElementById('price').value;

                        if (!name) {
                            event.preventDefault();
                            alert('Vui lòng nhập tên sản phẩm!');
                            return;
                        }

                        if (!price || price <= 0) {
                            event.preventDefault();
                            alert('Vui lòng nhập giá sản phẩm hợp lệ!');
                            return;
                        }

                        // Check if there's at least one variant
                        if (document.querySelectorAll('#variantsTable tbody tr').length === 0) {
                            event.preventDefault();
                            alert('Vui lòng thêm ít nhất một biến thể sản phẩm!');
                            return;
                        }

                        // Validate variants
                        const rows = document.querySelectorAll('#variantsTable tbody tr');
                        let isValid = true;
                        rows.forEach((row, index) => {
                            const stock = row.querySelector(`input[name="variants[${index}].stock"]`).value;
                            if (!stock || stock < 0) {
                                isValid = false;
                                alert(`Vui lòng nhập số lượng hợp lệ cho biến thể ${index + 1}!`);
                            }
                        });

                        if (!isValid) {
                            event.preventDefault();
                        }
                    });
                </script>
            </body>

            </html>