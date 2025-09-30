package p1;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/PlaceOrderServlet")
public class PlaceOrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String userEmail = (String) session.getAttribute("email");

        if (userEmail == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        Connection con = null;
        PreparedStatement psSelectCart = null;
        PreparedStatement psInsertOrder = null;
        PreparedStatement psUpdateStock = null;
        PreparedStatement psClearCart = null;

        try {
            con = DbConnection.getConnection();
            con.setAutoCommit(false); // ✅ Transaction start

            // 1️⃣ Get all cart items for this user
            String cartQuery = "SELECT c.PRODUCT_ID, c.QUANTITY, p.PRICE, p.QUANTITY AS STOCK " +
                               "FROM CART c JOIN PRODUCTS p ON c.PRODUCT_ID = p.PRODUCT_ID " +
                               "WHERE c.USER_EMAIL = ?";
            psSelectCart = con.prepareStatement(cartQuery);
            psSelectCart.setString(1, userEmail);
            ResultSet rs = psSelectCart.executeQuery();

            boolean hasItems = false;

            while (rs.next()) {
                hasItems = true;
                int productId = rs.getInt("PRODUCT_ID");
                int quantityOrdered = rs.getInt("QUANTITY");
                int stock = rs.getInt("STOCK");

                if (quantityOrdered > stock) {
                    rs.close();
                    throw new Exception("Not enough stock for product ID: " + productId);
                }

                // 2️⃣ Insert into ORDERS table
                String orderInsert = 
                    "INSERT INTO ORDERS (USER_EMAIL, PRODUCT_ID, QUANTITY, ORDER_DATE, STATUS) " +
                    "VALUES (?, ?, ?, SYSDATE, 'Pending')";
                psInsertOrder = con.prepareStatement(orderInsert);
                psInsertOrder.setString(1, userEmail);
                psInsertOrder.setInt(2, productId);
                psInsertOrder.setInt(3, quantityOrdered);
                psInsertOrder.executeUpdate();

                // 3️⃣ Update product stock
                String stockUpdate = "UPDATE PRODUCTS SET QUANTITY = QUANTITY - ? WHERE PRODUCT_ID = ?";
                psUpdateStock = con.prepareStatement(stockUpdate);
                psUpdateStock.setInt(1, quantityOrdered);
                psUpdateStock.setInt(2, productId);
                psUpdateStock.executeUpdate();
            }
            rs.close();

            if (!hasItems) {
                response.sendRedirect("cart.jsp?msg=Your+cart+is+empty");
                return;
            }

            // 4️⃣ Clear cart after successful order
            String clearCart = "DELETE FROM CART WHERE USER_EMAIL = ?";
            psClearCart = con.prepareStatement(clearCart);
            psClearCart.setString(1, userEmail);
            psClearCart.executeUpdate();

            con.commit(); // ✅ Transaction commit

            response.sendRedirect("myOrders.jsp?msg=Order+placed+successfully");

        } catch (Exception e) {
            e.printStackTrace();
            try {
                if (con != null) con.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            response.sendRedirect("cart.jsp?msg=Error+placing+order");
        } finally {
            try {
                if (psSelectCart != null) psSelectCart.close();
                if (psInsertOrder != null) psInsertOrder.close();
                if (psUpdateStock != null) psUpdateStock.close();
                if (psClearCart != null) psClearCart.close();
                if (con != null) con.close();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
    }
}
