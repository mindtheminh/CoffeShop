<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>


<%
    String cPath = request.getContextPath();
%>
<c:set var="cPath" value="${pageContext.request.contextPath}" />

<jsp:include page="/WEB-INF/view/layout/public/header.jsp">
    <jsp:param name="pageTitle" value="Chi tiết đơn hàng - Yen Coffee"/>
</jsp:include>

<jsp:include page="/WEB-INF/view/layout/public/navbar.jsp"/>

<style>
    :root {
        --gold: #c7a17a;
        --dark-bg: #0f0f10;
        --card-bg: rgba(15, 15, 16, 0.9);
    }

    body {
        background: linear-gradient(135deg, #1a1a1d 0%, #0f0f10 100%);
        color: #e9e9e9;
        min-height: 100vh;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        padding-top: 80px;
    }

    .page-header {
        background: linear-gradient(135deg, rgba(199, 161, 122, 0.1) 0%, rgba(15, 15, 16, 0.8) 100%);
        backdrop-filter: blur(10px);
        border-bottom: 2px solid var(--gold);
        padding: 2rem 0;
        margin-bottom: 2rem;
    }

    .page-title {
        color: var(--gold);
        font-size: 2rem;
        font-weight: 700;
        margin: 0;
    }

    .breadcrumb {
        font-size: 0.9rem;
        color: #b9b9b9;
        margin-top: .5rem;
    }

    .breadcrumb a {
        color: #b9b9b9;
        text-decoration: none;
    }

    .breadcrumb a:hover {
        color: var(--gold);
    }

    .order-info-card {
        background: var(--card-bg);
        border-radius: 12px;
        border: 1px solid rgba(199, 161, 122, 0.3);
        padding: 1.5rem 1.75rem;
        margin-bottom: 1.5rem;
    }

    .order-info-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
        gap: .75rem 2rem;
        font-size: 0.95rem;
    }

    .order-info-label {
        font-weight: 600;
        color: #dcdcdc;
    }

    .order-info-value {
        color: #c2c2c2;
    }

    .table-wrapper {
        background: var(--card-bg);
        border-radius: 12px;
        border: 1px solid rgba(199, 161, 122, 0.25);
        padding: 1.5rem 1.75rem;
        overflow-x: auto;
    }

    table.order-items {
        width: 100%;
        border-collapse: collapse;
        font-size: 0.95rem;
    }

    table.order-items thead th {
        border-bottom: 1px solid rgba(255,255,255,.12);
        padding: 0.75rem;
        text-align: left;
        font-weight: 600;
        white-space: nowrap;
    }

    table.order-items tbody td {
        padding: 0.6rem 0.75rem;
        border-bottom: 1px solid rgba(255,255,255,.06);
        vertical-align: middle;
    }

    table.order-items tbody tr:last-child td {
        border-bottom: none;
    }

    .text-right {
        text-align: right;
    }

    .text-center {
        text-align: center;
    }

    .order-summary-row td {
        font-weight: 700;
        border-top: 1px solid rgba(255,255,255,.15);
    }

    .btn-outline-gold {
        padding: 0.6rem 1.4rem;
        border-radius: 999px;
        border: 1px solid var(--gold);
        color: var(--gold);
        background: transparent;
        text-decoration: none;
        font-weight: 600;
        font-size: 0.9rem;
        transition: all .25s ease;
        display: inline-flex;
        align-items: center;
        gap: 0.4rem;
    }

    .btn-outline-gold:hover {
        background: var(--gold);
        color: #000;
        box-shadow: 0 4px 12px rgba(199, 161, 122, 0.5);
        transform: translateY(-1px);
    }

    .mt-3 { margin-top: 1rem; }
</style>

<div class="page-header">
    <div class="container">
        <h1 class="page-title">
            <i class="fas fa-file-invoice"></i> Chi tiết đơn hàng
        </h1>
        <div class="breadcrumb">
            <a href="${cPath}/customer/my-orders">Đơn hàng của tôi</a>
            &nbsp;/&nbsp;
            <span>Chi tiết</span>
        </div>
    </div>
