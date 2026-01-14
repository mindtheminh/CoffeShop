<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    String cPath = request.getContextPath();
    model.UserDto authUser = (model.UserDto) session.getAttribute("authUser");
    String userName = authUser != null ? authUser.getFullName() : "User";
    String userRole = authUser != null ? authUser.getRole() : "";
%>
<c:set var="cPath" value="${pageContext.request.contextPath}" />
<c:set var="authUser" value="${sessionScope.authUser}" />

<!-- Topbar -->
<nav class="sb-topnav navbar navbar-expand navbar-dark bg-dark">

    <!-- Navbar Brand-->
    <a class="navbar-brand ps-3" href="${cPath}/home">
        <i class="fas fa-coffee me-2"></i>YEN COFFEE HOUSE
    </a>

    <!-- Sidebar Toggle -->
    <button class="btn btn-link btn-sm order-1 order-lg-0 me-4 me-lg-0"
            id="sidebarToggle">
        <i class="fas fa-bars"></i>
    </button>

    <!-- Xóa phần Search => d-flex đẩy sang phải -->
    <div class="ms-auto"></div>

    <!-- Navbar-->
    <ul class="navbar-nav ms-auto ms-md-0 me-3 me-lg-4">
        <li class="nav-item dropdown">
            <a class="nav-link dropdown-toggle" id="navbarDropdown"
               href="#" role="button" data-bs-toggle="dropdown"
               aria-expanded="false">
                <i class="fas fa-user fa-fw"></i>
                <span class="d-none d-md-inline ms-1"><%= userName %></span>
                <c:if test="${authUser != null}">
                    <span class="badge bg-secondary ms-2"><%= userRole %></span>
                </c:if>
            </a>

            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="navbarDropdown">
                <li>
                    <a class="dropdown-item" href="${cPath}/customer/my-profile">
                        <i class="fas fa-user-cog me-2"></i>Thông tin tài khoản
                    </a>
                </li>
                <li>
                    <a class="dropdown-item" href="${cPath}/customer/my-orders">
                        <i class="fas fa-shopping-bag me-2"></i>Đơn hàng của tôi
                    </a>
                </li>

                <li><hr class="dropdown-divider" /></li>

                <li>
                    <a class="dropdown-item" href="${cPath}/auth/logout">
                        <i class="fas fa-sign-out-alt me-2"></i>Đăng xuất
                    </a>
                </li>
            </ul>
        </li>
    </ul>
</nav>
