package net.javaguide.userregister;

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

import net.javaguide.login.database.DBUtil;

/**
 * Servlet implementation class UserRegisterServlet
 */
@WebServlet("/UserRegisterServlet")
public class UserRegisterServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String city = request.getParameter("city");
        String gender = request.getParameter("gender");
        String dob = request.getParameter("dob");
        String bloodGroup = request.getParameter("blood_group");

        try {
            // Database connection
            Connection con = DBUtil.getConnection();

            // Insert user data
            String query = "INSERT INTO user (name, email, password, phone, address, city, gender, dob, blood_group) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, password);
            ps.setString(4, phone);
            ps.setString(5, address);
            ps.setString(6, city);
            ps.setString(7, gender);
            ps.setString(8, dob);
            ps.setString(9, bloodGroup);
            ps.executeUpdate();

            con.close();
           // response.sendRedirect("home.jsp"); 
         // After successful registration
            HttpSession session = request.getSession();
            session.setAttribute("successMessage", "Registration Successful! You can now login.");
            response.sendRedirect("userregisteration.jsp");  // or wherever you want to show the message
            
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error storing user information.");
        }
    

   
    
        
    }
}
