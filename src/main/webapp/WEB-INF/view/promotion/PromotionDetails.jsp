<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
    String cPath = request.getContextPath();
    request.setAttribute("pageTitle", "Chi tiết khuyến mãi - Yen Coffee");
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
                            <i class="fas fa-tags me-2"></i>Chi tiết khuyến mãi
                        </h1>
                        <p class="text-muted mb-0">Quản lý thông tin chi tiết, giá trị và trạng thái khuyến mãi</p>
                    </div>
                    <div class="d-flex gap-2">
                        <a href="${pageContext.request.contextPath}/promotion-list" class="btn btn-outline-secondary">
                            <i class="fas fa-arrow-left"></i> Quay lại danh sách
                        </a>
                        <button class="btn btn-primary" onclick="toggleEditMode()">
                            <i class="fas fa-edit"></i> <span id="editButtonText">Chỉnh sửa khuyến mãi</span>
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
                                 style="background:linear-gradient(135deg,#4e73df 0%,#224abe 100%);color:#fff;">
                                <span><i class="fas fa-info-circle me-1"></i> Thông tin khuyến mãi</span>
                            </div>

                            <div class="card-body">
                                <div class="row">
                                    <!-- ICON -->
                                    <div class="col-lg-3 text-center mb-3">
                                        <div class="promotion-icon">
                                            <i class="fas fa-tags fa-5x text-primary"></i>
                                        </div>
                                    </div>

                                    <!-- FIELDS -->
                                    <div class="col-lg-9">
                                        <div class="row">
                                            <!-- LEFT COLUMN -->
                                            <div class="col-md-6">
                                                <!-- ID -->
                                                <div class="info-label">ID Khuyến mãi</div>
                                                <div class="info-value"><strong>#${promotion.promotionId}</strong></div>

                                                <!-- NAME -->
                                                <div class="info-label">Tên khuyến mãi</div>
                                                <div class="info-value">
                                                    <span id="promotionNameDisplay">${promotion.name}</span>
                                                    <input type="text" id="promotionNameEdit" class="form-control" value="${promotion.name}" style="display:none;">
                                                </div>

                                                <!-- CODE -->
                                                <div class="info-label">Mã code</div>
                                                <div class="info-value">
                                                    <span id="promotionCodeDisplay" class="badge bg-info fs-6">${promotion.code}</span>
                                                    <input type="text" id="promotionCodeEdit" class="form-control" value="${promotion.code}" style="display:none;">
                                                </div>

                                                <!-- TYPE -->
                                                <div class="info-label">Loại khuyến mãi</div>
                                                <div class="info-value">
                                                    <span id="promotionTypeDisplay">
                                                        <c:choose>
                                                            <c:when test="${promotion.type == 'percentage'}"><span class="badge bg-success">Phần trăm (%)</span></c:when>
                                                            <c:when test="${promotion.type == 'fixed_amount'}"><span class="badge bg-primary">Số tiền cố định (₫)</span></c:when>
                                                            <c:when test="${promotion.type == 'free_shipping'}"><span class="badge bg-warning text-dark">Miễn phí vận chuyển</span></c:when>
                                                            <c:otherwise><span class="badge bg-secondary">${promotion.type}</span></c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                    <select id="promotionTypeEdit" class="form-select" style="display:none;">
                                                        <option value="percentage" ${promotion.type == 'percentage' ? 'selected' : ''}>Phần trăm (%)</option>
                                                        <option value="fixed_amount" ${promotion.type == 'fixed_amount' ? 'selected' : ''}>Số tiền cố định (₫)</option>
                                                        <option value="free_shipping" ${promotion.type == 'free_shipping' ? 'selected' : ''}>Miễn phí vận chuyển</option>
                                                    </select>
                                                </div>

                                                <!-- VALUE -->
                                                <div class="info-label">Giá trị</div>
                                                <div class="info-value">
                                                    <span id="promotionValueDisplay" class="text-success fw-bold fs-4">
                                                        <c:choose>
                                                            <c:when test="${promotion.type == 'percentage'}">
                                                                <fmt:formatNumber value="${promotion.value}" type="number" maxFractionDigits="0"/>%
                                                            </c:when>
                                                            <c:when test="${promotion.type == 'fixed_amount'}">
                                                                <fmt:formatNumber value="${promotion.value}" type="currency" currencyCode="VND"/>
                                                            </c:when>
                                                            <c:otherwise>Miễn phí</c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                    <input type="number" id="promotionValueEdit" class="form-control" value="${promotion.value}" min="0" step="0.01" style="display:none;">
                                                </div>
                                            </div>

                                            <!-- RIGHT COLUMN -->
                                            <div class="col-md-6">
                                                <!-- Spacer để căn đầu cột phải ngang với block ID bên trái -->
                                                <div class="align-spacer d-none d-md-block"></div>

                                                <!-- APPLY TO ALL -->
                                                <div class="info-label">Áp dụng cho tất cả sản phẩm</div>
                                                <div class="info-value">
                                                    <span id="promotionApplyToAllDisplay">
                                                        <c:choose>
                                                            <c:when test="${promotion.applyToAll}">
                                                                <span class="badge bg-success"><i class="fas fa-globe me-1"></i>Tất cả sản phẩm</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-info"><i class="fas fa-list-check me-1"></i>Chọn sản phẩm cụ thể</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                    <div id="promotionApplyToAllEdit" style="display:none;">
                                                        <c:set var="currentScope" value="${promotion.applyToAll ? 'all' : 'selected'}"/>
                                                        <div class="form-check mb-2">
                                                            <input class="form-check-input" type="radio" name="productScopeEdit" id="productScopeAllEdit" value="all"
                                                                   ${currentScope == 'all' ? 'checked' : ''}>
                                                            <label class="form-check-label" for="productScopeAllEdit">
                                                                <i class="fas fa-globe text-info me-1"></i>Tất cả sản phẩm
                                                            </label>
                                                        </div>
                                                        <div class="form-check mb-2">
                                                            <input class="form-check-input" type="radio" name="productScopeEdit" id="productScopeSelectedEdit" value="selected"
                                                                   ${currentScope == 'selected' ? 'checked' : ''}>
                                                            <label class="form-check-label" for="productScopeSelectedEdit">
                                                                <i class="fas fa-list-check text-primary me-1"></i>Chọn sản phẩm cụ thể
                                                            </label>
                                                        </div>
                                                        <div id="productSelectionContainerEdit" class="product-selection-container-edit"
                                                             <c:if test="${currentScope != 'selected'}">style="display:none;"</c:if>>
                                                            <button type="button" class="btn btn-outline-primary btn-sm" data-bs-toggle="modal" data-bs-target="#productSelectionModalEdit">
                                                                <i class="fas fa-plus me-1"></i>Chọn sản phẩm
                                                            </button>
                                                            <div id="selectedProductsDisplayEdit" class="mt-2">
                                                                <c:choose>
                                                                    <c:when test="${selectedProductIds != null && !empty selectedProductIds}">
                                                                        <c:set var="selectedCount" value="0"/>
                                                                        <c:forEach var="id" items="${selectedProductIds}">
                                                                            <c:set var="selectedCount" value="${selectedCount + 1}"/>
                                                                        </c:forEach>
                                                                        <small class="text-success">Đã chọn ${selectedCount} sản phẩm</small>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <small class="text-muted">Chưa chọn sản phẩm nào</small>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- MIN ORDER -->
                                                <div class="info-label">Đơn hàng tối thiểu</div>
                                                <div class="info-value">
                                                    <span id="promotionMinOrderDisplay">
                                                        <fmt:formatNumber value="${promotion.minOrderValue}" type="currency" currencyCode="VND"/>
                                                    </span>
                                                    <input type="number" id="promotionMinOrderEdit" class="form-control" value="${promotion.minOrderValue}" min="0" step="1000" style="display:none;">
                                                </div>

                                                <!-- STATUS -->
                                                <div class="info-label">Trạng thái</div>
                                                <div class="info-value">
                                                    <span id="promotionStatusDisplay">
                                                        <c:choose>
                                                            <c:when test="${promotion.status == 'Activate'}"><span class="badge bg-success"><i class="fas fa-check-circle"></i> HOẠT ĐỘNG</span></c:when>
                                                            <c:when test="${promotion.status == 'Deactivate'}"><span class="badge bg-secondary"><i class="fas fa-pause-circle"></i> TẠM DỪNG</span></c:when>
                                                            <c:when test="${promotion.status == 'Expired'}"><span class="badge bg-danger"><i class="fas fa-times-circle"></i> HẾT HẠN</span></c:when>
                                                            <c:when test="${promotion.status == 'Upcoming'}"><span class="badge bg-warning text-dark"><i class="fas fa-clock"></i> SẮP DIỄN RA</span></c:when>
                                                            <c:otherwise><span class="badge bg-secondary"><i class="fas fa-question-circle"></i> ${promotion.status}</span></c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                    <div id="promotionStatusEdit" class="d-flex status-radio-container-edit" style="display:none;gap:2rem;">
                                                        <div class="form-check status-radio-item">
                                                            <input class="form-check-input" type="radio" name="status" id="editStatusActivate" value="Activate" ${promotion.status == 'Activate' ? 'checked' : ''}>
                                                            <label class="form-check-label" for="editStatusActivate"><i class="fas fa-check-circle text-success"></i>Hoạt động</label>
                                                        </div>
                                                        <div class="form-check status-radio-item">
                                                            <input class="form-check-input" type="radio" name="status" id="editStatusDeactivate" value="Deactivate" ${promotion.status == 'Deactivate' ? 'checked' : ''}>
                                                            <label class="form-check-label" for="editStatusDeactivate"><i class="fas fa-pause-circle text-secondary"></i>Tạm dừng</label>
                                                        </div>
                                                        <div class="form-check status-radio-item">
                                                            <input class="form-check-input" type="radio" name="status" id="editStatusUpcoming" value="Upcoming" ${promotion.status == 'Upcoming' ? 'checked' : ''}>
                                                            <label class="form-check-label" for="editStatusUpcoming"><i class="fas fa-clock text-warning"></i>Sắp diễn ra</label>
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- START DATE -->
                                                <div class="info-label">Ngày bắt đầu</div>
                                                <div class="info-value">
                                                    <span id="promotionStartDateDisplay">
                                                        <fmt:formatDate value="${promotion.startDate}" pattern="dd/MM/yyyy HH:mm"/>
                                                    </span>
                                                    <fmt:formatDate value="${promotion.startDate}" pattern="yyyy-MM-dd" var="startDateStr"/>
                                                <input type="date" id="promotionStartDateEdit" class="form-control" value="${startDateStr}" style="display:none;">
                                                </div>

                                                <!-- END DATE -->
                                                <div class="info-label">Ngày kết thúc</div>
                                                <div class="info-value">
                                                    <span id="promotionEndDateDisplay">
                                                        <fmt:formatDate value="${promotion.endDate}" pattern="dd/MM/yyyy HH:mm"/>
                                                    </span>
                                                    <fmt:formatDate value="${promotion.endDate}" pattern="yyyy-MM-dd" var="endDateStr"/>
                                                    <input type="date" id="promotionEndDateEdit" class="form-control" value="${endDateStr}" style="display:none;">
                                                </div>
                                            </div>
                                        </div>

                                        <!-- DESCRIPTION -->
                                        <div class="row mt-3">
                                            <div class="col-12">
                                                <div class="info-label">Mô tả</div>
                                                <div class="info-value">
                                                    <span id="promotionDescriptionDisplay">${promotion.description != null ? promotion.description : 'Không có mô tả'}</span>
                                                    <textarea id="promotionDescriptionEdit" class="form-control" rows="3" style="display:none;">${promotion.description}</textarea>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- NOTE (ngay dưới mô tả) -->
                                        <div class="row">
                                            <div class="col-12">
                                                <div class="info-label">Ghi chú</div>
                                                <div class="info-value">
                                                    <span id="promotionNoteDisplay">${promotion.note != null ? promotion.note : 'Không có ghi chú'}</span>
                                                    <textarea id="promotionNoteEdit" class="form-control" rows="2" style="display:none;">${promotion.note}</textarea>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- (Giữ mục Số lần sử dụng nếu bạn cần, có thể ẩn) -->
                                        <div class="row d-none">
                                            <div class="col-12">
                                                <div class="info-label">Số lần sử dụng</div>
                                                <div class="info-value">
                                                    <span id="promotionMaxUsesDisplay">
                                                        ${promotion.usesCount != null ? promotion.usesCount : 0} / ${promotion.maxUses != null ? promotion.maxUses : '∞'}
                                                    </span>
                                                    <input type="number" id="promotionMaxUsesEdit" class="form-control" value="${promotion.maxUses}" min="0" style="display:none;">
                                                </div>
                                            </div>
                                        </div>

                                    </div> <!-- /col-lg-9 -->
                                </div> <!-- /row -->
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

