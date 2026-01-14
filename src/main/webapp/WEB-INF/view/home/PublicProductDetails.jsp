<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%
    String cPath = request.getContextPath();
    model.ProductDto product = (model.ProductDto) request.getAttribute("product");
    java.util.List<model.ProductDto> relatedProducts = new java.util.ArrayList<>();
    if (request.getAttribute("relatedProducts") != null) {
        relatedProducts = (java.util.List<model.ProductDto>) request.getAttribute("relatedProducts");
    }
    String productName = (product != null) ? product.getName() : "Chi tiết sản phẩm";
    request.setAttribute("pageTitle", productName + " - Yen Coffee House");
%>

<jsp:include page="/WEB-INF/view/layout/public/header.jsp"/>
<jsp:include page="/WEB-INF/view/layout/public/navbar.jsp"/>

<style>
  :root{ --bg-dark:#0f0f10; --bg-darker:#0a0a0b; --gold:#c7a17a; }
  body{background:#0c0c0d;color:#e9e9e9;font-family:"Poppins",system-ui,-apple-system,Segoe UI,Roboto,"Helvetica Neue",Arial,"Noto Sans",sans-serif;padding-top:80px}
  a{color:inherit;text-decoration:none}

  /* Hero */
  .home-slider .slider-item{min-height:40vh}
  .home-slider .overlay{background:linear-gradient(180deg,rgba(0,0,0,.45),rgba(0,0,0,.6))}
  .bread{font-weight:900;letter-spacing:.5px;text-transform:uppercase;color:#fff;font-size:2.5rem}
  .breadcrumbs{color:#cfcfcf;font-size:1rem}
  .breadcrumbs a:hover{color:var(--gold)}

  /* Sections */
  .ftco-section{padding:3rem 0;background:linear-gradient(180deg,var(--bg-dark),var(--bg-darker))}
  .product-details h3{font-weight:800;color:#fff;font-size:2rem;margin-bottom:1rem}
  .price span{background:rgba(199,161,122,.15);border:1px solid rgba(199,161,122,.35);padding:.5rem 1rem;border-radius:.6rem;color:#fff;font-size:1.5rem;font-weight:700}
  .btn{border-radius:999px;padding:.7rem 1.2rem;font-weight:600}
  .btn-outline-primary{border:2px solid var(--gold);color:var(--gold);background:transparent}
  .btn-outline-primary:hover{background:var(--gold);color:#000}
  .quantity-left-minus, .quantity-right-plus{
    background:transparent;
    border:1px solid rgba(255,255,255,.2);
    color:#fff;
    padding:.5rem .75rem;
    cursor:pointer;
    border-radius:8px;
    font-size:1rem;
    min-width:40px;
    display:inline-flex;
    align-items:center;
    justify-content:center;
  }
  .quantity-left-minus:hover, .quantity-right-plus:hover{
    background:rgba(255,255,255,.1);
    border-color:var(--gold);
    color:var(--gold);
  }
  .input-number{
    background:#1a1a1b;
    border:1px solid rgba(255,255,255,.2);
    color:#fff;
    text-align:center;
    border-radius:8px;
    max-width:80px;
    padding:.5rem;
    font-size:1rem;
  }
  .input-group-btn{
    display:inline-flex;
    align-items:center;
  }

  /* Related */
  .heading-section .subheading{color:var(--gold);font-weight:700;letter-spacing:.5px;margin-bottom:.25rem;font-size:18px;display:block}
  .heading-section h2{font-weight:800;color:#fff;font-size:2rem}
  .menu-entry{background:#151516;border-radius:14px;overflow:hidden;box-shadow:0 10px 30px rgba(0,0,0,.25);transition:transform 0.3s}
  .menu-entry:hover{transform:translateY(-5px)}
  .menu-entry .text{color:#ccc;padding:1.25rem}
  .menu-entry .text h3{font-size:1.2rem;margin-bottom:.5rem}
  .menu-entry .text h3 a{color:#fff}
  .menu-entry .text h3 a:hover{color:var(--gold)}
  .menu-entry .img{height:200px;display:block;background-size:cover;background-position:center;background-color:#2a2a2a}
  .cart-message{
    display:none;
    margin-top:1rem;
    padding:.75rem 1rem;
    border-radius:10px;
    font-weight:600;
    font-size:.95rem;
  }
  .cart-message.success{background:rgba(60,179,113,.12);border:1px solid rgba(60,179,113,.35);color:#6bd6a2}
  .cart-message.error{background:rgba(255,87,87,.12);border:1px solid rgba(255,87,87,.35);color:#ffb3b3}
</style>

<!-- HERO -->
<section class="home-slider owl-carousel">
  <div class="slider-item" style="background-image:url(<%=cPath%>/assets/images/bg_3.jpg);" data-stellar-background-ratio="0.5">
    <div class="overlay"></div>
    <div class="container">
      <div class="row slider-text justify-content-center align-items-center">
        <div class="col-md-7 col-sm-12 text-center ftco-animate">
          <h1 class="mb-3 mt-5 bread">Chi tiết sản phẩm</h1>
          <p class="breadcrumbs">
            <span class="mr-2"><a href="<%=cPath%>/home">Trang chủ</a></span>
            <span><a href="<%=cPath%>/home/public-products">Menu</a></span>
            <span id="bcName">${product.name != null ? product.name : 'Sản phẩm'}</span>
          </p>
        </div>
      </div>
    </div>
  </div>
</section>

<!-- PRODUCT DETAIL -->
<c:if test="${product != null}">
<section class="ftco-section">
  <div class="container">
    <div class="row" id="detailRow">
      <div class="col-lg-6 mb-5 ftco-animate">
        <c:choose>
          <c:when test="${not empty product.imageUrl}">
            <a href="${product.imageUrl}" class="image-popup">
              <img src="${product.imageUrl}" class="img-fluid" alt="${product.name}" id="imgMain">
            </a>
          </c:when>
          <c:otherwise>
            <img src="<%=cPath%>/assets/images/bg_1.jpg" class="img-fluid" alt="${product.name}" id="imgMain">
          </c:otherwise>
        </c:choose>
      </div>
      <div class="col-lg-6 product-details pl-md-5 ftco-animate">
        <h3 id="pName">${product.name}</h3>
        <p class="price"><span id="pPrice"><fmt:formatNumber value="${product.price}" type="currency" currencySymbol="₫"/></span></p>
        <p id="pDesc" style="color:#cfcfcf;line-height:1.8">${not empty product.description ? product.description : 'Mô tả sản phẩm.'}</p>
        
        <!-- Qty + Buttons -->
        <div class="row mt-3 align-items-center">
          <div class="col-md-6 d-flex align-items-center mb-3">
            <span class="input-group-btn mr-2">
              <button type="button" class="quantity-left-minus btn" id="btnMinus">
                <i class="fas fa-minus"></i>
              </button>
            </span>
            <input type="number" id="quantity" name="quantity" class="form-control input-number" value="1" min="1" max="100">
            <span class="input-group-btn ml-2">
              <button type="button" class="quantity-right-plus btn" id="btnPlus">
                <i class="fas fa-plus"></i>
              </button>
            </span>
          </div>
        </div>
        
        <p class="mt-2">
          <a href="#" id="addToCart" class="btn btn-outline-primary mr-2">Thêm vào giỏ</a>
          <a href="<%=cPath%>/home/public-products" class="btn btn-outline-primary">← Quay lại Menu</a>
        </p>
        <small id="sku" style="opacity:.7;color:#999">Mã sản phẩm: ${product.productId}</small>
        <div id="cartMessage" class="cart-message"></div>
      </div>
    </div>
  </div>
</section>

<!-- RELATED -->
<c:if test="${not empty relatedProducts}">
<section class="ftco-section">
  <div class="container">
    <div class="row justify-content-center mb-4">
      <div class="col-md-8 heading-section ftco-animate text-center">
        <span class="subheading">Gợi ý cho bạn</span>
        <h2 class="mb-3" style="font-weight:800">Sản phẩm liên quan</h2>
      </div>
    </div>
    <div class="row" id="relatedRow">
      <c:forEach var="related" items="${relatedProducts}">
        <div class="col-md-3 mb-4">
          <div class="menu-entry">
            <c:choose>
              <c:when test="${not empty related.imageUrl}">
                <a href="<%=cPath%>/public-product-details?id=${related.productId}" class="img" style="background-image:url('${related.imageUrl}');"></a>
              </c:when>
              <c:otherwise>
                <a href="<%=cPath%>/public-product-details?id=${related.productId}" class="img" style="background-image:url('<%=cPath%>/assets/images/bg_1.jpg');"></a>
              </c:otherwise>
            </c:choose>
            <div class="text text-center pt-3 pb-3">
              <h3><a href="<%=cPath%>/public-product-details?id=${related.productId}">${related.name}</a></h3>
              <p class="price"><span><fmt:formatNumber value="${related.price}" type="currency" currencySymbol="₫"/></span></p>
              <p><a href="<%=cPath%>/public-product-details?id=${related.productId}" class="btn btn-outline-primary">Xem chi tiết</a></p>
            </div>
          </div>
        </div>
      </c:forEach>
    </div>
  </div>
</section>
</c:if>
</c:if>

<c:if test="${product == null}">
<section class="ftco-section">
  <div class="container text-center">
    <h2>Sản phẩm không tồn tại</h2>
    <p><a href="<%=cPath%>/home/public-products" class="btn btn-outline-primary">Quay lại Menu</a></p>
  </div>
</section>
</c:if>

<jsp:include page="/WEB-INF/view/layout/public/footer.jsp"/>

<c:if test="${product != null}">
<script>
  const STOCK_QUANTITY = ${product.stockQuantity != null ? product.stockQuantity : 0};
  const cartMessageBox = document.getElementById('cartMessage');
  const quantityInput = document.getElementById('quantity');
  const btnPlus = document.getElementById('btnPlus');
  const btnMinus = document.getElementById('btnMinus');
  const addToCartBtn = document.getElementById('addToCart');

  // Wait for showCartToast to be available
  function waitForCartToast(callback) {
    if (typeof showCartToast === 'function') {
      callback();
    } else {
      setTimeout(() => waitForCartToast(callback), 50);
    }
  }

  // +/- số lượng
  document.addEventListener('DOMContentLoaded', function() {
    if (quantityInput) {
      const maxStock = Math.max(STOCK_QUANTITY, 0);
      quantityInput.setAttribute('max', maxStock || 1);
      if (maxStock === 0) {
        quantityInput.value = 0;
        quantityInput.disabled = true;
        if (addToCartBtn) {
          addToCartBtn.classList.add('disabled');
          addToCartBtn.setAttribute('aria-disabled', 'true');
        }
        showCartToast('error', 'Sản phẩm hiện đã hết hàng.');
      } else if (quantityInput.value > maxStock) {
        quantityInput.value = maxStock;
      }

      // Clamp when user types manually
      quantityInput.addEventListener('input', function() {
        let value = parseInt(quantityInput.value, 10) || 1;
        if (value < 1) value = 1;
        if (value > maxStock) {
          value = maxStock;
          showCartToast('error', 'Bạn chỉ có thể đặt tối đa ' + maxStock + ' sản phẩm.');
        }
        quantityInput.value = value;
      });
    }
    
    if (btnPlus && quantityInput) {
      btnPlus.addEventListener('click', function(e) {
        e.preventDefault();
        e.stopPropagation();
        let q = parseInt(quantityInput.value) || 1;
        if (STOCK_QUANTITY === 0) return;
        if (q < STOCK_QUANTITY) {
          quantityInput.value = q + 1;
        } else {
          showCartToast('error', 'Kho chỉ còn ' + STOCK_QUANTITY + ' sản phẩm.');
        }
      });
    }
    
    if (btnMinus && quantityInput) {
      btnMinus.addEventListener('click', function(e) {
        e.preventDefault();
        e.stopPropagation();
        let q = parseInt(quantityInput.value, 10) || 1;
        if (q > 1) {
          quantityInput.value = q - 1;
        }
      });
    }
  });

  /* ===== THÊM VÀO GIỎ HÀNG ===== */
  // Prevent duplicate event listeners
  (function() {
    if (window.productDetailsListenerAttached) {
      return;
    }
    window.productDetailsListenerAttached = true;
    
    // Track if adding to cart - use Set to track multiple products
    const addingProducts = new Set();
    
    addToCartBtn?.addEventListener('click', function(e) {
    e.preventDefault();
    e.stopPropagation();
    
    const productId = '${product.productId}';
    
    // Prevent double click for this specific product
    if (addingProducts.has(productId)) {
      console.log('Already adding product:', productId);
      return;
    }
    
    // Mark product as being added IMMEDIATELY
    addingProducts.add(productId);
    
    // Disable button immediately
    this.disabled = true;
    
    if (STOCK_QUANTITY === 0) {
      // Re-enable button if out of stock
      addingProducts.delete(productId);
      this.disabled = false;
      if (typeof showCartToast === 'function') {
        showCartToast('error', 'Sản phẩm hiện đã hết hàng.');
      } else {
        alert('Sản phẩm hiện đã hết hàng.');
      }
      return;
    }
    
    const productName = '${product.name}';
    const productPrice = ${product.price};
    const quantity = parseInt(quantityInput.value, 10) || 1;

    if (quantity > STOCK_QUANTITY) {
      // Re-enable button if quantity exceeds stock
      addingProducts.delete(productId);
      this.disabled = false;
      quantityInput.value = STOCK_QUANTITY;
      if (typeof showCartToast === 'function') {
        showCartToast('error', 'Bạn chỉ có thể đặt tối đa ' + STOCK_QUANTITY + ' sản phẩm.');
      } else {
        alert('Bạn chỉ có thể đặt tối đa ' + STOCK_QUANTITY + ' sản phẩm.');
      }
      return;
    }
    
    // Update button text (already disabled above)
    const originalText = this.textContent;
    this.textContent = 'Đang thêm...';
    
    const formData = new FormData();
    formData.append('action', 'add');
    formData.append('productId', productId);
    formData.append('productName', productName);
    formData.append('price', productPrice);
    formData.append('quantity', quantity);
    
    fetch('<%=cPath%>/home/cart', {
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
        throw new Error('INVALID_RESPONSE');
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
        return { success: false };
      }

      return data;
    })
    .then(data => {
      if (data && data.success) {
        // Update cart badge
        const cartBadge = document.getElementById('cart-count');
        if (cartBadge && data.cartCount !== undefined) {
          const count = data.cartCount || 0;
          cartBadge.textContent = count > 99 ? '99+' : count;
          cartBadge.style.display = count > 0 ? 'inline-flex' : 'none';
        }
        const successMessage = data.message || ('Đã thêm "' + productName + '" vào giỏ hàng!');
        if (typeof showCartToast === 'function') {
          showCartToast('success', successMessage);
        } else {
          alert(successMessage);
        }
      }
    })
    .catch(error => {
      console.error('Error:', error);
      if (typeof showCartToast === 'function') {
        if (error.message === 'INVALID_RESPONSE') {
          showCartToast('error', 'Máy chủ trả về dữ liệu không hợp lệ.');
        } else {
          showCartToast('error', 'Không thể kết nối tới máy chủ.');
        }
      } else {
        alert('Có lỗi xảy ra khi thêm sản phẩm vào giỏ hàng.');
      }
    })
    .finally(() => {
      // Reset flag and button state
      addingProducts.delete(productId);
      if (addToCartBtn) {
        addToCartBtn.disabled = false;
        addToCartBtn.textContent = originalText;
      }
    });
  });
  })();
</script>
</c:if>

<jsp:include page="/WEB-INF/view/layout/public/scripts.jsp"/>

</body>
</html>
