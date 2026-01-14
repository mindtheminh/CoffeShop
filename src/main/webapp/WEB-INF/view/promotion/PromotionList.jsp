<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<%
    String cPath = request.getContextPath();
    request.setAttribute("pageTitle", "Danh sách khuyến mãi - Yen Coffee");
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
                    <h1 class="h3 mb-0 text-gray-800">Danh sách khuyến mãi</h1>
                    <div class="d-flex gap-2">
                        <a href="${pageContext.request.contextPath}/promotion-new" class="btn btn-primary btn-sm">
                            <i class="fas fa-plus"></i> Thêm khuyến mãi mới
                        </a>
                        <a href="${pageContext.request.contextPath}/marketer-dashboard" class="btn btn-info btn-sm">
                            <i class="fas fa-chart-line"></i> Marketer Dashboard
                        </a>
                    </div>
                </div>

                <!-- Filter Card -->
                <div class="card shadow mb-4">
                    <div class="card-header py-3 d-flex align-items-center">
                        <i class="fas fa-filter me-2"></i>
                        <h6 class="m-0 font-weight-bold text-primary">Tìm kiếm và lọc</h6>
                    </div>
                    <div class="card-body">
                        <form method="get" action="${pageContext.request.contextPath}/promotion-list" class="row g-3">
                            <div class="col-lg-3 col-md-6">
                                <label class="form-label">Tìm kiếm</label>
                                <input type="text" class="form-control" name="search"
                                       placeholder="Tên khuyến mãi, mã code..." value="${param.search}">
                            </div>

                            <div class="col-lg-2 col-md-6">
                                <label class="form-label">Loại khuyến mãi</label>
                                <select class="form-select" name="type">
                                    <option value="">Tất cả</option>
                                    <option value="percentage" ${param.type == 'percentage' ? 'selected' : ''}>Phần trăm (%)</option>
                                    <option value="fixed_amount" ${param.type == 'fixed_amount' ? 'selected' : ''}>Số tiền cố định</option>
                                    <option value="free_shipping" ${param.type == 'free_shipping' ? 'selected' : ''}>Miễn phí ship</option>
                                </select>
                            </div>

                            <div class="col-lg-2 col-md-6">
                                <label class="form-label">Trạng thái</label>
                                <select class="form-select" name="status">
                                    <option value="">Tất cả</option>
                                    <option value="Activate" ${param.status == 'Activate' ? 'selected' : ''}>Hoạt động</option>
                                    <option value="Deactivate" ${param.status == 'Deactivate' ? 'selected' : ''}>Không hoạt động</option>
                                    <option value="Expired" ${param.status == 'Expired' ? 'selected' : ''}>Đã hết hạn</option>
                                    <option value="Upcoming" ${param.status == 'Upcoming' ? 'selected' : ''}>Sắp diễn ra</option>
                                </select>
                            </div>

                            <div class="col-lg-2 col-md-6">
                                <label class="form-label">Áp dụng</label>
                                <select class="form-select" name="applyToAll">
                                    <option value="">Tất cả</option>
                                    <option value="true" ${param.applyToAll == 'true' ? 'selected' : ''}>Toàn bộ</option>
                                    <option value="false" ${param.applyToAll == 'false' ? 'selected' : ''}>Sản phẩm cụ thể</option>
                                </select>
                            </div>

                            <div class="col-lg-3 col-md-12 d-flex align-items-end gap-2">
                                <button type="submit" class="btn btn-primary flex-fill">
                                    <i class="fas fa-search"></i> Tìm kiếm
                                </button>
                                <a href="${pageContext.request.contextPath}/promotion-list" class="btn btn-outline-secondary">
                                    <i class="fas fa-times"></i> Xóa bộ lọc
                                </a>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Promotion Table -->
                <div class="card shadow mb-4">
                    <div class="card-header py-3 d-flex justify-content-between align-items-center">
                        <h6 class="m-0 font-weight-bold text-primary">
                            <i class="fas fa-tags me-2"></i>Danh sách khuyến mãi
                        </h6>
                        <span class="badge bg-primary">${totalItems != null ? totalItems : 0} khuyến mãi</span>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${not empty promotionList}">
                                <div class="table-responsive">
                                    <table class="table table-bordered table-hover" id="datatablesSimple">
                                        <thead class="table-dark">
                                            <tr>
                                                <th>ID</th>
                                                <th>Mã Code</th>
                                                <th>Tên khuyến mãi</th>
                                                <th>Loại</th>
                                                <th>Giá trị</th>
                                                <th>Trạng thái</th>
                                                <th>Ngày bắt đầu</th>
                                                <th>Ngày kết thúc</th>
                                                <th>Hành động</th>
                                            </tr>
                                        </thead>
                                        <tfoot>
                                            <tr>
                                                <th>ID</th>
                                                <th>Mã Code</th>
                                                <th>Tên khuyến mãi</th>
                                                <th>Loại</th>
                                                <th>Giá trị</th>
                                                <th>Trạng thái</th>
                                                <th>Ngày bắt đầu</th>
                                                <th>Ngày kết thúc</th>
                                                <th>Hành động</th>
                                            </tr>
                                        </tfoot>
                                        <tbody>
                                            <c:forEach var="promotion" items="${promotionList}">
                                                <tr>
                                                    <td><span class="badge bg-secondary">${promotion.promotionId}</span></td>
                                                    <td>
                                                        <span class="badge bg-info">${promotion.code}</span>
                                                    </td>
                                                    <td>
                                                        <strong>${promotion.name}</strong><br>
                                                        <small class="text-muted">${promotion.description}</small>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${promotion.type == 'percentage'}">
                                                                <span class="badge bg-info">Phần trăm (%)</span>
                                                            </c:when>
                                                            <c:when test="${promotion.type == 'fixed_amount'}">
                                                                <span class="badge bg-success">Cố định</span>
                                                            </c:when>
                                                            <c:when test="${promotion.type == 'free_shipping'}">
                                                                <span class="badge bg-primary">Free Ship</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-secondary">${promotion.type}</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${promotion.type == 'percentage'}">
                                                                <strong class="text-success">
                                                                    <fmt:formatNumber value="${promotion.value}" type="number" maxFractionDigits="0"/>%
                                                                </strong>
                                                            </c:when>
                                                            <c:when test="${promotion.type == 'fixed_amount'}">
                                                                <fmt:formatNumber value="${promotion.value}" type="currency" currencySymbol="₫"/>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="text-muted">-</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${promotion.status == 'Activate' || promotion.status == 'active'}">
                                                                <span class="badge bg-success">Hoạt động</span>
                                                            </c:when>
                                                            <c:when test="${promotion.status == 'Deactivate' || promotion.status == 'inactive'}">
                                                                <span class="badge bg-secondary">Không hoạt động</span>
                                                            </c:when>
                                                            <c:when test="${promotion.status == 'Expired' || promotion.status == 'expired'}">
                                                                <span class="badge bg-danger">Đã hết hạn</span>
                                                            </c:when>
                                                            <c:when test="${promotion.status == 'Upcoming' || promotion.status == 'upcoming'}">
                                                                <span class="badge bg-warning text-dark">Sắp diễn ra</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-secondary">${promotion.status}</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${promotion.startDate != null}">
                                                                <fmt:formatDate value="${promotion.startDate}" pattern="dd/MM/yyyy"/>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="text-muted">-</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${promotion.endDate != null}">
                                                                <fmt:formatDate value="${promotion.endDate}" pattern="dd/MM/yyyy"/>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="text-muted">-</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td class="text-center">
                                                        <div class="btn-group">
                                                            <a href="${pageContext.request.contextPath}/promotion-detail?id=${promotion.promotionId}" 
                                                               class="btn btn-sm btn-outline-info" title="Chi tiết">
                                                                <i class="fas fa-eye"></i>
                                                            </a>
                                                            <c:choose>
                                                                <c:when test="${promotion.status == 'Activate'}">
                                                                    <button type="button" class="btn btn-sm btn-outline-secondary"
                                                                            title="Ngừng hoạt động"
                                                                            onclick="togglePromotionStatus('${promotion.promotionId}', '${promotion.name}', 'Activate')">
                                                                        <i class="fas fa-pause"></i>
                                                                    </button>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <button type="button" class="btn btn-sm btn-outline-success"
                                                                            title="Kích hoạt"
                                                                            onclick="togglePromotionStatus('${promotion.promotionId}', '${promotion.name}', 'Deactivate')">
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
                                    <i class="fas fa-tags fa-4x text-muted mb-3"></i>
                                    <h5 class="text-muted mb-3">🏷️ Chưa có khuyến mãi nào</h5>
                                    <p class="text-muted mb-4">Bắt đầu thêm khuyến mãi đầu tiên của bạn ngay bây giờ.</p>
                                    <a href="${pageContext.request.contextPath}/promotion-new" class="btn btn-primary">
                                        <i class="fas fa-plus"></i> Thêm khuyến mãi mới
                                    </a>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- Pagination -->
                <c:if test="${totalPages > 1}">
                    <div class="card shadow mb-4">
                        <div class="card-body">
                            <nav aria-label="Promotion pagination">
                                <ul class="pagination justify-content-center mb-0">
                                    <!-- Previous Page -->
                                    <c:choose>
                                        <c:when test="${currentPage > 1}">
                                            <li class="page-item">
                                                <a class="page-link" href="${pageContext.request.contextPath}/promotion-list?page=${currentPage - 1}&search=${param.search}&status=${param.status}&type=${param.type}&sortColumn=${param.sortColumn}&sortDirection=${param.sortDirection}">
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
                                                    <a class="page-link" href="${pageContext.request.contextPath}/promotion-list?page=${pageNum}&search=${param.search}&status=${param.status}&type=${param.type}&sortColumn=${param.sortColumn}&sortDirection=${param.sortDirection}">${pageNum}</a>
                                                </li>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:forEach>

                                    <!-- Next Page -->
                                    <c:choose>
                                        <c:when test="${currentPage < totalPages}">
                                            <li class="page-item">
                                                <a class="page-link" href="${pageContext.request.contextPath}/promotion-list?page=${currentPage + 1}&search=${param.search}&status=${param.status}&type=${param.type}&sortColumn=${param.sortColumn}&sortDirection=${param.sortDirection}">
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
                                    trong tổng số ${totalItems} khuyến mãi
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

