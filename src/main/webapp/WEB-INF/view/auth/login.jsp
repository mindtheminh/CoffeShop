<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%
    String cPath = request.getContextPath();
    String error = (String) request.getAttribute("error");
    String success = (String) session.getAttribute("registerSuccess");
    if (success != null) session.removeAttribute("registerSuccess");
    request.setAttribute("pageTitle", "Đăng nhập - Yen Coffee House");
%>

<jsp:include page="/WEB-INF/view/layout/public/header.jsp"/>
<jsp:include page="/WEB-INF/view/layout/public/navbar.jsp"/>

<!-- ===== LOGIN ===== -->
<main class="auth-wrap">
    <form class="auth-card" action="<%= cPath %>/auth/login" method="post" autocomplete="on" novalidate>
        <h1>Chào mừng bạn trở lại</h1>

        <!-- Alert messages -->
        <c:if test="${not empty success}">
            <div class="alert alert-success mb-3">${success}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger mb-3">${error}</div>
        </c:if>

        <div class="form-group">
            <label for="email">Email *</label>
            <input type="email" id="email" name="email" class="form-control" placeholder="you@example.com" required>
        </div>

        <div class="form-group pw-wrap">
            <label for="password">Mật khẩu *</label>
            <input type="password" id="password" name="password" class="form-control" placeholder="••••••••" required>
            <button type="button" class="pw-toggle" id="togglePw" aria-label="Hiện/ẩn mật khẩu">
                <i class="fa-regular fa-eye"></i>
            </button>
        </div>

        <div class="d-flex align-items-center justify-content-between mb-3">
            <label class="d-flex align-items-center" style="gap:.5rem;margin:0;">
                <input type="checkbox" id="remember" name="remember" style="transform:translateY(1px)">
                <span class="muted">Ghi nhớ đăng nhập</span>
            </label>
            <a href="<%= cPath %>/auth/reset" class="muted">Quên mật khẩu?</a>
        </div>

        <button type="submit" class="btn btn-primary btn-block w-100">Đăng nhập</button>

        <div class="sep"><span class="muted">hoặc</span></div>

        <a href="<%= cPath %>/auth/google-login" class="btn-google">
            <img src="https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg" alt="">
            Đăng nhập với Google
        </a>

        <p class="text-center mt-3 muted">
            Bạn chưa có tài khoản?
            <a href="<%= cPath %>/auth/register" style="color:var(--gold);font-weight:700">Tạo tài khoản!</a>
        </p>
    </form>
</main>

<jsp:include page="/WEB-INF/view/layout/public/footer.jsp"/>
<jsp:include page="/WEB-INF/view/layout/public/scripts.jsp"/>

<!-- JS toggle password -->
<script>
    const pw = document.getElementById('password');
    const toggle = document.getElementById('togglePw');
    toggle.addEventListener('click', () => {
        const show = pw.type === 'password';
        pw.type = show ? 'text' : 'password';
        toggle.innerHTML = show
            ? '<i class="fa-regular fa-eye-slash"></i>'
            : '<i class="fa-regular fa-eye"></i>';
        pw.focus();
    });
</script>

<!-- Custom CSS -->
<style>
:root{
  --bg-dark:#0f0f10;--bg-darker:#0a0a0b;--gold:#c7a17a;
  --nav-h:72px;
}
@media (max-width:991.98px){:root{--nav-h:56px}}

body{
  background:#0c0c0d;color:#e9e9e9;
  font-family:"Poppins",system-ui,-apple-system,Segoe UI,Roboto,"Helvetica Neue",Arial,"Noto Sans",sans-serif;
  padding-top:var(--nav-h);
}
a{color:inherit;text-decoration:none}

.auth-wrap{
  min-height:calc(100vh - var(--nav-h) - 120px);
  display:flex;align-items:center;justify-content:center;
  padding:2rem 1rem;
  background:linear-gradient(180deg,var(--bg-dark),var(--bg-darker));
}
.auth-card{
  width:100%;max-width:520px;
  background:#141415;border:1px solid rgba(255,255,255,.08);
  border-radius:16px;box-shadow:0 14px 40px rgba(0,0,0,.35);
  padding:1.5rem 1.5rem 1.75rem;
  margin-top:.75rem;
}
.auth-card h1{font-size:28px;font-weight:800;margin:0 0 .75rem}
.form-group label{font-weight:600;margin-bottom:.35rem}
.form-control{
  background:#0f0f10;border:1px solid rgba(255,255,255,.12);
  color:#fff;border-radius:12px;
  height:48px;padding:.6rem .9rem;
}
.form-control:focus{border-color:#ffffff33;box-shadow:none}
.pw-wrap{position:relative}
.pw-toggle{
  position:absolute;right:.75rem;top:50%;transform:translateY(-50%);
  background:transparent;border:0;color:#cfcfcf;font-size:18px
}
.btn{border-radius:999px;padding:.7rem 1.2rem;font-weight:700}
.btn-primary{background:var(--gold);border:2px solid var(--gold);color:#000}
.btn-primary:hover{filter:brightness(1.05)}
.btn-google{
  width:100%;display:flex;align-items:center;justify-content:center;gap:.55rem;
  background:#fff;color:#000;border-radius:999px;border:0;height:48px;font-weight:700
}
.btn-google img{width:20px;height:20px}
.muted{color:#cfcfcf}
.sep{display:flex;align-items:center;gap:10px;margin:.9rem 0}
.sep::before,.sep::after{content:"";height:1px;background:#ffffff1a;flex:1}
.footer-min{padding:1.2rem 0;background:#0b0b0c;text-align:center;color:#cfcfcf}
</style>
