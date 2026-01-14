<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%
    String cPath = request.getContextPath();
    java.util.List<model.ProductDto> products = new java.util.ArrayList<>();
    if (request.getAttribute("products") != null) {
        products = (java.util.List<model.ProductDto>) request.getAttribute("products");
    }
    String searchQuery = request.getParameter("search");
    String categoryFilter = request.getParameter("category");
    String sortBy = request.getParameter("sort");

    request.setAttribute("pageTitle", "Menu - Yen Coffee House");
    request.setAttribute("currentPage", "products");
%>

<jsp:include page="/WEB-INF/view/layout/public/header.jsp"/>
<jsp:include page="/WEB-INF/view/layout/public/navbar.jsp"/>

<style>
  :root{ --bg-dark:#0f0f10; --bg-darker:#0a0a0b; --gold:#c7a17a; --pill:#77c4e4; }
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
  .yc-search-panel{
    position:fixed;
    top:70px;
    left:0;
    right:0;
    background:rgba(15,15,16,0.98);
    padding:20px;
    z-index:999;
    display:none;
  }
  .yc-search-input{
    width:100%;
    max-width:600px;
    padding:12px 20px;
    background:#1a1a1b;
    border:1px solid rgba(255,255,255,0.1);
    border-radius:8px;
    color:#fff;
    font-size:1rem;
  }
  .yc-search-input::placeholder{
    color:#999;
  }
  .yc-search-input:focus{
    outline:none;
    border-color:var(--gold);
  }

  /* Hero */
  .home-slider .slider-item{min-height:42vh}
  .home-slider .overlay{background:linear-gradient(180deg,rgba(0,0,0,.45),rgba(0,0,0,.6))}
  .bread{font-weight:900;letter-spacing:.5px;text-transform:uppercase}

  /* Intro gốc ẩn đi */
  .ftco-intro{display:none!important}

  /* Section */
  .ftco-section{padding:3rem 0;background:linear-gradient(180deg,var(--bg-dark),var(--bg-darker))}
  .heading-section .subheading{display:block;color:var(--gold);font-weight:700;letter-spacing:.5px;margin-bottom:.25rem;font-size:44px;font-family:"Josefin Sans",serif}
  .heading-section h2{font-weight:800;margin-top:.25rem}

  /* Toolbar lọc/tìm/sort */
  .toolbar{background:#121214;border:1px solid rgba(255,255,255,.08);border-radius:14px;padding:.75rem 1rem;margin:0 0 1.25rem}
  .toolbar input[type="search"]{background:#0f0f10;border:1px solid rgba(255,255,255,.12);color:#fff;border-radius:10px;padding:.55rem .8rem;min-width:240px}
  .toolbar select{background:#0f0f10;border:1px solid rgba(255,255,255,.12);color:#fff;border-radius:10px;padding:.55rem .8rem}

  /* Tabs */
  .nav-pills .nav-link{border-radius:999px;margin:.25rem .35rem;padding:.6rem 1rem;border:1px solid rgba(255,255,255,.18);color:#e5e5e5}
  .nav-pills .nav-link.active{background:var(--pill);border-color:var(--pill);color:#fff}

  /* Card món */
  .menu-wrap{background:#151516;border-radius:16px;overflow:hidden;box-shadow:0 10px 30px rgba(0,0,0,.25);margin-bottom:28px}
  .menu-wrap .menu-img{display:block;height:210px;background-size:cover;background-position:center}
  .menu-wrap .text{padding:1.1rem 1.25rem}
  .menu-wrap h3{font-weight:700;margin-bottom:.35rem}
  .menu-wrap p{color:#cfcfcf;margin-bottom:.5rem}
  .price span{font-weight:700;color:#fff}
  .btn{border-radius:999px;padding:.6rem 1rem}
  .btn-outline-primary{border:2px solid var(--gold);color:var(--gold)}
  .btn-outline-primary:hover{background:var(--gold);color:#000}
  .btn-detail{width:44px;height:44px;border-radius:50%;border:2px solid var(--gold);display:inline-flex;align-items:center;justify-content:center;margin-left:.5rem;color:var(--gold);font-weight:900;font-size:18px;line-height:1;background:transparent;transition:.2s}
  .btn-detail:hover{background:var(--gold);color:#000}
  .cart-message{
    display:none;
    margin:1rem auto 1.5rem;
    padding:.85rem 1.15rem;
    border-radius:12px;
    font-weight:600;
    font-size:.95rem;
    max-width:640px;
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
</style>

<section class="home-slider owl-carousel">
  <div class="slider-item" style="background-image:url(<%=cPath%>/assets/images/bg_3.jpg);" data-stellar-background-ratio="0.5">
    <div class="overlay"></div>
    <div class="container">
      <div class="row slider-text justify-content-center align-items-center">
        <div class="col-md-7 col-sm-12 text-center ftco-animate">
          <h1 class="mb-3 mt-5 bread">Thực đơn</h1>
          <p class="breadcrumbs"><span class="mr-2"><a href="<%=cPath%>/home">Trang chủ</a></span> <span>Thực đơn</span></p>
        </div>
      </div>
    </div>
  </div>
</section>

<section class="ftco-section">
  <div class="container">
    <div class="row justify-content-center mb-3">
      <div class="col-md-9 heading-section text-center ftco-animate">
        <span class="subheading">Khám phá</span>
        <h2 class="mb-2">Các sản phẩm</h2>
        <p>Chọn danh mục hoặc dùng bộ lọc bên dưới để tìm nhanh sản phẩm bạn muốn.</p>
      </div>
    </div>

    <div class="toolbar d-flex flex-wrap align-items-center justify-content-center mb-4">
      <input id="searchBox" type="search" class="mr-2" placeholder="Tìm kiếm sản phẩm..." value="<%= searchQuery != null ? searchQuery : "" %>">
      <select id="sortSelect" class="mr-2">
        <option value="popular" <%= (sortBy == null || sortBy.isEmpty()) ? "selected" : "" %>>Sắp xếp: Mặc định</option>
        <option value="price-asc" <%= "price_asc".equals(sortBy) ? "selected" : "" %>>Giá tăng dần</option>
        <option value="price-desc" <%= "price_desc".equals(sortBy) ? "selected" : "" %>>Giá giảm dần</option>
        <option value="bestseller" <%= "bestseller".equals(sortBy) ? "selected" : "" %>>Bán chạy</option>
      </select>
    </div>

    <div id="cartMessage" class="cart-message"></div>

   <div class="row">
      <div class="col-md-12 mb-4">
        <div class="nav nav-pills justify-content-center" id="categoryTabs">
          <a class="nav-link active" data-cat="all">Tất cả sản phẩm</a>
          <a class="nav-link" data-cat="cafe">Cà phê</a>
          <a class="nav-link" data-cat="tra">Trà</a>
          <a class="nav-link" data-cat="trasua">Trà sữa</a>
          <a class="nav-link" data-cat="nuocep">Nước ép</a>
          <a class="nav-link" data-cat="banh">Bánh ngọt</a>
        </div>
      </div>
    </div>

    <div class="row" id="grid-all">
      <c:forEach var="product" items="${products}">
        <c:set var="catCode" value="all"/>
        <c:choose>
          <c:when test="${product.category == 'Cà phê'}"><c:set var="catCode" value="cafe"/></c:when>
          <c:when test="${product.category == 'Trà'}"><c:set var="catCode" value="tra"/></c:when>
          <c:when test="${product.category == 'Trà sữa'}"><c:set var="catCode" value="trasua"/></c:when>
          <c:when test="${product.category == 'Nước ép'}"><c:set var="catCode" value="nuocep"/></c:when>
          <c:when test="${product.category == 'Bánh ngọt'}"><c:set var="catCode" value="banh"/></c:when>
        </c:choose>

        <div class="col-md-4 text-center product-card"
             data-price="${product.price}"
             data-bestseller="${product.isBestseller ? 'true' : 'false'}"
             data-name="${product.name}"
             data-cat="${catCode}">
          <div class="menu-wrap">
            <c:choose>
              <c:when test="${not empty product.imageUrl}">
                <a class="menu-img img mb-4" style="background-image:url(${product.imageUrl});"></a>
              </c:when>
                
              <c:otherwise>
                <a class="menu-img img mb-4" style="background-image:url(<%=cPath%>/assets/images/bg_1.jpg);"></a>
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
                <a class="btn-detail" href="<%=cPath%>/public-product-details?id=${product.productId}" title="Xem chi tiết">!</a>
              </div>
            </div>
          </div>
        </div>
      </c:forEach>

      <c:if test="${empty products}">
        <div class="col-md-12 text-center">
          <p class="text-muted">Hiện chưa có sản phẩm nào trong danh mục này.</p>
        </div>
      </c:if>
    </div>
  </div>
</section>

<jsp:include page="/WEB-INF/view/layout/public/footer.jsp"/>

<script>
const CONTEXT_PATH = '<%=request.getContextPath()%>';
const CART_ENDPOINT = CONTEXT_PATH + '/home/cart';
const CART_COUNT_ENDPOINT = CONTEXT_PATH + '/home/cart?action=count';
const IS_LOGGED_IN = <%= session.getAttribute("authUser") != null ? "true" : "false" %>;

/* ===== FILTER & SORT PRODUCTS (Code này của bạn, giữ nguyên) ===== */
const searchBox = document.getElementById('searchBox');
const sortSelect = document.getElementById('sortSelect');
const cards = Array.from(document.querySelectorAll('.product-card'));
let currentCat = 'all';

function applyFilters() {
  const q = (searchBox.value || '').trim().toLowerCase();
  const mode = sortSelect.value;

  cards.forEach(card => {
    const name = (card.dataset.name || '').toLowerCase();
    const cat  = card.dataset.cat || 'all';
    const matchCat = currentCat === 'all' || cat === currentCat;
    const matchSearch = !q || name.includes(q);
    card.style.display = (matchCat && matchSearch) ? '' : 'none';
  });

  const grid = document.getElementById('grid-all');
  const visible = cards.filter(c => c.style.display !== 'none');
  visible.sort((a,b)=>{
    const pa = parseInt(a.dataset.price,10)||0;
    const pb = parseInt(b.dataset.price,10)||0;
    if(mode==='price-asc') return pa - pb;
    if(mode==='price-desc') return pb - pa;
    if(mode==='bestseller'){
      const ba = a.dataset.bestseller==='true'?1:0;
      const bb = b.dataset.bestseller==='true'?1:0;
      if(bb!==ba) return bb - ba;
      return pa - pb;
    }
    return 0;
  });
  visible.forEach(el=>grid.appendChild(el));
}

searchBox.addEventListener('input', applyFilters);
sortSelect.addEventListener('change', applyFilters);

document.querySelectorAll('#categoryTabs .nav-link').forEach(link=>{
  link.addEventListener('click', e=>{
    e.preventDefault();
    document.querySelectorAll('#categoryTabs .nav-link').forEach(l=>l.classList.remove('active'));
    link.classList.add('active');
    currentCat = link.dataset.cat || 'all';
    applyFilters();
  });
});

applyFilters();


/* ===== ADD TO CART - FIXED VERSION (Code "Thật" được thêm vào) ===== */
// Prevent duplicate event listeners
(function() {
  if (window.publicProductsListenersAttached) {
    return;
  }
  window.publicProductsListenersAttached = true;
  
  // Global set to track adding state per product
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
    
    // Mark product as being added IMMEDIATELY to prevent race condition
    addingProducts.add(productId);
    
    // Also disable button immediately
    this.disabled = true;
    
    if (!productId || !productName || !productPrice) {
      console.error('Missing product data:', { productId, productName, productPrice });
      if (typeof showCartToast === 'function') {
        showCartToast('error', 'Thiếu thông tin sản phẩm!');
      } else {
        alert('Thiếu thông tin sản phẩm!');
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
    
    if (!IS_LOGGED_IN) {
      // Re-enable button if not logged in
      addingProducts.delete(productId);
      this.disabled = false;
      if (typeof showCartToast === 'function') {
        showCartToast('error', 'Bạn cần đăng nhập để thêm sản phẩm vào giỏ hàng.');
      } else {
        alert('Bạn cần đăng nhập để thêm sản phẩm vào giỏ hàng.');
      }
      setTimeout(() => { window.location.href = CONTEXT_PATH + '/auth/login'; }, 600);
      return;
    }
    
    // Disable button (already disabled above, but update text)
    const originalText = this.textContent;
    this.textContent = 'Đang thêm...';
    
    const formData = new FormData();
    formData.append('action', 'add');
    formData.append('productId', productId);
    formData.append('quantity', '1');
    
    fetch(CART_ENDPOINT, {
      method: 'POST',
      headers: { 
        'X-Requested-With': 'XMLHttpRequest'
      },
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
        const errorMsg = data?.message || 'Không thể thêm sản phẩm vào giỏ hàng.';
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
      const message = data.message || ('Đã thêm "' + productName + '" vào giỏ hàng!');
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

/* ===== UPDATE CART BADGE (Code "Thật" được thêm vào) ===== */
function updateCartBadge(count) {
  const badge = document.getElementById('cart-count');
  if (badge && typeof count === 'number') {
    const safeCount = count || 0;
    badge.textContent = safeCount > 99 ? '99+' : safeCount;
    badge.style.display = safeCount > 0 ? 'inline-flex' : 'none';
    return;
  }

  fetch(CART_COUNT_ENDPOINT)
    .then(response => {
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      return response.json();
    })
    .then(data => {
      const badge = document.getElementById('cart-count');
      if (badge) {
        const count = data.count || 0;
        badge.textContent = count > 99 ? '99+' : count;
        badge.style.display = count > 0 ? 'inline-flex' : 'none';
      } else {
        console.warn('Cart badge element #cart-count not found in DOM');
      }
    })
    .catch(err => {
      console.error('Error updating cart badge:', err);
    });
}

/* ===== INITIALIZE ON PAGE LOAD (Code "Thật" được thêm vào) ===== */
document.addEventListener('DOMContentLoaded', function() {
  updateCartBadge();
});

/* ===== INITIALIZE ON PAGE LOAD (Code "Thật" được thêm vào) ===== */
if (document.readyState === 'complete' || document.readyState === 'interactive') {
  updateCartBadge();
}

</script>
<jsp:include page="/WEB-INF/view/layout/public/scripts.jsp"/>
</body>
</html>