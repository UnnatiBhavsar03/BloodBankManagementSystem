package net.javaguide.admin.recipient;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

/**
 * Servlet implementation class DeleteRecipientServlet
 */
@WebServlet("/DeleteRecipientServlet")
public class DeleteRecipientServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public DeleteRecipientServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		
		
		
		
		
		        int recipientId = Integer.parseInt(request.getParameter("recipient_id"));
		        
		        String dbURL = "jdbc:mysql://localhost:3306/BloodBank";
		        String dbUser = "root";
		        String dbPass = "Unnati@03";

		        try {
		            Class.forName("com.mysql.jdbc.Driver");
		            Connection con = DriverManager.getConnection(dbURL, dbUser, dbPass);
		            
		            PreparedStatement ps = con.prepareStatement("DELETE FROM recipient WHERE r_id = ?");
		            ps.setInt(1, recipientId);
		            ps.executeUpdate();

		            ps.close();
		            con.close();
		            
		            response.sendRedirect("recipientmanage.jsp");
		        } catch (Exception e) {
		            e.printStackTrace();
		            response.getWriter().println("Error: " + e.getMessage());
		        }
		    }
		}
