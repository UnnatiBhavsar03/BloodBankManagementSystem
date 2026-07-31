package net.javaguide.admin;

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
import java.sql.SQLException;

import net.javaguide.login.database.DBUtil;

@WebServlet("/ArrangeCampServlet")
public class ArrangeCampServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Example: Retrieve form data from the request
        String address = request.getParameter("c_address");
        String city = request.getParameter("c_city");
        String date = request.getParameter("c_date");
        String time = request.getParameter("c_time");

        Connection connection = null;
        PreparedStatement preparedStatement = null;

        try {
            // Establish connection
            connection = DBUtil.getConnection();

            // Insert camp data into the database
            String sql = "INSERT INTO blood_camp (c_address, c_city, c_date, c_time) VALUES (?, ?, ?, ?)";
            preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setString(1, address);
            preparedStatement.setString(2, city);
            preparedStatement.setString(3, date);
            preparedStatement.setString(4, time);

            int rowsInserted = preparedStatement.executeUpdate();
            HttpSession session = request.getSession();
            if (rowsInserted > 0) {
            	
                 session.setAttribute("successMessage", "Camp Arranged Successfully.");
                 
            	response.sendRedirect("arrangecamp.jsp"); 
            } else {
            	 session.setAttribute("errorMessage", "Failed to arrange camp. Please try again.");
                //response.getWriter().println("Failed to arrange camp. Please try again.");
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            response.getWriter().println("An error occurred: " + e.getMessage());
        } finally {
            // Close resources
            try {
                if (preparedStatement != null) preparedStatement.close();
                if (connection != null) connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}

