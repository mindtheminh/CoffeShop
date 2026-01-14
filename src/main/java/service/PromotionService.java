package service;

import model.PromotionDto;
import java.util.List;
import model.Order;
import model.Promotion;

/**
 * PromotionService interface - Business logic for Promotion management
 *
 * @author Asus
 */
public interface PromotionService {

    /**
     * Get all promotions
     *
     * @return List of all promotions as DTOs
     */
    List<PromotionDto> getAllPromotions();

    /**
     * Get promotion by ID
     *
     * @param id Promotion ID
     * @return PromotionDto if found, null otherwise
     */
    PromotionDto getPromotionById(String id);

    /**
     * Create new promotion
     *
     * @param promotionDto Promotion data to create
     * @return Created promotion ID
     */
    String createPromotion(PromotionDto promotionDto);

    /**
     * Update existing promotion
     *
     * @param promotionDto Promotion data to update
     * @return true if update successful
     */
    boolean updatePromotion(PromotionDto promotionDto);

    /**
     * Delete promotion by ID
     *
     * @param id Promotion ID to delete
     * @return true if delete successful
     */
    boolean deletePromotion(String id);

    /**
     * Get promotions by status
     *
     * @param status Promotion status
     * @return List of promotions with the given status
     */
    List<PromotionDto> getPromotionsByStatus(String status);

    /**
     * Get active promotions
     *
     * @return List of active promotions
     */
    List<PromotionDto> getActivePromotions();

    /**
     * Get promotion by code
     *
     * @param code Promotion code
     * @return PromotionDto if found, null otherwise
     */
    PromotionDto getPromotionByCode(String code);

    /**
     * Get promotions by type
     *
     * @param type Promotion type
     * @return List of promotions with the given type
     */
    List<PromotionDto> getPromotionsByType(String type);

    /**
     * Apply promotion to order
     *
     * @param promotionCode Promotion code
     * @param orderAmount Order amount
     * @return Discount amount if promotion is valid, 0 otherwise
     */
    double applyPromotion(String promotionCode, double orderAmount);

    /**
     * Get expiring promotions
     *
     * @param days Number of days before expiration
     * @return List of promotions expiring soon
     */
    List<PromotionDto> getExpiringPromotions(int days);

    /**
     * Validate promotion code
     *
     * @param code Promotion code
     * @param orderAmount Order amount
     * @return true if promotion is valid and applicable
     */
    boolean validatePromotionCode(String code, double orderAmount);

    /**
     * Update promotion details (name, code, description)
     *
     * @param promotionId Promotion ID
     * @param name New name
     * @param code New code
     * @param description New description
     * @return true if update successful
     */
    boolean updatePromotionDetails(String promotionId, String name, String code, String description);

    /**
     * Update promotion value
     *
     * @param promotionId Promotion ID
     * @param value New value
     * @return true if update successful
     */
    boolean updatePromotionValue(String promotionId, double value);

    /**
     * Update promotion dates
     *
     * @param promotionId Promotion ID
     * @param startDate New start date
     * @param endDate New end date
     * @return true if update successful
     */
    boolean updatePromotionDates(String promotionId, java.time.LocalDateTime startDate, java.time.LocalDateTime endDate);

    /**
     * Update Payment amount with fixed promotion
     *
     * @param promotion
     * @param order
     */
    void useFixedPromotion(Promotion promotion, Order order);

    /**
     * 
     * @param promotion
     * @param order 
     */
    public void usePercentPromotion(Promotion promotion, Order order);
}
