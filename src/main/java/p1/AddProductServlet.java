package p1;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/AddProductServlet")
public class AddProductServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String priceStr = request.getParameter("price");
        String quantityStr = request.getParameter("quantity");
        String imagePath = request.getParameter("imagePath");

        try {
            double price = Double.parseDouble(priceStr);
            int quantity = Integer.parseInt(quantityStr);

            Connection con = DbConnection.getConnection();
            String sql = "INSERT INTO PRODUCTS (NAME, DESCRIPTION, PRICE, QUANTITY, IMAGE_PATH) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, description);
            ps.setDouble(3, price);
            ps.setInt(4, quantity);
            ps.setString(5, imagePath);

            int rows = ps.executeUpdate();
            con.close();

            if (rows > 0) {
                response.sendRedirect("products.jsp?msg=Product+Added+Successfully");
            } else {
                response.sendRedirect("addProduct.jsp?msg=Failed+to+Add+Product");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("addProduct.jsp?msg=Error+Occured");
        }
    }
}
