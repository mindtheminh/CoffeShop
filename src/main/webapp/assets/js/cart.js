/**
 * Cart functionality for CoffeeShop
 */

// Add product to cart
function addToCart(productId, productName, price, quantity) {
    if (!quantity) quantity = 1;
    
    // Create form data
    const formData = new FormData();
    formData.append('action', 'add');
    formData.append('productId', productId);
    formData.append('quantity', quantity);
    
    // Send AJAX request
    fetch(contextPath + '/home/cart', {
        method: 'POST',
        headers: {
            'X-Requested-With': 'XMLHttpRequest'
        },
        body: formData
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            // Show success message
            showNotification('success', data.message);
            
            // Update cart count badge
            updateCartCount(data.cartCount);
        } else {
            showNotification('error', data.message || 'Có lỗi xảy ra!');
        }
    })
    .catch(error => {
        console.error('Error:', error);
        showNotification('error', 'Không thể kết nối đến server!');
    });
}

// Update cart count badge
function updateCartCount(count) {
    const cartBadge = document.querySelector('.cart-badge, .badge-cart');
    if (cartBadge) {
        cartBadge.textContent = count;
        
        // Animate badge
        cartBadge.style.transform = 'scale(1.3)';
        setTimeout(() => {
            cartBadge.style.transform = 'scale(1)';
        }, 200);
    }
}

// Show notification
function showNotification(type, message) {
    // Remove existing notifications
    const existingNotif = document.querySelector('.cart-notification');
    if (existingNotif) {
        existingNotif.remove();
    }
    
    // Create notification element
    const notification = document.createElement('div');
    notification.className = `cart-notification cart-notification-${type}`;
    notification.innerHTML = `
        <div class="cart-notification-content">
            <i class="fas ${type === 'success' ? 'fa-check-circle' : 'fa-exclamation-circle'}"></i>
            <span>${message}</span>
        </div>
    `;
    
    // Add to body
    document.body.appendChild(notification);
    
    // Show notification
    setTimeout(() => {
        notification.classList.add('show');
    }, 10);
    
    // Hide and remove after 3 seconds
    setTimeout(() => {
        notification.classList.remove('show');
        setTimeout(() => {
            notification.remove();
        }, 300);
    }, 3000);
}

// Add notification styles
const style = document.createElement('style');
style.textContent = `
    .cart-notification {
        position: fixed;
        top: 20px;
        right: 20px;
        background: white;
        padding: 1rem 1.5rem;
        border-radius: 8px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        z-index: 9999;
        transform: translateX(400px);
        transition: transform 0.3s ease;
    }
    
    .cart-notification.show {
        transform: translateX(0);
    }
    
    .cart-notification-content {
        display: flex;
        align-items: center;
        gap: 0.75rem;
    }
    
    .cart-notification-success {
        border-left: 4px solid #22c55e;
    }
    
    .cart-notification-success i {
        color: #22c55e;
        font-size: 1.5rem;
    }
    
    .cart-notification-error {
        border-left: 4px solid #ef4444;
    }
    
    .cart-notification-error i {
        color: #ef4444;
        font-size: 1.5rem;
    }
    
    .cart-notification span {
        color: #0f172a;
        font-weight: 500;
    }
`;
document.head.appendChild(style);

