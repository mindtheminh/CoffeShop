<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %> <!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>POS - Chi tiết đơn hủy</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;700&family=JetBrains+Mono:wght@400;700&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>

    <style>
        body {
            background-color: #eef2f6;
            font-family: "Inter", sans-serif;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 30px 15px;
        }

        /* Nút quay lại */
        .back-nav {
            width: 100%;
            max-width: 500px;
            margin-bottom: 15px;
        }
        
        .btn-back {
            background: white;
            border: 1px solid #ddd;
            color: #555;
            padding: 8px 15px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            transition: all 0.2s;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
        }

        .btn-back:hover {
            background: #f8f9fa;
            color: #000;
            transform: translateY(-1px);
        }

        /* Khung hóa đơn */
        .invoice-card {
            background: #fff;
            width: 100%;
            max-width: 500px; /* Kích thước giống khổ giấy in nhiệt lớn hoặc A5 */
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.08);
            position: relative;
            overflow: hidden;
        }

        /* Hiệu ứng con dấu ĐÃ HỦY */
        .cancelled-stamp {
            position: absolute;
            top: 20px;
            right: 20px;
            border: 3px solid #dc3545;
            color: #dc3545;
            font-weight: 700;
            font-size: 1.2rem;
            padding: 5px 15px;
            border-radius: 8px;
            opacity: 0.2;
            transform: rotate(-15deg);
            text-transform: uppercase;
            pointer-events: none;
            z-index: 0;
        }

        /* Header hóa đơn */
        .invoice-header {
            text-align: center;
            margin-bottom: 30px;
            position: relative;
            z-index: 1;
        }

        .invoice-title {
            font-size: 1.5rem;
            font-weight: 800;
            color: #dc3545; /* Màu đỏ cảnh báo */
            margin-bottom: 5px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .invoice-meta {
            font-size: 0.9rem;
            color: #6c757d;
            margin-bottom: 5px;
            display: flex;
            justify-content: space-between;
            border-bottom: 2px dashed #eee;
            padding-bottom: 15px;
            margin-top: 20px;
        }

        /* Bảng sản phẩm */
        .table-custom {
            width: 100%;
            margin-bottom: 20px;
            font-size: 0.95rem;
        }

        .table-custom th {
            text-transform: uppercase;
            font-size: 0.75rem;
            color: #888;
            letter-spacing: 0.5px;
            padding-bottom: 10px;
            border-bottom: 1px solid #eee;
        }

        .table-custom td {
            padding: 12px 0;
            border-bottom: 1px solid #f8f9fa;
            vertical-align: top;
        }

        .item-name {
            font-weight: 600;
            color: #333;
            display: block;
        }
        
        .item-meta {
            font-size: 0.85rem;
            color: #888;
            font-family: "JetBrains Mono", monospace; /* Font monospace cho số */
        }

        .text-amount {
            font-family: "JetBrains Mono", monospace;
            font-weight: 700;
            text-align: right;
            color: #333;
        }

        /* Phần tổng tiền */
        .invoice-footer {
            margin-top: 20px;
            padding-top: 15px;
            border-top: 2px solid #333;
        }

        .total-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 1.2rem;
            font-weight: 800;
            color: #dc3545;
        }

        .note-text {
            text-align: center;
            font-size: 0.85rem;
            color: #999;
            margin-top: 30px;
            font-style: italic;
        }

        /* Cấu hình khi in */
        @media print {
            body {
                background: #fff;
                padding: 0;
            }
            .back-nav {
                display: none !important;
            }
            .invoice-card {
                box-shadow: none;
                border: none;
                max-width: 100%;
                padding: 0;
            }
            .invoice-title {
                color: #000; /* In đen trắng tốt hơn */
            }
            .total-row {
                color: #000;
            }
            .cancelled-stamp {
                border-color: #000;
                color: #000;
                opacity: 0.5;
            }
        }
    </style>
</head>
<body>

    <div class="back-nav">
        <a href="${pageContext.request.contextPath}/cashier-dashboard" class="btn-back">
            <i class="fa fa-arrow-left me-2"></i> Quay lại POS
        </a>
    </div>

    <div class="invoice-card">
        <div class="cancelled-stamp">ĐÃ HỦY / VOID</div>

        <div class="invoice-header">
            <div class="invoice-title">HÓA ĐƠN HỦY</div>
            <div class="text-muted">Phiếu xác nhận hủy đơn hàng</div>
        </div>

        <div class="invoice-meta">
            <div>
                <strong>Mã đơn:</strong> 
                <span class="text-dark">
                    <c:choose>
                        <c:when test="${not empty orderId}">#${orderId}</c:when>
                        <c:otherwise>---</c:otherwise>
                    </c:choose>
                </span>
            </div>
            <div>
                <span id="currentDate"></span>
            </div>
        </div>

        <table class="table-custom">
            <thead>
                <tr>
                    <th style="width: 50%; text-align: left;">Sản phẩm</th>
                    <th style="width: 20%; text-align: center;">SL</th>
                    <th style="width: 30%; text-align: right;">Thành tiền</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${orderItems}" var="item">
                    <tr>
                        <td>
                            <span class="item-name">
                                <c:forEach items="${productList}" var="p">
                                    <c:if test="${p.productId == item.productId}">
                                        ${p.name}
                                    </c:if>
                                </c:forEach>
                            </span>
                            <span class="item-meta">
                                @ <c:choose>
                                    <c:when test="${item.unitPrice != null}">${item.unitPrice}</c:when>
                                    <c:otherwise>0</c:otherwise>
                                </c:choose>
                            </span>
                        </td>
                        <td style="text-align: center; font-weight: 600;">x${item.quantity}</td>
                        <td class="text-amount">
                            <c:choose>
                                <c:when test="${item.subtotal != null}">${item.subtotal}</c:when>
                                <c:otherwise>0</c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>

                <c:if test="${empty orderItems}">
                    <tr>
                        <td colspan="3" class="text-center text-muted py-4">
                            Không có thông tin sản phẩm
                        </td>
                    </tr>
                </c:if>
            </tbody>
        </table>

        <div class="invoice-footer">
            <div class="total-row">
                <span>TỔNG CỘNG</span>
                <span>
                    <c:choose>
                        <c:when test="${not empty pendingOrder and pendingOrder.totalAmount != null}">
                            ${pendingOrder.totalAmount} ₫
                        </c:when>
                        <c:otherwise>0 ₫</c:otherwise>
                    </c:choose>
                </span>
            </div>
        </div>

        <div class="note-text">
            Đơn hàng này đã bị hủy và không có giá trị thanh toán.<br>
            Nhân viên xác nhận: _________________
        </div>

    </div>

    <script>
        // Script nhỏ để hiển thị ngày giờ hiện tại nếu backend không truyền xuống
        const dateElement = document.getElementById('currentDate');
        const now = new Date();
        const options = { year: 'numeric', month: '2-digit', day: '2-digit', hour: '2-digit', minute:'2-digit' };
        dateElement.innerText = now.toLocaleDateString('vi-VN', options);
    </script>
</body>
</html>