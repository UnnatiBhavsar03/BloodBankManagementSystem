<%@ page import="java.sql.*, java.util.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
    // Database connection
    String dbURL = "jdbc:mysql://localhost:3306/BloodBank";
    String dbUser = "root";
    String dbPass = "Unnati@03";

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    // Filtering inputs
    String d_date = request.getParameter("d_date");
    String city = request.getParameter("city");
    String blood_group = request.getParameter("blood_group");
    String name = request.getParameter("name");

    try {
        Class.forName("com.mysql.jdbc.Driver");
        con = DriverManager.getConnection(dbURL, dbUser, dbPass);

        String query = "SELECT donor.*, user.name, user.email, user.phone, user.address, user.city, user.gender, user.dob, user.blood_group " +
                       "FROM donor JOIN user ON donor.u_id = user.u_id WHERE 1=1 ";

        if (d_date != null && !d_date.isEmpty()) {
            query += " AND donor.d_date = ?";
        }
        if (city != null && !city.isEmpty()) {
            query += " AND user.city = ?";
        }
        if (blood_group != null && !blood_group.isEmpty()) {
            query += " AND user.blood_group = ?";
        }
        if (name != null && !name.isEmpty()) {
            query += " AND user.name LIKE ?";
        }

        ps = con.prepareStatement(query);

        int i = 1;
        if (d_date != null && !d_date.isEmpty()) ps.setString(i++, d_date);
        if (city != null && !city.isEmpty()) ps.setString(i++, city);
        if (blood_group != null && !blood_group.isEmpty()) ps.setString(i++, blood_group);
        if (name != null && !name.isEmpty()) ps.setString(i++, "%" + name + "%");

        rs = ps.executeQuery();
%>

<html>
<head>
    <title>Donor Management</title>
    <link rel="stylesheet" href="headerfooter.css">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 40px;
            background-color: #f4f6f9;
        }

        h2 {
            color: #c0392b;
            text-align: center;
            margin-bottom: 30px;
        }

        form {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 20px;
            margin-bottom: 20px;
        }

        form label {
            display: flex;
            flex-direction: column;
            font-weight: bold;
            color: #2c3e50;
        }

        form input[type="text"],
        form input[type="date"],
        form button {
            padding: 8px;
            border-radius: 6px;
            border: 1px solid #ccc;
            width: 180px;
        }

        form button {
            background-color: #e74c3c;
            color: white;
            font-weight: bold;
            cursor: pointer;
            transition: background-color 0.2s;
        }

        form button:hover {
            background-color: #c0392b;
        }

        table {
            border-collapse: collapse;
            width: 100%;
            background-color: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }

        th, td {
            padding: 12px;
            text-align: center;
            border-bottom: 1px solid #ecf0f1;
        }

        th {
            background-color: #e74c3c;
            color: white;
            font-weight: bold;
        }

        td form {
            display: inline-block;
            margin: 0 5px;
        }

        td form button {
            padding: 5px 10px;
            font-size: 14px;
            border: none;
            border-radius: 4px;
            color: white;
        }

        td form button[type="submit"]:first-child {
            background-color: #3498db;
        }

        td form button[type="submit"]:first-child:hover {
            background-color: #2980b9;
        }

        td form button[type="submit"]:last-child {
            background-color: #27ae60;
        }

        td form button[type="submit"]:last-child:hover {
            background-color: #1e8449;
        }

        tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        @media (max-width: 768px) {
            form {
                flex-direction: column;
                align-items: center;
            }

            table {
                font-size: 12px;
            }

            form input[type="text"],
            form input[type="date"],
            form button {
                width: 100%;
            }
        }
    </style>
</head>

<body>
<div id="adminheader-container"></div>
    <h2>Donor Management</h2>

    <form method="get">
        <label>Date: <input type="date" name="d_date" value="<%= d_date == null ? "" : d_date %>"/></label>
        <label>City: <input type="text" name="city" value="<%= city == null ? "" : city %>"/></label>
        <label>Blood Group: <input type="text" name="blood_group" value="<%= blood_group == null ? "" : blood_group %>"/></label>
        <label>Name: <input type="text" name="name" value="<%= name == null ? "" : name %>"/></label>
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
            <th>Age</th>
            <th>DOB</th>
            <th>Blood Group</th>
            <th>Date</th>
            <th>Blood Units</th>
            
            <th>Donated At</th>
            
            <th>Actions</th>
        </tr>
        <%
            int serial = 1;
            while (rs.next()) {
        %>
        <tr>
            <td><%= serial++ %></td>
              <td><%= rs.getString("name") %></td>
            <td><%= rs.getString("email") %></td>
            <td><%= rs.getString("phone") %></td>
            <td><%= rs.getString("address") %></td>
            <td><%= rs.getString("city") %></td>
            <td><%= rs.getString("gender") %></td>
             <td><%= rs.getInt("d_age") %></td>
            <td><%= rs.getString("dob") %></td>
              <td><%= rs.getString("blood_group") %></td>
            <td><%= rs.getString("d_date") %></td>
            <td><%= rs.getInt("blood_units") %></td>
           
            <td><%= rs.getString("d_at") == null ? "Blood Bank" : rs.getString("d_at") %></td>
          
          
            <td>
                <form action="deleteDonor.jsp" method="post">
                    <input type="hidden" name="donor_id" value="<%= rs.getInt("d_id") %>"/>
                    <button type="submit">Delete</button>
                </form>
                <form action="donatedUpdate.jsp" method="post">
                    <input type="hidden" name="blood_group" value="<%= rs.getString("blood_group") %>"/>
                    <input type="hidden" name="blood_units" value="<%= rs.getInt("blood_units") %>"/>
                    <input type="hidden" name="donor_id" value="<%= rs.getInt("d_id") %>"/>
                    <button type="submit">Donated</button>
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
