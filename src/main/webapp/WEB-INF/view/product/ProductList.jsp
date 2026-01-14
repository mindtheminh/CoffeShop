<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<%
    String cPath = request.getContextPath();
    request.setAttribute("pageTitle", "Danh sách sản phẩm - Yen Coffee");
%>
<jsp:include page="/WEB-INF/view/layout/management/header.jsp"/>

<div id="wrapper">
  <jsp:include page="/WEB-INF/view/layout/management/sidebar.jsp"/>

  <div id="content-wrapper" class="d-flex flex-column">
    <div id="content">
      <jsp:include page="/WEB-INF/view/layout/management/navbar.jsp"/>

            <!-- Begin Page Content -->
            <div class="container-fluid">

                <!-- Page Heading -->
                <div class="d-sm-flex align-items-center justify-content-between mb-4">
                    <h1 class="h3 mb-0 text-gray-800">Danh sách sản phẩm</h1>
                    <div class="d-flex gap-2">
                        <a href="${pageContext.request.contextPath}/product-new" class="btn btn-primary btn-sm">
                            <i class="fas fa-plus"></i> Thêm sản phẩm mới
                        </a>
                        <a href="${pageContext.request.contextPath}/marketer-dashboard" class="btn btn-info btn-sm">
                            <i class="fas fa-chart-line"></i> Marketer Dashboard
                        </a>
                    </div>
                </div>

                <!-- Alerts -->
                <c:if test="${not empty sessionScope.success}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle me-2"></i>${sessionScope.success}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <c:remove var="success" scope="session"/>
                </c:if>
                <c:if test="${not empty sessionScope.error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-triangle me-2"></i>${sessionScope.error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <c:remove var="error" scope="session"/>
                </c:if>

                <!-- Filter Card -->
                <div class="card shadow mb-4">
                    <div class="card-header py-3 d-flex align-items-center">
                        <i class="fas fa-filter me-2"></i>
                        <h6 class="m-0 font-weight-bold text-primary">Tìm kiếm và lọc</h6>
                    </div>
                    <div class="card-body">
                        <form method="get" action="${pageContext.request.contextPath}/product-list" class="row g-3">
                            <div class="col-lg-3 col-md-6">
                                <label class="form-label">Tìm kiếm</label>
                                <input type="text" class="form-control" name="search"
                                       placeholder="Tên sản phẩm, mô tả..." value="${param.search}">
                            </div>

                            <div class="col-lg-2 col-md-6">
                                <label class="form-label">Danh mục</label>
                                <select class="form-select" name="category">
                                    <option value="">Tất cả</option>
                                    <option value="Cà phê" ${param.category == 'Cà phê' ? 'selected' : ''}>Cà phê</option>
                                    <option value="Trà" ${param.category == 'Trà' ? 'selected' : ''}>Trà</option>
                                    <option value="Trà sữa" ${param.category == 'Trà sữa' ? 'selected' : ''}>Trà sữa</option>
                                    <option value="Nước ép" ${param.category == 'Nước ép' ? 'selected' : ''}>Nước ép</option>
                                    <option value="Bánh ngọt" ${param.category == 'Bánh ngọt' ? 'selected' : ''}>Bánh ngọt</option>
                                    <option value="Khác" ${param.category == 'Khác' ? 'selected' : ''}>Khác</option>
                                </select>
                            </div>

                            <div class="col-lg-2 col-md-6">
                                <label class="form-label">Trạng thái</label>
                                <select class="form-select" name="status">
                                    <option value="">Tất cả</option>
                                    <option value="Activate" ${param.status == 'Activate' ? 'selected' : ''}>Hoạt động</option>
                                    <option value="Deactivate" ${param.status == 'Deactivate' ? 'selected' : ''}>Không hoạt động</option>
                                </select>
                            </div>

                            <div class="col-lg-2 col-md-6">
                                <label class="form-label">Bán chạy</label>
                                <select class="form-select" name="bestseller">
                                    <option value="">Tất cả</option>
                                    <option value="true" ${param.bestseller == 'true' ? 'selected' : ''}>Có</option>
                                    <option value="false" ${param.bestseller == 'false' ? 'selected' : ''}>Không</option>
                                </select>
                            </div>

                            <div class="col-lg-3 col-md-12 d-flex align-items-end gap-2">
                                <button type="submit" class="btn btn-primary flex-fill">
                                    <i class="fas fa-search"></i> Tìm kiếm
                                </button>
                                <a href="${pageContext.request.contextPath}/product-list" class="btn btn-outline-secondary">
                                    <i class="fas fa-times"></i> Xóa bộ lọc
                                </a>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Product Table -->
                <div class="card shadow mb-4">
                    <div class="card-header py-3 d-flex justify-content-between align-items-center">
                        <h6 class="m-0 font-weight-bold text-primary">
                            <i class="fas fa-coffee me-2"></i>Danh sách sản phẩm
                        </h6>
                        <span class="badge bg-primary">${totalItems != null ? totalItems : 0} sản phẩm</span>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${not empty products}">
                                <div class="table-responsive">
                                    <table class="table table-bordered table-hover" id="productsTable">
                                        <thead>
                                            <tr>
                                                <th class="sortable-column">ID</th>
                                                <th class="sortable-column">Tên sản phẩm</th>
                                                <th class="sortable-column">Danh mục</th>
                                                <th class="sortable-column">Giá</th>
                                                <th class="sortable-column">Bán chạy</th>
                                                <th class="sortable-column">Tồn kho</th>
                                                <th class="sortable-column">Trạng thái</th>
                                                <th>Hành động</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="product" items="${products}">
                                                <tr>
                                                    <td><span class="badge bg-secondary">${product.productId}</span></td>
                                                    <td>
                                                        <div class="d-flex align-items-center">
                                                            <c:if test="${not empty product.image_url}">
                                                                <img src="${product.image_url}" alt="${product.name}" 
                                                                     width="40" height="40" class="rounded me-2" style="object-fit: cover;">
                                                            </c:if>
                                                            <div>
                                                                <strong>${product.name}</strong><br>
                                                                <small class="text-muted">${product.description}</small>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td><span class="badge bg-info">${product.category}</span></td>
                                                    <td><fmt:formatNumber value="${product.price}" type="currency" currencySymbol="₫"/></td>
                                                    <td>
                                                        <c:if test="${product.is_bestseller}">
                                                            <span class="badge bg-warning text-dark"><i class="fas fa-star"></i> Bán chạy</span>
                                                        </c:if>
                                                        <c:if test="${!product.is_bestseller}">
                                                            <span class="badge bg-light text-muted">-</span>
                                                        </c:if>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${product.stock_quantity > 0}">
                                                                <span class="badge bg-success">${product.stock_quantity}</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-danger">Hết hàng</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${product.status == 'Activate'}">
                                                                <span class="badge bg-success">Hoạt động</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-secondary">Không hoạt động</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td class="text-center">
                                                        <div class="btn-group">
                                                            <a href="${pageContext.request.contextPath}/product-detail?id=${product.productId}" 
                                                               class="btn btn-sm btn-outline-info" title="Chi tiết">
                                                                <i class="fas fa-eye"></i>
                                                            </a>
                                                            <a href="${pageContext.request.contextPath}/product-detail?id=${product.productId}" 
                                                               class="btn btn-sm btn-outline-primary" title="Sửa">
                                                                <i class="fas fa-edit"></i>
                                                            </a>
                                                            <c:choose>
                                                                <c:when test="${product.status == 'Activate'}">
                                                                    <button type="button" class="btn btn-sm btn-outline-secondary"
                                                                            title="Ngừng hoạt động"
                                                                            onclick="toggleProductStatus('${product.productId}', '${product.name}', 'Activate')">
                                                                        <i class="fas fa-pause"></i>
                                                                    </button>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <button type="button" class="btn btn-sm btn-outline-success"
                                                                            title="Kích hoạt"
                                                                            onclick="toggleProductStatus('${product.productId}', '${product.name}', 'Deactivate')">
                                                                        <i class="fas fa-play"></i>
                                                                    </button>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-5">
                                    <i class="fas fa-coffee fa-4x text-muted mb-3"></i>
                                    <h5 class="text-muted mb-3">☕ Chưa có sản phẩm nào</h5>
                                    <p class="text-muted mb-4">Bắt đầu thêm sản phẩm đầu tiên của bạn ngay bây giờ.</p>
                                    <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#productModal" onclick="openProductModal()">
                                        <i class="fas fa-plus"></i> Thêm sản phẩm mới
                                    </button>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- Pagination PAGE/ hien thi tren trang --> 
                <c:if test="${totalPages > 1}">
                    <div class="card shadow mb-4">
                        <div class="card-body">
                            <nav aria-label="Product pagination">
                                <ul class="pagination justify-content-center mb-0">
                                    <!-- Previous Page -->
                                    <c:choose>
                                        <c:when test="${currentPage > 1}">
                                            <li class="page-item">
                                                <a class="page-link" href="${pageContext.request.contextPath}/product-list?page=${currentPage - 1}&search=${param.search}&category=${param.category}&status=${param.status}&bestseller=${param.bestseller}&sortColumn=${param.sortColumn}&sortDirection=${param.sortDirection}">
                                                    <i class="fas fa-chevron-left"></i>
                                                </a>
                                            </li>
                                        </c:when>
                                        <c:otherwise>
                                            <li class="page-item disabled">
                                                <span class="page-link"><i class="fas fa-chevron-left"></i></span>
                                            </li>
                                        </c:otherwise>
                                    </c:choose>

                                    <!-- Page Numbers -->
                                    <c:forEach begin="1" end="${totalPages}" var="pageNum">
                                        <c:choose>
                                            <c:when test="${pageNum == currentPage}">
                                                <li class="page-item active">
                                                    <span class="page-link">${pageNum}</span>
                                                </li>
                                            </c:when>
                                            <c:otherwise>
                                                <li class="page-item">
                                                    <a class="page-link" href="${pageContext.request.contextPath}/product-list?page=${pageNum}&search=${param.search}&category=${param.category}&status=${param.status}&bestseller=${param.bestseller}&sortColumn=${param.sortColumn}&sortDirection=${param.sortDirection}">${pageNum}</a>
                                                </li>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:forEach>

                                    <!-- Next Page -->
                                    <c:choose>
                                        <c:when test="${currentPage < totalPages}">
                                            <li class="page-item">
                                                <a class="page-link" href="${pageContext.request.contextPath}/product-list?page=${currentPage + 1}&search=${param.search}&category=${param.category}&status=${param.status}&bestseller=${param.bestseller}&sortColumn=${param.sortColumn}&sortDirection=${param.sortDirection}">
                                                    <i class="fas fa-chevron-right"></i>
                                                </a>
                                            </li>
                                        </c:when>
                                        <c:otherwise>
                                            <li class="page-item disabled">
                                                <span class="page-link"><i class="fas fa-chevron-right"></i></span>
                                            </li>
                                        </c:otherwise>
                                    </c:choose>
                                </ul>
                            </nav>
                            
                            <!-- Pagination Info -->
                            <div class="text-center mt-3">
                                <small class="text-muted">
                                    Hiển thị ${((currentPage - 1) * pageSize) + 1} - ${currentPage * pageSize > totalItems ? totalItems : currentPage * pageSize} 
                                    trong tổng số ${totalItems} sản phẩm
                                </small>
                            </div>
                        </div>
                    </div>
                </c:if>
            </div>
            <!-- End Page Content -->
        </div>

    <jsp:include page="/WEB-INF/view/layout/management/footer.jsp"/>
  </div>
</div>

<!-- Product Form Modal -->
<div class="modal fade" id="productModal" tabindex="-1" aria-labelledby="productModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-xl modal-dialog-scrollable">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="productModalLabel">
                    <i class="fas fa-${product != null ? 'edit' : 'plus-circle'} me-2"></i>
                    <span id="modalTitle">Thêm sản phẩm mới</span>
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form method="post" action="" id="productForm" enctype="multipart/form-data" novalidate>
                <input type="hidden" name="productId" id="formProductId">
                <div class="modal-body">
                    <div class="row g-4">
                        <!-- Cột trái -->
                        <div class="col-lg-6">
                            <!-- Tên sản phẩm -->
                            <div class="mb-3">
                                <label for="productName" class="form-label">
                                    <i class="fas fa-coffee text-primary me-1"></i>Tên sản phẩm <span class="text-danger">*</span>
                                </label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-coffee"></i></span>
                                    <input type="text" class="form-control" id="productName" name="productName" 
                                           placeholder="Nhập tên sản phẩm..." maxlength="255" required>
                                </div>
                                <div class="form-text">Tối đa 255 ký tự</div>
                            </div>

                            <!-- Danh mục -->
                            <div class="mb-3">
                                <label for="category" class="form-label">
                                    <i class="fas fa-tags text-primary me-1"></i>Danh mục <span class="text-danger">*</span>
                                </label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-tags"></i></span>
                                    <select class="form-select" id="category" name="category" required>
                                        <option value="">-- Chọn danh mục --</option>
                                        <option value="Cà phê">Cà phê</option>
                                        <option value="Trà">Trà</option>
                                        <option value="Trà sữa">Trà sữa</option>
                                        <option value="Nước ép">Nước ép</option>
                                        <option value="Bánh ngọt">Bánh ngọt</option>
                                        <option value="Khác">Khác</option>
                                    </select>
                                </div>
                            </div>

                            <!-- Giá bán -->
                            <div class="mb-3">
                                <label for="price" class="form-label">
                                    <i class="fas fa-dollar-sign text-primary me-1"></i>Giá bán <span class="text-danger">*</span>
                                </label>
                                <div class="input-group">
                                    <span class="input-group-text">₫</span>
                                    <input type="number" class="form-control" id="price" name="price" 
                                           placeholder="0.00" step="0.01" min="0" required>
                                </div>
                                <div class="form-text">Giá tính theo VND</div>
                            </div>

                            <!-- Số lượng tồn kho -->
                            <div class="mb-3">
                                <label for="stockQuantity" class="form-label">
                                    <i class="fas fa-boxes text-primary me-1"></i>Số lượng tồn kho <span class="text-danger">*</span>
                                </label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-boxes"></i></span>
                                    <input type="number" class="form-control" id="stockQuantity" name="stockQuantity" 
                                           placeholder="0" min="0" required value="0">
                                </div>
                                <div class="form-text">Số lượng hiện có trong kho</div>
                            </div>

                            <!-- Ảnh sản phẩm -->
                            <div class="mb-3">
                                <label for="productImage" class="form-label">
                                    <i class="fas fa-image text-primary me-1"></i>Ảnh sản phẩm
                                </label>
                                <input type="file" class="form-control" id="productImage" name="productImage" 
                                       accept="image/*" onchange="previewImageFile(this)">
                                <div class="form-text">Chọn ảnh từ máy tính (JPG, PNG, GIF). Kích thước tối đa: 5MB</div>

                                <!-- Current image (for edit mode) -->
                                <div id="currentImageContainer" class="mt-2" style="display: none;">
                                    <small class="text-muted">Ảnh hiện tại:</small><br>
                                    <img src="" alt="Current Image" id="currentImage" class="img-fluid rounded shadow-sm mt-1" 
                                         style="max-height: 150px; max-width: 100%;">
                                </div>

                                <!-- Preview ảnh -->
                                <div id="imagePreview" class="mt-3 text-center" style="display: none;">
                                    <small class="text-muted">Ảnh xem trước:</small><br>
                                    <img id="previewImg" src="" alt="Preview" class="img-fluid rounded shadow-sm mt-1" 
                                         style="max-height: 200px; max-width: 100%;">
                                    <div class="mt-2">
                                        <button type="button" class="btn btn-sm btn-outline-danger" onclick="clearImagePreview()">
                                            <i class="fas fa-times me-1"></i>Xóa ảnh đã chọn
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Cột phải -->
                        <div class="col-lg-6">
                            <!-- Trạng thái -->
                            <div class="mb-3">
                                <label class="form-label">
                                    <i class="fas fa-toggle-on text-primary me-1"></i>Trạng thái <span class="text-danger">*</span>
                                </label>
                                <div class="d-flex align-items-center flex-wrap gap-3">
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="radio" name="status" id="statusActive" value="Activate" required checked>
                                        <label class="form-check-label" for="statusActive">Hoạt động</label>
                                    </div>
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="radio" name="status" id="statusInactive" value="Deactivate" required>
                                        <label class="form-check-label" for="statusInactive">Không hoạt động</label>
                                    </div>
                                </div>
                            </div>

                            <!-- Đánh dấu là sản phẩm bán chạy -->
                            <div class="mb-3">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="isBestseller" name="isBestseller" value="true">
                                    <label class="form-check-label" for="isBestseller">
                                        <i class="fas fa-star text-warning me-1"></i>Đánh dấu là sản phẩm bán chạy
                                    </label>
                                </div>
                                <div class="form-text">Sản phẩm bán chạy sẽ được hiển thị nổi bật</div>
                            </div>

                            <!-- Mô tả sản phẩm -->
                            <div class="mb-3">
                                <label for="description" class="form-label">
                                    <i class="fas fa-align-left text-primary me-1"></i>Mô tả sản phẩm
                                </label>
                                <textarea class="form-control" id="description" name="description" rows="10" 
                                          placeholder="Mô tả chi tiết về sản phẩm..." 
                                          style="resize: vertical;"></textarea>
                                <div class="form-text">Mô tả ngắn gọn về sản phẩm</div>
                            </div>

                            <!-- Ghi chú -->
                            <div class="mb-3">
                                <label for="note" class="form-label">
                                    <i class="fas fa-sticky-note text-primary me-1"></i>Ghi chú
                                </label>
                                <textarea class="form-control" id="note" name="note" rows="6" placeholder="Ghi chú nội bộ (tùy chọn)"></textarea>
                                <div class="form-text">Liên kết cột note trong bảng products</div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                        <i class="fas fa-times me-1"></i>Hủy
                    </button>
                    <button type="reset" class="btn btn-outline-secondary" onclick="resetProductForm()">
                        <i class="fas fa-undo me-1"></i>Làm mới
                    </button>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save me-1"></i><span id="submitButtonText">Lưu sản phẩm</span>
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/view/layout/management/scripts.jsp"/>

<script>
// Modal và Form functions
function openProductModal() {
    resetProductForm();
    document.getElementById('productForm').action = '${pageContext.request.contextPath}/product-new';
    document.getElementById('modalTitle').textContent = 'Thêm sản phẩm mới';
    document.getElementById('submitButtonText').textContent = 'Lưu sản phẩm';
    document.getElementById('formProductId').value = '';
}

function editProductFromButton(button) {
    const productId = button.getAttribute('data-product-id');
    const name = button.getAttribute('data-product-name') || '';
    const category = button.getAttribute('data-product-category') || '';
    const price = button.getAttribute('data-product-price') || '';
    const stockQuantity = button.getAttribute('data-product-stock') || '0';
    const status = button.getAttribute('data-product-status') || 'Activate';
    const isBestseller = button.getAttribute('data-product-bestseller') === 'true';
    const description = button.getAttribute('data-product-description') || '';
    const note = button.getAttribute('data-product-note') || '';
    const imageUrl = button.getAttribute('data-product-image') || '';
    
    editProduct(productId, name, category, price, stockQuantity, status, isBestseller, description, note, imageUrl);
}

function editProduct(productId, name, category, price, stockQuantity, status, isBestseller, description, note, imageUrl) {
    document.getElementById('productForm').action = '${pageContext.request.contextPath}/product-edit';
    document.getElementById('modalTitle').textContent = 'Chỉnh sửa sản phẩm';
    document.getElementById('submitButtonText').textContent = 'Cập nhật sản phẩm';
    
    document.getElementById('formProductId').value = productId;
    document.getElementById('productName').value = name || '';
    document.getElementById('category').value = category || '';
    document.getElementById('price').value = price || '';
    document.getElementById('stockQuantity').value = stockQuantity || 0;
    
    // Set status radio
    if (status === 'Activate') {
        document.getElementById('statusActive').checked = true;
    } else {
        document.getElementById('statusInactive').checked = true;
    }
    
    // Set bestseller checkbox
    document.getElementById('isBestseller').checked = (isBestseller === 'true' || isBestseller === true);
    
    // Set description and note
    document.getElementById('description').value = description || '';
    document.getElementById('note').value = note || '';
    
    // Show current image if exists
    if (imageUrl && imageUrl.trim() !== '') {
        document.getElementById('currentImage').src = imageUrl;
        document.getElementById('currentImageContainer').style.display = 'block';
    } else {
        document.getElementById('currentImageContainer').style.display = 'none';
    }
    
    // Hide preview
    document.getElementById('imagePreview').style.display = 'none';
    
    // Show modal
    const modal = new bootstrap.Modal(document.getElementById('productModal'));
    modal.show();
}

function resetProductForm() {
    document.getElementById('productForm').reset();
    document.getElementById('formProductId').value = '';
    document.getElementById('currentImageContainer').style.display = 'none';
    document.getElementById('imagePreview').style.display = 'none';
    document.getElementById('productImage').value = '';
    document.getElementById('statusActive').checked = true;
    document.getElementById('isBestseller').checked = false;
}

function previewImageFile(input) {
    const preview = document.getElementById('imagePreview');
    const previewImg = document.getElementById('previewImg');
    const currentImageContainer = document.getElementById('currentImageContainer');
    
    if (input.files && input.files[0]) {
        const file = input.files[0];
        const maxSize = 5 * 1024 * 1024; // 5MB
        
        // Kiểm tra kích thước file
        if (file.size > maxSize) {
            showNotification('Kích thước ảnh quá lớn. Vui lòng chọn ảnh nhỏ hơn 5MB.', 'warning', 'Cảnh báo');
            input.value = '';
            preview.style.display = 'none';
            return;
        }
        
        // Kiểm tra loại file
        if (!file.type.match('image.*')) {
            showNotification('Vui lòng chọn file ảnh (JPG, PNG, GIF)', 'warning', 'Cảnh báo');
            input.value = '';
            preview.style.display = 'none';
            return;
        }
        
        const reader = new FileReader();
        reader.onload = function(e) {
            previewImg.src = e.target.result;
            preview.style.display = 'block';
            // Ẩn ảnh hiện tại nếu có
            if (currentImageContainer) {
                currentImageContainer.style.display = 'none';
            }
        };
        reader.readAsDataURL(file);
    } else {
        preview.style.display = 'none';
    }
}

function clearImagePreview() {
    const fileInput = document.getElementById('productImage');
    const preview = document.getElementById('imagePreview');
    
    if (fileInput) {
        fileInput.value = '';
    }
    preview.style.display = 'none';
    
    // Hiện lại ảnh hiện tại nếu đang ở edit mode
    const productId = document.getElementById('formProductId').value;
    if (productId && document.getElementById('currentImage').src) {
        document.getElementById('currentImageContainer').style.display = 'block';
    }
}

function deleteProduct(id, name) {
    showConfirm('Xóa sản phẩm "' + name + '"?', function() {
        const form = document.createElement('form');
        form.method = 'post';
        form.action = '${pageContext.request.contextPath}/product-delete';
        const input = document.createElement('input');
        input.type = 'hidden';
        input.name = 'id';
        input.value = id;
        form.appendChild(input);
        document.body.appendChild(form);
        form.submit();
    });
}

function toggleProductStatus(id, name, currentStatus) {
    const toStatus = currentStatus === 'Activate' ? 'Deactivate' : 'Activate';
    const confirmMsg = (toStatus === 'Deactivate')
        ? ('Ngừng hoạt động sản phẩm "' + name + '"?')
        : ('Kích hoạt sản phẩm "' + name + '"?');
    
    showConfirm(confirmMsg, function() {
        const form = document.createElement('form');
        form.method = 'post';
        form.action = '${pageContext.request.contextPath}/product/update-status';

        const idInput = document.createElement('input');
        idInput.type = 'hidden';
        idInput.name = 'productId';
        idInput.value = id;
        form.appendChild(idInput);

        const statusInput = document.createElement('input');
        statusInput.type = 'hidden';
        statusInput.name = 'status';
        statusInput.value = toStatus; // nếu backend toggle tự động thì bỏ dòng này
        form.appendChild(statusInput);

        document.body.appendChild(form);
        form.submit();
    });
}

// Form validation
document.getElementById('productForm').addEventListener('submit', function(e) {
    const requiredFields = ['productName', 'category', 'price', 'stockQuantity'];
    let isValid = true;
    
    requiredFields.forEach(function(fieldName) {
        const field = document.getElementById(fieldName);
        if (!field.value.trim()) {
            field.classList.add('is-invalid');
            isValid = false;
        } else {
            field.classList.remove('is-invalid');
        }
    });
    
    // Validate status radio buttons
    const statusChecked = document.querySelector('input[name="status"]:checked');
    if (!statusChecked) {
        isValid = false;
        document.getElementById('statusActive').classList.add('is-invalid');
        document.getElementById('statusInactive').classList.add('is-invalid');
    } else {
        document.getElementById('statusActive').classList.remove('is-invalid');
        document.getElementById('statusInactive').classList.remove('is-invalid');
    }
    
    // Validate image file if provided
    const imageInput = document.getElementById('productImage');
    if (imageInput && imageInput.files && imageInput.files[0]) {
        const file = imageInput.files[0];
        const maxSize = 5 * 1024 * 1024; // 5MB
        if (file.size > maxSize) {
            isValid = false;
            showNotification('Kích thước ảnh quá lớn. Vui lòng chọn ảnh nhỏ hơn 5MB.', 'warning', 'Cảnh báo');
        }
        if (!file.type.match('image.*')) {
            isValid = false;
            showNotification('Vui lòng chọn file ảnh hợp lệ (JPG, PNG, GIF).', 'warning', 'Cảnh báo');
        }
    }

    if (!isValid) {
        e.preventDefault();
        showNotification('Vui lòng nhập đầy đủ thông tin bắt buộc!', 'warning', 'Cảnh báo');
    }
});

// Real-time validation
document.querySelectorAll('#productForm input[required], #productForm select[required]').forEach(function(field) {
    field.addEventListener('blur', function() {
        if (this.type === 'radio') {
            const statusChecked = document.querySelector('input[name="status"]:checked');
            if (statusChecked) {
                document.getElementById('statusActive').classList.remove('is-invalid');
                document.getElementById('statusInactive').classList.remove('is-invalid');
            }
        } else if (!this.value.trim()) {
            this.classList.add('is-invalid');
        } else {
            this.classList.remove('is-invalid');
        }
    });
    
    field.addEventListener('input', function() {
        if (this.value.trim()) {
            this.classList.remove('is-invalid');
        }
    });
});

// Real-time validation for status radio buttons
document.querySelectorAll('input[name="status"]').forEach(function(radio) {
    radio.addEventListener('change', function() {
        if (document.querySelector('input[name="status"]:checked')) {
            document.getElementById('statusActive').classList.remove('is-invalid');
            document.getElementById('statusInactive').classList.remove('is-invalid');
        }
    });
});

// Reset modal when closed
document.getElementById('productModal').addEventListener('hidden.bs.modal', function() {
    resetProductForm();
});

// Custom sorting functionality
window.addEventListener('DOMContentLoaded', event => {
    const productsTable = document.getElementById('productsTable');
    if (productsTable) {
        const currentSortColumn = '<c:out value="${sortColumn}" default="" />';
        const currentSortDirection = '<c:out value="${sortDirection}" default="" />';
        
        // Custom sorting: detect clicks on sortable column headers
        const tableHeaders = productsTable.querySelectorAll('thead th.sortable-column');
        
        tableHeaders.forEach((header, index) => {
            header.style.cursor = 'pointer';
            header.style.userSelect = 'none';
            
            // Add sort icon
            if (!header.querySelector('.sort-icon')) {
                const sortIcon = document.createElement('span');
                sortIcon.className = 'sort-icon ms-2';
                sortIcon.innerHTML = '<i class="fas fa-sort"></i>';
                header.appendChild(sortIcon);
            }
            
            // Update icon if this is the current sort column
            if (currentSortColumn === index.toString()) {
                const sortIcon = header.querySelector('.sort-icon');
                if (sortIcon) {
                    if (currentSortDirection === 'asc') {
                        sortIcon.innerHTML = '<i class="fas fa-sort-up text-primary"></i>';
                    } else {
                        sortIcon.innerHTML = '<i class="fas fa-sort-down text-primary"></i>';
                    }
                }
            }
            
            header.addEventListener('click', function() {
                let newDirection = 'asc';
                if (currentSortColumn === index.toString()) {
                    // Same column, toggle direction
                    newDirection = currentSortDirection === 'asc' ? 'desc' : 'asc';
                }
                
                // Build URL with current filters and new sort parameters
                const params = new URLSearchParams(window.location.search);
                params.set('sortColumn', index.toString());
                params.set('sortDirection', newDirection);
                params.set('page', '1'); // Reset to first page when sorting
                
                // Reload page with new sort parameters
                window.location.href = window.location.pathname + '?' + params.toString();
            });
        });
    }
});
</script>

<style>
.form-control:focus, .form-select:focus {
    border-color: #5a5c69;
    box-shadow: 0 0 0 0.2rem rgba(90, 92, 105, 0.25);
}

.is-invalid {
    border-color: #e74a3b !important;
}

.form-check-input.is-invalid {
    border-color: #e74a3b !important;
    box-shadow: 0 0 0 0.2rem rgba(231, 74, 59, 0.25);
}

#imagePreview img {
    border: 2px solid #e3e6f0;
    transition: all 0.3s ease;
}

#imagePreview img:hover {
    transform: scale(1.05);
    border-color: #5a5c69;
}
</style>
