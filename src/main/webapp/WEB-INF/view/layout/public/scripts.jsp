<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- JS Libraries -->
<script src="${pageContext.request.contextPath}/assets/js/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/jquery-migrate-3.0.1.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/popper.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/jquery.easing.1.3.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/jquery.waypoints.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/jquery.stellar.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/owl.carousel.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/jquery.magnific-popup.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/aos.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/jquery.animateNumber.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/bootstrap-datepicker.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/jquery.timepicker.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/scrollax.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/common.js"></script>

<!-- Toast Notification Container - Center of screen -->
<div class="toast-container position-fixed" style="top: 50%; left: 50%; transform: translate(-50%, -50%); z-index: 99999; pointer-events: none;">
    <div id="toastNotification" class="toast shadow-lg" role="alert" aria-live="assertive" aria-atomic="true" style="min-width: 400px; max-width: 500px; border: none; border-radius: 12px; overflow: hidden; pointer-events: auto;">
        <div class="toast-header" id="toastHeader" style="border-bottom: 2px solid;">
            <i id="toastIcon" class="fas me-2 fs-5"></i>
            <strong class="me-auto" id="toastTitle">Thông báo</strong>
            <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
        </div>
        <div class="toast-body" id="toastMessage" style="font-size: 0.95rem; padding: 1.25rem;"></div>
    </div>
</div>

<!-- Confirm Modal - Dark Mode Coffee Theme (Perfectly Centered) -->
<div class="modal fade" id="confirmModal" tabindex="-1" aria-labelledby="confirmModalLabel" aria-hidden="true" data-bs-backdrop="true" data-bs-keyboard="true" style="z-index: 99999;">
    <div class="modal-dialog confirm-modal-centered" style="margin: 0; max-width: 500px; width: 90%;">
        <div class="modal-content" id="confirmModalContent" style="border: 1px solid rgba(255,255,255,0.1); border-radius: 12px; overflow: hidden; box-shadow: 0 8px 25px rgba(0,0,0,0.4); background-color: #2B2B2B;">
            <div class="modal-header" style="background: linear-gradient(135deg, #1F1F1F 0%, #2B2B2B 100%); color: #FFFFFF; border-bottom: 1px solid rgba(255,255,255,0.1); padding: 1.5rem 1.75rem; text-align: center; position: relative;">
                <h5 class="modal-title fw-bold mb-0 d-flex align-items-center justify-content-center" id="confirmModalLabel" style="font-family: 'Poppins', 'Inter', 'Roboto', sans-serif; font-size: 1.25rem; letter-spacing: 0.5px; color: #FFFFFF; width: 100%;">
                    <i class="fas fa-question-circle me-2" style="font-size: 1.5rem; color: #F0C987;"></i>Xác nhận hành động
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close" style="position: absolute; top: 1rem; right: 1rem; filter: brightness(0) invert(1); opacity: 0.8; transition: opacity 0.2s ease;"></button>
            </div>
            <div class="modal-body p-4" style="background-color: #2B2B2B; text-align: center;">
                <div id="confirmModalMessage" style="font-family: 'Poppins', 'Inter', 'Roboto', sans-serif; font-size: 1.1rem; font-weight: 500; color: #BFBFBF; line-height: 1.6; margin-bottom: 0.75rem;">
                    Bạn có chắc chắn muốn thực hiện hành động này?
                </div>
                <div id="confirmModalSubMessage" style="font-family: 'Poppins', 'Inter', 'Roboto', sans-serif; font-size: 0.9rem; color: #888888; line-height: 1.5; margin-top: 0.5rem;">
                    Hành động này có thể ảnh hưởng đến hoạt động của hệ thống.
                </div>
            </div>
            <div class="modal-footer border-top-0 p-4" style="background-color: #2B2B2B; border-top: 1px solid rgba(255,255,255,0.1); justify-content: center; gap: 1rem;">
                <button type="button" class="btn" id="confirmModalCancel" data-bs-dismiss="modal" style="border-radius: 8px; padding: 0.65rem 2rem; min-width: 120px; font-weight: 600; font-family: 'Poppins', 'Inter', 'Roboto', sans-serif; background-color: #444444; border-color: #444444; color: #FFFFFF; transition: all 0.3s ease;">
                    <i class="fas fa-times me-1"></i> Hủy
                </button>
                <button type="button" class="btn" id="confirmModalOk" style="border-radius: 8px; padding: 0.65rem 2rem; min-width: 120px; font-weight: 600; font-family: 'Poppins', 'Inter', 'Roboto', sans-serif; background-color: #C89666; border-color: #C89666; color: #FFFFFF; transition: all 0.3s ease;">
                    <i class="fas fa-check me-1"></i> Xác nhận
                </button>
            </div>
        </div>
    </div>
