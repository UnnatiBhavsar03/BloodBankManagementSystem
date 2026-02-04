package net.javaguide.login.web;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import net.javaguide.login.bean.LoginBean;
import net.javaguide.login.database.LoginDao;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private LoginDao loginDao;

	public void init() {
		loginDao = new LoginDao();
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String email = request.getParameter("email");
		String password = request.getParameter("password");
		LoginBean loginBean = new LoginBean();
		loginBean.setUsername(email);
		loginBean.setPassword(password);

		try {
			if (loginDao.validate(loginBean)) {
				HttpSession session = request.getSession();
				session.setAttribute("email",email);
				response.sendRedirect("admindesh.jsp");
			} else {
				request.setAttribute("errorMessage", "Invalid username or password");
	            RequestDispatcher rd = request.getRequestDispatcher("adminlogin.jsp");
	            rd.forward(request, response);
				
			}
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
	}
}
