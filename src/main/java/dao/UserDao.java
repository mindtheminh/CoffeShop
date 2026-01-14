package dao;

import model.User;
import java.util.List;
import java.util.Optional;

public interface UserDao {
    // CRUD operations
    List<User> findAll();
    Optional<User> findById(int userId);
    Optional<User> findByEmail(String email);
    void insert(User u);
    void update(User u);
    void delete(int userId);
    
    // Additional methods
    void clearResetToken(int userId);
    void saveResetToken(String email, String token, long expiryTime);
    Optional<User> findByResetToken(String token);
    List<User> findByRole(String role);
    List<User> findByStatus(String status);
    
    // Count methods for HR Dashboard
    int countAll();
    
    int countByStatus(String status);
    
    int countNewHiresThisMonth();
    
    List<User> findRecent(int limit);
}