</div>

<style>
/* Modal Backdrop with Blur Effect */
#confirmModal.show .modal-backdrop {
    background-color: rgba(0, 0, 0, 0.6);
    backdrop-filter: blur(4px);
    -webkit-backdrop-filter: blur(4px);
}

.modal-backdrop {
    background-color: rgba(0, 0, 0, 0.6) !important;
    backdrop-filter: blur(4px);
    -webkit-backdrop-filter: blur(4px);
    transition: opacity 0.3s ease;
}

/* Perfect Centering - Fixed Position */
.confirm-modal-centered {
    position: fixed !important;
    top: 50% !important;
    left: 50% !important;
    transform: translate(-50%, -50%) !important;
    margin: 0 !important;
    z-index: 1055 !important;
    display: flex !important;
    align-items: center !important;
    justify-content: center !important;
    animation: modalFadeIn 0.3s ease-out;
}

/* Perfect Center Animation - Compatible with transform */
@keyframes modalFadeIn {
    from {
        opacity: 0;
        transform: translate(-50%, -50%) scale(0.95);
    }
    to {
        opacity: 1;
        transform: translate(-50%, -50%) scale(1);
    }
}

/* Ensure modal backdrop covers full screen */
.modal-backdrop {
    position: fixed !important;
    top: 0 !important;
    left: 0 !important;
    width: 100vw !important;
    height: 100vh !important;
    z-index: 1050 !important;
}

/* Override Bootstrap's modal-dialog-centered if needed */
.modal-dialog-centered {
    display: flex;
    align-items: center;
    min-height: calc(100% - 1rem);
    justify-content: center;
}

/* Button Hover Effects */
#confirmModalCancel:hover {
    background-color: #555555 !important;
    border-color: #555555 !important;
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(68, 68, 68, 0.4);
}

#confirmModalOk:hover {
    background-color: #D8A96C !important;
    border-color: #D8A96C !important;
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(200, 150, 102, 0.5);
}

#confirmModalCancel:active,
#confirmModalOk:active {
    transform: translateY(0);
}

#confirmModalCancel:focus,
#confirmModalOk:focus {
    outline: 2px solid rgba(200, 150, 102, 0.5);
    outline-offset: 2px;
}

/* Close Button Hover */
.btn-close:hover {
    opacity: 1 !important;
}

/* Responsive Design */
@media (max-width: 768px) {
    .modal-dialog {
        width: 90% !important;
        max-width: 450px !important;
        margin: 1rem auto !important;
    }
    
    #confirmModalContent {
        margin: 0;
    }
    
    .modal-header {
        padding: 1.25rem 1.5rem !important;
    }
    
    .modal-body {
        padding: 1.5rem 1rem !important;
    }
    
    .modal-footer {
        flex-direction: column;
        gap: 0.75rem !important;
        padding: 1.25rem 1rem !important;
    }
    
    #confirmModalCancel,
    #confirmModalOk {
        width: 100%;
        min-width: unset !important;
    }
    
    #confirmModalMessage {
        font-size: 1rem !important;
    }
    
    #confirmModalSubMessage {
        font-size: 0.85rem !important;
    }
    
    #confirmModalLabel {
        font-size: 1.1rem !important;
    }
}

