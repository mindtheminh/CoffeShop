// Promotion.java (ENTITY, dùng cho DAO)
package model;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.OffsetDateTime;

public class Promotion {
    private String promotionId;          // NVARCHAR(10)
    private String code;
    private String name;
    private String type;                 // percentage | fixed_amount | free_shipping
    private BigDecimal value;            // DECIMAL(12,2)
    private BigDecimal minOrderValue;    // DECIMAL(12,2)
    private LocalDate startDate;         // DATE
    private LocalDate endDate;           // DATE
    private String status;               // Activate | Deactivate | ...
    private Boolean applyToAll;          // BIT
    private Integer maxUses;
    private Integer usesCount;
    private String description;
    private String note;
    private String promotionScope;       // NVARCHAR(20) nếu bạn dùng
    private Integer createdBy;
    private Integer updatedBy;
    private OffsetDateTime createdAt;    // DATETIMEOFFSET
    private OffsetDateTime updatedAt;    // DATETIMEOFFSET
    // getter/setter đầy đủ ...

    public void setPromotionId(String promotionId) {
        this.promotionId = promotionId;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setType(String type) {
        this.type = type;
    }

    public void setValue(BigDecimal value) {
        this.value = value;
    }

    public void setMinOrderValue(BigDecimal minOrderValue) {
        this.minOrderValue = minOrderValue;
    }

    public void setStartDate(LocalDate startDate) {
        this.startDate = startDate;
    }

    public void setEndDate(LocalDate endDate) {
        this.endDate = endDate;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public void setApplyToAll(Boolean applyToAll) {
        this.applyToAll = applyToAll;
    }

    public void setMaxUses(Integer maxUses) {
        this.maxUses = maxUses;
    }

    public void setUsesCount(Integer usesCount) {
        this.usesCount = usesCount;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public void setPromotionScope(String promotionScope) {
        this.promotionScope = promotionScope;
    }

    public void setCreatedBy(Integer createdBy) {
        this.createdBy = createdBy;
    }

    public void setUpdatedBy(Integer updatedBy) {
        this.updatedBy = updatedBy;
    }

    public void setCreatedAt(OffsetDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public void setUpdatedAt(OffsetDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public String getPromotionId() {
        return promotionId;
    }

    public String getCode() {
        return code;
    }

    public String getName() {
        return name;
    }

    public String getType() {
        return type;
    }

    public BigDecimal getValue() {
        return value;
    }

    public BigDecimal getMinOrderValue() {
        return minOrderValue;
    }

    public LocalDate getStartDate() {
        return startDate;
    }

    public LocalDate getEndDate() {
        return endDate;
    }

    public String getStatus() {
        return status;
    }

    public Boolean getApplyToAll() {
        return applyToAll;
    }

    public Integer getMaxUses() {
        return maxUses;
    }

    public Integer getUsesCount() {
        return usesCount;
    }

    public String getDescription() {
        return description;
    }

    public String getNote() {
        return note;
    }

    public String getPromotionScope() {
        return promotionScope;
    }

    public Integer getCreatedBy() {
        return createdBy;
    }

    public Integer getUpdatedBy() {
        return updatedBy;
    }

    public OffsetDateTime getCreatedAt() {
        return createdAt;
    }

    public OffsetDateTime getUpdatedAt() {
        return updatedAt;
    }

    @Override
    public String toString() {
        return "Promotion{" + "promotionId=" + promotionId + ", code=" + code + ", name=" + name + ", type=" + type + ", value=" + value + ", minOrderValue=" + minOrderValue + ", startDate=" + startDate + ", endDate=" + endDate + ", status=" + status + ", applyToAll=" + applyToAll + ", maxUses=" + maxUses + ", usesCount=" + usesCount + ", description=" + description + ", note=" + note + ", promotionScope=" + promotionScope + ", createdBy=" + createdBy + ", updatedBy=" + updatedBy + ", createdAt=" + createdAt + ", updatedAt=" + updatedAt + '}';
    }
    
}