<!-- Modal: Edit Promotion Details -->
<div class="modal fade" id="editDetailsModal" tabindex="-1" aria-labelledby="editDetailsModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="editDetailsModalLabel"><i class="fas fa-pen"></i> Cập nhật thông tin khuyến mãi</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="${pageContext.request.contextPath}/promotion/update-details" method="post">
                <input type="hidden" name="promotionId" value="${promotion.promotionId}">
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="promotionName" class="form-label">Tên khuyến mãi <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="promotionName" name="name" value="${promotion.name}" required>
                    </div>
                    <div class="mb-3">
                        <label for="promotionCode" class="form-label">Mã khuyến mãi <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="promotionCode" name="code" value="${promotion.code}" required>
                    </div>
                    <div class="mb-3">
                        <label for="description" class="form-label">Mô tả</label>
                        <textarea class="form-control" id="description" name="description" rows="4">${promotion.description}</textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Lưu thay đổi</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Modal: Edit Promotion Value -->
<div class="modal fade" id="editValueModal" tabindex="-1" aria-labelledby="editValueModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="editValueModalLabel"><i class="fas fa-dollar-sign"></i> Cập nhật giá trị khuyến mãi</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="${pageContext.request.contextPath}/promotion/update-value" method="post">
                <input type="hidden" name="promotionId" value="${promotion.promotionId}">
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="currentValue" class="form-label">Giá trị hiện tại</label>
                        <c:choose>
                            <c:when test="${promotion.type == 'percentage'}">
                                <fmt:formatNumber value="${promotion.value}" type="number" maxFractionDigits="0" var="formattedValue" />
                                <c:set var="currentValueText" value="${formattedValue}%"/>
                            </c:when>
                            <c:when test="${promotion.type == 'fixed_amount'}">
                                <fmt:formatNumber value="${promotion.value}" type="currency" currencyCode="VND" var="formattedValue"/>
                                <c:set var="currentValueText" value="${formattedValue}"/>
                            </c:when>
                            <c:otherwise>
                                <c:set var="currentValueText" value="Miễn phí"/>
                            </c:otherwise>
                        </c:choose>
                        <input type="text" class="form-control" id="currentValue" value="${currentValueText}" readonly>
                    </div>
                    <div class="mb-3">
                        <label for="newValue" class="form-label">Giá trị mới <span class="text-danger">*</span></label>
                        <input type="number" class="form-control" id="newValue" name="value" value="${promotion.value}" min="0" step="0.01" required>
                        <small class="form-text text-muted">
                            <c:choose>
                                <c:when test="${promotion.type == 'percentage'}">Nhập phần trăm (0-100)</c:when>
                                <c:when test="${promotion.type == 'fixed_amount'}">Nhập số tiền theo VND</c:when>
                                <c:otherwise>Khuyến mãi miễn phí vận chuyển</c:otherwise>
                            </c:choose>
                        </small>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-success"><i class="fas fa-check"></i> Cập nhật giá trị</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Modal: Edit Promotion Dates -->
