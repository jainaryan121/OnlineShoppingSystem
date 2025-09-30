<%@ page session="true" %>
<%@ page import="java.sql.*, p1.DbConnection" %>
<%
    String name = (String) session.getAttribute("name");
    String role = (String) session.getAttribute("role");
    if (name == null || !"admin".equalsIgnoreCase(role)) {
        response.sendRedirect("login.jsp");
        return;
    }

    String idStr = request.getParameter("id");
    int id = Integer.parseInt(idStr);
    String pname = "", desc = "", img = "";
    double price = 0;
    int qty = 0;

    try {
        Connection con = DbConnection.getConnection();
        PreparedStatement ps = con.prepareStatement("SELECT * FROM PRODUCTS WHERE PRODUCT_ID = ?");
        ps.setInt(1, id);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            pname = rs.getString("NAME");
            desc = rs.getString("DESCRIPTION");
            price = rs.getDouble("PRICE");
            qty = rs.getInt("QUANTITY");
            img = rs.getString("IMAGE_PATH");
        }
        con.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Product</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
     <link rel="stylesheet" href="<%= request.getContextPath() %>/css/home6.css">
</head>
<body>

    <div class="form-container">
        <h2> Edit Product</h2>

        <% if (img != null && !img.trim().isEmpty()) { %>
        <div class="img-preview">
            <img src="<%= img %>" alt="Product Image">
        </div>
        <% } %>

        <form action="UpdateProductServlet" method="post">
            <input type="hidden" name="id" value="<%= id %>">

            <label>Name:</label>
            <input type="text" name="name" value="<%= pname %>" required>

            <label>Description:</label>
            <textarea name="description" rows="3"><%= desc %></textarea>

            <label>Price:</label>
            <input type="number" name="price" step="0.01" value="<%= price %>" required>

            <label>Quantity:</label>
            <input type="number" name="quantity" value="<%= qty %>" required>

            <label>Image Path (URL):</label>
            <input type="text" name="imagePath" value="<%= img %>">

            <button type="submit"><i class="fa-solid fa-floppy-disk"></i> Update Product</button>
        </form>

        <a href="products.jsp" class="back-link"><i class="fa-solid fa-arrow-left"></i> Back to Products</a>
    </div>

</body>
</html>
