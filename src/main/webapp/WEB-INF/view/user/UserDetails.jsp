<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%
    String ctx = request.getContextPath();
    String mode = request.getParameter("mode");
    boolean isEditMode = "edit".equals(mode);
%>

<%
    String cPath = request.getContextPath();
    request.setAttribute("pageTitle", "Chi tiết người dùng - Yen Coffee");
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
                            <i class="fas fa-user me-2"></i><%= isEditMode ? "Chỉnh sửa" : "Chi tiết" %> người dùng
                        </h1>
                        <p class="text-muted mb-0">Quản lý thông tin chi tiết, vai trò và trạng thái người dùng</p>
                    </div>
                    <div class="d-flex gap-2">
                        <a href="${pageContext.request.contextPath}/user-list" class="btn btn-outline-secondary">
                            <i class="fas fa-arrow-left"></i> Quay lại danh sách
                        </a>
                        <button class="btn btn-primary" onclick="toggleEditMode()" id="editModeBtn">
                            <i class="fas fa-edit"></i> <span id="editButtonText"><%= isEditMode ? "Lưu thay đổi" : "Chỉnh sửa người dùng" %></span>
                        </button>
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
                                <c:choose>
                                    <c:when test="${user == null}">
                                        <div class="alert alert-warning">
                                            <i class="fas fa-exclamation-triangle me-2"></i>
                                            Không tìm thấy thông tin người dùng. Vui lòng quay lại <a href="${pageContext.request.contextPath}/user-list">danh sách người dùng</a>.
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                <div class="row">
                                    <!-- LEFT: AVATAR -->
                                    <div class="col-md-4 text-center mb-3">
                                        <div class="user-avatar-container mb-3">
                                            <div class="user-icon d-inline-flex align-items-center justify-content-center" 
                                                 style="width: 150px; height: 150px; background: linear-gradient(135deg, #4e73df 0%, #224abe 100%); border-radius: 50%; color: white; font-size: 4rem;">
                                                <i class="fas fa-user"></i>
                                            </div>
                                        </div>
                                        <div class="text-center">
                                            <h5 class="fw-bold">${user.fullName != null ? user.fullName : 'Chưa có tên'}</h5>
                                            <span class="badge bg-primary fs-6">${user.role != null ? user.role : 'N/A'}</span>
                                        </div>
                                    </div>

                                    <!-- RIGHT: FIELDS -->
                                    <div class="col-md-8">
                                        <div class="row">
                                            <!-- LEFT COLUMN -->
                                            <div class="col-md-6">
                                                <!-- ID -->
                                                <div class="info-label">ID Người dùng</div>
                                                <div class="info-value"><strong>#${user.userId != null ? user.userId : 'N/A'}</strong></div>

                                                <!-- NAME -->
                                                <div class="info-label">Họ và tên</div>
                                                <div class="info-value">
                                                    <span>${user.fullName != null ? user.fullName : 'Chưa có tên'}</span>
                                                </div>

                                                <!-- EMAIL -->
                                                <div class="info-label">Email</div>
                                                <div class="info-value">
                                                    <span>${user.email != null ? user.email : 'Chưa có email'}</span>
                                                </div>

                                                <!-- STATUS -->
                                                <div class="info-label status-indent">Trạng thái</div>
                                                <div class="info-value status-indent">
                                                    <span id="userStatusDisplay">
                                                        <c:choose>
                                                            <c:when test="${user.status == 'Active' || user.status == 'ACTIVE' || user.status == 'Activate'}">
                                                                <span class="badge bg-success">
                                                                    <i class="fas fa-check-circle"></i> HOẠT ĐỘNG
                                                                </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-secondary">
                                                                    <i class="fas fa-pause-circle"></i> TẠM DỪNG
                                                                </span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                    <div id="userStatusEdit" class="d-flex status-radio-container-edit"
                                                         style="display: none; gap: 2rem;">
                                                        <div class="form-check status-radio-item">
                                                            <input class="form-check-input" type="radio" name="status"
                                                                   id="editStatusActive" value="Active"
                                                                   ${user.status == 'Active' || user.status == 'ACTIVE' || user.status == 'Activate' ? 'checked' : ''}>
                                                            <label class="form-check-label" for="editStatusActive">
                                                                <i class="fas fa-check-circle text-success"></i>Hoạt động
                                                            </label>
                                                        </div>
                                                        <div class="form-check status-radio-item">
                                                            <input class="form-check-input" type="radio" name="status"
                                                                   id="editStatusInactive" value="Inactive"
                                                                   ${user.status == 'Inactive' || user.status == 'INACTIVE' || user.status == 'Deactivate' ? 'checked' : ''}>
                                                            <label class="form-check-label" for="editStatusInactive">
                                                                <i class="fas fa-pause-circle text-secondary"></i>Không hoạt động
                                                            </label>
                                                    </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- RIGHT COLUMN -->
                                            <div class="col-md-6">
                                                <!-- ROLE -->
                                                <div class="info-label">Vai trò</div>
                                                <div class="info-value">
                                                    <span id="userRoleDisplay">
                                                        <c:choose>
                                                            <c:when test="${user.role == 'ADMIN'}">
                                                                <span class="badge bg-danger">Admin</span>
                                                            </c:when>
                                                            <c:when test="${user.role == 'HR'}">
                                                                <span class="badge bg-success">HR</span>
                                                            </c:when>
                                                            <c:when test="${user.role == 'MARKETER'}">
                                                                <span class="badge bg-warning">Marketer</span>
                                                            </c:when>
                                                            <c:when test="${user.role == 'CASHIER'}">
                                                                <span class="badge bg-info">Cashier</span>
                                                            </c:when>
                                                            <c:when test="${user.role == 'STAFF'}">
                                                                <span class="badge bg-primary">Staff</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-secondary">Customer</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                    <select id="userRoleEdit" class="form-select" style="display: none;">
                                                            <option value="ADMIN" ${user.role == 'ADMIN' ? 'selected' : ''}>Admin</option>
                                                            <option value="HR" ${user.role == 'HR' ? 'selected' : ''}>HR</option>
                                                            <option value="MARKETER" ${user.role == 'MARKETER' ? 'selected' : ''}>Marketer</option>
                                                            <option value="CASHIER" ${user.role == 'CASHIER' ? 'selected' : ''}>Cashier</option>
                                                            <option value="STAFF" ${user.role == 'STAFF' ? 'selected' : ''}>Staff</option>
                                                            <option value="CUSTOMER" ${user.role == 'CUSTOMER' ? 'selected' : ''}>Customer</option>
                                                        </select>
                                                </div>

                                                <!-- PHONE -->
                                                <div class="info-label">Số điện thoại</div>
                                                <div class="info-value">
                                                    <span>Không có</span>
                                                </div>

                                                <!-- NOTE -->
                                                <div class="info-label">Ghi chú</div>
                                                <div class="info-value">
                                                    <span id="userNoteDisplay">${user.note != null && not empty user.note ? user.note : 'Không có ghi chú'}</span>
                                                    <textarea id="userNoteEdit" class="form-control" rows="3" style="display: none;" disabled>${user.note != null ? user.note : ''}</textarea>
                                                </div>
                                            </div>
                                        </div>
                                    </div> <!-- /col-md-8 -->
                                </div> <!-- /row -->

                                    <!-- Edit Info Alert -->
                                    <div class="alert alert-info mt-4 mb-0">
                                        <i class="fas fa-info-circle me-2"></i>
                                        <strong>Lưu ý:</strong> Chỉ có thể thay đổi được <strong>Vai trò</strong>, <strong>Trạng thái</strong> và <strong>Ghi chú</strong>. 
                                        Các thông tin khác như Họ và tên, Email không thể chỉnh sửa.
                                    </div>
                                    </c:otherwise>
                                </c:choose>
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

