<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<%
    String cPath = request.getContextPath();
    request.setAttribute("pageTitle", "Admin Dashboard - Yen Coffee");
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
                    <div>
                        <h1 class="h3 mb-0 text-gray-800">
                            <i class="fas fa-tachometer-alt me-2"></i>Admin Dashboard
                        </h1>
                        <p class="text-muted mb-0">Tổng quan hệ thống và quản lý</p>
                    </div>
                    <div class="d-flex gap-2">
                        <a href="${pageContext.request.contextPath}/setting-list" class="btn btn-info btn-sm">
                            <i class="fas fa-cogs"></i> Cài đặt hệ thống
                        </a>
                    </div>
                </div>

                <!-- KPI Cards -->
                <div class="row">
                    <!-- Hàng 1: 4 cards -->
                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="card bg-primary text-white mb-4 shadow-sm">
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
                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="card bg-success text-white mb-4 shadow-sm">
                            <div class="card-body">
                                <div class="d-flex align-items-center">
                                    <div class="flex-grow-1">
                                        <div class="small text-white">Tổng sản phẩm</div>
                                        <div class="h4 mb-0 text-white fw-bold">${totalProducts != null ? totalProducts : 0}</div>
                                    </div>
                                    <div class="ms-3">
                                        <i class="fas fa-coffee fa-2x text-white"></i>
                                    </div>
                                </div>
                            </div>
                            <div class="card-footer d-flex align-items-center justify-content-between bg-success">
                                <a class="small text-white stretched-link" href="${pageContext.request.contextPath}/product-list">Xem chi tiết</a>
                                <div class="small text-white"><i class="fas fa-angle-right"></i></div>
                            </div>
                        </div>
                    </div>
                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="card bg-warning text-white mb-4 shadow-sm">
                            <div class="card-body">
                                <div class="d-flex align-items-center">
                                    <div class="flex-grow-1">
                                        <div class="small text-white">Tổng số khuyến mãi</div>
                                        <div class="h4 mb-0 text-white fw-bold">${totalPromotions != null ? totalPromotions : 0}</div>
                                    </div>
                                    <div class="ms-3">
                                        <i class="fas fa-tags fa-2x text-white"></i>
                                    </div>
                                </div>
                            </div>
                            <div class="card-footer d-flex align-items-center justify-content-between bg-warning">
                                <a class="small text-white stretched-link" href="${pageContext.request.contextPath}/promotion-list">Xem chi tiết</a>
                                <div class="small text-white"><i class="fas fa-angle-right"></i></div>
                            </div>
                        </div>
                    </div>
                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="card bg-info text-white mb-4 shadow-sm">
                            <div class="card-body">
                                <div class="d-flex align-items-center">
                                    <div class="flex-grow-1">
                                        <div class="small text-white">Tổng số cấu hình</div>
                                        <div class="h4 mb-0 text-white fw-bold">${totalSettings != null ? totalSettings : 0}</div>
                                    </div>
                                    <div class="ms-3">
                                        <i class="fas fa-cogs fa-2x text-white"></i>
                                    </div>
                                </div>
                            </div>
                            <div class="card-footer d-flex align-items-center justify-content-between bg-info">
                                <a class="small text-white stretched-link" href="${pageContext.request.contextPath}/setting-list">Xem chi tiết</a>
                                <div class="small text-white"><i class="fas fa-angle-right"></i></div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Hàng 2: Card Tổng số Đơn hàng (ngay dưới Tổng số người dùng) -->
                <div class="row">
                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="card bg-success text-white mb-4 shadow-sm">
                            <div class="card-body">
                                <div class="d-flex align-items-center">
                                    <div class="flex-grow-1">
                                        <div class="small text-white">Tổng số Đơn hàng</div>
                                        <div class="h4 mb-0 text-white fw-bold">${totalOrders != null ? totalOrders : 0}</div>
                                    </div>
                                    <div class="ms-3">
                                        <i class="fas fa-shopping-cart fa-2x text-white"></i>
                                    </div>
                                </div>
                            </div>
                            <div class="card-footer d-flex align-items-center justify-content-between bg-success">
                                <a class="small text-white stretched-link" href="${pageContext.request.contextPath}/order-list">Xem chi tiết</a>
                                <div class="small text-white"><i class="fas fa-angle-right"></i></div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Charts Row -->
                <div class="row">
                    <div class="col-xl-8 col-lg-7">
                        <div class="card shadow mb-4">
                            <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between" style="background-image: linear-gradient(to right, #4e73df, #224abe); color: white;">
                                <h6 class="m-0 font-weight-bold">
                                    <i class="fas fa-chart-bar me-2"></i>Thống kê người dùng, sản phẩm và đơn hàng
                                </h6>
                            </div>
                            <div class="card-body">
                                <canvas id="statisticsChart" style="height: 300px;"></canvas>
                            </div>
                        </div>
                    </div>
                    <div class="col-xl-4 col-lg-5">
                        <div class="card shadow mb-4">
                            <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between" style="background-image: linear-gradient(to right, #1cc88a, #17a673); color: white;">
                                <h6 class="m-0 font-weight-bold">
                                    <i class="fas fa-chart-pie me-2"></i>Phân bổ người dùng theo vai trò
                                </h6>
                            </div>
                            <div class="card-body">
                                <canvas id="roleChart" style="height: 300px;"></canvas>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Quick Actions -->
                <div class="row">
                    <div class="col-lg-12">
                        <div class="card shadow mb-4">
                            <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between" style="background-image: linear-gradient(to right, #f6c23e, #dda20a); color: white;">
                                <h6 class="m-0 font-weight-bold">
                                    <i class="fas fa-bolt me-2"></i>Thao tác nhanh
                                </h6>
                            </div>
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-3 mb-3">
                                        <a href="${pageContext.request.contextPath}/user-new" class="btn btn-primary w-100">
                                            <i class="fas fa-user-plus me-2"></i>Thêm người dùng
                                        </a>
                                    </div>
                                    <div class="col-md-3 mb-3">
                                        <a href="${pageContext.request.contextPath}/product-new" class="btn btn-success w-100">
                                            <i class="fas fa-plus me-2"></i>Thêm sản phẩm
                                        </a>
                                    </div>
                                    <div class="col-md-3 mb-3">
                                        <a href="${pageContext.request.contextPath}/promotion-new" class="btn btn-info w-100">
                                            <i class="fas fa-tags me-2"></i>Thêm khuyến mãi
                                        </a>
                                    </div>
                                    <div class="col-md-3 mb-3">
                                        <a href="${pageContext.request.contextPath}/setting-new" class="btn btn-warning w-100">
                                            <i class="fas fa-plus me-2"></i>Thêm Cấu hình
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
            <!-- End Page Content -->
        </div>

    <jsp:include page="/WEB-INF/view/layout/management/footer.jsp"/>
  </div>
</div>

<jsp:include page="/WEB-INF/view/layout/management/scripts.jsp"/>

<!-- Page level custom scripts -->
<script>
// Statistics Chart - Bar Chart (Users, Products, Orders)
(function () {
    const el = document.getElementById("statisticsChart");
    if (!el) return;
    
    // Get data from server or use default
    const totalUsers = ${totalUsers != null ? totalUsers : 0};
    const totalProducts = ${totalProducts != null ? totalProducts : 0};
    const totalOrders = ${totalOrders != null ? totalOrders : 0};
    
    new Chart(el, {
        type: 'bar',
        data: {
            labels: ['Người dùng', 'Sản phẩm', 'Đơn hàng'],
            datasets: [{
                label: 'Số lượng',
                data: [totalUsers, totalProducts, totalOrders],
                backgroundColor: [
                    'rgba(78, 115, 223, 0.8)',
                    'rgba(28, 200, 138, 0.8)',
                    'rgba(246, 194, 62, 0.8)'
                ],
                borderColor: [
                    'rgba(78, 115, 223, 1)',
                    'rgba(28, 200, 138, 1)',
                    'rgba(246, 194, 62, 1)'
                ],
                borderWidth: 2,
                borderRadius: 5
            }]
        },
        options: {
            maintainAspectRatio: false,
            responsive: true,
            plugins: {
                legend: { 
                    display: true,
                    position: 'top',
                    labels: {
                        usePointStyle: true,
                        padding: 15,
                        font: {
                            size: 12
                        }
                    }
                },
                tooltip: {
                    backgroundColor: 'rgba(0,0,0,0.8)',
                    padding: 12,
                    titleFont: {
                        size: 14
                    },
                    bodyFont: {
                        size: 13
                    },
                    callbacks: {
                        label: function(context) {
                            return 'Số lượng: ' + context.parsed.y.toLocaleString('vi-VN');
                        }
                    }
                }
            },
            scales: {
                y: { 
                    beginAtZero: true,
                    grid: {
                        color: 'rgba(0,0,0,0.05)'
                    },
                    ticks: { 
                        font: {
                            size: 11
                        },
                        stepSize: 1,
                        callback: function(value) {
                            return value.toLocaleString('vi-VN');
                        }
                    }
                },
                x: {
                    grid: {
                        display: false
                    },
                    ticks: {
                        font: {
                            size: 11
                        }
                    }
                }
            }
        }
    });
})();

// User Role Distribution Chart - Pie Chart (improved)
(function () {
    const el = document.getElementById("roleChart");
    if (!el) return;
    
    // Get role data from server or use default
    const roleData = ${roleCountsJson != null ? roleCountsJson : '[0,0,0,0,0]'};
    const roleLabels = ["Admin", "HR", "Cashier", "Marketer", "Customer"];
    const roleColors = ['#dc3545', '#1cc88a', '#36b9cc', '#f6c23e', '#858796']; // Red, Green, Cyan, Yellow, Grey
    
    // Calculate total for percentage
    const total = roleData.reduce((a, b) => a + b, 0);
    
    new Chart(el, {
        type: 'pie',
        data: {
            labels: roleLabels,
            datasets: [{
                data: roleData,
                backgroundColor: roleColors,
                borderWidth: 3,
                borderColor: '#fff',
                hoverBorderWidth: 4,
                hoverOffset: 8
            }]
        },
        options: {
            maintainAspectRatio: false,
            responsive: true,
            plugins: {
                legend: { 
                    display: true,
                    position: 'bottom',
                    labels: {
                        usePointStyle: true,
                        padding: 15,
                        font: {
                            size: 11
                        },
                        generateLabels: function(chart) {
                            const data = chart.data;
                            if (data.labels.length && data.datasets.length) {
                                return data.labels.map((label, i) => {
                                    const value = data.datasets[0].data[i];
                                    const percentage = total > 0 ? ((value / total) * 100).toFixed(1) : 0;
                                    return {
                                        text: label + ': ' + value + ' (' + percentage + '%)',
                                        fillStyle: data.datasets[0].backgroundColor[i],
                                        strokeStyle: data.datasets[0].borderColor,
                                        lineWidth: data.datasets[0].borderWidth,
                                        hidden: false,
                                        index: i
                                    };
                                });
                            }
                            return [];
                        }
                    }
                },
                tooltip: {
                    backgroundColor: 'rgba(0,0,0,0.8)',
                    padding: 12,
                    titleFont: {
                        size: 14
                    },
                    bodyFont: {
                        size: 13
                    },
                    callbacks: {
                        label: function(context) {
                            const label = context.label || '';
                            const value = context.parsed || 0;
                            const total = context.dataset.data.reduce((a, b) => a + b, 0);
                            const percentage = total > 0 ? ((value / total) * 100).toFixed(1) : 0;
                            return label + ': ' + value + ' người (' + percentage + '%)';
                        }
                    }
                }
            }
        }
    });
})();
</script>
</body>
</html>
