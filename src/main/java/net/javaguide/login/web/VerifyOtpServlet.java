package net.javaguide.login.web;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import net.javaguide.login.util.OtpUtil;

import java.io.IOException;

@WebServlet("/VerifyOtpServlet")
public class VerifyOtpServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public VerifyOtpServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("otp_verify.jsp");
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
        String storedHash = (String) session.getAttribute("otp_hash");
        Long expiry = (Long) session.getAttribute("otp_expiry");
        Integer attemptsObj = (Integer) session.getAttribute("otp_attempts");
        String mailStatus = (String) session.getAttribute("otp_mail_status");

        if (pendingEmail == null || pendingRole == null || storedHash == null || expiry == null) {
            response.sendRedirect(getLoginJspForRole(pendingRole != null ? pendingRole : "admin"));
            return;
        }

        // Check if asynchronous email sending failed
        if ("FAILED".equalsIgnoreCase(mailStatus)) {
            String mailError = (String) session.getAttribute("otp_mail_error");
            OtpUtil.clearPendingOtpState(session);
            request.setAttribute("errorMessage", mailError != null ? mailError : "Failed to send OTP email. Please try again.");
            RequestDispatcher rd = request.getRequestDispatcher(getLoginJspForRole(pendingRole));
            rd.forward(request, response);
            return;
        }

        long now = System.currentTimeMillis();

        // 1. Expiry Check (5 minutes)
        if (now > expiry.longValue()) {
            OtpUtil.clearPendingOtpState(session);
            request.setAttribute("errorMessage", "OTP has expired. Please login again.");
            RequestDispatcher rd = request.getRequestDispatcher(getLoginJspForRole(pendingRole));
            rd.forward(request, response);
            return;
        }

        // 2. Increment attempts counter
        int attempts = (attemptsObj != null ? attemptsObj.intValue() : 0) + 1;
        session.setAttribute("otp_attempts", Integer.valueOf(attempts));

        // 3. Attempt Limit Check (Max 5 attempts)
        if (attempts > 5) {
            OtpUtil.clearPendingOtpState(session);
            request.setAttribute("errorMessage", "Maximum OTP attempts exceeded. Please login again.");
            RequestDispatcher rd = request.getRequestDispatcher(getLoginJspForRole(pendingRole));
            rd.forward(request, response);
            return;
        }

        // 4. Verify input OTP using constant-time comparison
        String inputOtp = request.getParameter("otp");
        boolean isValid = OtpUtil.verifyOtp(inputOtp, storedHash);

        if (isValid) {
            // Requirement 18, 19, 20: Successful verification
            OtpUtil.clearPendingOtpState(session);
            session.setAttribute("email", pendingEmail);
            response.sendRedirect(getDashboardForRole(pendingRole));
        } else {
            // Failed OTP attempt
            if (attempts >= 5) {
                OtpUtil.clearPendingOtpState(session);
                request.setAttribute("errorMessage", "Maximum OTP attempts exceeded. Please login again.");
                RequestDispatcher rd = request.getRequestDispatcher(getLoginJspForRole(pendingRole));
                rd.forward(request, response);
            } else {
                int remaining = 5 - attempts;
                request.setAttribute("errorMessage", "Invalid OTP. You have " + remaining + " attempt(s) remaining.");
                RequestDispatcher rd = request.getRequestDispatcher("otp_verify.jsp");
                rd.forward(request, response);
            }
        }
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

    private String getDashboardForRole(String role) {
        if ("donor".equalsIgnoreCase(role)) {
            return "donordesh.jsp";
        } else if ("recipient".equalsIgnoreCase(role)) {
            return "recipientdesh.jsp";
        } else {
            return "admindesh.jsp";
        }
    }
}
