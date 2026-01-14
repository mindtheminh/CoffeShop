<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%
    String cPath = request.getContextPath();
    java.util.List<model.ProductDto> bestSellers = new java.util.ArrayList<>();
    if (request.getAttribute("bestSellers") != null) {
        bestSellers = (java.util.List<model.ProductDto>) request.getAttribute("bestSellers");
    }
    java.util.List<model.PromotionDto> activePromotions = new java.util.ArrayList<>();
    if (request.getAttribute("activePromotions") != null) {
        activePromotions = (java.util.List<model.PromotionDto>) request.getAttribute("activePromotions");
    }
    request.setAttribute("pageTitle", "Yen Coffee House - Trang chủ");
%>

<jsp:include page="/WEB-INF/view/layout/public/header.jsp"/>
<jsp:include page="/WEB-INF/view/layout/public/navbar.jsp"/>

<style>
    :root{ --bg-dark:#0f0f10; --bg-darker:#0a0a0b; --gold:#c7a17a; --pill:#77c4e4; }
    body{background:#0c0c0d;color:#e9e9e9;font-family:"Roboto","Poppins",system-ui,-apple-system,Segoe UI,"Helvetica Neue",Arial,"Noto Sans",sans-serif;padding-top:70px}
    *{font-variant-ligatures:none;text-rendering:optimizeLegibility;-webkit-font-smoothing:antialiased;-moz-osx-font-smoothing:grayscale}
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
    .yc-icon{
      background:transparent;
      border:none;
      color:#fff;
      font-size:1.2rem;
      padding:0.5rem 0.75rem;
      cursor:pointer;
      transition:color 0.3s;
    }
    .yc-icon:hover{
      color:var(--gold);
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
    .dropdown-toggle::after{
      margin-left:0.5rem;
      vertical-align:0.15em;
    }
    .yc-sep{
      display:none;
    }

    /* ===== HERO ===== */
    .hero{
      position:relative;
      min-height:90vh;
      background:url('<%=cPath%>/assets/images/bg_2.jpg') center/cover no-repeat fixed;
      display:flex;
      align-items:center;
      justify-content:center;
    }
    .product-badge {
        position: absolute;
        top: 10px;
        right: 10px;
        background: var(--danger);
        color: white;
        padding: 0.25rem 0.5rem;
        border-radius: 4px;
        font-size: 0.75rem;
        font-weight: 600;
    }
    .hero:before{
      content:"";
      position:absolute;
      inset:0;
      background:linear-gradient(180deg,rgba(0,0,0,.4),rgba(0,0,0,.5));
    }
    .hero .content{
      position:relative;
      z-index:2;
      text-align:center;
      padding:2rem 1rem;
    }
    .hero .welcome{
      color:var(--gold);
      font-size:1.3rem;
      font-weight:600;
      margin-bottom:0.5rem;
      letter-spacing:1px;
    }
    .hero h1{
      font-size:3.5rem;
      letter-spacing:2px;
      font-weight:800;
      text-transform:uppercase;
      margin:0.5rem 0 1.5rem 0;
      color:#fff;
      line-height:1.2;
      text-shadow:2px 2px 4px rgba(0,0,0,0.5);
    }
    .hero p{
      color:#e0e0e0;
      max-width:700px;
      margin:0 auto 2rem;
      font-size:1.1rem;
      line-height:1.6;
    }
    .btn{
      border-radius:50px;
      padding:0.75rem 2rem;
      font-weight:600;
      transition:all 0.3s;
      border:2px solid;
      text-decoration:none;
      display:inline-block;
      margin:0 0.5rem;
    }
    .btn-outline-light{
      border-color:#fff;
      color:#fff;
      background:transparent;
    }
    .btn-outline-light:hover{
      background:#fff;
      color:#000;
      transform:translateY(-2px);
      box-shadow:0 5px 15px rgba(255,255,255,0.3);
    }
    .btn-outline-primary{
      border-color:#fff;
      color:#fff;
      background:transparent;
    }
    .btn-outline-primary:hover{
      background:#fff;
      color:#000;
      transform:translateY(-2px);
      box-shadow:0 5px 15px rgba(255,255,255,0.3);
    }

    /* ===== STORY ===== */
    .subheading-script{font-family:"Josefin Sans",serif;font-size:56px;color:var(--gold);font-weight:700;line-height:1}
    .title-block{font-weight:900;font-size:50px;letter-spacing:1px;color:#fff;text-transform:uppercase;line-height:1.05}
    .story-card{background:rgba(0,0,0,.55);padding:2rem 2.25rem;border-radius:14px;box-shadow:0 10px 30px rgba(0,0,0,.35);color:#d7d7d7}

    /* ===== SECTIONS ===== */
    .ftco-section{padding:3.5rem 0;background:linear-gradient(180deg,var(--bg-dark),var(--bg-darker))}
    .ftco-section.light{background:#121213}
    .section-title{font-size:40px;font-weight:800;margin:0 0 .5rem;color:#fff}
    .section-sub{color:#d0d0d0}

    /* ===== CARDS MENU ===== */
    .nav-pills .nav-link{border-radius:999px;margin:.25rem .35rem;padding:.6rem 1rem;border:1px solid rgba(255,255,255,.18);color:#e5e5e5;background:transparent;transition:all 0.3s}
    .nav-pills .nav-link.active{background:var(--pill);border-color:var(--pill);color:#fff}
    .nav-pills .nav-link:hover{background:rgba(119,196,228,0.3);border-color:var(--pill)}
    .menu-wrap{background:#151516;border-radius:16px;overflow:hidden;box-shadow:0 10px 30px rgba(0,0,0,.25);margin-bottom:28px;transition:transform 0.3s}
    .menu-wrap:hover{transform:translateY(-5px)}
    .menu-wrap .menu-img{display:block;height:210px;background-size:cover;background-position:center;background-color:#2a2a2a}
    .menu-wrap .text{padding:1.1rem 1.25rem}
    .menu-wrap h3{font-weight:700;margin-bottom:.35rem;color:#fff;font-size:1.3rem}
    .menu-wrap p{color:#cfcfcf;margin-bottom:.5rem}
    .price span{font-weight:700;color:#fff;font-size:1.2rem}
    .btn-detail{width:44px;height:44px;border-radius:50%;border:2px solid var(--gold);display:inline-flex;align-items:center;justify-content:center;margin-left:.5rem;color:var(--gold);font-weight:900;font-size:18px;line-height:1;background:transparent;transition:.2s;text-decoration:none}
    .btn-detail:hover{background:var(--gold);color:#000}

    /* Search Panel */
    .yc-search-panel{position:fixed;top:70px;left:0;right:0;background:rgba(15,15,16,0.98);padding:20px;z-index:999;display:none}
    .yc-search-input{width:100%;max-width:600px;padding:12px 20px;background:#1a1a1b;border:1px solid rgba(255,255,255,0.1);border-radius:8px;color:#fff;font-size:1rem}
    .yc-search-input::placeholder{color:#999}
    .yc-search-input:focus{outline:none;border-color:var(--gold)}

    /* Cart Notification */
    .cart-notification{
      position:fixed;
      top:90px;
      right:20px;
      background:#fff;
      padding:1rem 1.5rem;
      border-radius:12px;
      box-shadow:0 8px 24px rgba(0,0,0,0.4);
      z-index:10000;
      transform:translateX(400px);
      transition:transform 0.3s ease;
      min-width:320px;
    }
    .cart-notification.show{transform:translateX(0)}
    .cart-notification-content{display:flex;align-items:center;gap:1rem}
    .cart-notification-success{border-left:4px solid #22c55e}
    .cart-notification-success i{color:#22c55e;font-size:1.5rem}
    .cart-notification-error{border-left:4px solid #ef4444}
    .cart-notification-error i{color:#ef4444;font-size:1.5rem}
    .cart-notification span{color:#1f2937;font-weight:600;font-size:1rem;line-height:1.4}

    .cart-message{
      display:none;
      margin:1.25rem auto 0;
      padding:.85rem 1.2rem;
      border-radius:12px;
      font-weight:600;
      font-size:.95rem;
      max-width:520px;
      text-align:center;
    }
    .cart-message.success{
      background:rgba(34,197,94,.12);
      border:1px solid rgba(34,197,94,.35);
      color:#6ee7b7;
    }
    .cart-message.error{
      background:rgba(248,113,113,.12);
      border:1px solid rgba(248,113,113,.35);
      color:#fca5a5;
    }
/* Cart Toast Notification */
.cart-toast {
  position: fixed;
  top: 90px;
  right: 20px;
  background: #fff;
  padding: 1rem 1.5rem;
  border-radius: 12px;
  box-shadow: 0 8px 24px rgba(0,0,0,0.4);
  z-index: 10000;
  transform: translateX(400px);
  transition: transform 0.3s ease;
  min-width: 320px;
  border-left: 4px solid #22c55e;
}
.cart-toast.show {
  transform: translateX(0);
}
.cart-toast.error {
  border-left-color: #ef4444;
}
.cart-toast.warning {
  border-left-color: #f59e0b;
}
.cart-toast-content {
  display: flex;
  align-items: center;
  gap: 1rem;
}
.cart-toast-content i {
  color: #22c55e;
  font-size: 1.5rem;
}
.cart-toast.error i {
  color: #ef4444;
}
.cart-toast.warning i {
  color: #f59e0b;
}
.cart-toast-content span {
  color: #1f2937;
  font-weight: 600;
  font-size: 1rem;
  line-height: 1.4;
}
    .ftco-appointment,.ftco-intro,.ftco-cta,.book-table,.reservation-wrap{display:none!important}
  </style>

<!-- ===== HERO ===== -->
<header id="home" class="hero">
  <div class="content container">
    <div class="welcome">Chào mừng</div>
    <h1>HƯƠNG VỊ TUYỆT HẢO & KHÔNG GIAN ĐẸP</h1>
    <p>Mùi hạt rang mới – bật dậy năng lượng cho ngày của bạn.</p>
    <div>
      <a class="btn btn-outline-light me-2" href="<%=cPath%>/home/public-products">Xem Menu</a>
      <a class="btn btn-outline-primary" href="<%=cPath%>/home/cart">Đặt ngay</a>
    </div>
  </div>
</header>

<!-- ===== STORY ===== -->
<section id="story" class="ftco-section">
  <div class="container">
    <div class="row align-items-stretch">
      <div class="col-md-6 p-md-5 img img-2" style="background-image:url('<%=cPath%>/assets/images/about.jpg');background-size:cover;"></div>
      <div class="col-md-6 d-flex">
        <div class="w-100 pt-5 pl-md-5">
          <div class="mb-2">
            <span class="subheading-script">Khám phá</span>
            <div class="title-block" style="font-size:48px;margin-top:.25rem;">CÂU CHUYỆN CỦA CHÚNG TÔI</div>
          </div>
          <div class="story-card">
            <p>YEN COFFEE HOUSE ra đời từ những mẻ rang ở bếp nhà. Hạt cà phê từ cao nguyên được rang vừa, giữ trọn vị ngọt tự nhiên; pha bằng cả máy lẫn phin, vì mỗi vị khách có một nhịp riêng.</p>
            <p>Quán là nơi hẹn buổi sáng, trú mưa buổi chiều và kể chuyện tối muộn. Mỗi ly bán ra, chúng tôi trích 1.000₫ để trồng cây - nhỏ thôi nhưng bền.</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</section>

<!-- ===== MENU ===== -->
<section id="menu" class="ftco-section light">
  <div class="container">
    <div class="row justify-content-center mb-3">
      <div class="col-md-9 text-center">
        <h2 class="section-title">Thực đơn của chúng tôi</h2>
        <p class="section-sub">Chọn danh mục để xem các món nổi bật.</p>
      </div>
    </div>
<!--
    <div class="row">
      <div class="col-md-12 text-center mb-3">
        <ul class="nav nav-pills justify-content-center">
          <li class="nav-item"><a class="nav-link active" data-bs-toggle="tab" href="#pane-cafe">Cà phê</a></li>
          <li class="nav-item"><a class="nav-link" data-bs-toggle="tab" href="#pane-tra">Trà</a></li>
          <li class="nav-item"><a class="nav-link" data-bs-toggle="tab" href="#pane-trasua">Trà sữa</a></li>
          <li class="nav-item"><a class="nav-link" data-bs-toggle="tab" href="#pane-nuocep">Nước ép</a></li>
          <li class="nav-item"><a class="nav-link" data-bs-toggle="tab" href="#pane-banh">Bánh ngọt</a></li>
        </ul>
      </div>-->

      <div class="col-12">
        <div id="cart-message" class="cart-message"></div>
      </div>

      <div class="col-md-12">
        <div class="tab-content text-center">
          <div class="tab-pane fade show active" id="pane-cafe">
            <div class="row">
              <c:choose>
                <c:when test="${not empty bestSellers}">
                  <c:forEach var="product" items="${bestSellers}" begin="0" end="2">
                    <div class="col-lg-4">
                      <div class="menu-wrap">
                        <c:choose>
                          <c:when test="${not empty product.imageUrl}">
                            <div class="menu-img img" style="background-image:url('${product.imageUrl}');"></div>
                            <c:if test="${product.isBestseller}">
                                                        <span class="product-badge">Bán chạy</span>
                                                    </c:if>
                          </c:when>
                          <c:otherwise>
                            <div class="menu-img img" style="background-image:url('<%=cPath%>/assets/images/bg_1.jpg');"></div>
                          </c:otherwise>
                        </c:choose>
                        <div class="text">
                          <h3>${product.name}</h3>
                          <p>${not empty product.description ? product.description : 'Sản phẩm chất lượng cao'}</p>
                          <p class="price"><span><fmt:formatNumber value="${product.price}" type="currency" currencySymbol="₫"/></span></p>
                          <div class="d-flex justify-content-center">
                            <button class="btn btn-outline-primary btn-add-cart"
                                    data-product-id="${product.productId}"
                                    data-product-name="${product.name}"
                                    data-product-price="${product.price}"
                                    data-product-stock="${product.stockQuantity != null ? product.stockQuantity : 0}">
                              Thêm vào giỏ
                            </button>
                            <a class="btn-detail" href="<%=cPath%>/public-product-details?id=${product.productId}" title="Xem chi tiết"><i class="fas fa-info"></i></a>
                          </div>
                        </div>
                      </div>
                    </div>
                  </c:forEach>
                </c:when>
                <c:otherwise>
                  <!-- Default products if no data -->
                  <div class="col-lg-4">
                    <div class="menu-wrap">
                      <div class="menu-img img" style="background-image:url('<%=cPath%>/assets/images/bg_1.jpg');"></div>
                      <div class="text">
                        <h3>CÀ PHÊ SỮA ĐÁ</h3>
                        <p>Gu Việt chuẩn vị – béo thơm, mát lạnh.</p>
                        <p class="price"><span>29.000₫</span></p>
                        <div class="d-flex justify-content-center">
                          <a class="btn btn-outline-primary" href="<%=cPath%>/home/public-products">Xem thêm</a>
                        </div>
                      </div>
                    </div>
                  </div>
                  <div class="col-lg-4">
                    <div class="menu-wrap">
                      <div class="menu-img img" style="background-image:url('<%=cPath%>/assets/images/bg_3.jpg');"></div>
                      <div class="text">
                        <h3>AMERICANO NÓNG</h3>
                        <p>Đậm mùi hạt rang, tỉnh táo cả ngày.</p>
                        <p class="price"><span>32.000₫</span></p>
                        <div class="d-flex justify-content-center">
                          <a class="btn btn-outline-primary" href="<%=cPath%>/home/public-products">Xem thêm</a>
                        </div>
                      </div>
                    </div>
                  </div>
                  <div class="col-lg-4">
                    <div class="menu-wrap">
                      <div class="menu-img img" style="background-image:url('<%=cPath%>/assets/images/bg_4.jpg');"></div>
                      <div class="text">
                        <h3>COLD BREW CAM SẢ</h3>
                        <p>Thơm mát, hậu vị ngọt dài.</p>
                        <p class="price"><span>39.000₫</span></p>
                        <div class="d-flex justify-content-center">
                          <a class="btn btn-outline-primary" href="<%=cPath%>/home/public-products">Xem thêm</a>
                        </div>
                      </div>
                    </div>
                  </div>
                </c:otherwise>
              </c:choose>
            </div>
          </div>
          <div class="tab-pane fade" id="pane-tra">
            <div class="row">
              <div class="col-12 text-center">
                <p class="text-muted">Xem tất cả sản phẩm tại <a href="<%=cPath%>/home/public-products?category=Trà">Menu</a></p>
              </div>
            </div>
          </div>
          <div class="tab-pane fade" id="pane-trasua">
            <div class="row">
              <div class="col-12 text-center">
                <p class="text-muted">Xem tất cả sản phẩm tại <a href="<%=cPath%>/home/public-products?category=Trà sữa">Menu</a></p>
              </div>
            </div>
          </div>
          <div class="tab-pane fade" id="pane-nuocep">
            <div class="row">
              <div class="col-12 text-center">
                <p class="text-muted">Xem tất cả sản phẩm tại <a href="<%=cPath%>/home/public-products?category=Nước ép">Menu</a></p>
              </div>
            </div>
          </div>
          <div class="tab-pane fade" id="pane-banh">
            <div class="row">
              <div class="col-12 text-center">
                <p class="text-muted">Xem tất cả sản phẩm tại <a href="<%=cPath%>/home/public-products?category=Bánh ngọt">Menu</a></p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</section>

<!-- ===== PROMO ===== -->
<section id="promo" class="ftco-section" style="padding:2.5rem 0;">
  <div class="container text-center">
    <span style="color:var(--gold);font-weight:700;letter-spacing:.5px">Ưu đãi</span>
    <h3 style="font-weight:800;margin:.25rem 0 1rem;color:#fff">Khuyến mãi trong tuần</h3>
    <c:choose>
      <c:when test="${not empty activePromotions}">
        <c:forEach var="promo" items="${activePromotions}" begin="0" end="0">
          <p class="section-sub">${promo.name} - ${promo.description}</p>
        </c:forEach>
      </c:when>
      <c:otherwise>
        <p class="section-sub">Mua 2 tặng 1 cà phê pha máy • Giảm 20% khi mang ly cá nhân</p>
      </c:otherwise>
    </c:choose>
    <a href="<%=cPath%>/home/public-promotions" class="btn btn-outline-primary">Xem chi tiết khuyến mãi</a>
  </div>
</section>

<jsp:include page="/WEB-INF/view/layout/public/footer.jsp"/>

<script>
  // Search panel toggle
  document.getElementById('yc-search-btn')?.addEventListener('click', function() {
    const panel = document.getElementById('yc-search-panel');
    panel.style.display = panel.style.display === 'none' ? 'block' : 'none';
    if (panel.style.display === 'block') {
      document.getElementById('yc-search-input')?.focus();
    }
  });

  const cartMessageBox = document.getElementById('cart-message');
  const CART_ENDPOINT = '<%=cPath%>/home/cart';

  // Add to cart functionality - Prevent double click and duplicate listeners
  (function() {
    // Prevent duplicate event listeners
    if (window.cartListenersAttached) {
      return;
    }
    window.cartListenersAttached = true;
    
    // Global map to track adding state per product
    const addingProducts = new Set();
    
    document.querySelectorAll('.btn-add-cart').forEach(btn => {
      // Remove existing listeners if any
      const newBtn = btn.cloneNode(true);
      btn.parentNode.replaceChild(newBtn, btn);
      
      newBtn.addEventListener('click', function(e) {
      e.preventDefault();
      e.stopPropagation();
      
      const productId = this.getAttribute('data-product-id');
      const productName = this.getAttribute('data-product-name');
      const productPrice = this.getAttribute('data-product-price');
      const stock = parseInt(this.getAttribute('data-product-stock'), 10);
      
      // Prevent duplicate requests for the same product
      if (addingProducts.has(productId)) {
        console.log('Already adding product:', productId);
        return;
      }
      
      // Mark product as being added
      addingProducts.add(productId);

      if (!productId) {
        if (typeof showCartToast === 'function') {
          showCartToast('error', 'Thiếu mã sản phẩm, không thể thêm vào giỏ.');
        } else {
          alert('Thiếu mã sản phẩm, không thể thêm vào giỏ.');
        }
        return;
      }

      if (Number.isFinite(stock) && stock <= 0) {
        if (typeof showCartToast === 'function') {
          showCartToast('error', 'Sản phẩm đã hết hàng.');
        } else {
          alert('Sản phẩm đã hết hàng.');
        }
        return;
      }

      // Check if user is logged in
      <% if (session.getAttribute("authUser") == null) { %>
        if (typeof showCartToast === 'function') {
          showCartToast('error', 'Bạn cần đăng nhập để thêm sản phẩm vào giỏ hàng.');
        } else {
          alert('Bạn cần đăng nhập để thêm sản phẩm vào giỏ hàng.');
        }
        setTimeout(() => { window.location.href = '<%=cPath%>/auth/login'; }, 600);
        return;
      <% } %>

      // Disable button
      const originalText = this.textContent;
      this.disabled = true;
      this.textContent = 'Đang thêm...';

      const formData = new FormData();
      formData.append('action', 'add');
      formData.append('productId', productId);
      formData.append('quantity', '1');

      fetch(CART_ENDPOINT, {
        method: 'POST',
        headers: { 'X-Requested-With': 'XMLHttpRequest' },
        body: formData
      })
      .then(async response => {
        let data;
        try {
          data = await response.json();
        } catch (err) {
          if (typeof showCartToast === 'function') {
            showCartToast('error', 'Máy chủ trả về dữ liệu không hợp lệ.');
          } else {
            alert('Máy chủ trả về dữ liệu không hợp lệ.');
          }
          throw new Error('INVALID_JSON');
        }

        if (!response.ok || !data.success) {
          const errorMsg = data?.message || 'Không thể thêm sản phẩm vào giỏ hàng!';
          // Check if product already in cart
          if (typeof showCartToast === 'function') {
            if (errorMsg.includes('đã có') || errorMsg.includes('already')) {
              showCartToast('warning', 'Sản phẩm này đã có trong giỏ hàng.');
            } else {
              showCartToast('error', errorMsg);
            }
          } else {
            alert(errorMsg);
          }
          throw new Error('REQUEST_FAILED');
        }

        return data;
      })
      .then(data => {
        const message = data.message || 'Đã thêm "' + (productName || 'sản phẩm') + '" vào giỏ hàng!';
        if (typeof showCartToast === 'function') {
          showCartToast('success', message);
        } else {
          alert(message);
        }
        updateCartBadge(data.cartCount);
      })
      .catch(error => {
        if (error.message === 'REQUEST_FAILED' || error.message === 'INVALID_JSON') {
          return;
        }
        console.error('Error:', error);
        if (typeof showCartToast === 'function') {
          showCartToast('error', 'Có lỗi xảy ra khi thêm sản phẩm vào giỏ hàng!');
        } else {
          alert('Có lỗi xảy ra khi thêm sản phẩm vào giỏ hàng!');
        }
      })
      .finally(() => {
        // Reset button state and remove from adding set
        addingProducts.delete(productId);
        this.disabled = false;
        this.textContent = originalText;
      });
    });
  });
  })();

  // Update cart badge
  function updateCartBadge(count) {
    const badge = document.getElementById('cart-count');
    if (badge && count !== undefined) {
      badge.textContent = count > 99 ? '99+' : count;
      badge.style.display = count > 0 ? 'inline-flex' : 'none';

      // Animate badge
      badge.style.transform = 'scale(1.3)';
      setTimeout(() => {
        badge.style.transform = 'scale(1)';
      }, 200);
    }
  }
</script>

<jsp:include page="/WEB-INF/view/layout/public/scripts.jsp"/>
<!-- Cart Toast Notification -->
<div id="cart-toast" class="cart-toast">
  <div class="cart-toast-content">
    <i class="fas fa-check-circle"></i>
    <span id="cart-toast-message"></span>
  </div>
</div>
</body>
</html>
