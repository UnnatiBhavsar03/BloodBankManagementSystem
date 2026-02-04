<%@ page import="java.sql.*" %>
<%
    int donorId = Integer.parseInt(request.getParameter("donor_id"));

    String dbURL = "jdbc:mysql://localhost:3306/BloodBank";
    String dbUser = "root";
    String dbPass = "Unnati@03";

    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection(dbURL, dbUser, dbPass);

        PreparedStatement ps = con.prepareStatement("DELETE FROM donor WHERE d_id = ?");
        ps.setInt(1, donorId);
        ps.executeUpdate();

        response.sendRedirect("donormanage.jsp");

    } catch(Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>
