<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    String cPath = request.getContextPath();
    String success = (String) request.getAttribute("success");
    String error = (String) request.getAttribute("error");
%>
<jsp:include page="/WEB-INF/view/layout/public/header.jsp">
    <jsp:param name="pageTitle" value="Đổi mật khẩu - Yen Coffee"/>
</jsp:include>

<jsp:include page="/WEB-INF/view/layout/public/navbar.jsp"/>

<style>
    :root {
        --bg-dark: #0f0f10;
        --bg-darker: #0a0a0b;
        --gold: #c7a17a;
        --card-bg: #141415;
    }

    body {
        font-family: 'Poppins', -apple-system, system-ui, sans-serif;
        background: linear-gradient(180deg, var(--bg-dark), var(--bg-darker));
        color: #e9e9e9;
        min-height: 100vh;
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

    .card {
        background: var(--card-bg);
        border: 1px solid rgba(255,255,255,.08);
        border-radius: 16px;
        padding: 30px;
        box-shadow: 0 14px 40px rgba(0,0,0,.35);
        max-width: 600px;
        margin: 0 auto;
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

    .form-group {
        margin-bottom: 20px;
    }

    .form-group label {
        display: block;
        font-weight: 600;
        margin-bottom: 8px;
        color: #e9e9e9;
    }

    .pw-wrap {
        position: relative;
    }

    .form-control {
        width: 100%;
        background: #0f0f10;
        border: 1px solid rgba(255,255,255,.12);
        color: #fff;
        padding: 12px 16px;
        padding-right: 50px;
        border-radius: 12px;
        font-size: 15px;
        transition: border-color .3s;
    }

    .form-control:focus {
        outline: none;
        border-color: var(--gold);
    }

    .pw-toggle {
        position: absolute;
        right: 15px;
        top: 50%;
        transform: translateY(-50%);
        background: transparent;
        border: none;
        color: #cfcfcf;
        font-size: 18px;
        cursor: pointer;
        transition: color .3s;
    }

    .pw-toggle:hover {
        color: var(--gold);
    }

    .password-requirements {
        background: rgba(199,161,122,.1);
        border-left: 3px solid var(--gold);
        padding: 15px;
        border-radius: 8px;
        margin-top: 20px;
    }

    .password-requirements ul {
        list-style: none;
        margin: 10px 0 0 0;
        padding: 0;
    }

    .password-requirements li {
        display: flex;
        align-items: center;
        gap: 10px;
        padding: 5px 0;
        color: #cfcfcf;
        font-size: 14px;
    }

    .password-requirements li i {
        color: var(--gold);
    }

    .btn {
        padding: 12px 30px;
        border-radius: 999px;
        font-weight: 700;
        border: none;
        cursor: pointer;
        transition: all .3s;
        font-size: 15px;
    }

    .btn-primary {
        background: var(--gold);
        color: #000;
    }

    .btn-primary:hover {
        filter: brightness(1.1);
        transform: translateY(-2px);
    }

    @media (max-width: 768px) {
        .page-title {
            font-size: 24px;
        }

        .card {
            padding: 20px;
        }
    }
</style>

<!-- Page Header -->
<div class="page-header">
    <div class="container">
        <h1 class="page-title">
            <i class="fas fa-key"></i> Đổi mật khẩu
        </h1>
    </div>
</div>

<!-- Main Content -->
<div class="container pb-5">
    <!-- Navigation Tabs -->
    <div class="nav-tabs">
        <a href="<%= cPath %>/customer/my-profile">
            <i class="fas fa-user"></i> Thông tin
        </a>
        <a href="<%= cPath %>/customer/my-orders">
            <i class="fas fa-shopping-bag"></i> Đơn hàng
        </a>
        <a href="<%= cPath %>/customer/change-password" class="active">
            <i class="fas fa-key"></i> Đổi mật khẩu
        </a>
    </div>

    <div class="card">
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

        <form method="post" action="<%= cPath %>/customer/change-password">
            <div class="form-group pw-wrap">
                <label for="currentPassword">
                    <i class="fas fa-lock"></i> Mật khẩu hiện tại *
                </label>
                <input type="password" id="currentPassword" name="currentPassword"
                       class="form-control" placeholder="••••••••" required>
                <button type="button" class="pw-toggle" id="toggleCurrent">
                    <i class="fa-regular fa-eye"></i>
                </button>
            </div>

            <div class="form-group pw-wrap">
                <label for="newPassword">
                    <i class="fas fa-key"></i> Mật khẩu mới *
                </label>
                <input type="password" id="newPassword" name="newPassword"
                       class="form-control" placeholder="••••••••" required>
                <button type="button" class="pw-toggle" id="toggleNew">
                    <i class="fa-regular fa-eye"></i>
                </button>
            </div>

            <div class="form-group pw-wrap">
                <label for="confirmPassword">
                    <i class="fas fa-check-double"></i> Xác nhận mật khẩu mới *
                </label>
                <input type="password" id="confirmPassword" name="confirmPassword"
                       class="form-control" placeholder="••••••••" required>
                <button type="button" class="pw-toggle" id="toggleConfirm">
                    <i class="fa-regular fa-eye"></i>
                </button>
            </div>

            <div class="password-requirements">
                <div style="font-weight:700;margin-bottom:5px;color:var(--gold);">
                    <i class="fas fa-info-circle"></i> Yêu cầu mật khẩu:
                </div>
                <ul>
                    <li>
                        <i class="fas fa-check-circle"></i>
                        <span>Tối thiểu 8 ký tự</span>
                    </li>
                    <li>
                        <i class="fas fa-check-circle"></i>
                        <span>Có ít nhất 1 chữ HOA (A-Z)</span>
                    </li>
                    <li>
                        <i class="fas fa-check-circle"></i>
                        <span>Có ít nhất 1 chữ thường (a-z)</span>
                    </li>
                    <li>
                        <i class="fas fa-check-circle"></i>
                        <span>Có ít nhất 1 số (0-9)</span>
                    </li>
                </ul>
            </div>

            <div style="margin-top: 30px;">
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-save"></i> Đổi mật khẩu
                </button>
            </div>
        </form>
    </div>
</div>

<jsp:include page="/WEB-INF/view/layout/public/footer.jsp"/>
<jsp:include page="/WEB-INF/view/layout/public/scripts.jsp"/>

<script>
    // Toggle password visibility
    const togglePassword = (inputId, toggleId) => {
        const input = document.getElementById(inputId);
        const toggle = document.getElementById(toggleId);

        toggle.addEventListener('click', () => {
            const isPassword = input.type === 'password';
            input.type = isPassword ? 'text' : 'password';
            toggle.innerHTML = isPassword
                ? '<i class="fa-regular fa-eye-slash"></i>'
                : '<i class="fa-regular fa-eye"></i>';
        });
    };

    togglePassword('currentPassword', 'toggleCurrent');
    togglePassword('newPassword', 'toggleNew');
    togglePassword('confirmPassword', 'toggleConfirm');

    // Password match validation
    const newPassword = document.getElementById('newPassword');
    const confirmPassword = document.getElementById('confirmPassword');

    confirmPassword.addEventListener('input', () => {
        if (confirmPassword.value && newPassword.value !== confirmPassword.value) {
            confirmPassword.setCustomValidity('Mật khẩu không khớp');
        } else {
            confirmPassword.setCustomValidity('');
        }
    });

    newPassword.addEventListener('input', () => {
        if (confirmPassword.value && newPassword.value !== confirmPassword.value) {
            confirmPassword.setCustomValidity('Mật khẩu không khớp');
        } else {
            confirmPassword.setCustomValidity('');
        }
    });
</script>

</body>
</html>
