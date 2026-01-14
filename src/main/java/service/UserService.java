
package service;

import model.UserDto;
import java.util.List;
import model.Order;
import model.Promotion;

public interface UserService {
    // Authentication
    boolean isStrongPassword(String raw);

    boolean existsByEmail(String email);

    UserDto findByEmail(String email);

    void register(UserDto dto);

    UserDto authenticate(String email, String rawPassword);

    // CRUD operations
    List<UserDto> getAllUsers();

    UserDto getUserById(int userId);

    void insertUser(UserDto dto);

    void updateUser(UserDto dto);

    void deleteUser(int userId);

    // Additional methods
    List<UserDto> getUsersByRole(String role);

    List<UserDto> getUsersByStatus(String status);
    
    // Count methods for HR Dashboard
    int countAll();
    
    int countActive();
    
    int countInactive();
    
    int countNewHiresThisMonth();
    
    List<UserDto> findRecent(int limit);
    
   
}