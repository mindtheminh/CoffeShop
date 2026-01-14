/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package util;

import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.io.UnsupportedEncodingException;
import java.util.Properties;
import jakarta.mail.Authenticator;
import jakarta.mail.PasswordAuthentication;

/**
 *
 * @author Acer
 */
public class EmailUtils {

    private static final String USERNAME = "he182533nguyenvuduc@gmail.com"; // Gmail cuar usser
    private static final String PASSWORD = "nmgd ljyg gecn mnzw";   // App Password

    public static void sendVerificationEmail(String to, String code) throws MessagingException, UnsupportedEncodingException {
        String subject = "Ma xac nhan dang ky - Yen Coffee";
        String content = "<!DOCTYPE html>"
                + "<html>"
                + "<head>"
                + "<meta charset='UTF-8'>"
                + "<meta name='viewport' content='width=device-width, initial-scale=1.0'>"
                + "</head>"
                + "<body style='margin: 0; padding: 20px; font-family: Arial, sans-serif; background-color: #f5f5f5;'>"
                + "<div style='max-width: 600px; margin: 0 auto; background-color: #ffffff; border-radius: 10px; overflow: hidden; box-shadow: 0 2px 10px rgba(0,0,0,0.1);'>"
                + "<div style='background-color: #c7a17a; padding: 30px; text-align: center;'>"
                + "<h1 style='color: #000; margin: 0; font-size: 24px;'>Yen Coffee</h1>"
                + "</div>"
                + "<div style='padding: 40px 30px;'>"
                + "<h2 style='color: #333; margin-top: 0; font-size: 22px;'>Xac nhan dang ky tai khoan</h2>"
                + "<p style='color: #666; line-height: 1.6; font-size: 15px;'>Xin chao!</p>"
                + "<p style='color: #666; line-height: 1.6; font-size: 15px;'>Ban vua dang ky tai khoan tren he thong. Day la ma OTP cua ban:</p>"
                + "<div style='background: linear-gradient(135deg, #c7a17a 0%, #8b7355 100%); padding: 25px; border-radius: 10px; margin: 30px 0; text-align: center;'>"
                + "<div style='background: #fff; padding: 20px; border-radius: 8px; display: inline-block;'>"
                + "<h1 style='color: #333; margin: 0; font-size: 42px; letter-spacing: 8px; font-weight: bold;'>" + code + "</h1>"
                + "</div>"
                + "</div>"
                + "<p style='color: #666; line-height: 1.6; font-size: 15px; text-align: center; margin: 25px 0;'>Nhap ma nay vao trang dang ky de hoan tat</p>"
                + "<div style='background-color: #fff3cd; border-left: 4px solid #ffc107; padding: 15px; margin: 25px 0; border-radius: 4px;'>"
                + "<p style='color: #856404; margin: 0; font-size: 14px;'><strong>Luu y:</strong> Ma OTP chi co hieu luc trong 5 phut.</p>"
                + "</div>"
                + "<p style='color: #666; line-height: 1.6; font-size: 14px;'>Neu ban khong dang ky tai khoan, vui long bo qua email nay.</p>"
                + "</div>"
                + "<div style='background-color: #f8f9fa; padding: 20px 30px; border-top: 1px solid #ddd;'>"
                + "<p style='color: #999; font-size: 12px; margin: 0; text-align: center;'>Email nay duoc gui tu dong tu he thong Yen Coffee.<br>Vui long khong tra loi email nay.</p>"
                + "</div>"
                + "</div>"
                + "</body>"
                + "</html>";

        // Dùng propertis để giao tiếp Smtp
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.mime.charset", "UTF-8");

        //xác thực với gg để gửi
        Session session = Session.getInstance(props,
                new Authenticator() {
            public PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(USERNAME, PASSWORD);
            }
        });

        // Set UTF-8 encoding
        session.getProperties().setProperty("mail.mime.charset", "UTF-8");

        MimeMessage message = new MimeMessage(session);
        message.setFrom(new InternetAddress(USERNAME, "Yen Coffee", "UTF-8"));
        
