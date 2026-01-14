<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>In Hóa Đơn - Yen Coffee</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
    
    <link href="https://fonts.googleapis.com/css2?family=Inconsolata:wght@400;700&family=Inter:wght@400;600&family=Dancing+Script:wght@700&family=Libre+Barcode+39&display=swap" rel="stylesheet">

    <style>
        :root {
            --bg-color: #e0e5ec;
            --paper-color: #ffffff;
            --ink-color: #2c2c2c;
            --accent-color: #4e73df;
        }

        body {
            background-color: var(--bg-color);
            font-family: 'Inter', sans-serif; /* Font chính cho tiêu đề */
            display: flex;
            justify-content: center;
            align-items: flex-start;
            min-height: 100vh;
            margin: 0;
            padding: 40px 20px;
            color: var(--ink-color);
        }

        /* Khung hóa đơn */
        .receipt-container {
            width: 100%;
            max-width: 380px; /* Khổ giấy in nhiệt thông dụng (80mm) */
            position: relative;
            filter: drop-shadow(0 10px 20px rgba(0,0,0,0.15));
        }

        .receipt {
            background: var(--paper-color);
            padding: 25px 20px 40px 20px;
            /* Tạo hiệu ứng răng cưa ở dưới cùng bằng CSS Gradient */
            background-image: 
                linear-gradient(135deg, transparent 5px, var(--paper-color) 5px), 
                linear-gradient(225deg, transparent 5px, var(--paper-color) 5px);
            background-position: bottom left;
            background-size: 20px 20px; /* Kích thước răng cưa */
            background-repeat: repeat-x;
            
            /* Cắt phần thừa phía dưới để lộ răng cưa */
            margin-bottom: 20px;
            clip-path: polygon(
                0 0, 
                100% 0, 
                100% calc(100% - 10px), 
                0 calc(100% - 10px)
            );
            /* Nếu clip-path phức tạp, dùng padding-bottom thay thế */
            padding-bottom: 30px; 
            border-radius: 5px 5px 0 0;
        }

        /* Nút quay lại - Floating */
        .back-btn-wrapper {
            position: absolute;
            top: 0;
            left: -60px;
        }
        .back-btn {
            background: #fff;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--ink-color);
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            text-decoration: none;
            transition: transform 0.2s;
        }
        .back-btn:hover {
            transform: scale(1.1);
            color: var(--accent-color);
        }

        /* Header */
        .brand-name {
            font-family: 'Dancing Script', cursive;
            font-size: 2.2rem;
            text-align: center;
            margin-bottom: 5px;
            margin-top: 0;
        }
        
        .store-info {
            text-align: center;
            font-size: 0.85rem;
            color: #666;
            margin-bottom: 15px;
            font-family: 'Inconsolata', monospace;
        }

        .divider {
            border-bottom: 2px dashed #ddd;
            margin: 15px 0;
        }

        .invoice-details {
            display: flex;
            justify-content: space-between;
            font-size: 0.85rem;
            font-family: 'Inconsolata', monospace;
            margin-bottom: 5px;
        }

        /* Table */
        .table-receipt {
            width: 100%;
            border-collapse: collapse;
            font-family: 'Inconsolata', monospace;
            font-size: 0.95rem;
        }

        .table-receipt th {
            text-align: left;
            text-transform: uppercase;
            font-size: 0.75rem;
            color: #888;
            padding-bottom: 8px;
            border-bottom: 1px solid #eee;
        }
        
        .table-receipt td {
            padding: 8px 0;
            vertical-align: top;
        }

        .col-item { width: 45%; }
        .col-qty { width: 15%; text-align: center; }
        .col-price { width: 20%; text-align: right; }
        .col-total { width: 20%; text-align: right; font-weight: 700; }

        .item-name {
            display: block;
            font-weight: 600;
        }

        /* Total Section */
        .summary-section {
            margin-top: 15px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-family: 'Inconsolata', monospace;
        }

        .total-label {
            font-size: 1.1rem;
            font-weight: 700;
            text-transform: uppercase;
        }

        .total-amount {
            font-size: 1.4rem;
            font-weight: 800;
        }

        /* Barcode Area */
        .barcode-area {
            text-align: center;
            margin-top: 25px;
        }
        
        .barcode-font {
            font-family: 'Libre Barcode 39', cursive;
            font-size: 40px;
            line-height: 1;
            margin-bottom: 5px;
        }

        .thank-you {
            text-align: center;
            font-size: 0.8rem;
            margin-top: 10px;
            font-style: italic;
            color: #777;
        }

        /* Nút In */
        .btn-print-container {
            margin-top: 20px;
            text-align: center;
        }
        
        .btn-print {
            background-color: var(--ink-color);
            color: #fff;
            border: none;
            padding: 12px 30px;
            border-radius: 50px;
            font-family: 'Inter', sans-serif;
            font-weight: 600;
            font-size: 0.95rem;
            cursor: pointer;
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
            transition: all 0.3s ease;
        }

        .btn-print:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(0,0,0,0.25);
        }

        /* Ẩn khi in */
        @media print {
            body {
                background: none;
                padding: 0;
                color: #000;
            }
            .back-btn-wrapper, .btn-print-container {
                display: none !important;
            }
            .receipt-container {
                box-shadow: none;
                filter: none;
                max-width: 100%;
                width: 100%;
            }
            .receipt {
                margin: 0;
                padding: 0;
                clip-path: none; /* Bỏ hiệu ứng cắt khi in thật */
                background-image: none;
            }
        }
    </style>
