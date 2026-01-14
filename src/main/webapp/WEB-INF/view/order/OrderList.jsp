<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<%
    String cPath = request.getContextPath();
    request.setAttribute("pageTitle", "Danh sách đơn hàng - Yen Coffee");
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
                    <div class="d-flex align-items-center">

                        <h1 class="h3 mb-0 text-gray-800">
                            <i class="fas fa-shopping-cart me-2"></i>Danh sách đơn hàng
                        </h1>
                    </div>


                </div>

                <!-- Stat Cards -->
                <div class="row mb-4">
                    <div class="col-xl-2 col-md-4 mb-3">
                        <div class="card bg-primary text-white shadow-sm">
                            <div class="card-body">
                                <div class="small">Tổng số đơn</div>
                                <div class="h5 fw-bold">${orderCount != null ? orderCount : 0}</div>
                            </div>
                        </div>
                    </div>
                    <div class="col-xl-2 col-md-4 mb-3">
                        <div class="card bg-success text-white shadow-sm">
                            <div class="card-body">
                                <div class="small">Đã thanh toán</div>
                                <div class="h5 fw-bold">${orderCountCompleted != null ? orderCountCompleted : 0}</div>
                            </div>
                        </div>
                    </div>
                    <div class="col-xl-2 col-md-4 mb-3">
                        <div class="card bg-warning text-white shadow-sm">
                            <div class="card-body">
                                <div class="small">Đang chờ</div>
                                <div class="h5 fw-bold">${orderCountPending != null ? orderCountPending : 0}</div>
                            </div>
                        </div>
                    </div>
                    <div class="col-xl-2 col-md-4 mb-3">
                        <div class="card bg-info text-white shadow-sm">
                            <div class="card-body">
                                <div class="small">Đang xử lí</div>
                                <div class="h5 fw-bold">${orderCountProcessing != null ? orderCountProcessing : 0}</div>
                            </div>
                        </div>
                    </div>
                    <div class="col-xl-2 col-md-4 mb-3">
                        <div class="card bg-danger text-white shadow-sm">
                            <div class="card-body">
                                <div class="small">Hủy</div>
                                <div class="h5 fw-bold">${orderCountCancelled != null ? orderCountCancelled : 0}</div>
                            </div>
                        </div>
                    </div>
                </div>





                <!-- Orders Table -->
                <div class="card shadow mb-4">
                    <div class="card-header py-3 bg-gradient-primary text-white d-flex justify-content-between align-items-center">
                        
                        <div class="btn-group" role="group">
                            <a href="${pageContext.request.contextPath}/cashier-dashboard" 
                               class="btn btn-primary btn-sm ${param.status == 'Dashboard' ? 'active' : ''}">
                                <i class="fas fa-tachometer-alt me-1"></i> Quay lại
                            </a>
                        </div>

                        <div class="btn-group" role="group">
                            <a href="${pageContext.request.contextPath}/orders?filterDate=${param.filterDate}" 
                               class="btn btn-secondary btn-sm ${empty param.status ? 'active' : ''}">
                                <i class="fas fa-list me-1"></i> Tất cả
                            </a>
                            <a href="${pageContext.request.contextPath}/orders?status=Completed&filterDate=${param.filterDate}" 
                               class="btn btn-success btn-sm ${param.status == 'Completed' ? 'active' : ''}">
                                <i class="fas fa-check-circle me-1"></i> Hoàn thành
                            </a>
                            <a href="${pageContext.request.contextPath}/orders?status=Pending&filterDate=${param.filterDate}" 
                               class="btn btn-warning btn-sm ${param.status == 'Pending' ? 'active' : ''}">
                                <i class="fas fa-hourglass-half me-1"></i> Đang chờ
                            </a>
                            <a href="${pageContext.request.contextPath}/orders?status=Cancelled&filterDate=${param.filterDate}" 
                               class="btn btn-danger btn-sm ${param.status == 'Cancelled' ? 'active' : ''}">
                                <i class="fas fa-times-circle me-1"></i> Đã hủy
                            </a>
                        </div>
                        <h6 class="m-0 fw-bold"><i class="fas fa-list me-2"></i>Danh sách đơn hàng</h6>


                        <!-- Filter Date (bên phải) -->
                        <div class="filter-date">
                            <form action="${pageContext.request.contextPath}/orders" method="get" class="d-flex align-items-center">
                                <label for="filterDate" class="me-2 mb-0 fw-bold">Lọc theo ngày:</label>
                                <input type="date" id="filterDate" name="filterDate" class="form-control form-control-sm me-2"
                                       value="${param.filterDate != null ? param.filterDate : ''}"/>
                                <button type="submit" class="btn btn-secondary btn-sm"><i class="fas fa-filter me-1"></i> </button>
                            </form>
                        </div>
                        <div>
                            <form action="${pageContext.request.contextPath}/OrderServlet" method="get" class="d-flex align-items-center">
                                <input type="text" name="search" class="form-control form-control-sm me-2" placeholder="Tìm kiếm ID">
                                <button type="submit" class="btn btn-light btn-sm"><i class="fas fa-search"></i></button>
                            </form>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-bordered table-striped">
                                <thead class="table-light">
                                    <tr>
                                        <th>ID</th>
                                        <th>Tổng tiền</th>
                                        <th>Phải trả</th>
                                        <th>Phương thức</th>
                                        <th>Trạng thái</th>
                                        <th>Thời gian</th>
                                        <th>Chỉnh sửa cuối</th>
                                        <th>Chi tiết</th>

                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${orders}" var="o">
                                        <tr>
                                            <td>${o.orderId}</td>
                                            <td>${o.totalAmount}</td>
                                            <td>${o.paymentAmount}</td>
                                            <td>${o.payMethod}</td>
                                            <td>${o.status}</td>
                                            <td><fmt:formatDate value="${o.createdAtAsDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                                            <td><fmt:formatDate value="${o.updatedAtAsDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                                            <td>

                                                <form action="${pageContext.request.contextPath}/order-details" method="get" style="display:inline;">
                                                    <input type="hidden" name="orderId" value="${o.orderId}"/>
                                                    <button type="submit" class="btn btn-info btn-sm mb-1">Chi tiết</button>
                                                </form>
                                                <c:if test="${o.status eq 'Pending'}">
                                                    <form action="${pageContext.request.contextPath}/editOrder" method="post" style="display:inline;">
                                                        <input type="hidden" name="orderId" value="${o.orderId}"/>
                                                        <button type="submit" class="btn btn-warning btn-sm mb-1">Chỉnh sửa</button>
                                                    </form>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty orders}">
                                        <tr>
                                            <td colspan="7" class="text-center text-muted">Không có đơn hàng nào được tìm thấy</td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>

                        <!-- Pagination -->
                        <c:if test="${totalPages > 1}">
                            <nav class="mt-3">
                                <ul class="pagination pagination-sm justify-content-center">
                                    <li class="page-item">
                                        <a class="page-link" href="?page=1&status=${param.status}&filterDate=${param.filterDate}">&laquo;</a>
                                    </li>
                                    <c:forEach begin="1" end="${totalPages}" var="i">
                                        <li class="page-item ${i == currentPage ? 'active' : ''}">
                                            <a class="page-link" href="?page=${i}&status=${param.status}&filterDate=${param.filterDate}">${i}</a>
                                        </li>
                                    </c:forEach>
                                    <li class="page-item">
                                        <a class="page-link" href="?page=${totalPages}&status=${param.status}&filterDate=${param.filterDate}">&raquo;</a>
                                    </li>
                                </ul>
                            </nav>
                        </c:if>


                    </div>
                </div>

            </div>
            <!-- End Page Content -->

        </div>

    <jsp:include page="/WEB-INF/view/layout/management/footer.jsp"/>
  </div>
</div>

<jsp:include page="/WEB-INF/view/layout/management/scripts.jsp"/>
