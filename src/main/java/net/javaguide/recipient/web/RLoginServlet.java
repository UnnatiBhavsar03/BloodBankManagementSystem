package net.javaguide.recipient.web;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import net.javaguide.login.database.DBUtil;
import net.javaguide.login.util.OtpUtil;
import net.javaguide.userregister.MailUtil;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/RLoginServlet")
public class RLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
       
    public RLoginServlet() {
        super();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        try {
            try (Connection connection = DBUtil.getConnection()) {
                String sql = "SELECT * FROM user WHERE email = ? AND password = ?";
                PreparedStatement statement = connection.prepareStatement(sql);
                statement.setString(1, email);
                statement.setString(2, password);
                
                ResultSet result = statement.executeQuery();
                
                if (result.next()) {
                    // Successful primary authentication - set pending OTP session state
                    HttpSession session = request.getSession();
                    
                    String otp = OtpUtil.generateOtp();
                    String otpHash = OtpUtil.hashOtp(otp);
                    long now = System.currentTimeMillis();
                    long expiry = now + (5 * 60 * 1000); // 5 minutes

                    session.setAttribute("pending_email", email);
                    session.setAttribute("pending_role", "recipient");
                    session.setAttribute("otp_hash", otpHash);
                    session.setAttribute("otp_expiry", Long.valueOf(expiry));
                    session.setAttribute("otp_attempts", Integer.valueOf(0));
                    session.setAttribute("otp_last_sent", Long.valueOf(now));

                    // Send OTP email asynchronously and redirect immediately
                    MailUtil.sendOtpEmailAsync(email, otp, session);
                    response.sendRedirect("otp_verify.jsp");
                } else {
                    // Failed primary login
                    request.setAttribute("errorMessage", "Invalid username or password");
                    RequestDispatcher dispatcher = request.getRequestDispatcher("recipientlogin.jsp");
                    dispatcher.forward(request, response);
                }
            }
        } catch (Exception e) {
            throw new ServletException("Login failed", e);
        }
    }
}
