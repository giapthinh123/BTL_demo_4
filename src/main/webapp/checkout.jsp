<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh toán - Fashion Shop</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
    <!-- Header -->
    <jsp:include page="page/header.jsp" />
    
    <!-- Checkout Section -->
    <section class="container my-5">
        <h2 class="mb-4">Thanh toán</h2>
        
        <!-- Alert for errors -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                ${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>
        
        <form action="${pageContext.request.contextPath}/checkout/process" method="post" id="checkoutForm">
            <div class="row">
                <!-- Shipping Information -->
                <div class="col-lg-8">
                    <div class="card mb-4">
                        <div class="card-header bg-primary text-white">
                            <h5 class="mb-0">Thông tin giao hàng</h5>
                        </div>
                        <div class="card-body">
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label for="shippingName" class="form-label">Họ và tên <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="shippingName" name="shippingName" value="${user.fullName}" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="shippingPhone" class="form-label">Số điện thoại <span class="text-danger">*</span></label>
                                    <input type="tel" class="form-control" id="shippingPhone" name="shippingPhone" value="${user.phone}" required>
                                </div>
                                <div class="col-12">
                                    <label for="shippingEmail" class="form-label">Email</label>
                                    <input type="email" class="form-control" id="shippingEmail" name="shippingEmail" value="${user.email}">
                                </div>
                                <div class="col-12">
                                    <label for="shippingAddress" class="form-label">Địa chỉ <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="shippingAddress" name="shippingAddress" value="${user.address}" required>
                                </div>
                                <div class="col-md-4">
                                    <label for="shippingProvince" class="form-label">Tỉnh/Thành phố <span class="text-danger">*</span></label>
                                    <select class="form-select" id="shippingProvince" name="shippingProvince" required>
                                        <option value="">Chọn tỉnh/thành phố</option>
                                    </select>
                                </div>
                                <div class="col-md-4">
                                    <label for="shippingDistrict" class="form-label">Quận/Huyện <span class="text-danger">*</span></label>
                                    <select class="form-select" id="shippingDistrict" name="shippingDistrict" required>
                                        <option value="">Chọn quận/huyện</option>
                                    </select>
                                </div>
                                <div class="col-md-4">
                                    <label for="shippingWard" class="form-label">Phường/Xã <span class="text-danger">*</span></label>
                                    <select class="form-select" id="shippingWard" name="shippingWard" required>
                                        <option value="">Chọn phường/xã</option>
                                    </select>
                                </div>
                                <div class="col-12">
                                    <label for="note" class="form-label">Ghi chú</label>
                                    <textarea class="form-control" id="note" name="note" rows="3" placeholder="Ghi chú về đơn hàng, ví dụ: thời gian hay chỉ dẫn địa điểm giao hàng chi tiết hơn."></textarea>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Payment Methods -->
                    <div class="card mb-4">
                        <div class="card-header bg-primary text-white">
                            <h5 class="mb-0">Phương thức thanh toán</h5>
                        </div>
                        <div class="card-body">
                            <div class="form-check mb-3">
                                <input class="form-check-input" type="radio" name="paymentMethod" id="codPayment" value="COD" checked>
                                <label class="form-check-label" for="codPayment">
                                    <i class="fas fa-money-bill-wave me-2"></i> Thanh toán khi nhận hàng (COD)
                                </label>
                                <div class="form-text">Bạn sẽ thanh toán bằng tiền mặt khi nhận hàng</div>
                            </div>

                            <div class="form-check mb-3">
                                <input class="form-check-input" type="radio" name="paymentMethod" id="momoPayment" value="MOMO">
                                <label class="form-check-label" for="momoPayment">
                                    <i class="fas fa-wallet me-2"></i> Thanh toán MoMo
                                </label>
                                <div class="form-text">Thanh toán qua ví điện tử MoMo</div>
                            </div>
                            
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="paymentMethod" id="vnpayPayment" value="VNPAY">
                                <label class="form-check-label" for="vnpayPayment">
                                    <i class="fas fa-credit-card me-2"></i> Thanh toán VNPAY
                                </label>
                                <div class="form-text">Thanh toán qua cổng VNPAY bằng QR Code hoặc thẻ ngân hàng nội địa, thẻ quốc tế</div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Order Summary -->
                <div class="col-lg-4">
                    <div class="card">
                        <div class="card-header bg-primary text-white">
                            <h5 class="mb-0">Đơn hàng của bạn</h5>
                        </div>
                        <div class="card-body">
                            <div class="order-summary">
                                <h6 class="border-bottom pb-2 mb-3">Sản phẩm</h6>

                                <c:forEach items="${products}" var="item" varStatus="loopStatus">
                                    <div class="d-flex justify-content-between mb-2">
                                        <span>${item.name} x ${cart_items[loopStatus.index].quantity} <small class="text-muted">${variant[loopStatus.index].size} ${variant[loopStatus.index].color}</small></span>
                                        <span>${item.price * cart_items[loopStatus.index].quantity}</span>
                                    </div>
                                </c:forEach>
                                <hr>
                                <div class="d-flex justify-content-between mb-4">
                                    <strong>Tổng cộng:</strong>
                                    <strong class="text-primary">${finalTotal}</strong>
                                </div>

                                <div class="form-check mb-3">
                                    <input class="form-check-input" type="checkbox" id="agreeTerms" name="agreeTerms" required>
                                    <label class="form-check-label" for="agreeTerms">
                                        Tôi đã đọc và đồng ý với <a href="${pageContext.request.contextPath}/terms" target="_blank">điều khoản và điều kiện</a> của website
                                    </label>
                                </div>
                                
                                <div class="d-grid">
                                    <button type="submit" class="btn btn-primary btn-lg">
                                        Đặt hàng
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </form>
    </section>
    
    <!-- Footer -->
    <jsp:include page="page/footer.jsp" />
    
    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
    <script>
        // Load address data from JSON file
        fetch('${pageContext.request.contextPath}/assets/data/vietnamAddress.json')
            .then(response => response.json())
            .then(data => {
                const provinceSelect = document.getElementById('shippingProvince');
                const districtSelect = document.getElementById('shippingDistrict');
                const wardSelect = document.getElementById('shippingWard');

                // Populate provinces
                data.forEach(province => {
                    const option = document.createElement('option');
                    option.value = province.Name;
                    option.textContent = province.Name;
                    provinceSelect.appendChild(option);
                });

                // Handle province change
                provinceSelect.addEventListener('change', function() {
                    const selectedProvince = data.find(p => p.Name === this.value);

                    // Reset district and ward
                    districtSelect.innerHTML = '<option value="">Chọn quận/huyện</option>';
                    wardSelect.innerHTML = '<option value="">Chọn phường/xã</option>';

                    if (selectedProvince) {
                        selectedProvince.Districts.forEach(district => {
                            const option = document.createElement('option');
                            option.value = district.Name;
                            option.textContent = district.Name;
                            districtSelect.appendChild(option);
                        });
                    }
                });

                // Handle district change
                districtSelect.addEventListener('change', function() {
                    const selectedProvince = data.find(p => p.Name === provinceSelect.value);
                    const selectedDistrict = selectedProvince?.Districts.find(d => d.Name === this.value);

                    // Reset ward
                    wardSelect.innerHTML = '<option value="">Chọn phường/xã</option>';

                    if (selectedDistrict) {
                        selectedDistrict.Wards.forEach(ward => {
                            const option = document.createElement('option');
                            option.value = ward.Name;
                            option.textContent = ward.Name;
                            wardSelect.appendChild(option);
                        });
                    }
                });
            })
            .catch(error => console.error('Error loading address data:', error));
        
        // Form validation
        document.getElementById('checkoutForm').addEventListener('submit', function(event) {
            const agreeTerms = document.getElementById('agreeTerms');
            
            if (!agreeTerms.checked) {
                event.preventDefault();
                alert('Vui lòng đồng ý với điều khoản và điều kiện để tiếp tục!');
            }
        });
    </script>
</body>
</html>
