package p1;

import java.io.*;
import java.sql.*;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class LoginServlet
 */
@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		
		String email=request.getParameter("email");
		String password=request.getParameter("password");
		
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			Connection conn=DbConnection.getConnection();
			
			PreparedStatement ps=conn.prepareStatement("select * from users where email=? and password=?");
			
			ps.setString(1,email);
			ps.setString(2, password);
			
			ResultSet rs=ps.executeQuery();
			if(rs.next()) {
				String role=rs.getString("role");
				String name=rs.getString("name");
				
				
				// Session
				
				HttpSession hs=request.getSession();
				hs.setAttribute("name",name);
				hs.setAttribute("email",email);
				hs.setAttribute("role",role);
				if("admin".equalsIgnoreCase(role)) {
					response.sendRedirect("admindashboard.jsp");
				}
				else {
					response.sendRedirect("userdashboard.jsp");
				}
			}
				else {
					request.setAttribute("errorMessage","Invalid email or password");
					RequestDispatcher rd=request.getRequestDispatcher("login.jsp");
					rd.forward(request, response);
				}
		}	
		catch(Exception e) {
			e.printStackTrace();
			response.getWriter().println("Database error: "+e.getMessage());
		}
		
	}

}
