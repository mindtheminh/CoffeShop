<%@ page contentType="text/html;charset=UTF-8" %>

<style>
    :root{
        --bg-dark:#0f0f10;
        --bg-darker:#0a0a0b;
        --gold:#c7a17a;
    }
    .auth-wrap{
        min-height:calc(100vh - var(--nav-h) - 120px);
        display:flex;
        align-items:center;
        justify-content:center;
        padding:2rem 1rem;
        background:linear-gradient(180deg,var(--bg-dark),var(--bg-darker));
    }
    .auth-card{
        width:100%;
        max-width:560px;
        background:#141415;
        border:1px solid rgba(255,255,255,.08);
        border-radius:16px;
        box-shadow:0 14px 40px rgba(0,0,0,.35);
        padding:1.5rem 1.75rem 1.75rem;
        margin-top:.75rem;
    }
    .auth-card h1{
        font-size:28px;
        font-weight:800;
        margin:0 0 1rem;
    }
    .auth-card p{
        color:#cfcfcf;
        line-height:1.6;
        margin-bottom:1.5rem;
    }
    .form-group{
        margin-bottom:1.5rem;
    }
    .form-group label{
        font-weight:600;
        margin-bottom:.5rem;
        display:block;
    }
    .form-control{
        background:#0f0f10;
        border:1px solid rgba(255,255,255,.12);
        color:#fff;
        border-radius:12px;
        height:48px;
        padding:.6rem .9rem;
        width:100%;
    }
    .form-control:focus{
        border-color:#ffffff33;
        box-shadow:none;
        outline:none;
    }
    .otp-input{
        text-align:center;
        font-size:28px;
        font-weight:bold;
        letter-spacing:12px;
        font-family:monospace;
        height:68px;
    }
    .btn-primary{
        background:var(--gold);
        border:2px solid var(--gold);
        color:#000;
        border-radius:999px;
        padding:.7rem 1.2rem;
        font-weight:700;
        cursor:pointer;
    }
    .btn-primary:hover{
        filter:brightness(1.05);
    }
    .alert{
        padding:.85rem 1rem;
        border-radius:12px;
        margin-bottom:1rem;
    }
    .alert-danger{
        background:rgba(231,76,60,.15);
        color:#e74c3c;
        border:1px solid rgba(231,76,60,.3);
    }
    .form-text{
        display:block;
        margin-top:.5rem;
        color:#999;
        font-size:13px;
        text-align:center;
    }
</style>
<jsp:include page="/WEB-INF/view/layout/public/header.jsp"/>
<jsp:include page="/WEB-INF/view/layout/public/navbar.jsp"/>

<main class="auth-wrap">
    <% String email = (String) request.getAttribute("pendingEmail"); %>
    <form class="auth-card" method="post" action="${pageContext.request.contextPath}/auth/verify">
        <h1>Xác nhận email</h1>
        <p>Mã OTP gồm <strong>6 số</strong> đã được gửi đến email <strong><%= email %></strong> của bạn.</p>

        <div class="form-group">
            <label for="code">Mã OTP (6 số)</label>
            <input type="text" id="code" name="code" maxlength="6" 
                   class="form-control otp-input" 
                   placeholder="123456"
                   pattern="[0-9]{6}"
                   inputmode="numeric"
                   autocomplete="off"
                   required>
            <small class="form-text">Nhập chính xác 6 chữ số nhận được trong email</small>
        </div>

        <% String error = (String) request.getAttribute("error"); %>
        <% if (error != null) {%>
        <div class="alert alert-danger"><%= error%></div>
        <% }%>

        <button type="submit" class="btn btn-primary w-100">Xác nhận</button>
        
        <p style="text-align:center;margin-top:1.5rem;color:#999;">
            Không nhận được mã? <a href="${pageContext.request.contextPath}/auth/register" style="color:var(--gold);font-weight:600;">Đăng ký lại</a>
        </p>
    </form>
</main>

<jsp:include page="/WEB-INF/view/layout/public/footer.jsp"/>
<jsp:include page="/WEB-INF/view/layout/public/scripts.jsp"/>

<script>
    // OTP input: only numbers
    const otpInput = document.getElementById('code');
    if (otpInput) {
        // Remove non-numeric characters
        otpInput.addEventListener('input', function(e) {
            this.value = this.value.replace(/[^0-9]/g, '');
        });
        
        // Prevent paste of non-numeric
        otpInput.addEventListener('paste', function(e) {
            e.preventDefault();
            const pastedText = (e.clipboardData || window.clipboardData).getData('text');
            const numericOnly = pastedText.replace(/[^0-9]/g, '').substring(0, 6);
            this.value = numericOnly;
        });
        
        // Auto-focus
        otpInput.focus();
        
        // Auto-submit when 6 digits entered (optional)
        otpInput.addEventListener('input', function(e) {
            if (this.value.length === 6) {
                // Optionally auto-submit
                // this.form.submit();
            }
        });
    }
</script>

