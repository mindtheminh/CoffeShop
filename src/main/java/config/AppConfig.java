package config;

public class AppConfig {
    // Your Google OAuth 2.0 credentials
    public static final String CLIENT_ID = "338917210432-arhrn9f73eu2son0nqag0bqj3jbnp2rl.apps.googleusercontent.com";
    public static final String CLIENT_SECRET = "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";
    
    // Redirect URI must exactly match the one registered in Google Cloud
    public static final String GOOGLE_REDIRECT_URI = "http://localhost:9999/ISP392/auth/google-callback";
}