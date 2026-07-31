<%@ page import="java.sql.*, net.javaguide.login.database.DBUtil" %>
<%
    String bloodGroup = request.getParameter("blood_group");
    int bloodUnits = Integer.parseInt(request.getParameter("blood_units"));
    int donorId = Integer.parseInt(request.getParameter("donor_id"));

    try {
        Connection con = DBUtil.getConnection();

        PreparedStatement ps1 = con.prepareStatement("UPDATE stock SET units = units + ? WHERE blood_group = ?");
        ps1.setInt(1, bloodUnits);
        ps1.setString(2, bloodGroup);
        ps1.executeUpdate();

        PreparedStatement ps2 = con.prepareStatement("DELETE FROM donor WHERE d_id = ?");
        ps2.setInt(1, donorId);
        ps2.executeUpdate();

        response.sendRedirect("donormanage.jsp");

    } catch(Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>
