package net.javaguide.userregister;

import java.io.InputStream;
import java.io.File;
import java.io.FileInputStream;
import java.util.Properties;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import jakarta.servlet.http.HttpSession;
import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

public class MailUtil {

    private static final ExecutorService EXECUTOR = Executors.newFixedThreadPool(5, r -> {
        Thread t = new Thread(r, "otp-email-worker");
        t.setDaemon(true);
        return t;
    });

    private static Properties loadEmailProperties() {
        Properties props = new Properties();
        
        // 1. Try loading from classpath resource "email.properties"
        try (InputStream input = MailUtil.class.getClassLoader().getResourceAsStream("email.properties")) {
            if (input != null) {
                props.load(input);
            }
        } catch (Exception e) {
            // Ignore failure, fall back to file or system properties
        }

        // 2. If properties still missing host, try relative file path src/main/resources/email.properties
        if (!props.containsKey("smtp.host")) {
            File propFile = new File("src/main/resources/email.properties");
            if (propFile.exists()) {
                try (InputStream input = new FileInputStream(propFile)) {
                    props.load(input);
                } catch (Exception e) {
                    // Ignore failure
                }
            }
        }

        // Defaults for Gmail SMTP if not specified
        if (!props.containsKey("smtp.host")) {
            props.put("smtp.host", "smtp.gmail.com");
            props.put("smtp.port", "587");
            props.put("smtp.auth", "true");
            props.put("smtp.starttls.enable", "true");
        }

        return props;
    }

    public static boolean sendOtpEmail(String toEmail, String otp) {
        String subject = "Blood Bank Management System - 2FA Verification Code";
        String messageText = "Hello,\n\n"
                + "Your 6-digit OTP for login is: " + otp + "\n\n"
                + "This OTP is valid for 5 minutes. Do not share this code with anyone.\n\n"
                + "If you did not request this code, please ignore this email.\n\n"
                + "Regards,\n"
                + "Blood Bank Management System Team";
        return sendEmail(toEmail, subject, messageText);
    }

    public static void sendOtpEmailAsync(String toEmail, String otp, HttpSession httpSession) {
        if (httpSession != null) {
            httpSession.setAttribute("otp_mail_status", "SENDING");
        }
        EXECUTOR.submit(() -> {
            boolean success = sendOtpEmail(toEmail, otp);
            if (httpSession != null) {
                try {
                    if (success) {
                        httpSession.setAttribute("otp_mail_status", "SENT");
                    } else {
                        httpSession.setAttribute("otp_mail_status", "FAILED");
                        httpSession.setAttribute("otp_mail_error", "Failed to send OTP email. Please try again.");
                    }
                } catch (Exception e) {
                    // Session might be invalidated or expired
                }
            }
        });
    }

    public static boolean sendEmail(String to, String subject, String messageText) {
        Properties fileProps = loadEmailProperties();

        // Environment variables have highest precedence
        String envEmail = System.getenv("SMTP_EMAIL");
        String envPassword = System.getenv("SMTP_PASSWORD");

        final String from = (envEmail != null && !envEmail.trim().isEmpty()) ? envEmail.trim()
                : (System.getProperty("smtp.email") != null ? System.getProperty("smtp.email")
                : fileProps.getProperty("smtp.email", "your_email@gmail.com"));

        final String password = (envPassword != null && !envPassword.trim().isEmpty()) ? envPassword.trim()
                : (System.getProperty("smtp.password") != null ? System.getProperty("smtp.password")
                : fileProps.getProperty("smtp.password", "your_app_password"));

        String smtpHost = fileProps.getProperty("smtp.host", "smtp.gmail.com");
        String smtpPort = fileProps.getProperty("smtp.port", "587");
        String smtpAuth = fileProps.getProperty("smtp.auth", "true");
        String startTls = fileProps.getProperty("smtp.starttls.enable", "true");

        Properties mailProps = new Properties();
        mailProps.put("mail.smtp.host", smtpHost);
        mailProps.put("mail.smtp.port", smtpPort);
        mailProps.put("mail.smtp.auth", smtpAuth);
        mailProps.put("mail.smtp.starttls.enable", startTls);

        try {
            Session session = Session.getInstance(mailProps, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(from, password);
                }
            });

            Message msg = new MimeMessage(session);
            msg.setFrom(new InternetAddress(from));
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            msg.setSubject(subject);
            msg.setText(messageText);

            Transport.send(msg);
            return true;
        } catch (MessagingException e) {
            // Note: Do NOT log sensitive credentials or OTP values (Requirement 11)
            System.err.println("Failed to send email to recipient: " + e.getMessage());
            return false;
        } catch (Exception e) {
            System.err.println("Unexpected error while sending email: " + e.getMessage());
            return false;
        }
    }
}
