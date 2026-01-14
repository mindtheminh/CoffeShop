<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<%
    String cPath = request.getContextPath();
%>
<c:set var="cPath" value="${pageContext.request.contextPath}" />

<jsp:include page="/WEB-INF/view/layout/public/header.jsp">
    <jsp:param name="pageTitle" value="Đơn hàng của tôi - Yen Coffee"/>
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

    .nav-tabs {
        display: flex;
        gap: 10px;
        margin-bottom: 30px;
        flex-wrap: wrap;
        border-bottom: 2px solid rgba(199, 161, 122, 0.2);
        padding-bottom: 15px;
    }

    .nav-tabs a {
        padding: 12px 24px;
        border-radius: 8px;
        text-decoration: none;
        font-weight: 600;
        transition: all .3s;
        border: 2px solid transparent;
        color: #cfcfcf;
    }

    .nav-tabs a.active {
        background: var(--gold);
        color: #000;
    }

    .nav-tabs a:not(.active) {
        background: rgba(255,255,255,.05);
        border-color: rgba(255,255,255,.08);
    }

    .nav-tabs a:not(.active):hover {
        background: rgba(255,255,255,.08);
        color: #e9e9e9;
    }

    .orders-wrapper {
        display: flex;
        flex-direction: column;
        gap: 1.5rem;
    }

    .order-card {
        background: var(--card-bg);
        border-radius: 12px;
        border: 1px solid rgba(199, 161, 122, 0.25);
        padding: 1.5rem 1.75rem;
        display: flex;
        flex-direction: column;
        gap: 0.75rem;
    }

    .order-card-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        gap: 1rem;
        flex-wrap: wrap;
    }

    .order-id {
        font-weight: 700;
        font-size: 1rem;
    }

    .badge-status {
        padding: 6px 14px;
        border-radius: 999px;
        font-size: 0.85rem;
        font-weight: 600;
        border: 1px solid;
    }

    .badge-status.pending {
        background: rgba(241, 196, 15, .12);
        color: #f1c40f;
        border-color: rgba(241, 196, 15, .4);
    }

    .badge-status.paid,
    .badge-status.completed {
        background: rgba(46, 204, 113, .12);
        color: #2ecc71;
        border-color: rgba(46, 204, 113, .4);
    }

    .badge-status.cancelled {
        background: rgba(231, 76, 60, .12);
        color: #e74c3c;
        border-color: rgba(231, 76, 60, .4);
    }

    .order-meta {
        font-size: 0.9rem;
        color: #b9b9b9;
        display: flex;
        flex-wrap: wrap;
        gap: 0.75rem 1.5rem;
    }

    .order-meta span i {
        margin-right: 6px;
    }

    .order-footer {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-top: .5rem;
        gap: 1rem;
        flex-wrap: wrap;
    }

    .order-total {
        font-weight: 700;
        font-size: 1rem;
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

    .empty-state {
        background: var(--card-bg);
        border-radius: 12px;
        border: 1px dashed rgba(199, 161, 122, 0.5);
        padding: 2rem;
        text-align: center;
    }

    .empty-state h3 {
        color: var(--gold);
        margin-bottom: 0.75rem;
        font-size: 1.2rem;
    }

    .empty-state p {
        margin-bottom: 1rem;
        color: #cfcfcf;
    }

    .empty-state a {
        text-decoration: none;
    }
</style>

<!-- Page Header -->
<div class="page-header">
    <div class="container">
        <h1 class="page-title">
            <i class="fas fa-shopping-bag"></i> Đơn hàng của tôi
        </h1>
    </div>
</div>

<div class="container pb-5">

    <!-- Tabs -->
    <div class="nav-tabs">
        <a href="${cPath}/customer/my-profile">
            <i class="fas fa-user"></i> Thông tin
        </a>
        <a href="${cPath}/customer/my-orders" class="active">
            <i class="fas fa-shopping-bag"></i> Đơn hàng
        </a>
        <a href="${cPath}/customer/change-password">
            <i class="fas fa-key"></i> Đổi mật khẩu
        </a>
    </div>

    <!-- Nếu không có đơn -->
    <c:if test="${empty orders}">
        <div class="empty-state">
            <h3><i class="fas fa-coffee"></i> Bạn chưa có đơn hàng nào</h3>
            <p>Thử ghé menu và đặt một tách cà phê đầu tiên cùng YEN COFFEE HOUSE nhé!</p>
            <a href="${cPath}/home" class="btn-outline-gold">
                <i class="fas fa-mug-hot"></i> Về trang menu
            </a>
        </div>
    </c:if>

    <!-- Danh sách đơn -->
    <c:if test="${not empty orders}">
        <div class="orders-wrapper">

            <c:forEach var="order" items="${orders}">
                <div class="order-card">

                    <div class="order-card-header">
                        <div class="order-id">
                            <i class="fas fa-receipt"></i>
                            Mã đơn: <span>#${order.orderId}</span>
                        </div>

                        <div>
                            <span class="badge-status
                                  <c:if test="${order.status == 'Pending'}"> pending</c:if>
                                  <c:if test="${order.status == 'PAID' or order.status == 'Paid'}"> paid</c:if>
                                  <c:if test="${order.status == 'Completed'}"> completed</c:if>
                                  <c:if test="${order.status == 'Cancelled'}"> cancelled</c:if>
                                      ">
                                      <i class="fas fa-circle"></i>
                                  ${order.status}
                            </span>
                        </div>

                    </div>

                    <div class="order-meta">
                        <span>
                            <i class="far fa-calendar-alt"></i>
                            Ngày đặt: ${order.createdAt}
                        </span>
                        <span>
                            <i class="fas fa-money-bill-wave"></i>
                            Phương thức thanh toán:
                            <c:out value="${order.payMethod}" default="Không xác định" />
                        </span>
                        <span>
                            <i class="fas fa-map-marker-alt"></i>
                            Giao đến:
                            <c:out value="${order.shippingAddress}" default="Chưa cập nhật" />
                        </span>
                    </div>

                    <div class="order-footer">
                        <div class="order-total">
                            Tổng tiền:
                            <fmt:formatNumber value="${order.totalAmount}"
                                              type="number"
                                              pattern="#,##0 đ"/>
                        </div>

                        <a href="${cPath}/customer/my-order-details?id=${order.orderId}"
                           class="btn-outline-gold">
                            <i class="fas fa-eye"></i> Xem chi tiết
                        </a>
                    </div>

                </div>
            </c:forEach>

        </div>
    </c:if>
</div>

<jsp:include page="/WEB-INF/view/layout/public/footer.jsp"/>
<jsp:include page="/WEB-INF/view/layout/public/scripts.jsp"/>