<div class="modal fade" id="editDatesModal" tabindex="-1" aria-labelledby="editDatesModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="editDatesModalLabel"><i class="fas fa-calendar"></i> Cập nhật ngày khuyến mãi</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="${pageContext.request.contextPath}/promotion/update-dates" method="post">
                <input type="hidden" name="promotionId" value="${promotion.promotionId}">
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="startDate" class="form-label">Ngày bắt đầu <span class="text-danger">*</span></label>
                        <fmt:formatDate value="${promotion.startDate}" pattern="yyyy-MM-dd" var="startDateStr" />
                        <input type="date" class="form-control" id="startDate" name="startDate" value="${startDateStr}" required>
                    </div>
                    <div class="mb-3">
                        <label for="endDate" class="form-label">Ngày kết thúc <span class="text-danger">*</span></label>
                        <fmt:formatDate value="${promotion.endDate}" pattern="yyyy-MM-dd" var="endDateStr" />
                        <input type="date" class="form-control" id="endDate" name="endDate" value="${endDateStr}" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Cập nhật ngày</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Hidden form for promotion update -->
<form id="promotionUpdateForm" action="${pageContext.request.contextPath}/promotion-edit" method="post" style="display:none;">
    <input type="hidden" name="promotionId" value="${promotion.promotionId}">
    <input type="hidden" name="name" id="formName">
    <input type="hidden" name="code" id="formCode">
    <input type="hidden" name="type" id="formType">
    <input type="hidden" name="value" id="formValue">
    <input type="hidden" name="minOrderValue" id="formMinOrderValue">
    <input type="hidden" name="status" id="formStatus">
    <input type="hidden" name="startDate" id="formStartDate">
    <input type="hidden" name="endDate" id="formEndDate">
    <input type="hidden" name="description" id="formDescription">
    <input type="hidden" name="note" id="formNote">
    <input type="hidden" name="productScope" id="formProductScope">
    <input type="hidden" name="selectedProductIds" id="formSelectedProductIds">
    <input type="hidden" name="maxUses" id="formMaxUses">