        //Chuyển email thành địa chỉ
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
        message.setSubject(subject, "UTF-8");
        message.setContent(content, "text/html; charset=UTF-8");
        message.setHeader("Content-Type", "text/html; charset=UTF-8");

        Transport.send(message);
    }
    
    public static void sendPasswordResetOTP(String to, String otp) throws MessagingException, UnsupportedEncodingException {
        String subject = "Ma OTP dat lai mat khau - Yen Coffee";
        String content = "<!DOCTYPE html>"
                + "<html>"
                + "<head>"
                + "<meta charset='UTF-8'>"
                + "<meta name='viewport' content='width=device-width, initial-scale=1.0'>"
                + "</head>"
                + "<body style='margin: 0; padding: 20px; font-family: Arial, sans-serif; background-color: #f5f5f5;'>"
                + "<div style='max-width: 600px; margin: 0 auto; background-color: #ffffff; border-radius: 10px; overflow: hidden; box-shadow: 0 2px 10px rgba(0,0,0,0.1);'>"
                + "<div style='background-color: #c7a17a; padding: 30px; text-align: center;'>"
                + "<h1 style='color: #000; margin: 0; font-size: 24px;'>Yen Coffee</h1>"
                + "</div>"
                + "<div style='padding: 40px 30px;'>"
                + "<h2 style='color: #333; margin-top: 0; font-size: 22px;'>Ma xac nhan dat lai mat khau</h2>"
                + "<p style='color: #666; line-height: 1.6; font-size: 15px;'>Xin chao,</p>"
                + "<p style='color: #666; line-height: 1.6; font-size: 15px;'>Ban vua yeu cau dat lai mat khau. Day la ma OTP cua ban:</p>"
                + "<div style='background: linear-gradient(135deg, #c7a17a 0%, #8b7355 100%); padding: 25px; border-radius: 10px; margin: 30px 0; text-align: center;'>"
                + "<div style='background: #fff; padding: 20px; border-radius: 8px; display: inline-block;'>"
                + "<h1 style='color: #333; margin: 0; font-size: 42px; letter-spacing: 8px; font-weight: bold;'>" + otp + "</h1>"
                + "</div>"
                + "</div>"
                + "<p style='color: #666; line-height: 1.6; font-size: 15px; text-align: center; margin: 25px 0;'>Nhap ma nay vao trang dat lai mat khau</p>"
                + "<div style='background-color: #fff3cd; border-left: 4px solid #ffc107; padding: 15px; margin: 25px 0; border-radius: 4px;'>"
                + "<p style='color: #856404; margin: 0; font-size: 14px;'><strong>Luu y:</strong> Ma OTP chi co hieu luc trong 5 phut.</p>"
                + "</div>"
                + "<p style='color: #666; line-height: 1.6; font-size: 14px;'>Neu ban khong yeu cau dat lai mat khau, vui long bo qua email nay.</p>"
                + "</div>"
                + "<div style='background-color: #f8f9fa; padding: 20px 30px; border-top: 1px solid #ddd;'>"
                + "<p style='color: #999; font-size: 12px; margin: 0; text-align: center;'>Email nay duoc gui tu dong tu he thong Yen Coffee.<br>Vui long khong tra loi email nay.</p>"
                + "</div>"
                + "</div>"
                + "</body>"
                + "</html>";

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.mime.charset", "UTF-8");

        Session session = Session.getInstance(props,
                new Authenticator() {
            public PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(USERNAME, PASSWORD);
            }
        });

        // Set UTF-8 encoding
        session.getProperties().setProperty("mail.mime.charset", "UTF-8");

        MimeMessage message = new MimeMessage(session);
        message.setFrom(new InternetAddress(USERNAME, "Yen Coffee", "UTF-8"));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
        message.setSubject(subject, "UTF-8");
        message.setContent(content, "text/html; charset=UTF-8");
        message.setHeader("Content-Type", "text/html; charset=UTF-8");

        Transport.send(message);
    }
    
    public static void main(String[] args) throws MessagingException, UnsupportedEncodingException {
        // Test verification email
        // sendVerificationEmail("anhnq16102005@gmail.com", "abcdef");
        
        // Test password reset email
        // sendPasswordResetEmail("anhnq16102005@gmail.com", "test-token-123");
    }
}