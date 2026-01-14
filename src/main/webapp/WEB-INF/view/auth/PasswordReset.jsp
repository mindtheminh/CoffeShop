<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    String cPath = request.getContextPath();
    String message = (String) request.getAttribute("message");
    String error = (String) request.getAttribute("error");
    String email = (String) request.getAttribute("email");
    Boolean showOTPForm = (Boolean) request.getAttribute("showOTPForm");
    request.setAttribute("pageTitle", "Quên mật khẩu - Yen Coffee House");
%>

<jsp:include page="/WEB-INF/view/layout/public/header.jsp"/>
<jsp:include page="/WEB-INF/view/layout/public/navbar.jsp"/>

<!-- ===== FORGOT PASSWORD WITH OTP ===== -->
<main class="auth-wrap">
    <div class="auth-card">
        <h1>Quên mật khẩu?</h1>
        <p class="subtitle">
            <% if (showOTPForm != null && showOTPForm) { %>
                Nhập mã OTP và mật khẩu mới
            <% } else { %>
                Nhập email để nhận mã xác nhận
            <% } %>
        </p>

        <!-- Alert messages -->
        <c:if test="${not empty message}">
            <div class="alert alert-success mb-3">
                <i class="fa-solid fa-circle-check"></i>
                ${message}
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger mb-3">
                <i class="fa-solid fa-circle-exclamation"></i>
                ${error}
            </div>
        </c:if>

        <form action="<%= cPath %>/auth/reset-password" method="post" autocomplete="off" novalidate>
            
            <!-- Email Field (always shown) -->
            <div class="form-group">
                <label for="email">Địa chỉ email *</label>
                <input type="email" id="email" name="email" class="form-control" 
                       value="<%= email != null ? email : "" %>"
                       placeholder="you@example.com" required 
                       <%= showOTPForm != null && showOTPForm ? "readonly" : "" %>>
            </div>

            <% if (showOTPForm != null && showOTPForm) { %>
                <!-- OTP Input -->
                <div class="form-group otp-group">
                    <label for="otp">Mã OTP (kiểm tra email) *</label>
                    <input type="text" id="otp" name="otp" class="form-control otp-input" 
                           maxlength="6" placeholder="123456" required pattern="[0-9]{6}"
                           autocomplete="off">
                    <small class="form-text">Mã OTP gồm 6 chữ số đã được gửi đến email của bạn</small>
                </div>

                <!-- New Password -->
                <div class="form-group pw-wrap">
                    <label for="password">Mật khẩu mới *</label>
                    <input type="password" id="password" name="password" class="form-control" 
                           placeholder="••••••••" required>
                    <button type="button" class="pw-toggle" id="togglePw1" aria-label="Hiện/ẩn mật khẩu">
                        <i class="fa-regular fa-eye"></i>
                    </button>
                </div>

                <!-- Confirm Password -->
                <div class="form-group pw-wrap">
                    <label for="confirmPassword">Xác nhận mật khẩu *</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" 
                           placeholder="••••••••" required>
                    <button type="button" class="pw-toggle" id="togglePw2" aria-label="Hiện/ẩn mật khẩu">
                        <i class="fa-regular fa-eye"></i>
                    </button>
                </div>

                <div class="password-requirements mb-3">
                    <small class="muted">
                        <i class="fa-solid fa-circle-info"></i>
                        Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường và số
                    </small>
                </div>

                <button type="submit" class="btn btn-primary btn-block w-100">Đặt lại mật khẩu</button>

                <div class="text-center mt-3">
                    <a href="<%= cPath %>/auth/reset" class="link-secondary">
                        <i class="fa-solid fa-arrow-left"></i>
                        Gửi lại mã OTP
                    </a>
                </div>

            <% } else { %>
                <!-- Request OTP Button -->
                <button type="submit" class="btn btn-primary btn-block w-100">Gửi mã OTP</button>

                <div class="sep"><span class="muted">hoặc</span></div>

                <div class="text-center">
                    <a href="<%= cPath %>/auth/login" class="link-secondary">
                        <i class="fa-solid fa-arrow-left"></i>
                        Quay lại đăng nhập
                    </a>
                </div>
            <% } %>

            <p class="text-center mt-3 muted">
                Chưa có tài khoản?
                <a href="<%= cPath %>/auth/register" style="color:var(--gold);font-weight:700">Đăng ký ngay!</a>
            </p>
        </form>
    </div>
</main>

<jsp:include page="/WEB-INF/view/layout/public/footer.jsp"/>
<jsp:include page="/WEB-INF/view/layout/public/scripts.jsp"/>

