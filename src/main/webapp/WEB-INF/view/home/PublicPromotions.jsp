<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%
    String cPath = request.getContextPath();
    java.util.List<model.PromotionDto> promotions = new java.util.ArrayList<>();
    if (request.getAttribute("promotions") != null) {
        promotions = (java.util.List<model.PromotionDto>) request.getAttribute("promotions");
    }
    request.setAttribute("pageTitle", "Khuyến Mãi - Yen Coffee House");
    request.setAttribute("currentPage", "promotions");
%>

<jsp:include page="/WEB-INF/view/layout/public/header.jsp"/>
<jsp:include page="/WEB-INF/view/layout/public/navbar.jsp"/>

<style>
  :root{ --bg-dark:#0f0f10; --bg-darker:#0a0a0b; --gold:#c7a17a; --pill:#77c4e4; }
  body{background:#0c0c0d;color:#e9e9e9;font-family:"Poppins",system-ui,-apple-system,Segoe UI,Roboto,"Helvetica Neue",Arial,"Noto Sans",sans-serif;padding-top:80px}
  a{color:inherit;text-decoration:none}

  /* HERO */
  .hero{
    position:relative;min-height:42vh;
    background:url('<%=cPath%>/assets/images/bg_3.jpg') center/cover no-repeat fixed;
  }
  .hero:before{content:"";position:absolute;inset:0;background:linear-gradient(180deg,rgba(0,0,0,.45),rgba(0,0,0,.6))}
  .hero .content{position:relative;z-index:2;display:flex;align-items:center;justify-content:center;flex-direction:column;height:42vh;text-align:center;padding:2rem 1rem}
  .hero h1{font-weight:900;letter-spacing:.5px;text-transform:uppercase;margin:0 0 .35rem;color:#fff;font-size:2.5rem}
  .breadcrumbs{color:#cfcfcf;font-size:1rem;margin-top:.5rem}
  .breadcrumbs a:hover{color:var(--gold)}

  /* SECTION */
  .ftco-section{padding:2.6rem 0;background:linear-gradient(180deg,var(--bg-dark),var(--bg-darker))}
  .toolbar{
    background:#121214;border:1px solid rgba(255,255,255,.08);border-radius:14px;
    padding:.9rem 1rem;margin-bottom:1.25rem
  }
  .toolbar input[type="search"], .toolbar select{
    background:#0f0f10;border:1px solid rgba(255,255,255,.12);color:#fff;border-radius:10px;
    padding:.6rem .85rem;height:44px;min-width:200px
  }
  .toolbar input[type="search"]::placeholder{color:#999}
  .toolbar select option{background:#0f0f10;color:#fff}

  /* COUPON CARD */
  .coupon{
    background:#151516;border:1px dashed rgba(255,255,255,.2);
    border-radius:16px;overflow:hidden;position:relative;
    box-shadow:0 10px 28px rgba(0,0,0,.25);
    display:flex;flex-direction:column;height:100%;transition:transform 0.3s
  }
  .coupon:hover{transform:translateY(-5px)}
  .coupon .head{
    display:flex;align-items:center;gap:.75rem;padding:1rem 1rem .25rem 1rem
  }
  .tag{
    background:rgba(199,161,122,.18);color:#fff;border:1px solid rgba(199,161,122,.35);
    padding:.25rem .5rem;border-radius:8px;font-weight:700;font-size:.85rem
  }
  .badge-status{
    margin-left:auto;padding:.25rem .55rem;border-radius:8px;font-size:.78rem;font-weight:700
  }
  .badge-ok{background:#193b2e;color:#97ffc6;border:1px solid #2f6c56}
  .badge-soon{background:#3a2f1a;color:#ffd18a;border:1px solid #8a6d35}
  .badge-exp{background:#321b1b;color:#ffb3b3;border:1px solid #6a3a3a}
  .coupon h3{font-weight:800;margin:.25rem 1rem .35rem 1rem;color:#fff;font-size:1.3rem}
  .coupon p{color:#cfcfcf;margin:0 1rem .6rem 1rem;line-height:1.6}
  .code-row{
    display:flex;gap:.5rem;align-items:center;margin:.25rem 1rem 1rem 1rem
  }
  .code{
    flex:1;background:#0f0f10;border:1px dashed rgba(255,255,255,.25);border-radius:10px;
    height:44px;display:flex;align-items:center;justify-content:center;font-weight:700;letter-spacing:2px;color:#fff;font-size:1.1rem
  }
  .btn{border-radius:999px;padding:.6rem 1rem;font-weight:700;border:none;cursor:pointer;transition:all 0.3s}
  .btn-gold{background:var(--gold);border:2px solid var(--gold);color:#000}
  .btn-gold:hover{background:#d68f17;border-color:#d68f17}
  .btn-gold:disabled{opacity:.5;cursor:not-allowed}
  .btn-outline{border:2px solid var(--gold);color:var(--gold);background:transparent}
  .btn-outline:hover{background:var(--gold);color:#000}
  .actions{display:flex;gap:.5rem;padding:0 1rem 1rem 1rem}
  .actions .flex-fill{flex:1}
  .cond{
    border-top:1px solid rgba(255,255,255,.08);padding:.75rem 1rem;font-size:.95rem;color:#cfcfcf;margin-top:auto
  }
  .cond .toggle{color:var(--gold);cursor:pointer;font-weight:700;user-select:none}
  .cond .toggle:hover{text-decoration:underline}
  .cond .content{display:none;margin-top:.4rem;color:#d9d9d9;line-height:1.8}
  .cond .content div{margin:.25rem 0}
</style>

<!-- HERO -->
<header class="hero">
  <div class="content container">
    <h1>Khuyến mãi đang diễn ra</h1>
    <p style="max-width:760px;color:#e0e0e0;margin:.5rem 0">
      Chọn ưu đãi phù hợp, nhấn <b>Sao chép</b>. Đến
      <a href="<%=cPath%>/home/public-products" style="color:var(--gold);font-weight:700">Menu</a>
      để áp dụng ngay!
    </p>
    <p class="breadcrumbs"><a href="<%=cPath%>/home">Trang chủ</a> • <span>Khuyến mãi</span></p>
  </div>
</header>

<!-- CONTENT -->
<section class="ftco-section">
  <div class="container">
    <!-- Toolbar -->
   <div class="toolbar d-flex flex-wrap align-items-center justify-content-center">
  <input id="searchBox" type="search" class="mr-2 mb-2" placeholder="Tìm kiếm ưu đãi… (ví dụ: freeship, 20%)">

  <!-- Bộ lọc theo loại khuyến mãi -->
  <select id="typeSelect" class="mr-2 mb-2">
    <option value="all">-- Chọn loại khuyến mãi --</option>
    <option value="percentage">Phần trăm (%)</option>
    <option value="fixed_amount">Giá trị cố định (đ)</option>
    <option value="free_shipping">Miễn phí ship</option>
  </select>

  <select id="filterSelect" class="mr-2 mb-2">
    <option value="all">Tất cả trạng thái</option>
    <option value="valid">Còn hạn</option>
    <option value="soon">Sắp hết hạn</option>
    <option value="expired">Hết hạn</option>
  </select>

  <select id="sortSelect" class="mb-2">
    <option value="new">Sắp xếp: Mới nhất</option>
    <option value="expire">Sắp hết hạn</option>
    <option value="value">Giá trị cao → thấp</option>
  </select>
</div>



    <!-- Grid -->
    <div class="row" id="promoGrid">
      <!-- JS render -->
    </div>
  </div>
</section>

<!-- Toast -->
<div class="toast-copy" id="toast" style="position:fixed;left:50%;transform:translateX(-50%);bottom:24px;z-index:2000;background:#141415;border:1px solid rgba(255,255,255,.12);border-radius:999px;padding:.6rem 1rem;display:none;align-items:center;gap:.6rem;color:#fff">
  <i class="fa-solid fa-check"></i><span id="toastText">Đã sao chép mã</span>
</div>

<jsp:include page="/WEB-INF/view/layout/public/footer.jsp"/>

<script>
  /* ================== DATA - Backend + Fallback Demo ================== */
  <%
    java.util.List<model.PromotionDto> promoList = (java.util.List<model.PromotionDto>) request.getAttribute("promotions");
    if (promoList == null) promoList = new java.util.ArrayList<>();
    
    StringBuilder promoJson = new StringBuilder("[");
    boolean first = true;
    for (model.PromotionDto promo : promoList) {
      if (!first) promoJson.append(",");
      first = false;
      
      String code = promo.getCode() != null ? promo.getCode().replace("'", "\\'").replace("\"", "\\\"").replace("\\", "\\\\") : "";
      String name = promo.getName() != null ? promo.getName().replace("'", "\\'").replace("\"", "\\\"").replace("\\", "\\\\") : "";
      String desc = promo.getDescription() != null ? promo.getDescription().replace("'", "\\'").replace("\"", "\\\"").replace("\\", "\\\\").replace("\n", " ").replace("\r", "") : "Khuyến mãi đặc biệt";
      String type = "special";
      if ("percentage".equals(promo.getType())) type = "percent";
      else if ("fixed_amount".equals(promo.getType())) type = "amount";
      else if ("free_shipping".equals(promo.getType())) type = "ship";
      
      java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
      String fromDate = promo.getStartDate() != null ? sdf.format(promo.getStartDate()) : "2025-01-01";
      String toDate = promo.getEndDate() != null ? sdf.format(promo.getEndDate()) : "2025-12-31";
      
      double value = promo.getValue() != null ? promo.getValue().doubleValue() : 0;
      double maxValue = ("percentage".equals(promo.getType()) && promo.getValue() != null) ? promo.getValue().doubleValue() : 0;
      double minOrder = promo.getMinOrderValue() != null ? promo.getMinOrderValue().doubleValue() : 0;
      int left = 999;
      if (promo.getMaxUses() != null && promo.getUsesCount() != null) {
        left = Math.max(0, promo.getMaxUses() - promo.getUsesCount());
      }
      
      promoJson.append("{");
      promoJson.append("code:'").append(code).append("',");
      promoJson.append("title:'").append(name).append("',");
      promoJson.append("type:'").append(type).append("',");
      promoJson.append("value:").append(value).append(",");
      promoJson.append("max:").append(maxValue).append(",");
      promoJson.append("minOrder:").append(minOrder).append(",");
      promoJson.append("from:'").append(fromDate).append("',");
      promoJson.append("to:'").append(toDate).append("',");
      promoJson.append("left:").append(left).append(",");
      promoJson.append("desc:'").append(desc).append("',");
      promoJson.append("status:'").append(promo.getStatus() != null ? promo.getStatus().replace("'", "\\'") : "").append("'");
      promoJson.append("}");
    }
    promoJson.append("]");
  %>
  const BACKEND_PROMOS = <%= promoJson.toString() %>;

  // Fallback demo data if no backend data
  const DEMO_PROMOS = [
    {
      code:'GIAM20', title:'Giảm 20% hoá đơn', type:'percent', value:20,
      max:30000, minOrder:99000,
      from:'2025-01-01', to:'2025-12-31',
      left:500,
      desc:'Giảm tối đa 30.000₫ cho đơn từ 99.000₫. Áp dụng tất cả danh mục.'
    },
    {
      code:'FREESHIP20K', title:'Miễn phí vận chuyển 20K', type:'ship', value:20000,
      max:20000, minOrder:80000,
      from:'2025-01-01', to:'2025-12-31',
      left:300,
      desc:'Hỗ trợ phí ship tối đa 20.000₫ cho đơn từ 80.000₫ (bán kính 5km).'
    }
  ];

  const PROMOS = BACKEND_PROMOS.length > 0 ? BACKEND_PROMOS : DEMO_PROMOS;

  /* ================== UTIL ================== */
  const fmt = n => (n||0).toLocaleString('vi-VN')+'₫';
  const dayDiff = (a,b) => Math.ceil((a-b)/(1000*60*60*24));

  function statusOf(p){
    const today = new Date();
    today.setHours(0,0,0,0);
    const to = new Date(p.to+'T23:59:59');
    const from = new Date(p.from+'T00:00:00');
    if(today < from) return 'valid';
    const days = dayDiff(to, today);
    if (to < today) return 'expired';
    if (days <= 5) return 'soon';
    return 'valid';
  }

  function valueRank(p){
    if(p.type==='percent') return p.value * (p.max||0);
    return p.value||0;
  }

  /* ================== RENDER ================== */
  const grid = document.getElementById('promoGrid');
  const searchBox = document.getElementById('searchBox');
  const filterSelect = document.getElementById('filterSelect');
  const sortSelect = document.getElementById('sortSelect');

  function render(){
    const q = (searchBox.value||'').trim().toLowerCase();
    const f = filterSelect.value;
    const s = sortSelect.value;

    let list = PROMOS.map(p=>({...p, _status: statusOf(p)}));

    if(q){
      list = list.filter(p =>
        p.code.toLowerCase().includes(q) ||
        p.title.toLowerCase().includes(q) ||
        (p.desc||'').toLowerCase().includes(q) ||
        (p.value||'').toString().includes(q)
      );
    }

    if(f!=='all'){
      list = list.filter(p => p._status === (f==='valid'?'valid': f==='soon'?'soon':'expired'));
    }

    if(s==='expire'){
      list.sort((a,b)=> new Date(a.to) - new Date(b.to));
    }else if(s==='value'){
      list.sort((a,b)=> valueRank(b) - valueRank(a));
    }else{
      list.sort((a,b)=> new Date(b.from) - new Date(a.from));
    }

    grid.innerHTML = '';
    if(list.length===0){
      grid.innerHTML = '<div class="col-12"><div class="coupon" style="padding:2rem;text-align:center;color:#999">Không tìm thấy ưu đãi phù hợp.</div></div>';
      return;
    }

    list.forEach(p=>{
      const st = p._status;
      let badgeClass = 'badge-ok';
      let badgeText = 'Còn hạn';
      if (st === 'soon') {
        badgeClass = 'badge-soon';
        badgeText = 'Sắp hết hạn';
      } else if (st === 'expired') {
        badgeClass = 'badge-exp';
        badgeText = 'Hết hạn';
      }
      const daysLeft = dayDiff(new Date(p.to+'T23:59:59'), new Date());

      let tagText = 'Special';
      if (p.type === 'percent') {
        tagText = '- ' + p.value + '%';
      } else if (p.type === 'amount') {
        tagText = '- ' + fmt(p.value);
      } else if (p.type === 'ship') {
        tagText = 'Freeship ' + fmt(p.value);
      }

      const disabledAttr = st === 'expired' ? 'disabled' : '';
      const daysText = st !== 'expired' ? '(còn ' + Math.max(daysLeft, 0) + ' ngày)' : '';
      const minOrderHtml = p.minOrder ? '<div>Đơn tối thiểu: <b>' + fmt(p.minOrder) + '</b></div>' : '';
      const maxHtml = p.max ? '<div>Giảm tối đa: <b>' + fmt(p.max) + '</b></div>' : '';
      
      const html = 
        '<div class="col-lg-4 col-md-6 mb-4">' +
          '<div class="coupon">' +
            '<div class="head">' +
              '<span class="tag">' + tagText + '</span>' +
              '<span class="badge-status ' + badgeClass + '">' + badgeText + '</span>' +
            '</div>' +
            '<h3>' + (p.title || '') + '</h3>' +
            '<p>' + (p.desc || '') + '</p>' +
            '<div class="code-row">' +
              '<div class="code" title="Mã khuyến mãi">' + (p.code || '') + '</div>' +
              '<button class="btn btn-outline" data-copy="' + (p.code || '') + '"><i class="fa-solid fa-copy mr-1"></i>Sao chép</button>' +
            '</div>' +
            '<div class="actions">' +
              '<button class="btn btn-gold flex-fill" ' + disabledAttr + ' data-apply="' + (p.code || '') + '">' +
                'Dùng ngay' +
              '</button>' +
            '</div>' +
            '<div class="cond">' +
              '<span class="toggle" data-toggle="' + (p.code || '') + '">Điều kiện & thời hạn</span>' +
              '<div class="content" id="cond-' + (p.code || '') + '">' +
                '<div>Hiệu lực: <b>' + (p.from || '') + '</b> → <b>' + (p.to || '') + '</b> ' + daysText + '</div>' +
                minOrderHtml +
                maxHtml +
                '<div>Còn lại: <b>' + (p.left || 0) + '</b> lượt</div>' +
              '</div>' +
            '</div>' +
          '</div>' +
        '</div>';
      grid.insertAdjacentHTML('beforeend', html);
    });

    // Bind events
    grid.querySelectorAll('[data-copy]').forEach(btn=>{
      btn.addEventListener('click', ()=> copyCode(btn.getAttribute('data-copy')));
    });
    grid.querySelectorAll('[data-apply]').forEach(btn=>{
      btn.addEventListener('click', ()=>{
        const code = btn.getAttribute('data-apply');
        location.href = '<%=cPath%>/home/public-products?coupon=' + encodeURIComponent(code);
      });
    });
    grid.querySelectorAll('[data-toggle]').forEach(t=>{
      t.addEventListener('click', ()=>{
        const id = 'cond-' + t.getAttribute('data-toggle');
        const box = document.getElementById(id);
        box.style.display = box.style.display==='block' ? 'none' : 'block';
      });
    });
  }

  /* ================== COPY & TOAST ================== */
  function showToast(text){
    const t = document.getElementById('toast');
    const span = document.getElementById('toastText');
    span.textContent = text || 'Đã sao chép';
    t.style.display = 'flex';
    setTimeout(()=>{ t.style.display='none'; }, 1600);
  }

  async function copyCode(code){
    try{
      await navigator.clipboard.writeText(code);
    }catch(e){
      const tmp = document.createElement('input');
      tmp.value = code; document.body.appendChild(tmp); tmp.select();
      try{ document.execCommand('copy'); }catch(e){}
      document.body.removeChild(tmp);
    }
    showToast('Đã sao chép: ' + code);
  }

  /* ================== FILTER EVENTS ================== */
  [searchBox, filterSelect, sortSelect].forEach(el=>{
    el.addEventListener('input', render);
    el.addEventListener('change', render);
  });

  // Init
  render();
</script>

<jsp:include page="/WEB-INF/view/layout/public/scripts.jsp"/>

</body>
</html>
