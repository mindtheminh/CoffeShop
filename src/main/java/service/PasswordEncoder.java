package service;

import common.PasswordUtils;

public final class PasswordEncoder {
	private PasswordEncoder() {}

    public static boolean matchesFlexible(String rawPassword, String stored) {
        if (stored == null) return false;
        // bcrypt via reflection if library present
        if (stored.startsWith("$2a$") || stored.startsWith("$2b$") || stored.startsWith("$2y$")) {
            try {
                Class<?> bc = Class.forName("org.mindrot.jbcrypt.BCrypt");
                java.lang.reflect.Method m = bc.getMethod("checkpw", String.class, String.class);
                Object ok = m.invoke(null, rawPassword, stored);
                return (Boolean) ok;
            } catch (Throwable t) {
                System.err.println("[WARN] BCrypt library not on classpath; bcrypt check skipped: " + t.getMessage());
                return false;
            }
        }
        // our HEX:SALT format
        if (stored.contains(":")) {
            return PasswordUtils.matches(rawPassword, stored);
        }
        // legacy plain text
        return rawPassword.equals(stored);
    }
}


