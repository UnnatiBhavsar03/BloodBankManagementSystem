package net.javaguide.donor.donateblood;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

/**
 * Servlet implementation class DonateBloodServlet
 */
@WebServlet("/DonateBloodServlet")
public class DonateBloodServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    
    public DonateBloodServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		
		
		
		
		        // Retrieve form data
		        //String donationDate = request.getParameter("donationDate");
		       // int bloodUnits = Integer.parseInt(request.getParameter("bloodUnits"));
		        //int age = Integer.parseInt(request.getParameter("age"));

		        // Retrieve email from session
		       // HttpSession session = request.getSession();
		       // String email = (String) session.getAttribute("email");

		        // Database connection parameters
		       // String dbURL = "jdbc:mysql://localhost:3306/BloodBank";
		       // String dbUser = "root";
		        //String dbPass = "Unnati@03";

		        //try {
		          //  Class.forName("com.mysql.cj.jdbc.Driver");
		            //Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

		            // Retrieve user ID using email
		           // PreparedStatement psUser = conn.prepareStatement("SELECT u_id FROM user WHERE email = ?");
		            //psUser.setString(1, email);
		         //   ResultSet rsUser = psUser.executeQuery();

		           // if (rsUser.next()) {
		             //   int userId = rsUser.getInt("u_id");

		                // Insert donation record
		               //PreparedStatement psDonor = conn.prepareStatement(
		                 //   "INSERT INTO donor (u_id, d_date, blood_units, d_age) VALUES (?, ?, ?, ?)"
		               // );
		                //psDonor.setInt(1, userId);
		                //psDonor.setDate(2, Date.valueOf(donationDate));
		             //   psDonor.setInt(3, bloodUnits);
		               // psDonor.setInt(4, age);
		             //   psDonor.executeUpdate();

		                // Set success message
		          //      request.setAttribute("message", "Donation recorded successfully!");

		                // Forward back to the JSP page
		            //    RequestDispatcher dispatcher = request.getRequestDispatcher("donateBlood.jsp");
		              //  dispatcher.forward(request, response);
		           // } else {
		                // User not found
		             //   request.setAttribute("message", "User not found.");
		               // RequestDispatcher dispatcher = request.getRequestDispatcher("donateBlood.jsp");
		           //     dispatcher.forward(request, response);
		          //  }

		        //    conn.close();
		       // } catch (Exception e) {
		         //   e.printStackTrace();
		            // Set error message
		           // request.setAttribute("message", "An error occurred while recording the donation.");
		           // RequestDispatcher dispatcher = request.getRequestDispatcher("donateBlood.jsp");
		          //  dispatcher.forward(request, response);
		       // }
		   // }
	//	}

		
		
		
		
		
		
		
		
		
		
		        // Retrieve form data
		 String donationDate = request.getParameter("donationDate");
		        String campIdParam = request.getParameter("campId");
		        int bloodUnits = Integer.parseInt(request.getParameter("bloodUnits"));
		        int age = Integer.parseInt(request.getParameter("age"));

		        // Retrieve email from session
		        HttpSession session = request.getSession();
		        String email = (String) session.getAttribute("email");

		        // Database connection parameters
		        String dbURL = "jdbc:mysql://localhost:3306/BloodBank";
		        String dbUser = "root";
		        String dbPass = "Unnati@03";

		        try {
		            Class.forName("com.mysql.cj.jdbc.Driver");
		            Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

		            // Retrieve user ID using email
		            PreparedStatement psUser = conn.prepareStatement("SELECT u_id FROM user WHERE email = ?");
		            psUser.setString(1, email);
		            ResultSet rsUser = psUser.executeQuery();
		            int userId = -1;
		            if (rsUser.next()) {
		                userId = rsUser.getInt("u_id");
		            }

		            if (userId != -1) {
		                PreparedStatement psInsert;
		                if (campIdParam != null && !campIdParam.isEmpty()) {
		                    // Scenario 1: Camp Registration
		                    int campId = Integer.parseInt(campIdParam);

		                    // Retrieve camp date
		                    PreparedStatement psCamp = conn.prepareStatement("SELECT c_date FROM blood_camp WHERE c_id = ?");
		                    psCamp.setInt(1, campId);
		                    ResultSet rsCamp = psCamp.executeQuery();
		                    Date campDate = null;
		                    if (rsCamp.next()) {
		                        campDate = rsCamp.getDate("c_date");
		                    }

		                    if (campDate != null) {
		                        psInsert = conn.prepareStatement(
		                            "INSERT INTO donor (u_id, d_at, d_date, blood_units, d_age) VALUES (?, ?, ?, ?, ?)"
		                        );
		                        psInsert.setInt(1, userId);
		                        psInsert.setInt(2, campId);
		                        psInsert.setDate(3, campDate);
		                        psInsert.setInt(4, bloodUnits);
		                        psInsert.setInt(5, age);
		                    } else {
		                        response.getWriter().println("Camp not found.");
		                        conn.close();
		                        return;
		                    }
		                } else {
		                    // Scenario 2: Direct Donation
		                   
		                    psInsert = conn.prepareStatement(
		                        "INSERT INTO donor (u_id, d_at, donation_date, blood_units, age) VALUES (?, NULL, ?, ?, ?)"
		                    );
		                    psInsert.setInt(1, userId);
		                    psInsert.setDate(2, Date.valueOf(donationDate));
		                    psInsert.setInt(3, bloodUnits);
		                    psInsert.setInt(4, age);
		                }

		                int rowsInserted = psInsert.executeUpdate();

		                if (rowsInserted > 0) {
		                    //response.getWriter().println("Donation registered successfully!");
		                	
		                	
		                	 HttpSession session1 = request.getSession();
		                     session1.setAttribute("message", "Donation registered successfully!");
		                     
		                	
		                    //request.setAttribute("message", "Donation registered successfully!");
		                    RequestDispatcher dispatcher = request.getRequestDispatcher("donateBlood.jsp");
			                dispatcher.forward(request, response);
		                } else {
		                   // response.getWriter().println("Failed to register donation.");
		                	 //request.setAttribute("message", "Failed to register donation.");
		                	 HttpSession session1 = request.getSession();
		                     session1.setAttribute("message", "Failed to register donation.");
		                    RequestDispatcher dispatcher = request.getRequestDispatcher("donateBlood.jsp");
			                dispatcher.forward(request, response);
		                }
		            } else {
		                //response.getWriter().println("User not found.");
		               // request.setAttribute("message", "User not found.");
		            	 HttpSession session1 = request.getSession();
	                     session1.setAttribute("message", "An error occurred.");
		                RequestDispatcher dispatcher = request.getRequestDispatcher("donateBlood.jsp");
		                dispatcher.forward(request, response);
		            }

		            conn.close();
		        } catch (Exception e) {
		            e.printStackTrace();
		            //response.getWriter().println("An error occurred.");
		           // request.setAttribute("message", "An error occurred.");
		            HttpSession session1 = request.getSession();
                    session1.setAttribute("message", "An error occurred.");
		            RequestDispatcher dispatcher = request.getRequestDispatcher("donateBlood.jsp");
	                dispatcher.forward(request, response);
		        }
		    }
		}

