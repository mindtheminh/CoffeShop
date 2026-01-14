<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    String cPath = request.getContextPath();
    request.setAttribute("pageTitle", "Marketer Dashboard - Yen Coffee");
%>
<jsp:include page="/WEB-INF/view/layout/management/header.jsp"/>

<div id="wrapper">
  <jsp:include page="/WEB-INF/view/layout/management/sidebar.jsp"/>

  <div id="content-wrapper" class="d-flex flex-column">
    <div id="content">
      <jsp:include page="/WEB-INF/view/layout/management/navbar.jsp"/>
            
            <div class="container-fluid">
                <h1 class="h3 mb-4 text-gray-800">Marketer Dashboard</h1>
                <ol class="breadcrumb mb-4">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/home">Home</a></li>
                    <li class="breadcrumb-item active">Marketer Dashboard</li>
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
                                <div class="small text-white">Tổng sản phẩm</div>
                                <div class="h4 mb-0 text-white fw-bold">${totalProducts != null ? totalProducts : 0}</div>
                            </div>
                            <div class="ms-3">
                                <i class="fas fa-box fa-2x text-white"></i>
                            </div>
                        </div>
                    </div>
                    <div class="card-footer d-flex align-items-center justify-content-between bg-primary">
                        <a class="small text-white stretched-link" href="${pageContext.request.contextPath}/product-list">Xem chi tiết</a>
                        <div class="small text-white"><i class="fas fa-angle-right"></i></div>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-md-6">
                <div class="card bg-success text-white mb-4">
                    <div class="card-body">
                        <div class="d-flex align-items-center">
                            <div class="flex-grow-1">
                                <div class="small text-white">Sản phẩm hoạt động</div>
                                <div class="h4 mb-0 text-white fw-bold">${activeProducts != null ? activeProducts : 0}</div>
                            </div>
                            <div class="ms-3">
                                <i class="fas fa-check-circle fa-2x text-white"></i>
                            </div>
                        </div>
                    </div>
                    <div class="card-footer d-flex align-items-center justify-content-between bg-success">
                        <a class="small text-white stretched-link" href="${pageContext.request.contextPath}/product-list?status=Activate">Xem chi tiết</a>
                        <div class="small text-white"><i class="fas fa-angle-right"></i></div>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-md-6">
                <div class="card bg-warning text-white mb-4">
                    <div class="card-body">
                        <div class="d-flex align-items-center">
                            <div class="flex-grow-1">
                                <div class="small text-white">Danh mục</div>
                                <div class="h4 mb-0 text-white fw-bold">${totalCategories != null ? totalCategories : 0}</div>
                            </div>
                            <div class="ms-3">
                                <i class="fas fa-tags fa-2x text-white"></i>
                            </div>
                        </div>
                    </div>
                    <div class="card-footer d-flex align-items-center justify-content-between bg-warning">
                        <a class="small text-white stretched-link" href="${pageContext.request.contextPath}/product-list">Xem chi tiết</a>
                        <div class="small text-white"><i class="fas fa-angle-right"></i></div>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-md-6">
                <div class="card bg-info text-white mb-4">
                    <div class="card-body">
                        <div class="d-flex align-items-center">
                            <div class="flex-grow-1">
                                <div class="small text-white">Khuyến mãi</div>
                                <div class="h4 mb-0 text-white fw-bold">${totalPromotions != null ? totalPromotions : 0}</div>
                            </div>
                            <div class="ms-3">
                                <i class="fas fa-percentage fa-2x text-white"></i>
                            </div>
                        </div>
                    </div>
                    <div class="card-footer d-flex align-items-center justify-content-between bg-info">
                        <a class="small text-white stretched-link" href="${pageContext.request.contextPath}/promotion-list">Xem chi tiết</a>
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
                        Phân bố sản phẩm theo danh mục
                    </div>
                    <div class="card-body">
                        <canvas id="categoryChart" width="100%" height="40"></canvas>
                    </div>
                </div>
            </div>
            <div class="col-xl-6">
                <div class="card mb-4">
                    <div class="card-header">
                        <i class="fas fa-chart-bar me-1"></i>
                        Trạng thái sản phẩm
                    </div>
                    <div class="card-body">
                        <canvas id="statusChart" width="100%" height="40"></canvas>
                    </div>
                </div>
            </div>
        </div>

        <!-- Recent Products Table -->
        <div class="card mb-4">
            <div class="card-header">
                <i class="fas fa-table me-1"></i>
                Sản phẩm gần đây
            </div>
            <div class="card-body">
                <c:choose>
                    <c:when test="${not empty recentProducts}">
                        <div class="table-responsive">
                            <table id="datatablesSimple" class="table table-bordered">
                                <thead>
                                    <tr>
                                        <th>Tên sản phẩm</th>
                                        <th>Danh mục</th>
                                        <th>Giá</th>
                                        <th>Trạng thái</th>
                                        <th>Bán chạy</th>
                                        <th>Ngày tạo</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="product" items="${recentProducts}">
                                        <tr>
                                            <td>
                                                <strong>${product.name}</strong>
                                                <c:if test="${not empty product.description}">
                                                    <br><small class="text-muted">${product.description}</small>
                                                </c:if>
                                            </td>
                                            <td>
                                                <span class="badge bg-secondary">${product.category}</span>
                                            </td>
                                            <td>
                                                <fmt:formatNumber value="${product.price}" type="currency" currencyCode="VND"/>
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
                                            <td>
                                                <c:choose>
                                                    <c:when test="${product.is_bestseller}">
                                                        <span class="badge bg-warning">Bán chạy</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-light text-dark">Thường</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <fmt:formatDate value="${product.created_at}" pattern="dd/MM/yyyy"/>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-5">
                            <i class="fas fa-box fa-3x text-muted mb-3"></i>
                            <h5 class="text-muted">Chưa có sản phẩm nào</h5>
                            <p class="text-muted">Tạo sản phẩm đầu tiên để bắt đầu quản lý.</p>
                            <a href="${pageContext.request.contextPath}/product-new" class="btn btn-primary">
                                <i class="fas fa-plus"></i> Tạo sản phẩm đầu tiên
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
                        <i class="fas fa-coffee me-1"></i>
                        Quản lý sản phẩm
                    </div>
                    <div class="card-body">
                        <div class="d-grid gap-2">
                            <a href="${pageContext.request.contextPath}/product-new" class="btn btn-primary">
                                <i class="fas fa-plus"></i> Tạo sản phẩm mới
                            </a>
                            <a href="${pageContext.request.contextPath}/product-list" class="btn btn-outline-primary">
                                <i class="fas fa-list"></i> Xem tất cả sản phẩm
                            </a>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-6">
                <div class="card mb-4">
                    <div class="card-header">
                        <i class="fas fa-percentage me-1"></i>
                        Quản lý khuyến mãi
                    </div>
                    <div class="card-body">
                        <div class="d-grid gap-2">
                            <a href="${pageContext.request.contextPath}/promotion-new" class="btn btn-success">
                                <i class="fas fa-plus"></i> Tạo khuyến mãi mới
                            </a>
                            <a href="${pageContext.request.contextPath}/promotion-list" class="btn btn-outline-success">
                                <i class="fas fa-list"></i> Xem tất cả khuyến mãi
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<!-- Scripts -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/startbootstrap-sb-admin/js/scripts.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/umd/simple-datatables.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/startbootstrap-sb-admin/assets/demo/datatables-simple-demo.js"></script>

<!-- Custom Charts -->
<script>
// Category Chart
const categoryCtx = document.getElementById('categoryChart').getContext('2d');
const categoryData = ${categoryData != null ? categoryData : '[0,0,0,0,0]'};
new Chart(categoryCtx, {
    type: 'doughnut',
    data: {
        labels: ['Cà phê', 'Trà', 'Nước ép', 'Bánh ngọt', 'Khác'],
        datasets: [{
            data: categoryData,
            backgroundColor: [
                '#8B4513',
                '#228B22', 
                '#FF6347',
                '#DDA0DD',
                '#A9A9A9'
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
            data: [${activeProducts != null ? activeProducts : 0}, ${inactiveProducts != null ? inactiveProducts : 0}],
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

        </div>
        <!-- End of Content -->
    <jsp:include page="/WEB-INF/view/layout/management/footer.jsp"/>
  </div>
</div>

<jsp:include page="/WEB-INF/view/layout/management/scripts.jsp"/>