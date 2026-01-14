<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%-- Product Details (Marketer) - Aligned version --%>

<%
    String cPath = request.getContextPath();
    request.setAttribute("pageTitle", "Chi tiết sản phẩm - Yen Coffee");
%>
<jsp:include page="/WEB-INF/view/layout/management/header.jsp"/>

<div id="wrapper">
  <jsp:include page="/WEB-INF/view/layout/management/sidebar.jsp"/>

  <div id="content-wrapper" class="d-flex flex-column">
    <div id="content">
      <jsp:include page="/WEB-INF/view/layout/management/navbar.jsp"/>

            <div class="container-fluid" style="background-color:#f8f9fc;min-height:100vh;">
                <!-- Heading -->
                <div class="d-sm-flex align-items-center justify-content-between mb-4">
                    <div>
                        <h1 class="h3 mb-0 text-gray-800">
                            <i class="fas fa-coffee me-2"></i>Chi tiết sản phẩm
                        </h1>
                        <p class="text-muted mb-0">Quản lý thông tin chi tiết, giá bán và trạng thái sản phẩm</p>
                    </div>
                    <div class="d-flex gap-2">
                        <a href="${pageContext.request.contextPath}/product-list" class="btn btn-outline-secondary">
                            <i class="fas fa-arrow-left"></i> Quay lại danh sách
                        </a>
                        <button class="btn btn-primary" onclick="toggleEditMode()">
                            <i class="fas fa-edit"></i> <span id="editButtonText">Chỉnh sửa sản phẩm</span>
                        </button>
                    </div>
                </div>

                <!-- Messages -->
                <c:if test="${not empty sessionScope.success}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle"></i> ${sessionScope.success}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <c:remove var="success" scope="session"/>
                </c:if>

                <c:if test="${not empty sessionScope.error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-circle"></i> ${sessionScope.error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <c:remove var="error" scope="session"/>
                </c:if>

                <div class="row">
                    <div class="col-12">
                        <div class="card shadow mb-4">
                            <div class="card-header py-3 d-flex justify-content-between align-items-center"
                                 style="background:linear-gradient(135deg,#4e73df 0%,#224abe 100%);color:#fff;">
                                <span><i class="fas fa-info-circle me-1"></i> Thông tin sản phẩm</span>
                            </div>

                            <div class="card-body">
                                <div class="row">
                                    <!-- LEFT: IMAGE -->
                                    <div class="col-md-4 text-center mb-3">
                                        <div class="product-image-container mb-3">
                                            <c:if test="${not empty product.image_url}">
                                                <img src="${product.image_url}" alt="${product.name}"
                                                     id="productImageDisplay"
                                                     class="img-fluid rounded shadow-sm"
                                                     style="max-height:300px;max-width:100%;object-fit:cover;">
                                            </c:if>
                                            <c:if test="${empty product.image_url}">
                                                <div class="product-icon">
                                                    <i class="fas fa-coffee fa-5x text-primary"></i>
                                                </div>
                                            </c:if>
                                        </div>

                                        <!-- Upload image -->
                                        <form method="post" action="${pageContext.request.contextPath}/product/update-image"
                                              enctype="multipart/form-data" id="imageUpdateForm" class="text-center">
                                            <input type="hidden" name="productId" value="${product.productId}">
                                            <div class="mb-3">
                                                <label class="form-label">Chọn ảnh mới</label>
                                                <input type="file" class="form-control" name="productImage" accept="image/*"
                                                       id="productImageInput" onchange="previewImageFileDetail(this)"
                                                       style="display:none;">
                                                <button type="button" class="btn btn-sm btn-outline-primary"
                                                        onclick="document.getElementById('productImageInput').click()"
                                                        id="uploadImageBtn" style="display:none;">
                                                    <i class="fas fa-upload me-1"></i>Chọn ảnh
                                                </button>
                                                <div class="form-text" id="imageUploadText" style="display:none;">
                                                    Chọn ảnh từ máy tính (JPG, PNG, GIF). Kích thước tối đa: 5MB
                                                </div>
                                            </div>

                        <div id="imagePreviewDetail" class="mb-3 text-center" style="display:none;">
                            <small class="text-muted">Ảnh xem trước:</small><br>
                            <img id="previewImgDetail" src="" alt="Preview"
                                 class="img-fluid rounded shadow-sm mt-1"
                                 style="max-height:200px;max-width:100%;">
                            <div class="mt-2">
                                <button type="submit" class="btn btn-sm btn-success" id="confirmUploadBtn">
                                    <i class="fas fa-check me-1"></i>Cập nhật ảnh
                                </button>
                                <button type="button" class="btn btn-sm btn-outline-danger"
                                        onclick="clearImagePreviewDetail()">
                                    <i class="fas fa-times me-1"></i>Hủy
                                </button>
                            </div>
                        </div>
                                        </form>
                                    </div>

                                    <!-- RIGHT: FIELDS -->
                                    <div class="col-md-8">
                                        <div class="row">
                                            <!-- LEFT SUBCOL -->
                                            <div class="col-md-6">
                                                <div class="info-label">ID Sản phẩm</div>
                                                <div class="info-value"><strong>#${product.productId}</strong></div>

                                                <div class="info-label">Tên sản phẩm</div>
                                                <div class="info-value">
                                                    <span id="productNameDisplay">${product.name}</span>
                                                    <input type="text" id="productNameEdit" class="form-control"
                                                           value="${product.name}" style="display:none;">
                                                </div>

                                                <div class="info-label">Danh mục</div>
                                                <div class="info-value">
                                                    <span id="productCategoryDisplay">
                                                        <span class="badge bg-info fs-6">${product.category}</span>
                                                    </span>
                                                    <select id="productCategoryEdit" class="form-select" style="display:none;">
                                                        <option value="Cà phê" ${product.category == 'Cà phê' ? 'selected' : ''}>Cà phê</option>
                                                        <option value="Trà" ${product.category == 'Trà' ? 'selected' : ''}>Trà</option>
                                                        <option value="Trà sữa" ${product.category == 'Trà sữa' ? 'selected' : ''}>Trà sữa</option>
                                                        <option value="Nước ép" ${product.category == 'Nước ép' ? 'selected' : ''}>Nước ép</option>
                                                        <option value="Bánh ngọt" ${product.category == 'Bánh ngọt' ? 'selected' : ''}>Bánh ngọt</option>
                                                        <option value="Khác" ${product.category == 'Khác' ? 'selected' : ''}>Khác</option>
                                                    </select>
                                                </div>

                                                <!-- Giữ khoảng trống trước Status để khớp bên phải -->
                                                <div class="mt-3"></div>

                                                <div class="info-label status-indent">Trạng thái</div>
                                                <div class="info-value status-indent">
                                                    <span id="productStatusDisplay">
                                                        <c:choose>
                                                            <c:when test="${product.status == 'Activate'}">
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
                                                    <div id="productStatusEdit" class="d-flex status-radio-container-edit"
                                                         style="display:none;gap:2rem;">
                                                        <div class="form-check status-radio-item">
                                                            <input class="form-check-input" type="radio" name="status"
                                                                   id="editStatusActivate" value="Activate"
                                                                   ${product.status == 'Activate' ? 'checked' : ''}>
                                                            <label class="form-check-label" for="editStatusActivate">
                                                                <i class="fas fa-check-circle text-success"></i>Hoạt động
                                                            </label>
                                                        </div>
                                                        <div class="form-check status-radio-item">
                                                            <input class="form-check-input" type="radio" name="status"
                                                                   id="editStatusDeactivate" value="Deactivate"
                                                                   ${product.status == 'Deactivate' ? 'checked' : ''}>
                                                            <label class="form-check-label" for="editStatusDeactivate">
                                                                <i class="fas fa-pause-circle text-secondary"></i>Không hoạt động
                                                            </label>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- RIGHT SUBCOL -->
                                            <div class="col-md-6">
                                                <%-- Spacer: căn đỉnh cột phải ngang với "Tên sản phẩm" --%>
                                                <div class="align-spacer d-none d-md-block"></div>

                                                <div class="info-label">Giá bán</div>
                                                <div class="info-value">
                                                    <span id="productPriceDisplay" class="text-success fw-bold fs-4">
                                                        <fmt:formatNumber value="${product.price}" type="currency" currencyCode="VND"/>
                                                    </span>
                                                    <div id="productPriceEdit" style="display:none;">
                                                        <div class="input-group">
                                                            <span class="input-group-text">₫</span>
                                                            <input type="number" id="productPriceInput" class="form-control"
                                                                   step="0.01" min="0" value="${product.price}" required>
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="info-label">Số lượng tồn kho</div>
                                                <div class="info-value">
                                                    <span id="productStockDisplay" class="fw-bold">
                                                        ${product.stockQuantity != null ? product.stockQuantity : 0} sản phẩm
                                                    </span>
                                                    <input type="number" id="productStockEdit" class="form-control"
                                                           value="${product.stockQuantity != null ? product.stockQuantity : 0}"
                                                           min="0" style="display:none;">
                                                </div>

                                                <div class="info-label">Sản phẩm bán chạy</div>
                                                <div class="info-value">
                                                    <span id="productBestsellerDisplay">
                                                        <c:choose>
                                                            <c:when test="${product.is_bestseller}">
                                                                <span class="badge bg-warning text-dark">
                                                                    <i class="fas fa-star"></i> BÁN CHẠY
                                                                </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-secondary">Thường</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                    <div id="productBestsellerEdit" style="display:none;">
                                                        <div class="form-check form-switch">
                                                            <input class="form-check-input" type="checkbox" id="editBestseller"
                                                                   ${product.is_bestseller ? 'checked' : ''}>
                                                            <label class="form-check-label" for="editBestseller">
                                                                Đánh dấu là sản phẩm bán chạy
                                                            </label>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- DESCRIPTION -->
                                        <div class="row mt-3">
                                            <div class="col-12">
                                                <div class="info-label">Mô tả</div>
                                                <div class="info-value">
                                                    <span id="productDescriptionDisplay">
                                                        ${product.description != null && not empty product.description ? product.description : 'Không có mô tả'}
                                                    </span>
                                                    <textarea id="productDescriptionEdit" class="form-control" rows="4" style="display:none;">${product.description}</textarea>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- NOTE -->
                                        <div class="row">
                                            <div class="col-12">
                                                <div class="info-label">Ghi chú (nội bộ)</div>
                                                <div class="info-value">
                                                    <span id="productNoteDisplay">
                                                        ${product.note != null && not empty product.note ? product.note : 'Không có ghi chú'}
                                                    </span>
                                                    <textarea id="productNoteEdit" class="form-control" rows="2" style="display:none;">${product.note}</textarea>
                                                </div>
                                            </div>
                                        </div>
                                    </div> <!-- /col-md-8 -->
                                </div> <!-- /row -->
                            </div> <!-- /card-body -->
                        </div> <!-- /card -->
                    </div>
                </div>
            </div>
        </div>

    <jsp:include page="/WEB-INF/view/layout/management/footer.jsp"/>
  </div>
</div>

<!-- Hidden submit form -->
<form id="productUpdateForm" action="${pageContext.request.contextPath}/product-edit" method="post"
      enctype="multipart/form-data" style="display:none;">
    <input type="hidden" name="productId" value="${product.productId}">
    <input type="hidden" name="productName" id="formProductName">
    <input type="hidden" name="category" id="formCategory">
    <input type="hidden" name="status" id="formStatus">
    <input type="hidden" name="description" id="formDescription">
    <input type="hidden" name="note" id="formNote">
    <input type="hidden" name="stockQuantity" id="formStockQuantity">
    <input type="hidden" name="isBestseller" id="formIsBestseller">
    <input type="hidden" name="price" id="formPrice">
</form>

<jsp:include page="/WEB-INF/view/layout/management/scripts.jsp"/>

<script>
let isEditMode = false;

function toggleEditMode() {
    isEditMode = !isEditMode;
    const editButton = document.getElementById('editButtonText');

    if (isEditMode) {
        editButton.textContent = 'Lưu thay đổi';

        document.getElementById('productNameDisplay').style.display = 'none';
        document.getElementById('productNameEdit').style.display = 'block';

        document.getElementById('productCategoryDisplay').style.display = 'none';
        document.getElementById('productCategoryEdit').style.display = 'block';

        document.getElementById('productPriceDisplay').style.display = 'none';
        document.getElementById('productPriceEdit').style.display = 'block';

        document.getElementById('productStockDisplay').style.display = 'none';
        document.getElementById('productStockEdit').style.display = 'block';

        document.getElementById('productStatusDisplay').style.display = 'none';
        document.getElementById('productStatusEdit').style.display = 'flex';

        document.getElementById('productBestsellerDisplay').style.display = 'none';
        document.getElementById('productBestsellerEdit').style.display = 'block';

        document.getElementById('productDescriptionDisplay').style.display = 'none';
        document.getElementById('productDescriptionEdit').style.display = 'block';

        document.getElementById('productNoteDisplay').style.display = 'none';
        document.getElementById('productNoteEdit').style.display = 'block';

        document.getElementById('uploadImageBtn').style.display = 'inline-block';
        document.getElementById('imageUploadText').style.display = 'block';
    } else {
        saveProductChanges();
    }
}

function saveProductChanges() {
    document.getElementById('formProductName').value = document.getElementById('productNameEdit').value;
    document.getElementById('formCategory').value = document.getElementById('productCategoryEdit').value;

    const statusRadios = document.querySelectorAll('input[name="status"]:checked');
    document.getElementById('formStatus').value = statusRadios.length > 0 ? statusRadios[0].value : 'Activate';

    document.getElementById('formDescription').value = document.getElementById('productDescriptionEdit').value;
    document.getElementById('formNote').value = document.getElementById('productNoteEdit').value;
    document.getElementById('formStockQuantity').value = document.getElementById('productStockEdit').value;

    const priceInput = document.getElementById('productPriceInput');
    if (priceInput) document.getElementById('formPrice').value = priceInput.value;

    const bestsellerCheckbox = document.getElementById('editBestseller');
    document.getElementById('formIsBestseller').value = (bestsellerCheckbox && bestsellerCheckbox.checked) ? 'true' : 'false';

    document.getElementById('productUpdateForm').submit();
}

function previewImageFileDetail(input) {
    const preview = document.getElementById('imagePreviewDetail');
    const previewImg = document.getElementById('previewImgDetail');
    const productImageDisplay = document.getElementById('productImageDisplay');

    if (input.files && input.files[0]) {
        const file = input.files[0];
        const maxSize = 5 * 1024 * 1024;

        if (file.size > maxSize) { showNotification('Kích thước ảnh quá lớn. Vui lòng chọn ảnh nhỏ hơn 5MB.', 'warning', 'Cảnh báo'); input.value=''; preview.style.display='none'; return; }
        if (!file.type.match('image.*')) { showNotification('Vui lòng chọn file ảnh (JPG, PNG, GIF)', 'warning', 'Cảnh báo'); input.value=''; preview.style.display='none'; return; }

        const reader = new FileReader();
        reader.onload = function(e) {
            previewImg.src = e.target.result;
            preview.style.display = 'block';
            if (productImageDisplay) productImageDisplay.style.display = 'none';
            document.getElementById('uploadImageBtn').style.display = 'none';
            document.getElementById('imageUploadText').style.display = 'none';
        };
        reader.readAsDataURL(file);
    } else {
        preview.style.display = 'none';
        if (productImageDisplay) productImageDisplay.style.display = 'block';
    }
}

function clearImagePreviewDetail() {
    const fileInput = document.getElementById('productImageInput');
    const preview = document.getElementById('imagePreviewDetail');
    const productImageDisplay = document.getElementById('productImageDisplay');

    if (fileInput) fileInput.value = '';
    preview.style.display = 'none';
    if (productImageDisplay) productImageDisplay.style.display = 'block';

    if (isEditMode) {
        document.getElementById('uploadImageBtn').style.display = 'inline-block';
        document.getElementById('imageUploadText').style.display = 'block';
    }
}
</script>

<style>
/* Typography */
.info-label{
    font-size:.85rem;font-weight:600;color:#5a5c69;margin-top:.75rem;margin-bottom:.25rem;
    text-transform:uppercase;letter-spacing:.5px
}
.info-value{font-size:1rem;color:#2c3e50;margin-bottom:.75rem;min-height:1.5rem}
.info-value strong{color:#1f2937}
.card-header{font-weight:600}

/* Image */
.product-icon{padding:2rem}
.product-image-container{padding:1rem}

/* Status radio */
.status-radio-container-edit{flex-wrap:nowrap;align-items:center}
.status-radio-container-edit .status-radio-item{margin:0;padding:0;white-space:nowrap;flex-shrink:0}
.status-radio-container-edit .status-radio-item .form-check-label{
    margin-left:.5rem;cursor:pointer;display:inline-flex;align-items:center;gap:.375rem
}
.status-radio-container-edit .status-radio-item .form-check-input{margin-top:.25rem;cursor:pointer}

/* Căn lề "Trạng thái" */
.status-indent{padding-left:1.25rem}
@media (min-width:768px){ .status-indent{padding-left:1.5rem} }

/* ===== Alignment tweak (QUAN TRỌNG) =====
   Bù đúng chiều cao block "ID Sản phẩm" để
   Giá bán ngang Tên sản phẩm & Tồn kho ngang Danh mục.
*/
.align-spacer{height:56px}              /* base */
@media (min-width:768px){ .align-spacer{height:64px} }  /* md */
@media (min-width:992px){ .align-spacer{height:72px} }  /* lg */

/* Nhịp dọc */
.mt-3{margin-top:1rem !important}
</style>
</body>
</html>
