<%@ page import="java.sql.*, java.util.*, net.javaguide.login.database.DBUtil" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String blood_group = request.getParameter("blood_group");
    String units = request.getParameter("units");

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        con = DBUtil.getConnection();

        String query = "SELECT * FROM stock WHERE 1=1";

        if (blood_group != null && !blood_group.isEmpty()) {
            query += " AND blood_group = ?";
        }
       

        ps = con.prepareStatement(query);
        int index = 1;
        if (blood_group != null && !blood_group.isEmpty()) {
            ps.setString(index++, blood_group);
        }
     

        rs = ps.executeQuery();
%>

<html>
<head>
    <title>Stock Management</title>
    <link rel="stylesheet" href="headerfooter.css">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 40px;
            background-color: #f8f9fa;
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
            form button {
                width: 100%;
            }
        }
    </style>
</head>
<body>
<div id="adminheader-container"></div>
<h2>Blood Stock Overview</h2>

<form method="get">
    <label>Blood Group:
        <input type="text" name="blood_group" value="<%= blood_group == null ? "" : blood_group %>" placeholder="A+, O-, etc." />
    </label>
    
    <button type="submit">Search</button>
</form>

<table>
    <tr>
        <th>S.No</th>
        <th>Blood Group</th>
        <th>Units</th>
    </tr>
    <%
        int serial = 1;
        while (rs.next()) {
    %>
    <tr>
        <td><%= serial++ %></td>
        <td><%= rs.getString("blood_group") %></td>
        <td><%= rs.getInt("units") %></td>
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
