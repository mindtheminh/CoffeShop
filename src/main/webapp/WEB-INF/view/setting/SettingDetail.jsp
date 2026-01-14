<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
    String mode = request.getParameter("mode");
    boolean isEditMode = "edit".equals(mode);
    String cPath = request.getContextPath();
    request.setAttribute("pageTitle", "Chi tiết cấu hình - Yen Coffee");
%>
<jsp:include page="/WEB-INF/view/layout/management/header.jsp"/>

<div id="wrapper">
  <jsp:include page="/WEB-INF/view/layout/management/sidebar.jsp"/>

  <div id="content-wrapper" class="d-flex flex-column">
    <div id="content">
      <jsp:include page="/WEB-INF/view/layout/management/navbar.jsp"/>

            <!-- Begin Page Content -->
            <div class="container-fluid" style="background-color:#f8f9fc;min-height:100vh;">

                <!-- Page Heading -->
                <div class="d-sm-flex align-items-center justify-content-between mb-4">
                    <div>
                        <h1 class="h3 mb-0 text-gray-800">
                            <i class="fas fa-cog me-2"></i>Chi tiết cấu hình
                        </h1>
                        <p class="text-muted mb-0">Quản lý thông tin chi tiết, giá trị và trạng thái cấu hình hệ thống</p>
                    </div>
                    <div class="d-flex gap-2">
                        <a href="${pageContext.request.contextPath}/setting-list" class="btn btn-outline-secondary">
                            <i class="fas fa-arrow-left"></i> Quay lại danh sách
                        </a>
                        <button class="btn btn-primary" onclick="toggleEditMode()">
                            <i class="fas fa-edit"></i> <span id="editButtonText">Chỉnh sửa cấu hình</span>
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

                <div class="row">
                    <div class="col-12">
                        <div class="card shadow mb-4">
                            <div class="card-header py-3 d-flex justify-content-between align-items-center"
                                 style="background:linear-gradient(90deg,#2563EB,#1E3A8A);color:#fff;">
                                <span><i class="fas fa-circle-info me-1"></i> Thông tin cấu hình</span>
                            </div>

                            <div class="card-body" style="padding: 2rem 2.5rem;">
                                <c:choose>
                                    <c:when test="${setting == null}">
                                        <div class="alert alert-warning">
                                            <i class="fas fa-exclamation-triangle me-2"></i>
                                            Không tìm thấy thông tin cấu hình. Vui lòng quay lại <a href="${pageContext.request.contextPath}/setting-list">danh sách cấu hình</a>.
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                <div class="row">
                                    <!-- ICON -->
                                    <div class="col-lg-3 text-center mb-3">
                                        <div class="setting-icon">
                                            <i class="fas fa-gear fa-5x text-primary"></i>
                                        </div>
                                    </div>

                                    <!-- FIELDS -->
                                    <div class="col-lg-9">
                                        <div class="row">
                                            <!-- LEFT COLUMN -->
                                            <div class="col-md-6">
                                                <!-- ID -->
                                                <div class="info-label">Mã cấu hình</div>
                                                <div class="info-value"><strong>#${setting.settingId != null ? setting.settingId : 'N/A'}</strong></div>

                                                <!-- NAME -->
                                                <div class="info-label">Tên cấu hình</div>
                                                <div class="info-value">
                                                    <span id="settingNameDisplay">${setting.name != null ? setting.name : 'Chưa có tên'}</span>
                                                </div>

                                                <!-- VALUE -->
                                                <div class="info-label">Giá trị</div>
                                                <div class="info-value">
                                                    <code class="text-dark">${setting.value != null ? setting.value : 'Chưa có giá trị'}</code>
                                                </div>

                                                <!-- DATATYPE -->
                                                <div class="info-label">Kiểu dữ liệu</div>
                                                <div class="info-value">
                                                    <span class="badge bg-info">${setting.datatype != null ? setting.datatype : 'N/A'}</span>
                                                </div>

                                                <!-- STATUS -->
                                                <div class="info-label">Trạng thái</div>
                                                <div class="info-value">
                                                    <span id="settingStatusDisplay">
                                                        <c:choose>
                                                            <c:when test="${setting.status == 'Active' || setting.status == 'ACTIVE'}">
                                                                <span class="badge bg-success">
                                                                    <i class="fas fa-check-circle"></i> Hoạt động
                                                                </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-secondary">
                                                                    <i class="fas fa-pause-circle"></i> Không hoạt động
                                                                </span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                    <div id="settingStatusEdit" class="d-flex status-radio-container-edit" style="display:none;gap:2rem;">
                                                        <div class="form-check status-radio-item">
                                                            <input class="form-check-input" type="radio" name="status" id="editStatusActive" value="Active"
                                                                   ${setting.status == 'Active' || setting.status == 'ACTIVE' ? 'checked' : ''}>
                                                            <label class="form-check-label" for="editStatusActive">
                                                                <i class="fas fa-check-circle text-success"></i>Hoạt động
                                                            </label>
                                                        </div>
                                                        <div class="form-check status-radio-item">
                                                            <input class="form-check-input" type="radio" name="status" id="editStatusInactive" value="Inactive"
                                                                   ${setting.status == 'Inactive' || setting.status == 'INACTIVE' ? 'checked' : ''}>
                                                            <label class="form-check-label" for="editStatusInactive">
                                                                <i class="fas fa-pause-circle text-secondary"></i>Không hoạt động
                                                            </label>
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- CREATED AT -->
                                                <div class="info-label">Ngày tạo</div>
                                                <div class="info-value">
                                                    <small class="text-muted" style="color: #6B7280; font-size: 0.875rem;">${setting.createdAt != null ? setting.createdAt : 'N/A'}</small>
                                                </div>

                                                <!-- UPDATED AT -->
                                                <div class="info-label">Cập nhật gần nhất</div>
                                                <div class="info-value">
                                                    <small class="text-muted" style="color: #6B7280; font-size: 0.875rem;">${setting.updatedAt != null ? setting.updatedAt : 'Chưa cập nhật'}</small>
                                                </div>
                                            </div>

                                            <!-- RIGHT COLUMN -->
                                            <div class="col-md-6">
                                                <!-- CATEGORY - thẳng hàng với Mã cấu hình -->
                                                <div class="info-label">Danh mục</div>
                                                <div class="info-value">
                                                    <span class="badge bg-primary">
                                                        <c:choose>
                                                            <c:when test="${setting.category == 'General'}">Chung</c:when>
                                                            <c:when test="${setting.category == 'Notification'}">Thông báo</c:when>
                                                            <c:when test="${setting.category == 'Delivery'}">Giao hàng</c:when>
                                                            <c:when test="${setting.category == 'Finance'}">Tài chính</c:when>
                                                            <c:when test="${setting.category == 'Operation'}">Vận hành</c:when>
                                                            <c:when test="${setting.category == 'Reservation'}">Đặt chỗ</c:when>
                                                            <c:otherwise>${setting.category != null ? setting.category : 'N/A'}</c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                </div>

                                                <!-- DESCRIPTION - thẳng hàng với Tên cấu hình -->
                                                <div class="info-label">Mô tả</div>
                                                <div class="info-value">
                                                    <span id="settingDescriptionDisplay">${setting.description != null && not empty setting.description ? setting.description : 'Không có mô tả'}</span>
                                                    <textarea id="settingDescriptionEdit" class="form-control" rows="3" style="display:none;">${setting.description != null ? setting.description : ''}</textarea>
                                                </div>

                                                <!-- Empty space để thẳng hàng với Giá trị -->
                                                <div class="info-label" style="visibility: hidden;">Giá trị</div>
                                                <div class="info-value" style="visibility: hidden;">-</div>

                                                <!-- NOTE - thẳng hàng với Kiểu dữ liệu và Trạng thái -->
                                                <div class="info-label">Ghi chú</div>
                                                <div class="info-value">
                                                    <span id="settingNoteDisplay">${setting.note != null && not empty setting.note ? setting.note : 'Không có ghi chú'}</span>
                                                    <textarea id="settingNoteEdit" class="form-control" rows="3" style="display:none;">${setting.note != null ? setting.note : ''}</textarea>
                                                </div>
                                            </div>
                                        </div>
                                    </div> <!-- /col-lg-9 -->
                                </div> <!-- /row -->
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

