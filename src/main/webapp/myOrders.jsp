<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%@ page import="java.sql.*, p1.DbConnection" %>
<%
    // ✅ Session check
    String email = (String) session.getAttribute("email");
    if (email == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Orders</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/home5.css">
</head>
<body>

    <!-- 🔹 Top Header -->
    <div class="header">
        <h1>📦 My Orders</h1>
        <a href="userdashboard.jsp"><i class="fa-solid fa-arrow-left"></i> Dashboard</a>
    </div>

    <h2>🧾 Order History</h2>

<%
    String msg = request.getParameter("msg");
    if (msg != null) {
%>
    <div class="message"><%= msg %></div>
<%
    }

    try {
        Connection con = DbConnection.getConnection();

        String sql = 
            "SELECT o.ID, p.NAME, p.PRICE, o.QUANTITY, " +
            "(o.QUANTITY * p.PRICE) AS TOTAL_PRICE, " +
            "TO_CHAR(o.ORDER_DATE, 'DD-MON-YYYY') AS ORDER_DATE, o.STATUS " +
            "FROM ORDERS o " +
            "JOIN PRODUCTS p ON o.PRODUCT_ID = p.PRODUCT_ID " +
            "WHERE o.USER_EMAIL = ? " +
            "ORDER BY o.ORDER_DATE DESC, o.ID DESC";

        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, email);
        ResultSet rs = ps.executeQuery();

        boolean hasOrders = false;
%>

<table>
    <tr>
        <th>Order ID</th>
        <th>Product</th>
        <th>Price (₹)</th>
        <th>Quantity</th>
        <th>Total (₹)</th>
        <th>Order Date</th>
        <th>Status</th>
    </tr>

<%
        while (rs.next()) {
            hasOrders = true;
            int orderId = rs.getInt("ID");
            String productName = rs.getString("NAME");
            double price = rs.getDouble("PRICE");
            int qty = rs.getInt("QUANTITY");
            double total = rs.getDouble("TOTAL_PRICE");
            String orderDate = rs.getString("ORDER_DATE");
            String status = rs.getString("STATUS");
%>
    <tr>
        <td><%= orderId %></td>
        <td><%= productName %></td>
        <td>₹ <%= price %></td>
        <td><%= qty %></td>
        <td>₹ <%= total %></td>
        <td><%= orderDate %></td>
        <td><span class="status <%= status %>"><%= status %></span></td>
    </tr>
<%
        }

        if (!hasOrders) {
%>
    <tr>
        <td colspan="7" class="empty-row">You have no orders yet 🛍️</td>
    </tr>
<%
        }

        rs.close();
        ps.close();
        con.close();
    } catch (Exception e) {
        e.printStackTrace();
%>
    <p style="text-align:center; color:red;">⚠ Error loading orders. Please try again later.</p>
<%
    }
%>
</table>

</body>
</html>