<!-- JS toggle password -->
<script>
    <% if (showOTPForm != null && showOTPForm) { %>
    // Toggle password visibility
    const pw1 = document.getElementById('password');
    const toggle1 = document.getElementById('togglePw1');
    if (pw1 && toggle1) {
        toggle1.addEventListener('click', () => {
            const show = pw1.type === 'password';
            pw1.type = show ? 'text' : 'password';
            toggle1.innerHTML = show
                ? '<i class="fa-regular fa-eye-slash"></i>'
                : '<i class="fa-regular fa-eye"></i>';
            pw1.focus();
        });
    }

    const pw2 = document.getElementById('confirmPassword');
    const toggle2 = document.getElementById('togglePw2');
    if (pw2 && toggle2) {
        toggle2.addEventListener('click', () => {
            const show = pw2.type === 'password';
            pw2.type = show ? 'text' : 'password';
            toggle2.innerHTML = show
                ? '<i class="fa-regular fa-eye-slash"></i>'
                : '<i class="fa-regular fa-eye"></i>';
            pw2.focus();
        });
    }

    // OTP input: only numbers
    const otpInput = document.getElementById('otp');
    if (otpInput) {
        otpInput.addEventListener('input', function(e) {
            this.value = this.value.replace(/[^0-9]/g, '');
        });
        
        // Auto-focus OTP field
        otpInput.focus();
    }

    // Password match validation
    const passwordInput = document.getElementById('password');
    const confirmInput = document.getElementById('confirmPassword');
    
    if (confirmInput && passwordInput) {
        confirmInput.addEventListener('input', () => {
            if (confirmInput.value && passwordInput.value !== confirmInput.value) {
                confirmInput.setCustomValidity('Mật khẩu không khớp');
            } else {
                confirmInput.setCustomValidity('');
            }
        });

        passwordInput.addEventListener('input', () => {
            if (confirmInput.value && passwordInput.value !== confirmInput.value) {
                confirmInput.setCustomValidity('Mật khẩu không khớp');
            } else {
                confirmInput.setCustomValidity('');
            }
        });
    }
    <% } %>
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
.auth-card h1{font-size:28px;font-weight:800;margin:0 0 .5rem}
.auth-card .subtitle{color:#cfcfcf;font-size:15px;margin-bottom:1.5rem}
.form-group{margin-bottom:1rem}
.form-group label{font-weight:600;margin-bottom:.35rem;display:block}
.form-control{
  background:#0f0f10;border:1px solid rgba(255,255,255,.12);
  color:#fff;border-radius:12px;
  height:48px;padding:.6rem .9rem;width:100%;
}
.form-control:focus{border-color:#ffffff33;box-shadow:none;outline:none}
.form-control[readonly]{background:#1a1a1b;cursor:not-allowed;opacity:.7}
.pw-wrap{position:relative}
.pw-toggle{
  position:absolute;right:.75rem;top:50%;transform:translateY(-50%);
  background:transparent;border:0;color:#cfcfcf;font-size:18px;cursor:pointer
}
.otp-input{
  text-align:center;
  font-size:24px;
  font-weight:bold;
  letter-spacing:8px;
  font-family:monospace;
}
.otp-group small{
  display:block;
  margin-top:.5rem;
  color:#999;
  font-size:13px;
}
.password-requirements{
  background:rgba(199,161,122,.1);
  border-left:3px solid var(--gold);
  padding:.75rem 1rem;
  border-radius:8px;
}
.password-requirements small{
  display:flex;
  align-items:center;
  gap:.5rem;
  line-height:1.4;
}
.btn{border-radius:999px;padding:.7rem 1.2rem;font-weight:700;border:none;cursor:pointer}
.btn-primary{background:var(--gold);border:2px solid var(--gold);color:#000}
.btn-primary:hover{filter:brightness(1.05)}
.muted{color:#cfcfcf}
.link-secondary{
  color:#cfcfcf;
  font-weight:600;
  transition:color .2s;
}
.link-secondary:hover{color:var(--gold)}
.link-secondary i{margin-right:.5rem}
.sep{display:flex;align-items:center;gap:10px;margin:.9rem 0}
.sep::before,.sep::after{content:"";height:1px;background:#ffffff1a;flex:1}
.alert{
  padding:.85rem 1rem;
  border-radius:12px;
  margin-bottom:1rem;
  display:flex;
  align-items:center;
  gap:.75rem;
}
.alert-success{
  background:rgba(46,204,113,.15);
  color:#2ecc71;
  border:1px solid rgba(46,204,113,.3);
}
.alert-danger{
  background:rgba(231,76,60,.15);
  color:#e74c3c;
  border:1px solid rgba(231,76,60,.3);
}
.alert i{font-size:1.1rem}
.footer-min{padding:1.2rem 0;background:#0b0b0c;text-align:center;color:#cfcfcf}
</style>