</div>

<div class="container pb-5">

    <!-- Nếu không có order -->
    <c:if test="${order == null}">
        <div class="order-info-card">
            <p>Không tìm thấy đơn hàng. Có thể đơn đã bị xoá hoặc bạn truy cập sai đường dẫn.</p>
            <a href="${cPath}/customer/my-orders" class="btn-outline-gold mt-3">
                <i class="fas fa-arrow-left"></i> Quay lại danh sách đơn
            </a>
        </div>
    </c:if>

    <c:if test="${order != null}">
        <!-- Thông tin tổng quan -->
        <div class="order-info-card">
            <div class="order-info-grid">
                <div>
                    <div class="order-info-label">Mã đơn hàng</div>
                    <div class="order-info-value">#${order.orderId}</div>
                </div>
                <div>
                    <div class="order-info-label">Trạng thái đơn</div>
                    <div class="order-info-value">${order.status}</div>
                </div>
                <div>
                    <div class="order-info-label">Ngày đặt</div>
                    <div class="order-info-value">${order.createdAt}</div>
                </div>
                <div>
                    <div class="order-info-label">Phương thức thanh toán</div>
                    <div class="order-info-value">
                        <c:out value="${order.payMethod}" default="Không xác định"/>
                    </div>
                </div>
                <div>
                    <div class="order-info-label">Số điện thoại liên hệ</div>
                    <div class="order-info-value">
                        <c:out value="${order.phoneContact}" default="Chưa cập nhật"/>
                    </div>
                </div>
                <div>
                    <div class="order-info-label">Địa chỉ giao hàng</div>
                    <div class="order-info-value">
                        <c:out value="${order.shippingAddress}" default="Chưa cập nhật"/>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bảng sản phẩm -->
        <div class="table-wrapper">
            <h5 style="margin-bottom:1rem;">Sản phẩm trong đơn</h5>

            <table class="order-items">
                <thead>
                <tr>
                    <th>#</th>
                    <th>Sản phẩm</th>
                    <th class="text-center">Số lượng</th>
                    <th class="text-right">Đơn giá</th>
                    <th class="text-right">Thành tiền</th>
                </tr>
                </thead>
                <tbody>
                <c:if test="${empty items}">
                    <tr>
                        <td colspan="5" class="text-center">
                            Không có sản phẩm trong đơn này.
                        </td>
                    </tr>
                </c:if>

                <c:if test="${not empty items}">
                    <c:forEach var="item" items="${items}" varStatus="loop">
                        <tr>
                            <td>${loop.index + 1}</td>
                            <!-- Tùy model của bạn, sửa lại getter cho đúng -->
                            <td>
                                <c:out value="${item.productName}" default="${item.productId}"/>
                            </td>
                            <td class="text-center">${item.quantity}</td>
                            <td class="text-right">
                                <fmt:formatNumber value="${item.unitPrice}"
                                                  type="number"
                                                  pattern="#,##0 đ"/>
                            </td>
                            <td class="text-right">
                                <fmt:formatNumber value="${item.unitPrice * item.quantity}"
                                                  type="number"
                                                  pattern="#,##0 đ"/>
                            </td>
                        </tr>
                    </c:forEach>

                    <!-- Tổng tiền -->
                    <tr class="order-summary-row">
                        <td colspan="4" class="text-right">Tổng tiền đơn hàng</td>
                        <td class="text-right">
                            <fmt:formatNumber value="${order.totalAmount}"
                                              type="number"
                                              pattern="#,##0 đ"/>
                        </td>
                    </tr>
                </c:if>
                </tbody>
            </table>

            <a href="${cPath}/customer/my-orders" class="btn-outline-gold mt-3">
                <i class="fas fa-arrow-left"></i> Quay lại danh sách đơn
            </a>
        </div>
    </c:if>

</div>

<jsp:include page="/WEB-INF/view/layout/public/footer.jsp"/>
<jsp:include page="/WEB-INF/view/layout/public/scripts.jsp"/>