<!-- Hidden form for setting update -->
<c:if test="${setting != null}">
<form id="settingUpdateForm" action="${pageContext.request.contextPath}/setting-detail" method="post" style="display:none;">
    <input type="hidden" name="action" value="update">
    <input type="hidden" name="settingId" value="${setting.settingId}">
    <input type="hidden" name="status" id="formStatus">
    <input type="hidden" name="note" id="formNote">
    <input type="hidden" name="description" id="formDescription">
</form>
</c:if>

<jsp:include page="/WEB-INF/view/layout/management/scripts.jsp"/>

<script>
    let isEditMode = <%= isEditMode %>;

    function toggleEditMode() {
        <c:if test="${setting == null}">
        showNotification('Không có thông tin cấu hình để chỉnh sửa!', 'warning', 'Cảnh báo');
        return;
        </c:if>
        isEditMode = !isEditMode;
        const editButton = document.getElementById('editButtonText');
        const editModeBtn = document.querySelector('button[onclick="toggleEditMode()"]');

        if (isEditMode) {
            editButton.textContent = 'Lưu thay đổi';
            editModeBtn.classList.remove('btn-primary');
            editModeBtn.classList.add('btn-success');

            document.getElementById('settingStatusDisplay').style.display = 'none';
            document.getElementById('settingStatusEdit').style.display = 'flex';

            document.getElementById('settingNoteDisplay').style.display = 'none';
            document.getElementById('settingNoteEdit').style.display = 'block';
            document.getElementById('settingNoteEdit').disabled = false;

            document.getElementById('settingDescriptionDisplay').style.display = 'none';
            document.getElementById('settingDescriptionEdit').style.display = 'block';
            document.getElementById('settingDescriptionEdit').disabled = false;
        } else {
            saveSettingChanges();
        }
    }

    function saveSettingChanges() {
        const statusRadios = document.querySelectorAll('input[name="status"]:checked');
        
        if (statusRadios.length === 0) {
            showNotification('Vui lòng chọn trạng thái!', 'warning', 'Cảnh báo');
            return;
        }

        document.getElementById('formStatus').value = statusRadios[0].value;
        document.getElementById('formNote').value = document.getElementById('settingNoteEdit').value.trim();
        document.getElementById('formDescription').value = document.getElementById('settingDescriptionEdit').value.trim();
        document.getElementById('settingUpdateForm').submit();
    }

    if (<%= isEditMode %>) {
        toggleEditMode();
    }
