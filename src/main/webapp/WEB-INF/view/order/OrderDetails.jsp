<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<%
    String cPath = request.getContextPath();
    request.setAttribute("pageTitle", "Chi tiết đơn hàng - Yen Coffee");
%>
<jsp:include page="/WEB-INF/view/layout/management/header.jsp"/>

<div id="wrapper">
  <jsp:include page="/WEB-INF/view/layout/management/sidebar.jsp"/>

  <div id="content-wrapper" class="d-flex flex-column">
    <div id="content">
      <jsp:include page="/WEB-INF/view/layout/management/navbar.jsp"/>

            <div class="container-fluid" style="background-color:#f8f9fc; min-height:100vh;">

                <!-- Page Heading -->
                <div class="d-sm-flex align-items-center justify-content-between mb-4">
                    <div class="d-flex align-items-center">
                        <h1 class="h3 mb-0 text-gray-800">
                            <i class="fas fa-receipt me-2"></i>Chi tiết đơn hàng #${orderId}
                        </h1>
                    </div>


                </div>

                <!-- Success/Error Messages -->
                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle me-2"></i>${successMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-circle me-2"></i>${errorMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <!-- Order Info -->
                <div class="card shadow-sm mb-4">
                    <div class="card-header bg-gradient-primary text-white fw-bold">
                        <a href="${pageContext.request.contextPath}/orders" 
                           class="btn btn-light border shadow-sm">
                            <i class="fas fa-arrow-left me-1"></i> Quay lại danh sách
                        </a>
                        <i class="fas fa-info-circle me-2"></i>Thông tin đơn hàng
                    </div>


                    <div class="card-body">
                        <div class="row mb-2">
                            <div class="col-md-4">
                                <strong>ID Đơn:</strong> ${order.orderId}
                            </div>
                            <div class="col-md-4">
                                <strong>Người tạo: </strong> ${user.fullName} 
                            </div>
                            <div class="col-md-4">
                                <strong>Trạng thái:</strong>
                                <span class="badge
                                      ${order.status eq 'Completed' ? 'bg-success' :
                                        order.status eq 'Pending' ? 'bg-warning text-dark' :
                                        order.status eq 'Processing' ? 'bg-info' :
                                        order.status eq 'Cancelled' ? 'bg-danger' : 'bg-secondary'}">
                                          ${order.status}
                                      </span>
                                </div>
                                <div class="col-md-4">
                                    <strong>Loại đơn:</strong> 
                                    <c:choose>
                                        <c:when test="${orderEntity.orderType eq 'Online' or (orderEntity.shippingAddress != null and not empty orderEntity.shippingAddress)}">
                                            <span class="badge bg-primary">Đơn online</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary">Đơn tại quầy</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="col-md-4">
                                    <strong>Ghi chú (Nếu có) </strong> ${order.note} 
                                </div>
                                <div class="col-md-4">
                                    <strong>Thời gian:</strong>
                                    <fmt:formatDate value="${order.createdAtAsDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
                                </div>
                                <div class="col-md-4">
                                    <strong>Sửa đổi cuối:</strong>
                                    <fmt:formatDate value="${order.updatedAtAsDate}" pattern="yyyy-MM-dd HH:mm:ss"/> 
                                </div>
                            </div>
                            <div class="row mb-2">
                                <div class="col-md-4">
                                    <strong>Tổng tiền:</strong> <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫"/>
                                </div>
                                <div class="col-md-4">
                                    <strong>Phải trả:</strong> <fmt:formatNumber value="${order.paymentAmount}" type="currency" currencySymbol="₫"/>
                                </div>
                                <div class="col-md-4">
                                    <strong>Phương thức thanh toán:</strong> 
                                    <c:choose>
                                        <c:when test="${order.payMethod eq 'Cash' or order.payMethod eq 'COD'}">
                                            COD (Tiền mặt khi nhận hàng)
                                        </c:when>
                                        <c:when test="${order.payMethod eq 'PayOS'}">
                                            PayOS (Chuyển khoản ngân hàng)
                                        </c:when>
                                        <c:otherwise>
                                            ${order.payMethod != null ? order.payMethod : 'Chưa xác định'}
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="row mb-2">
                                <div class="col-md-6">
                                    <strong>Số điện thoại:</strong> ${order.phoneContact != null ? order.phoneContact : 'Chưa có'}
                                </div>
                                <div class="col-md-6">
                                    <strong>Địa chỉ giao hàng:</strong> ${order.shippingAddress != null ? order.shippingAddress : 'Chưa có'}
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Order Items -->
                    <div class="card shadow-sm mb-4">
                        <div class="card-header bg-gradient-info text-white fw-bold">
                            <i class="fas fa-box-open me-2"></i>Danh sách sản phẩm
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-bordered table-hover align-middle">
                                    <thead class="table-light">
                                        <tr>
                                            <th>#</th>
                                            <th>Tên sản phẩm</th>
                                            <th>Số lượng</th>
                                            <th>Đơn giá</th>
                                            <th>Thành tiền</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${orderItems}" var="item" varStatus="loop">
                                            <tr>
                                                <td>${loop.index + 1}</td>
                                                <td>  <c:choose>
                                                        <c:when test="${not empty prodsuctList}">
                                                            <c:forEach items="${prodsuctList}" var="p">
                                                                <c:if test="${p.productId == item.productId}">
                                                                    ${p.name}
                                                                </c:if>
                                                            </c:forEach>
                                                        </c:when>
                                                        <c:otherwise>
                                                            Không có
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>${item.quantity}</td>
                                                <td><fmt:formatNumber value="${item.unitPrice}" type="currency" currencySymbol="₫"/></td>
                                                <td><fmt:formatNumber value="${item.subtotal}" type="currency" currencySymbol="₫"/></td>
                                            </tr>
                                        </c:forEach>
                                        <c:if test="${empty orderItems}">
                                            <tr>
                                                <td colspan="5" class="text-center text-muted">Không có sản phẩm nào trong đơn này</td>
                                            </tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <!-- Optional: Actions -->
                    <div class="text-end">
                        <c:set var="isOnlineOrder" value="${orderEntity.orderType eq 'Online' or (orderEntity.shippingAddress != null and not empty orderEntity.shippingAddress)}" />
                        
                        <!-- Đơn Pending: có thể sửa/hủy -->
                        <c:if test="${order.status eq 'Pending'}">
                            <!-- Đơn online: có nút Xác nhận đơn (Pending → Processing) -->
                            <c:if test="${isOnlineOrder}">
                                <form action="${pageContext.request.contextPath}/orders/accept" method="post" class="d-inline" 
                                      onsubmit="return confirm('Bạn có chắc chắn muốn xác nhận đơn hàng #${orderId}?');">
                                    <input type="hidden" name="orderId" value="${orderId}">
                                    <button type="submit" class="btn btn-primary me-2">
                                        <i class="fas fa-check me-1"></i> Xác nhận đơn
                                    </button>
                                </form>
                            </c:if>
                            
                            <!-- Cả đơn cashier và online đều có thể sửa/hủy khi Pending -->
                            <form action="${pageContext.request.contextPath}/editOrder" method="post" class="d-inline me-2">
                                <input type="hidden" name="orderId" value="${orderId}">
                                <button type="submit" class="btn btn-warning">
                                    <i class="fas fa-edit me-1"></i> Chỉnh sửa đơn
                                </button>
                            </form>
                            
                            <form action="${pageContext.request.contextPath}/cancelledOrder" method="post" class="d-inline" 
                                  onsubmit="return confirm('Bạn có chắc chắn muốn hủy đơn hàng #${orderId}?');">
                                <input type="hidden" name="orderId" value="${orderId}">
                                <button type="submit" class="btn btn-danger">
                                    <i class="fas fa-times me-1"></i> Hủy đơn
                                </button>
                            </form>
                        </c:if>
                        
                        <!-- Đơn Processing: chỉ có thể xác nhận hoàn thành (Processing → Completed) -->
                        <c:if test="${order.status eq 'Processing'}">
                            <form action="${pageContext.request.contextPath}/orders/confirm" method="post" class="d-inline" 
                                  onsubmit="return confirm('Bạn có chắc chắn muốn xác nhận đơn hàng #${orderId} đã hoàn thành?');">
                                <input type="hidden" name="orderId" value="${orderId}">
                                <button type="submit" class="btn btn-success">
                                    <i class="fas fa-check-circle me-1"></i> Xác nhận hoàn thành
                                </button>
                            </form>
                        </c:if>
                        
                        <!-- Đơn cashier (không phải online): có thể sửa nếu chưa Completed -->
                        <c:if test="${not isOnlineOrder and order.status ne 'Completed' and order.status ne 'Cancelled'}">
                            <form action="${pageContext.request.contextPath}/editOrder" method="post" class="d-inline">
                                <input type="hidden" name="orderId" value="${orderId}">
                                <button type="submit" class="btn btn-warning">
                                    <i class="fas fa-edit me-1"></i> Chỉnh sửa đơn
                                </button>
                            </form>
                        </c:if>
                        
                        <!-- Đơn Completed hoặc Cancelled: không có nút hành động -->
                        <c:if test="${order.status eq 'Completed' or order.status eq 'Cancelled'}">
                            <span class="text-muted">
                                <i class="fas fa-info-circle me-1"></i>
                                Đơn hàng ${order.status eq 'Completed' ? 'đã hoàn thành' : 'đã bị hủy'} - không thể thay đổi
                            </span>
                        </c:if>
                    </div>

                </div>
            </div>

    <jsp:include page="/WEB-INF/view/layout/management/footer.jsp"/>
  </div>
</div>

<jsp:include page="/WEB-INF/view/layout/management/scripts.jsp"/>
