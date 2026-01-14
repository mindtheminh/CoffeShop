<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<%
    String cPath = request.getContextPath();
    request.setAttribute("pageTitle", "Danh sách người dùng - Yen Coffee");
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
                        <i class="fas fa-users me-2"></i>Danh sách người dùng
                    </h1>
                    <div class="d-flex gap-2">
                        <a href="${pageContext.request.contextPath}/user-new" class="btn btn-primary btn-sm">
                            <i class="fas fa-plus"></i> Thêm người dùng mới
                        </a>
                        <a href="${pageContext.request.contextPath}/hr-dashboard" class="btn btn-info btn-sm">
                            <i class="fas fa-chart-line"></i> HR Dashboard
                        </a>
                    </div>
                </div>

                <!-- Alerts -->
                <c:if test="${not empty param.success}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle me-2"></i>${param.success}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-triangle me-2"></i>${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <!-- Filter Card -->
                <div class="card shadow mb-4">
                    <div class="card-header py-3 d-flex align-items-center">
                        <i class="fas fa-filter me-2"></i>
                        <h6 class="m-0 font-weight-bold text-primary">Tìm kiếm và lọc</h6>
                    </div>
                    <div class="card-body">
                        <form method="get" action="${pageContext.request.contextPath}/user-list" class="row g-3">
                            <div class="col-lg-3 col-md-6">
                                <label class="form-label">Tìm kiếm</label>
                                <input type="text" class="form-control" name="search"
                                       placeholder="Tên, email..." value="${param.search}">
                            </div>

                            <div class="col-lg-2 col-md-6">
                                <label class="form-label">Vai trò</label>
                                <select class="form-select" name="role">
                                    <option value="">Tất cả</option>
                                    <option value="ADMIN" ${param.role == 'ADMIN' ? 'selected' : ''}>Admin</option>
                                    <option value="HR" ${param.role == 'HR' ? 'selected' : ''}>HR</option>
                                    <option value="MARKETER" ${param.role == 'MARKETER' ? 'selected' : ''}>Marketer</option>
                                    <option value="CASHIER" ${param.role == 'CASHIER' ? 'selected' : ''}>Cashier</option>
                                    <option value="STAFF" ${param.role == 'STAFF' ? 'selected' : ''}>Staff</option>
                                    <option value="CUSTOMER" ${param.role == 'CUSTOMER' ? 'selected' : ''}>Customer</option>
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
                                    <option value="created_at_desc" ${param.sort == 'created_at_desc' ? 'selected' : ''}>Mới nhất</option>
                                    <option value="created_at_asc" ${param.sort == 'created_at_asc' ? 'selected' : ''}>Cũ nhất</option>
                                    <option value="name_asc" ${param.sort == 'name_asc' ? 'selected' : ''}>Tên A-Z</option>
                                    <option value="name_desc" ${param.sort == 'name_desc' ? 'selected' : ''}>Tên Z-A</option>
                                </select>
                            </div>

                            <div class="col-lg-3 col-md-12 d-flex align-items-end gap-2">
                                <button type="submit" class="btn btn-primary flex-fill">
                                    <i class="fas fa-search"></i> Tìm kiếm
                                </button>
                                <a href="${pageContext.request.contextPath}/user-list" class="btn btn-outline-secondary">
                                    <i class="fas fa-times"></i> Xóa bộ lọc
                                </a>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Users Table -->
                <div class="card shadow mb-4">
                    <div class="card-header py-3 d-flex justify-content-between align-items-center">
                        <h6 class="m-0 font-weight-bold text-primary">
                            <i class="fas fa-users me-2"></i>Danh sách người dùng
                        </h6>
                        <span class="badge bg-primary">${users != null ? users.size() : 0} người dùng</span>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${not empty users}">
                                <div class="table-responsive">
                                    <table class="table table-bordered table-hover" id="usersTable">
                                        <thead>
                                            <tr>
                                                <th class="sortable-column">ID</th>
                                                <th class="sortable-column">Tên người dùng</th>
                                                <th class="sortable-column">Email</th>
                                                <th class="sortable-column">Vai trò</th>
                                                <th class="sortable-column">Trạng thái</th>
                                                <th>Hành động</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="user" items="${users}">
                                                <tr>
                                                    <td><span class="badge bg-secondary">#${user.userId}</span></td>
                                                    <td>
                                                        <div class="d-flex align-items-center">
                                                            <div style="width: 40px; height: 40px; background: linear-gradient(135deg, #4e73df 0%, #224abe 100%); color: white; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin-right: 12px; flex-shrink: 0;">
                                                                <i class="fas fa-user"></i>
                                                            </div>
                                                            <div>
                                                                <strong>${user.fullName}</strong>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td><small class="text-muted">${user.email}</small></td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${user.role == 'ADMIN'}">
                                                                <span class="badge bg-danger">Admin</span>
                                                            </c:when>
                                                            <c:when test="${user.role == 'HR'}">
                                                                <span class="badge bg-success">HR</span>
                                                            </c:when>
                                                            <c:when test="${user.role == 'MARKETER'}">
                                                                <span class="badge bg-warning text-dark">Marketer</span>
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
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${user.status == 'Active' || user.status == 'ACTIVE' || user.status == 'Activate'}">
                                                                <span class="badge bg-success">
                                                                    <i class="fas fa-check-circle"></i> Hoạt động
                                                                </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-secondary">
                                                                    <i class="fas fa-ban"></i> Không hoạt động
                                                                </span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td class="text-center">
                                                        <div class="btn-group">
                                                            <a href="${pageContext.request.contextPath}/user-detail?id=${user.userId}" 
                                                               class="btn btn-sm btn-outline-info" title="Chi tiết">
                                                                <i class="fas fa-eye"></i>
                                                            </a>
                                                            <c:choose>
                                                                <c:when test="${user.status == 'Active' || user.status == 'ACTIVE' || user.status == 'Activate'}">
                                                                    <button type="button" class="btn btn-sm btn-outline-secondary"
                                                                            title="Ngừng hoạt động"
                                                                            onclick="toggleUserStatus(${user.userId}, '${user.fullName}', 'Active')">
                                                                        <i class="fas fa-pause"></i>
                                                                    </button>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <button type="button" class="btn btn-sm btn-outline-success"
                                                                            title="Kích hoạt"
                                                                            onclick="toggleUserStatus(${user.userId}, '${user.fullName}', 'Inactive')">
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
                                    <i class="fas fa-users fa-4x text-muted mb-3"></i>
                                    <h5 class="text-muted mb-3">👥 Chưa có người dùng nào</h5>
                                    <p class="text-muted mb-4">Bắt đầu thêm người dùng đầu tiên của bạn ngay bây giờ.</p>
                                    <a href="${pageContext.request.contextPath}/user-new" class="btn btn-primary">
                                        <i class="fas fa-plus"></i> Thêm người dùng mới
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
                            <nav aria-label="User pagination">
                                <ul class="pagination justify-content-center mb-0">
                                    <!-- Previous Page -->
                                    <c:choose>
                                        <c:when test="${currentPage > 1}">
                                            <li class="page-item">
                                                <a class="page-link" href="${pageContext.request.contextPath}/user-list?page=${currentPage - 1}&search=${param.search}&role=${param.role}&status=${param.status}&sortColumn=${param.sortColumn}&sortDirection=${param.sortDirection}">
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
                                                    <a class="page-link" href="${pageContext.request.contextPath}/user-list?page=${i}&search=${param.search}&role=${param.role}&status=${param.status}&sortColumn=${param.sortColumn}&sortDirection=${param.sortDirection}">${i}</a>
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
                                                <a class="page-link" href="${pageContext.request.contextPath}/user-list?page=${currentPage + 1}&search=${param.search}&role=${param.role}&status=${param.status}&sortColumn=${param.sortColumn}&sortDirection=${param.sortDirection}">
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
                                    trong tổng số ${totalItems} người dùng
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

