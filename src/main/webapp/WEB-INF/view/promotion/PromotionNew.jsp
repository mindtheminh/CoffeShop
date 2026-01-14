<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
    String cPath = request.getContextPath();
    request.setAttribute("pageTitle", "Thêm khuyến mãi mới - Yen Coffee");
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
                            <i class="fas fa-tags me-2"></i>Thêm khuyến mãi mới
                        </h1>
                        <p class="text-muted mb-0">Nhập thông tin chi tiết để tạo chương trình khuyến mãi mới</p>
                    </div>
                    <div class="d-flex gap-2">
                        <a href="${pageContext.request.contextPath}/promotion-list" class="btn btn-outline-secondary">
                            <i class="fas fa-arrow-left me-1"></i>Quay lại danh sách
                        </a>
                    </div>
                </div>

                <div class="card shadow mb-4">
                    <div class="card-header py-3 d-flex align-items-center justify-content-between"
                         style="background:linear-gradient(135deg,#4e73df 0%,#224abe 100%);color:#fff;">
                        <span class="fw-semibold text-uppercase"><i class="fas fa-info-circle me-1"></i>Thông tin khuyến mãi</span>
                        <span class="badge bg-light text-primary text-uppercase">Tạo mới</span>
                    </div>
                    <div class="card-body">

                        <!-- Server-side messages (giữ nguyên) -->
                        <c:if test="${not empty successMessage}">
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                <strong>Thêm khuyến mãi thành công!</strong> ${successMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>
                        <c:if test="${not empty errorMessage}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <strong>Vui lòng kiểm tra lại thông tin bắt buộc.</strong> ${errorMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>

                        <!-- Client-side summary errors (mới thêm, chỉ hiện khi validate fail) -->
                        <div id="clientAlert" class="alert alert-danger d-none" role="alert">
                            <i class="fas fa-exclamation-triangle me-1"></i>
                            Vui lòng sửa các lỗi bên dưới rồi gửi lại.
                            <ul id="clientAlertList" class="mb-0 ps-3"></ul>
                        </div>

                        <c:set var="form" value="${promotionDto}"/>
                        <c:set var="fieldErrors" value="${fieldErrors}"/>
                        <c:set var="selectedProductDetails" value="${selectedProductDetails}"/>
                        <c:if test="${empty form}">
                            <c:set var="form" value="${null}"></c:set>
                        </c:if>

                        <form method="post" action="${pageContext.request.contextPath}/promotion-new" id="promotionForm" novalidate>
                            <c:set var="applyToAll" value="${form != null && form.applyToAll != null ? form.applyToAll : true}"/>
                            <c:set var="selectedIds" value="${selectedProductIds}"/>
                            <c:set var="selectedIdsCsv" value="${selectedProductIdsCsv}"/>

                            <div class="row g-4">
                                <div class="col-lg-3 text-center d-flex flex-column align-items-center justify-content-start">
                                    <div class="promotion-icon mb-3">
                                        <i class="fas fa-tags fa-3x text-primary"></i>
                                    </div>
                                    <div class="info-label">ID khuyến mãi</div>
                                    <div class="info-value text-muted">(Tự động tạo)</div>
                                </div>

                                <div class="col-lg-9">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="info-label">Tên khuyến mãi<span class="text-danger"> *</span></div>
                                            <input type="text" class="form-control ${not empty fieldErrors['name'] ? 'is-invalid' : ''}"
                                                   name="name" id="name" maxlength="255" required
                                                   value="${form != null ? form.name : ''}" placeholder="Nhập tên khuyến mãi">
                                            <c:if test="${not empty fieldErrors['name']}">
                                                <small class="text-danger">${fieldErrors['name']}</small>
                                            </c:if>
                                            <!-- chỗ hiển thị lỗi client -->
                                            <div class="invalid-feedback">Vui lòng nhập tên khuyến mãi.</div>

                                            <div class="info-label mt-3">Mã khuyến mãi<span class="text-danger"> *</span></div>
                                            <input type="text" class="form-control text-uppercase ${not empty fieldErrors['code'] ? 'is-invalid' : ''}"
                                                   name="code" id="code" maxlength="50" required
                                                   value="${form != null ? form.code : ''}" placeholder="VD: WELCOME10">
                                            <c:if test="${not empty fieldErrors['code']}">
                                                <small class="text-danger">${fieldErrors['code']}</small>
                                            </c:if>
                                            <div class="form-text">Chỉ A–Z và 0–9, 4–20 ký tự.</div>
                                            <div class="invalid-feedback" data-msg="pattern">Mã không hợp lệ (chỉ A–Z, 0–9; 4–20 ký tự).</div>

                                            <div class="info-label mt-3">Loại khuyến mãi<span class="text-danger"> *</span></div>
                                            <select class="form-select ${not empty fieldErrors['type'] ? 'is-invalid' : ''}" name="type" id="type" required onchange="updateValueLabel()">
                                                <option value="">-- Chọn loại khuyến mãi --</option>
                                                <option value="percentage" ${form != null && form.type == 'percentage' ? 'selected' : ''}>Phần trăm (%)</option>
                                                <option value="fixed_amount" ${form != null && form.type == 'fixed_amount' ? 'selected' : ''}>Giá trị cố định (₫)</option>
                                                <option value="free_shipping" ${form != null && form.type == 'free_shipping' ? 'selected' : ''}>Miễn phí ship</option>
                                            </select>
                                            <c:if test="${not empty fieldErrors['type']}">
                                                <small class="text-danger">${fieldErrors['type']}</small>
                                            </c:if>
                                            <div class="invalid-feedback">Vui lòng chọn loại khuyến mãi.</div>

                                            <div class="info-label mt-3"><span id="valueLabel">Giá trị khuyến mãi</span><span class="text-danger"> *</span></div>
                                            <div class="input-group">
                                                <span class="input-group-text" id="valuePrefix"><i class="fas fa-gift"></i></span>
                                                <input type="number" class="form-control ${not empty fieldErrors['value'] ? 'is-invalid' : ''}"
                                                       name="value" id="value" min="0" step="0.01" required
                                                       value="${form != null && form.value != null ? form.value : ''}">
                                                <span class="input-group-text" id="valueSuffix">%</span>
                                            </div>
                                            <small class="text-muted" id="valueHelp">Nhập giá trị khuyến mãi</small>
                                            <c:if test="${not empty fieldErrors['value']}">
                                                <small class="text-danger d-block">${fieldErrors['value']}</small>
                                            </c:if>
                                            <div class="invalid-feedback" data-msg="number">Giá trị phải là số hợp lệ.</div>
                                            <div class="invalid-feedback" data-msg="rangePerc">Giá trị % phải trong khoảng 0–100.</div>
                                            <div class="invalid-feedback" data-msg="rangeMoney">Số tiền giảm phải &gt; 0.</div>
                                        </div>

                                        <div class="col-md-6">
                                            <div class="info-label">Phạm vi áp dụng<span class="text-danger"> *</span></div>
                                            <div class="form-check">
                                                <input class="form-check-input" type="radio" id="scopeAll" name="productScope" value="all" ${applyToAll ? 'checked' : ''}>
                                                <label class="form-check-label" for="scopeAll"><span class="badge bg-success"><i class="fas fa-globe me-1"></i>Tất cả sản phẩm</span></label>
                                            </div>
                                            <div class="form-check">
                                                <input class="form-check-input" type="radio" id="scopeSelected" name="productScope" value="selected" ${!applyToAll ? 'checked' : ''}>
                                                <label class="form-check-label" for="scopeSelected"><span class="badge bg-info text-dark"><i class="fas fa-list-check me-1"></i>Chọn sản phẩm cụ thể</span></label>
                                            </div>
                                            <div id="productSelectionContainer" class="mt-2" <c:if test="${applyToAll}">style="display:none;"</c:if>>
                                                <button type="button" class="btn btn-outline-primary btn-sm" data-bs-toggle="modal" data-bs-target="#productSelectionModal">
                                                    <i class="fas fa-plus me-1"></i>Chọn sản phẩm
                                                </button>
                                                <div id="selectedProductsSummary" class="mt-2">
                                                    <c:choose>
                                                        <c:when test="${selectedIds != null && fn:length(selectedIds) > 0}">
                                                            <small class="text-success"><strong>Đã chọn ${fn:length(selectedIds)} sản phẩm.</strong></small>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <small class="text-muted">Chưa chọn sản phẩm nào</small>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                                <div id="selectedProductsChips" class="mt-2 d-flex flex-wrap gap-2">
                                                    <c:forEach var="product" items="${selectedProductDetails}">
                                                        <span class="badge bg-light text-dark border"><i class="fas fa-mug-hot me-1 text-primary"></i>${product.name}</span>
                                                    </c:forEach>
                                                </div>
                                                <c:if test="${not empty fieldErrors['productScope']}">
                                                    <small class="text-danger d-block mt-2">${fieldErrors['productScope']}</small>
                                                </c:if>
                                                <!-- client side error -->
                                                <div class="invalid-feedback d-block d-none" id="scopeError">Vui lòng chọn ít nhất 1 sản phẩm.</div>
                                            </div>
                                            <input type="hidden" name="selectedProductIds" id="selectedProductIds" value="${selectedIdsCsv}"/>

                                            <div class="info-label mt-3">Đơn hàng tối thiểu</div>
                                            <input type="number" class="form-control ${not empty fieldErrors['minOrderValue'] ? 'is-invalid' : ''}"
                                                   name="minOrderValue" id="minOrderValue" min="0" step="1000"
                                                   value="${form != null && form.minOrderValue != null ? form.minOrderValue : ''}" placeholder="Không bắt buộc">
                                            <c:if test="${not empty fieldErrors['minOrderValue']}">
                                                <small class="text-danger">${fieldErrors['minOrderValue']}</small>
                                            </c:if>
                                            <div class="invalid-feedback">Giá trị phải là số không âm.</div>

                        <div class="info-label mt-3">Trạng thái<span class="text-danger"> *</span></div>
                                            <div class="d-flex gap-3 flex-wrap">
                                                <div class="form-check">
                                                    <input class="form-check-input" type="radio" name="status" id="statusActivate" value="Activate" ${form == null || form.status == 'Activate' ? 'checked' : ''}>
                                                    <label class="form-check-label" for="statusActivate"><i class="fas fa-check-circle text-success me-1"></i>Hoạt động</label>
                                                </div>
                                                <div class="form-check">
                                                    <input class="form-check-input" type="radio" name="status" id="statusDeactivate" value="Deactivate" ${form != null && form.status == 'Deactivate' ? 'checked' : ''}>
                                                    <label class="form-check-label" for="statusDeactivate"><i class="fas fa-pause-circle text-secondary me-1"></i>Tạm dừng</label>
                                                </div>
                                                <div class="form-check">
                                                    <input class="form-check-input" type="radio" name="status" id="statusUpcoming" value="Upcoming" ${form != null && form.status == 'Upcoming' ? 'checked' : ''}>
                                                    <label class="form-check-label" for="statusUpcoming"><i class="fas fa-clock text-warning me-1"></i>Sắp diễn ra</label>
                                                </div>
                                            </div>
                                            <c:if test="${not empty fieldErrors['status']}">
                                                <small class="text-danger d-block">${fieldErrors['status']}</small>
                                            </c:if>

                                            <fmt:formatDate value="${form != null ? form.startDate : null}" pattern="yyyy-MM-dd" var="startDateValue"/>
                                            <fmt:formatDate value="${form != null ? form.endDate : null}" pattern="yyyy-MM-dd" var="endDateValue"/>

                                            <div class="info-label mt-3">Ngày bắt đầu<span class="text-danger"> *</span></div>
                                            <input type="date" class="form-control ${not empty fieldErrors['startDate'] ? 'is-invalid' : ''}"
                                                   name="startDate" id="startDate" required value="${startDateValue}">
                                            <c:if test="${not empty fieldErrors['startDate']}">
                                                <small class="text-danger">${fieldErrors['startDate']}</small>
                                            </c:if>
                                            <div class="invalid-feedback">Vui lòng chọn ngày bắt đầu.</div>

                                            <div class="info-label mt-3">Ngày kết thúc<span class="text-danger"> *</span></div>
                                            <input type="date" class="form-control ${not empty fieldErrors['endDate'] ? 'is-invalid' : ''}"
                                                   name="endDate" id="endDate" required value="${endDateValue}">
                                            <c:if test="${not empty fieldErrors['endDate']}">
                                                <small class="text-danger">${fieldErrors['endDate']}</small>
                                            </c:if>
                                            <div class="invalid-feedback" data-msg="required">Vui lòng chọn ngày kết thúc.</div>
                                            <div class="invalid-feedback" data-msg="rangeDate">Ngày kết thúc phải sau hoặc bằng ngày bắt đầu.</div>
                                        </div>
                                    </div>

                                    <div class="row mt-4">
                                        <div class="col-md-6">
                                            <div class="info-label">Mô tả khuyến mãi<span class="text-danger"> *</span></div>
                                            <textarea class="form-control ${not empty fieldErrors['description'] ? 'is-invalid' : ''}" name="description" id="description" rows="4" required>${form != null && form.description != null ? form.description : ''}</textarea>
                                            <c:if test="${not empty fieldErrors['description']}">
                                                <small class="text-danger">${fieldErrors['description']}</small>
                                            </c:if>
                                            <div class="invalid-feedback">Vui lòng nhập mô tả.</div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="info-label">Ghi chú nội bộ</div>
                                            <textarea class="form-control" name="note" id="note" rows="4">${form != null && form.note != null ? form.note : ''}</textarea>
                                        </div>
                                    </div>

                                    <div class="d-flex justify-content-between align-items-center mt-4 pt-3 border-top">
                                        <button type="reset" class="btn btn-secondary"><i class="fas fa-undo me-1"></i>Làm mới</button>
                                        <button type="submit" class="btn btn-primary"><i class="fas fa-save me-1"></i>Lưu khuyến mãi</button>
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

<!-- Modal chọn sản phẩm -->
<div class="modal fade" id="productSelectionModal" tabindex="-1" aria-labelledby="productSelectionModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="productSelectionModalLabel"><i class="fas fa-list-check me-1"></i>Chọn sản phẩm áp dụng</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <input type="text" class="form-control mb-3" id="productSearch" placeholder="Tìm kiếm sản phẩm...">
                <div class="border rounded p-3" style="max-height:400px;overflow-y:auto;">
                    <c:choose>
                        <c:when test="${allProducts != null && fn:length(allProducts) > 0}">
                            <c:forEach var="product" items="${allProducts}">
                                <div class="form-check product-item" data-product-id="${product.product_id}" data-product-name="${product.name}">
                                    <input class="form-check-input" type="checkbox" id="product_${product.product_id}" value="${product.product_id}">
                                    <label class="form-check-label" for="product_${product.product_id}">
                                        <strong>${product.name}</strong>
                                        <c:if test="${product.category != null}">
                                            <span class="badge bg-secondary ms-1">${product.category}</span>
                                        </c:if>
                                        <c:if test="${product.price != null}">
                                            <span class="text-muted ms-1"><fmt:formatNumber value="${product.price}" type="currency" currencyCode="VND"/></span>
                                        </c:if>
                                    </label>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <p class="text-muted mb-0">Chưa có sản phẩm khả dụng.</p>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                <button type="button" class="btn btn-primary" onclick="saveProductSelection()"><i class="fas fa-check me-1"></i>Xác nhận</button>
            </div>
        </div>
    </div>
</div>

<style>
.promotion-icon{
    width:112px;height:112px;border-radius:50%;background:rgba(78,115,223,.12);
    display:flex;align-items:center;justify-content:center;
}
.info-label{
    font-size:.85rem;font-weight:600;color:#5a5c69;margin-bottom:.35rem;text-transform:uppercase;letter-spacing:.5px;
}
.info-value{font-size:1rem;color:#2c3e50;margin-bottom:.5rem;}
.card-header{font-weight:600}
.form-control.is-invalid,.form-select.is-invalid{border-color:#dc3545;}
#selectedProductsChips span{font-size:.75rem}
</style>

<script>
(function(){
    const typeEl = document.getElementById('type');
    const valueEl = document.getElementById('value');
    const codeEl = document.getElementById('code');
    const scopeRadios = document.querySelectorAll('input[name="productScope"]');
    const searchInput = document.getElementById('productSearch');

    function setValueLabel(){
        const label = document.getElementById('valueLabel');
        const suffix = document.getElementById('valueSuffix');
        const help = document.getElementById('valueHelp');
        const prefix = document.getElementById('valuePrefix');
        if(!typeEl){return;}
        switch(typeEl.value){
            case 'percentage':
                label.textContent = 'Giá trị khuyến mãi (%)';
                suffix.textContent = '%';
                help.textContent = 'Giá trị phần trăm giảm giá (0 - 100).';
                valueEl.disabled = false;
                valueEl.required = true;
                valueEl.max = 100;
                prefix.innerHTML = '<i class="fas fa-percent"></i>';
                break;
            case 'fixed_amount':
                label.textContent = 'Giá trị khuyến mãi (₫)';
                suffix.textContent = '₫';
                help.textContent = 'Nhập số tiền giảm cố định (> 0).';
                valueEl.disabled = false;
                valueEl.required = true;
                valueEl.removeAttribute('max');
                prefix.innerHTML = '<i class="fas fa-donate"></i>';
                break;
            case 'free_shipping':
                label.textContent = 'Giá trị khuyến mãi';
                suffix.textContent = '';
                help.textContent = 'Khuyến mãi miễn phí vận chuyển (không cần nhập giá trị).';
                valueEl.value = 0;
                valueEl.disabled = true;
                valueEl.required = false;
                prefix.innerHTML = '<i class="fas fa-truck"></i>';
                break;
            default:
                label.textContent = 'Giá trị khuyến mãi';
                suffix.textContent = '';
                help.textContent = 'Chọn loại khuyến mãi để xác định giá trị.';
                valueEl.disabled = false;
                valueEl.required = true;
                valueEl.removeAttribute('max');
                prefix.innerHTML = '<i class="fas fa-gift"></i>';
        }
    }

    function toggleProductContainer(){
        const container = document.getElementById('productSelectionContainer');
        if(!container){return;}
        const selected = document.querySelector('input[name="productScope"]:checked');
        if(selected && selected.value === 'selected'){
            container.style.display = 'block';
        } else {
            container.style.display = 'none';
        }
    }

    function updateSelectedProductsDisplay(list){
        const summary = document.getElementById('selectedProductsSummary');
        const chips = document.getElementById('selectedProductsChips');
        const hidden = document.getElementById('selectedProductIds');
        if(!summary || !chips || !hidden){return;}
        chips.innerHTML = '';
        if(!list || !list.length){
            summary.innerHTML = '<small class="text-muted">Chưa chọn sản phẩm nào</small>';
            hidden.value = '';
            return;
        }
        summary.innerHTML = `<small class="text-success"><strong>Đã chọn ${list.length} sản phẩm.</strong></small>`;
        hidden.value = list.map(p => p.id).join(',');
        list.forEach(p => {
            const badge = document.createElement('span');
            badge.className = 'badge bg-light text-dark border';
            badge.innerHTML = `<i class="fas fa-mug-hot me-1 text-primary"></i>${p.name}`;
            chips.appendChild(badge);
        });
    }

    window.saveProductSelection = function(){
        const checked = document.querySelectorAll('#productSelectionModal input[type="checkbox"]:checked');
        const selected = Array.from(checked).map(cb => {
            const item = cb.closest('.product-item');
            return {
                id: item.getAttribute('data-product-id'),
                name: item.getAttribute('data-product-name')
            };
        });
        updateSelectedProductsDisplay(selected);
        const modalEl = document.getElementById('productSelectionModal');
        bootstrap.Modal.getInstance(modalEl).hide();
    };

    if(codeEl){
        codeEl.addEventListener('input', function(){
            this.value = this.value.toUpperCase().replace(/[^A-Z0-9]/g, '');
        });
    }
    if(typeEl){
        typeEl.addEventListener('change', setValueLabel);
        setValueLabel();
    }
    scopeRadios.forEach(r => r.addEventListener('change', toggleProductContainer));
    toggleProductContainer();

    if(searchInput){
        searchInput.addEventListener('input', function(){
            const keyword = this.value.trim().toLowerCase();
            document.querySelectorAll('.product-item').forEach(item => {
                const name = item.getAttribute('data-product-name') || '';
                item.style.display = name.toLowerCase().includes(keyword) ? 'block' : 'none';
            });
        });
    }

    const hiddenIds = document.getElementById('selectedProductIds');
    if(hiddenIds && hiddenIds.value){
        const ids = hiddenIds.value.split(',').map(id => id.trim()).filter(Boolean);
        if(ids.length){
            const allItems = Array.from(document.querySelectorAll('.product-item'));
            const matched = ids.map(id => {
                const item = allItems.find(i => i.getAttribute('data-product-id') === id);
                if(item){
                    const checkbox = item.querySelector('input[type="checkbox"]');
                    if(checkbox){ checkbox.checked = true; }
                    return { id, name: item.getAttribute('data-product-name') };
                }
                return null;
            }).filter(Boolean);
            updateSelectedProductsDisplay(matched);
        }
    }

    /* ====== VALIDATION KHÔNG POPUP (mới thêm) ====== */
    const form = document.getElementById('promotionForm');
    const clientAlert = document.getElementById('clientAlert');
    const clientAlertList = document.getElementById('clientAlertList');

    const reCode = /^[A-Z0-9]{4,20}$/; // mã: chỉ A-Z và 0-9, 4-20 ký tự
    const numberLike = v => {
        if (v === '' || v === null || v === undefined) return null;
        const cleaned = String(v).replace(/\s+/g,'').replace(/,/g,'');
        if (!/^[-+]?\d*\.?\d+$/.test(cleaned)) return NaN;
        return Number(cleaned);
    };
    const clearInvalid = el=>{
        el.classList.remove('is-invalid');
        const group = el.closest('.col-md-6, .col-md-3, .col-12');
        if(!group) return;
        group.querySelectorAll('.invalid-feedback').forEach(x=>x.style.display='none');
    };
    const showInvalid = (el, key)=>{
        el.classList.add('is-invalid');
        const group = el.closest('.col-md-6, .col-md-3, .col-12');
        if(!group) return;
        const feedbacks = group.querySelectorAll('.invalid-feedback');
        if(!feedbacks.length) return;
        feedbacks.forEach(x=>{
            x.style.display = (!x.dataset.msg && !key) || (x.dataset.msg === key) ? 'block' : 'none';
        });
    };

    function validateForm(){
        clientAlertList.innerHTML='';
        clientAlert.classList.add('d-none');
        let ok = true;

        const nameEl = document.getElementById('name');
        if(!nameEl.value.trim()){
            ok=false; showInvalid(nameEl);
            clientAlertList.insertAdjacentHTML('beforeend','<li>Chưa nhập <b>Tên khuyến mãi</b>.</li>');
        } else clearInvalid(nameEl);

        const code = codeEl.value.trim().toUpperCase();
        if(!code){
            ok=false; showInvalid(codeEl,'required');
            clientAlertList.insertAdjacentHTML('beforeend','<li>Chưa nhập <b>Mã khuyến mãi</b>.</li>');
        } else if(!reCode.test(code)){
            ok=false; showInvalid(codeEl,'pattern');
            clientAlertList.insertAdjacentHTML('beforeend','<li><b>Mã khuyến mãi</b> sai định dạng (chỉ A–Z, 0–9; 4–20 ký tự).</li>');
        } else { clearInvalid(codeEl); codeEl.value = code; }

        if(!typeEl.value){
            ok=false; showInvalid(typeEl);
            clientAlertList.insertAdjacentHTML('beforeend','<li>Vui lòng chọn <b>Loại khuyến mãi</b>.</li>');
        } else clearInvalid(typeEl);

        if(typeEl.value === 'percentage' || typeEl.value === 'fixed_amount'){
            const v = numberLike(valueEl.value);
            if(valueEl.value.trim()===''){
                ok=false; showInvalid(valueEl,'number');
                clientAlertList.insertAdjacentHTML('beforeend','<li><b>Giá trị</b> không được để trống.</li>');
            } else if(isNaN(v)){
                ok=false; showInvalid(valueEl,'number');
                clientAlertList.insertAdjacentHTML('beforeend','<li><b>Giá trị</b> phải là số (không nhập chữ).</li>');
            } else if(typeEl.value==='percentage' && (v<0 || v>100)){
                ok=false; showInvalid(valueEl,'rangePerc');
                clientAlertList.insertAdjacentHTML('beforeend','<li><b>Giá trị %</b> phải từ 0 đến 100.</li>');
            } else if(typeEl.value==='fixed_amount' && v<=0){
                ok=false; showInvalid(valueEl,'rangeMoney');
                clientAlertList.insertAdjacentHTML('beforeend','<li><b>Số tiền giảm</b> phải lớn hơn 0.</li>');
            } else { clearInvalid(valueEl); valueEl.value = String(v); }
        } else {
            clearInvalid(valueEl);
            valueEl.value = 0;
        }

        const minEl = document.getElementById('minOrderValue');
        if(minEl.value.trim()!==''){
            const mv = numberLike(minEl.value);
            if(isNaN(mv) || mv < 0){
                ok=false; showInvalid(minEl);
                clientAlertList.insertAdjacentHTML('beforeend','<li><b>Đơn hàng tối thiểu</b> phải là số không âm.</li>');
            } else { clearInvalid(minEl); minEl.value = String(mv); }
        } else clearInvalid(minEl);

        const startEl = document.getElementById('startDate');
        const endEl = document.getElementById('endDate');
        if(!startEl.value){
            ok=false; showInvalid(startEl);
            clientAlertList.insertAdjacentHTML('beforeend','<li>Chưa chọn <b>Ngày bắt đầu</b>.</li>');
        } else clearInvalid(startEl);
        if(!endEl.value){
            ok=false; showInvalid(endEl,'required');
            clientAlertList.insertAdjacentHTML('beforeend','<li>Chưa chọn <b>Ngày kết thúc</b>.</li>');
        } else { clearInvalid(endEl); }
        if(startEl.value && endEl.value && new Date(endEl.value) < new Date(startEl.value)){
            ok=false; showInvalid(endEl,'rangeDate');
            clientAlertList.insertAdjacentHTML('beforeend','<li><b>Ngày kết thúc</b> phải sau hoặc bằng <b>Ngày bắt đầu</b>.</li>');
        }

        // product scope
        const scopeSelected = document.querySelector('input[name="productScope"]:checked')?.value === 'selected';
        const ids = (document.getElementById('selectedProductIds').value || '').trim();
        const scopeError = document.getElementById('scopeError');
        if(scopeSelected && !ids){
            ok=false;
            if(scopeError){ scopeError.classList.remove('d-none'); }
            clientAlertList.insertAdjacentHTML('beforeend','<li>Vui lòng chọn ít nhất 1 <b>sản phẩm áp dụng</b>.</li>');
        } else {
            if(scopeError){ scopeError.classList.add('d-none'); }
        }

        if(!ok){
            clientAlert.classList.remove('d-none');
            clientAlert.scrollIntoView({behavior:'smooth', block:'start'});
        }
        return ok;
    }

    if(form){
        form.addEventListener('submit', function(e){
            if(!validateForm()){
                e.preventDefault(); // chặn submit khi lỗi
            }
        });
    }
})();
</script>

<jsp:include page="/WEB-INF/view/layout/management/scripts.jsp"/>
