<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
    String cPath = request.getContextPath();
    request.setAttribute("pageTitle", "Danh sách cấu hình - Yen Coffee");
%>
<jsp:include page="/WEB-INF/view/layout/management/header.jsp"/>

<div id="wrapper">
  <jsp:include page="/WEB-INF/view/layout/management/sidebar.jsp"/>

  <div id="content-wrapper" class="d-flex flex-column">
    <div id="content">
      <jsp:include page="/WEB-INF/view/layout/management/navbar.jsp"/>

            <!-- Begin Page Content -->
            <div class="container-fluid" style="background-color:#f8f9fc; min-height:100vh;">

                <!-- Page Heading -->
                <div class="d-sm-flex align-items-center justify-content-between mb-4">
                    <h1 class="h3 mb-0 text-gray-800">
                        <i class="fas fa-cogs me-2"></i>Danh sách cấu hình
                    </h1>
                    <div class="d-flex gap-2">
                        <a href="${pageContext.request.contextPath}/setting-new" class="btn btn-primary btn-sm">
                            <i class="fas fa-plus"></i> Thêm cấu hình mới
                        </a>
                        <a href="${pageContext.request.contextPath}/admin-dashboard" class="btn btn-info btn-sm">
                            <i class="fas fa-chart-line"></i> Admin Dashboard
                        </a>
                    </div>
                </div>

                <!-- Alerts -->
                <c:if test="${not empty sessionScope.success}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle me-2"></i><c:out value="${sessionScope.success}"/>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <c:remove var="success" scope="session" />
                </c:if>
                <c:if test="${not empty sessionScope.error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-triangle me-2"></i><c:out value="${sessionScope.error}"/>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <c:remove var="error" scope="session" />
                </c:if>

                <!-- Filter Card -->
                <div class="card shadow mb-4">
                    <div class="card-header py-3 d-flex align-items-center">
                        <i class="fas fa-filter me-2"></i>
                        <h6 class="m-0 font-weight-bold text-primary">Tìm kiếm và lọc</h6>
                    </div>
                    <div class="card-body">
                        <form method="get" action="${pageContext.request.contextPath}/setting-list" class="row g-3">
                            <div class="col-lg-4 col-md-6">
                                <label class="form-label">Tìm kiếm</label>
                                <input type="text" class="form-control" name="search"
                                       placeholder="Tên, giá trị..." value="${param.search}">
                            </div>

                            <div class="col-lg-2 col-md-6">
                                <label class="form-label">Danh mục</label>
                                <select class="form-select" name="category">
                                    <option value="">Tất cả</option>
                                    <option value="General" ${param.category == 'General' ? 'selected' : ''}>Chung</option>
                                    <option value="Notification" ${param.category == 'Notification' ? 'selected' : ''}>Thông báo</option>
                                    <option value="Delivery" ${param.category == 'Delivery' ? 'selected' : ''}>Giao hàng</option>
                                    <option value="Finance" ${param.category == 'Finance' ? 'selected' : ''}>Tài chính</option>
                                    <option value="Operation" ${param.category == 'Operation' ? 'selected' : ''}>Vận hành</option>
                                    <option value="Reservation" ${param.category == 'Reservation' ? 'selected' : ''}>Đặt chỗ</option>
                                </select>
                            </div>

                            <div class="col-lg-2 col-md-6">
                                <label class="form-label">Trạng thái</label>
                                <select class="form-select" name="status">
                                    <option value="">Tất cả</option>
                                    <option value="Active" ${param.status == 'Active' ? 'selected' : ''}>Hoạt động</option>
                                    <option value="Inactive" ${param.status == 'Inactive' ? 'selected' : ''}>Không hoạt động</option>
                                </select>
                            </div>

                            <div class="col-lg-2 col-md-6">
                                <label class="form-label">Sắp xếp</label>
                                <select class="form-select" name="sort">
                                    <option value="name_asc" ${param.sort == 'name_asc' ? 'selected' : ''}>Tên A-Z</option>
                                    <option value="name_desc" ${param.sort == 'name_desc' ? 'selected' : ''}>Tên Z-A</option>
                                    <option value="category_asc" ${param.sort == 'category_asc' ? 'selected' : ''}>Danh mục A-Z</option>
                                    <option value="status_asc" ${param.sort == 'status_asc' ? 'selected' : ''}>Trạng thái</option>
                                </select>
                            </div>

                            <div class="col-lg-2 col-md-12 d-flex align-items-end gap-2">
                                <button type="submit" class="btn btn-primary flex-fill">
                                    <i class="fas fa-search"></i> Tìm kiếm
                                </button>
                                <a href="${pageContext.request.contextPath}/setting-list" class="btn btn-outline-secondary">
                                    <i class="fas fa-times"></i> Xóa bộ lọc
                                </a>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Settings Table -->
                <div class="card shadow mb-4">
                    <div class="card-header py-3 d-flex justify-content-between align-items-center">
                        <h6 class="m-0 font-weight-bold text-primary">
                            <i class="fas fa-cogs me-2"></i>Danh sách cấu hình
                        </h6>
                        <span class="badge bg-primary">${settingList != null ? settingList.size() : 0} cấu hình</span>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${not empty settingList}">
                                <div class="table-responsive">
                                    <table class="table table-bordered table-striped table-hover" id="settingsTable">
                                        <thead class="table-dark">
                                            <tr>
                                                <th>ID</th>
                                                <th>Tên cấu hình</th>
                                                <th>Giá trị</th>
                                                <th>Kiểu dữ liệu</th>
                                                <th>Danh mục</th>
                                                <th>Trạng thái</th>
                                                <th>Hành động</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="s" items="${settingList}">
                                                <tr>
                                                    <td><span class="badge bg-secondary">#${s.settingId}</span></td>
                                                    <td>
                                                        <div class="d-flex align-items-center">
                                                            <div style="width: 40px; height: 40px; background: linear-gradient(135deg, #4e73df 0%, #224abe 100%); color: white; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin-right: 12px; flex-shrink: 0;">
                                                                <i class="fas fa-cog"></i>
                                                            </div>
                                                            <div>
                                                                <strong><c:out value="${s.name}"/></strong>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td><code class="text-dark"><c:out value="${s.value}"/></code></td>
                                                    <td>
                                                        <span class="badge bg-info">
                                                            <c:out value="${s.datatype}"/>
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <span class="badge bg-primary">
                                                            <c:choose>
                                                                <c:when test="${s.category == 'General'}">Chung</c:when>
                                                                <c:when test="${s.category == 'Notification'}">Thông báo</c:when>
                                                                <c:when test="${s.category == 'Delivery'}">Giao hàng</c:when>
                                                                <c:when test="${s.category == 'Finance'}">Tài chính</c:when>
                                                                <c:when test="${s.category == 'Operation'}">Vận hành</c:when>
                                                                <c:when test="${s.category == 'Reservation'}">Đặt chỗ</c:when>
                                                                <c:otherwise><c:out value="${s.category}"/></c:otherwise>
                                                            </c:choose>
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${fn:toLowerCase(s.status) == 'active'}">
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
                                                    </td>
                                                    <td class="text-center">
                                                        <div class="btn-group">
                                                            <a href="${pageContext.request.contextPath}/setting-detail?id=${s.settingId}" 
                                                               class="btn btn-sm btn-outline-info" 
                                                               data-bs-toggle="tooltip" 
                                                               data-bs-placement="top" 
                                                               title="Xem chi tiết">
                                                                <i class="fas fa-eye"></i>
                                                            </a>
                                                            <c:choose>
                                                                <c:when test="${fn:toLowerCase(s.status) == 'active'}">
                                                                    <button type="button" class="btn btn-sm btn-outline-secondary"
                                                                            data-bs-toggle="tooltip" 
                                                                            data-bs-placement="top" 
                                                                            title="Ngừng hoạt động"
                                                                            onclick="toggleSettingStatus('${s.settingId}', '<c:out value="${s.name}"/>', 'Active')">
                                                                        <i class="fas fa-pause"></i>
                                                                    </button>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <button type="button" class="btn btn-sm btn-outline-success"
                                                                            data-bs-toggle="tooltip" 
                                                                            data-bs-placement="top" 
                                                                            title="Kích hoạt"
                                                                            onclick="toggleSettingStatus('${s.settingId}', '<c:out value="${s.name}"/>', 'Inactive')">
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
                                    <i class="fas fa-cogs fa-4x text-muted mb-3"></i>
                                    <h5 class="text-muted mb-3">Chưa có cấu hình nào</h5>
                                    <p class="text-muted mb-4">Bắt đầu thêm cấu hình đầu tiên của bạn ngay bây giờ.</p>
                                    <a href="${pageContext.request.contextPath}/setting-new" class="btn btn-primary">
                                        <i class="fas fa-plus"></i> Thêm cấu hình mới
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
                            <nav aria-label="Setting pagination">
                                <ul class="pagination justify-content-center mb-0">
                                    <!-- Previous Page -->
                                    <c:choose>
                                        <c:when test="${currentPage > 1}">
                                            <li class="page-item">
                                                <a class="page-link" href="${pageContext.request.contextPath}/setting-list?page=${currentPage - 1}&search=${param.search}&category=${param.category}&status=${param.status}&sortColumn=${param.sortColumn}&sortDirection=${param.sortDirection}">
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
                                    <c:forEach var="i" begin="1" end="${totalPages}">
                                        <c:choose>
                                            <c:when test="${i == currentPage}">
                                                <li class="page-item active">
                                                    <span class="page-link">${i}</span>
                                                </li>
                                            </c:when>
                                            <c:when test="${i <= 3 || i > totalPages - 3 || (i >= currentPage - 1 && i <= currentPage + 1)}">
                                                <li class="page-item">
                                                    <a class="page-link" href="${pageContext.request.contextPath}/setting-list?page=${i}&search=${param.search}&category=${param.category}&status=${param.status}&sortColumn=${param.sortColumn}&sortDirection=${param.sortDirection}">${i}</a>
                                                </li>
                                            </c:when>
                                            <c:when test="${i == 4 || i == totalPages - 3}">
                                                <li class="page-item disabled">
                                                    <span class="page-link">...</span>
                                                </li>
                                            </c:when>
                                        </c:choose>
                                    </c:forEach>

                                    <!-- Next Page -->
                                    <c:choose>
                                        <c:when test="${currentPage < totalPages}">
                                            <li class="page-item">
                                                <a class="page-link" href="${pageContext.request.contextPath}/setting-list?page=${currentPage + 1}&search=${param.search}&category=${param.category}&status=${param.status}&sortColumn=${param.sortColumn}&sortDirection=${param.sortDirection}">
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
                                    trong tổng số ${totalItems} cấu hình
                                </small>
                            </div>
                        </div>
                    </div>
                </c:if>
            </div>
            <!-- End Page Content -->
        </div> <!-- End of Content -->
    <jsp:include page="/WEB-INF/view/layout/management/footer.jsp"/>
  </div>
</div>

<jsp:include page="/WEB-INF/view/layout/management/scripts.jsp"/>

<script>
function toggleSettingStatus(settingId, settingName, currentStatus) {
    const toStatus = (currentStatus === 'Active' || currentStatus === 'ACTIVE') ? 'Inactive' : 'Active';
    const confirmMsg = (toStatus === 'Inactive')
        ? ('Ngừng hoạt động cấu hình "' + settingName + '"?')
        : ('Kích hoạt cấu hình "' + settingName + '"?');
    showConfirm(confirmMsg, function() {
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = '${pageContext.request.contextPath}/setting/toggle-status';

        const idInput = document.createElement('input');
        idInput.type = 'hidden';
        idInput.name = 'id';
        idInput.value = settingId;
        form.appendChild(idInput);

        const statusInput = document.createElement('input');
        statusInput.type = 'hidden';
        statusInput.name = 'status';
        statusInput.value = toStatus;
        form.appendChild(statusInput);

        document.body.appendChild(form);
        form.submit();
    });
}

// Initialize tooltips
document.addEventListener('DOMContentLoaded', function() {
    const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });
});
</script>

<style>
.table-hover tbody tr:hover {
    background-color: rgba(78, 115, 223, 0.05);
}
</style>
</body>
</html>
