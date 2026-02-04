<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title> User Registration </title>
    <link rel="stylesheet" href="headerfooter.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f9f9f9;
        }
        .container {
            max-width: 600px;
            margin: 50px auto;
            padding: 20px;
            background-color: white;
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
        input, textarea, select, button {
            margin-top: 5px;
            padding: 10px;
            font-size: 16px;
        }
        button {
            background-color: #d9534f;
            color: white;
            border: none;
            cursor: pointer;
            margin-top: 20px;
        }
        button:hover {
            background-color: #c9302c;
        }
        .radio-group {
            display: flex;
            gap: 10px;
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
<div id="header-container"></div>
    <div class="container">
        <h2>User  Registration </h2>
      <%
    String successMessage = (String) session.getAttribute("successMessage");
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
    }
%>



        
        <form action="UserRegisterServlet" method="POST">
            <label for="name">Name:</label>
            <input type="text" id="name" placeholder="Enter Name"  name="name" required>

            <label for="email">Email:</label>
            <input type="email" id="email" placeholder="Enter Email"  name="email" required>
            
            

            <label for="password">Password:</label>
            <input type="password" id="password" name="password"     placeholder="Enter your password"  required>
            

            <label for="phone">Phone Number:</label>
           <input type="tel" id="phone" name="phone"  pattern="[0-9]{10}"   placeholder="Enter phone number"  required>
            

            <label for="address">Address:</label>
            <textarea id="address" placeholder="Enter address"  name="address" rows="3" required></textarea>

            <label for="city">City:</label>
            <input type="text" id="city" placeholder="Enter city"  name="city" required>

            <label>Gender:</label>
            <div class="radio-group">
                <label><input type="radio" name="gender" value="Male" required> Male</label>
                <label><input type="radio" name="gender" value="Female" required> Female</label>
                <label><input type="radio" name="gender" value="Other" required> Other</label>
            </div>

            <label for="dob">Date of Birth:</label>
            <input type="date" id="dob" name="dob" required>

            <label for="bloodGroup">Blood Group:</label>
            <select id="blood_group" name="blood_group" required>
                <option value="A+">A+</option>
                <option value="A-">A-</option>
                <option value="B+">B+</option>
                <option value="B-">B-</option>
                <option value="O+">O+</option>
                <option value="O-">O-</option>
                <option value="AB+">AB+</option>
                <option value="AB-">AB-</option>
            </select>

            <button type="submit">Register</button>
            <button type="Reset">Reset</button>
        </form>
    </div>
     <div>
<div id="footer-container"></div>  <!-- Footer will be loaded here -->
</div>
    <script src="main.js"></script>
</body>
</html>
