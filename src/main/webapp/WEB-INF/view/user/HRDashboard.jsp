<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <title>HR Dashboard — Yên Coffee House</title>

    <link href="<%=ctx%>/assets/startbootstrap-sb-admin/css/styles.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/style.min.css" rel="stylesheet" />
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
    </head>

<body class="sb-nav-fixed">
<nav class="sb-topnav navbar navbar-expand navbar-dark bg-dark">
    <a class="navbar-brand ps-3" href="<%=ctx%>/">Yên Coffee House</a>

    <button class="btn btn-link btn-sm order-1 order-lg-0 me-4 me-lg-0" id="sidebarToggle">
        <i class="fas fa-bars"></i>
    </button>

    <form class="d-none d-md-inline-block form-inline ms-auto me-0 me-md-3 my-2 my-md-0">
        <div class="input-group">
            <input class="form-control" type="text" placeholder="Tìm người dùng..." aria-label="Search" />
            <button class="btn btn-primary" id="btnNavbarSearch" type="button"><i class="fas fa-search"></i></button>
        </div>
    </form>

    <ul class="navbar-nav ms-auto ms-md-0 me-3 me-lg-4">
        <li class="nav-item dropdown">
            <a class="nav-link dropdown-toggle" id="navbarDropdown" href="#" role="button"
               data-bs-toggle="dropdown" aria-expanded="false">
                <i class="fas fa-user fa-fw"></i>
            </a>
            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="navbarDropdown">
                <li><a class="dropdown-item" href="<%=ctx%>/my-profile">My profile</a></li>
                <li><a class="dropdown-item" href="<%=ctx%>/my-orders">My Orders</a></li>
                <li><a class="dropdown-item" href="<%=ctx%>/my-cart">My Cart</a></li>
                <li><hr class="dropdown-divider" /></li>
                <li><a class="dropdown-item" href="<%=ctx%>/auth/logout">Đăng xuất</a></li>
            </ul>
        </li>
    </ul>
</nav>

