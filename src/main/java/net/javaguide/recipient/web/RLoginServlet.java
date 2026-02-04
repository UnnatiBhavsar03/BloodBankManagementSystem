package net.javaguide.recipient.web;

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
import java.sql.ResultSet;

/**
 * Servlet implementation class RLoginServlet
 */
@WebServlet("/RLoginServlet")
public class RLoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public RLoginServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        // Database credentials
        String jdbcURL = "jdbc:mysql://localhost:3306/BloodBank";
        String dbUser = "root";
        String dbPassword = "Unnati@03";
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection connection = DriverManager.getConnection(jdbcURL, dbUser, dbPassword)) {
                String sql = "SELECT * FROM user WHERE email = ? AND password = ?";
                PreparedStatement statement = connection.prepareStatement(sql);
                statement.setString(1, email);
                statement.setString(2, password); // For hashed passwords, use appropriate hashing
                
                ResultSet result = statement.executeQuery();
                
                if (result.next()) {
                    // Successful login
                    HttpSession session = request.getSession();
                    session.setAttribute("email", email);
                    response.sendRedirect("recipientdesh.jsp");
                } else {
                    // Failed login
                    request.setAttribute("errorMessage", "Invalid username or password");
                    RequestDispatcher dispatcher = request.getRequestDispatcher("recipientlogin.jsp");
                    dispatcher.forward(request, response);
                }
            }
        } catch (Exception e) {
            throw new ServletException("Login failed", e);
        }
    }
}

