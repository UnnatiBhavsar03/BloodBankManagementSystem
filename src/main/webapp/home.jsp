<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="headerfooter.css">

<style>
 body {
            margin: 0;
            padding: 0;
            background: url('homeimg.jpeg') no-repeat center center fixed;
            background-size: cover;
            font-family: Arial, sans-serif;
            color: #fff;
        }
        .overlay {
            background-color: rgba(0, 0, 0, 0.6);
            height: 500px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            text-align: center;
        }
        h1 {
            font-size: 48px;
            margin-bottom: 20px;
        }
        p {
            font-size: 20px;
            margin-bottom: 30px;
        }
        .btn {
            padding: 12px 24px;
            margin: 10px;
            font-size: 18px;
            color: #fff;
            background-color: #e74c3c;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
        }
        .btn:hover {
            background-color: #c0392b;
        }
        </style>
</head>
<body>
<div id="header-container"></div>



    <div class="overlay">
        <h1>🩸 Welcome to Life Line Blood Bank</h1>
        <p> Thank you for being a part of the life-saving mission. Together, we ensure that hope is always available when needed.</p>
       
    </div>

 <div>
<div id="footer-container"></div>  <!-- Footer will be loaded here -->
</div>
    <script src="main.js"></script>
</body>
</html>