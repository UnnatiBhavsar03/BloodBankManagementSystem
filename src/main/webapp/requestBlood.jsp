<%@ page import="java.sql.*, net.javaguide.login.database.DBUtil" %>
<%
   
//Retrieve email from session
String email = (String) session.getAttribute("email");
String name = "";
    if (email != null) {
        try {
            Connection con = DBUtil.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT name FROM user WHERE email = ?");
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                name = rs.getString("name");
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
 else {
    response.sendRedirect("recipientlogin.jsp");
}
%>
<html>
<head>
    <title>Request Blood</title>
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
<div id="recipientheader-container"></div>
<div class="container">
    <h2>Request Blood</h2>
     <%
    String Message = (String) session.getAttribute("message");
    if (Message != null) {
%>
    <div id="popupBox" class="popup-box">
        <div class="popup-content">
           
            <h2>Success</h2>
            <p><%= Message %></p>
             <button onclick="closePopup()" class="ok-button">OK</button>
        </div>
    </div>

    <script>
        function closePopup() {
            document.getElementById("popupBox").style.display = "none";
        }
    </script>
<%
        session.removeAttribute("message");
    }
%>

    <form action="RequestBloodServlet" method="post" enctype="multipart/form-data">
        <label>Name:</label>
        <input type="text" name="name" value="<%= name %>" readonly /><br/>

        <label>Blood Group:</label>
        <select name="blood_group" required>
            <option value="">Select</option>
            <option value="A+">A+</option>
            <option value="A-">A-</option>
            <option value="B+">B+</option>
            <option value="B-">B-</option>
            <option value="AB+">AB+</option>
            <option value="AB-">AB-</option>
            <option value="O+">O+</option>
            <option value="O-">O-</option>
        </select><br/>

        <label>Request Date:</label>
        <input type="date" name="request_date" required /><br/>

        <label>Blood Units:</label>
        <input type="number" name="bloodUnits" min="1" required /><br/>

        <label>Age:</label>
        <input type="number" name="age" min="18" required /><br/>

        <label>Doctor Description Pic:</label>
        <input type="file" name="doctor_description_pic" accept="image/*" required /><br/>

        <button type="submit">Request</button>
            <button type="Reset">Reset</button>
    </form>
     </div>
     <div>
<div id="footer-container"></div>  <!-- Footer will be loaded here -->
</div>
    <script src="main.js"></script>
</body>
</html>
