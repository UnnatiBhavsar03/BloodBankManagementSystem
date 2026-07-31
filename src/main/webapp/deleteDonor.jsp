<%@ page import="java.sql.*, net.javaguide.login.database.DBUtil" %>
<%
    int donorId = Integer.parseInt(request.getParameter("donor_id"));

    try {
        Connection con = DBUtil.getConnection();

        PreparedStatement ps = con.prepareStatement("DELETE FROM donor WHERE d_id = ?");
        ps.setInt(1, donorId);
        ps.executeUpdate();

        response.sendRedirect("donormanage.jsp");

    } catch(Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>
