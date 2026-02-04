package net.javaguide.userregister;

import java.util.Properties;

import jakarta.mail.Authenticator;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.Message;
import jakarta.mail.internet.MimeMessage;
public class MailUtil {

	
	
	
	

	    public static boolean sendEmail(String to, String subject, String messageText) {
	        final String from = "your_email@gmail.com";      // Sender's email
	        final String password = "your_app_password";     // Use App Password for Gmail

	        Properties props = new Properties();
	        props.put("mail.smtp.host", "smtp.gmail.com");
	        props.put("mail.smtp.port", "587");
	        props.put("mail.smtp.auth", "true");
	        props.put("mail.smtp.starttls.enable", "true");

	        Session session = Session.getInstance(props, new Authenticator() {
	            protected PasswordAuthentication getPasswordAuthentication() {
	                return new PasswordAuthentication(from, password);
	            }
	        });

	        try {
	            Message msg = new MimeMessage(session);
	            msg.setFrom(new InternetAddress(from));
	            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
	            msg.setSubject(subject);
	            msg.setText(messageText);

	            Transport.send(msg);
	            return true;
	        } catch (MessagingException e) {
	            e.printStackTrace();
	            return false;
	        }
	    }
	}
	
	
	
	
	

