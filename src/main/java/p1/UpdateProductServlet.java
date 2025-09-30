package p1;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/UpdateProductServlet")
public class UpdateProductServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String priceStr = request.getParameter("price");
        String quantityStr = request.getParameter("quantity");
        String imagePath = request.getParameter("imagePath");

        try {
            int id = Integer.parseInt(idStr);
            double price = Double.parseDouble(priceStr);
            int quantity = Integer.parseInt(quantityStr);

            Connection con = DbConnection.getConnection();
            String sql = "UPDATE PRODUCTS SET NAME=?, DESCRIPTION=?, PRICE=?, QUANTITY=?, IMAGE_PATH=? WHERE PRODUCT_ID=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, description);
            ps.setDouble(3, price);
            ps.setInt(4, quantity);
            ps.setString(5, imagePath);
            ps.setInt(6, id);

            int rows = ps.executeUpdate();
            con.close();

            if (rows > 0) {
                response.sendRedirect("products.jsp?msg=Product+Updated+Successfully");
            } else {
                response.sendRedirect("products.jsp?msg=Update+Failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("products.jsp?msg=Error+Updating+Product");
        }
    }
}
