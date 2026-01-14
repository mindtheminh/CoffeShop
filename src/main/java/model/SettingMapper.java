package model;

public class SettingMapper {
    
    public static SettingDto toDto(Setting setting) {
        if (setting == null) return null;
        
        SettingDto dto = new SettingDto();
        dto.setSettingId(setting.getSettingId());
        dto.setName(setting.getName());
        dto.setValue(setting.getValue());
        dto.setDatatype(setting.getDatatype());
        dto.setCategory(setting.getCategory());
        dto.setStatus(setting.getStatus());
        dto.setDescription(setting.getDescription());
        dto.setNote(setting.getNote());
        dto.setUpdatedBy(setting.getUpdatedBy());
        dto.setCreatedAt(setting.getCreatedAt());
        dto.setUpdatedAt(setting.getUpdatedAt());
        return dto;
    }
    
    public static Setting toEntity(SettingDto dto) {
        if (dto == null) return null;
        
        Setting setting = new Setting();
        setting.setSettingId(dto.getSettingId());
        setting.setName(dto.getName());
        setting.setValue(dto.getValue());
        setting.setDatatype(dto.getDatatype());
        setting.setCategory(dto.getCategory());
        setting.setStatus(dto.getStatus());
        setting.setDescription(dto.getDescription());
        setting.setNote(dto.getNote());
        setting.setUpdatedBy(dto.getUpdatedBy());
        setting.setCreatedAt(dto.getCreatedAt());
        setting.setUpdatedAt(dto.getUpdatedAt());
        return setting;
    }
}
