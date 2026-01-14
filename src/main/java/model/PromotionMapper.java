// PromotionMapper.java
package model;

// use model.PromotionDto and model.Promotion

import java.time.ZoneId;
import java.util.Date;

public class PromotionMapper {
    public static PromotionDto toDto(Promotion p) {
        if (p == null) return null;
        PromotionDto d = new PromotionDto();
        d.setPromotionId(p.getPromotionId());
        d.setCode(p.getCode());
        d.setName(p.getName());
        d.setType(p.getType());
        d.setValue(p.getValue());
        d.setMinOrderValue(p.getMinOrderValue());
        d.setStatus(p.getStatus());
        d.setApplyToAll(p.getApplyToAll());
        d.setMaxUses(p.getMaxUses());
        d.setUsesCount(p.getUsesCount());
        d.setDescription(p.getDescription());
        d.setNote(p.getNote());

        if (p.getStartDate() != null)
            d.setStartDate(Date.from(p.getStartDate()
                    .atStartOfDay(ZoneId.systemDefault()).toInstant()));
        if (p.getEndDate() != null)
            d.setEndDate(Date.from(p.getEndDate()
                    .atStartOfDay(ZoneId.systemDefault()).toInstant()));
        if (p.getCreatedAt() != null)
            d.setCreatedAt(Date.from(p.getCreatedAt().toInstant()));
        if (p.getUpdatedAt() != null)
            d.setUpdatedAt(Date.from(p.getUpdatedAt().toInstant()));
        return d;
    }
    
    public static Promotion toEntity(PromotionDto d) {
        if (d == null) return null;
        try {
            Promotion p = new Promotion();
            p.setPromotionId(d.getPromotionId());
            p.setCode(d.getCode());
            p.setName(d.getName());
            p.setType(d.getType());
            p.setValue(d.getValue());
            p.setMinOrderValue(d.getMinOrderValue());
            p.setStatus(d.getStatus());
            p.setApplyToAll(d.getApplyToAll());
            p.setMaxUses(d.getMaxUses());
            p.setUsesCount(d.getUsesCount());
            p.setDescription(d.getDescription());
            p.setNote(d.getNote());

            if (d.getStartDate() != null) {
                try {
                    java.util.Date startDate = d.getStartDate();
                    // Convert java.util.Date to LocalDate
                    // If it's already a java.sql.Date, we can use it directly
                    if (startDate instanceof java.sql.Date) {
                        p.setStartDate(((java.sql.Date) startDate).toLocalDate());
                    } else {
                        // For java.util.Date, convert via Instant
                        p.setStartDate(startDate.toInstant().atZone(ZoneId.systemDefault()).toLocalDate());
                    }
                    System.out.println("Mapper: Successfully converted startDate: " + d.getStartDate() + " -> " + p.getStartDate());
                } catch (Exception e) {
                    System.err.println("=== MAPPER ERROR: Converting startDate ===");
                    System.err.println("StartDate object: " + d.getStartDate());
                    System.err.println("StartDate class: " + (d.getStartDate() != null ? d.getStartDate().getClass().getName() : "null"));
                    System.err.println("Error: " + e.getClass().getName() + " - " + e.getMessage());
                    e.printStackTrace();
                    throw new RuntimeException("Invalid start date format: " + (d.getStartDate() != null ? d.getStartDate().toString() : "null"), e);
                }
            }
            if (d.getEndDate() != null) {
                try {
                    java.util.Date endDate = d.getEndDate();
                    // Convert java.util.Date to LocalDate
                    // If it's already a java.sql.Date, we can use it directly
                    if (endDate instanceof java.sql.Date) {
                        p.setEndDate(((java.sql.Date) endDate).toLocalDate());
                    } else {
                        // For java.util.Date, convert via Instant
                        p.setEndDate(endDate.toInstant().atZone(ZoneId.systemDefault()).toLocalDate());
                    }
                    System.out.println("Mapper: Successfully converted endDate: " + d.getEndDate() + " -> " + p.getEndDate());
                } catch (Exception e) {
                    System.err.println("=== MAPPER ERROR: Converting endDate ===");
                    System.err.println("EndDate object: " + d.getEndDate());
                    System.err.println("EndDate class: " + (d.getEndDate() != null ? d.getEndDate().getClass().getName() : "null"));
                    System.err.println("Error: " + e.getClass().getName() + " - " + e.getMessage());
                    e.printStackTrace();
                    throw new RuntimeException("Invalid end date format: " + (d.getEndDate() != null ? d.getEndDate().toString() : "null"), e);
                }
            }
            if (d.getCreatedAt() != null)
                p.setCreatedAt(d.getCreatedAt().toInstant().atZone(ZoneId.systemDefault()).toOffsetDateTime());
            if (d.getUpdatedAt() != null)
                p.setUpdatedAt(d.getUpdatedAt().toInstant().atZone(ZoneId.systemDefault()).toOffsetDateTime());
            return p;
        } catch (Exception e) {
            String errorMsg = e.getMessage();
            System.err.println("=== MAPPER ERROR ===");
            System.err.println("Exception type: " + e.getClass().getName());
            System.err.println("Message: " + errorMsg);
            e.printStackTrace();
            
            // Build detailed error message
            String finalMsg = "Error mapping PromotionDto to Promotion";
            if (errorMsg != null && !errorMsg.isEmpty()) {
                finalMsg += ": " + errorMsg;
            } else {
                finalMsg += " (" + e.getClass().getSimpleName() + ")";
            }
            
            throw new RuntimeException(finalMsg, e);
        }
    }
}
