package p1;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/UpdateCartServlet")
public class UpdateCartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String cartIdStr = request.getParameter("cartId");
        String quantityStr = request.getParameter("quantity");

        try {
            int cartId = Integer.parseInt(cartIdStr);
            int quantity = Integer.parseInt(quantityStr);

            Connection con = DbConnection.getConnection();
            String sql = "UPDATE CART SET QUANTITY = ? WHERE PRODUCT_ID = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, quantity);
            ps.setInt(2, cartId);
            ps.executeUpdate();
            con.close();

            response.sendRedirect("cart.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("cart.jsp?msg=Error+updating+cart");
        }
    }
}