@media (max-width: 576px) {
    .modal-dialog {
        width: 95% !important;
        max-width: 400px !important;
    }
    
    .modal-header {
        padding: 1rem 1.25rem !important;
    }
    
    .modal-body {
        padding: 1.25rem 0.75rem !important;
    }
    
    .modal-footer {
        padding: 1rem 0.75rem !important;
    }
}
</style>

<!-- Prevent body layout shift when modal opens -->
<style>
/* Prevent body from shrinking when modal opens */
body.modal-open {
    overflow: hidden !important;
    padding-right: 0 !important;
}

/* Ensure content doesn't shift */
body {
    transition: none !important;
}

/* ===== CART NOTIFICATION BOTTOM RIGHT - GIỐNG THEGIOIDIDONG ===== */
.cart-notification-bottom {
    position: fixed !important;
    bottom: 20px !important;
    right: 20px !important;
    background: #FFFFFF !important;
    border-radius: 4px !important;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15) !important;
    padding: 10px 12px !important;
    display: flex !important;
    align-items: center !important;
    gap: 10px !important;
    z-index: 999999 !important;
    min-width: auto !important;
    max-width: none !important;
    transform: translateX(calc(100% + 50px)) !important;
    opacity: 0 !important;
    transition: all 0.3s ease-out !important;
    font-family: "Poppins", "Inter", "Roboto", sans-serif !important;
    border: 1px solid rgba(0, 0, 0, 0.08) !important;
    visibility: visible !important;
}

.cart-notification-bottom.show {
    transform: translateX(0) !important;
    opacity: 1 !important;
}

.cart-notification-icon {
    width: 24px !important;
    height: 24px !important;
    border-radius: 50% !important;
    background: #22C55E !important;
    display: flex !important;
    align-items: center !important;
    justify-content: center !important;
    flex-shrink: 0 !important;
}

.cart-notification-icon i {
    color: #FFFFFF !important;
    font-size: 14px !important;
    line-height: 1 !important;
}

.cart-notification-text {
    flex: 0 1 auto !important;
    display: flex !important;
    align-items: center !important;
    white-space: nowrap !important;
    min-width: 0 !important;
}

.cart-notification-message {
    font-size: 13px !important;
    font-weight: 400 !important;
    color: #333333 !important;
    line-height: 1.4 !important;
    white-space: nowrap !important;
    display: block !important;
    visibility: visible !important;
    opacity: 1 !important;
}

.cart-notification-button {
    background: #2563EB !important;
    color: #FFFFFF !important;
    padding: 6px 12px !important;
    border-radius: 4px !important;
    font-size: 12px !important;
    font-weight: 500 !important;
    text-decoration: none !important;
    white-space: nowrap !important;
    transition: background-color 0.2s ease !important;
    display: inline-block !important;
    flex-shrink: 0 !important;
    border: none !important;
    cursor: pointer !important;
}

.cart-notification-button:hover {
    background: #1D4ED8 !important;
    color: #FFFFFF !important;
    text-decoration: none !important;
}

.cart-notification-button:active {
    background: #1E40AF !important;
}

/* Responsive */
@media (max-width: 768px) {
    .cart-notification-bottom {
        bottom: 15px !important;
        right: 15px !important;
        padding: 8px 10px !important;
        gap: 8px !important;
    }
    
    .cart-notification-icon {
        width: 22px !important;
        height: 22px !important;
    }
    
    .cart-notification-icon i {
        font-size: 12px !important;
    }
    
    .cart-notification-message {
        font-size: 12px !important;
    }
    
    .cart-notification-button {
        padding: 5px 10px !important;
        font-size: 11px !important;
    }
}

