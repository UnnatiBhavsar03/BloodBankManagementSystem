<%@ page import="java.sql.*, java.time.LocalDate, net.javaguide.login.database.DBUtil" %>
<%
    // Retrieve filter parameters
    String filterDate = request.getParameter("campDate");
    String filterCity = request.getParameter("city");

    // Initialize variables
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    int serialNo = 1;
%>
<!DOCTYPE html>
<html>
<head>

    <title>Upcoming Blood Donation Camps</title>
     <link rel="stylesheet" href="headerfooter.css">
 <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f4f6f8;
            margin: 0;
            padding: 20px;
        }
        .container {
            max-width: 960px;
            margin: auto;
            background: #fff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        h2 {
            text-align: center;
            color: #2c3e50;
            margin-bottom: 30px;
        }
        form {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 15px;
            margin-bottom: 25px;
        }
        form input[type="date"],
        form input[type="text"] {
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            width: 200px;
        }
        form input[type="submit"] {
            padding: 10px 20px;
            background-color: #e74c3c;
            color: #fff;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        form input[type="submit"]:hover {
            background-color: #c0392b;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }
        th, td {
            padding: 12px 15px;
            text-align: center;
        }
        th {
            background-color: #e74c3c;
            color: #fff;
        }
        tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        tr:hover {
            background-color: #f1f1f1;
        }
        .register-btn {
            background-color: #3498db;
            color: #fff;
            padding: 8px 14px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        .register-btn:hover {
            background-color: #2980b9;
        }
        @media (max-width: 600px) {
            form {
                flex-direction: column;
                align-items: center;
            }
            form input[type="date"],
            form input[type="text"],
            form input[type="submit"] {
                width: 100%;
                max-width: 300px;
            }
        }
    </style>
    </head>
<body>
<div id="donorheader-container"></div>
 <div class="container">
    <h2>Upcoming Blood Donation Camps</h2>
    <form method="get" action="camps.jsp">
        <label for="campDate">Camp Date:</label>
        <input type="date" id="campDate" name="campDate" value="<%= filterDate != null ? filterDate : "" %>" />

        <label for="city">City:</label>
        <input type="text" id="city" name="city" value="<%= filterCity != null ? filterCity : "" %>" />

        <input type="submit" value="Search" />
    </form>
    <br/>

    <table border="1">
        <tr>
            <th>S.No</th>
            <th>Camp Date</th>
            <th>Time</th>
            <th>Address</th>
            <th>City</th>
            <th>Register</th>
        </tr>
        <%
            try {
                conn = DBUtil.getConnection();

                // Build SQL query with filters
                StringBuilder sql = new StringBuilder("SELECT c_id, c_date, c_time, c_address, c_city FROM blood_camp WHERE c_date > ?");
                if (filterDate != null && !filterDate.isEmpty()) {
                    sql.append(" AND c_date = ?");
                }
                if (filterCity != null && !filterCity.isEmpty()) {
                    sql.append(" AND c_city LIKE ?");
                }
                sql.append(" ORDER BY c_date ASC");

                ps = conn.prepareStatement(sql.toString());
                int paramIndex = 1;
                ps.setDate(paramIndex++, java.sql.Date.valueOf(LocalDate.now()));
                if (filterDate != null && !filterDate.isEmpty()) {
                    ps.setDate(paramIndex++, java.sql.Date.valueOf(filterDate));
                }
                if (filterCity != null && !filterCity.isEmpty()) {
                    ps.setString(paramIndex++, "%" + filterCity + "%");
                }

                rs = ps.executeQuery();
                while (rs.next()) {
                    int campId = rs.getInt("c_id");
                    Date campDate = rs.getDate("c_date");
                    Time campTime = rs.getTime("c_time");
                    String address = rs.getString("c_address");
                    String city = rs.getString("c_city");
        %>
        <tr>
            <td><%= serialNo++ %></td>
            <td><%= campDate %></td>
            <td><%= campTime %></td>
            <td><%= address %></td>
            <td><%= city %></td>
            <td>
                <form action="donateBlood.jsp" method="get">
                    <input type="hidden" name="campId" value="<%= campId %>" />
                    <input type="submit" value="Register" />
                </form>
            </td>
        </tr>
        <%
                }
            } catch (Exception e) {
                e.printStackTrace();
        %>
        <tr>
            <td colspan="6">An error occurred while retrieving camp data.</td>
        </tr>
        <%
            } finally {
                if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
                if (ps != null) try { ps.close(); } catch (SQLException ignore) {}
                if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
            }
        %>
    </table>
     </div>
     <div>
<div id="footer-container"></div>  <!-- Footer will be loaded here -->
</div>
    <script src="main.js"></script>
</body>
</html>
