<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String userEmail = (String) session.getAttribute("email");
    if (userEmail == null) {
        response.sendRedirect("recipientlogin.jsp");
        return;
    }
%>
<html>
<head>
    <title>My Blood Requests</title>
   <link rel="stylesheet" href="headerfooter.css">
    <style>
         body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #fff0f0;
            padding: 30px;
        }
        .filter-form {
            margin-bottom: 30px;
            background: #ffdddd;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(255, 0, 0, 0.3);
        }
        .filter-form input, .filter-form select, .filter-form button {
            padding: 10px;
            margin: 8px 5px;
            font-size: 16px;
            border: 1px solid #ff4d4d;
            border-radius: 5px;
        }
        .filter-form button {
            background-color: #ff3333;
            color: #fff;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        .filter-form button:hover {
            background-color: #e60000;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            background: #fff;
            box-shadow: 0 0 15px rgba(255, 0, 0, 0.2);
            border-radius: 8px;
            overflow: hidden;
        }
        th, td {
            padding: 14px 18px;
            border-bottom: 1px solid #f99;
            text-align: center;
        }
        th {
            background: #cc0000;
            color: #fff;
            font-size: 18px;
        }
        tr:hover {
            background: #ffe5e5;
        }
    </style>
</head>
<body>
<div id="recipientheader-container"></div>
<h2>🩸 My Blood Requests</h2>

<!-- Filter Form -->
<form class="filter-form" method="get" action="Rviewhistory.jsp">
    <input type="date" name="r_date" placeholder="Request Date">
    <select name="r_bloodgroup">
        <option value="">Select Blood Group</option>
        <option value="A+">A+</option>
        <option value="A-">A-</option>
        <option value="B+">B+</option>
        <option value="B-">B-</option>
        <option value="O+">O+</option>
        <option value="O-">O-</option>
        <option value="AB+">AB+</option>
        <option value="AB-">AB-</option>
    </select>
    <button type="submit">Search</button>
</form>

<!-- Recipient Table -->
<table>
    <tr>
        <th>S.No</th>
        <th>Request Date</th>
        <th>Required Units</th>
        <th>Age</th>
        <th>Blood Group</th>
        <th>Doctor Description (Pic)</th>
    </tr>

<%
    Connection con = null;
    PreparedStatement pst = null;
    ResultSet rs = null;
    int sNo = 1;

    String r_date = request.getParameter("r_date");
    String r_bloodgroup = request.getParameter("r_bloodgroup");

    try {
        Class.forName("com.mysql.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/BloodBank", "root", "Unnati@03");

        String sql = 
               "SELECT r.* FROM recipient r " +
                        "INNER JOIN user u ON r.u_id = u.u_id " +
                        "WHERE u.email = ?";
        if (r_date != null && !r_date.isEmpty()) {
            sql += " AND r_date = ?";
        }
        if (r_bloodgroup != null && !r_bloodgroup.isEmpty()) {
            sql += " AND r_bloodgroup = ?";
        }

        pst = con.prepareStatement(sql);

        int i = 1;
        pst.setString(i++, userEmail);
        if (r_date != null && !r_date.isEmpty()) {
            pst.setString(i++, r_date);
        }
        if (r_bloodgroup != null && !r_bloodgroup.isEmpty()) {
            pst.setString(i++, r_bloodgroup);
        }

        rs = pst.executeQuery();

        while (rs.next()) {
%>
    <tr>
        <td><%= sNo++ %></td>
        <td><%= rs.getString("r_date") %></td>
        <td><%= rs.getInt("required_units") %></td>
        <td><%= rs.getInt("r_age") %></td>
        <td><%= rs.getString("r_bloodgroup") %></td>
        <td>
            <%
                String pic = rs.getString("doctor_desc_pic");
                if (pic != null && !pic.isEmpty()) {
            %>
                <a href="<%= pic %>" target="_blank">View</a>
            <%
                } else {
                    out.print("No File");
                }
            %>
        </td>
    </tr>
<%
        }
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) {}
        if (pst != null) try { pst.close(); } catch (SQLException e) {}
        if (con != null) try { con.close(); } catch (SQLException e) {}
    }
%>
</table>
<div>
<div id="footer-container"></div>  <!-- Footer will be loaded here -->
</div>
    <script src="main.js"></script>
</body>
</html>
