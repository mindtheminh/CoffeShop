<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    String cPath = request.getContextPath();
    Object authUserObj = session.getAttribute("authUser");
    boolean isLoggedIn = authUserObj != null;
%>
<!-- ===== NAV ===== -->
<nav class="navbar navbar-expand-lg navbar-dark fixed-top" id="yc-navbar">
  <div class="container">
    <a class="navbar-brand" href="<%=cPath%>/home"><strong>YEN COFFEE HOUSE</strong></a>

    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#yc-nav">
      <span class="navbar-toggler-icon"></span>
    </button>

    <div class="collapse navbar-collapse" id="yc-nav">
      <ul class="navbar-nav ms-auto align-items-center">
        <li class="nav-item">
          <button class="yc-icon" id="yc-search-btn" aria-label="Tìm kiếm"><i class="fas fa-magnifying-glass"></i></button>
        </li>
        <li class="nav-item"><a href="<%=cPath%>/home" class="nav-link yc-spaced">TRANG CHỦ</a></li>
        <li class="nav-item"><a href="<%=cPath%>/home/public-products" class="nav-link yc-spaced">MENU</a></li>
        <li class="nav-item"><a href="<%=cPath%>/home/public-promotions" class="nav-link yc-spaced">KHUYẾN MÃI</a></li>
        <li class="nav-item">
          <a href="<%=cPath%>/home/cart" class="nav-link position-relative" title="Giỏ hàng" style="padding:0.5rem 1rem!important;">
            <i class="fas fa-cart-shopping"></i>
            <span id="cart-count" class="badge-cart" style="display:none;">0</span>
          </a>
        </li>
        <li class="nav-item dropdown">
          <a class="nav-link dropdown-toggle" href="#" id="accDrop" role="button" data-bs-toggle="dropdown" style="padding:0.5rem 1rem!important;">
            <i class="fas fa-user"></i>
          </a>
          <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="accDrop">
            <% if (isLoggedIn) { %>
              <li><a class="dropdown-item" href="<%=cPath%>/customer/my-profile"><i class="fas fa-user-cog me-2"></i>Tài khoản</a></li>
              <li><a class="dropdown-item" href="<%=cPath%>/customer/my-orders"><i class="fas fa-shopping-bag me-2"></i>Đơn hàng</a></li>
              <li><hr class="dropdown-divider"></li>
              <li><a class="dropdown-item" href="<%=cPath%>/auth/logout"><i class="fas fa-sign-out-alt me-2"></i>Đăng xuất</a></li>
            <% } else { %>
              <li><a class="dropdown-item" href="<%=cPath%>/auth/login"><i class="fas fa-sign-in-alt me-2"></i>Đăng nhập</a></li>
              <li><a class="dropdown-item" href="<%=cPath%>/auth/register"><i class="fas fa-user-plus me-2"></i>Đăng ký</a></li>
            <% } %>
          </ul>
        </li>
      </ul>
    </div>
  </div>
</nav>

<!-- Panel tìm kiếm -->
<div id="yc-search-panel" class="yc-search-panel">
  <div class="container d-flex justify-content-center">
    <form method="get" action="<%=cPath%>/home/public-products" class="w-100" style="max-width:600px">
      <input id="yc-search-input" type="search" name="search" class="yc-search-input" placeholder="Nhập từ khóa để tìm kiếm sản phẩm... (Enter để tìm)" autofocus>
    </form>
  </div>
</div>

<script>
  // Search panel toggle
  document.getElementById('yc-search-btn')?.addEventListener('click', function() {
    const panel = document.getElementById('yc-search-panel');
    panel.style.display = panel.style.display === 'none' ? 'block' : 'none';
    if (panel.style.display === 'block') {
      document.getElementById('yc-search-input')?.focus();
    }
  });

  // Load cart count on page load
  <% if (isLoggedIn) { %>
  window.addEventListener('DOMContentLoaded', function() {
    fetch('<%=cPath%>/api/cart/count')
      .then(response => response.json())
      .then(data => {
        const badge = document.getElementById('cart-count');
        if (badge) {
          const count = data.count || 0;
          badge.textContent = count > 99 ? '99+' : count;
          badge.style.display = count > 0 ? 'inline-flex' : 'none';
        }
      })
      .catch(err => console.error('Error loading cart count:', err));
  });
  <% } %>
</script>