<jsp:include page="/WEB-INF/view/layout/management/scripts.jsp"/>

<script>
function toggleUserStatus(userId, userName, currentStatus) {
    const toStatus = (currentStatus === 'Active' || currentStatus === 'ACTIVE' || currentStatus === 'Activate') ? 'Inactive' : 'Active';
    const confirmMsg = (toStatus === 'Inactive')
        ? ('Ngừng hoạt động người dùng "' + userName + '"?')
        : ('Kích hoạt người dùng "' + userName + '"?');
    const subMsg = (toStatus === 'Inactive')
        ? ('Người dùng này sẽ không thể đăng nhập hoặc thực hiện giao dịch nữa.')
        : ('Người dùng này sẽ có thể đăng nhập và sử dụng hệ thống bình thường.');
    
    showConfirm(confirmMsg, function() {
        const form = document.createElement('form');
        form.method = 'post';
        form.action = '${pageContext.request.contextPath}/user/toggle-status';

        const idInput = document.createElement('input');
        idInput.type = 'hidden';
        idInput.name = 'id';
        idInput.value = userId;
        form.appendChild(idInput);

        document.body.appendChild(form);
        form.submit();
    }, null, subMsg);
}

// Custom sorting functionality
window.addEventListener('DOMContentLoaded', event => {
    const usersTable = document.getElementById('usersTable');
    if (usersTable) {
        const currentSortColumn = '<c:out value="${sortColumn}" default="" />';
        const currentSortDirection = '<c:out value="${sortDirection}" default="" />';
        
        // Custom sorting: detect clicks on sortable column headers
        const tableHeaders = usersTable.querySelectorAll('thead th.sortable-column');
        
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
                
                // Reload page with new sort parameters
                window.location.href = window.location.pathname + '?' + params.toString();
            });
        });
    }
});
</script>

<style>
.table-hover tbody tr:hover {
    background-color: rgba(78, 115, 223, 0.05);
}
</style>
