package service;

import dao.DBConnect;
import dao.OrderDao;
import dao.OrderDaoJdbc;
import dao.PromotionDao;
import dao.PromotionDaoJdbc;
import java.math.BigDecimal;
import java.math.RoundingMode;
import model.PromotionDto;
import model.PromotionMapper;
import model.Promotion;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;
import model.Order;

public class PromotionServiceImpl implements PromotionService {

    private final PromotionDao dao;

    public PromotionServiceImpl(PromotionDao dao) {
        this.dao = dao;
    }

    public PromotionServiceImpl() {
        this.dao = null;
    }

    @Override
    // Lay tat ca khuyen mai va map sang DTO
    public List<PromotionDto> getAllPromotions() {
        try {
            List<Promotion> entities = dao.findAll();
            return entities.stream().map(PromotionMapper::toDto).collect(Collectors.toList());
        } catch (Exception e) {
            throw new RuntimeException("Failed to load all promotions", e);
        }
    }

    @Override
    // Lay thong tin khuyen mai theo ma
    public PromotionDto getPromotionById(String id) {
        try {
            Optional<Promotion> opt = dao.findById(id);
            return opt.map(PromotionMapper::toDto).orElse(null);
        } catch (Exception e) {
            throw new RuntimeException("Failed to get promotion by id: " + id, e);
        }
    }

    @Override
    // Tao moi khuyen mai tu DTO
    public String createPromotion(PromotionDto promotionDto) {
        try {
            System.out.println("Service: Creating promotion - Name: " + promotionDto.getName() + ", Code: " + promotionDto.getCode());
            System.out.println("Service: Type: " + promotionDto.getType() + ", Value: " + promotionDto.getValue());
            System.out.println("Service: StartDate: " + promotionDto.getStartDate() + ", EndDate: " + promotionDto.getEndDate());

            Promotion promotion = PromotionMapper.toEntity(promotionDto);
            System.out.println("Service: Entity mapped successfully");

            String result = dao.create(promotion);
            System.out.println("Service: Promotion created with ID: " + result);
            return result;
        } catch (RuntimeException e) {
            // Re-throw để giữ nguyên thông tin lỗi và chuỗi cause
            System.err.println("Service: RuntimeException caught");
            System.err.println("Service: Message: " + e.getMessage());
            if (e.getCause() != null) {
                System.err.println("Service: Cause: " + e.getCause().getClass().getName() + " - " + e.getCause().getMessage());
                if (e.getCause().getCause() != null) {
                    System.err.println("Service: Root cause: " + e.getCause().getCause().getClass().getName() + " - " + e.getCause().getCause().getMessage());
                }
            }
            e.printStackTrace();
            throw e; // Re-throw để giữ nguyên toàn bộ thông tin
        } catch (Exception e) {
            System.err.println("Service: Exception caught (non-RuntimeException)");
            System.err.println("Service: Exception type: " + e.getClass().getName());
            System.err.println("Service: Message: " + e.getMessage());
            e.printStackTrace();
            // Wrap nhưng giữ nguyên exception gốc
            RuntimeException wrapped = new RuntimeException("Failed to create promotion", e);
            wrapped.addSuppressed(e);
            throw wrapped;
        }
    }

    @Override
    // Cap nhat khuyen mai
    public boolean updatePromotion(PromotionDto promotionDto) {
        try {
            Promotion promotion = PromotionMapper.toEntity(promotionDto);
            return dao.update(promotion);
        } catch (Exception e) {
            throw new RuntimeException("Failed to update promotion", e);
        }
    }

    @Override
    // Xoa khuyen mai theo ma
    public boolean deletePromotion(String id) {
        try {
            return dao.deleteById(id);
        } catch (Exception e) {
            throw new RuntimeException("Failed to delete promotion", e);
        }
    }

    @Override
    // Lay danh sach khuyen mai theo trang thai
    public List<PromotionDto> getPromotionsByStatus(String status) {
        try {
            List<Promotion> entities = dao.findByStatus(status);
            return entities.stream().map(PromotionMapper::toDto).collect(Collectors.toList());
        } catch (Exception e) {
            throw new RuntimeException("Failed to get promotions by status", e);
        }
    }

    @Override
    // Lay danh sach khuyen mai dang hoat dong
    public List<PromotionDto> getActivePromotions() {
        try {
            List<Promotion> entities = dao.findActivePromotions();
            return entities.stream().map(PromotionMapper::toDto).collect(Collectors.toList());
        } catch (Exception e) {
            throw new RuntimeException("Failed to get active promotions", e);
        }
    }

    @Override
    // Lay khuyen mai theo ma code
    public PromotionDto getPromotionByCode(String code) {
        try {
            Optional<Promotion> opt = dao.findByCode(code);
            return opt.map(PromotionMapper::toDto).orElse(null);
        } catch (Exception e) {
            throw new RuntimeException("Failed to get promotion by code", e);
        }
    }

    @Override
    // Lay khuyen mai theo loai
    public List<PromotionDto> getPromotionsByType(String type) {
        try {
            List<Promotion> entities = dao.findByType(type);
            return entities.stream().map(PromotionMapper::toDto).collect(Collectors.toList());
        } catch (Exception e) {
            throw new RuntimeException("Failed to get promotions by type", e);
        }
    }