<div id="layoutSidenav">
    <div id="layoutSidenav_nav">
        <nav class="sb-sidenav accordion sb-sidenav-dark" id="sidenavAccordion">
            <div class="sb-sidenav-menu">
                <div class="nav">
                    <div class="sb-sidenav-menu-heading">CORE</div>

                    <a class="nav-link" href="<%=ctx%>/home">
                        <div class="sb-nav-link-icon"><i class="fas fa-house"></i></div>
                        Home
                    </a>

                    <a class="nav-link active" href="<%=ctx%>/hr-dashboard">
                        <div class="sb-nav-link-icon"><i class="fas fa-tachometer-alt"></i></div>
                        HR Dashboard
                    </a>

                    <a class="nav-link" href="<%=ctx%>/user-list">
                        <div class="sb-nav-link-icon"><i class="fas fa-users"></i></div>
                        User List
                    </a>

                    <a class="nav-link" href="<%=ctx%>/user-new">
                        <div class="sb-nav-link-icon"><i class="fas fa-user-plus"></i></div>
                        New User
                    </a>
                </div>
            </div>
            <div class="sb-sidenav-footer">
                <div class="small">Đăng nhập với vai trò:</div>
                HR Manager
            </div>
        </nav>
    </div>

    <div id="layoutSidenav_content">
        <main>
            <div class="container-fluid px-4">
                <h1 class="mt-4">HR Dashboard</h1>
                <ol class="breadcrumb mb-4">
                    <li class="breadcrumb-item active">Tổng quan</li>
                </ol>

                <!-- Chỉ 1 KPI: Tổng người dùng -->
                <div class="row">
                    <div class="col-xl-3 col-md-6">
                        <div class="card bg-primary text-white mb-4">
                            <div class="card-body">
                                Tổng người dùng:
                                <strong><c:out value="${totalUsers != null ? totalUsers : 0}"/></strong>
                            </div>
                            <div class="card-footer d-flex align-items-center justify-content-between">
                                <span class="small text-white">—</span>
                                <div class="small text-white"><i class="fas fa-angle-right"></i></div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- CHART: Phân bố người dùng theo ROLE -->
                <div class="row">
                    <div class="col-xl-12">
                        <div class="card mb-4">
                            <div class="card-header">
                                <i class="fas fa-chart-bar me-1"></i>
                                Phân bố người dùng theo vai trò
                                <span class="text-muted small ms-2">(CUSTOMER, STAFF, CASHIER, MARKETER, HR, ADMIN)</span>
                            </div>
                            <div class="card-body">
                                <canvas id="roleChart"
                                        data-values='${roleCountsJson != null ? roleCountsJson : "[0,0,0,0,0,0]"}'
                                        width="100%" height="40"></canvas>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- User gần đây (ít bản ghi) -->
                <div class="card mb-4">
                    <div class="card-header">
                        <i class="fas fa-table me-1"></i>
                        User gần đây
                    </div>
                    <div class="card-body">
                        <table id="datatablesSimple">
                            <thead>
                            <tr>
                                <th>ID</th>
                                <th>Full Name</th>
                                <th>Email</th>
                                <th>Role</th>
                                <th>Status</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="u" items="${recentUsers}">
                                <tr>
                                    <td><c:out value="${u.userId}"/></td>
                                    <td><c:out value="${u.fullName}"/></td>
                                    <td><c:out value="${u.email}"/></td>
                                    <td>
                                        <span class="badge bg-primary">
                                            <c:out value="${u.role}"/>
                                        </span>
                                    </td>
                                    <td>
                                        <span class="badge 
                                            ${u.status == 'ACTIVE' ? 'bg-success' : (u.status == 'INACTIVE' ? 'bg-secondary' : 'bg-warning')}">
                                            <c:out value="${u.status == 'ACTIVE' ? 'Active' : (u.status == 'INACTIVE' ? 'Inactive' : u.status)}"/>
                                        </span>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                        <div class="text-muted small mt-2">
                            Hiển thị người dùng mới nhất (giới hạn ít bản ghi để xem nhanh).
                        </div>
                    </div>
                </div>

            </div>
        </main>

        <footer class="py-4 bg-light mt-auto">
            <div class="container-fluid px-4">
                <div class="d-flex align-items-center justify-content-between small">
                    <div class="text-muted">© Yên Coffee House 2025</div>
                    <div>
                        <a href="#">Chính sách</a>
                        &middot;
                        <a href="#">Điều khoản</a>
                    </div>
                </div>
            </div>
        </footer>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
<script src="<%=ctx%>/assets/startbootstrap-sb-admin/js/scripts.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.8.0/Chart.min.js" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/umd/simple-datatables.min.js" crossorigin="anonymous"></script>
<script>
    // init datatable (gọn)
    (function () {
        const tbl = document.getElementById('datatablesSimple');
        if (tbl) new simpleDatatables.DataTable(tbl, { perPage: 5 });
    })();

    // Bar chart theo ROLE
    (function () {
        const el = document.getElementById('roleChart');
        if (!el) return;
        let values = [0,0,0,0,0,0];
        try { values = JSON.parse(el.getAttribute('data-values') || '[0,0,0,0,0,0]'); } catch (_) {}
        const labels = ["CUSTOMER","STAFF","CASHIER","MARKETER","HR","ADMIN"];

        new Chart(el, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [{
                    label: "Users",
                    data: values,
                    backgroundColor: "rgba(2,117,216,1)"
                }]
            },
            options: {
                scales: {
                    xAxes: [{ gridLines: { display: false } }],
                    yAxes: [{ ticks: { beginAtZero: true, precision: 0 }, gridLines: { color: "rgba(0,0,0,.125)" } }]
                },
                legend: { display: false }
            }
        });
    })();
</script>
    </body>
</html>
