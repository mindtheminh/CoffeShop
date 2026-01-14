<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String contextPath = request.getContextPath();
    Object user = session.getAttribute("user"); // Điều chỉnh tên attribute theo dự án của bạn
%>
<!-- ===== NAV ===== -->
<nav class="navbar navbar-expand-lg navbar-dark fixed-top" id="yc-navbar">
  <div class="container">
    <a class="navbar-brand" href="<%= contextPath %>/">YEN COFFEE HOUSE</a>

    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#yc-nav">
      <span class="oi oi-menu"></span>
    </button>

    <div class="collapse navbar-collapse" id="yc-nav">
      <ul class="navbar-nav ml-auto align-items-center">
        <!-- Icon tìm kiếm -->
        <li class="nav-item d-flex align-items-center">
          <button class="yc-icon" id="yc-search-btn" aria-label="Tìm kiếm">
            <i class="fa-solid fa-magnifying-glass"></i>
          </button>
        </li>

        <li class="nav-item">
          <a href="<%= contextPath %>/" class="nav-link yc-spaced">TRANG CHỦ</a>
        </li>
        <li class="nav-item">
          <a href="<%= contextPath %>/products" class="nav-link yc-spaced">MENU</a>
        </li>
        <li class="nav-item">
          <a href="<%= contextPath %>/promotions" class="nav-link yc-spaced">KHUYẾN MÃI</a>
        </li>

        <!-- Giỏ hàng -->
        <li class="nav-item">
          <a href="<%= contextPath %>/home/cart" class="nav-link yc-spaced" title="Giỏ hàng">
            <i class="fa-solid fa-cart-shopping"></i>
            <span id="cart-count" class="badge-cart" style="display:none;">0</span>
          </a>
        </li>

        <!-- Dropdown tài khoản - Chưa đăng nhập -->
        <% if (user == null) { %>
        <li class="nav-item dropdown account-dropdown">
          <a class="nav-link dropdown-toggle d-flex align-items-center"
             href="#" id="accDrop" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" title="Tài khoản">
            <i class="fa-solid fa-user"></i>
          </a>
          <div class="dropdown-menu dropdown-menu-right shadow" aria-labelledby="accDrop">
            <a class="dropdown-item" href="<%= contextPath %>/login">
              <i class="fa-solid fa-right-to-bracket mr-2"></i>Đăng nhập
            </a>
            <a class="dropdown-item" href="<%= contextPath %>/register">
              <i class="fa-solid fa-user-plus mr-2"></i>Đăng ký
            </a>
          </div>
        </li>
        <% } else { %>
        <!-- Dropdown tài khoản - Đã đăng nhập -->
        <li class="nav-item dropdown">
          <a class="nav-link dropdown-toggle d-flex align-items-center" href="#" id="accDrop" 
             role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
            <i class="fa-solid fa-user"></i>
            <span class="ml-2">
              <% 
                // Điều chỉnh theo cấu trúc user object của bạn
                if (user instanceof java.util.Map) {
                  out.print(((java.util.Map)user).get("username"));
                } else {
                  try {
                    java.lang.reflect.Method method = user.getClass().getMethod("getUsername");
                    out.print(method.invoke(user));
                  } catch(Exception e) {
                    out.print("Tài khoản");
                  }
                }
              %>
            </span>
          </a>
          <div class="dropdown-menu dropdown-menu-right shadow" aria-labelledby="accDrop">
            <a class="dropdown-item" href="<%= contextPath %>/orders">
              <i class="fa-solid fa-list mr-2"></i>Đơn hàng của tôi
            </a>
            <a class="dropdown-item" href="<%= contextPath %>/profile">
              <i class="fa-solid fa-user-gear mr-2"></i>Thông tin
            </a>
            <a class="dropdown-item" href="<%= contextPath %>/logout">
              <i class="fa-solid fa-right-from-bracket mr-2"></i>Đăng xuất
            </a>
          </div>
        </li>
        <% } %>
      </ul>
    </div>
  </div>
  <div class="yc-sep"></div>
</nav>

<!-- Panel tìm kiếm -->
<div id="yc-search-panel" class="yc-search-panel">
  <div class="container d-flex justify-content-center">
    <input id="yc-search-input" type="search" class="yc-search-input" 
           placeholder="Nhập từ khóa đồ uống... (Enter để tìm)">
  </div>
</div>
<!-- ===== END NAV ===== -->
