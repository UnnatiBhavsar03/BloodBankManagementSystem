package net.javaguide.recipient.requestblood;



import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import net.javaguide.login.database.DBUtil;

/**
 * Servlet implementation class RequestBloodServlet
 */
@WebServlet("/RequestBloodServlet")
@MultipartConfig(
	    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
	    maxFileSize = 1024 * 1024 * 10,       // 10MB
	    maxRequestSize = 1024 * 1024 * 50     // 50MB
	)
public class RequestBloodServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public RequestBloodServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		
		
				        // Retrieve session email
		        HttpSession session = request.getSession();
		        String email = (String) session.getAttribute("email");

		        if (email == null) {
		            response.sendRedirect("recipientlogin.jsp");
		            return;
		        }

		        // Retrieve form data
		        String bloodGroup = request.getParameter("blood_group");
		        String requestDate = request.getParameter("request_date");
		        //int bloodUnits = Integer.parseInt(request.getParameter("bloodUnits"));
		        //int age = Integer.parseInt(request.getParameter("age"));
		        Part filePart = request.getPart("doctor_description_pic");

		        // Define the path to save uploaded files
		        String savePath = request.getServletContext().getRealPath("/") + "uploads"; // Change this to your desired directory
		        File fileSaveDir = new File(savePath);
		        if (!fileSaveDir.exists()) {
		            fileSaveDir.mkdirs();
		        }

		        // Get the submitted file name
		        String fileName = new File(filePart.getSubmittedFileName()).getName();
		        String filePath = savePath + File.separator + fileName;

		        // Write the file to the specified path
		        filePart.write(filePath);

		        // Store the relative path in the database
		        String relativePath = "uploads/" + fileName;
		        
		        
		        
		        String bloodUnitsStr = request.getParameter("bloodUnits");
		        String ageStr = request.getParameter("age");

		        int bloodUnits = 0;
		        int age = 0;

		        try {
		            if (bloodUnitsStr != null && !bloodUnitsStr.isEmpty()) {
		                bloodUnits = Integer.parseInt(bloodUnitsStr);
		            } else {
		                // Handle missing blood_units, e.g., set default or return error
		                response.sendRedirect("requestBlood.jsp?error=missing_blood_units");
		                return;
		            }

		            if (ageStr != null && !ageStr.isEmpty()) {
		                age = Integer.parseInt(ageStr);
		            } else {
		                // Handle missing age, e.g., set default or return error
		                response.sendRedirect("requestBlood.jsp?error=missing_age");
		                return;
		            }
		        } catch (NumberFormatException e) {
		            // Handle invalid number format, e.g., return error message
		            response.sendRedirect("requestBlood.jsp?error=invalid_number_format");
		            return;
		        }

		        
		        
		        

		        try {
		            Connection con = DBUtil.getConnection();

		            // Retrieve u_id from user table
		            PreparedStatement psUser = con.prepareStatement("SELECT u_id FROM user WHERE email = ?");
		            psUser.setString(1, email);
		            ResultSet rs = psUser.executeQuery();

		            int u_id = -1;
		            if (rs.next()) {
		                u_id = rs.getInt("u_id");
		            } else {
		                // User not found
		                response.sendRedirect("recipientlogin.jsp");
		                return;
		            }

		            // Insert into donor table
		            PreparedStatement ps = con.prepareStatement("INSERT INTO recipient (u_id, r_bloodgroup, r_date, required_units, r_age, doctor_desc_pic) VALUES (?, ?, ?, ?, ?, ?)");
		            ps.setInt(1, u_id);
		            ps.setString(2, bloodGroup);
		            ps.setDate(3, java.sql.Date.valueOf(requestDate));
		            ps.setInt(4, bloodUnits);
		            ps.setInt(5, age);
		            ps.setString(6, relativePath);
		            int rowsInserted = ps.executeUpdate();
		            if (rowsInserted > 0) {
		            	
	                    //response.getWriter().println("Donation registered successfully!");
	                    //request.setAttribute("message", "if your request is approved , the blood will be delivered to your specified address within possible time."
	                    		//+ "    For urgent queries, contact us at phone ");
		            	HttpSession session1 = request.getSession();
	                     session1.setAttribute("message", "if your request is approved , the blood will be delivered to your specified address within possible time."
		                    		+ "    For urgent queries, contact us at phone ");
	                    RequestDispatcher dispatcher = request.getRequestDispatcher("requestBlood.jsp");
		                dispatcher.forward(request, response);
	                } else {
	                   // response.getWriter().println("Failed to register donation.");
	                	// request.setAttribute("message", "Failed to register request.");
	                	HttpSession session1 = request.getSession();
	                     session1.setAttribute("message", "Failed to register request.");
	                    RequestDispatcher dispatcher = request.getRequestDispatcher("requestBlood.jsp");
		                dispatcher.forward(request, response);
	                }
	            
	            con.close();
	        } catch (Exception e) {
	            e.printStackTrace();
	            //response.getWriter().println("An error occurred.");
	            //request.setAttribute("message", "An error occurred.");
	            HttpSession session1 = request.getSession();
                session1.setAttribute("message", "An error occurred.");
	            RequestDispatcher dispatcher = request.getRequestDispatcher("requestBlood.jsp");
	            dispatcher.forward(request, response);
	        }
	    }
	}




