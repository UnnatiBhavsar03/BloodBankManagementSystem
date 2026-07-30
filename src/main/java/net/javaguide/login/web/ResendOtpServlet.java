package net.javaguide.login.web;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import net.javaguide.login.util.OtpUtil;
import net.javaguide.userregister.MailUtil;

import java.io.IOException;

@WebServlet("/ResendOtpServlet")
public class ResendOtpServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public ResendOtpServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect("home.jsp");
            return;
        }

        String pendingEmail = (String) session.getAttribute("pending_email");
        String pendingRole = (String) session.getAttribute("pending_role");
        Long lastSentObj = (Long) session.getAttribute("otp_last_sent");

        if (pendingEmail == null || pendingRole == null) {
            response.sendRedirect(getLoginJspForRole(pendingRole != null ? pendingRole : "admin"));
            return;
        }

        long now = System.currentTimeMillis();
        long lastSent = (lastSentObj != null) ? lastSentObj.longValue() : 0L;

        // 1. 60-second server-side cooldown check (Requirement 9)
        if ((now - lastSent) < 60000) {
            long remainingSecs = ((60000 - (now - lastSent)) / 1000) + 1;
            request.setAttribute("errorMessage", "Please wait " + remainingSecs + " seconds before requesting a new OTP.");
            RequestDispatcher rd = request.getRequestDispatcher("otp_verify.jsp");
            rd.forward(request, response);
            return;
        }

        // 2. Invalidate previous OTP: generate new OTP, reset expiry and attempt count (Requirement 10)
        String newOtp = OtpUtil.generateOtp();
        String newHash = OtpUtil.hashOtp(newOtp);
        long newExpiry = now + (5 * 60 * 1000); // 5 minutes

        session.setAttribute("otp_hash", newHash);
        session.setAttribute("otp_expiry", Long.valueOf(newExpiry));
        session.setAttribute("otp_attempts", Integer.valueOf(0));
        session.setAttribute("otp_last_sent", Long.valueOf(now));

        // 3. Send email asynchronously and notify user
        MailUtil.sendOtpEmailAsync(pendingEmail, newOtp, session);
        request.setAttribute("successMessage", "A new OTP has been requested and is being sent to your email.");
        RequestDispatcher rd = request.getRequestDispatcher("otp_verify.jsp");
        rd.forward(request, response);
    }

    private String getLoginJspForRole(String role) {
        if ("donor".equalsIgnoreCase(role)) {
            return "donorlogin.jsp";
        } else if ("recipient".equalsIgnoreCase(role)) {
            return "recipientlogin.jsp";
        } else {
            return "adminlogin.jsp";
        }
    }
}