</form>

<jsp:include page="/WEB-INF/view/layout/management/scripts.jsp"/>

<script>
    let isEditMode = false;

    // Toggle Edit Mode
    function toggleEditMode() {
        isEditMode = !isEditMode;
        const editButton = document.getElementById('editButtonText');

        if (isEditMode) {
            editButton.textContent = 'Lưu thay đổi';

            document.getElementById('promotionNameDisplay').style.display = 'none';
            document.getElementById('promotionNameEdit').style.display = 'block';

            document.getElementById('promotionCodeDisplay').style.display = 'none';
            document.getElementById('promotionCodeEdit').style.display = 'block';

            document.getElementById('promotionTypeDisplay').style.display = 'none';
            document.getElementById('promotionTypeEdit').style.display = 'block';

            document.getElementById('promotionValueDisplay').style.display = 'none';
            document.getElementById('promotionValueEdit').style.display = 'block';

            document.getElementById('promotionStatusDisplay').style.display = 'none';
            document.getElementById('promotionStatusEdit').style.display = 'flex';

            document.getElementById('promotionStartDateDisplay').style.display = 'none';
            document.getElementById('promotionStartDateEdit').style.display = 'block';

            document.getElementById('promotionEndDateDisplay').style.display = 'none';
            document.getElementById('promotionEndDateEdit').style.display = 'block';

            document.getElementById('promotionDescriptionDisplay').style.display = 'none';
            document.getElementById('promotionDescriptionEdit').style.display = 'block';

            document.getElementById('promotionNoteDisplay').style.display = 'none';
            document.getElementById('promotionNoteEdit').style.display = 'block';

            document.getElementById('promotionMinOrderDisplay').style.display = 'none';
            document.getElementById('promotionMinOrderEdit').style.display = 'block';

            document.getElementById('promotionApplyToAllDisplay').style.display = 'none';
            document.getElementById('promotionApplyToAllEdit').style.display = 'block';

            document.getElementById('promotionMaxUsesDisplay')?.style && (document.getElementById('promotionMaxUsesDisplay').style.display = 'none');
            document.getElementById('promotionMaxUsesEdit')?.style && (document.getElementById('promotionMaxUsesEdit').style.display = 'block');
        } else {
            savePromotionChanges();
        }
    }

    // Save Promotion Changes
    function savePromotionChanges() {
        document.getElementById('formName').value = document.getElementById('promotionNameEdit').value;
        document.getElementById('formCode').value = document.getElementById('promotionCodeEdit').value;
        document.getElementById('formType').value = document.getElementById('promotionTypeEdit').value;
        document.getElementById('formValue').value = document.getElementById('promotionValueEdit').value;
        document.getElementById('formMinOrderValue').value = document.getElementById('promotionMinOrderEdit').value;

        const statusRadios = document.querySelectorAll('input[name="status"]:checked');
        document.getElementById('formStatus').value = statusRadios.length > 0 ? statusRadios[0].value : 'Activate';

        const productScopeRadios = document.querySelectorAll('input[name="productScopeEdit"]:checked');
        document.getElementById('formProductScope').value = productScopeRadios.length > 0 ? productScopeRadios[0].value : 'all';

        const selectedProductIds = document.getElementById('formSelectedProductIds').value || '';
        document.getElementById('formSelectedProductIds').value = selectedProductIds;

        document.getElementById('formStartDate').value = document.getElementById('promotionStartDateEdit').value;
        document.getElementById('formEndDate').value = document.getElementById('promotionEndDateEdit').value;
        document.getElementById('formDescription').value = document.getElementById('promotionDescriptionEdit').value;
        document.getElementById('formNote').value = document.getElementById('promotionNoteEdit').value;
        const maxUsesEl = document.getElementById('promotionMaxUsesEdit');
        if (maxUsesEl) document.getElementById('formMaxUses').value = maxUsesEl.value;

        document.getElementById('promotionUpdateForm').submit();
    }

    // Handle product scope radio buttons in edit mode
    document.addEventListener('DOMContentLoaded', function() {
        document.querySelectorAll('input[name="productScopeEdit"]').forEach(function(radio) {
            radio.addEventListener('change', function() {
                const container = document.getElementById('productSelectionContainerEdit');
                if (this.value === 'selected') {
                    container.style.display = 'block';
                } else {
                    container.style.display = 'none';
                    document.getElementById('formSelectedProductIds').value = '';
                    updateSelectedProductsDisplayEdit([]);
                }
            });
        });

        // Initialize selected products
        const selectedIds = [
            <c:forEach var="productId" items="${selectedProductIds}" varStatus="loop">
            '${productId}'<c:if test="${!loop.last}">,</c:if>
            </c:forEach>
        ];
        if (selectedIds.length > 0 && selectedIds[0] !== '') {
            updateSelectedProductsDisplayEdit(selectedIds);
            selectedIds.forEach(function(productId) {
                const checkbox = document.getElementById('edit_product_' + productId);
                if (checkbox) checkbox.checked = true;
            });
        }
    });

    // Update selected products display in edit mode
    function updateSelectedProductsDisplayEdit(productIds) {
        const displayDiv = document.getElementById('selectedProductsDisplayEdit');
        const hiddenInput = document.getElementById('formSelectedProductIds');

        if (productIds.length === 0) {
            displayDiv.innerHTML = '<small class="text-muted">Chưa chọn sản phẩm nào</small>';
            hiddenInput.value = '';
        } else {
            const allProducts = [];
            document.querySelectorAll('.product-item-edit').forEach(function(item) {
                const productId = item.getAttribute('data-product-id');
                const productName = item.getAttribute('data-product-name');
                if (productId && productName) allProducts.push({id: productId, name: productName});
            });
            const selectedProducts = allProducts.filter(p => productIds.includes(p.id));
            const productNames = selectedProducts.map(p => p.name).join(', ');
            displayDiv.innerHTML = `<small class="text-success"><strong>Đã chọn ${selectedProducts.length} sản phẩm:</strong> ${productNames}</small>`;
            hiddenInput.value = productIds.join(',');
        }
    }

    // Product search in edit modal
    document.getElementById('productSearchInputEdit')?.addEventListener('input', function(e) {
        const searchTerm = e.target.value.toLowerCase();
        document.querySelectorAll('.product-item-edit').forEach(function(item) {
            const productName = item.getAttribute('data-product-name').toLowerCase();
            item.style.display = productName.includes(searchTerm) ? 'block' : 'none';
        });
    });

    // Save product selection in edit mode
    function saveProductSelectionEdit() {
        const selectedCheckboxes = document.querySelectorAll('#productSelectionModalEdit input[type="checkbox"]:checked');
        const selectedProductIds = Array.from(selectedCheckboxes).map(cb => cb.value);
        updateSelectedProductsDisplayEdit(selectedProductIds);
        const modal = bootstrap.Modal.getInstance(document.getElementById('productSelectionModalEdit'));
        if (modal) modal.hide();
    }
