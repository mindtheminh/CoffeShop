package config;

import jakarta.servlet.http.HttpServletRequest;
import vn.payos.PayOS;

/**
 * PayOS Configuration
 * Quản lý khởi tạo PayOS client (Singleton)
 *
 * Lưu ý quan trọng:
 *  - CLIENT_ID, API_KEY, CHECKSUM_KEY phải trùng 100% với PayOS Dashboard
 *  - Không có khoảng trắng / xuống dòng dư thừa
 *  - CHECKSUM_KEY thường là 64 ký tự hex
 */
public class PayOSConfig {

    /**
     * Giá trị mặc định (fallback) – CHỈ dùng cho local dev.
     * Khuyến nghị:
     *   - Lấy từ ENV: PAYOS_CLIENT_ID, PAYOS_API_KEY, PAYOS_CHECKSUM_KEY
     *   - Không commit giá trị thật lên Git
     */
    private static final String DEFAULT_CLIENT_ID   = "     ";
    private static final String DEFAULT_API_KEY     = "     ";
    private static final String DEFAULT_CHECKSUM_KEY = "    ";

    private static PayOS payOSInstance;
    private static boolean initialized = false;

    // =================== Public API ===================

    /**
     * Lấy PayOS instance (Singleton)
     */
    public static PayOS getPayOS() {
        if (payOSInstance == null) {
            synchronized (PayOSConfig.class) {
                if (payOSInstance == null) {
                    // Đọc key từ ENV hoặc fallback sang default
                    String clientId    = getEnvOrDefault("PAYOS_CLIENT_ID", DEFAULT_CLIENT_ID);
                    String apiKey      = getEnvOrDefault("PAYOS_API_KEY", DEFAULT_API_KEY);
                    String checksumKey = getEnvOrDefault("PAYOS_CHECKSUM_KEY", DEFAULT_CHECKSUM_KEY);

                    validateKeys(clientId, apiKey, checksumKey);
                    logKeyInfo(clientId, apiKey, checksumKey);

                    payOSInstance = new PayOS(clientId, apiKey, checksumKey);
                    initialized = true;
                    System.out.println("PayOS instance initialized successfully.");
                }
            }
        }
        return payOSInstance;
    }

    /**
     * Lấy base URL (dùng để build returnUrl, cancelUrl)
     * Ví dụ: http://localhost:8080/ISP392
     */
    public static String getBaseUrl(HttpServletRequest request) {
        String scheme      = request.getScheme();      // http / https
        String serverName  = request.getServerName();  // localhost / domain
        int    serverPort  = request.getServerPort();  // 8080, 80, 443...
        String contextPath = request.getContextPath(); // /ISP392

        StringBuilder baseUrl = new StringBuilder();
        baseUrl.append(scheme).append("://").append(serverName);

        // Chỉ thêm port nếu không phải port mặc định
        if (("http".equalsIgnoreCase(scheme) && serverPort != 80) ||
            ("https".equalsIgnoreCase(scheme) && serverPort != 443)) {
            baseUrl.append(":").append(serverPort);
        }

        baseUrl.append(contextPath);

        String url = baseUrl.toString();
        System.out.println("PayOS Base URL (from request): " + url);
        System.out.println("  - Scheme: " + scheme);
        System.out.println("  - Server: " + serverName);
        System.out.println("  - Port  : " + serverPort);
        System.out.println("  - Context Path: " + contextPath);

        return url;
    }

    /**
     * Fallback getBaseUrl (khi không có request) – ít dùng
     */
    public static String getBaseUrl() {
        String contextPath = System.getProperty("context.path", "/ISP392");
        String port        = System.getProperty("server.port", "8080");
        String host        = System.getProperty("server.host", "localhost");

        String url = "http://" + host + ":" + port + contextPath;
        System.out.println("PayOS Base URL (fallback): " + url);
        System.out.println("WARNING: Using fallback URL. Context path may be incorrect!");
        return url;
    }

    /**
     * Reset PayOS instance – dùng khi đổi key / test
     */
    public static void reset() {
        synchronized (PayOSConfig.class) {
            payOSInstance = null;
            initialized = false;
            System.out.println("PayOS instance reset. Next getPayOS() will re-initialize.");
        }
    }

    /**
     * Force re-init ngay lập tức
     */
    public static void reinitialize() {
        reset();
        getPayOS();
    }

    // =================== Helper Methods ===================

    /**
     * Lấy giá trị từ ENV (hoặc System Property), nếu không có thì dùng default
     */
    private static String getEnvOrDefault(String key, String defaultValue) {
        String fromEnv = System.getenv(key);
        if (fromEnv != null && !fromEnv.trim().isEmpty()) {
            return fromEnv.trim();
        }

        String fromProp = System.getProperty(key);
        if (fromProp != null && !fromProp.trim().isEmpty()) {
            return fromProp.trim();
        }

        return defaultValue;
    }

    /**
     * Validate format của 3 key
     */
    private static void validateKeys(String clientId, String apiKey, String checksumKey) {
        if (clientId == null || clientId.trim().isEmpty()) {
            throw new IllegalStateException("PAYOS CLIENT_ID is not set (ENV: PAYOS_CLIENT_ID)");
        }
        if (apiKey == null || apiKey.trim().isEmpty()) {
            throw new IllegalStateException("PAYOS API_KEY is not set (ENV: PAYOS_API_KEY)");
        }
        if (checksumKey == null || checksumKey.trim().isEmpty()) {
            throw new IllegalStateException("PAYOS CHECKSUM_KEY is not set (ENV: PAYOS_CHECKSUM_KEY)");
        }

        // Kiểm tra khoảng trắng thừa
        if (!clientId.equals(clientId.trim()) ||
            !apiKey.equals(apiKey.trim()) ||
            !checksumKey.equals(checksumKey.trim())) {
            System.err.println("WARNING: PayOS keys contain leading/trailing whitespace!");
        }

        // Kiểm tra độ dài checksum (thường 64 ký tự hex)
        String trimmedKey = checksumKey.trim();
        if (trimmedKey.length() != 64) {
            System.err.println("WARNING: CHECKSUM_KEY length is " + trimmedKey.length() + " (expected 64).");
        }
    }

    /**
     * Log thông tin (không in full key)
     */
    private static void logKeyInfo(String clientId, String apiKey, String checksumKey) {
        System.out.println("=== PAYOS CONFIG INITIALIZATION ===");
        System.out.println("CLIENT_ID length : " + clientId.length());
        System.out.println("CLIENT_ID prefix : " + safePrefix(clientId));

        System.out.println("API_KEY length   : " + apiKey.length());
        System.out.println("API_KEY prefix   : " + safePrefix(apiKey));

        System.out.println("CHECKSUM length  : " + checksumKey.length());
        System.out.println("CHECKSUM prefix  : " + safePrefix(checksumKey));
        System.out.println("CHECKSUM suffix  : " + safeSuffix(checksumKey));

        System.out.println("PayOS initialized: " + initialized);
        System.out.println("===================================");
    }

    private static String safePrefix(String value) {
        if (value == null) return "null";
        return value.substring(0, Math.min(8, value.length()));
    }

    private static String safeSuffix(String value) {
        if (value == null) return "null";
        int len = value.length();
        return value.substring(Math.max(0, len - 8));
    }
}