@media (max-width: 480px) {
    .cart-notification-bottom {
        bottom: 10px !important;
        right: 10px !important;
        left: 10px !important;
        width: calc(100% - 20px) !important;
        max-width: none !important;
        justify-content: space-between !important;
    }
    
    .cart-notification-text {
        flex: 1 !important;
        min-width: 0 !important;
    }
    
    .cart-notification-message {
        overflow: hidden !important;
        text-overflow: ellipsis !important;
        white-space: nowrap !important;
    }
    
    .cart-notification-button {
        padding: 5px 10px !important;
        font-size: 11px !important;
        margin-left: auto !important;
    }
}
</style>

<!-- Notification Helper Functions -->
<script>
// Toast notification function (replaces alert)
function showNotification(message, type = 'info', title = 'Thông báo') {
    const toast = document.getElementById('toastNotification');
    if (!toast) {
        alert(message);
        return;
    }
    
    const toastIcon = document.getElementById('toastIcon');
    const toastTitle = document.getElementById('toastTitle');
    const toastMessage = document.getElementById('toastMessage');
    const toastHeader = document.getElementById('toastHeader');
    
    // Set icon, color, and background based on type
    const configs = {
        'success': { 
            icon: 'fa-check-circle', 
            iconColor: 'text-white',
            headerBg: 'bg-success',
            headerText: 'text-white',
            borderColor: '#28a745'
        },
        'error': { 
            icon: 'fa-exclamation-circle', 
            iconColor: 'text-white',
            headerBg: 'bg-danger',
            headerText: 'text-white',
            borderColor: '#dc3545'
        },
        'warning': { 
            icon: 'fa-exclamation-triangle', 
            iconColor: 'text-dark',
            headerBg: 'bg-warning',
            headerText: 'text-dark',
            borderColor: '#ffc107'
        },
        'info': { 
            icon: 'fa-info-circle', 
            iconColor: 'text-white',
            headerBg: 'bg-info',
            headerText: 'text-white',
            borderColor: '#17a2b8'
        }
    };
    
    const config = configs[type] || configs['info'];
    toastIcon.className = 'fas ' + config.icon + ' me-2 ' + config.iconColor;
    toastHeader.className = 'toast-header ' + config.headerBg + ' ' + config.headerText;
    toastHeader.style.borderBottomColor = config.borderColor;
    toastTitle.textContent = title;
    toastMessage.textContent = message;
    
    // Show toast using Bootstrap 5
    const bsToast = new bootstrap.Toast(toast, { autohide: true, delay: 5000 });
    bsToast.show();
}

// Confirm dialog function (replaces confirm)
function showConfirm(message, onConfirm, onCancel = null, subMessage = null) {
    const modalEl = document.getElementById('confirmModal');
    if (!modalEl) {
        // Fallback to native confirm if modal not available
        if (confirm(message) && onConfirm) {
            onConfirm();
        } else if (onCancel) {
            onCancel();
        }
        return;
    }
    
    const modal = new bootstrap.Modal(modalEl, {
        backdrop: true,
        keyboard: true,
        focus: true
    });
    const modalMessage = document.getElementById('confirmModalMessage');
    const modalSubMessage = document.getElementById('confirmModalSubMessage');
    const confirmBtn = document.getElementById('confirmModalOk');
    const cancelBtn = document.getElementById('confirmModalCancel');
    
    // Set main message
    modalMessage.textContent = message;
    
    // Set sub message if provided
    if (subMessage) {
        modalSubMessage.textContent = subMessage;
        modalSubMessage.style.display = 'block';
    } else {
        // Default sub message based on action type
        if (message.includes('Ngừng hoạt động') || message.includes('người dùng')) {
            modalSubMessage.textContent = 'Người dùng này sẽ không thể đăng nhập hoặc thực hiện giao dịch nữa.';
            modalSubMessage.style.display = 'block';
        } else if (message.includes('Xóa')) {
            modalSubMessage.textContent = 'Hành động này không thể hoàn tác. Vui lòng xác nhận cẩn thận.';
            modalSubMessage.style.display = 'block';
        } else {
            modalSubMessage.style.display = 'none';
        }
    }
    
    // Remove previous event listeners by cloning buttons
    const newConfirmBtn = confirmBtn.cloneNode(true);
    const newCancelBtn = cancelBtn.cloneNode(true);
    confirmBtn.parentNode.replaceChild(newConfirmBtn, confirmBtn);
    cancelBtn.parentNode.replaceChild(newCancelBtn, cancelBtn);
    
    // Prevent body layout shift when modal opens
    modalEl.addEventListener('show.bs.modal', function() {
        document.body.style.paddingRight = '0px';
    }, { once: true });
    
    // Restore when modal closes
    modalEl.addEventListener('hidden.bs.modal', function() {
        document.body.style.paddingRight = '';
        if (onCancel) onCancel();
    }, { once: true });
    
    // Add new event listeners
    newConfirmBtn.addEventListener('click', function() {
        modal.hide();
        if (onConfirm) onConfirm();
    });
    
    newCancelBtn.addEventListener('click', function() {
        modal.hide();
        if (onCancel) onCancel();
    });
    
    modal.show();
}

