 <%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
    String cPath = request.getContextPath();
    request.setAttribute("pageTitle", "Thanh toán - Yen Coffee House");
%>

<jsp:include page="/WEB-INF/view/layout/public/header.jsp"/>
<jsp:include page="/WEB-INF/view/layout/public/navbar.jsp"/>

<style>
  :root{ --bg-dark:#0f0f10; --bg-darker:#0a0a0b; --gold:#c7a17a; }
  body{background:#0c0c0d;color:#e9e9e9;font-family:"Poppins",system-ui,-apple-system,Segoe UI,Roboto,"Helvetica Neue",Arial,"Noto Sans",sans-serif;padding-top:80px}
  a{color:inherit;text-decoration:none}

  /* Hero Section with Blur Background */
  .checkout-hero{
    position:relative;min-height:30vh;
    background:url('<%=cPath%>/assets/images/bg_3.jpg') center/cover no-repeat fixed;
  }
  .checkout-hero:before{
    content:"";position:absolute;inset:0;
    background:linear-gradient(180deg,rgba(0,0,0,.6),rgba(0,0,0,.8));
    backdrop-filter:blur(2px);
    -webkit-backdrop-filter:blur(2px);
  }
  .checkout-hero .content{
    position:relative;z-index:2;
    display:flex;align-items:center;justify-content:center;
    flex-direction:column;height:30vh;text-align:center;padding:2rem 1rem
  }
  .checkout-hero h1{
    font-weight:900;letter-spacing:.5px;text-transform:uppercase;
    margin:0 0 .35rem;color:#fff;font-size:2.5rem
  }
  .breadcrumbs{color:#cfcfcf;font-size:1rem;margin-top:.5rem}
  .breadcrumbs a:hover{color:var(--gold)}

  /* Main Content */
  .checkout-section{
    padding:3rem 0;
    background:linear-gradient(180deg,var(--bg-dark),var(--bg-darker));
    position:relative;
  }

  /* Form Cards */
  .checkout-card{
    background:rgba(15,15,16,0.85);
    backdrop-filter:blur(10px);
    border-radius:15px;
    padding:2rem;
    margin-bottom:2rem;
    border:1px solid rgba(199,161,122,0.2);
    box-shadow:0 8px 32px rgba(0,0,0,0.3);
  }

  .checkout-card h3{
    font-size:1.5rem;font-weight:700;color:var(--gold);
    margin-bottom:1.5rem;text-transform:uppercase;
    letter-spacing:1px;
    display:flex;align-items:center;gap:0.75rem;
  }

  .checkout-card h3 i{font-size:1.3rem;}

  /* Form Styles */
  .form-label{
    font-weight:600;color:#e9e9e9;margin-bottom:0.75rem;
    font-size:0.95rem;text-transform:uppercase;letter-spacing:0.5px;
  }

  .form-control, .form-select{
    background:rgba(0,0,0,0.4);
    border:1px solid rgba(199,161,122,0.3);
    border-radius:8px;
    padding:0.75rem 1rem;
    color:#e9e9e9;
    transition:all 0.3s ease;
  }

  .form-control:focus, .form-select:focus{
    background:rgba(0,0,0,0.5);
    border-color:var(--gold);
    box-shadow:0 0 0 0.2rem rgba(199,161,122,0.25);
    color:#fff;
    outline:none;
  }

  .form-control:disabled, .form-control[readonly]{
    background:rgba(0,0,0,0.2);
    border-color:rgba(199,161,122,0.2);
    color:#888;
    cursor:not-allowed;
  }

  .form-control::placeholder{
    color:#888;
  }

  /* Payment Method Radio */
  .payment-method-radio{
    display:flex;align-items:center;
    padding:1rem 1.25rem;
    border:2px solid rgba(199,161,122,0.3);
    border-radius:10px;
    margin-bottom:0.75rem;
    cursor:pointer;
    transition:all 0.3s ease;
    background:rgba(0,0,0,0.2);
  }

  .payment-method-radio:hover{
    border-color:var(--gold);
    background:rgba(199,161,122,0.1);
  }

  .payment-method-radio input[type="radio"]{
    margin-right:0.75rem;
    cursor:pointer;
    width:18px;height:18px;
  }

  .payment-method-radio input[type="radio"]:checked + label{
    color:var(--gold);
    font-weight:600;
  }

  .payment-method-radio label{
    flex:1;margin:0;cursor:pointer;
    display:flex;align-items:center;gap:0.5rem;
    color:#e9e9e9;
  }

  .payment-icon{font-size:1.2rem;}

  /* Order Summary */
  .order-summary{
    background:rgba(0,0,0,0.3);
    border-radius:10px;
    padding:1.5rem;
    border:1px solid rgba(199,161,122,0.2);
  }

  .order-item{
    display:flex;justify-content:space-between;
    padding:0.75rem 0;
    border-bottom:1px solid rgba(199,161,122,0.1);
  }

  .order-item:last-child{border-bottom:none;}

  .order-item strong{color:#fff;}

  .summary-row{
    display:flex;justify-content:space-between;
    padding:0.75rem 0;
    border-bottom:1px solid rgba(199,161,122,0.1);
    color:#e9e9e9;
  }

  .summary-row:last-child{
    border-bottom:none;
    font-weight:700;
    font-size:1.2rem;
    color:var(--gold);
    padding-top:1rem;
    margin-top:0.5rem;
    border-top:2px solid var(--gold);
  }

  /* Promotion Code Section */
  .promo-section{
    margin-top:1rem;
    padding-top:1rem;
    border-top:1px solid rgba(199,161,122,0.1);
  }

  .promo-input-group{
    display:flex;gap:0.5rem;
  }

  .promo-input-group .form-control{
    flex:1;
  }

  .promo-btn{
    background:var(--gold);
    color:#000;
    border:none;
    border-radius:8px;
    padding:0.75rem 1.5rem;
    font-weight:600;
    cursor:pointer;
    transition:all 0.3s ease;
  }

  .promo-btn:hover{
    background:#d4b08c;
    transform:translateY(-2px);
  }

  .promo-message{
    margin-top:0.5rem;font-size:0.875rem;
  }

  /* Buttons */
  .checkout-btn{
    width:100%;
    background:var(--gold);
    color:#000;
    border:none;
    border-radius:10px;
    padding:1rem 2rem;
    font-size:1.1rem;
    font-weight:700;
    cursor:pointer;
    transition:all 0.3s ease;
    text-transform:uppercase;
    letter-spacing:1px;
    margin-top:1.5rem;
  }

  .checkout-btn:hover{
    background:#d4b08c;
    transform:translateY(-2px);
    box-shadow:0 6px 20px rgba(199,161,122,0.4);
  }

  .checkout-btn:disabled{
    background:#6c757d;
    cursor:not-allowed;
    transform:none;
  }

  .back-btn{
    width:100%;
    background:transparent;
    color:#e9e9e9;
    border:2px solid rgba(199,161,122,0.3);
    border-radius:10px;
    padding:0.75rem 2rem;
    font-weight:600;
    cursor:pointer;
    transition:all 0.3s ease;
    margin-top:0.75rem;
    text-decoration:none;
    display:block;
    text-align:center;
  }

  .back-btn:hover{
    border-color:var(--gold);
    color:var(--gold);
    background:rgba(199,161,122,0.1);
  }

  /* PayOS Info */
  #payosInfo{
    margin-top:1rem;
    padding:1rem;
    background:rgba(199,161,122,0.1);
    border-radius:8px;
    text-align:center;
  }

  #payosInfo img{height:40px;}

  #embedded-payment-container{
    margin-top:1rem;
    border-radius:10px;
    overflow:hidden;
    min-height:500px;
  }

  /* Responsive */
  @media (max-width:768px){
    .checkout-hero h1{font-size:1.8rem;}
    .checkout-card{padding:1.5rem;}
  }
</style>

<!-- Hero Section -->
<div class="checkout-hero">
    <div class="content">
        <h1>THANH TOÁN</h1>
        <div class="breadcrumbs">
            <a href="<%=cPath%>/home">TRANG CHỦ</a> / 
            <a href="<%=cPath%>/home/cart">GIỎ HÀNG</a> / 
            <span>THANH TOÁN</span>
        </div>
    </div>
</div>

<!-- Main Content -->
<div class="checkout-section">
    <div class="container">
        <!-- Alert Messages -->
        <c:if test="${not empty sessionScope.paymentCancelled}">
            <div class="alert alert-warning alert-dismissible fade show" role="alert" style="background:rgba(255,193,7,0.2);border-color:#ffc107;color:#fff;">
                <i class="fas fa-exclamation-triangle"></i> ${sessionScope.errorMessage}
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert"></button>
            </div>
            <c:remove var="paymentCancelled" scope="session"/>
            <c:remove var="errorMessage" scope="session"/>
        </c:if>

        <form id="checkoutForm" method="POST" action="${pageContext.request.contextPath}/home/cart/checkout">
            <div class="row">
                <!-- Left Column: Customer Information & Payment Method -->
                <div class="col-lg-7">
                    <!-- Customer Information -->
                    <div class="checkout-card">
                        <h3>
                            <i class="fas fa-user"></i>
                            Thông tin nhận hàng
                        </h3>
                        
                        <div class="mb-3">
                            <label for="fullName" class="form-label">Họ và tên <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="fullName" name="fullName" 
                                   value="${fullName != null ? fullName : ''}" readonly>
                        </div>

                        <div class="mb-3">
                            <label for="phoneContact" class="form-label">Số điện thoại <span class="text-danger">*</span></label>
                            <input type="tel" class="form-control" id="phoneContact" name="phoneContact" 
                                   value="${phoneContact != null ? phoneContact : ''}" 
                                   pattern="[0-9]{10,11}" placeholder="0XXXXXXXXX" required>
                        </div>

                        <div class="mb-3">
                            <label for="shippingAddress" class="form-label">Địa chỉ giao hàng <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="shippingAddress" name="shippingAddress" 
                                   value="${shippingAddress != null ? shippingAddress : ''}" 
                                   placeholder="Số nhà, đường, phường/xã, quận/huyện, TP" required>
                        </div>

                        <div class="mb-3">
                            <label for="note" class="form-label">Ghi chú</label>
                            <textarea class="form-control" id="note" name="note" rows="3" 
                                      placeholder="Ví dụ: gọi trước khi tới">${cart.note != null ? cart.note : ''}</textarea>
                        </div>
                    </div>

                    <!-- Payment Method -->
                    <div class="checkout-card">
                        <h3>
                            <i class="fas fa-credit-card"></i>
                            Phương thức thanh toán
                        </h3>

                        <div class="payment-method-radio">
                            <input type="radio" id="paymentCash" name="paymentMethod" value="Cash" checked>
                            <label for="paymentCash">
                                <i class="fas fa-money-bill-wave payment-icon"></i>
                                Tiền mặt khi nhận hàng (COD)
                            </label>
                        </div>

                        <div class="payment-method-radio">
                            <input type="radio" id="paymentPayOS" name="paymentMethod" value="PayOS">
                            <label for="paymentPayOS">
                                <i class="fas fa-credit-card payment-icon"></i>
                                Chuyển khoản ngân hàng (PayOS)
                            </label>
                        </div>

                        <div class="text-center mt-3" id="payosInfo" style="display: none;">
                            <img src="https://payos.vn/docs/img/logo.svg" alt="PayOS" style="height: 40px;">
                            <p class="text-muted mt-2" style="color:#888;">Thanh toán an toàn với PayOS</p>
                        </div>

                        <!-- Embedded Payment Container (for PayOS) -->
                        <div id="embedded-payment-container" style="height: 500px; display: none;"></div>
                    </div>
                </div>

                <!-- Right Column: Order Summary -->
                <div class="col-lg-5">
                    <div class="checkout-card">
                        <h3>
                            <i class="fas fa-list-ul"></i>
                            Đơn hàng của bạn
                        </h3>
                        <div class="order-summary">
                            <c:forEach var="item" items="${cartItems}">
                                <div class="order-item">
                                    <div>
                                        <strong>${item.productName}</strong>
                                        <br>
                                        <small style="color:#888;">
                                            <fmt:formatNumber value="${item.unitPrice}" type="number" groupingUsed="true"/>₫
                                            × ${item.quantity}
                                        </small>
                                    </div>
                                    <div>
                                        <strong>
                                            <fmt:formatNumber value="${item.subtotal}" type="number" groupingUsed="true"/>₫
                                        </strong>
                                    </div>
                                </div>
                            </c:forEach>

                            <div class="summary-row">
                                <span>Tạm tính</span>
                                <span><fmt:formatNumber value="${subtotal}" type="number" groupingUsed="true"/>₫</span>
                            </div>
                            
                            <div class="summary-row">
                                <span>Phí giao hàng</span>
                                <span>
                                    <c:choose>
                                        <c:when test="${shipping == 0}">
                                            <span style="color:#22c55e;">Miễn phí</span>
                                        </c:when>
                                        <c:otherwise>
                                            <fmt:formatNumber value="${shipping}" type="number" groupingUsed="true"/>₫
                                        </c:otherwise>
                                    </c:choose>
                                </span>
                            </div>

                            <!-- Promotion Code Section (moved here) -->
                            <div class="promo-section">
                                <label class="form-label" style="font-size:0.85rem;margin-bottom:0.5rem;">
                                    <i class="fas fa-tag"></i> Nhập mã giảm giá
                                </label>
                                <div class="promo-input-group">
                                    <input type="text" class="form-control" id="promotionCode" name="promotionCode" 
                                           value="${promotionCode != null ? promotionCode : ''}" 
                                           placeholder="Nhập mã khuyến mãi">
                                    <button type="button" class="promo-btn" id="applyPromoBtn">
                                        <i class="fas fa-check"></i> Áp dụng
                                    </button>
                                </div>
                                <div id="promoMessage" class="promo-message"></div>
                            </div>

                            <div id="discountRow" class="summary-row" style="color:#22c55e;display:none;">
                                <span>Giảm giá</span>
                                <span id="discountAmountDisplay">-0₫</span>
                            </div>
                            
                            <div class="summary-row">
                                <span>Thành tiền</span>
                                <span id="totalAmountDisplay"><fmt:formatNumber value="${total}" type="number" groupingUsed="true"/>₫</span>
                            </div>
                            
                            <!-- Hidden values for calculation -->
                            <input type="hidden" id="subtotalValue" value="${subtotal}">
                            <input type="hidden" id="shippingValue" value="${shipping}">
                            <input type="hidden" id="currentDiscount" value="${discountAmount != null ? discountAmount : 0}">
                        </div>

                        <!-- Action Buttons -->
                        <button type="submit" id="submitCheckoutBtn" class="checkout-btn">
                            <i class="fas fa-check"></i> Đặt hàng
                        </button>
                        
                        <a href="${pageContext.request.contextPath}/home/cart" class="back-btn">
                            <i class="fas fa-arrow-left"></i> Quay lại giỏ hàng
                        </a>
                    </div>
                </div>
            </div>
        </form>
    </div>
</div>

<jsp:include page="/WEB-INF/view/layout/public/footer.jsp"/>

<!-- Scripts -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<!-- Toast Notification Container -->
<div class="toast-container position-fixed" style="top: 50%; left: 50%; transform: translate(-50%, -50%); z-index: 99999; pointer-events: none;">
    <div id="toastNotification" class="toast shadow-lg" role="alert" aria-live="assertive" aria-atomic="true" style="min-width: 400px; max-width: 500px; border: none; border-radius: 12px; overflow: hidden; pointer-events: auto; background:rgba(15,15,16,0.95);">
        <div class="toast-header" id="toastHeader" style="border-bottom: 2px solid;">
            <i id="toastIcon" class="fas me-2 fs-5"></i>
            <strong class="me-auto" id="toastTitle" style="color:#e9e9e9;">Thông báo</strong>
            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="toast" aria-label="Close"></button>
        </div>
        <div class="toast-body" id="toastMessage" style="font-size: 0.95rem; padding: 1.25rem; color:#e9e9e9;"></div>
    </div>
</div>

<!-- Notification Helper Functions -->
<script>
function showNotification(message, type = 'info', title = 'Thông báo') {
    const toast = document.getElementById('toastNotification');
    if (!toast) {
        alert(message);
        return;
    }
    
    const toastIcon = document.getElementById('toastIcon');
    const toastTitle = document.getElementById('toastTitle');
    const toastMessage = document.getElementById('toastMessage');
    const toastHeader = document.getElementById('toastHeader');
    
    const configs = {
        'success': { 
            icon: 'fa-check-circle', 
            iconColor: 'text-white',
            headerBg: 'bg-success',
            headerText: 'text-white',
            borderColor: '#28a745'
        },
        'error': { 
            icon: 'fa-exclamation-circle', 
            iconColor: 'text-white',
            headerBg: 'bg-danger',
            headerText: 'text-white',
            borderColor: '#dc3545'
        },
        'warning': { 
            icon: 'fa-exclamation-triangle', 
            iconColor: 'text-dark',
            headerBg: 'bg-warning',
            headerText: 'text-dark',
            borderColor: '#ffc107'
        },
        'info': { 
            icon: 'fa-info-circle', 
            iconColor: 'text-white',
            headerBg: 'bg-info',
            headerText: 'text-white',
            borderColor: '#17a2b8'
        }
    };
    
    const config = configs[type] || configs['info'];
    toastIcon.className = 'fas ' + config.icon + ' me-2 ' + config.iconColor;
    toastHeader.className = 'toast-header ' + config.headerBg + ' ' + config.headerText;
    toastHeader.style.borderBottomColor = config.borderColor;
    toastTitle.textContent = title;
    toastMessage.textContent = message;
    
    const bsToast = new bootstrap.Toast(toast, { autohide: true, delay: 5000 });
    bsToast.show();
}
</script>

<script src="https://cdn.payos.vn/payos-checkout/v1/stable/payos-initialize.js"></script>
<script>
    // Payment method change handler
    document.querySelectorAll('input[name="paymentMethod"]').forEach(radio => {
        radio.addEventListener('change', function() {
            const payosInfo = document.getElementById('payosInfo');
            const embeddedContainer = document.getElementById('embedded-payment-container');
            
            if (this.value === 'PayOS') {
                payosInfo.style.display = 'block';
            } else {
                payosInfo.style.display = 'none';
                embeddedContainer.style.display = 'none';
            }
        });
    });

    // Format number helper
    function formatNumber(num) {
        return new Intl.NumberFormat('vi-VN').format(num);
    }

    // Update total display
    function updateTotalDisplay() {
        const subtotal = parseFloat(document.getElementById('subtotalValue').value) || 0;
        const shipping = parseFloat(document.getElementById('shippingValue').value) || 0;
        const discount = parseFloat(document.getElementById('currentDiscount').value) || 0;
        
        const total = subtotal + shipping - discount;
        
        // Update discount row
        const discountRow = document.getElementById('discountRow');
        const discountDisplay = document.getElementById('discountAmountDisplay');
        
        if (discount > 0) {
            discountRow.style.display = 'flex';
            discountDisplay.textContent = '-' + formatNumber(discount) + '₫';
        } else {
            discountRow.style.display = 'none';
        }
        
        // Update total
        document.getElementById('totalAmountDisplay').textContent = formatNumber(total) + '₫';
    }

    // Save form data to localStorage
    function saveFormData() {
        const formData = {
            phoneContact: document.getElementById('phoneContact').value,
            shippingAddress: document.getElementById('shippingAddress').value,
            note: document.getElementById('note').value,
            promotionCode: document.getElementById('promotionCode').value
        };
        localStorage.setItem('checkoutFormData', JSON.stringify(formData));
    }

    // Load form data from localStorage
    function loadFormData() {
        const saved = localStorage.getItem('checkoutFormData');
        if (saved) {
            try {
                const formData = JSON.parse(saved);
                if (formData.phoneContact) {
                    document.getElementById('phoneContact').value = formData.phoneContact;
                }
                if (formData.shippingAddress) {
                    document.getElementById('shippingAddress').value = formData.shippingAddress;
                }
                if (formData.note) {
                    document.getElementById('note').value = formData.note;
                }
                if (formData.promotionCode) {
                    document.getElementById('promotionCode').value = formData.promotionCode;
                }
            } catch (e) {
                console.error('Error loading form data:', e);
            }
        }
    }

    // Auto-save form data on input
    ['phoneContact', 'shippingAddress', 'note', 'promotionCode'].forEach(id => {
        const element = document.getElementById(id);
        if (element) {
            element.addEventListener('input', saveFormData);
            element.addEventListener('change', saveFormData);
        }
    });

    // Load form data on page load
    document.addEventListener('DOMContentLoaded', function() {
        loadFormData();
        updateTotalDisplay();
    });

    // Apply promotion code
    document.getElementById('applyPromoBtn').addEventListener('click', async function() {
        const promoCode = document.getElementById('promotionCode').value.trim();
        const promoMessage = document.getElementById('promoMessage');
        
        if (!promoCode) {
            promoMessage.innerHTML = '<small class="text-danger">Vui lòng nhập mã khuyến mãi</small>';
            return;
        }

        this.disabled = true;
        const originalText = this.innerHTML;
        this.innerHTML = '<i class="fas fa-spinner fa-spin"></i>';

        try {
            const response = await fetch('${pageContext.request.contextPath}/home/cart/apply-promo', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'promotionCode=' + encodeURIComponent(promoCode) + '&orderId=${cart.orderId}'
            });

            const result = await response.json();
            
            if (result.success) {
                promoMessage.innerHTML = '<small class="text-success"><i class="fas fa-check"></i> ' + result.message + '</small>';
                
                // Update discount value
                const discountAmount = result.discountAmount || 0;
                document.getElementById('currentDiscount').value = discountAmount;
                
                // Update display without reload
                updateTotalDisplay();
                
                // Save form data
                saveFormData();
                
                showNotification('Áp dụng mã khuyến mãi thành công!', 'success', 'Thành công');
            } else {
                promoMessage.innerHTML = '<small class="text-danger"><i class="fas fa-times"></i> ' + result.message + '</small>';
                showNotification(result.message, 'error', 'Lỗi');
            }
        } catch (error) {
            console.error('Error:', error);
            promoMessage.innerHTML = '<small class="text-danger">Có lỗi xảy ra khi áp dụng mã khuyến mãi</small>';
            showNotification('Có lỗi xảy ra khi áp dụng mã khuyến mãi', 'error', 'Lỗi');
        } finally {
            this.disabled = false;
            this.innerHTML = originalText;
        }
    });

    // Clear localStorage on successful form submission
    function clearFormData() {
        localStorage.removeItem('checkoutFormData');
    }

    // Form submission handler
    document.getElementById('checkoutForm').addEventListener('submit', async function(e) {
        e.preventDefault();
        
        const paymentMethod = document.querySelector('input[name="paymentMethod"]:checked').value;
        const submitBtn = document.getElementById('submitCheckoutBtn');
        
        // Validate form
        const phoneContact = document.getElementById('phoneContact').value.trim();
        const shippingAddress = document.getElementById('shippingAddress').value.trim();
        
        if (!phoneContact || !shippingAddress) {
            showNotification('Vui lòng điền đầy đủ thông tin khách hàng', 'error', 'Lỗi');
            return;
        }
        
        // Save form data before submit
        saveFormData();

        if (paymentMethod === 'PayOS') {
            // Handle PayOS payment
            submitBtn.disabled = true;
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang tạo link thanh toán...';

            try {
                // First, save order info
                const formData = new FormData(this);
                formData.append('action', 'save-info');
                
                const saveResponse = await fetch('${pageContext.request.contextPath}/home/cart/checkout', {
                    method: 'POST',
                    body: formData
                });

                if (!saveResponse.ok) {
                    throw new Error('Không thể lưu thông tin đơn hàng');
                }

                // Then create payment link
                const paymentResponse = await fetch('${pageContext.request.contextPath}/payment/create-payment-link', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    }
                });

                const result = await paymentResponse.json();

                // Check for error response
                if (!result.success && result.message) {
                    showNotification('Không thể tạo link thanh toán: ' + result.message, 'error', 'Lỗi');
                    submitBtn.disabled = false;
                    submitBtn.innerHTML = '<i class="fas fa-check"></i> Đặt hàng';
                    return;
                }

                // Check if checkoutUrl exists
                if (result.checkoutUrl) {
                    console.log('PayOS checkout URL received:', result.checkoutUrl);
                    
                    // Option 1: Direct redirect (simpler, recommended)
                    window.location.href = result.checkoutUrl;
                    return;
                    
                    // Option 2: Embedded payment (commented out, use if needed)
                    /*
                    const config = {
                        RETURN_URL: window.location.origin + '${pageContext.request.contextPath}/payment/success?orderId=${cart.orderId}',
                        ELEMENT_ID: 'embedded-payment-container',
                        CHECKOUT_URL: result.checkoutUrl,
                        embedded: true,
                        onSuccess: function(event) {
                            console.log('Payment success event:', event);
                            clearFormData();
                            verifyPayment();
                        }
                    };
                    const payosInstance = PayOSCheckout.usePayOS(config);
                    payosInstance.open();
                    document.getElementById('embedded-payment-container').style.display = 'block';
                    submitBtn.innerHTML = '<i class="fas fa-times"></i> Đóng thanh toán';
                    submitBtn.onclick = function() {
                        payosInstance.exit();
                        document.getElementById('embedded-payment-container').style.display = 'none';
                        submitBtn.innerHTML = '<i class="fas fa-check"></i> Đặt hàng';
                        submitBtn.disabled = false;
                    };
                    startPaymentPolling();
                    */
                } else {
                    // No checkoutUrl in response
                    const errorMsg = result.message || 'Không thể tạo link thanh toán';
                    console.error('Payment link creation failed:', result);
                    showNotification('Lỗi: ' + errorMsg, 'error', 'Lỗi');
                    submitBtn.disabled = false;
                    submitBtn.innerHTML = '<i class="fas fa-check"></i> Đặt hàng';
                }
                    } catch (error) {
                        console.error('Error:', error);
                        showNotification('Có lỗi xảy ra khi tạo link thanh toán', 'error', 'Lỗi');
                        submitBtn.disabled = false;
                        submitBtn.innerHTML = '<i class="fas fa-check"></i> Đặt hàng';
                    }
                } else {
                    // Handle Cash/COD payment
                    submitBtn.disabled = true;
                    submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang xử lý...';
                    
                    // First, save order info
                    const formData = new FormData(this);
                    formData.append('action', 'save-info');
                    
                    try {
                        const saveResponse = await fetch('${pageContext.request.contextPath}/home/cart/checkout', {
                            method: 'POST',
                            body: formData
                        });

                        if (!saveResponse.ok) {
                            throw new Error('Không thể lưu thông tin đơn hàng');
                        }

                        // Then submit checkout - create a form and submit it
                        const checkoutForm = document.createElement('form');
                        checkoutForm.method = 'POST';
                        checkoutForm.action = '${pageContext.request.contextPath}/home/cart/checkout';
                        checkoutForm.style.display = 'none';
                        
                        // Add action field
                        const actionInput = document.createElement('input');
                        actionInput.type = 'hidden';
                        actionInput.name = 'action';
                        actionInput.value = 'checkout';
                        checkoutForm.appendChild(actionInput);
                        
                        // Add payment method field
                        const paymentInput = document.createElement('input');
                        paymentInput.type = 'hidden';
                        paymentInput.name = 'paymentMethod';
                        paymentInput.value = 'Cash';
                        checkoutForm.appendChild(paymentInput);
                        
                        // Add all other form fields
                        const originalForm = document.getElementById('checkoutForm');
                        const formInputs = originalForm.querySelectorAll('input, textarea, select');
                        formInputs.forEach(input => {
                            if (input.name && input.name !== 'paymentMethod' && input.type !== 'radio') {
                                const newInput = document.createElement('input');
                                newInput.type = 'hidden';
                                newInput.name = input.name;
                                newInput.value = input.value;
                                checkoutForm.appendChild(newInput);
                            }
                        });
                        
                        // Add radio button value if checked
                        const checkedPayment = originalForm.querySelector('input[name="paymentMethod"]:checked');
                        if (checkedPayment) {
                            paymentInput.value = checkedPayment.value === 'PayOS' ? 'PayOS' : 'Cash';
                        }
                        
                        document.body.appendChild(checkoutForm);
                        
                        // Clear saved form data before submit
                        clearFormData();
                        
                        // Submit form (will redirect to payment success page)
                        checkoutForm.submit();
                    } catch (error) {
                        console.error('Error:', error);
                        showNotification('Có lỗi xảy ra khi đặt hàng: ' + error.message, 'error', 'Lỗi');
                        submitBtn.disabled = false;
                        submitBtn.innerHTML = '<i class="fas fa-check"></i> Đặt hàng';
                    }
                }
            });

    // Verify payment status
    function verifyPayment() {
        fetch('${pageContext.request.contextPath}/payment/verify-payment?orderId=${cart.orderId}', {
            method: 'POST'
        })
        .then(response => response.json())
            .then(data => {
                console.log('Verify payment response:', data);
                if (data.success && data.status === 'PAID') {
                    clearFormData(); // Clear saved form data on payment success
                    window.location.href = '${pageContext.request.contextPath}/my-orders';
                } else {
                    showNotification('Thanh toán chưa được xác nhận: ' + data.message, 'warning', 'Cảnh báo');
                }
            })
        .catch(error => {
            console.error('Error verifying payment:', error);
        });
    }

    // Poll payment status every 3 seconds
    let pollingInterval = null;
    function startPaymentPolling() {
        if (pollingInterval) {
            clearInterval(pollingInterval);
        }

        pollingInterval = setInterval(() => {
            fetch('${pageContext.request.contextPath}/payment/verify-payment?orderId=${cart.orderId}', {
                method: 'POST'
            })
            .then(response => response.json())
                    .then(data => {
                        console.log('Polling payment status:', data);
                        if (data.success && data.status === 'PAID') {
                            clearInterval(pollingInterval);
                            clearFormData(); // Clear saved form data on payment success
                            window.location.href = '${pageContext.request.contextPath}/my-orders';
                        } else if (data.status === 'CANCELLED') {
                            clearInterval(pollingInterval);
                            showNotification('Thanh toán đã bị hủy', 'warning', 'Thông báo');
                        }
                    })
            .catch(error => {
                console.error('Error polling payment:', error);
            });
        }, 3000);
    }

    // Clear polling when page unloads
    window.addEventListener('beforeunload', () => {
        if (pollingInterval) {
            clearInterval(pollingInterval);
        }
    });
</script>
</body>
</html>