<!-- Hidden form for user update -->
<c:if test="${user != null}">
<form id="userUpdateForm" action="${pageContext.request.contextPath}/user-detail" method="post" style="display: none;">
    <input type="hidden" name="action" value="update">
    <input type="hidden" name="userId" value="${user.userId}">
    <input type="hidden" name="role" id="formRole">
    <input type="hidden" name="status" id="formStatus">
    <input type="hidden" name="note" id="formNote">
</form>
</c:if>

<jsp:include page="/WEB-INF/view/layout/management/scripts.jsp"/>

<script>
    let isEditMode = <%= isEditMode %>;

    function toggleEditMode() {
        <c:if test="${user == null}">
        showNotification('Không có thông tin người dùng để chỉnh sửa!', 'warning', 'Cảnh báo');
        return;
        </c:if>
        isEditMode = !isEditMode;
        const editButton = document.getElementById('editButtonText');
        const editModeBtn = document.getElementById('editModeBtn');

        if (isEditMode) {
            // Switch to edit mode
            editButton.innerHTML = '<i class="fas fa-save"></i> Lưu thay đổi';
            editModeBtn.classList.remove('btn-primary');
            editModeBtn.classList.add('btn-success');

            // Only show edit elements for role, status, and note
            document.getElementById('userRoleDisplay').style.display = 'none';
            document.getElementById('userRoleEdit').style.display = 'block';

            document.getElementById('userStatusDisplay').style.display = 'none';
            document.getElementById('userStatusEdit').style.display = 'flex';

            document.getElementById('userNoteDisplay').style.display = 'none';
            document.getElementById('userNoteEdit').style.display = 'block';
            document.getElementById('userNoteEdit').disabled = false;
        } else {
            // Save changes
            saveUserChanges();
        }
    }

    function saveUserChanges() {
        // Validate required fields (only role and status)
        const role = document.getElementById('userRoleEdit').value;
        const statusRadios = document.querySelectorAll('input[name="status"]:checked');
        
        if (!role) {
            showNotification('Vui lòng chọn vai trò!', 'warning', 'Cảnh báo');
            document.getElementById('userRoleEdit').focus();
            return;
        }

        if (statusRadios.length === 0) {
            showNotification('Vui lòng chọn trạng thái!', 'warning', 'Cảnh báo');
            return;
        }

        // Collect form data - only role, status, and note
        document.getElementById('formRole').value = role;
        document.getElementById('formStatus').value = statusRadios[0].value;
        document.getElementById('formNote').value = document.getElementById('userNoteEdit').value.trim();

        // Submit
        document.getElementById('userUpdateForm').submit();
    }

    // Initialize edit mode if URL has mode=edit
    if (<%= isEditMode %>) {
        toggleEditMode();
    }
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
</style>
    </body>
</html>
