<%@ page session="true" %>
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
    <title>Add Product</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
   <link rel="stylesheet" href="<%= request.getContextPath() %>/css/home10.css">
   
</head>
<body>

    <div class="form-container">
        <h2>Add New Product</h2>

        <form action="AddProductServlet" method="post">
            <label>Product Name:</label>
            <input type="text" name="name" placeholder="Enter product name" required>

            <label>Description:</label>
            <textarea name="description" rows="3" placeholder="Enter product description"></textarea>

            <label>Price:</label>
            <input type="number" name="price" step="0.01" placeholder="Enter price" required>

            <label>Quantity:</label>
            <input type="number" name="quantity" placeholder="Enter quantity" required>

            <label>Image Path (URL):</label>
            <input type="text" name="imagePath" placeholder="https://example.com/image.jpg">

            <button type="submit"><i class="fa-solid fa-plus"></i> Add Product</button>
        </form>

        <a href="admindashboard.jsp" class="back-link"><i class="fa-solid fa-arrow-left"></i> Back to Dashboard</a>

        <%
            String msg = request.getParameter("msg");
            if (msg != null) {
        %>
            <div class="msg"><%= msg %></div>
        <%
            }
        %>
    </div>

</body>
</html>
