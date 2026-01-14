package model;

public final class UserMapper {
    private UserMapper(){}

    public static UserDto toDto(User u){
        if (u == null) return null;
        UserDto d = new UserDto();
        d.setUserId(u.getUserId());
        d.setEmail(u.getEmail());
        d.setFullName(u.getFullName());
        d.setRole(u.getRole());
        d.setStatus(u.getStatus());
        d.setNote(u.getNote());
        d.setCreatedAt(u.getCreatedAt());
        // Don't map password hash for security
        return d;
    }
    
    public static User toEntity(UserDto dto){
        if (dto == null) return null;
        User u = new User();
        u.setUserId(dto.getUserId());
        u.setEmail(dto.getEmail());
        u.setFullName(dto.getFullName());
        u.setRole(dto.getRole());
        u.setStatus(dto.getStatus());
        u.setNote(dto.getNote());
        u.setCreatedAt(dto.getCreatedAt());
        // Password hash should be set separately if needed
        return u;
    }
}
