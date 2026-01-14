package service;

import model.SettingDto;
import java.util.List;

public interface SettingService {
    List<SettingDto> getAllSettings();
    SettingDto getSettingById(String id);  // Changed from UUID to String
    void insertSetting(SettingDto dto);
    void updateSetting(SettingDto dto);
    void deleteSetting(String id);  // Changed from UUID to String
    List<SettingDto> getSettingsByCategory(String category);
}