</head>
<body>

    <div class="receipt-container">
        
        <div class="back-btn-wrapper">
            <a href="${pageContext.request.contextPath}/cashier-dashboard" class="back-btn" title="Quay lại">
                <i class="fas fa-arrow-left"></i>
            </a>
        </div>

        <div class="receipt">
            <h1 class="brand-name">Yen Coffee</h1>
            <div class="store-info">
                <div>Thôn 3 Thạch Hòa, Hòa Lạc, Hà Nội</div>
                <div>Hotline: 0369 632 378</div>
            </div>

            <div class="divider"></div>

            <div class="invoice-details">
                <span>Mã đơn:</span>
                <strong>
                    <c:choose>
                        <c:when test="${not empty pendingOrder.orderId}">#${pendingOrder.orderId}</c:when>
                        <c:otherwise>---</c:otherwise>
                    </c:choose>
                </strong>
            </div>
            <div class="invoice-details">
                <span>Ngày:</span>
                <span>
                    <c:choose>
                        <c:when test="${not empty currentTime}"><fmt:formatDate value="${currentTime}" pattern="dd/MM/yy HH:mm" /></c:when>
                        <c:otherwise><script>document.write(new Date().toLocaleDateString('vi-VN'));</script></c:otherwise>
                    </c:choose>
                </span>
            </div>
            <c:if test="${not empty sessionScope.authUser}">
                <div class="invoice-details">
                    <span>Thu ngân:</span>
                    <span>${sessionScope.authUser.fullName}</span>
                </div>
            </c:if>

            <div class="divider"></div>

            <table class="table-receipt">
                <thead>
                    <tr>
                        <th class="col-item">Món</th>
                        <th class="col-qty">SL</th>
                        <th class="col-price">Đ.Giá</th>
                        <th class="col-total">Tổng</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${orderItems}" var="item">
                        <tr>
                            <td>
                                <span class="item-name">
                                    <c:forEach items="${productList}" var="p">
                                        <c:if test="${p.productId == item.productId}">${p.name}</c:if>
                                    </c:forEach>
                                </span>
                            </td>
                            <td class="col-qty item-quantity">
                                ${item.quantity != null ? item.quantity : 0}
                            </td>
                            <td class="col-price">
                                <c:if test="${item.unitPrice != null}">
                                    <fmt:formatNumber value="${item.unitPrice}" pattern="#,###"/>
                                </c:if>
                            </td>
                            <td class="col-total">
                                <c:if test="${item.subtotal != null}">
                                    <fmt:formatNumber value="${item.subtotal}" pattern="#,###"/>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                    
                    <c:if test="${empty orderItems}">
                        <tr><td colspan="4" style="text-align:center; padding: 20px 0;">Chưa có sản phẩm nào</td></tr>
                    </c:if>
                </tbody>
            </table>

            <div class="divider"></div>

            <div class="summary-section" style="color: #666; font-size: 0.9rem;">
                <span>Tổng số lượng:</span>
                <span id="total-quantity">0</span>
            </div>

            <div class="summary-section" style="margin-top: 10px;">
                <span class="total-label">Thành tiền</span>
                <span class="total-amount">
                    <c:choose>
                        <c:when test="${not empty pendingOrder and pendingOrder.totalAmount != null}">
                            <fmt:formatNumber value="${pendingOrder.totalAmount}" pattern="#,###"/>
                        </c:when>
                        <c:otherwise>0</c:otherwise>
                    </c:choose> ₫
                </span>
            </div>

            <div class="barcode-area">
                <div class="barcode-font">
                    <c:choose>
                        <c:when test="${not empty pendingOrder.orderId}">*${pendingOrder.orderId}*</c:when>
                        <c:otherwise>*DEMO*</c:otherwise>
                    </c:choose>
                </div>
                <div class="thank-you">Cảm ơn & Hẹn gặp lại quý khách!</div>
                <div class="thank-you" style="font-size: 0.7rem;">Wifi: YenCoffee_Free / Pass: 12345678</div>
            </div>

        </div> <div class="btn-print-container">
            <button class="btn-print" onclick="window.print()">
                <i class="fas fa-print me-2"></i> IN HÓA ĐƠN
            </button>
        </div>

    </div>

    <script>
        function calculateTotalQuantity() {
            const quantityCells = document.querySelectorAll('.item-quantity');
            let totalQuantity = 0;
            quantityCells.forEach(cell => {
                const quantity = parseInt(cell.textContent.trim());
                if (!isNaN(quantity)) {
                    totalQuantity += quantity;
                }
            });
            const totalQuantityElement = document.getElementById('total-quantity');
            if (totalQuantityElement) {
                totalQuantityElement.textContent = totalQuantity;
            }
        }
        document.addEventListener('DOMContentLoaded', calculateTotalQuantity);
    </script>
</body>
</html>