// Cart Toast Notification Function - THÔNG BÁO GÓC DƯỚI BÊN PHẢI (GIỐNG THEGIOIDIDONG)
function showCartToast(type = "success", message = "Thêm vào giỏ hàng thành công") {
    try {
        // Ensure body exists
        if (!document.body) {
            setTimeout(() => showCartToast(type, message), 100);
            return;
        }
        
        // Remove any existing notification
        const existing = document.querySelector('.cart-notification-bottom');
        if (existing) {
            existing.remove();
        }
        
        // Get context path for cart link
        const contextPath = '<%=request.getContextPath()%>';
        const cartUrl = contextPath + '/home/cart';
        
        // Create notification container
        const notification = document.createElement("div");
        notification.className = "cart-notification-bottom";
        
        // Set icon based on type
        let iconClass = "fa-check-circle";
        if (type === "warning") {
            iconClass = "fa-exclamation-triangle";
        } else if (type === "error") {
            iconClass = "fa-xmark-circle";
        }
        
        // Debug log
        console.log('showCartToast - type:', type, 'message:', message);
        
        // Create notification content
        const iconDiv = document.createElement("div");
        iconDiv.className = "cart-notification-icon";
        const icon = document.createElement("i");
        icon.className = `fa-solid ${iconClass}`;
        iconDiv.appendChild(icon);
        
        const textDiv = document.createElement("div");
        textDiv.className = "cart-notification-text";
        const messageSpan = document.createElement("span");
        messageSpan.className = "cart-notification-message";
        messageSpan.textContent = message || "Thêm vào giỏ hàng thành công";
        textDiv.appendChild(messageSpan);
        
        const buttonLink = document.createElement("a");
        buttonLink.href = cartUrl;
        buttonLink.className = "cart-notification-button";
        buttonLink.textContent = "Xem giỏ hàng";
        
        notification.appendChild(iconDiv);
        notification.appendChild(textDiv);
        notification.appendChild(buttonLink);
        
        // Append to body
        document.body.appendChild(notification);
        
        // Show animation
        setTimeout(() => {
            notification.classList.add("show");
        }, 10);
        
        // Auto hide after 5 seconds
        setTimeout(() => {
            notification.classList.remove("show");
            setTimeout(() => {
                if (notification.parentNode) {
                    notification.remove();
                }
            }, 300);
        }, 5000);
        
    } catch (error) {
        console.error('Error showing cart toast:', error);
        alert('✓ ' + message);
    }
}

// Make function available globally immediately
window.showCartToast = showCartToast;

// Also make it available on DOMContentLoaded as backup
document.addEventListener('DOMContentLoaded', function() {
    if (!window.showCartToast) {
        window.showCartToast = showCartToast;
    }
});
</script>