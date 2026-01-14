<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ page import="java.math.BigDecimal" %>
<%
    String cPath = request.getContextPath();
    Object authUserObj = session.getAttribute("authUser");
    model.UserDto authUser = (model.UserDto) authUserObj;

    java.util.List<model.OrderItem> cartItems =
        (java.util.List<model.OrderItem>) request.getAttribute("cartItems");
    if (cartItems == null) {
        cartItems = new java.util.ArrayList<>();
    }

    BigDecimal subtotal = (BigDecimal) request.getAttribute("subtotal");
    BigDecimal shipping = (BigDecimal) request.getAttribute("shipping");
    BigDecimal total = (BigDecimal) request.getAttribute("total");

    if (subtotal == null) subtotal = BigDecimal.ZERO;
    if (shipping == null) shipping = BigDecimal.ZERO;
    if (total == null) total = BigDecimal.ZERO;

    request.setAttribute("pageTitle", "Giỏ hàng - Yen Coffee House");
%>

<jsp:include page="/WEB-INF/view/layout/public/header.jsp"/>
<jsp:include page="/WEB-INF/view/layout/public/navbar.jsp"/>

<style>
  :root{ --bg-dark:#0f0f10; --bg-darker:#0a0a0b; --gold:#c7a17a; }
  body{background:#0c0c0d;color:#e9e9e9;font-family:"Poppins",system-ui,-apple-system,Segoe UI,Roboto,"Helvetica Neue",Arial,"Noto Sans",sans-serif;padding-top:80px}
  a{color:inherit;text-decoration:none}

  /* ===== NAVBAR ===== */
  #yc-navbar{
    background:rgba(15,15,16,0.95)!important;
    backdrop-filter:blur(10px);
    -webkit-backdrop-filter:blur(10px);
    z-index:1000;
    padding:0.75rem 0;
    box-shadow:0 2px 10px rgba(0,0,0,0.3);
  }
  .navbar-brand{
    font-size:1.3rem;
    font-weight:700;
    letter-spacing:1px;
    color:#fff!important;
    text-transform:uppercase;
  }
  .yc-spaced{
    letter-spacing:1.5px;
    font-weight:500;
    font-size:0.9rem;
    text-transform:uppercase;
    color:#fff!important;
    padding:0.5rem 1rem!important;
  }
  .yc-spaced:hover{
    color:var(--gold)!important;
  }
  .badge-cart{
    background:#dc3545;
    color:#fff;
    padding:2px 6px;
    border-radius:50%;
    font-size:0.7rem;
    font-weight:700;
    display:inline-flex;
    align-items:center;
    justify-content:center;
    min-width:18px;
    height:18px;
    position:absolute;
    top:-5px;
    right:-5px;
  }
  .navbar-nav .nav-link{
    color:#fff!important;
  }
  .navbar-nav .nav-link i{
    font-size:1.2rem;
  }

  .container {
    max-width: 1200px;
    margin: 0 auto;
    padding: 0 2rem;
  }

  .page-header {
    background:rgba(15,15,16,0.6);
    backdrop-filter:blur(10px);
    border-radius:12px;
    padding:2rem;
    margin:2rem 0;
    border:1px solid rgba(199,161,122,0.2);
  }

  .page-title {
    font-size:2.5rem;
    font-weight:700;
    color:var(--gold);
    margin-bottom:0.5rem;
    letter-spacing:1px;
  }

  .page-subtitle {
    color:#b0b0b0;
    font-size:1.1rem;
  }

  .cart-container {
    display:grid;
    grid-template-columns:2fr 1fr;
    gap:2rem;
    margin:2rem 0;
  }

  .cart-items {
    background:rgba(15,15,16,0.6);
    backdrop-filter:blur(10px);
    border-radius:12px;
    padding:2rem;
    border:1px solid rgba(199,161,122,0.2);
  }

  .cart-item {
    display:flex;
    align-items:center;
    padding:1.5rem 0;
    border-bottom:1px solid rgba(199,161,122,0.1);
  }

  .cart-item:last-child {
    border-bottom:none;
  }

  .cart-item-image {
    width:80px;
    height:80px;
    background:rgba(0,0,0,0.3);
    border-radius:8px;
    display:flex;
    align-items:center;
    justify-content:center;
    color:#888;
    font-size:0.8rem;
    margin-right:1rem;
    overflow:hidden;
  }

  .cart-item-info {
    flex:1;
  }

  .cart-item-name {
    font-weight:600;
    color:#fff;
    margin-bottom:0.25rem;
    font-size:1.1rem;
  }

  .cart-item-price {
    color:var(--gold);
    font-weight:600;
    font-size:1.1rem;
  }

  .quantity-controls {
    display:flex;
    align-items:center;
    gap:0.5rem;
    margin:0 1rem;
  }

  .quantity-btn {
    width:32px;
    height:32px;
    border:1px solid rgba(199,161,122,0.3);
    background:rgba(0,0,0,0.3);
    border-radius:4px;
    display:flex;
    align-items:center;
    justify-content:center;
    cursor:pointer;
    transition:all 0.3s ease;
    color:#fff;
  }

  .quantity-btn:hover {
    background:var(--gold);
    color:#000;
    border-color:var(--gold);
  }

  .quantity-input {
    width:60px;
    text-align:center;
    border:1px solid rgba(199,161,122,0.3);
    background:rgba(0,0,0,0.3);
    border-radius:4px;
    padding:0.25rem;
    color:#fff;
  }

  .remove-btn {
    background:#dc3545;
    color:white;
    border:none;
    border-radius:4px;
    padding:0.5rem;
    cursor:pointer;
    transition:all 0.3s ease;
  }

  .remove-btn:hover {
    background:#c82333;
  }

  .cart-summary {
    background:rgba(15,15,16,0.6);
    backdrop-filter:blur(10px);
    border-radius:12px;
    padding:2rem;
    border:1px solid rgba(199,161,122,0.2);
    height:fit-content;
  }

  .summary-title {
    font-size:1.5rem;
    font-weight:600;
    color:var(--gold);
    margin-bottom:1.5rem;
  }

  .summary-row {
    display:flex;
    justify-content:space-between;
    margin-bottom:1rem;
    padding-bottom:1rem;
    border-bottom:1px solid rgba(199,161,122,0.1);
    color:#e9e9e9;
  }

  .summary-row:last-child {
    border-bottom:none;
    font-weight:600;
    font-size:1.1rem;
    color:var(--gold);
  }

  .checkout-btn {
    width:100%;
    background:var(--gold);
    color:#000;
    border:none;
    border-radius:8px;
    padding:1rem;
    font-size:1.1rem;
    font-weight:600;
    cursor:pointer;
    transition:all 0.3s ease;
    margin-top:1rem;
  }

  .checkout-btn:hover {
    background:#d4b08c;
  }

  .empty-cart {
    text-align:center;
    padding:4rem 2rem;
    color:#888;
    background:rgba(15,15,16,0.6);
    backdrop-filter:blur(10px);
    border-radius:12px;
    border:1px solid rgba(199,161,122,0.2);
  }

  .empty-cart i {
    font-size:4rem;
    margin-bottom:1rem;
    color:var(--gold);
  }

  .empty-cart h3 {
    margin-bottom:1rem;
    color:#e9e9e9;
  }

  .continue-shopping {
    background:var(--gold);
    color:#000;
    border:none;
    border-radius:8px;
    padding:0.75rem 2rem;
    font-weight:600;
    cursor:pointer;
    transition:all 0.3s ease;
    text-decoration:none;
    display:inline-block;
  }

  .continue-shopping:hover {
    background:#d4b08c;
    color:#000;
    text-decoration:none;
  }
  

  @media (max-width: 768px) {
    .cart-container {
      grid-template-columns:1fr;
      gap:1rem;
    }

    .cart-item {
      flex-direction:column;
      align-items:flex-start;
      gap:1rem;
    }

    .cart-item-image {
      margin-right:0;
    }

    .quantity-controls {
      margin:0;
    }
  }
</style>

    <div class="container">
        <!-- Page Header -->
        <div class="page-header">
            <h1 class="page-title">Giỏ hàng</h1>
            <p class="page-subtitle">Quản lý các sản phẩm bạn đã chọn</p>
        </div>

        <% if (cartItems.isEmpty()) { %>
            <!-- Empty Cart -->
            <div class="empty-cart">
                <i class="fas fa-shopping-cart"></i>
                <h3>Giỏ hàng trống</h3>
                <p>Bạn chưa có sản phẩm nào trong giỏ hàng</p>
                <a href="<%=cPath%>/home/public-products" class="continue-shopping">
                    <i class="fas fa-arrow-left"></i> Tiếp tục mua sắm
                </a>
            </div>
        <% } else { %>
            <!-- Cart Content -->
            <div class="cart-container">
                <!-- Cart Items -->
                <div class="cart-items">
                    <h3 class="mb-4" style="color:var(--gold);">Sản phẩm đã chọn</h3>

                    <c:forEach var="item" items="${cartItems}">
                        <div class="cart-item">
                            <div class="cart-item-image">
                                <c:choose>
                                    <c:when test="${not empty item.productImageUrl}">
                                        <img src="${item.productImageUrl}" alt="${item.productName}"
                                             style="width:100%;height:100%;object-fit:cover;border-radius:8px;">
                                    </c:when>
                                    <c:otherwise>
                                        <i class="fas fa-coffee" style="font-size:2rem;color:#888;"></i>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="cart-item-info">
                                <div class="cart-item-name">${item.productName}</div>
                                <div class="cart-item-price">
                                    <fmt:formatNumber value="${item.unitPrice}" type="number" groupingUsed="true"/>₫
                                </div>
                            </div>
                            <div class="quantity-controls">
                                <button class="quantity-btn" onclick="updateQuantity('${item.productId}', parseInt('${item.quantity}') - 1)">
                                    <i class="fas fa-minus"></i>
                                </button>
                                <input type="number" class="quantity-input" value="${item.quantity}"
                                       min="1" max="99" onchange="updateQuantity('${item.productId}', this.value)">
                                <button class="quantity-btn" onclick="updateQuantity('${item.productId}', parseInt('${item.quantity}') + 1)">
                                    <i class="fas fa-plus"></i>
                                </button>
                            </div>
                            <div class="cart-item-price">
                                <fmt:formatNumber value="${item.subtotal}" type="number" groupingUsed="true"/>₫
                            </div>
                            <button class="remove-btn" onclick="removeItem('${item.productId}')">
                                <i class="fas fa-trash"></i>
                            </button>
                        </div>
                    </c:forEach>
                </div>

                <!-- Cart Summary -->
                <div class="cart-summary">
                    <h3 class="summary-title">Tóm tắt đơn hàng</h3>

                    <div class="summary-row">
                        <span>Tạm tính:</span>
                        <span style="color:var(--gold);"><%=String.format("%,d", subtotal.longValue())%>₫</span>
                    </div>

                    <div class="summary-row">
                        <span>Phí vận chuyển:</span>
                        <span>
                            <% if (shipping.compareTo(BigDecimal.ZERO) == 0) { %>
                                <span style="color:#22c55e;">Miễn phí</span>
                            <% } else { %>
                                <span style="color:var(--gold);"><%=String.format("%,d", shipping.longValue())%>₫</span>
                            <% } %>
                        </span>
                    </div>

                    <div class="summary-row" style="border-top:2px solid rgba(199,161,122,0.3);padding-top:1rem;margin-top:1rem;">
                        <span style="font-size:1.2rem;font-weight:700;">Tổng cộng:</span>
                        <span style="font-size:1.3rem;font-weight:700;color:var(--gold);"><%=String.format("%,d", total.longValue())%>₫</span>
                    </div>

                    <a href="<%=cPath%>/home/cart/checkout" class="checkout-btn" style="display:block;text-align:center;text-decoration:none;">
                        <i class="fas fa-credit-card"></i> Thanh toán
                    </a>

                    <a href="<%=cPath%>/home/public-products" class="continue-shopping" style="display:block;text-align:center;margin-top:1rem;">
                        <i class="fas fa-arrow-left"></i> Tiếp tục mua sắm
                    </a>
                </div>
            </div>
        <% } %>
    </div>

    <jsp:include page="/WEB-INF/view/layout/public/scripts.jsp"/>
    
    <script>
        // Wait for showCartToast to be available
        function waitForCartToast(callback) {
            if (typeof showCartToast === 'function') {
                callback();
            } else {
                setTimeout(() => waitForCartToast(callback), 50);
            }
        }
        
        function updateQuantity(productId, quantity) {
            if (quantity < 1) {
                removeItem(productId);
                return;
            }
            
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = '<%=cPath%>/home/cart';
            
            const actionInput = document.createElement('input');
            actionInput.type = 'hidden';
            actionInput.name = 'action';
            actionInput.value = 'update';
            
            const productIdInput = document.createElement('input');
            productIdInput.type = 'hidden';
            productIdInput.name = 'productId';
            productIdInput.value = productId;
            
            const quantityInput = document.createElement('input');
            quantityInput.type = 'hidden';
            quantityInput.name = 'quantity';
            quantityInput.value = quantity;
            
            form.appendChild(actionInput);
            form.appendChild(productIdInput);
            form.appendChild(quantityInput);
            
            document.body.appendChild(form);
            form.submit();
        }
        
        function removeItem(productId) {
            // Remove directly without confirmation, show toast notification
            waitForCartToast(() => {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '<%=cPath%>/home/cart';
            
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'remove';
            
                const productIdInput = document.createElement('input');
                productIdInput.type = 'hidden';
                productIdInput.name = 'productId';
                productIdInput.value = productId;
            
                form.appendChild(actionInput);
                form.appendChild(productIdInput);
            
                document.body.appendChild(form);
                
                // Show toast before submitting
                showCartToast('success', 'Đã xóa sản phẩm khỏi giỏ hàng!');
                
                // Submit after a short delay to show toast
                setTimeout(() => {
                    form.submit();
                }, 300);
            });
        }
        
        // Check for URL parameters to show toast after redirect
        waitForCartToast(() => {
            const urlParams = new URLSearchParams(window.location.search);
            const message = urlParams.get('message');
            const type = urlParams.get('type') || 'success';
            
            if (message) {
                showCartToast(type, decodeURIComponent(message));
                // Clean URL
                window.history.replaceState({}, document.title, window.location.pathname);
            }
        });
    </script>
</body>
</html>
