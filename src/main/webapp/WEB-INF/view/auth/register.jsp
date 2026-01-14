<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String error   = (String) request.getAttribute("error");
    String success = (String) request.getAttribute("success");
    if (success == null && "1".equals(request.getParameter("success"))) {
        success = "Tạo tài khoản thành công!";
    }
    String cPath = request.getContextPath();
%>

<jsp:include page="/WEB-INF/view/layout/public/header.jsp"/>
<jsp:include page="/WEB-INF/view/layout/public/navbar.jsp"/>

<!-- ===== REGISTER ===== -->
<main class="auth-wrap">
  <form class="auth-card" method="post" action="<%= cPath %>/auth/register" novalidate>
    <h1>Tạo tài khoản mới</h1>

    <% if (error != null) { %>
      <div class="alert alert-danger mb-3"><%= error %></div>
    <% } %>
    <% if (success != null) { %>
      <div class="alert alert-success mb-3"><%= success %></div>
    <% } %>

    <!-- Full name -->
    <div class="form-group">
      <label for="fullname">Họ và tên *</label>
      <input type="text" id="fullname" name="fullName" class="form-control"
             placeholder="Nguyễn Văn A" required
             value="<%= request.getAttribute("fullName") != null ? request.getAttribute("fullName") : "" %>">
      <div class="err" id="errName">Vui lòng nhập họ tên.</div>
    </div>

    <!-- Email -->
    <div class="form-group">
      <label for="email">Email *</label>
      <input type="email" id="email" name="email" class="form-control"
             placeholder="you@example.com" required
             value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>">
      <div class="err" id="errEmail">Email chưa hợp lệ.</div>
    </div>

    <!-- Password -->
    <div class="form-group pw-wrap">
      <label for="password">Mật khẩu *</label>
      <input type="password" id="password" name="password" class="form-control"
             placeholder="Tối thiểu 6 ký tự" minlength="6" required>
      <button type="button" class="pw-toggle" data-target="password" aria-label="Hiện/ẩn mật khẩu">
        <i class="fa-regular fa-eye"></i>
      </button>
      <div class="err" id="errPw">Mật khẩu tối thiểu 6 ký tự.</div>
    </div>

    <!-- Confirm -->
    <div class="form-group pw-wrap">
      <label for="confirm">Xác nhận mật khẩu *</label>
      <input type="password" id="confirm" name="confirm" class="form-control"
             placeholder="Nhập lại mật khẩu" required>
      <button type="button" class="pw-toggle" data-target="confirm" aria-label="Hiện/ẩn mật khẩu">
        <i class="fa-regular fa-eye"></i>
      </button>
      <div class="err" id="errMatch">Mật khẩu xác nhận không khớp.</div>
    </div>

    <button type="submit" class="btn btn-primary btn-block w-100">Đăng ký</button>

    <div class="sep"><span class="muted">hoặc</span></div>

    <a href="<%= cPath %>/auth/google-login" class="btn-google">
      <img src="https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg" alt="">
      Tiếp tục với Google
    </a>

    <p class="text-center mt-3 muted">
      Tôi đã có tài khoản?
      <a href="<%= cPath %>/auth/login" style="color:var(--gold);font-weight:700">Đăng nhập</a>
    </p>
  </form>
</main>

<jsp:include page="/WEB-INF/view/layout/public/footer.jsp"/>
<jsp:include page="/WEB-INF/view/layout/public/scripts.jsp"/>

<!-- ===== JS Toggle + Validation ===== -->
<script>
  document.querySelectorAll('.pw-toggle').forEach(btn=>{
    btn.addEventListener('click', ()=>{
      const id = btn.getAttribute('data-target');
      const input = document.getElementById(id);
      const show = input.type === 'password';
      input.type = show ? 'text' : 'password';
      btn.innerHTML = show
        ? '<i class="fa-regular fa-eye-slash"></i>'
        : '<i class="fa-regular fa-eye"></i>';
      input.focus();
    });
  });

  // Validation
  const form = document.querySelector('form.auth-card');
  form.addEventListener('submit', e=>{
    const name = document.getElementById('fullname').value.trim();
    const email = document.getElementById('email').value.trim();
    const pw = document.getElementById('password').value;
    const cf = document.getElementById('confirm').value;
    let ok = true;

    ['errName','errEmail','errPw','errMatch'].forEach(id=>document.getElementById(id).style.display='none');

    if(!name){ document.getElementById('errName').style.display='block'; ok=false; }
    const re=/^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if(!re.test(email)){ document.getElementById('errEmail').style.display='block'; ok=false; }
    if(!pw || pw.length<6){ document.getElementById('errPw').style.display='block'; ok=false; }
    if(pw!==cf){ document.getElementById('errMatch').style.display='block'; ok=false; }

    if(!ok){ e.preventDefault(); }
  });
</script>

<!-- ===== Custom CSS ===== -->
<style>
:root{
  --bg-dark:#0f0f10;--bg-darker:#0a0a0b;--gold:#c7a17a;--nav-h:72px;
}
@media (max-width:991.98px){:root{--nav-h:56px}}
body{
  background:#0c0c0d;color:#e9e9e9;
  font-family:"Poppins",system-ui,-apple-system,Segoe UI,Roboto,"Helvetica Neue",Arial,"Noto Sans",sans-serif;
  padding-top:var(--nav-h);
}
.auth-wrap{
  min-height:calc(100vh - var(--nav-h) - 120px);
  display:flex;align-items:center;justify-content:center;
  padding:2rem 1rem;
  background:linear-gradient(180deg,var(--bg-dark),var(--bg-darker));
}
.auth-card{
  width:100%;max-width:560px;
  background:#141415;border:1px solid rgba(255,255,255,.08);
  border-radius:16px;box-shadow:0 14px 40px rgba(0,0,0,.35);
  padding:1.5rem 1.5rem 1.75rem;margin-top:.75rem;
}
.auth-card h1{font-size:28px;font-weight:800;margin:0 0 .75rem}
.form-group label{font-weight:600;margin-bottom:.35rem}
.form-control{
  background:#0f0f10;border:1px solid rgba(255,255,255,.12);
  color:#fff;border-radius:12px;height:48px;padding:.6rem .9rem;
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
.err{color:#ffb3b3;font-size:.9rem;margin-top:.35rem;display:none}
</style>
