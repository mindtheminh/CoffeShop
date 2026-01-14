package dao;

import model.Promotion;
import java.util.List;
import java.util.Optional;

/**
 * PromotionDao interface - Data Access Object for Promotion
 * @author Asus
 */
public interface PromotionDao {
    
    /**
     * Find all promotions
     * @return List of all promotions
     */
    List<Promotion> findAll();
    
    /**
     * Find promotion by ID
     * @param id Promotion ID
     * @return Optional containing the promotion if found
     */
    Optional<Promotion> findById(String id);
    
    /**
     * Create new promotion
     * @param promotion Promotion to create
     * @return Created promotion ID
     */
    String create(Promotion promotion);
    
    /**
     * Update existing promotion
     * @param promotion Promotion to update
     * @return true if update successful
     */
    boolean update(Promotion promotion);
    
    /**
     * Delete promotion by ID
     * @param id Promotion ID to delete
     * @return true if delete successful
     */
    boolean deleteById(String id);
    
    /**
     * Find promotions by status
     * @param status Promotion status
     * @return List of promotions with the given status
     */
    List<Promotion> findByStatus(String status);
    
    /**
     * Find active promotions
     * @return List of active promotions
     */
    List<Promotion> findActivePromotions();
    
    /**
     * Find promotion by code
     * @param code Promotion code
     * @return Optional containing the promotion if found
     */
    Optional<Promotion> findByCode(String code);
    
    /**
     * Find promotions by type
     * @param type Promotion type
     * @return List of promotions with the given type
     */
    List<Promotion> findByType(String type);
    
    /**
     * Update promotion usage count
     * @param promotionId Promotion ID
     * @return true if update successful
     */
    boolean incrementUsageCount(String promotionId);
    
    /**
     * Find promotions that are about to expire
     * @param days Number of days before expiration
     * @return List of promotions expiring soon
     */
    List<Promotion> findExpiringPromotions(int days);
    
    /**
     * Update promotion details (name, code, description)
     * @param promotionId Promotion ID
     * @param name New name
     * @param code New code
     * @param description New description
     * @return true if update successful
     */
    boolean updatePromotionDetails(String promotionId, String name, String code, String description);
    
    /**
     * Update promotion value
     * @param promotionId Promotion ID
     * @param value New value
     * @return true if update successful
     */
    boolean updatePromotionValue(String promotionId, double value);
    
    /**
     * Update promotion dates
     * @param promotionId Promotion ID
     * @param startDate New start date
     * @param endDate New end date
     * @return true if update successful
     */
    boolean updatePromotionDates(String promotionId, java.time.LocalDateTime startDate, java.time.LocalDateTime endDate);
}