package p1;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/AddToCartServlet")
public class AddToCartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String userEmail = (String) session.getAttribute("email"); // Make sure this is set at login
        String productIdStr = request.getParameter("productId");
        String quantityStr = request.getParameter("quantity");

        if (userEmail == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            int productId = Integer.parseInt(productIdStr);
            int quantityRequested = Integer.parseInt(quantityStr);

            Connection con = DbConnection.getConnection();

            // 1️⃣ Check available stock
            String stockQuery = "SELECT QUANTITY FROM PRODUCTS WHERE PRODUCT_ID = ?";
            PreparedStatement ps1 = con.prepareStatement(stockQuery);
            ps1.setInt(1, productId);
            ResultSet rs = ps1.executeQuery();

            int availableQty = 0;
            if (rs.next()) {
                availableQty = rs.getInt("QUANTITY");
            }
            rs.close();
            ps1.close();

            if (availableQty <= 0) {
                con.close();
                response.sendRedirect("userProduct.jsp?msg=Out+of+Stock");
                return;
            }

            if (quantityRequested > availableQty) {
                con.close();
                response.sendRedirect("userProduct.jsp?msg=Only+" + availableQty + "+items+available");
                return;
            }

            // 2️⃣ Check if product already exists in user's cart
            String checkCart = "SELECT QUANTITY FROM CART WHERE USER_EMAIL = ? AND PRODUCT_ID = ?";
            PreparedStatement ps2 = con.prepareStatement(checkCart);
            ps2.setString(1, userEmail);
            ps2.setInt(2, productId);
            ResultSet rsCart = ps2.executeQuery();

            if (rsCart.next()) {
                // If already in cart, update quantity (but also check limit)
                int existingQty = rsCart.getInt("QUANTITY");
                int newQty = existingQty + quantityRequested;

                if (newQty > availableQty) {
                    con.close();
                    response.sendRedirect("userProduct.jsp?msg=Max+stock+is+" + availableQty);
                    return;
                }

                String updateCart = "UPDATE CART SET QUANTITY = ? WHERE USER_EMAIL = ? AND PRODUCT_ID = ?";
                PreparedStatement ps3 = con.prepareStatement(updateCart);
                ps3.setInt(1, newQty);
                ps3.setString(2, userEmail);
                ps3.setInt(3, productId);
                ps3.executeUpdate();
                ps3.close();

            } else {
                // New cart entry
                String insertCart = "INSERT INTO CART (USER_EMAIL, PRODUCT_ID, QUANTITY) VALUES (?, ?, ?)";
                PreparedStatement ps4 = con.prepareStatement(insertCart);
                ps4.setString(1, userEmail);
                ps4.setInt(2, productId);
                ps4.setInt(3, quantityRequested);
                ps4.executeUpdate();
                ps4.close();
            }

            rsCart.close();
            ps2.close();
            con.close();

            response.sendRedirect("userProduct.jsp?msg=Added+to+Cart");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("userProduct.jsp?msg=Error+Adding+to+Cart");
        }
    }
}
