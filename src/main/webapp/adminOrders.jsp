<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%@ page import="java.sql.*, p1.DbConnection" %>
<%
    
    String adminName = (String) session.getAttribute("name");
    String role = (String) session.getAttribute("role");
    if (adminName == null || !"admin".equalsIgnoreCase(role)) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Orders (Admin)</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
   <link rel="stylesheet" href="<%= request.getContextPath() %>/css/home8.css">
   
</head>
<body>

   
    <div class="navbar">
        <h1>📝 Manage Orders</h1>
        <a href="admindashboard.jsp"><i class="fa-solid fa-arrow-left"></i> Dashboard</a>
    </div>

    <%
        String msg = request.getParameter("msg");
        if (msg != null) {
    %>
        <div class="message"><%= msg %></div>
    <%
        }

        try {
            Connection con = DbConnection.getConnection();
            String sql = "SELECT o.ID, o.USER_EMAIL, p.NAME, p.PRICE, o.QUANTITY, " +
                        "(o.QUANTITY * p.PRICE) AS TOTAL_PRICE, " +
                        "TO_CHAR(o.ORDER_DATE, 'DD-MON-YYYY') AS ORDER_DATE, o.STATUS " +
                        "FROM ORDERS o JOIN PRODUCTS p ON o.PRODUCT_ID = p.PRODUCT_ID " +
                        "ORDER BY o.ORDER_DATE DESC, o.ID DESC";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
    %>

    <table>
        <tr>
            <th>Order ID</th>
            <th>User Email</th>
            <th>Product</th>
            <th>Price (₹)</th>
            <th>Quantity</th>
            <th>Total (₹)</th>
            <th>Order Date</th>
            <th>Status</th>
            <th>Action</th>
        </tr>

    <%
        boolean hasOrders = false;
        while (rs.next()) {
            hasOrders = true;
            int orderId = rs.getInt("ID");
            String userEmail = rs.getString("USER_EMAIL");
            String productName = rs.getString("NAME");
            double price = rs.getDouble("PRICE");
            int qty = rs.getInt("QUANTITY");
            double total = rs.getDouble("TOTAL_PRICE");
            String date = rs.getString("ORDER_DATE");
            String status = rs.getString("STATUS");
    %>
        <tr>
            <td><%= orderId %></td>
            <td><%= userEmail %></td>
            <td><%= productName %></td>
            <td>₹ <%= price %></td>
            <td><%= qty %></td>
            <td>₹ <%= total %></td>
            <td><%= date %></td>
            <td><span class="status <%= status %>"><%= status %></span></td>
            <td>
                <form action="UpdateOrderStatusServlet" method="post" style="display:inline;">
                    <input type="hidden" name="orderId" value="<%= orderId %>">
                    <select name="status">
                        <option value="Pending" <%= "Pending".equals(status) ? "selected" : "" %>>Pending</option>
                        <option value="Shipped" <%= "Shipped".equals(status) ? "selected" : "" %>>Shipped</option>
                        <option value="Delivered" <%= "Delivered".equals(status) ? "selected" : "" %>>Delivered</option>
                    </select>
                    <button type="submit"><i class="fa-solid fa-pen"></i></button>
                </form>
            </td>
        </tr>
    <%
        }

        if (!hasOrders) {
    %>
        <tr>
            <td colspan="9" class="empty">No orders found 📝</td>
        </tr>
    <%
        }

        rs.close();
        ps.close();
        con.close();
    } catch (Exception e) {
        e.printStackTrace();
    %>
        <p style="text-align:center; color:red;">⚠ Error loading orders. Try again later.</p>
    <%
    }
    %>
    </table>

</body>
</html>
