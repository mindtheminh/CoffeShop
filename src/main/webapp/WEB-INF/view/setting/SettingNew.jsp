<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
    String cPath = request.getContextPath();
    request.setAttribute("pageTitle", "Thêm cấu hình mới - Yen Coffee");
%>
<jsp:include page="/WEB-INF/view/layout/management/header.jsp"/>

<div id="wrapper">
  <jsp:include page="/WEB-INF/view/layout/management/sidebar.jsp"/>

  <div id="content-wrapper" class="d-flex flex-column">
    <div id="content">
      <jsp:include page="/WEB-INF/view/layout/management/navbar.jsp"/>

            <div class="container-fluid" style="background-color:#f8f9fc;min-height:100vh;">

                <div class="d-sm-flex align-items-center justify-content-between mb-4">
                    <div>
                        <h1 class="h3 mb-0 text-gray-800">
                            <i class="fas fa-plus me-2"></i>Thêm cấu hình mới
                        </h1>
                        <p class="text-muted mb-0">Nhập thông tin chi tiết để tạo cấu hình hệ thống mới</p>
                    </div>
                    <div class="d-flex gap-2">
                        <a href="${pageContext.request.contextPath}/setting-list" class="btn btn-outline-secondary">
                            <i class="fas fa-arrow-left me-1"></i>Quay lại danh sách
                        </a>
                    </div>
                </div>

                <div class="card shadow mb-4">
                    <div class="card-header py-3 d-flex align-items-center justify-content-between"
                         style="background:linear-gradient(90deg,#2563EB,#1E3A8A);color:#fff;">
                        <span class="fw-semibold text-uppercase"><i class="fas fa-circle-info me-1"></i>Thông tin cấu hình</span>
                        <span class="badge bg-light text-primary text-uppercase">Tạo mới</span>
                    </div>
                    <div class="card-body" style="padding: 2rem 2.5rem;">

                        <!-- Server-side messages -->
                        <c:if test="${not empty successMessage}">
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                <strong>Thêm cấu hình thành công!</strong> ${successMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>
                        <c:if test="${not empty errorMessage}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <strong>Vui lòng kiểm tra lại thông tin bắt buộc.</strong> ${errorMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>

                        <c:set var="form" value="${setting}"/>
                        <c:set var="fieldErrors" value="${fieldErrors}"/>
                        <c:if test="${empty form}">
                            <c:set var="form" value="${null}"></c:set>
                        </c:if>

                        <form method="post" action="${pageContext.request.contextPath}/setting-new" id="settingForm" novalidate>
                            <div class="row g-4">
                                <div class="col-lg-3 text-center d-flex flex-column align-items-center justify-content-start">
                                    <div class="setting-icon mb-3">
                                        <i class="fas fa-gear fa-3x text-primary"></i>
                                    </div>
                                    <div class="info-label">ID cấu hình</div>
                                    <div class="info-value text-muted">(Tự động tạo)</div>
                                </div>

                                <div class="col-lg-9">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="info-label">Tên cấu hình<span class="text-danger"> *</span></div>
                                            <input type="text" class="form-control ${not empty fieldErrors['name'] ? 'is-invalid' : ''}"
                                                   name="name" id="name" maxlength="255" required
                                                   value="${form != null ? form.name : ''}" placeholder="Nhập tên cấu hình (vd: shipping_fee)">
                                            <c:if test="${not empty fieldErrors['name']}">
                                                <small class="text-danger">${fieldErrors['name']}</small>
                                            </c:if>
                                            <div class="invalid-feedback">Vui lòng nhập tên cấu hình.</div>

                                            <div class="info-label mt-3">Giá trị<span class="text-danger"> *</span></div>
                                            <input type="text" class="form-control ${not empty fieldErrors['value'] ? 'is-invalid' : ''}"
                                                   name="value" id="value" required
                                                   value="${form != null ? form.value : ''}" placeholder="Nhập giá trị (vd: 25000, true, 'text')">
                                            <c:if test="${not empty fieldErrors['value']}">
                                                <small class="text-danger">${fieldErrors['value']}</small>
                                            </c:if>
                                            <div class="form-text">Giá trị của cấu hình hệ thống</div>
                                            <div class="invalid-feedback">Vui lòng nhập giá trị.</div>

                                            <div class="info-label mt-3">Kiểu dữ liệu<span class="text-danger"> *</span></div>
                                            <select class="form-select ${not empty fieldErrors['datatype'] ? 'is-invalid' : ''}" name="datatype" id="datatype" required>
                                                <option value="">-- Chọn kiểu dữ liệu --</option>
                                                <option value="String" ${form != null && form.datatype == 'String' ? 'selected' : ''}>String</option>
                                                <option value="Number" ${form != null && form.datatype == 'Number' ? 'selected' : ''}>Number</option>
                                                <option value="Boolean" ${form != null && form.datatype == 'Boolean' ? 'selected' : ''}>Boolean</option>
                                                <option value="Email" ${form != null && form.datatype == 'Email' ? 'selected' : ''}>Email</option>
                                                <option value="Currency" ${form != null && form.datatype == 'Currency' ? 'selected' : ''}>Currency</option>
                                                <option value="Percentage" ${form != null && form.datatype == 'Percentage' ? 'selected' : ''}>Percentage</option>
                                                <option value="Time" ${form != null && form.datatype == 'Time' ? 'selected' : ''}>Time</option>
                                                <option value="Json" ${form != null && form.datatype == 'Json' ? 'selected' : ''}>Json</option>
                                            </select>
                                            <c:if test="${not empty fieldErrors['datatype']}">
                                                <small class="text-danger">${fieldErrors['datatype']}</small>
                                            </c:if>
                                            <div class="invalid-feedback">Vui lòng chọn kiểu dữ liệu.</div>
                                        </div>

                                        <div class="col-md-6">
                                            <div class="info-label">Danh mục<span class="text-danger"> *</span></div>
                                            <select class="form-select ${not empty fieldErrors['category'] ? 'is-invalid' : ''}" name="category" id="category" required>
                                                <option value="">-- Chọn danh mục --</option>
                                                <option value="General" ${form == null || (form != null && form.category == 'General') ? 'selected' : ''}>Chung</option>
                                                <option value="Notification" ${form != null && form.category == 'Notification' ? 'selected' : ''}>Thông báo</option>
                                                <option value="Delivery" ${form != null && form.category == 'Delivery' ? 'selected' : ''}>Giao hàng</option>
                                                <option value="Finance" ${form != null && form.category == 'Finance' ? 'selected' : ''}>Tài chính</option>
                                                <option value="Operation" ${form != null && form.category == 'Operation' ? 'selected' : ''}>Vận hành</option>
                                                <option value="Reservation" ${form != null && form.category == 'Reservation' ? 'selected' : ''}>Đặt chỗ</option>
                                            </select>
                                            <c:if test="${not empty fieldErrors['category']}">
                                                <small class="text-danger">${fieldErrors['category']}</small>
                                            </c:if>
                                            <div class="invalid-feedback">Vui lòng chọn danh mục.</div>

                                            <div class="info-label mt-3">Trạng thái<span class="text-danger"> *</span></div>
                                            <div class="d-flex gap-3 flex-wrap">
                                                <div class="form-check">
                                                    <input class="form-check-input" type="radio" name="status" id="statusActive" value="Active" ${form == null || form.status == 'Active' ? 'checked' : ''} required>
                                                    <label class="form-check-label" for="statusActive"><i class="fas fa-check-circle text-success me-1"></i>Hoạt động</label>
                                                </div>
                                                <div class="form-check">
                                                    <input class="form-check-input" type="radio" name="status" id="statusInactive" value="Inactive" ${form != null && form.status == 'Inactive' ? 'checked' : ''}>
                                                    <label class="form-check-label" for="statusInactive"><i class="fas fa-pause-circle text-secondary me-1"></i>Không hoạt động</label>
                                                </div>
                                            </div>
                                            <c:if test="${not empty fieldErrors['status']}">
                                                <small class="text-danger d-block">${fieldErrors['status']}</small>
                                            </c:if>
                                        </div>
                                    </div>

                                    <div class="row mt-4">
                                        <div class="col-md-6">
                                            <div class="info-label">Mô tả</div>
                                            <textarea class="form-control ${not empty fieldErrors['description'] ? 'is-invalid' : ''}" name="description" id="description" rows="4">${form != null && form.description != null ? form.description : ''}</textarea>
                                            <c:if test="${not empty fieldErrors['description']}">
                                                <small class="text-danger">${fieldErrors['description']}</small>
                                            </c:if>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="info-label">Ghi chú nội bộ</div>
                                            <textarea class="form-control" name="note" id="note" rows="4">${form != null && form.note != null ? form.note : ''}</textarea>
                                        </div>
                                    </div>

                                    <div class="d-flex justify-content-between align-items-center mt-4 pt-3 border-top">
                                        <button type="reset" class="btn btn-secondary"><i class="fas fa-undo me-1"></i>Làm mới</button>
                                        <button type="submit" class="btn btn-primary"><i class="fas fa-save me-1"></i>Lưu cấu hình</button>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    <jsp:include page="/WEB-INF/view/layout/management/footer.jsp"/>
  </div>
</div>

<style>
.setting-icon{
    width:112px;height:112px;border-radius:50%;background:rgba(37,99,235,.12);
    display:flex;align-items:center;justify-content:center;
}
.info-label{
    font-size:.85rem;font-weight:600;color:#5a5c69;margin-bottom:.35rem;text-transform:uppercase;letter-spacing:.5px;
}
.info-value{font-size:1rem;color:#2c3e50;margin-bottom:.5rem;}
.card-header{font-weight:600}
.form-control.is-invalid,.form-select.is-invalid{border-color:#dc3545;}
</style>

<script>
// Bootstrap validation
(() => {
    'use strict';
    const forms = document.querySelectorAll('#settingForm');
    Array.from(forms).forEach(form => {
        form.addEventListener('submit', event => {
            if (!form.checkValidity()) {
                event.preventDefault();
                event.stopPropagation();
            }
            form.classList.add('was-validated');
        }, false);
    });
})();
</script>

<jsp:include page="/WEB-INF/view/layout/management/scripts.jsp"/>
</body>
</html>