</script>

<!-- Product Selection Modal for Edit -->
<div class="modal fade" id="productSelectionModalEdit" tabindex="-1" aria-labelledby="productSelectionModalEditLabel" aria-hidden="true" data-bs-backdrop="static">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="productSelectionModalEditLabel"><i class="fas fa-list-check me-2"></i>Chọn sản phẩm</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="mb-3">
                    <input type="text" class="form-control" id="productSearchInputEdit" placeholder="Tìm kiếm sản phẩm...">
                </div>
                <div class="border rounded p-2" style="max-height:400px;overflow-y:auto;">
                    <c:choose>
                        <c:when test="${allProducts != null && !empty allProducts}">
                            <c:forEach var="product" items="${allProducts}">
                                <div class="form-check product-item-edit" data-product-id="${product.product_id}" data-product-name="${product.name}">
                                    <input class="form-check-input" type="checkbox" id="edit_product_${product.product_id}"
                                           value="${product.product_id}"
                                           <c:forEach var="selectedId" items="${selectedProductIds}">
                                               <c:if test="${selectedId == product.product_id}">checked</c:if>
                                           </c:forEach>>
                                    <label class="form-check-label" for="edit_product_${product.product_id}">
                                        <strong>${product.name}</strong>
                                        <c:if test="${product.category != null}">
                                            <span class="badge bg-secondary ms-2">${product.category}</span>
                                        </c:if>
                                        <c:if test="${product.price != null}">
                                            <span class="text-muted ms-2">- <fmt:formatNumber value="${product.price}" type="currency" currencyCode="VND"/></span>
                                        </c:if>
                                    </label>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <p class="text-muted">Không có sản phẩm nào</p>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                <button type="button" class="btn btn-primary" onclick="saveProductSelectionEdit()">
                    <i class="fas fa-check me-1"></i>Xác nhận
                </button>
            </div>
        </div>
    </div>
</div>

<style>
/* Nhãn & giá trị nhất quán */
.info-label{
    font-size:.85rem;font-weight:600;color:#5a5c69;margin-top:.75rem;margin-bottom:.25rem;
    text-transform:uppercase;letter-spacing:.5px
}
.info-value{font-size:1rem;color:#2c3e50;margin-bottom:.75rem;min-height:1.5rem}
.card-header{font-weight:600}

/* Căn hàng: bù block "ID Khuyến mãi" bên trái */
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

/* Modal center fallback */
#productSelectionModalEdit .modal-dialog{margin:auto}
</style>
</body>
</html>
