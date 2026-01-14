<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    String cPath = request.getContextPath();
    request.setAttribute("pageTitle", "Tạo đơn hàng mới - Yen Coffee");
%>
<jsp:include page="/WEB-INF/view/layout/management/header.jsp"/>

<style>
            :root {
                --bg-light: #ffffff; /* Nền trắng */
                --bg-lighter: #f8f9fa; /* Nền trắng nhẹ hơn cho body */
                --primary-blue: #4da6ff; /* Màu xanh nhạt hơn */
                --primary-blue-dark: #007bff; /* Màu xanh đậm hơn (cho hover) */
                --card-bg: #ffffff; /* Nền thẻ */
                --card-border: #dee2e6; /* Viền thẻ */
                --text-dark: #212529; /* Chữ đen/xám đậm */
                --text-muted: #6c757d; /* Chữ xám nhạt */
                --order-summary-bg: #f8f9fa; /* Nền tóm tắt đơn hàng */
            }

            body {
                background: var(--bg-lighter) !important;
                color: var(--text-dark) !important;
                font-family: "Poppins", sans-serif;
                min-height: 100vh;
                margin: 0;
            }

            .container-pos {
                padding: 15px 50px 40px 50px;
                background: transparent !important;
            }

            .container-pos .row {
                align-items: flex-start !important;
            }
            .order-summary {
                height: auto !important;
                max-height: none !important;
            }
            .col-lg-3 {
                align-self: flex-start !important;
            }
            .col-lg-9 {
                overflow-y: auto;
                max-height: calc(100vh - 180px);
                padding-right: 12px;
            }

            /* Tiêu đề Menu */
            .section-title.menu-title {
                color: var(--bg-light);
                background-color: var(--primary-blue);
                padding: 5px 10px;
                border-radius: 5px;
                font-weight: 700;
                margin-bottom: 1rem;
                display: inline-block;
            }
            /* SỬA ĐỔI: Tiêu đề Đơn hàng Xám Nhạt */
            .section-title.summary-title {
                color: var(--primary-blue-dark); /* Đổi màu chữ sang xanh đậm để nổi bật trên nền nhạt */
                background-color: #e9ecef; /* Màu xám rất nhạt */
                padding: 5px 10px;
                border-radius: 5px;
                font-weight: 700;
                margin-bottom: 1rem;
                display: inline-block;
            }

            .back-button-container {
                margin: 0.3rem 0 1rem 50px;
            }

            /* Nút Vàng cũ, thay bằng Xanh */
            .btn-primary-blue {
                background: var(--primary-blue) !important;
                color: #fff !important;
                border: none;
                font-weight: 600;
                border-radius: 8px;
                transition: all 0.3s;
            }
            .btn-primary-blue:hover {
                background: var(--primary-blue-dark) !important;
                color: #fff !important;
                transform: translateY(-2px);
                /* Cập nhật bóng đổ để phản ánh màu xanh nhạt mới */
                box-shadow: 0 4px 15px rgba(77, 166, 255, 0.3);
            }
            /* Nút Hủy đơn */
            .btn-cancel-order {
                background: #d9534f;
                color: white;
                font-weight: 600;
                border-radius: 8px;
                transition: all 0.3s;
            }
            .btn-cancel-order:hover {
                background: #c9302c;
            }

            /* --- PRODUCT CARD --- */
            .product-card {
                background: var(--card-bg);
                border: 1px solid var(--card-border);
                border-radius: 12px;
                padding: 12px;
                text-align: center;
                transition: all 0.2s;
                height: 100%;
                box-shadow: 0 2px 5px rgba(0,0,0,0.05); /* Thêm bóng nhẹ */
            }
            .product-card:hover {
                box-shadow: 0 0 12px rgba(0, 123, 255, 0.2);
                border-color: var(--primary-blue);
            }
            .product-card img {
                max-height: 120px;
                object-fit: cover;
            }
            .product-name {
                font-weight: 600;
                color: var(--primary-blue-dark); /* Tên sản phẩm màu xanh đậm */
                font-size: 0.95rem;
            }
            .product-price {
                color: var(--text-muted);
                font-size: 0.85rem;
                margin-bottom: 8px;
            }

            /* --- Quantity Control --- */
            .quantity-control {
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 6px;
                margin-top: 6px;
                margin-bottom: 8px;
            }

            .btn-qty {
                background: var(--primary-blue);
                color: #fff;
                border: 1px solid var(--primary-blue-dark);
                width: 30px;
                height: 30px;
                border-radius: 6px;
                font-size: 1.1rem;
                font-weight: 600;
                display: flex;
                align-items: center;
                justify-content: center;
                transition: all 0.2s ease;
            }
            .btn-qty:hover {
                background: var(--primary-blue-dark);
                color: #fff;
                transform: translateY(-2px);
            }

            .qty-input {
                width: 55px;
                text-align: center;
                background: var(--bg-lighter);
                border: 1px solid var(--card-border);
                color: var(--text-dark);
                border-radius: 6px;
                height: 30px;
                font-size: 0.9rem;
            }
            .qty-input:focus {
                outline: none;
                border-color: var(--primary-blue);
                box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25);
            }

            /* --- ORDER SUMMARY --- */
            .order-summary {
                background: var(--order-summary-bg); /* Nền xám nhạt */
                border: 1px solid var(--card-border);
                border-radius: 12px;
                padding: 18px;
                box-shadow: 0 4px 20px rgba(0,0,0,0.1);
                display: flex;
                flex-direction: column;
                justify-content: space-between;
                position: sticky;
                top: 75px; /* Giữ cố định khi cuộn */
            }

            /* Bảng tóm tắt đơn hàng */
            .order-table {
                width: 100%;
                color: var(--text-dark);
                border-collapse: collapse;
                margin-bottom: 12px;
                font-size: 0.85rem;
            }
            .order-table th, .order-table td {
                background: var(--bg-light); /* Nền trắng cho ô */
                color: var(--text-dark);
                border: 1px solid #e9ecef; /* Viền mỏng, nhạt */
                text-align: center;
                vertical-align: middle;
                padding: 8px 4px;
            }
            .order-table th {
                background: #e9ecef; /* Nền xám nhạt cho tiêu đề cột */
                font-weight: 600;
                color: var(--primary-blue-dark);
            }

            .order-total {
                border-top: 2px solid var(--primary-blue);
                font-weight: 700;
                color: var(--primary-blue-dark);
                text-align: right;
                padding-top: 8px;
                font-size: 1.1rem;
            }
            .order-total span {
                color: #d9534f; /* Màu đỏ cho tổng tiền */
                font-size: 1.2rem;
            }

            .btn-disabled {
                background: #ced4da;
                color: #868e96;
                border: none;
                width: 100%;
                font-weight: 600;
                border-radius: 8px;
                padding: 10px;
                cursor: not-allowed;
            }

            /* Sửa lại style chữ tạo hóa đơn để khớp với yêu cầu giữ nguyên */
            .btn-gold-original {
                background: var(--gold) !important; /* Dùng lại màu vàng ban đầu để giữ style */
                color: #000 !important;
                border: none;
                font-weight: 600;
                border-radius: 8px;
                transition: all 0.3s;
            }
            .btn-gold-original:hover {
                background: #e1ba91 !important;
                transform: translateY(-2px);
                box-shadow: 0 4px 15px rgba(199,161,122,0.3);
            }

            .text-danger.small {
                color: #dc3545 !important;
            }

            @media (max-width: 992px) {
                .container-pos {
                    padding: 10px 20px;
                }
                .back-button-container {
                    margin-left: 20px;
                }
                .order-summary {
                    margin-top: 20px;
                    position: relative; /* Bỏ sticky trên di động */
                    top: auto;
                }
            }
            /* ==== POS THEME UPDATE FOR PRODUCT MENU ==== */
            .product-card.pos-theme {
                background: linear-gradient(180deg, #ffffff 0%, #f7fcff 100%);
                border: 1px solid #d6e9ff;
                border-radius: 14px;
                padding: 14px;
                text-align: center;
                transition: all 0.25s ease-in-out;
                box-shadow: 0 3px 10px rgba(0, 128, 255, 0.08);
            }

            .product-card.pos-theme:hover {
                background: linear-gradient(180deg, #e6f3ff 0%, #ffffff 100%);
                border-color: #4da6ff;
                box-shadow: 0 6px 16px rgba(0, 128, 255, 0.18);
                transform: translateY(-2px);
            }

            .product-card.pos-theme .product-name {
                color: #0066cc;
                font-weight: 600;
                margin-top: 8px;
                font-size: 0.95rem;
            }

            .product-card.pos-theme .product-price {
                color: #ff8800;
                font-size: 0.9rem;
                margin-bottom: 6px;
            }

            .product-card.pos-theme .btn-add-product {
                background: linear-gradient(90deg, #4da6ff, #00c3ff);
                color: #fff !important;
                border: none;
                font-weight: 600;
                border-radius: 8px;
                padding: 6px 0;
                transition: all 0.2s ease;
            }

            .product-card.pos-theme .btn-add-product:hover {
                background: linear-gradient(90deg, #0090ff, #00a8ff);
                box-shadow: 0 3px 10px rgba(0, 160, 255, 0.35);
                transform: translateY(-2px);
            }

            .product-card.pos-theme .btn-qty {
                background: #00bcd4;
                border-color: #0097a7;
            }

            .product-card.pos-theme .btn-qty:hover {
                background: #0097a7;
            }

            .product-card.pos-theme .qty-input {
                background: #f1f9ff;
                border: 1px solid #cfe6ff;
            }

            .product-card.pos-theme .product-image img {
                border-radius: 10px;
                box-shadow: 0 2px 6px rgba(0,0,0,0.05);
            }

</style>

<div id="wrapper">
  <jsp:include page="/WEB-INF/view/layout/management/sidebar.jsp"/>

  <div id="content-wrapper" class="d-flex flex-column">
    <div id="content">
      <jsp:include page="/WEB-INF/view/layout/management/navbar.jsp"/>

    <div class="container-fluid" style="background-color:#f8f9fc;min-height:100vh;">
        <div class="back-button-container">
            <a href="${pageContext.request.contextPath}/cashier-dashboard" class="btn btn-primary-blue btn-sm">
                <i class="fa fa-arrow-left me-1"></i> Quay lại
            </a>



        </div>

        <div class="d-flex justify-content-between align-items-center px-3 mt-2 mb-2">
            <div></div>

            <form action="${pageContext.request.contextPath}/cancelledOrder" method="post">
                <input type="hidden" name="orderId" value="${orderId}">
                <button type="submit" 
                        class="btn btn-sm btn-cancel-order">
                    <i class="fa fa-times-circle me-1"></i> Hủy đơn
                </button>
            </form>
        </div>


        <div class="container-fluid container-pos">
            <div class="mb-2"><strong>Order ID:</strong>
                <c:choose>
                    <c:when test="${not empty orderId}">
                        ${orderId}
                    </c:when>
                    <c:otherwise>
                        không có
                    </c:otherwise>
                </c:choose>
                <h5 class="section-title menu-title">Menu</h5>
            </div>
            <div class="row row-cols-2 row-cols-md-3 row-cols-lg-4 g-3">
                <div class="col-lg-9 col-md-9">

                    <div class="row g-3">
                        <c:set var="orderIdFromRequest" value="${requestScope.orderId}" />

                        <c:set var="orderIdFromSession" value="${sessionScope.currentOrder != null ? sessionScope.currentOrder.orderId : null}" />

                        <c:set var="currentOrderId" value="${orderIdFromRequest != null ? orderIdFromRequest : orderIdFromSession}" />


                        <c:if test="${empty productList}">
                            <div class="text-center text-primary-blue py-5">Không có sản phẩm </div>
                        </c:if>

                        <c:forEach items="${productList}" var="p">
                            <div class="col">
                                <div class="product-card pos-theme">
                                    <div class="product-name">${p.name}</div>
                                    <div class="product-price fw-semibold">${p.price} ₫</div>

                                    <form action="${pageContext.request.contextPath}/NewOrderServlet" method="post" class="mt-2">
                                        <input type="hidden" name="orderId" value="${orderId}">
                                        <input type="hidden" name="productId" value="${p.productId}">
                                        <div class="quantity-control">
                                            <button type="button" class="btn-qty minus">−</button>
                                            <input type="text" name="quantity" value="1" class="qty-input">
                                            <button type="button" class="btn-qty plus">+</button>
                                        </div>
                                        <div class="text-danger small error-msg" style="display:none; margin-top:4px;">
                                            Vui lòng nhập số nguyên dương
                                        </div>
                                        <button type="submit" class="btn btn-add-product w-100">
                                            <i class="fa fa-cart-plus me-1"></i> Thêm
                                        </button>

                                        <c:if test="${not empty errorMessage and errorProductId == p.productId}">
                                            <div class="text-danger small mt-1">
                                                ${errorMessage}
                                            </div>
                                        </c:if>
                                    </form>
                                </div>
                            </div>
                        </c:forEach>

                    </div>
                </div>

                <div class="col-lg-3 col-md-3">
                    <h5 class="section-title summary-title">Đơn hàng hiện tại</h5>
                    <div class="order-summary">
                        <c:if test="${not empty pendingOrder}">
                            <div class="mb-2"><strong>Order ID:</strong>
                                <c:choose>
                                    <c:when test="${not empty orderId}">${orderId}</c:when>
                                    <c:otherwise>không có</c:otherwise>
                                </c:choose>
                            </div>
                        </c:if>

                        <table class="order-table">
                            <thead>
                                <tr><th>sản phẩm</th>
                                    <th>SL</th>
                                    <th>Đơn giá</th>
                                    <th>Tổng</th>
                                    <th></th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${orderItems}" var="item">
                                    <tr>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty productList}">
                                                    <c:forEach items="${productList}" var="p">
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
                                        <td>
                                            <c:choose>
                                                <c:when test="${item.unitPrice != null}">${item.unitPrice}</c:when>
                                                <c:otherwise>Không có</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${item.subtotal != null}">${item.subtotal}</c:when>
                                                <c:otherwise>Không có</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <form action="${pageContext.request.contextPath}/orderItem-delete" method="post" style="margin:0;">
                                                <input type="hidden" name="orderId" value="${orderId}">
                                                <input type="hidden" name="orderItemId" value="${item.orderItemId}">

                                                <button type="submit"
                                                        style="
                                                        background:none;
                                                        border:none;
                                                        color:#d9534f; /* Màu đỏ cho nút xóa */
                                                        font-size:1rem;
                                                        cursor:pointer;
                                                        "
                                                        title="Xóa sản phẩm">
                                                    <i class="fa-solid fa-trash"></i>
                                                </button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty orderItems}">
                                    <tr><td colspan="5" class="text-center" style="color: var(--text-muted);">Không có sản phẩm được chọn</td></tr>
                                </c:if>
                            </tbody>
                        </table>

                        <div class="order-total">
                            Tổng tiền
                            <span>
                                <c:choose>
                                    <c:when test="${not empty pendingOrder and pendingOrder.totalAmount != null}">
                                        ${pendingOrder.totalAmount} ₫
                                    </c:when>
                                    <c:otherwise>0 ₫</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        <div class="order-total">
                            Phải trả 
                            <span>
                                <c:choose>
                                    <c:when test="${not empty pendingOrder and pendingOrder.paymentAmount != null}">
                                        ${pendingOrder.paymentAmount} ₫
                                    </c:when>
                                    <c:otherwise>0 ₫</c:otherwise>
                                </c:choose>
                            </span>
                        </div>

                        <hr/>
                        <form action="${pageContext.request.contextPath}/NewOrderServlet" method="post" class="mb-3">
                            <input type="hidden" name="orderId" value="${orderId}">
                            <input 
                                type="text" 
                                name="note" 
                                id="note" 
                                class="form-control mb-3" 
                                placeholder="${empty pendingOrder.note ? 'Ghi chú' : pendingOrder.note}" 
                                />

                            <button type="submit" class="btn btn-primary-blue w-100 btn-sm">
                                <i class="fa fa-save me-1"></i> Xác nhận Ghi chú
                            </button>
                        </form>
                        <!-- Form nhập mã giảm giá -->
                        <form action="${pageContext.request.contextPath}/applyDiscount" method="post" class="d-flex mb-3">
                            <input type="hidden" name="orderId" value="${orderId}">

                            <input 
                                type="text" 
                                name="discountCode" 
                                class="form-control me-2" 
                                placeholder="Nhập mã"
                                style="max-width: 120px;" />

                            <button type="submit" class="btn btn-primary-blue">
                                Xác nhận
                            </button>
                        </form>

                        <c:if test="${not empty error}">
                            <div class="text-danger small mb-3">${error}</div>
                        </c:if>



                        <form action="${pageContext.request.contextPath}/invoice" method="post">
                            <input type="hidden"  name="orderID" value="${orderId}">

                            <input type="radio" name="paymethod" value="Tiền mặt" checked> Tiền mặt
                            <input type="radio" name="paymethod" value="PayOS"> Pay OS
                            <div class="mt-3">
                                <c:choose>
                                    <c:when test="${not empty orderItems}">
                                        <button type="submit" class="btn btn-gold-original w-100 p-2">
                                            <i class="fa fa-file-invoice"></i> Tạo hóa đơn
                                        </button>
                                    </c:when>
                                    <c:otherwise>
                                        <button type="submit" class="btn-disabled" disabled>
                                            <i class="fa fa-file-invoice"></i> Tạo hóa đơn 
                                        </button>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </form>

                    </div>
                </div>
            </div>

        </div>
      </div>

        <script>
            document.querySelectorAll('.product-card').forEach(card => {
                const input = card.querySelector('.qty-input');
                const plus = card.querySelector('.btn-qty.plus');
                const minus = card.querySelector('.btn-qty.minus');
                const error = card.querySelector('.error-msg');
                const form = card.querySelector('form');

                plus.addEventListener('click', (e) => {
                    e.preventDefault(); // Ngăn submit nhầm
                    let val = parseInt(input.value) || 1;
                    input.value = val + 1;
                    hideError();
                });

                minus.addEventListener('click', (e) => {
                    e.preventDefault();
                    let val = parseInt(input.value) || 1;
                    input.value = Math.max(1, val - 1);
                    hideError();
                });

                input.addEventListener('input', () => {
                    const val = input.value.trim();
                    // Cho phép nhập số nguyên dương
                    const valid = /^[0-9]+$/.test(val) && parseInt(val) > 0;
                    if (!valid) {
                        input.style.borderColor = 'red';
                        // Sửa tin nhắn lỗi cho hợp lý hơn với regex
                        error.innerHTML = 'Vui lòng nhập số nguyên dương';
                        error.style.display = 'block';
                    } else {
                        hideError();
                    }
                });

                // Thêm sự kiện khi mất focus để đảm bảo giá trị không rỗng hoặc 0
                input.addEventListener('blur', () => {
                    let val = parseInt(input.value) || 1;
                    if (val < 1) {
                        val = 1;
                    }
                    input.value = val;
                    hideError();
                });


                function hideError() {
                    input.style.borderColor = '';
                    error.style.display = 'none';
                }
            });

        </script>

    </div>

    <jsp:include page="/WEB-INF/view/layout/management/footer.jsp"/>
  </div>
</div>

<jsp:include page="/WEB-INF/view/layout/management/scripts.jsp"/>