<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
    String cPath = request.getContextPath();
    String orderId = request.getParameter("orderId");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment Debug</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: #f5f5f5;
            padding: 2rem;
        }
        .debug-card {
            background: white;
            border-radius: 12px;
            padding: 2rem;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            margin-bottom: 1rem;
        }
        .log-entry {
            padding: 0.5rem;
            margin: 0.25rem 0;
            border-left: 3px solid #0d6efd;
            background: #f8f9fa;
            font-family: monospace;
            font-size: 0.9rem;
        }
        .log-error {
            border-left-color: #dc3545;
            background: #fff5f5;
        }
        .log-success {
            border-left-color: #198754;
            background: #f0fff4;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="debug-card">
            <h2>Payment Debug Tool</h2>
            <p>Order ID: <strong><%= orderId != null ? orderId : "Not specified" %></strong></p>
            
            <div class="mb-3">
                <label>Enter Order ID:</label>
                <input type="text" id="orderIdInput" class="form-control" value="<%= orderId != null ? orderId : "" %>" placeholder="e.g., ORD001">
            </div>
            
            <button class="btn btn-primary" onclick="checkPayment()">
                <i class="fas fa-search"></i> Check Payment Status
            </button>
            
            <button class="btn btn-secondary" onclick="clearLogs()">
                <i class="fas fa-trash"></i> Clear Logs
            </button>
        </div>
        
        <div class="debug-card">
            <h4>Logs:</h4>
            <div id="logs"></div>
        </div>
        
        <div class="debug-card">
            <h4>Response:</h4>
            <pre id="response" style="background: #f8f9fa; padding: 1rem; border-radius: 8px;"></pre>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/js/all.min.js"></script>
    <script>
        function log(message, type = 'info') {
            const logsDiv = document.getElementById('logs');
            const entry = document.createElement('div');
            entry.className = 'log-entry';
            if (type === 'error') entry.classList.add('log-error');
            if (type === 'success') entry.classList.add('log-success');
            
            const timestamp = new Date().toLocaleTimeString();
            entry.textContent = `[${timestamp}] ${message}`;
            logsDiv.appendChild(entry);
            logsDiv.scrollTop = logsDiv.scrollHeight;
        }
        
        function clearLogs() {
            document.getElementById('logs').innerHTML = '';
            document.getElementById('response').textContent = '';
        }
        
        function checkPayment() {
            const orderId = document.getElementById('orderIdInput').value;
            
            if (!orderId) {
                log('Please enter an Order ID', 'error');
                return;
            }
            
            log('Checking payment status for order: ' + orderId);
            
            fetch('<%=cPath%>/payment/verify-payment?orderId=' + orderId, {
                method: 'POST'
            })
            .then(response => {
                log('Received response from server');
                return response.json();
            })
            .then(data => {
                log('Response parsed successfully', 'success');
                document.getElementById('response').textContent = JSON.stringify(data, null, 2);
                
                if (data.success) {
                    log('✓ Payment verified: ' + data.status, 'success');
                    if (data.status === 'PAID') {
                        log('✓ Payment is PAID! Order should be updated in database', 'success');
                    }
                } else {
                    log('✗ Payment verification failed: ' + data.message, 'error');
                }
            })
            .catch(error => {
                log('✗ Error: ' + error.message, 'error');
                console.error('Error:', error);
            });
        }
        
        // Auto-check if orderId is provided
        window.addEventListener('load', () => {
            const orderId = document.getElementById('orderIdInput').value;
            if (orderId) {
                log('Auto-checking payment for order: ' + orderId);
                checkPayment();
            }
        });
    </script>
</body>
</html>

