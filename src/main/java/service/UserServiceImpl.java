package service;

import common.PasswordUtils;
import dao.OrderDao;
import dao.OrderDaoJdbc;
import dao.UserDao;
import dao.UserDaoJdbc;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import model.Order;
import model.Promotion;
import model.User;
import model.UserDto;
import model.UserMapper;

public class UserServiceImpl implements UserService {

    private final UserDao userDao = new UserDaoJdbc();
    private static final String STRONG_PW_REGEX = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).{8,}$";

    @Override
    public boolean isStrongPassword(String raw) {
        return raw != null && raw.matches(STRONG_PW_REGEX);
    }

    @Override
    public void register(UserDto dto) {
        User u = new User();
        u.setFullName(dto.getFullName());
        u.setEmail(dto.getEmail());
        
        // Xử lý password - nếu có thì hash, nếu không (Google login) thì để null
        if (dto.getPassword() != null && !dto.getPassword().isEmpty()) {
            String stored = PasswordUtils.hashForStore(dto.getPassword()); // HEX:SALT
            u.setPasswordHash(stored);
        } else {
            // Với đăng ký thường, không cho NULL password
            u.setPasswordHash(PasswordUtils.hashForStore("Temp#12345"));
        }
        
        u.setRole(dto.getRole() == null ? "CUSTOMER" : dto.getRole());
        // DB constraint expects 'Active' / 'Inactive' for users
        u.setStatus(dto.getStatus() == null ? "Active" : dto.getStatus());
        u.setNote(dto.getNote());

        userDao.insert(u);
    }

    @Override
    public boolean existsByEmail(String email) {
        return userDao.findByEmail(email).isPresent();
    }

    @Override
    public UserDto findByEmail(String email) {
        return userDao.findByEmail(email)
                .map(UserMapper::toDto)
                .orElse(null);
    }

    @Override
    public UserDto authenticate(String email, String rawPassword) {
        java.util.Optional<User> opt = userDao.findByEmail(email);
        if (opt.isEmpty())
            return null;
        User u = opt.get();
        String stored = u.getPasswordHash();
        if (!service.PasswordEncoder.matchesFlexible(rawPassword, stored))
            return null;
        return UserMapper.toDto(u);
    }

    @Override
    public List<UserDto> getAllUsers() {
        try {
            System.out.println("=== DEBUG: UserServiceImpl.getAllUsers() called ===");
            List<User> users = userDao.findAll();
            System.out.println("DEBUG: Raw users from DAO: " + (users != null ? users.size() : "null"));
            
            List<UserDto> userDtos = users.stream()
                    .map(UserMapper::toDto)
                    .collect(java.util.stream.Collectors.toList());
            
            System.out.println("DEBUG: Mapped user DTOs: " + (userDtos != null ? userDtos.size() : "null"));
            return userDtos;
        } catch (Exception e) {
            System.out.println("=== DEBUG: Exception in UserServiceImpl.getAllUsers() ===");
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    @Override
    public UserDto getUserById(int userId) {
        return userDao.findById(userId)
                .map(UserMapper::toDto)
                .orElse(null);
    }

    @Override
    public void insertUser(UserDto dto) {
        String stored = PasswordUtils.hashForStore(dto.getPassword());

        User u = new User();
        u.setFullName(dto.getFullName());
        u.setEmail(dto.getEmail());
        u.setPasswordHash(stored);
        u.setRole(dto.getRole() == null ? "CUSTOMER" : dto.getRole());
        u.setStatus(dto.getStatus() == null ? "Active" : dto.getStatus());

        userDao.insert(u);
    }

    @Override
    public void updateUser(UserDto dto) {
        // Get existing user from database to preserve password_hash
        int userId = Integer.parseInt(dto.getUserId());
        User existingUser = userDao.findById(userId).orElse(null);
        
        if (existingUser == null) {
            throw new RuntimeException("User not found with id: " + userId);
        }
        
        // Create updated user with existing data
        User u = UserMapper.toEntity(dto);
        
        // Preserve existing password_hash (don't overwrite it)
        u.setPasswordHash(existingUser.getPasswordHash());
        
        // If password is provided and not empty, update it with new hash
        if (dto.getPassword() != null && !dto.getPassword().isEmpty()) {
            String stored = PasswordUtils.hashForStore(dto.getPassword());
            u.setPasswordHash(stored);
        }
        
        userDao.update(u);
    }

    @Override
    public void deleteUser(int userId) {
        userDao.delete(userId);
    }

    @Override
    public List<UserDto> getUsersByRole(String role) {
        return userDao.findByRole(role).stream()
                .map(UserMapper::toDto)
                .collect(java.util.stream.Collectors.toList());
    }

    @Override
    public List<UserDto> getUsersByStatus(String status) {
        return userDao.findByStatus(status).stream()
                .map(UserMapper::toDto)
                .collect(java.util.stream.Collectors.toList());
    }

    @Override
    public int countAll() {
        try {
            return userDao.countAll();
        } catch (Exception e) {
            System.err.println("Error counting all users: " + e.getMessage());
            e.printStackTrace();
            return 0;
        }
    }

    @Override
    public int countActive() {
        try {
            return userDao.countByStatus("Active");
        } catch (Exception e) {
            System.err.println("Error counting active users: " + e.getMessage());
            e.printStackTrace();
            return 0;
        }
    }

    @Override
    public int countInactive() {
        try {
            return userDao.countByStatus("Inactive");
        } catch (Exception e) {
            System.err.println("Error counting inactive users: " + e.getMessage());
            e.printStackTrace();
            return 0;
        }
    }

    @Override
    public int countNewHiresThisMonth() {
        try {
            return userDao.countNewHiresThisMonth();
        } catch (Exception e) {
            System.err.println("Error counting new hires this month: " + e.getMessage());
            e.printStackTrace();
            return 0;
        }
    }

    @Override
    public List<UserDto> findRecent(int limit) {
        try { 
            
            return userDao.findRecent(limit).stream()
                    .map(UserMapper::toDto)
                    .collect(java.util.stream.Collectors.toList());
        } catch (Exception e) {
            System.err.println("Error finding recent users: " + e.getMessage());
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    
    
    
}