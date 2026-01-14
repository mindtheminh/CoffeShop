package dao;

import model.Setting;
import java.util.List;
import java.util.Optional;

public interface SettingDao {
    List<Setting> findAll();
    Optional<Setting> findById(String id);  // Changed from UUID to String
    void insert(Setting setting);
    void update(Setting setting);
    void delete(String id);  // Changed from UUID to String
    List<Setting> findByCategory(String category);
    String generateNextSettingId();  // Generate next ID like ST001, ST002
}
