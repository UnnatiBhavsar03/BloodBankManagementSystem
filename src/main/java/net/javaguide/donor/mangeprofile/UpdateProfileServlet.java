package net.javaguide.donor.mangeprofile;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;

import java.sql.DriverManager;
import java.sql.PreparedStatement;



/**
 * Servlet implementation class UpdateProfileServlet
 */
@WebServlet("/UpdateProfileServlet")
public class UpdateProfileServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public UpdateProfileServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	
    
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
           
    	
    	
    	
    	
    	
    	
    	
    	
    	        // Retrieve form data
    	        String name = request.getParameter("name");
    	        String phone = request.getParameter("phone");
    	        String address = request.getParameter("address");
    	        String city = request.getParameter("city");
    	        String gender = request.getParameter("gender");
    	        String dob = request.getParameter("dob");
    	        String bloodGroup = request.getParameter("bloodGroup");

    	        // Retrieve user ID from session
    	        HttpSession session = request.getSession();
    	        String email = (String) session.getAttribute("email");

    	        // Database connection parameters
    	        String dbURL = "jdbc:mysql://localhost:3306/BloodBank";
    	        String dbUser = "root";
    	        String dbPass = "Unnati@03";

    	        try {
    	            Class.forName("com.mysql.cj.jdbc.Driver");
    	            Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
    	            PreparedStatement stmt = conn.prepareStatement(
    	                "UPDATE user SET name = ?, phone = ?, address = ?, city = ?, gender = ?, dob = ?, blood_group=? Where email= ?"
    	
    	
    	);
    	                    stmt.setString(1, name);
    	                    stmt.setString(2, phone);
    	                    stmt.setString(3,address);
    	                    stmt.setString(4, city);
    	                    stmt.setString(5, gender);
    	                    stmt.setString(6, dob);
    	                    stmt.setString(7, bloodGroup);
    	                    stmt.setString(8, email);
    	                    int rowsUpdated =stmt.executeUpdate();
    	                    conn.close();
    	                    HttpSession session1 = request.getSession();
    	                    if (rowsUpdated > 0) {
    	                        // Set success message
    	                        //request.setAttribute("successMessage", "Profile updated successfully.")
    	                    	 
    	                          session1.setAttribute("successMessage", "Profile updated succesfully.");
    	                          
    	                    } else {
    	                        // Set failure message
    	                    	session1.setAttribute("errorMessage", "Failed to update profile.");
    	                       // request.setAttribute("errorMessage", "Failed to update profile.");
    	                    }

    	                    // Forward back to the JSP page
    	                    RequestDispatcher dispatcher = request.getRequestDispatcher("manageProfile.jsp");
    	                    dispatcher.forward(request, response);

    	                } catch (Exception e) {
    	                    e.printStackTrace();
    	                    request.setAttribute("errorMessage", "An error occurred while updating the profile.");
    	                    RequestDispatcher dispatcher = request.getRequestDispatcher("manageProfile.jsp");
    	                    dispatcher.forward(request, response);
    	                }
    	            }
    	        }