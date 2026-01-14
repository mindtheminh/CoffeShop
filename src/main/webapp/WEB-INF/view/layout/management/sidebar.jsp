<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    String cPath = request.getContextPath();
    model.UserDto authUser = (model.UserDto) session.getAttribute("authUser");
    String role = authUser != null ? authUser.getRole() : "";
    
    boolean isAdmin = "ADMIN".equals(role);
    boolean isHR = "HR".equals(role);
    boolean isMarketer = "MARKETER".equals(role);
    boolean isCashier = "CASHIER".equals(role);
%>
<c:set var="cPath" value="${pageContext.request.contextPath}" />
<c:set var="authUser" value="${sessionScope.authUser}" />
<c:set var="isAdmin" value="${authUser != null && authUser.role == 'ADMIN'}" />
<c:set var="isHR" value="${authUser != null && authUser.role == 'HR'}" />
<c:set var="isMarketer" value="${authUser != null && authUser.role == 'MARKETER'}" />
<c:set var="isCashier" value="${authUser != null && authUser.role == 'CASHIER'}" />

<div id="layoutSidenav">
  <div id="layoutSidenav_nav">
    <nav class="sb-sidenav accordion sb-sidenav-dark" id="sidenavAccordion">
      <div class="sb-sidenav-menu">
        <div class="nav">
          <div class="sb-sidenav-menu-heading">CORE</div>

          <a class="nav-link" href="${cPath}/home">
            <div class="sb-nav-link-icon"><i class="fas fa-home"></i></div>
            Trang chủ
          </a>

          <!-- Dashboards - Chỉ hiện 1 dashboard theo role -->
          <c:if test="${isHR}">
            <a class="nav-link" href="${cPath}/hr-dashboard">
              <div class="sb-nav-link-icon"><i class="fas fa-users-cog"></i></div>
              HR Dashboard
            </a>
          </c:if>

          <c:if test="${isMarketer}">
            <a class="nav-link" href="${cPath}/marketer-dashboard">
              <div class="sb-nav-link-icon"><i class="fas fa-chart-line"></i></div>
              Marketer Dashboard
            </a>
          </c:if>

          <c:if test="${isCashier}">
            <a class="nav-link" href="${cPath}/cashier-dashboard">
              <div class="sb-nav-link-icon"><i class="fas fa-cash-register"></i></div>
              Cashier Dashboard
            </a>
          </c:if>

          <c:if test="${isAdmin}">
            <a class="nav-link" href="${cPath}/admin-dashboard">
              <div class="sb-nav-link-icon"><i class="fas fa-tachometer-alt"></i></div>
              Admin Dashboard
            </a>
          </c:if>

          <div class="sb-sidenav-menu-heading">CHỨC NĂNG</div>

          <!-- Users (HR & Admin) -->
          <c:if test="${isAdmin || isHR}">
            <a class="nav-link collapsed" href="#" data-bs-toggle="collapse"
               data-bs-target="#collapseUser" aria-expanded="false" aria-controls="collapseUser">
              <div class="sb-nav-link-icon"><i class="fas fa-users"></i></div>
              Người dùng
              <div class="sb-sidenav-collapse-arrow"><i class="fas fa-angle-down"></i></div>
            </a>
            <div class="collapse" id="collapseUser" data-bs-parent="#sidenavAccordion">
              <nav class="sb-sidenav-menu-nested nav">
                <a class="nav-link" href="${cPath}/user-list">Danh sách người dùng</a>
                <a class="nav-link" href="${cPath}/user-new">Tạo người dùng mới</a>
              </nav>
            </div>
          </c:if>

          <!-- Products (Marketer & Admin) -->
          <c:if test="${isAdmin || isMarketer}">
            <a class="nav-link collapsed" href="#" data-bs-toggle="collapse"
               data-bs-target="#collapseProduct" aria-expanded="false" aria-controls="collapseProduct">
              <div class="sb-nav-link-icon"><i class="fas fa-coffee"></i></div>
              Sản phẩm
              <div class="sb-sidenav-collapse-arrow"><i class="fas fa-angle-down"></i></div>
            </a>
            <div class="collapse" id="collapseProduct" data-bs-parent="#sidenavAccordion">
              <nav class="sb-sidenav-menu-nested nav">
                <a class="nav-link" href="${cPath}/product-list">Danh sách sản phẩm</a>
                <a class="nav-link" href="${cPath}/product-new">Thêm sản phẩm</a>
              </nav>
            </div>
          </c:if>

          <!-- Promotions (Marketer & Admin) -->
          <c:if test="${isAdmin || isMarketer}">
            <a class="nav-link collapsed" href="#" data-bs-toggle="collapse"
               data-bs-target="#collapsePromo" aria-expanded="false" aria-controls="collapsePromo">
              <div class="sb-nav-link-icon"><i class="fas fa-tags"></i></div>
              Khuyến mãi
              <div class="sb-sidenav-collapse-arrow"><i class="fas fa-angle-down"></i></div>
            </a>
            <div class="collapse" id="collapsePromo" data-bs-parent="#sidenavAccordion">
              <nav class="sb-sidenav-menu-nested nav">
                <a class="nav-link" href="${cPath}/promotion-list">Danh sách khuyến mãi</a>
                <a class="nav-link" href="${cPath}/promotion-new">Thêm khuyến mãi</a>
              </nav>
            </div>
          </c:if>

          <!-- Orders (Cashier & Admin) -->
          <c:if test="${isAdmin || isCashier}">
            <a class="nav-link collapsed" href="#" data-bs-toggle="collapse"
               data-bs-target="#collapseOrder" aria-expanded="false" aria-controls="collapseOrder">
              <div class="sb-nav-link-icon"><i class="fas fa-shopping-cart"></i></div>
              Đơn hàng
              <div class="sb-sidenav-collapse-arrow"><i class="fas fa-angle-down"></i></div>
            </a>
            <div class="collapse" id="collapseOrder" data-bs-parent="#sidenavAccordion">
              <nav class="sb-sidenav-menu-nested nav">
                <a class="nav-link" href="${cPath}/orders">Danh sách đơn hàng</a>
                <a class="nav-link" href="${cPath}/NewOrderServlet">Tạo đơn hàng mới</a>
              </nav>
            </div>
          </c:if>

          <!-- Settings (Admin only) -->
          <c:if test="${isAdmin}">
            <a class="nav-link collapsed" href="#" data-bs-toggle="collapse"
               data-bs-target="#collapseSetting" aria-expanded="false" aria-controls="collapseSetting">
              <div class="sb-nav-link-icon"><i class="fas fa-gear"></i></div>
              Cấu hình
              <div class="sb-sidenav-collapse-arrow"><i class="fas fa-angle-down"></i></div>
            </a>
            <div class="collapse" id="collapseSetting" data-bs-parent="#sidenavAccordion">
              <nav class="sb-sidenav-menu-nested nav">
                <a class="nav-link" href="${cPath}/setting-list">Danh sách cấu hình</a>
                <a class="nav-link" href="${cPath}/setting-new">Thêm cấu hình</a>
              </nav>
            </div>
          </c:if>

        </div>
      </div>

      <div class="sb-sidenav-footer">
        <div class="small">Đăng nhập với vai trò:</div>
        <c:choose>
          <c:when test="${isAdmin}">Admin</c:when>
          <c:when test="${isHR}">HR</c:when>
          <c:when test="${isMarketer}">Marketer</c:when>
          <c:when test="${isCashier}">Cashier</c:when>
          <c:otherwise>User</c:otherwise>
        </c:choose>
      </div>
    </nav>
  </div>

  <div id="layoutSidenav_content">
    <!-- Content will be inserted here -->

