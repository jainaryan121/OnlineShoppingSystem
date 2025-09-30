package p1;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/UpdateOrderStatusServlet")
public class UpdateOrderStatusServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String orderIdStr = request.getParameter("orderId");
        String status = request.getParameter("status");

        try {
            int orderId = Integer.parseInt(orderIdStr);

            Connection con = DbConnection.getConnection();
            String sql = "UPDATE ORDERS SET STATUS = ? WHERE ID = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, orderId);
            ps.executeUpdate();
            con.close();

            response.sendRedirect("adminOrders.jsp?msg=Order+status+updated");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("adminOrders.jsp?msg=Failed+to+update+status");
        }
    }
}
