<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String dbURL = "jdbc:mysql://localhost:3306/BloodBank";
    String dbUser = "root";
    String dbPass = "Unnati@03";

    String r_date = request.getParameter("r_date");
    String r_bloodgroup = request.getParameter("r_bloodgroup");
    String city = request.getParameter("city");
    String name = request.getParameter("name");

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.jdbc.Driver");
        con = DriverManager.getConnection(dbURL, dbUser, dbPass);

        String query = "SELECT r.*, u.name, u.email, u.phone, u.address, u.city, u.gender, u.dob FROM recipient r JOIN user u ON r.u_id = u.u_id WHERE 1=1";

        if (r_date != null && !r_date.isEmpty()) {
            query += " AND r.r_date = ?";
        }
        if (r_bloodgroup != null && !r_bloodgroup.isEmpty()) {
            query += " AND r.r_bloodgroup = ?";
        }
        if (city != null && !city.isEmpty()) {
            query += " AND u.city LIKE ?";
        }
        if (name != null && !name.isEmpty()) {
            query += " AND u.name LIKE ?";
        }

        ps = con.prepareStatement(query);

        int index = 1;
        if (r_date != null && !r_date.isEmpty()) ps.setString(index++, r_date);
        if (r_bloodgroup != null && !r_bloodgroup.isEmpty()) ps.setString(index++, r_bloodgroup);
        if (city != null && !city.isEmpty()) ps.setString(index++, "%" + city + "%");
        if (name != null && !name.isEmpty()) ps.setString(index++, "%" + name + "%");

        rs = ps.executeQuery();
%>

<html>
<head>
    <title>Recipient Management</title>
     <link rel="stylesheet" href="headerfooter.css">
    <style>
        body { font-family: 'Segoe UI', sans-serif; background-color: #f9f9f9; padding: 40px; }
        h2 { text-align: center; color: #c0392b; margin-bottom: 30px; }
        form { display: flex; flex-wrap: wrap; justify-content: center; gap: 20px; margin-bottom: 20px; }
        form label { font-weight: bold; color: #34495e; display: flex; flex-direction: column; }
        form input, form button {
            padding: 8px; border: 1px solid #ccc; border-radius: 5px;
            width: 180px;
        }
        form button {
            background-color: #e74c3c; color: white; font-weight: bold; cursor: pointer;
        }
        form button:hover { background-color: #c0392b; }

        table {
            width: 100%; border-collapse: collapse;
            background-color: white; border-radius: 8px;
            overflow: hidden; box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        th, td {
            padding: 10px; text-align: center; border-bottom: 1px solid #eee;
        }

        th {
            background-color: #e74c3c; color: white;
        }

        td form {
            display: inline-block; margin: 0 4px;
        }

        td form button {
            padding: 5px 10px; border: none; border-radius: 4px; font-size: 13px;
        }

        .delete-btn { background-color: #3498db; color: white; }
        .delete-btn:hover { background-color: #2980b9; }

        .confirm-btn { background-color: #2ecc71; color: white; }
        .confirm-btn:hover { background-color: #27ae60; }

        tr:nth-child(even) { background-color: #f2f2f2; }

        @media (max-width: 768px) {
            table { font-size: 12px; }
            form { flex-direction: column; align-items: center; }
            form input, form button { width: 100%; }
        }
    </style>
</head>
<body>
<div id="adminheader-container"></div>
<h2>Recipient Records</h2>

<form method="get">
    <label>Recipient Date:
        <input type="date" name="r_date" value="<%= r_date == null ? "" : r_date %>"/>
    </label>
    <label>City:
        <input type="text" name="city" value="<%= city == null ? "" : city %>"/>
    </label>
    <label>Blood Group:
        <input type="text" name="r_bloodgroup" value="<%= r_bloodgroup == null ? "" : r_bloodgroup %>"/>
    </label>
    <label>Name:
        <input type="text" name="name" value="<%= name == null ? "" : name %>"/>
    </label>
    <button type="submit">Search</button>
</form>

<table>
    <tr>
        <th>S.No</th>
        <th>Name</th>
        <th>Email</th>
        <th>Phone</th>
        <th>Address</th>
        <th>City</th>
        <th>Gender</th>
        <th>DOB</th>
        <th>R. Date</th>
        <th>Required Units</th>
        <th>Age</th>
        <th>Blood Group</th>
        <th>Doctor Desc</th>
        <th>Actions</th>
    </tr>
    <%
        int sno = 1;
        while(rs.next()) {
            int recipientId = rs.getInt("r_id");
            String pic = rs.getString("doctor_desc_pic");
            String bloodGroup = rs.getString("r_bloodgroup");
            int units = rs.getInt("required_units");
    %>
    <tr>
        <td><%= sno++ %></td>
        <td><%= rs.getString("name") %></td>
        <td><%= rs.getString("email") %></td>
        <td><%= rs.getString("phone") %></td>
        <td><%= rs.getString("address") %></td>
        <td><%= rs.getString("city") %></td>
        <td><%= rs.getString("gender") %></td>
        <td><%= rs.getDate("dob") %></td>
        <td><%= rs.getDate("r_date") %></td>
        <td><%= units %></td>
        <td><%= rs.getInt("r_age") %></td>
        <td><%= bloodGroup %></td>
        <td><a href="<%= pic %>" target="_blank">View</a></td>
        <td>
            <form action="DeleteRecipientServlet" method="post">
                <input type="hidden" name="recipient_id" value="<%= recipientId %>"/>
                <button class="delete-btn" type="submit">Delete</button>
            </form>
            <form action="ConfirmRecipientServlet" method="post">
                <input type="hidden" name="recipient_id" value="<%= recipientId %>"/>
                <input type="hidden" name="blood_group" value="<%= bloodGroup %>"/>
                <input type="hidden" name="required_units" value="<%= units %>"/>
                <button class="confirm-btn" type="submit">Confirmed</button>
            </form>
        </td>
    </tr>
    <% } %>
</table>
<div>
<div id="footer-container"></div>  <!-- Footer will be loaded here -->
</div>
    <script src="main.js"></script>
</body>
</html>

<%
    } catch(Exception e) {
        out.println("Error: " + e.getMessage());
    } finally {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (con != null) con.close();
    }
%>