<!-- Hidden Toggle Status Form -->
<form id="togglePromotionStatusForm" action="${pageContext.request.contextPath}/promotion/toggle-status" method="post" style="display: none;">
    <input type="hidden" name="promotionId" id="togglePromotionId" value="">
    <input type="hidden" name="status" id="togglePromotionStatus" value="">
</form>

<jsp:include page="/WEB-INF/view/layout/management/scripts.jsp"/>

<!-- Simple DataTables Script -->
<script src="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/umd/simple-datatables.min.js" crossorigin="anonymous"></script>

<style>
/* Ẩn các phần không cần thiết của Simple-DataTables */
.datatable-wrapper .datatable-top,
.datatable-wrapper .datatable-bottom {
    display: none !important;
}
</style>

<script>
    // Initialize Simple DataTables when page loads
    window.addEventListener('DOMContentLoaded', event => {
        // Simple-DataTables
        // https://github.com/fiduswriter/Simple-DataTables/wiki
        const datatablesSimple = document.getElementById('datatablesSimple');
        if (datatablesSimple) {
            // Disable default sorting, handle manually for server-side sorting
            const dataTable = new simpleDatatables.DataTable(datatablesSimple, {
                perPage: 1000, // Hiển thị tất cả để không có pagination
                perPageSelect: false, // Ẩn dropdown per page
                searchable: false, // Ẩn tìm kiếm
                sortable: false, // Tắt sorting của Simple-DataTables, sẽ tự implement
                labels: {
                    noRows: "Không tìm thấy bản ghi nào",
                    info: ""
                }
            });
            
            // Wait for table to be rendered, then add custom sorting
            setTimeout(() => {
                const currentSortColumn = '<c:out value="${sortColumn}" default="" />';
                const currentSortDirection = '<c:out value="${sortDirection}" default="" />';
                
                // Custom sorting: detect clicks on sortable column headers
                const tableHeaders = datatablesSimple.querySelectorAll('thead th');
                
                tableHeaders.forEach((header, index) => {
                    if (index === 8) return; // Skip action column
                    
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
            }, 100);
        }
    });

    // Toggle Promotion Status Function
    function togglePromotionStatus(promotionId, promotionName, currentStatus) {
        const toStatus = currentStatus === 'Activate' ? 'Deactivate' : 'Activate';
        const confirmMsg = (toStatus === 'Deactivate') ?
            ('Ngừng hoạt động khuyến mãi "' + promotionName + '"?') :
            ('Kích hoạt khuyến mãi "' + promotionName + '"?');
        
        showConfirm(confirmMsg, function() {
            document.getElementById('togglePromotionId').value = promotionId;
            document.getElementById('togglePromotionStatus').value = toStatus;
            document.getElementById('togglePromotionStatusForm').submit();
        });
    }
</script>
