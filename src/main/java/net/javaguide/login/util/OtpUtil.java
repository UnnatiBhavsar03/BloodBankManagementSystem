package net.javaguide.login.util;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import jakarta.servlet.http.HttpSession;

public class OtpUtil {

    private static final SecureRandom RANDOM = new SecureRandom();

    /**
     * Generates a secure 6-digit OTP string (000000 - 999999).
     */
    public static String generateOtp() {
        int number = RANDOM.nextInt(1000000);
        return String.format("%06d", number);
    }

    /**
     * Computes the SHA-256 hex string of the given OTP.
     */
    public static String hashOtp(String otp) {
        if (otp == null) {
            return null;
        }
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashBytes = md.digest(otp.getBytes(StandardCharsets.UTF_8));
            StringBuilder hexString = new StringBuilder();
            for (byte b : hashBytes) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) {
                    hexString.append('0');
                }
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("SHA-256 algorithm not available", e);
        }
    }

    /**
     * Securely compares input OTP with stored SHA-256 hash in constant time using MessageDigest.isEqual().
     */
    public static boolean verifyOtp(String inputOtp, String storedHash) {
        if (inputOtp == null || storedHash == null) {
            return false;
        }
        String inputHash = hashOtp(inputOtp.trim());
        byte[] inputHashBytes = inputHash.getBytes(StandardCharsets.UTF_8);
        byte[] storedHashBytes = storedHash.getBytes(StandardCharsets.UTF_8);

        return MessageDigest.isEqual(inputHashBytes, storedHashBytes);
    }

    /**
     * Clears all pending OTP session attributes as specified in Requirement 3 & 20.
     */
    public static void clearPendingOtpState(HttpSession session) {
        if (session != null) {
            session.removeAttribute("pending_email");
            session.removeAttribute("pending_role");
            session.removeAttribute("otp_hash");
            session.removeAttribute("otp_expiry");
            session.removeAttribute("otp_attempts");
            session.removeAttribute("otp_last_sent");
            session.removeAttribute("otp_mail_status");
            session.removeAttribute("otp_mail_error");
        }
    }
}
