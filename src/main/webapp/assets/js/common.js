// Lấy context path động từ URL (nếu cần)
function getContextPath() {
    const pathname = window.location.pathname;
    const pathArray = pathname.split('/').filter(function(item) {
        return item !== '';
    });
    // Nếu có context path (không phải root), trả về context path
    if (pathArray.length > 0 && pathArray[0] !== 'css' && pathArray[0] !== 'js' && pathArray[0] !== 'images' && pathArray[0] !== 'fragments') {
        return '/' + pathArray[0];
    }
    return '';
}

// ===== PANEL TÌM KIẾM =====
(function(){
    const btn = document.getElementById('yc-search-btn');
    const panel = document.getElementById('yc-search-panel');
    const input = document.getElementById('yc-search-input');
    
    if (!btn || !panel || !input) return;
    
    function openP(){ 
        panel.style.display = 'block'; 
        setTimeout(() => input.focus(), 30);
    }
    function closeP(){ 
        panel.style.display = 'none'; 
        input.value = ''; 
    }
    
    btn.addEventListener('click', () => {
        panel.style.display === 'block' ? closeP() : openP();
    });
    
    input.addEventListener('keydown', e => {
        if(e.key === 'Escape') closeP();
        if(e.key === 'Enter'){ 
            const q = input.value.trim(); 
            if(q) {
                // Redirect đến trang products với query
                const currentPath = window.location.pathname;
                const basePath = currentPath.substring(0, currentPath.lastIndexOf('/')) || '';
                window.location.href = basePath + '/PublicProduct.html?q=' + encodeURIComponent(q);
            }
        }
    });
    
    document.addEventListener('click', e => {
        if(panel.style.display === 'block' && !panel.contains(e.target) && e.target !== btn && !btn.contains(e.target)){ 
            closeP(); 
        }
    });
})();

// ===== BADGE GIỎ HÀNG (LEGACY - NOT USED) =====
// NOTE: Cart functionality now uses server-side database storage
// This localStorage-based cart is deprecated and commented out
/*
function updateCartBadge(){
    const el = document.getElementById('cart-count');
    if(!el) return;

    // Lấy từ localStorage hoặc từ server
    let count = 0;
    try {
        const items = JSON.parse(localStorage.getItem('cart') || '[]');
        count = items.reduce((sum, item) => sum + (parseInt(item.qty) || 0), 0);
    } catch(e) {
        console.error('Error reading cart:', e);
    }

    el.textContent = count > 99 ? '99+' : count;
    el.style.display = count > 0 ? 'inline-flex' : 'none';
}

// Cập nhật badge khi trang load
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', updateCartBadge);
} else {
    updateCartBadge();
}

// ===== THÊM VÀO GIỎ HÀNG =====
function addToCart(productData){
    let cart = [];
    try {
        cart = JSON.parse(localStorage.getItem('cart') || '[]');
    } catch(e) {
        console.error('Error reading cart:', e);
    }

    const existIdx = cart.findIndex(item => item.id === productData.id);
    if(existIdx >= 0){
        cart[existIdx].qty += (productData.qty || 1);
    } else {
        cart.push({
            id: productData.id,
            name: productData.name,
            price: productData.price,
            img: productData.img || '',
            qty: productData.qty || 1
        });
    }

    localStorage.setItem('cart', JSON.stringify(cart));
    updateCartBadge();

    // Thông báo (có thể thay bằng toast notification)
    alert('✓ Đã thêm "' + productData.name + '" vào giỏ hàng!');
}

// Gắn sự kiện click vào nút "Thêm vào giỏ"
document.addEventListener('click', function(e){
    const btn = e.target.closest('.btn-outline-primary');
    if(!btn || !btn.textContent.includes('Thêm vào giỏ')) return;

    e.preventDefault();

    const card = btn.closest('.menu-wrap');
    if(!card) return;

    const nameEl = card.querySelector('h3');
    const priceEl = card.querySelector('.price span');
    const imgEl = card.querySelector('.menu-img');
    const linkEl = card.querySelector('.btn-detail');

    if(!nameEl || !priceEl) return;

    const name = nameEl.textContent.trim();
    const priceText = priceEl.textContent.replace(/[^\d]/g, '');
    const price = parseInt(priceText, 10) || 0;
    let img = '';
    if(imgEl) {
        const bgImg = imgEl.style.backgroundImage || window.getComputedStyle(imgEl).backgroundImage;
        if(bgImg && bgImg !== 'none') {
            img = bgImg.replace(/url\(['"]?([^'"]+)['"]?\)/, '$1');
        }
    }
    const code = linkEl ? (function() {
        try {
            const url = new URL(linkEl.href, window.location.href);
            return url.searchParams.get('code') || name.toLowerCase().replace(/\s+/g, '');
        } catch(e) {
            const match = linkEl.href.match(/[?&]code=([^&]+)/);
            return match ? match[1] : name.toLowerCase().replace(/\s+/g, '');
        }
    })() : name.toLowerCase().replace(/\s+/g, '');

    addToCart({
        id: code,
        name: name,
        price: price,
        img: img,
        qty: 1
    });
});
*/

// Export functions để có thể sử dụng ở nơi khác
if (typeof window !== 'undefined') {
    // window.updateCartBadge = updateCartBadge; // DEPRECATED - using server-side cart
    // window.addToCart = addToCart; // DEPRECATED - using server-side cart
    window.getContextPath = getContextPath;
}
