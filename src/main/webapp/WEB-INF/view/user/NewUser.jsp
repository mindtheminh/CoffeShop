<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<%
    String cPath = request.getContextPath();
    request.setAttribute("pageTitle", "Tạo người dùng mới - Yen Coffee");
%>
<jsp:include page="/WEB-INF/view/layout/management/header.jsp"/>

<div id="wrapper">
  <jsp:include page="/WEB-INF/view/layout/management/sidebar.jsp"/>

  <div id="content-wrapper" class="d-flex flex-column">
    <div id="content">
      <jsp:include page="/WEB-INF/view/layout/management/navbar.jsp"/>

            <!-- Begin Page Content -->
            <div class="container-fluid" style="background-color: #f8f9fc; min-height: 100vh;">

                <!-- Page Heading -->
                <div class="d-sm-flex align-items-center justify-content-between mb-4">
                    <div>
                        <h1 class="h3 mb-0 text-gray-800">
                            <i class="fas fa-user-plus me-2"></i>Tạo người dùng mới
                        </h1>
                        <p class="text-muted mb-0">Nhập thông tin chi tiết để tạo người dùng mới</p>
                    </div>
                    <div class="d-flex gap-2">
                        <a href="${pageContext.request.contextPath}/user-list" class="btn btn-outline-secondary">
                            <i class="fas fa-arrow-left"></i> Quay lại danh sách
                        </a>
                    </div>
                </div>

                <!-- Success/Error Messages -->
                <c:if test="${not empty sessionScope.success}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle"></i> ${sessionScope.success}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <c:remove var="success" scope="session" />
                </c:if>
                
                <c:if test="${not empty sessionScope.error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-circle"></i> ${sessionScope.error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <c:remove var="error" scope="session" />
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-circle"></i> ${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <div class="row">
                    <!-- User Information -->
                    <div class="col-12">
                        <!-- Main User Information Card -->
                        <div class="card shadow mb-4">
                            <div class="card-header py-3 d-flex justify-content-between align-items-center"
                                 style="background: linear-gradient(135deg, #4e73df 0%, #224abe 100%); color: white;">
                                <span><i class="fas fa-info-circle me-1"></i> Thông tin người dùng</span>
                            </div>
                            <div class="card-body">
                                <form method="post" action="${pageContext.request.contextPath}/user-new" id="userNewForm" novalidate>
                                    <input type="hidden" name="action" value="create">
                                    
                                    <div class="row">
                                        <!-- LEFT: AVATAR -->
                                        <div class="col-md-4 text-center mb-3">
                                            <div class="user-avatar-container mb-3">
                                                <div class="user-icon d-inline-flex align-items-center justify-content-center" 
                                                     style="width: 150px; height: 150px; background: linear-gradient(135deg, #4e73df 0%, #224abe 100%); border-radius: 50%; color: white; font-size: 4rem;">
                                                    <i class="fas fa-user-plus"></i>
                                                </div>
                                            </div>
                                            <div class="text-center">
                                                <h5 class="fw-bold text-muted">Người dùng mới</h5>
                                                <span class="badge bg-secondary fs-6" id="roleBadgePreview">Chưa chọn vai trò</span>
                                            </div>
                                        </div>

                                        <!-- RIGHT: FIELDS -->
                                        <div class="col-md-8">
                                            <div class="row">
                                                <!-- LEFT COLUMN -->
                                                <div class="col-md-6">
                                                    <!-- FULL NAME -->
                                                    <div class="info-label">Họ và tên <span class="text-danger">*</span></div>
                                                    <div class="info-value">
                                                        <input type="text" class="form-control" id="fullName" name="fullName"
                                                               placeholder="Nhập họ và tên đầy đủ..." maxlength="255" required
                                                               value="${user != null ? user.fullName : ''}">
                                                    </div>

                                                    <!-- EMAIL -->
                                                    <div class="info-label">Email <span class="text-danger">*</span></div>
                                                    <div class="info-value">
                                                        <input type="email" class="form-control" id="email" name="email"
                                                               placeholder="user@example.com" maxlength="255" required
                                                               value="${user != null ? user.email : ''}">
                                                    </div>

                                                    <!-- STATUS -->
                                                    <div class="info-label status-indent">Trạng thái <span class="text-danger">*</span></div>
                                                    <div class="info-value status-indent">
                                                        <div class="d-flex status-radio-container-edit" style="gap: 2rem;">
                                                            <div class="form-check status-radio-item">
                                                                <input class="form-check-input" type="radio" name="status"
                                                                       id="statusActive" value="Active" checked required>
                                                                <label class="form-check-label" for="statusActive">
                                                                    <i class="fas fa-check-circle text-success"></i>Hoạt động
                                                                </label>
                                                            </div>
                                                            <div class="form-check status-radio-item">
                                                                <input class="form-check-input" type="radio" name="status"
                                                                       id="statusInactive" value="Inactive">
                                                                <label class="form-check-label" for="statusInactive">
                                                                    <i class="fas fa-pause-circle text-secondary"></i>Không hoạt động
                                                                </label>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- RIGHT COLUMN -->
                                                <div class="col-md-6">
                                                    <!-- ROLE -->
                                                    <div class="info-label">Vai trò <span class="text-danger">*</span></div>
                                                    <div class="info-value">
                                                        <select class="form-select" id="role" name="role" required>
                                                            <option value="">-- Chọn vai trò --</option>
                                                            <option value="ADMIN" ${user != null && user.role == 'ADMIN' ? 'selected' : ''}>Admin</option>
                                                            <option value="HR" ${user != null && user.role == 'HR' ? 'selected' : ''}>HR</option>
                                                            <option value="MARKETER" ${user != null && user.role == 'MARKETER' ? 'selected' : ''}>Marketer</option>
                                                            <option value="CASHIER" ${user != null && user.role == 'CASHIER' ? 'selected' : ''}>Cashier</option>
                                                            <option value="STAFF" ${user != null && user.role == 'STAFF' ? 'selected' : ''}>Staff</option>
                                                            <option value="CUSTOMER" ${user != null && user.role == 'CUSTOMER' ? 'selected' : ''}>Customer</option>
                                                        </select>
                                                    </div>

                                                    <!-- PHONE -->
                                                    <div class="info-label">Số điện thoại</div>
                                                    <div class="info-value">
                                                        <input type="tel" class="form-control" id="phone" name="phone"
                                                               placeholder="0123456789" maxlength="15"
                                                               value="${user != null ? user.phone : ''}">
                                                    </div>

                                                    <!-- NOTE -->
                                                    <div class="info-label">Ghi chú</div>
                                                    <div class="info-value">
                                                        <textarea class="form-control" id="note" name="note" rows="3"
                                                                  placeholder="Nhập ghi chú về tài khoản người dùng (tùy chọn)...">${user != null ? user.note : ''}</textarea>
                                                    </div>
                                                </div>
                                            </div>
                                        </div> <!-- /col-md-8 -->
                                    </div> <!-- /row -->

                                    <!-- Password Info Alert -->
                                    <div class="alert alert-info mt-4 mb-0">
                                        <i class="fas fa-info-circle me-2"></i>
                                        <strong>Thông tin mật khẩu:</strong> Mật khẩu sẽ được tự động tạo ngẫu nhiên khi tạo tài khoản. 
                                        Người dùng cần sử dụng chức năng <strong>"Quên mật khẩu"</strong> để đặt mật khẩu mới khi đăng nhập lần đầu.
                                    </div>

                                    <!-- Action Buttons -->
                                    <div class="d-flex justify-content-end gap-2 mt-4 pt-3 border-top">
                                        <a href="${pageContext.request.contextPath}/user-list" class="btn btn-outline-secondary">
                                            <i class="fas fa-times"></i> Hủy
                                        </a>
                                        <button type="reset" class="btn btn-secondary">
                                            <i class="fas fa-undo"></i> Làm mới
                                        </button>
                                        <button type="submit" class="btn btn-primary">
                                            <i class="fas fa-save"></i> Lưu người dùng
                                        </button>
                                    </div>
                                </form>
                            </div> <!-- /card-body -->
                        </div> <!-- /card -->
                    </div> <!-- /col-12 -->
                </div> <!-- /row -->
            </div>
            <!-- End Page Content -->
                    </div>
        <!-- End of Content -->
    <jsp:include page="/WEB-INF/view/layout/management/footer.jsp"/>
  </div>
</div>

<jsp:include page="/WEB-INF/view/layout/management/scripts.jsp"/>

<script>
document.getElementById('userNewForm').addEventListener('submit', function(e){
    let ok = true;

    const requiredIds = ['fullName','email','role'];
    requiredIds.forEach(id=>{
        const el = document.getElementById(id);
        if(!el.value || !String(el.value).trim()){
            el.classList.add('is-invalid'); ok = false;
        } else el.classList.remove('is-invalid');
    });

    const status = document.querySelector('input[name="status"]:checked');
    if(!status){
        ok = false;
        if(!document.getElementById('statusWarn')){
            const warn = document.createElement('div');
            warn.id = 'statusWarn';
            warn.className = 'text-danger mt-1 small';
            warn.textContent = 'Vui lòng chọn trạng thái.';
            document.querySelector('input[name="status"]').closest('.info-value').appendChild(warn);
        }
    } else {
        const w = document.getElementById('statusWarn');
        if (w) w.remove();
    }

    if(!ok){
        e.preventDefault();
        showNotification('Vui lòng nhập đầy đủ thông tin bắt buộc!', 'warning', 'Cảnh báo');
    }
});

// Realtime validation
document.querySelectorAll('#userNewForm input[required], #userNewForm select[required]').forEach(el=>{
    el.addEventListener('blur', function(){ this.value.trim() ? this.classList.remove('is-invalid') : this.classList.add('is-invalid'); });
    el.addEventListener('input', function(){ if(this.value.trim()) this.classList.remove('is-invalid'); });
});
document.querySelectorAll('input[name="status"]').forEach(r=>{
    r.addEventListener('change', ()=>{ const w=document.getElementById('statusWarn'); if(w) w.remove(); });
});

// Update role badge preview
document.getElementById('role').addEventListener('change', function(){
    const role = this.value;
    const badge = document.getElementById('roleBadgePreview');
    const roleNames = {
        'ADMIN': {text: 'Admin', class: 'bg-danger'},
        'HR': {text: 'HR', class: 'bg-success'},
        'MARKETER': {text: 'Marketer', class: 'bg-warning'},
        'CASHIER': {text: 'Cashier', class: 'bg-info'},
        'STAFF': {text: 'Staff', class: 'bg-primary'},
        'CUSTOMER': {text: 'Customer', class: 'bg-secondary'}
    };
    
    if(role && roleNames[role]){
        badge.textContent = roleNames[role].text;
        badge.className = 'badge ' + roleNames[role].class + ' fs-6';
    } else {
        badge.textContent = 'Chưa chọn vai trò';
        badge.className = 'badge bg-secondary fs-6';
    }
});

// Auto hide alerts
setTimeout(()=>{ document.querySelectorAll('.alert.show').forEach(a=>{ a.classList.remove('show'); setTimeout(()=>a.remove(),300); }); }, 5000);
</script>

<style>
    /* Typography + Spacing for labels/values */
    .info-label {
        font-size: 0.85rem;
        font-weight: 600;
        color: #5a5c69;
        margin-top: .75rem;
        margin-bottom: 0.25rem;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }
    .info-value {
        font-size: 1rem;
        color: #2c3e50;
        margin-bottom: .75rem;
        min-height: 1.5rem;
    }
    .info-value strong {
        color: #1f2937;
    }

    /* Status radio */
    .status-radio-container-edit { flex-wrap: nowrap; align-items: center; }
    .status-radio-container-edit .status-radio-item { margin: 0; padding: 0; white-space: nowrap; flex-shrink: 0; }
    .status-radio-container-edit .status-radio-item .form-check-label {
        margin-left: 0.5rem; cursor: pointer; display: inline-flex; align-items: center; gap: 0.375rem;
    }
    .status-radio-container-edit .status-radio-item .form-check-label i { flex-shrink: 0; }
    .status-radio-container-edit .status-radio-item .form-check-input { margin-top: 0.25rem; cursor: pointer; }

    /* Alignment tweaks */
    .status-indent { padding-left: 1.25rem; }
    @media (min-width: 768px) {
        .status-indent { padding-left: 1.5rem; }
    }

    .align-spacer {
        height: 72px;
    }

    /* Form controls */
    .form-control:focus, .form-select:focus { 
        border-color: #4e73df; 
        box-shadow: 0 0 0 0.2rem rgba(78, 115, 223, 0.25); 
    }
    .btn-primary:hover { 
        transform: translateY(-1px); 
        transition: .2s; 
    }
    .card { 
        transition: box-shadow .15s; 
    }
    .card:hover { 
        box-shadow: 0 .5rem 1rem rgba(0,0,0,.15) !important; 
    }
    .is-invalid { 
        border-color: #e74a3b !important; 
    }
</style>
