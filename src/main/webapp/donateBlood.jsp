<%@ page import="java.sql.*, java.time.LocalDate, net.javaguide.login.database.DBUtil" %>


<%
// Retrieve email from session
String email = (String) session.getAttribute("email");
String name = "";
String bloodGroup = "";

try {
    Connection conn = DBUtil.getConnection();
    PreparedStatement ps = conn.prepareStatement("SELECT name, blood_group FROM user WHERE email = ?");
    ps.setString(1, email);
    ResultSet rs = ps.executeQuery();
    if (rs.next()) {
        name = rs.getString("name");
        bloodGroup = rs.getString("blood_group");
    }
    conn.close();
} catch (Exception e) {
    e.printStackTrace();
}
%>










<%

    // Retrieve the campId parameter from the request
    String campIdParam = request.getParameter("campId");
    String campDate = "";
    boolean isCampRegistration = false;

    if (campIdParam != null && !campIdParam.isEmpty()) {
        isCampRegistration = true;
        try {
            Connection conn = DBUtil.getConnection();

            // Retrieve the camp date based on campId
            PreparedStatement ps = conn.prepareStatement("SELECT c_date FROM blood_camp WHERE c_id = ?");
            ps.setInt(1, Integer.parseInt(campIdParam));
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                campDate = rs.getString("c_date");
            } else {
                campDate = "Camp not found";
                isCampRegistration = false;
            }
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            campDate = "Error retrieving camp date";
            isCampRegistration = false;
        }
    } else {
        // For direct donation, use the current date
        campDate = LocalDate.now().toString();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Donate Blood</title>
    <link rel="stylesheet" href="headerfooter.css">
</head>
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
<body>
<div id="donorheader-container"></div>
 <div class="container">
    <h2><%= isCampRegistration ? "Register for Blood Donation Camp" : " Donate Blood" %></h2>
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
    
       <%--  <% String message = (String) request.getAttribute("message"); %>
<% if (message != null) { %>
    <div style="color: green;"><%= message %></div>
<% } %> --%>
    <form action="DonateBloodServlet" method="post">
     <label>Name:</label>
        <input type="text" name="name" value="<%= name %>" readonly /><br/>

        <label>Blood Group:</label>
        <input type="text" name="bloodGroup" value="<%= bloodGroup %>" readonly /><br/>
        
        <% if (isCampRegistration) { %>
            <input type="hidden" name="campId" value="<%= campIdParam %>" />
            <label>Camp Date:</label>
            <input type="text" name="campDate" value="<%= campDate %>" readonly /><br/>
        <% } else { %>
             <label>Donation Date:</label>
        <input type="date" name="donationDate" required /><br/>
        <% } %>

        <label>Blood Units:</label>
        <input type="number" name="bloodUnits" min="1" required /><br/>

        <label>Age:</label>
        <input type="number" name="age" min="18" required /><br/>
        
        

        <button type="submit">Donate</button>
            <button type="Reset">Reset</button>
    </form>
     </div>
     <div>
<div id="footer-container"></div>  <!-- Footer will be loaded here -->
</div>
    <script src="main.js"></script>
</body>
</html>
