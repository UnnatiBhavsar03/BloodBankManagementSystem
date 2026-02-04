<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Donor Login</title>
    <link rel="stylesheet" href="headerfooter.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: Arial, sans-serif;
        }
        body {
            display: flex;
           flex-direction: column;
            margin: 0;
            padding: 0;
           
            background: #f4f4f4;
        }
        .main-content {
            flex: 1; /* Allows content to take available space */
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .container {
            display: flex;
            
             margin: 50px auto;
            width: 60%;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            border-radius: 10px;
            overflow: hidden;
            background: white;
        }
        .login-section, .register-section {
            width: 50%;
            padding: 40px;
        }
        .login-section {
            background: #ffffff;
        }
        .register-section {
            background: #e74c3c;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            text-align: center;
        }
        h2 {
            margin-bottom: 20px;
            color: #333;
        }
        input {
            width: 100%;
            padding: 10px;
            margin: 10px 0;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        .btn {
            width: 100%;
            padding: 10px;
            background: #e74c3c;
            border: none;
            color: white;
            font-size: 16px;
            cursor: pointer;
            border-radius: 5px;
            margin-top: 10px;
        }
        .btn:hover {
            background: #c0392b;
        }
        .warning {
            color: red;
            font-size: 14px;
            display: none;
        }
        .register-btn {
            padding: 10px 20px;
            background: white;
            border: none;
            color: #e74c3c;
            font-size: 16px;
            cursor: pointer;
            border-radius: 5px;
            text-decoration: none;
        }
        .register-btn:hover {
            background: #ccc;
        }
        @media (max-width: 768px) {
            .container {
                flex-direction: column;
                width: 90%;
            }
            .login-section, .register-section {
                width: 100%;
            }
        }
    </style>
</head>
<body>
<div id="header-container"></div>
<div class="main-content">
    <div class="container">
        <!-- Login Section -->
        <div class="login-section">
            <h2>Recipient Login</h2>
            <form action="RLoginServlet" method="post" id="loginForm">
                <input type="text" name="email" placeholder="Username">
                <span class="warning" id="userWarning">Username is required!</span>

                <input type="password" name="password" placeholder="Password">
                <span class="warning" id="passWarning">Password is required!</span>

                <input type="submit" value="Login" />
            </form>
             <p style="color:red;">
        <%= request.getAttribute("errorMessage") != null ? request.getAttribute("errorMessage") : "" %>
    </p>
        </div>

        <!-- Register Section -->
        <div class="register-section">
            <h2>New Here?</h2>
            <p>Join us today and make a difference.</p>
            <a href="userregisteration.jsp" class="register-btn">Register</a>
        </div>
    </div>
 </div>
    
  
  
<div>
<div id="footer-container"></div>  <!-- Footer will be loaded here -->
</div>
    <script src="main.js"></script>
</body>
</html>
