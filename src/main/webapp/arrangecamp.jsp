<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Arrange Camp - Blood Bank</title>
     <link rel="stylesheet" href="headerfooter.css">
    <style>
   
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f8f9fa;
        }
        .container {
            width: 50%;
            margin: 50px auto;
            background: #ffffff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        h2 {
            text-align: center;
            color: #d9534f;
        }
        form {
            display: flex;
            flex-direction: column;
        }
        label {
            margin-top: 10px;
            font-weight: bold;
        }
        input, textarea, button {
            margin-top: 5px;
            padding: 10px;
            font-size: 16px;
        }
        button {
            background-color: #d9534f;
            color: white;
            border: none;
            cursor: pointer;
        }
        button:hover {
            background-color: #c9302c;
        }
        .popup-box {
        position: fixed;
        top: 0; left: 0;
        width: 100%;
        height: 100%;
        background: rgba(0,0,0,0.5); /* Dim background */
        display: flex;
        justify-content: center;
        align-items: center;
        z-index: 1000;
    }
    .popup-content {
        background: #fff;
        padding: 30px;
        border-radius: 8px;
        text-align: center;
        position: relative;
        box-shadow: 0px 0px 15px rgba(0,0,0,0.3);
        max-width: 400px;
        width: 90%;
    }
    .popup-content h2 {
        margin-top: 0;
        color: #28a745;
    }
    .popup-content p {
        font-size: 16px;
        color: #333;
    }
     .ok-button {
        background-color: #28a745;
        color: white;
        border: none;
        padding: 10px 20px;
        font-size: 16px;
        border-radius: 5px;
        cursor: pointer;
        margin-top: 10px;
    }
    .ok-button:hover {
        background-color: #218838;
    }

        
    </style>
</head>
<body>
<div id="adminheader-container"></div>
    <div class="container">
        <h2>Arrange Blood Donation Camp</h2>
         <%
    String successMessage = (String) session.getAttribute("successMessage");
         String errorMessage = (String) request.getAttribute("errorMessage");
    if (successMessage != null) {
%>
    <div id="popupBox" class="popup-box">
        <div class="popup-content">
           
            <h2>Success</h2>
            <p><%= successMessage %></p>
             <button onclick="closePopup()" class="ok-button">OK</button>
        </div>
    </div>

    <script>
        function closePopup() {
            document.getElementById("popupBox").style.display = "none";
        }
    </script>
<%
        session.removeAttribute("successMessage");
    } else if (errorMessage != null) {
%>
   <div id="popupBox" class="popup-box">
        <div class="popup-content">
           
            <h2>Error</h2>
            <p><%= errorMessage %></p>
             <button onclick="closePopup()" class="ok-button">OK</button>
        </div>
    </div>

    <script>
        function closePopup() {
            document.getElementById("popupBox").style.display = "none";
        }
    </script>
<%
        session.removeAttribute("errorMessage");
    } 
%>
        <form action="<%=request.getContextPath()%>/ArrangeCampServlet" method="POST">


           <label for="Camp address"> camp Address:</label>
            <input type="text" id="c_address" name="c_address" required>


            <label for="Camp city"> camp city:</label>
            <input type="text" id="c_city" name="c_city" required>

            
            <label for="date">Date:</label>
            <input type="date" id="c_date" name="c_date" required>

            <label for="time">Time:</label>
            <input type="time" id="c_time" name="c_time" required>


            

            <button type="submit">Schedule Camp</button>
        </form>
    </div>
    <div>
<div id="footer-container"></div>  <!-- Footer will be loaded here -->
</div>
    <script src="main.js"></script>
</body>
</html>