    @Override
    // Tinh so tien duoc giam khi ap dung khuyen mai
    public double applyPromotion(String promotionCode, double orderAmount) {
        try {
            PromotionDto promotion = getPromotionByCode(promotionCode);
            if (promotion == null || !validatePromotionCode(promotionCode, orderAmount)) {
                return 0;
            }

            if ("percentage".equals(promotion.getType())) {
                return orderAmount * promotion.getValue().doubleValue() / 100;
            } else if ("fixed_amount".equals(promotion.getType())) {
                return Math.min(promotion.getValue().doubleValue(), orderAmount);
            }
            return 0;
        } catch (Exception e) {
            throw new RuntimeException("Failed to apply promotion", e);
        }
    }

    @Override
    // Lay khuyen mai sap het han
    public List<PromotionDto> getExpiringPromotions(int days) {
        try {
            List<Promotion> entities = dao.findExpiringPromotions(days);
            return entities.stream().map(PromotionMapper::toDto).collect(Collectors.toList());
        } catch (Exception e) {
            throw new RuntimeException("Failed to get expiring promotions", e);
        }
    }

    @Override
    // Kiem tra ma khuyen mai co hop le hay khong
    public boolean validatePromotionCode(String code, double orderAmount) {
        try {
            PromotionDto promotion = getPromotionByCode(code);
            if (promotion == null) {
                return false;
            }

            // Check if promotion is active
            if (!"ACTIVE".equals(promotion.getStatus())) {
                return false;
            }

            // Check if promotion is still valid (date range)
            java.util.Date now = new java.util.Date();
            if (promotion.getStartDate() != null && now.before(promotion.getStartDate())) {
                return false;
            }
            if (promotion.getEndDate() != null && now.after(promotion.getEndDate())) {
                return false;
            }

            // Check minimum order value
            if (promotion.getMinOrderValue() != null && orderAmount < promotion.getMinOrderValue().doubleValue()) {
                return false;
            }

            // Check usage limits
            if (promotion.getMaxUses() != null && promotion.getUsesCount() != null
                    && promotion.getUsesCount() >= promotion.getMaxUses()) {
                return false;
            }

            return true;
        } catch (Exception e) {
            throw new RuntimeException("Failed to validate promotion code", e);
        }
    }

    @Override
    // Cap nhat ten code va mo ta khuyen mai
    public boolean updatePromotionDetails(String promotionId, String name, String code, String description) {
        try {
            return dao.updatePromotionDetails(promotionId, name, code, description);
        } catch (Exception e) {
            throw new RuntimeException("Failed to update promotion details", e);
        }
    }

    @Override
    // Cap nhat gia tri giam cua khuyen mai
    public boolean updatePromotionValue(String promotionId, double value) {
        try {
            return dao.updatePromotionValue(promotionId, value);
        } catch (Exception e) {
            throw new RuntimeException("Failed to update promotion value", e);
        }
    }

    @Override
    // Cap nhat ngay bat dau va ket thuc cua khuyen mai
    public boolean updatePromotionDates(String promotionId, java.time.LocalDateTime startDate, java.time.LocalDateTime endDate) {
        try {
            return dao.updatePromotionDates(promotionId, startDate, endDate);
        } catch (Exception e) {
            throw new RuntimeException("Failed to update promotion dates", e);
        }
    }

    @Override
    public void useFixedPromotion(Promotion promotion, Order order) {
        BigDecimal totalAmount = order.getTotalAmount();

        // Trừ giá trị giảm
        BigDecimal updatePayamount = totalAmount.subtract(promotion.getValue());

        // Nếu muốn đảm bảo không âm
        if (updatePayamount.compareTo(BigDecimal.ZERO) < 0) {
            updatePayamount = BigDecimal.ZERO;
        }

        OrderDao o = new OrderDaoJdbc();
        o.updatePayAmount(order.getOrderId(), updatePayamount);
    }

    @Override
    public void usePercentPromotion(Promotion promotion, Order order) {
        BigDecimal totalAmount = order.getTotalAmount();
        BigDecimal discountPercent = promotion.getValue(); // ví dụ: 20 = 20%

        // Tính (100 - discountPercent) / 100
        BigDecimal discountMultiplier = BigDecimal.valueOf(100)
                .subtract(discountPercent)
                .divide(BigDecimal.valueOf(100));

        // Tính paymentAmount = totalAmount * (100 - value)/100
        BigDecimal updatePayamount = totalAmount.multiply(discountMultiplier);

        // Nếu âm (phòng hờ lỗi dữ liệu)
        if (updatePayamount.compareTo(BigDecimal.ZERO) < 0) {
            updatePayamount = BigDecimal.ZERO;
        }

        // Làm tròn 2 chữ số thập phân (theo tiền tệ)
        updatePayamount = updatePayamount.setScale(2, RoundingMode.HALF_UP);

        // Cập nhật vào DB
        OrderDao o = new OrderDaoJdbc();
        o.updatePayAmount(order.getOrderId(), updatePayamount);
    }

    public static void main(String[] args) {
        PromotionService p = new PromotionServiceImpl();
        OrderDao o = new OrderDaoJdbc();

        Order order = new Order();

        order = o.findById("ORD099").orElseThrow();
        Promotion pro = new Promotion();
        DBConnect db = new DBConnect();
        PromotionDao proDao = new PromotionDaoJdbc(db.getConnection());
        pro = proDao.findByCode("ABCD").orElseThrow();
        p.useFixedPromotion(pro, order);
    }
}
