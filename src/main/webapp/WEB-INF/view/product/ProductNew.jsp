<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
    String cPath = request.getContextPath();
    request.setAttribute("pageTitle", "Thêm sản phẩm mới - Yen Coffee");
%>
<jsp:include page="/WEB-INF/view/layout/management/header.jsp"/>

<div id="wrapper">
  <jsp:include page="/WEB-INF/view/layout/management/sidebar.jsp"/>

  <div id="content-wrapper" class="d-flex flex-column">
    <div id="content">
      <jsp:include page="/WEB-INF/view/layout/management/navbar.jsp"/>

            <!-- Begin Page Content -->
            <div class="container-fluid bg-light min-vh-100 py-4">

                <!-- Page Heading -->
                <div class="d-sm-flex align-items-center justify-content-between mb-4">
                    <div>
                        <h1 class="h3 mb-0 text-gray-800">
                            <i class="fas fa-coffee me-2"></i>Thêm sản phẩm mới
                        </h1>
                        <p class="text-muted mb-0">Quản lý thông tin chi tiết, giá bán và trạng thái sản phẩm</p>
                    </div>
                    <div class="d-flex gap-2">
                        <a href="${pageContext.request.contextPath}/product-list" class="btn btn-outline-secondary">
                            <i class="fas fa-arrow-left me-1"></i>Quay lại danh sách
                        </a>
                        <a href="${pageContext.request.contextPath}/marketer-dashboard" class="btn btn-primary">
                            <i class="fas fa-tachometer-alt me-1"></i>Marketer Dashboard
                        </a>
                    </div>
                </div>

                <!-- Messages -->
                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                        <i class="fas fa-check-circle me-2"></i>${successMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Đóng"></button>
                    </div>
                </c:if>

                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
                        <i class="fas fa-exclamation-triangle me-2"></i>${errorMessage}
                        <c:if test="${not empty validationErrors}">
                            <ul class="mb-0 mt-2 ps-3">
                                <c:forEach var="err" items="${validationErrors}">
                                    <li><c:out value="${err}"/></li>
                                </c:forEach>
                            </ul>
                        </c:if>
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Đóng"></button>
                    </div>
                </c:if>

                <c:set var="statusValue" value="${empty productDto.status ? 'Activate' : productDto.status}"/>

                <div class="row">
                    <div class="col-12">
                        <div class="card shadow border-0 mb-4">
                            <div class="card-header py-3 d-flex justify-content-between align-items-center"
                                 style="background: linear-gradient(135deg, #4e73df 0%, #224abe 100%); color: #fff;">
                                <span><i class="fas fa-info-circle me-2"></i>Thông tin sản phẩm</span>
                            </div>

                            <div class="card-body">
                                <!-- FORM: giữ nguyên action/name -->
                                <form method="post"
                                      action="${pageContext.request.contextPath}/product-new"
                                      enctype="multipart/form-data" novalidate>

                                    <div class="row">
                                        <!-- LEFT: IMAGE + UPLOAD -->
                                        <div class="col-md-4 text-center mb-3">
                                            <div class="product-image-container mb-3">
                                                <c:choose>
                                                    <c:when test="${not empty productDto.imageUrl}">
                                                        <img src="${productDto.imageUrl}" alt="Ảnh sản phẩm"
                                                             id="productImagePreview"
                                                             class="img-fluid rounded shadow-sm"
                                                             style="max-height:300px; object-fit:cover;">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div id="imagePlaceholderIcon"
                                                             class="placeholder-icon rounded-circle d-flex align-items-center justify-content-center mx-auto">
                                                            <i class="fas fa-coffee fa-5x text-primary"></i>
                                                        </div>
                                                        <img id="productImagePreview" src="" alt="Preview"
                                                             class="img-fluid rounded shadow-sm"
                                                             style="max-height:300px; object-fit:cover; display:none;">
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>

                                            <div class="text-center">
                                                <input type="file" class="d-none" id="productImage" name="productImage"
                                                       accept=".jpg,.jpeg,.png,.gif">
                                                <button type="button" class="btn btn-sm btn-outline-primary"
                                                        onclick="document.getElementById('productImage').click()">
                                                    <i class="fas fa-upload me-1"></i>Chọn ảnh
                                                </button>
                                                <div class="form-text mt-2">
                                                    Chọn ảnh từ máy tính (JPG, PNG, GIF). Kích thước tối đa: 5MB.
                                                </div>
                                            </div>
                                        </div>

                                        <!-- RIGHT: TWO COLUMNS (aligned with details) -->
                                        <div class="col-md-8">
                                            <div class="row">
                                                <!-- LEFT COLUMN -->
                                                <div class="col-md-6">
                                                    <!-- NAME -->
                                                    <div class="info-label">Tên sản phẩm</div>
                                                    <div class="info-value">
                                                        <input type="text" class="form-control" id="productName" name="productName"
                                                               maxlength="255" placeholder="Nhập tên sản phẩm *"
                                                               value="<c:out value='${productDto.name}'/>">
                                                    </div>

                                                    <!-- CATEGORY -->
                                                    <div class="info-label">Danh mục</div>
                                                    <div class="info-value">
                                                        <select class="form-select" id="category" name="category">
                                                            <option value="">-- Chọn danh mục --</option>
                                                            <c:forEach var="categoryItem" items="${categories}">
                                                                <option value="${categoryItem}"
                                                                    <c:if test="${categoryItem == productDto.category}">selected</c:if>>
                                                                    <c:out value="${categoryItem}"/>
                                                                </option>
                                                            </c:forEach>
                                                        </select>
                                                    </div>

                                                    <!-- spacer: đưa về 0 trên trang NEW để căn hàng -->
                                                    <div class="align-spacer d-none d-md-block"></div>

                                                    <!-- STATUS -->
                                                    <div class="info-label status-indent">Trạng thái</div>
                                                    <div class="info-value status-indent">
                                                        <div class="d-flex gap-4 flex-wrap">
                                                            <div class="form-check">
                                                                <input class="form-check-input" type="radio" name="status"
                                                                       id="statusActive" value="Activate"
                                                                       <c:if test="${statusValue eq 'Activate'}">checked</c:if>>
                                                                <label class="form-check-label" for="statusActive">
                                                                    <i class="fas fa-check-circle text-success me-1"></i>Hoạt động
                                                                </label>
                                                            </div>
                                                            <div class="form-check">
                                                                <input class="form-check-input" type="radio" name="status"
                                                                       id="statusInactive" value="Deactivate"
                                                                       <c:if test="${statusValue eq 'Deactivate'}">checked</c:if>>
                                                                <label class="form-check-label" for="statusInactive">
                                                                    <i class="fas fa-pause-circle text-secondary me-1"></i>Không hoạt động
                                                                </label>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- RIGHT COLUMN -->
                                                <div class="col-md-6">
                                                    <!-- spacer top: bằng 0 để Giá bán ngang hàng Tên -->
                                                    <div class="align-spacer d-none d-md-block"></div>

                                                    <!-- PRICE -->
                                                    <div class="info-label">Giá bán</div>
                                                    <div class="info-value">
                                                        <div class="input-group">
                                                            <span class="input-group-text">₫</span>
                                                            <input type="number" class="form-control" id="price" name="price"
                                                                   min="0" step="0.01" placeholder="0.00 *"
                                                                   value="<c:out value='${productDto.price}'/>">
                                                        </div>
                                                    </div>

                                                    <!-- STOCK -->
                                                    <div class="info-label">Số lượng tồn kho</div>
                                                    <div class="info-value">
                                                        <input type="number" class="form-control" id="stockQuantity" name="stockQuantity"
                                                               min="0" placeholder="0 *"
                                                               value="<c:out value='${productDto.stockQuantity}'/>">
                                                    </div>

                                                    <!-- BESTSELLER -->
                                                    <div class="info-label">Sản phẩm bán chạy</div>
                                                    <div class="info-value">
                                                        <div class="form-check form-switch">
                                                            <input class="form-check-input" type="checkbox" role="switch"
                                                                   id="isBestseller" name="isBestseller" value="true"
                                                                   <c:if test="${productDto.isBestseller}">checked</c:if>>
                                                            <label class="form-check-label" for="isBestseller">
                                                                <i class="fas fa-star text-warning me-2"></i>Đánh dấu là sản phẩm bán chạy
                                                            </label>
                                                        </div>
                                                        <small class="text-muted">Sản phẩm bán chạy sẽ được hiển thị nổi bật.</small>
                                                    </div>
                                                </div>
                                            </div>

                        <!-- DESCRIPTION -->
                        <div class="row mt-3">
                            <div class="col-12">
                                <div class="info-label">Mô tả</div>
                                <div class="info-value">
                                    <textarea class="form-control" id="description" name="description" rows="4"
                                              placeholder="Mô tả chi tiết về sản phẩm..."><c:out value="${productDto.description}"/></textarea>
                                </div>
                            </div>
                        </div>

                        <!-- NOTE -->
                        <div class="row">
                            <div class="col-12">
                                <div class="info-label">Ghi chú (nội bộ)</div>
                                <div class="info-value">
                                    <textarea class="form-control" id="note" name="note" rows="2"
                                              placeholder="Nhập ghi chú nội bộ (tùy chọn)"><c:out value="${productDto.note}"/></textarea>
                                </div>
                            </div>
                        </div>
                    </div> <!-- /col-md-8 -->
                </div> <!-- /row -->

                <!-- ACTIONS -->
                <div class="d-flex flex-wrap justify-content-between align-items-center mt-4 pt-3 border-top">
                    <a href="${pageContext.request.contextPath}/product-list" class="btn btn-outline-secondary">
                        <i class="fas fa-list me-1"></i>Quay lại danh sách
                    </a>
                    <div class="d-flex gap-2">
                        <button type="reset" class="btn btn-outline-secondary">
                            <i class="fas fa-undo me-1"></i>Làm mới
                        </button>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save me-1"></i>Lưu sản phẩm
                        </button>
                    </div>
                </div>
            </form>
            <!-- /FORM -->
        </div>
    </div>
</div>
</div>
</div>
<!-- End Page Content -->

    <jsp:include page="/WEB-INF/view/layout/management/footer.jsp"/>
  </div>
</div>

<jsp:include page="/WEB-INF/view/layout/management/scripts.jsp"/>

<script>
    // Preview ảnh (giữ nguyên logic)
    (function () {
        const fileInput = document.getElementById('productImage');
        const previewImg = document.getElementById('productImagePreview');
        const placeholder = document.getElementById('imagePlaceholderIcon');

        if (fileInput) {
            fileInput.addEventListener('change', function () {
                const file = this.files && this.files[0];
                if (!file) {
                    if (previewImg) { previewImg.src = ''; previewImg.style.display = 'none'; }
                    if (placeholder) { placeholder.style.display = 'flex'; }
                    return;
                }
                const maxSize = 5 * 1024 * 1024;
                if (file.size > maxSize) { showNotification('Kích thước ảnh quá lớn. Vui lòng chọn ảnh nhỏ hơn 5MB.', 'warning', 'Cảnh báo'); this.value=''; return; }
                if (!file.type.match('image.*')) { showNotification('Vui lòng chọn file ảnh (JPG, PNG, GIF)', 'warning', 'Cảnh báo'); this.value=''; return; }

                const reader = new FileReader();
                reader.onload = function (e) {
                    if (previewImg) { previewImg.src = e.target.result; previewImg.style.display = 'block'; }
                    if (placeholder) { placeholder.style.display = 'none'; }
                };
                reader.readAsDataURL(file);
            });
        }
    })();
</script>

<style>
    /* Typography & rhythm giống trang details */
    .info-label{
        font-size:.85rem;font-weight:600;color:#5a5c69;margin-top:.75rem;margin-bottom:.25rem;
        text-transform:uppercase;letter-spacing:.5px
    }
    .info-value{font-size:1rem;color:#2c3e50;margin-bottom:.75rem;min-height:1.5rem}
    .card-header{font-weight:600}

    /* Image area */
    .product-image-container{padding:1rem}
    .placeholder-icon{width:140px;height:140px;background:#ebf2ff}
    .placeholder-icon i{line-height:140px}

    /* Căn chỉnh (NEW: spacer về 0 để canh hàng với cột trái) */
    .status-indent{padding-left:1.25rem}
    @media (min-width:768px){ .status-indent{padding-left:1.5rem} }
    .align-spacer{height:0 !important;} /* quan trọng: căn Giá bán = Tên SP, Stock = Danh mục */

    /* Focus */
    .form-control:focus,.form-select:focus{
        border-color:#4e73df;box-shadow:0 0 0 .2rem rgba(78,115,223,.25)
    }
    textarea{resize:vertical}
</style>
