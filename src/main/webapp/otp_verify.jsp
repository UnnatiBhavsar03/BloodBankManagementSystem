<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String pendingEmail = (String) session.getAttribute("pending_email");
    String pendingRole = (String) session.getAttribute("pending_role");
    String mailStatus = (String) session.getAttribute("otp_mail_status");

    if (pendingEmail == null) {
        response.sendRedirect("home.jsp");
        return;
    }

    if ("FAILED".equalsIgnoreCase(mailStatus)) {
        String mailError = (String) session.getAttribute("otp_mail_error");
        net.javaguide.login.util.OtpUtil.clearPendingOtpState(session);
        request.setAttribute("errorMessage", mailError != null ? mailError : "Failed to send OTP email. Please try again.");
        String loginJsp = "adminlogin.jsp";
        if ("donor".equalsIgnoreCase(pendingRole)) loginJsp = "donorlogin.jsp";
        else if ("recipient".equalsIgnoreCase(pendingRole)) loginJsp = "recipientlogin.jsp";
        request.getRequestDispatcher(loginJsp).forward(request, response);
        return;
    }

    String maskedEmail = pendingEmail;
    int atIdx = pendingEmail.indexOf("@");
    if (atIdx > 2) {
        maskedEmail = pendingEmail.substring(0, 2) + "****" + pendingEmail.substring(atIdx);
    }

    String errorMessage = (String) request.getAttribute("errorMessage");
    String successMessage = (String) request.getAttribute("successMessage");
    
    Long expiryObj = (Long) session.getAttribute("otp_expiry");
    long expiryTime = (expiryObj != null) ? expiryObj.longValue() : 0L;

    Long lastSentObj = (Long) session.getAttribute("otp_last_sent");
    long lastSent = (lastSentObj != null) ? lastSentObj.longValue() : 0L;
    long now = System.currentTimeMillis();
    long secondsElapsed = (now - lastSent) / 1000;
    long initialCooldown = (secondsElapsed < 60) ? (60 - secondsElapsed) : 0;
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>2FA Verification - Blood Bank Management System</title>
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<style>
    * {
        box-sizing: border-box;
        margin: 0;
        padding: 0;
        font-family: 'Poppins', sans-serif;
    }
    body {
        background: linear-gradient(135deg, #e63946 0%, #1d3557 100%);
        min-height: 100vh;
        display: flex;
        align-items: center;
        justify-content: center;
        padding: 20px;
    }
    .otp-card {
        background: rgba(255, 255, 255, 0.96);
        border-radius: 16px;
        box-shadow: 0 15px 35px rgba(0, 0, 0, 0.25);
        width: 100%;
        max-width: 440px;
        padding: 40px 30px;
        text-align: center;
        backdrop-filter: blur(10px);
    }
    .otp-icon {
        width: 70px;
        height: 70px;
        background: #ffe6e6;
        color: #e63946;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        margin: 0 auto 20px;
        font-size: 32px;
    }
    .otp-card h2 {
        color: #1d3557;
        font-size: 24px;
        font-weight: 600;
        margin-bottom: 8px;
    }
    .otp-card p {
        color: #6c757d;
        font-size: 14px;
        margin-bottom: 24px;
        line-height: 1.5;
    }
    .email-badge {
        font-weight: 600;
        color: #e63946;
    }
    .alert {
        padding: 12px 16px;
        border-radius: 8px;
        font-size: 14px;
        margin-bottom: 20px;
        text-align: left;
    }
    .alert-danger {
        background-color: #f8d7da;
        color: #721c24;
        border: 1px solid #f5c6cb;
    }
    .alert-success {
        background-color: #d4edda;
        color: #155724;
        border: 1px solid #c3e6cb;
    }
    .otp-input-container {
        margin-bottom: 24px;
    }
    .otp-input {
        width: 100%;
        letter-spacing: 12px;
        font-size: 28px;
        text-align: center;
        padding: 12px;
        border: 2px solid #ced4da;
        border-radius: 10px;
        outline: none;
        transition: all 0.3s ease;
        font-weight: 600;
        color: #1d3557;
    }
    .otp-input:focus {
        border-color: #e63946;
        box-shadow: 0 0 0 4px rgba(230, 57, 70, 0.15);
    }
    .btn-verify {
        width: 100%;
        background: #e63946;
        color: white;
        border: none;
        padding: 14px;
        font-size: 16px;
        font-weight: 600;
        border-radius: 10px;
        cursor: pointer;
        transition: background 0.3s ease, transform 0.1s ease;
    }
    .btn-verify:hover {
        background: #d62828;
    }
    .btn-verify:active {
        transform: scale(0.98);
    }
    .resend-section {
        margin-top: 24px;
        font-size: 14px;
        color: #6c757d;
    }
    .btn-resend {
        background: none;
        border: none;
        color: #e63946;
        font-weight: 600;
        cursor: pointer;
        text-decoration: underline;
        font-size: 14px;
        padding: 0;
        margin-left: 4px;
    }
    .btn-resend:disabled {
        color: #adb5bd;
        cursor: not-allowed;
        text-decoration: none;
    }
    .timer-text {
        font-weight: 500;
        color: #495057;
    }
    .otp-expiry-badge {
        margin-bottom: 20px;
        font-size: 14px;
        color: #495057;
        background: #f8f9fa;
        padding: 10px 16px;
        border-radius: 8px;
        border: 1px solid #e9ecef;
        display: inline-block;
    }
</style>
</head>
<body>

<div class="otp-card">
    <div class="otp-icon">🔒</div>
    <h2>Two-Factor Verification</h2>
    <p>Enter the 6-digit OTP code sent to your email <br><span class="email-badge"><%= maskedEmail %></span></p>

    <div class="otp-expiry-badge">
        OTP Expires in: <span id="otpTimer" style="font-weight: 700; color: #e63946;">--:--</span>
    </div>

    <% if (errorMessage != null) { %>
        <div class="alert alert-danger"><%= errorMessage %></div>
    <% } %>

    <% if (successMessage != null) { %>
        <div class="alert alert-success"><%= successMessage %></div>
    <% } %>

    <form action="VerifyOtpServlet" method="post">
        <div class="otp-input-container">
            <input type="text" name="otp" class="otp-input" maxlength="6" pattern="[0-9]{6}" inputmode="numeric" placeholder="------" required autofocus autocomplete="one-time-code" />
        </div>
        <button type="submit" class="btn-verify">Verify OTP</button>
    </form>

    <div class="resend-section">
        Didn't receive the code? 
        <form action="ResendOtpServlet" method="post" style="display:inline;" id="resendForm">
            <button type="submit" id="resendBtn" class="btn-resend" disabled>Resend OTP</button>
        </form>
        <div id="cooldownContainer" style="margin-top: 8px;">
            Resend available in <span id="countdown" class="timer-text"><%= initialCooldown %></span>s
        </div>
    </div>
</div>

<script>
    const serverExpiryTime = <%= expiryTime %>;
    const lastSentTime = <%= lastSent %>;

    const resendBtn = document.getElementById("resendBtn");
    const countdownSpan = document.getElementById("countdown");
    const cooldownContainer = document.getElementById("cooldownContainer");
    const otpTimerSpan = document.getElementById("otpTimer");
    const otpInput = document.querySelector(".otp-input");
    const verifyBtn = document.querySelector(".btn-verify");

    function updateTimers() {
        const now = Date.now();

        // 1. Live OTP Expiry Countdown (5 minutes from server expiry timestamp)
        const remainingExpirySecs = Math.max(0, Math.floor((serverExpiryTime - now) / 1000));
        if (remainingExpirySecs <= 0) {
            otpTimerSpan.textContent = "Expired";
            otpTimerSpan.style.color = "#dc3545";
            if (otpInput) otpInput.disabled = true;
            if (verifyBtn) {
                verifyBtn.disabled = true;
                verifyBtn.style.background = "#6c757d";
            }
        } else {
            const minutes = Math.floor(remainingExpirySecs / 60);
            const seconds = remainingExpirySecs % 60;
            otpTimerSpan.textContent = 
                String(minutes).padStart(2, '0') + ":" + String(seconds).padStart(2, '0');
        }

        // 2. Resend Cooldown (60 seconds from last sent)
        const resendCooldownEnd = lastSentTime + 60000;
        const remainingResendSecs = Math.max(0, Math.floor((resendCooldownEnd - now) / 1000));

        if (remainingResendSecs <= 0) {
            if (resendBtn) resendBtn.disabled = false;
            if (cooldownContainer) cooldownContainer.style.display = "none";
        } else {
            if (resendBtn) resendBtn.disabled = true;
            if (cooldownContainer) cooldownContainer.style.display = "block";
            if (countdownSpan) countdownSpan.textContent = remainingResendSecs;
        }

        if (remainingExpirySecs > 0 || remainingResendSecs > 0) {
            setTimeout(updateTimers, 1000);
        }
    }

    updateTimers();
</script>

</body>
</html>
