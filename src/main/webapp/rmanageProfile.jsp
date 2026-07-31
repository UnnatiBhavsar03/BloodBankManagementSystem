<%@ page import="java.sql.*, net.javaguide.login.database.DBUtil" %>
<%@ page session="true" %>
<%
    // Retrieve user ID from session
    String email = (String) session.getAttribute("email");
    if (email == null) {
        response.sendRedirect("recipientlogin.jsp");
        return;
    }

    // Initialize variables
    String name = "";
    String phone = "";
    String address = "";
    String city = "";
    String gender = "";
    String dob = "";
    String bloodGroup = "";

    try {
        Connection conn = DBUtil.getConnection();
        PreparedStatement stmt = conn.prepareStatement("SELECT name, phone, address, city, gender, dob, blood_group FROM user WHERE email = ?");
        stmt.setString(1, email);
        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            name = rs.getString("name");
            phone = rs.getString("phone");
            address = rs.getString("address");
            city = rs.getString("city");
            gender = rs.getString("gender");
            dob = rs.getString("dob");
            bloodGroup = rs.getString("blood_group");
        }
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>





<!DOCTYPE html>
<html>
<head>
    <title> Manage Profile </title>
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
        <h2>Manage Profile </h2>
        <!-- Display success or error message -->
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
        
        <form action="RUpdateProfileServlet" method="POST">
            <label for="name">Name:</label>
            <input type="text" id="name" name="name" value="<%= name %>" required>

            
            <label for="phone">Phone Number:</label>
            <input type="text" id="phone"   name="phone"  value="<%= phone %>" required>

            <label for="address">Address:</label>
            <textarea id="address"   name="address" rows="3" required><%= address %></textarea>

            <label for="city">City:</label>
            <input type="text" id="city"   name="city" value="<%= city %>" required>

            <label>Gender:</label>
            <div class="radio-group">
                <label><input type="radio" name="gender" value="Male" <%= "Male".equalsIgnoreCase(gender) ? "checked" : "" %> required> Male</label>
                <label><input type="radio" name="gender" value="Female"  <%= "Female".equalsIgnoreCase(gender) ? "checked" : "" %> required> Female</label>
                <label><input type="radio" name="gender" value="Other" <%= "Other".equalsIgnoreCase(gender) ? "checked" : "" %> required> Other</label>
            </div>

            <label for="dob">Date of Birth:</label>
            <input type="date" id="dob" name="dob"  value="<%= dob %>" required>

            <label for="bloodGroup">Blood Group:</label>
            <select id="bloodGroup" name="bloodGroup" required>
                <option value="A+" <%= "A+".equalsIgnoreCase(bloodGroup) ? "selected" : "" %>>A+</option>
                <option value="A-" <%= "A-".equalsIgnoreCase(bloodGroup) ? "selected" : "" %>>A-</option>
                <option value="B+" <%= "B+".equalsIgnoreCase(bloodGroup) ? "selected" : "" %>>B+</option>
                <option value="B-" <%= "B-".equalsIgnoreCase(bloodGroup) ? "selected" : "" %>>B-</option>
                <option value="O+" <%= "O+".equalsIgnoreCase(bloodGroup) ? "selected" : "" %>>O+</option>
                <option value="O-" <%= "O-".equalsIgnoreCase(bloodGroup) ? "selected" : "" %>>O-</option>
                <option value="AB+" <%= "AB+".equalsIgnoreCase(bloodGroup) ? "selected" : "" %>>AB+</option>
                <option value="AB-" <%= "AB-".equalsIgnoreCase(bloodGroup) ? "selected" : "" %>>AB-</option>
            </select>

            <button type="submit">Update Profile</button>
            <button type="Reset">Reset</button>
          </form>
    </div>
     <div>
<div id="footer-container"></div>  <!-- Footer will be loaded here -->
</div>
    <script src="main.js"></script>
</body>
</html>
