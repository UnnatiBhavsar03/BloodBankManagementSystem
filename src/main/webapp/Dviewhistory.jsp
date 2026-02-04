<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String userEmail = (String) session.getAttribute("email");
    if (userEmail == null) {
        response.sendRedirect("donorlogin.jsp");
        return;
    }
%>
<html>
<head>
    <title>My Blood Donations</title>
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
<div id="donorheader-container"></div>
<h2>🩸 My Blood Donations</h2>

<!-- Filter Form -->
<form class="filter-form" method="get" action="Dviewhistory.jsp">
    <input type="date" name="d_date" placeholder="Donation Date">
  
    <button type="submit">Search</button>
</form>

<!-- Donor Table -->
<table>
    <tr>
        <th>S.No</th>
        <th>Donation Date</th>
        <th>Blood Units</th>
        <th>Age</th>
        <th>Blood Donated At</th>
    </tr>

<%
    Connection con = null;
    PreparedStatement pst = null;
    ResultSet rs = null;
    int sNo = 1;

    String d_date = request.getParameter("d_date");
   

    try {
        Class.forName("com.mysql.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/BloodBank", "root", "Unnati@03");

        String sql = "SELECT donor.* FROM donor " +
                "INNER JOIN user ON donor.u_id = user.u_id " +
                "WHERE user.email = ?";
        if (d_date != null && !d_date.isEmpty()) {
            sql += " AND d_date = ?";
        }
        

        pst = con.prepareStatement(sql);

        int i = 1;
        pst.setString(i++, userEmail);
        if (d_date != null && !d_date.isEmpty()) {
            pst.setString(i++, d_date);
        }
      
        rs = pst.executeQuery();

        while (rs.next()) {
%>
    <tr>
        <td><%= sNo++ %></td>
        <td><%= rs.getString("d_date") %></td>
        <td><%= rs.getInt("blood_units") %></td>
        <td><%= rs.getInt("d_age") %></td>
        <td>
            <%
                String d_at = rs.getString("d_at");
                if (d_at == null || d_at.trim().isEmpty()) {
                    out.print("Blood Bank");
                } else {
                    out.print(d_at);
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
