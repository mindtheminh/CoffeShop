<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
    String cPath = request.getContextPath();
    String orderId = (String) request.getAttribute("orderId");
    if (orderId == null) {
        orderId = request.getParameter("orderId");
    }
    if (orderId == null) {
        orderId = (String) session.getAttribute("successOrderId");
    }
    request.setAttribute("pageTitle", "Đặt hàng thành công - Yen Coffee House");
%>

<jsp:include page="/WEB-INF/view/layout/public/header.jsp"/>
<jsp:include page="/WEB-INF/view/layout/public/navbar.jsp"/>

<style>
  /* Import Google Fonts */
  @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&family=Inter:wght@400;600;700&family=Roboto+Mono:wght@400;600&display=swap');
  
  :root {
    --bg-dark: #0f0f0f;
    --bg-card: #1a1a1a;
    --bg-box: #1f1f1f;
    --bg-countdown: #2a2a2a;
    --border-coffee: #C89666;
    --text-green: #22C55E;
    --text-light: #e9e9e9;
    --text-gray: #9CA3AF;
    --shadow-coffee: rgba(200, 150, 102, 0.2);
    --shadow-green: rgba(34, 197, 94, 0.4);
  }
  
  * {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
  }
  
  body {
    background: var(--bg-dark);
    color: var(--text-light);
    font-family: "Poppins", "Inter", system-ui, -apple-system, "Segoe UI", Roboto, sans-serif;
    font-size: 16px;
    min-height: 100vh;
    display: flex;
    flex-direction: column;
    padding-top: 80px;
  }
  
  /* Main Content Container - Centered */
  .main-content {
    flex: 1;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 2rem 1rem;
    min-height: calc(100vh - 80px - 100px); /* Subtract header and footer */
  }
  
  /* Success Card */
  .success-card {
    max-width: 480px;
    width: 100%;
    background: var(--bg-card);
    border: 1px solid var(--border-coffee);
    border-radius: 16px;
    padding: 2.5rem;
    text-align: center;
    box-shadow: 0 0 20px var(--shadow-coffee);
    animation: slideUp 0.5s ease-out;
  }
  
  @keyframes slideUp {
    from {
      opacity: 0;
      transform: translateY(30px);
    }
    to {
      opacity: 1;
      transform: translateY(0);
    }
  }
  
  /* Success Icon with Glow */
  .success-icon {
    width: 100px;
    height: 100px;
    background: linear-gradient(135deg, var(--text-green) 0%, #16a34a 100%);
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    margin: 0 auto 1.5rem;
    animation: scaleIn 0.5s ease-out 0.2s both;
    box-shadow: 0 0 30px var(--shadow-green), 0 8px 25px var(--shadow-green);
    position: relative;
  }
  
  .success-icon::before {
    content: '';
    position: absolute;
    width: 120px;
    height: 120px;
    border-radius: 50%;
    background: var(--text-green);
    opacity: 0.2;
    filter: blur(15px);
    z-index: -1;
    animation: pulse 2s ease-in-out infinite;
  }
  
  @keyframes pulse {
    0%, 100% {
      transform: scale(1);
      opacity: 0.2;
    }
    50% {
      transform: scale(1.1);
      opacity: 0.3;
    }
  }
  
  @keyframes scaleIn {
    from {
      transform: scale(0);
    }
    to {
      transform: scale(1);
    }
  }
  
  .success-icon i {
    font-size: 50px;
    color: #fff;
    z-index: 1;
  }
  
  /* Title */
  .success-title {
    font-size: 1.75rem;
    font-weight: 700;
    color: var(--text-green);
    text-transform: uppercase;
    margin-bottom: 1rem;
    letter-spacing: 0.5px;
  }
  
  /* Description */
  .success-message {
    font-size: 1rem;
    color: var(--text-light);
    margin-bottom: 1.5rem;
    line-height: 1.6;
  }
  
  /* Order ID Box */
  .order-info {
    background: var(--bg-box);
    border: 1px solid #333;
    border-radius: 8px;
    padding: 0.75rem;
    margin: 1.5rem 0;
    font-family: "Roboto Mono", monospace;
  }
  
  .order-info strong {
    color: var(--text-light);
    font-size: 1rem;
    font-weight: 600;
  }
  
  /* Countdown Section */
  .countdown-section {
    background: var(--bg-countdown);
    border-radius: 8px;
    padding: 1rem;
    margin: 1.5rem 0;
  }
  
  .countdown-text {
    font-size: 0.95rem;
    color: var(--text-light);
    margin-bottom: 0.5rem;
  }
  
  .countdown-number {
    font-size: 2rem;
    font-weight: 700;
    color: var(--border-coffee);
    display: inline-block;
    min-width: 40px;
    font-family: "Roboto Mono", monospace;
  }
  
  .countdown-label {
    font-size: 0.9rem;
    color: var(--text-gray);
    margin-top: 0.25rem;
  }
  
  /* Button Group */
  .btn-group-custom {
    display: flex;
    gap: 0.75rem;
    justify-content: center;
    flex-wrap: wrap;
    margin-top: 2rem;
  }
  
  .btn-custom {
    padding: 0.75rem 1.5rem;
    font-size: 1rem;
    font-weight: 600;
    border-radius: 8px;
    text-decoration: none;
    display: inline-flex;
    align-items: center;
    gap: 0.5rem;
    transition: all 0.3s ease;
    border: none;
    cursor: pointer;
    min-width: 180px;
    justify-content: center;
  }
  
  .btn-primary-custom {
    background: var(--border-coffee);
    color: #000;
  }
  
  .btn-primary-custom:hover {
    filter: brightness(1.2);
    box-shadow: 0 4px 15px rgba(200, 150, 102, 0.5);
    transform: translateY(-2px);
    color: #000;
  }
  
  .btn-outline-custom {
    border: 2px solid var(--border-coffee);
    color: var(--border-coffee);
    background: transparent;
  }
  
  .btn-outline-custom:hover {
    background: var(--border-coffee);
    color: #000;
    filter: brightness(1.2);
    box-shadow: 0 4px 15px rgba(200, 150, 102, 0.5);
    transform: translateY(-2px);
  }
  
  /* Footer */
  .footer {
    background: var(--bg-dark);
    padding: 2rem 0;
    margin-top: auto;
    text-align: center;
    border-top: 1px solid rgba(200, 150, 102, 0.1);
  }
  
  .footer p {
    margin: 0;
    color: var(--text-gray);
    font-size: 0.875rem;
  }
  
  /* Responsive */
  @media (max-width: 768px) {
    .main-content {
      padding: 1.5rem 1rem;
      min-height: calc(100vh - 80px - 80px);
    }
    
    .success-card {
      padding: 2rem 1.5rem;
      max-width: 100%;
    }
    
    .success-title {
      font-size: 1.5rem;
    }
    
    .success-icon {
      width: 80px;
      height: 80px;
    }
    
    .success-icon i {
      font-size: 40px;
    }
    
    .btn-group-custom {
      flex-direction: column;
    }
    
    .btn-custom {
      width: 100%;
      min-width: auto;
    }
    
    .footer {
      padding: 1.5rem 0;
    }
  }
  
  @media (max-width: 480px) {
    .success-card {
      padding: 1.5rem 1rem;
    }
    
    .success-title {
      font-size: 1.25rem;
    }
    
    .countdown-number {
      font-size: 1.75rem;
    }
  }
</style>

<!-- Main Content -->
<div class="main-content">
    <div class="success-card">
        <!-- Success Icon -->
        <div class="success-icon">
            <i class="fas fa-check-circle"></i>
        </div>
        
        <!-- Title -->
        <h1 class="success-title">ĐẶT HÀNG THÀNH CÔNG!</h1>
        
        <!-- Description -->
        <p class="success-message">
            Cảm ơn bạn đã đặt hàng. Đơn hàng của bạn đã được xác nhận và đang được xử lý.
        </p>
        
        <!-- Order ID -->
        <c:if test="${not empty orderId}">
            <div class="order-info">
                <strong>Mã đơn hàng: #${orderId}</strong>
            </div>
        </c:if>
        
        <!-- Countdown -->
        <div class="countdown-section">
            <div class="countdown-text">
                Trang sẽ tự động chuyển về trang chủ sau
            </div>
            <div class="countdown-number" id="countdown">3</div>
            <div class="countdown-label">giây</div>
        </div>
        
        <!-- Action Buttons -->
        <div class="btn-group-custom">
            <a href="${pageContext.request.contextPath}/home" class="btn-custom btn-primary-custom" id="homeBtn">
                <i class="fas fa-home"></i>
                Quay về trang chủ
            </a>
            <a href="${pageContext.request.contextPath}/customer/my-orders" class="btn-custom btn-outline-custom">
                <i class="fas fa-list"></i>
                Xem đơn hàng của tôi
            </a>
        </div>
    </div>
</div>

<!-- Footer -->
<footer class="footer">
    <div class="container">
        <p>
            © 2025 YEN COFFEE HOUSE · 123 Phố Xanh · (+84) 888 999 000
        </p>
    </div>
</footer>

<jsp:include page="/WEB-INF/view/layout/public/scripts.jsp"/>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    let countdown = 3;
    const countdownElement = document.getElementById('countdown');
    const homeBtn = document.getElementById('homeBtn');
    const homeUrl = '${pageContext.request.contextPath}/home';
    
    // Countdown function
    function updateCountdown() {
        if (countdownElement) {
            countdownElement.textContent = countdown;
        }
        
        if (countdown <= 0) {
            window.location.href = homeUrl;
            return;
        }
        
        countdown--;
        setTimeout(updateCountdown, 1000);
    }
    
    // Start countdown when page loads
    document.addEventListener('DOMContentLoaded', function() {
        updateCountdown();
    });
    
    // Clear countdown if user clicks button
    if (homeBtn) {
        homeBtn.addEventListener('click', function() {
            countdown = 0; // Stop countdown
        });
    }
</script>
</body>
</html>
