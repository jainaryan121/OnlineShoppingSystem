<%@ page session="true" %>
<%@ page import="java.sql.*, p1.DbConnection" %>
<%
    String name = (String) session.getAttribute("name");
    String role = (String) session.getAttribute("role");
    if (name == null || !"admin".equalsIgnoreCase(role)) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Products</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/home4.css">
    
   
</head>
<body>

    <!-- 🔹 Navbar -->
    <div class="navbar">
        <h1>Manage Products</h1>
        <a href="admindashboard.jsp"><i class="fa-solid fa-arrow-left"></i> Dashboard</a>
    </div>

    <!-- 🔸 Product Table Section -->
    <div class="table-container">
        <div class="table-header">
            <h2>Product List</h2>
            <a href="addProduct.jsp" class="add-btn"><i class="fa-solid fa-plus"></i> Add Product</a>
        </div>

        <% String msg = request.getParameter("msg");
           if (msg != null) { %>
            <div class="message"><%= msg %></div>
        <% } %>

        <table>
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Description</th>
                <th>Price (&#8377;)</th>
                <th>Quantity</th>
                <th>Image</th>
                <th>Actions</th>
            </tr>

        <%
            try {
                Connection con = DbConnection.getConnection();
                Statement st = con.createStatement();
                ResultSet rs = st.executeQuery("SELECT * FROM PRODUCTS ORDER BY PRODUCT_ID");

                boolean hasProducts = false;
                while (rs.next()) {
                    hasProducts = true;
        %>
            <tr>
                <td><%= rs.getInt("PRODUCT_ID") %></td>
                <td><%= rs.getString("NAME") %></td>
                <td><%= rs.getString("DESCRIPTION") %></td>
                <td><%= rs.getDouble("PRICE") %></td>
                <td><%= rs.getInt("QUANTITY") %></td>
                <td>
                    <% String imgPath = rs.getString("IMAGE_PATH"); %>
                    <% if (imgPath != null && !imgPath.trim().isEmpty()) { %>
                        <img src="<%= imgPath %>" alt="Product Image" width="60">
                    <% } else { %>
                        N/A
                    <% } %>
                </td>
                <td>
                    <a class="btn btn-edit" href="editProduct.jsp?id=<%= rs.getInt("PRODUCT_ID") %>"><i class="fa-solid fa-pen"></i> Edit</a>
                    <a class="btn btn-delete" href="DeleteProductServlet?id=<%= rs.getInt("PRODUCT_ID") %>" 
                       onclick="return confirm('Are you sure you want to delete this product?');"><i class="fa-solid fa-trash"></i> Delete</a>
                </td>
            </tr>
        <%
                }
                if (!hasProducts) {
        %>
            <tr>
                <td colspan="7" style="text-align:center;">No products found 📝</td>
            </tr>
        <%
                }
                con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        %>
        </table>
    </div>

</body>
</html>
