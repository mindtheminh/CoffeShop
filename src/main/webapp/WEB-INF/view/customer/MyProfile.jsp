<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%
    String cPath = request.getContextPath();
    model.UserDto user = (model.UserDto) request.getAttribute("user");
    String success = (String) session.getAttribute("success");
    String error = (String) request.getAttribute("error");
    if (success != null) {
        session.removeAttribute("success");
    }
    
    // Format created_at date
    String createdAtStr = "Chưa có";
    if (user != null && user.getCreatedAt() != null) {
        try {
            java.time.OffsetDateTime createdAt = user.getCreatedAt();
            java.time.format.DateTimeFormatter formatter = 
                java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
            createdAtStr = createdAt.format(formatter);
        } catch (Exception e) {
            createdAtStr = "Chưa có";
        }
    }
%>
<jsp:include page="/WEB-INF/view/layout/public/header.jsp">
    <jsp:param name="pageTitle" value="Thông tin tài khoản - Yen Coffee"/>
</jsp:include>

<jsp:include page="/WEB-INF/view/layout/public/navbar.jsp"/>

<style>
    :root {
        --gold: #c7a17a;
        --dark-bg: #0f0f10;
        --card-bg: rgba(15, 15, 16, 0.8);
    }

    body {
        background: linear-gradient(135deg, #1a1a1d 0%, #0f0f10 100%);
        color: #e9e9e9;
        min-height: 100vh;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        padding-top: 80px;
    }

    .page-header {
        background: linear-gradient(135deg, rgba(199, 161, 122, 0.1) 0%, rgba(15, 15, 16, 0.8) 100%);
        backdrop-filter: blur(10px);
        border-bottom: 2px solid var(--gold);
        padding: 2rem 0;
        margin-bottom: 2rem;
    }

    .page-title {
        color: var(--gold);
        font-size: 2rem;
        font-weight: 700;
        margin: 0;
    }

    .nav-tabs {
        display: flex;
        gap: 10px;
        margin-bottom: 30px;
        flex-wrap: wrap;
        border-bottom: 2px solid rgba(199, 161, 122, 0.2);
        padding-bottom: 15px;
    }

    .nav-tabs a {
        padding: 12px 24px;
        border-radius: 8px;
        text-decoration: none;
        font-weight: 600;
        transition: all .3s;
        border: 2px solid transparent;
        color: #cfcfcf;
    }

    .nav-tabs a.active {
        background: var(--gold);
        color: #000;
    }

    .nav-tabs a:not(.active) {
        background: rgba(255,255,255,.05);
        border-color: rgba(255,255,255,.08);
    }

    .nav-tabs a:not(.active):hover {
        background: rgba(255,255,255,.08);
        color: #e9e9e9;
    }

    .profile-card {
        background: var(--card-bg);
        backdrop-filter: blur(10px);
        border: 1px solid rgba(199, 161, 122, 0.2);
        border-radius: 12px;
        padding: 2rem;
        margin-bottom: 2rem;
    }

    .form-group {
        margin-bottom: 1.5rem;
    }

    .form-group label {
        display: block;
        font-weight: 600;
        margin-bottom: 0.5rem;
        color: #e9e9e9;
    }

    .form-control {
        width: 100%;
        background: #0f0f10;
        border: 1px solid rgba(255,255,255,.12);
        color: #fff;
        padding: 12px 16px;
        border-radius: 8px;
        font-size: 15px;
        transition: border-color .3s;
    }

    .form-control:focus {
        outline: none;
        border-color: var(--gold);
    }

    .btn-gold {
        background: var(--gold);
        color: #000;
        border: none;
        padding: 12px 30px;
        border-radius: 8px;
        font-weight: 600;
        transition: all 0.3s ease;
        cursor: pointer;
    }

    .btn-gold:hover {
        background: #d4b08c;
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(199, 161, 122, 0.3);
    }

    .alert {
        padding: 15px 20px;
        border-radius: 12px;
        margin-bottom: 20px;
        display: flex;
        align-items: center;
        gap: 12px;
    }

    .alert-success {
        background: rgba(46,204,113,.15);
        color: #2ecc71;
        border: 1px solid rgba(46,204,113,.3);
    }

    .alert-danger {
        background: rgba(231,76,60,.15);
        color: #e74c3c;
        border: 1px solid rgba(231,76,60,.3);
    }
</style>

<!-- Page Header -->
<div class="page-header">
    <div class="container">
        <h1 class="page-title">
            <i class="fas fa-user-cog"></i> Thông tin tài khoản
        </h1>
    </div>
</div>

<!-- Main Content -->
<div class="container pb-5">
    <!-- Navigation Tabs -->
    <div class="nav-tabs">
        <a href="<%= cPath %>/customer/my-profile" class="active">
            <i class="fas fa-user"></i> Thông tin
        </a>
        <a href="<%= cPath %>/customer/my-orders">
            <i class="fas fa-shopping-bag"></i> Đơn hàng
        </a>
        <a href="<%= cPath %>/customer/change-password">
            <i class="fas fa-key"></i> Đổi mật khẩu
        </a>
    </div>

    <!-- Profile Card -->
    <div class="profile-card">
        <% if (success != null) { %>
        <div class="alert alert-success">
            <i class="fas fa-check-circle"></i>
            <span><%= success %></span>
        </div>
        <% } %>

        <% if (error != null) { %>
        <div class="alert alert-danger">
            <i class="fas fa-exclamation-circle"></i>
            <span><%= error %></span>
        </div>
        <% } %>

        <form method="post" action="<%= cPath %>/customer/my-profile">
            <div class="form-group">
                <label for="fullName">
                    <i class="fas fa-user"></i> Họ và tên *
                </label>
                <input type="text" id="fullName" name="fullName" 
                       class="form-control" 
                       value="<%= user != null ? user.getFullName() : "" %>" 
                       required>
            </div>

            <div class="form-group">
                <label for="email">
                    <i class="fas fa-envelope"></i> Email *
                </label>
                <input type="email" id="email" name="email" 
                       class="form-control" 
                       value="<%= user != null ? user.getEmail() : "" %>" 
                       required>
            </div>

            <div class="form-group">
                <label>
                    <i class="fas fa-shield-alt"></i> Vai trò
                </label>
                <input type="text" class="form-control" 
                       value="<%= user != null && user.getRole() != null ? user.getRole() : "CUSTOMER" %>" 
                       disabled style="opacity: 0.6;">
            </div>

            <div class="form-group">
                <label>
                    <i class="fas fa-id-card"></i> User ID
                </label>
                <input type="text" class="form-control" 
                       value="<%= user != null && user.getUserId() != null ? user.getUserId() : "" %>" 
                       disabled style="opacity: 0.6;">
            </div>

            <div class="form-group">
                <label>
                    <i class="fas fa-phone"></i> Số điện thoại
                </label>
                <input type="text" class="form-control" 
                       value="<%= request.getAttribute("phone") != null ? request.getAttribute("phone") : "Chưa có" %>" 
                       disabled style="opacity: 0.6;">
            </div>

            <div class="form-group">
                <label>
                    <i class="fas fa-calendar-alt"></i> Ngày tạo tài khoản
                </label>
                <input type="text" class="form-control" 
                       value="<%= createdAtStr %>" 
                       disabled style="opacity: 0.6;">
            </div>

            <div style="margin-top: 30px;">
                <button type="submit" class="btn-gold">
                    <i class="fas fa-save"></i> Cập nhật thông tin
                </button>
            </div>
        </form>
    </div>
</div>

<jsp:include page="/WEB-INF/view/layout/public/footer.jsp"/>
<jsp:include page="/WEB-INF/view/layout/public/scripts.jsp"/>

</body>
</html>
