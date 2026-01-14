/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */


package common;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.util.UUID;

public final class PasswordUtils {
    private PasswordUtils() {}
    
    private static final String UPPERCASE = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    private static final String LOWERCASE = "abcdefghijklmnopqrstuvwxyz";
    private static final String DIGITS = "0123456789";
    private static final String SPECIAL = "!@#$%&*";
    private static final String ALL_CHARS = UPPERCASE + LOWERCASE + DIGITS + SPECIAL;
    private static final SecureRandom RANDOM = new SecureRandom();

    public static String newSalt() {
        return UUID.randomUUID().toString();
    }
    
    /**
     * Generate a random password with at least 8 characters including uppercase, lowercase, and digit
     */
    public static String generateRandomPassword() {
        StringBuilder password = new StringBuilder(12);
        
        // Ensure at least one of each required type
        password.append(UPPERCASE.charAt(RANDOM.nextInt(UPPERCASE.length())));
        password.append(LOWERCASE.charAt(RANDOM.nextInt(LOWERCASE.length())));
        password.append(DIGITS.charAt(RANDOM.nextInt(DIGITS.length())));
        password.append(SPECIAL.charAt(RANDOM.nextInt(SPECIAL.length())));
        
        // Fill the rest randomly
        for (int i = password.length(); i < 12; i++) {
            password.append(ALL_CHARS.charAt(RANDOM.nextInt(ALL_CHARS.length())));
        }
        
        // Shuffle the password to avoid predictable pattern
        char[] chars = password.toString().toCharArray();
        for (int i = chars.length - 1; i > 0; i--) {
            int j = RANDOM.nextInt(i + 1);
            char temp = chars[i];
            chars[i] = chars[j];
            chars[j] = temp;
        }
        
        return new String(chars);
    }

    public static String sha256Hex(String s) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] out = md.digest(s.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder(out.length * 2);
            for (byte b : out) sb.append(String.format("%02X", b));
            return sb.toString();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    /** Tạo chuỗi lưu DB: HEX:SALT */
    public static String hashForStore(String rawPassword) {
        String salt = newSalt();
        String hex  = sha256Hex(salt + rawPassword);
        return hex + ":" + salt;
    }

    /** So khớp raw với stored dạng HEX:SALT */
    public static boolean matches(String rawPassword, String storedHexColonSalt) {
        if (storedHexColonSalt == null) return false;
        String[] parts = storedHexColonSalt.split(":");
        if (parts.length != 2) return false;
        String hex = parts[0], salt = parts[1];
        String tryHex = sha256Hex(salt + rawPassword);
        return hex.equalsIgnoreCase(tryHex);
    }
}
