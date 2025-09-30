<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%@ page import="java.sql.*, p1.DbConnection" %>
<%
    String userEmail = (String) session.getAttribute("email");
    String role = (String) session.getAttribute("role");
    if (userEmail == null || !"user".equalsIgnoreCase(role)) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Cart</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/home7.css">
    
</head>
<body>

    
    <div class="header">
        <h1>🛒 My Cart</h1>
        <a href="userProduct.jsp"><i class="fa-solid fa-arrow-left"></i> Continue Shopping</a>
    </div>

    <%
        double total = 0;
        try {
            Connection con = DbConnection.getConnection();
            String sql = "SELECT c.ID, c.QUANTITY, p.PRODUCT_ID, p.NAME, p.PRICE, p.IMAGE_PATH " +
                        "FROM CART c JOIN PRODUCTS p ON c.PRODUCT_ID = p.PRODUCT_ID " +
                        "WHERE c.USER_EMAIL = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, userEmail);
            ResultSet rs = ps.executeQuery();

            boolean hasItems = false;
    %>

    <table>
        <tr>
            <th>Image</th>
            <th>Product</th>
            <th>Price (₹)</th>
            <th>Quantity</th>
            <th>Total</th>
            <th>Actions</th>
        </tr>

    <%
            while (rs.next()) {
                hasItems = true;
                int cartId = rs.getInt("ID");
                String name = rs.getString("NAME");
                double price = rs.getDouble("PRICE");
                int qty = rs.getInt("QUANTITY");
                String image = rs.getString("IMAGE_PATH");

                double itemTotal = price * qty;
                total += itemTotal;
    %>
        <tr>
            <td>
                <% if (image != null && !image.trim().isEmpty()) { %>
                    <img src="<%= image %>" alt="Product">
                <% } else { %>
                    N/A
                <% } %>
            </td>
            <td><%= name %></td>
            <td>₹ <%= price %></td>
            <td>
                <form action="UpdateCartServlet" method="post" style="display:inline;">
                    <input type="hidden" name="cartId" value="<%= cartId %>">
                    <input type="number" name="quantity" value="<%= qty %>" min="1">
                    <button type="submit" class="update-btn"><i class="fa-solid fa-rotate"></i></button>
                </form>
            </td>
            <td>₹ <%= itemTotal %></td>
            <td>
                <form action="RemoveFromCartServlet" method="post" style="display:inline;">
                    <input type="hidden" name="cartId" value="<%= cartId %>">
                    <button type="submit" class="remove-btn"><i class="fa-solid fa-trash"></i></button>
                </form>
            </td>
        </tr>
    <%
            }

            con.close();

            if (!hasItems) {
    %>
        <tr>
            <td colspan="6" class="empty-cart">Your cart is empty 🛒</td>
        </tr>
    <%
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    %>
    </table>

    <% if (total > 0) { %>
    <div class="total-section">
        Grand Total: ₹ <%= total %>
        <form action="PlaceOrderServlet" method="post" style="display:inline;">
            <button type="submit" class="place-order-btn">Place Order 🧾</button>
        </form>
    </div>
    <% } %>

</body>
</html>
