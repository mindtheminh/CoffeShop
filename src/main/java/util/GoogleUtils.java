/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package util;

import config.AppConfig;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import org.json.JSONObject;

/**
 * Google OAuth 2.0 Utilities
 * Sử dụng HTTP requests thuần để tránh dependency issues
 * @author PC
 */
public class GoogleUtils {
    public static final String CLIENT_ID = AppConfig.CLIENT_ID;
    public static final String CLIENT_SECRET = AppConfig.CLIENT_SECRET;
    public static final String REDIRECT_URI = AppConfig.GOOGLE_REDIRECT_URI;
    
    private static final String TOKEN_URL = "https://oauth2.googleapis.com/token";
    private static final String USERINFO_URL = "https://www.googleapis.com/oauth2/v2/userinfo";
    private static final String AUTH_URL = "https://accounts.google.com/o/oauth2/v2/auth";

    /**
     * Tạo URL để redirect user đến Google login page
     */
    public static String getGoogleLoginUrl() {
        try {
            return AUTH_URL + "?"
                    + "client_id=" + URLEncoder.encode(CLIENT_ID, "UTF-8")
                    + "&redirect_uri=" + URLEncoder.encode(REDIRECT_URI, "UTF-8")
                    + "&response_type=code"
                    + "&scope=email profile"
                    + "&access_type=offline";
        } catch (Exception e) {
            throw new RuntimeException("Error building Google login URL", e);
        }
    }

    /**
     * Đổi authorization code thành access token
     */
    public static String getToken(String code) throws IOException {
        URL url = new URL(TOKEN_URL);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
        conn.setDoOutput(true);

        String postData = "code=" + URLEncoder.encode(code, "UTF-8")
                + "&client_id=" + URLEncoder.encode(CLIENT_ID, "UTF-8")
                + "&client_secret=" + URLEncoder.encode(CLIENT_SECRET, "UTF-8")
                + "&redirect_uri=" + URLEncoder.encode(REDIRECT_URI, "UTF-8")
                + "&grant_type=authorization_code";

        try (OutputStream os = conn.getOutputStream()) {
            os.write(postData.getBytes());
            os.flush();
        }

        int responseCode = conn.getResponseCode();
        if (responseCode == HttpURLConnection.HTTP_OK) {
            BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            String inputLine;
            StringBuilder response = new StringBuilder();
            while ((inputLine = in.readLine()) != null) {
                response.append(inputLine);
            }
            in.close();

            JSONObject json = new JSONObject(response.toString());
            return json.getString("access_token");
        } else {
            // Read error response for better debugging
            BufferedReader errIn = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
            String errorResponse = "";
            String line;
            while ((line = errIn.readLine()) != null) {
                errorResponse += line;
            }
            errIn.close();
            throw new IOException("Failed to get access token. Response code: " + responseCode + ", Error: " + errorResponse);
        }
    }

    /**
     * Lấy thông tin user từ Google bằng access token
     * @return JSONObject chứa email, name, picture, etc.
     */
    public static JSONObject getUserInfo(String accessToken) throws IOException {
        URL url = new URL(USERINFO_URL);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Authorization", "Bearer " + accessToken);

        int responseCode = conn.getResponseCode();
        if (responseCode == HttpURLConnection.HTTP_OK) {
            BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            String inputLine;
            StringBuilder response = new StringBuilder();
            while ((inputLine = in.readLine()) != null) {
                response.append(inputLine);
            }
            in.close();

            return new JSONObject(response.toString());
        } else {
            // Read error response for better debugging
            BufferedReader errIn = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
            String errorResponse = "";
            String line;
            while ((line = errIn.readLine()) != null) {
                errorResponse += line;
            }
            errIn.close();
            throw new IOException("Failed to get user info. Response code: " + responseCode + ", Error: " + errorResponse);
        }
    }
}
