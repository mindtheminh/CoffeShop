<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%
    String cPath = request.getContextPath();
    request.setAttribute("pageTitle", "Cashier Dashboard - Yen Coffee");
%>
<jsp:include page="/WEB-INF/view/layout/management/header.jsp"/>

<div id="wrapper">
  <jsp:include page="/WEB-INF/view/layout/management/sidebar.jsp"/>

  <div id="content-wrapper" class="d-flex flex-column">
    <div id="content">
      <jsp:include page="/WEB-INF/view/layout/management/navbar.jsp"/>

      <!-- Begin Page Content -->
      <div class="container-fluid">
        <h1 class="h3 mb-4 text-gray-800">Cashier Dashboard</h1>

        <!-- Stat Cards -->
        <div class="row">
          <div class="col-xl-3 col-md-6 mb-4">
            <div class="card border-left-primary shadow h-100 py-2">
              <div class="card-body">
                <div class="row no-gutters align-items-center">
                  <div class="col mr-2">
                    <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">Tổng số đơn trong ngày</div>
                    <div class="h5 mb-0 font-weight-bold text-gray-800">${orderCount != null ? orderCount : 0}</div>
                  </div>
                  <div class="col-auto">
                    <i class="fas fa-shopping-cart fa-2x text-gray-300"></i>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <div class="col-xl-3 col-md-6 mb-4">
            <div class="card border-left-success shadow h-100 py-2">
              <div class="card-body">
                <div class="row no-gutters align-items-center">
                  <div class="col mr-2">
                    <div class="text-xs font-weight-bold text-success text-uppercase mb-1">Đã thanh toán</div>
                    <div class="h5 mb-0 font-weight-bold text-gray-800">${orderCountCompleted != null ? orderCountCompleted : 0} Đơn</div>
                    <div class="text-xs text-gray-600">${revenueString != null ? revenueString : '0₫'}</div>
                  </div>
                  <div class="col-auto">
                    <i class="fas fa-check-circle fa-2x text-gray-300"></i>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <div class="col-xl-3 col-md-6 mb-4">
            <div class="card border-left-warning shadow h-100 py-2">
              <div class="card-body">
                <div class="row no-gutters align-items-center">
                  <div class="col mr-2">
                    <div class="text-xs font-weight-bold text-warning text-uppercase mb-1">Đang chờ</div>
                    <div class="h5 mb-0 font-weight-bold text-gray-800">${orderCountPending != null ? orderCountPending : 0} Đơn</div>
                    <div class="text-xs text-gray-600">${totalPendingRevenue != null ? totalPendingRevenue : '0₫'}</div>
                  </div>
                  <div class="col-auto">
                    <i class="fas fa-hourglass-half fa-2x text-gray-300"></i>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <div class="col-xl-3 col-md-6 mb-4">
            <div class="card border-left-danger shadow h-100 py-2">
              <div class="card-body">
                <div class="row no-gutters align-items-center">
                  <div class="col mr-2">
                    <div class="text-xs font-weight-bold text-danger text-uppercase mb-1">Hủy</div>
                    <div class="h5 mb-0 font-weight-bold text-gray-800">${orderCountCancelled != null ? orderCountCancelled : 0} Đơn</div>
                  </div>
                  <div class="col-auto">
                    <i class="fas fa-times-circle fa-2x text-gray-300"></i>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>


        <!-- Phần tiêu đề + lọc + nút tạo mới -->
        <div class="card shadow mb-4">
            <div class="card-header py-3 bg-gradient-primary text-white d-flex justify-content-between align-items-center flex-wrap">

                <!-- Bên trái: nút "Tất cả đơn hàng" -->
                <form action="${pageContext.request.contextPath}/orders" method="get" class="me-2">
                    <button type="submit" class="btn btn-light btn-sm text-primary fw-bold">
                        <i class="fas fa-list me-1"></i> Tất cả đơn hàng
                    </button>
                </form>

                <!-- Giữa: tiêu đề -->
                <div class="card-body">
                    <div class="btn-group mb-3" role="group">
                        <a href="${pageContext.request.contextPath}/cashier-dashboard?filterDate=${param.filterDate}" 
                           class="btn btn-secondary btn-sm ${empty param.status ? 'active' : ''}">
                            <i class="fas fa-list me-1"></i> Tất cả
                        </a>
                        <a href="${pageContext.request.contextPath}/cashier-dashboard?status=Completed&filterDate=${param.filterDate}" 
                           class="btn btn-success btn-sm ${param.status == 'Completed' ? 'active' : ''}">
                            <i class="fas fa-check-circle me-1"></i> Hoàn thành
                        </a>
                        <a href="${pageContext.request.contextPath}/cashier-dashboard?status=Pending&filterDate=${param.filterDate}" 
                           class="btn btn-warning btn-sm ${param.status == 'Pending' ? 'active' : ''}">
                            <i class="fas fa-hourglass-half me-1"></i> Đang chờ
                        </a>
                        <a href="${pageContext.request.contextPath}/cashier-dashboard?status=Cancelled&filterDate=${param.filterDate}" 
                           class="btn btn-danger btn-sm ${param.status == 'Cancelled' ? 'active' : ''}">
                            <i class="fas fa-times-circle me-1"></i> Đã hủy
                        </a>
                    </div>
                </div>

                <!-- Bên phải: lọc ngày + nút New Order -->
                <div class="d-flex align-items-center flex-shrink-0">
                    <form action="${pageContext.request.contextPath}/cashier-dashboard" method="get" class="d-flex align-items-center me-2">
                        <label for="filterDate" class="me-2 mb-0 fw-bold">Ngày:</label>
                        <input type="date" id="filterDate" name="filterDate" class="form-control form-control-sm me-2"
                               value="${param.filterDate != null ? param.filterDate : ''}"/>
                        <button type="submit" class="btn btn-light btn-sm text-primary">
                            <i class="fas fa-filter me-1"></i>
                        </button>
                    </form>

                    <div class="btn-neworder-top">
                        <form action="${pageContext.request.contextPath}/NewOrderServlet" method="get">
                            <button type="submit"><i class="fas fa-plus me-1"></i>New Order</button>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Phần nhóm nút trạng thái -->

        </div>

        <!-- Orders table -->
        <div class="card">
            <div class="card-header bg-gradient-primary">
                <i class="fas fa-list me-2"></i>10 đơn hàng mới nhất 
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-bordered table-hover">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Tổng tiền</th>
                                <th>Phải trả</th>
                                <th>Phương thức</th>
                                <th>Trạng thái</th>
                                <th>Thời gian tạo</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${orders}" var="o">
                                <tr>
                                    <td>${o.orderId}</td>
                                    <td>${o.totalAmount}</td>
                                    <td>${o.paymentAmount}</td>
                                    <td>${o.payMethod}</td>
                                    <td>
                                        ${o.status}
                                        <c:if test="${o.status eq 'Pending'}">
                                            <form action="${pageContext.request.contextPath}/editOrder" method="post" style="display:inline;">
                                                <input type="hidden" name="orderId" value="${o.orderId}"/>
                                                <button type="submit" class="btn btn-warning btn-sm mb-1">Chỉnh sửa</button>
                                            </form>
                                        </c:if>
                                    </td>
                                    <td><fmt:formatDate value="${o.createdAtAsDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty orders}">
                                <tr>
                                    <td colspan="6" class="text-center text-muted">Không có đơn hàng nào được tìm thấy</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>



    <jsp:include page="/WEB-INF/view/layout/management/footer.jsp"/>
  </div>
</div>

<jsp:include page="/WEB-INF/view/layout/management/scripts.jsp"/>

<script>
  document.addEventListener("DOMContentLoaded", function () {
    const dateInput = document.getElementById("filterDate");
    if (dateInput) {
      dateInput.addEventListener("change", function () {
        this.form.submit();
      });
    }
  });
</script>