</script>

<style>
/* Nhãn & giá trị nhất quán */
.info-label{
    font-size:.85rem;font-weight:600;color:#5a5c69;margin-top:.75rem;margin-bottom:.25rem;
    text-transform:uppercase;letter-spacing:.5px
}
.info-value{font-size:1rem;color:#2c3e50;margin-bottom:.75rem;min-height:1.5rem}
.card-header{font-weight:600}

/* Icon container */
.setting-icon{
    width:112px;height:112px;border-radius:50%;background:rgba(37,99,235,.12);
    display:flex;align-items:center;justify-content:center;
}

/* Căn hàng: bù block "Mã cấu hình" bên trái */
.align-spacer{height:56px}
@media (min-width:768px){ .align-spacer{height:64px} }
@media (min-width:992px){ .align-spacer{height:72px} }

/* Status radios khi edit */
.status-radio-container-edit{flex-wrap:nowrap;align-items:center}
.status-radio-container-edit .status-radio-item{margin:0;padding:0;white-space:nowrap;flex-shrink:0}
.status-radio-container-edit .status-radio-item .form-check-label{
    margin-left:.5rem;cursor:pointer;display:inline-flex;align-items:center;gap:.375rem
}
.status-radio-container-edit .status-radio-item .form-check-input{margin-top:.25rem;cursor:pointer}
</style>
</body>
</html>
