package service;

import dao.SettingDao;
import dao.SettingDaoJdbc;
import model.Setting;
import model.SettingDto;
import model.SettingMapper;

import java.util.List;
import java.util.stream.Collectors;

public class SettingServiceImpl implements SettingService {

    private final SettingDao settingDao = new SettingDaoJdbc();

    @Override
    public List<SettingDto> getAllSettings() {
        return settingDao.findAll().stream()
                .map(SettingMapper::toDto)
                .collect(Collectors.toList());
    }

    @Override
    public SettingDto getSettingById(String id) {
        return settingDao.findById(id)
                .map(SettingMapper::toDto)
                .orElse(null);
    }

    @Override
    public void insertSetting(SettingDto dto) {
        Setting setting = SettingMapper.toEntity(dto);
        settingDao.insert(setting);
        dto.setSettingId(setting.getSettingId());
    }

    @Override
    public void updateSetting(SettingDto dto) {
        Setting setting = SettingMapper.toEntity(dto);
        settingDao.update(setting);
    }

    @Override
    public void deleteSetting(String id) {
        settingDao.delete(id);
    }

    @Override
    public List<SettingDto> getSettingsByCategory(String category) {
        return settingDao.findByCategory(category).stream()
                .map(SettingMapper::toDto)
                .collect(Collectors.toList());
    }
}