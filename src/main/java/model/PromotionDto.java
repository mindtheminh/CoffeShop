// PromotionDto.java (chỉ cho View/JSP)
package model;

import java.math.BigDecimal;
import java.util.Date;

public class PromotionDto {
    private String promotionId;
    private String code;
    private String name;
    private String type;
    private BigDecimal value;
    private BigDecimal minOrderValue;
    private Date startDate;   // java.util.Date để fmt:formatDate
    private Date endDate;
    private String status;
    private Boolean applyToAll;
    private Integer maxUses;
    private Integer usesCount;
    private String description;
    private String note;
    // createdAt/updatedAt nếu cần hiển thị thì cũng để Date
    private Date createdAt;
    private Date updatedAt;
    // getter/setter ...

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

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public void setEndDate(Date endDate) {
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

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public void setUpdatedAt(Date updatedAt) {
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

    public Date getStartDate() {
        return startDate;
    }

    public Date getEndDate() {
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

    public Date getCreatedAt() {
        return createdAt;
    }

    public Date getUpdatedAt() {
        return updatedAt;
    }
    
    @Override
    public String toString() {
        return "PromotionDto{" +
                "promotionId='" + promotionId + '\'' +
                ", code='" + code + '\'' +
                ", name='" + name + '\'' +
                ", type='" + type + '\'' +
                ", value=" + value +
                ", minOrderValue=" + minOrderValue +
                ", startDate=" + startDate +
                ", endDate=" + endDate +
                ", status='" + status + '\'' +
                ", applyToAll=" + applyToAll +
                ", maxUses=" + maxUses +
                ", usesCount=" + usesCount +
                ", description='" + description + '\'' +
                ", note='" + note + '\'' +
                '}';
    }
    
}
