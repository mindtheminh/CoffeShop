<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    String cPath = request.getContextPath();
    request.setAttribute("pageTitle", "HR Dashboard - Yen Coffee");
%>
<jsp:include page="/WEB-INF/view/layout/management/header.jsp"/>

<div id="wrapper">
  <jsp:include page="/WEB-INF/view/layout/management/sidebar.jsp"/>

  <div id="content-wrapper" class="d-flex flex-column">
    <div id="content">
      <jsp:include page="/WEB-INF/view/layout/management/navbar.jsp"/>
            
            <div class="container-fluid" style="background-color:#f8f9fc; min-height:100vh;">
                <h1 class="h3 mb-4 text-gray-800">HR Dashboard</h1>
                <ol class="breadcrumb mb-4">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/home">Home</a></li>
                    <li class="breadcrumb-item active">HR Dashboard</li>
                </ol>

                <!-- Error Messages -->
                <c:if test="${not empty error}">
                    <div class="alert alert-warning alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-triangle"></i> ${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <!-- KPI Cards -->
                <div class="row">
                    <div class="col-xl-3 col-md-6">
                        <div class="card bg-primary text-white mb-4">
                            <div class="card-body">
                                <div class="d-flex align-items-center">
                                    <div class="flex-grow-1">
                                        <div class="small text-white">Tổng số người dùng</div>
                                        <div class="h4 mb-0 text-white fw-bold">${totalUsers != null ? totalUsers : 0}</div>
                                    </div>
                                    <div class="ms-3">
                                        <i class="fas fa-users fa-2x text-white"></i>
                                    </div>
                                </div>
                            </div>
                            <div class="card-footer d-flex align-items-center justify-content-between bg-primary">
                                <a class="small text-white stretched-link" href="${pageContext.request.contextPath}/user-list">Xem chi tiết</a>
                                <div class="small text-white"><i class="fas fa-angle-right"></i></div>
                            </div>
                        </div>
                    </div>
                    <div class="col-xl-3 col-md-6">
                        <div class="card bg-success text-white mb-4">
                            <div class="card-body">
                                <div class="d-flex align-items-center">
                                    <div class="flex-grow-1">
                                        <div class="small text-white">Người dùng hoạt động</div>
                                        <div class="h4 mb-0 text-white fw-bold">${activeUsers != null ? activeUsers : 0}</div>
                                    </div>
                                    <div class="ms-3">
                                        <i class="fas fa-user-check fa-2x text-white"></i>
                                    </div>
                                </div>
                            </div>
                            <div class="card-footer d-flex align-items-center justify-content-between bg-success">
                                <a class="small text-white stretched-link" href="${pageContext.request.contextPath}/user-list?status=Active">Xem chi tiết</a>
                                <div class="small text-white"><i class="fas fa-angle-right"></i></div>
                            </div>
                        </div>
                    </div>
                    <div class="col-xl-3 col-md-6">
                        <div class="card bg-warning text-white mb-4">
                            <div class="card-body">
                                <div class="d-flex align-items-center">
                                    <div class="flex-grow-1">
                                        <div class="small text-white">Người dùng không hoạt động</div>
                                        <div class="h4 mb-0 text-white fw-bold">${inactiveUsers != null ? inactiveUsers : 0}</div>
                                    </div>
                                    <div class="ms-3">
                                        <i class="fas fa-user-slash fa-2x text-white"></i>
                                    </div>
                                </div>
                            </div>
                            <div class="card-footer d-flex align-items-center justify-content-between bg-warning">
                                <a class="small text-white stretched-link" href="${pageContext.request.contextPath}/user-list?status=Inactive">Xem chi tiết</a>
                                <div class="small text-white"><i class="fas fa-angle-right"></i></div>
                            </div>
                        </div>
                    </div>
                    <div class="col-xl-3 col-md-6">
                        <div class="card bg-info text-white mb-4">
                            <div class="card-body">
                                <div class="d-flex align-items-center">
                                    <div class="flex-grow-1">
                                        <div class="small text-white">Tổng vai trò</div>
                                        <div class="h4 mb-0 text-white fw-bold">6</div>
                                    </div>
                                    <div class="ms-3">
                                        <i class="fas fa-user-tag fa-2x text-white"></i>
                                    </div>
                                </div>
                            </div>
                            <div class="card-footer d-flex align-items-center justify-content-between bg-info">
                                <a class="small text-white stretched-link" href="${pageContext.request.contextPath}/user-list">Xem chi tiết</a>
                                <div class="small text-white"><i class="fas fa-angle-right"></i></div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Charts -->
                <div class="row">
                    <div class="col-xl-6">
                        <div class="card mb-4">
                            <div class="card-header">
                                <i class="fas fa-chart-pie me-1"></i>
                                Phân bố người dùng theo vai trò
                            </div>
                            <div class="card-body">
                                <canvas id="roleChart" width="100%" height="40"></canvas>
                            </div>
                        </div>
                    </div>
                    <div class="col-xl-6">
                        <div class="card mb-4">
                            <div class="card-header">
                                <i class="fas fa-chart-bar me-1"></i>
                                Trạng thái người dùng
                            </div>
                            <div class="card-body">
                                <canvas id="statusChart" width="100%" height="40"></canvas>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Recent Users Table -->
                <div class="card mb-4">
                    <div class="card-header">
                        <i class="fas fa-table me-1"></i>
                        Người dùng gần đây
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${not empty recentUsers}">
                                <div class="table-responsive">
                                    <table id="datatablesSimple" class="table table-bordered">
                                        <thead>
                                            <tr>
                                                <th>ID</th>
                                                <th>Họ tên</th>
                                                <th>Email</th>
                                                <th>Vai trò</th>
                                                <th>Trạng thái</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="user" items="${recentUsers}">
                                                <tr>
                                                    <td>${user.userId}</td>
                                                    <td>
                                                        <strong>${user.fullName}</strong>
                                                    </td>
                                                    <td>${user.email}</td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${user.role == 'ADMIN'}">
                                                                <span class="badge bg-danger">Admin</span>
                                                            </c:when>
                                                            <c:when test="${user.role == 'HR'}">
                                                                <span class="badge bg-success">HR</span>
                                                            </c:when>
                                                            <c:when test="${user.role == 'MARKETER'}">
                                                                <span class="badge bg-warning">Marketer</span>
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
                                                                <span class="badge bg-success">Hoạt động</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-secondary">Không hoạt động</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-5">
                                    <i class="fas fa-users fa-3x text-muted mb-3"></i>
                                    <h5 class="text-muted">Chưa có người dùng nào</h5>
                                    <p class="text-muted">Tạo người dùng đầu tiên để bắt đầu quản lý.</p>
                                    <a href="${pageContext.request.contextPath}/user-new" class="btn btn-primary">
                                        <i class="fas fa-plus"></i> Tạo người dùng đầu tiên
                                    </a>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- Quick Actions -->
                <div class="row">
                    <div class="col-lg-6">
                        <div class="card mb-4">
                            <div class="card-header">
                                <i class="fas fa-users me-1"></i>
                                Quản lý người dùng
                            </div>
                            <div class="card-body">
                                <div class="d-grid gap-2">
                                    <a href="${pageContext.request.contextPath}/user-new" class="btn btn-primary">
                                        <i class="fas fa-plus"></i> Tạo người dùng mới
                                    </a>
                                    <a href="${pageContext.request.contextPath}/user-list" class="btn btn-outline-primary">
                                        <i class="fas fa-list"></i> Xem tất cả người dùng
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-6">
                        <div class="card mb-4">
                            <div class="card-header">
                                <i class="fas fa-chart-line me-1"></i>
                                Báo cáo & Thống kê
                            </div>
                            <div class="card-body">
                                <div class="d-grid gap-2">
                                    <a href="${pageContext.request.contextPath}/user-list?sort=created_at_desc" class="btn btn-success">
                                        <i class="fas fa-user-plus"></i> Người dùng mới
                                    </a>
                                    <a href="${pageContext.request.contextPath}/user-list" class="btn btn-outline-success">
                                        <i class="fas fa-chart-bar"></i> Xem báo cáo chi tiết
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- End of Content -->
    <jsp:include page="/WEB-INF/view/layout/management/footer.jsp"/>
  </div>
</div>

<!-- Scripts -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/startbootstrap-sb-admin/js/scripts.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/umd/simple-datatables.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/startbootstrap-sb-admin/assets/demo/datatables-simple-demo.js"></script>

<!-- Custom Charts -->
<script>
// Role Chart
const roleCtx = document.getElementById('roleChart').getContext('2d');
const roleData = ${roleCountsJson != null ? roleCountsJson : '[0,0,0,0,0,0]'};
new Chart(roleCtx, {
    type: 'doughnut',
    data: {
        labels: ['Customer', 'Staff', 'Cashier', 'Marketer', 'HR', 'Admin'],
        datasets: [{
            data: roleData,
            backgroundColor: [
                '#6c757d',
                '#007bff',
                '#17a2b8',
                '#ffc107',
                '#28a745',
                '#dc3545'
            ]
        }]
    },
    options: {
        responsive: true,
        plugins: {
            legend: {
                position: 'bottom'
            }
        }
    }
});

// Status Chart
const statusCtx = document.getElementById('statusChart').getContext('2d');
new Chart(statusCtx, {
    type: 'bar',
    data: {
        labels: ['Hoạt động', 'Không hoạt động'],
        datasets: [{
            label: 'Số lượng',
            data: [${activeUsers != null ? activeUsers : 0}, ${inactiveUsers != null ? inactiveUsers : 0}],
            backgroundColor: ['#28a745', '#6c757d']
        }]
    },
    options: {
        responsive: true,
        scales: {
            y: {
                beginAtZero: true
            }
        }
    }
});
</script>

<jsp:include page="/WEB-INF/view/layout/management/scripts.jsp"/>