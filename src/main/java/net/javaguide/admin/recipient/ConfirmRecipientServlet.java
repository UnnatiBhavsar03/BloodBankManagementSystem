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

import net.javaguide.login.database.DBUtil;

/**
 * Servlet implementation class ConfirmRecipientServlet
 */
@WebServlet("/ConfirmRecipientServlet")
public class ConfirmRecipientServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ConfirmRecipientServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		
		
		
		
		

		        int recipientId = Integer.parseInt(request.getParameter("recipient_id"));
		        String bloodGroup = request.getParameter("blood_group");
		        int requiredUnits = Integer.parseInt(request.getParameter("required_units"));

		        try {
		            Connection con = DBUtil.getConnection();
		            con.setAutoCommit(false);  // start transaction

		            // Update stock table
		            PreparedStatement updateStock = con.prepareStatement(
		                "UPDATE stock SET units = units - ? WHERE blood_group = ? AND units >= ?");
		            updateStock.setInt(1, requiredUnits);
		            updateStock.setString(2, bloodGroup);
		            updateStock.setInt(3, requiredUnits);
		            int affectedRows = updateStock.executeUpdate();

		            if (affectedRows == 0) {
		                con.rollback();
		                response.getWriter().println("Insufficient stock for blood group: " + bloodGroup);
		                return;
		            }

		            // Delete recipient after successful stock update
		            PreparedStatement deleteRecipient = con.prepareStatement("DELETE FROM recipient WHERE r_id = ?");
		            deleteRecipient.setInt(1, recipientId);
		            deleteRecipient.executeUpdate();

		            con.commit();  // commit transaction
		            updateStock.close();
		            deleteRecipient.close();
		            con.close();

		            response.sendRedirect("recipientmanage.jsp");
		        } catch (Exception e) {
		            e.printStackTrace();
		            response.getWriter().println("Error: " + e.getMessage());
		        }
		    }
		}
