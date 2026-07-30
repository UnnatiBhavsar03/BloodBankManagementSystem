package net.javaguide.login.web;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import net.javaguide.login.bean.LoginBean;
import net.javaguide.login.database.LoginDao;
import net.javaguide.login.util.OtpUtil;
import net.javaguide.userregister.MailUtil;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private LoginDao loginDao;

    public void init() {
        loginDao = new LoginDao();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");
        LoginBean loginBean = new LoginBean();
        loginBean.setUsername(email);
        loginBean.setPassword(password);

        try {
            if (loginDao.validate(loginBean)) {
                HttpSession session = request.getSession();
                
                // Generate 6-digit OTP and store SHA-256 hash in session
                String otp = OtpUtil.generateOtp();
                String otpHash = OtpUtil.hashOtp(otp);
                long now = System.currentTimeMillis();
                long expiry = now + (5 * 60 * 1000); // 5 minutes

                session.setAttribute("pending_email", email);
                session.setAttribute("pending_role", "admin");
                session.setAttribute("otp_hash", otpHash);
                session.setAttribute("otp_expiry", Long.valueOf(expiry));
                session.setAttribute("otp_attempts", Integer.valueOf(0));
                session.setAttribute("otp_last_sent", Long.valueOf(now));

                // Send OTP email asynchronously and redirect immediately
                MailUtil.sendOtpEmailAsync(email, otp, session);
                response.sendRedirect("otp_verify.jsp");
            } else {
                request.setAttribute("errorMessage", "Invalid username or password");
                RequestDispatcher rd = request.getRequestDispatcher("adminlogin.jsp");
                rd.forward(request, response);
            }
        } catch (ClassNotFoundException e) {
            throw new ServletException("Database validation failed", e);
        }
    }
}
