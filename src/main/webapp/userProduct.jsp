<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%@ page import="java.sql.*, p1.DbConnection" %>
<%
    String username = (String) session.getAttribute("name");
    String role = (String) session.getAttribute("role");
    if (username == null || !"user".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Browse Products</title>
   
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/home2.css">
    
</head>
<body>

<h2 style="text-align:center;">🛍️ Welcome, <%= username %> — Browse Products</h2>
<div style="text-align:center;">
    <a href="cart.jsp">My Cart 🛒</a> | 
    <a href="userdashboard.jsp">← Back to Dashboard</a>
</div>

<div class="product-grid">
<%
    try {
        Connection con = DbConnection.getConnection();
        Statement st = con.createStatement();
        ResultSet rs = st.executeQuery("SELECT * FROM PRODUCTS ORDER BY PRODUCT_ID");

        while (rs.next()) {
            int id = rs.getInt("PRODUCT_ID");
            String pname = rs.getString("NAME");
            String desc = rs.getString("DESCRIPTION");
            double price = rs.getDouble("PRICE");
            int qty = rs.getInt("QUANTITY");
            String img = rs.getString("IMAGE_PATH");
%>
    <div class="product-card">
        <% if (img != null && !img.trim().isEmpty()) { %>
            <img src="<%= img %>" alt="Product">
        <% } else { %>
            <img src="images/no-image.png" alt="No Image">
        <% } %>
        <h3><%= pname %></h3>
        <p><%= desc %></p>
        <p class="price">₹ <%= price %></p>
        <% if (qty > 0) { %>
            <form action="AddToCartServlet" method="post">
                <input type="hidden" name="productId" value="<%= id %>">
                <input type="number" name="quantity" value="1" min="1" max="<%= qty %>">
                <button type="submit">Add to Cart</button>
            </form>
        <% } else { %>
            <p style="color:red;">Out of Stock</p>
        <% } %>
    </div>
<%
        }
        con.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
</div>

</body>
</html>
