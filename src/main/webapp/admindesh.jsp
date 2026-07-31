<%@ page import="java.sql.*, java.util.*, net.javaguide.login.database.DBUtil" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Admin Dashboard - Blood Stock</title>
    <link rel="stylesheet" href="headerfooter.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f5f5f5;
        }
        .dashboard {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            padding: 40px;
            justify-content: center;
        }
        .card {
            background: #fff;
            padding: 20px 30px;
            border-radius: 12px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            width: 180px;
            text-align: center;
            transition: 0.3s;
        }
        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 6px 14px rgba(0,0,0,0.15);
        }
        .blood-group {
            font-size: 24px;
            font-weight: bold;
            color: #d50000;
        }
        .units {
            font-size: 20px;
            margin-top: 10px;
            color: #333;
        }
    </style>
</head>
<body>
<div id="adminheader-container"></div>

<h2 style="text-align:center;">🩸 Blood Stock</h2>

<div class="dashboard">
    <%
        Connection con = null;
        Statement st = null;
        ResultSet rs = null;
        try {
            con = DBUtil.getConnection();
            st = con.createStatement();
            rs = st.executeQuery("SELECT blood_group, units FROM stock");

            while (rs.next()) {
                String bg = rs.getString("blood_group");
                int units = rs.getInt("units");
    %>
        <div class="card">
            <div class="blood-group"><%= bg %></div>
            <div class="units"><%= units %> units</div>
        </div>
    <%
            }
        } catch (Exception e) {
            out.println("Error: " + e.getMessage());
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) {}
            if (st != null) try { st.close(); } catch (SQLException e) {}
            if (con != null) try { con.close(); } catch (SQLException e) {}
        }
    %>
</div>
<div>
<div id="footer-container"></div>  <!-- Footer will be loaded here -->
</div>
    <script src="main.js"></script>
</body>
</html>
