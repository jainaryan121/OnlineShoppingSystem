package p1;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/DeleteProductServlet")
public class DeleteProductServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");

        try {
            int id = Integer.parseInt(idStr);
            Connection con = DbConnection.getConnection();
            String sql = "DELETE FROM PRODUCTS WHERE PRODUCT_ID = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, id);

            int rows = ps.executeUpdate();
            con.close();

            if (rows > 0) {
                response.sendRedirect("products.jsp?msg=Product+Deleted+Successfully");
            } else {
                response.sendRedirect("products.jsp?msg=Product+Not+Found");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("products.jsp?msg=Error+Deleting+Product");
        }
    }
}
