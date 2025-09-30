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
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/home9.css">
    
</head>
<body>

  
    <div class="navbar">
        <h1>Admin Dashboard</h1>
        <a href="logout.jsp" class="logout">Logout</a>
    </div>

    
    <div class="dashboard-container">
        <div class="welcome">
            Welcome, <strong><%= name %></strong> (Admin)
            <p style="font-size:14px; color:#555;">Manage products, view orders, and control your store from here.</p>
        </div>

       
        <div class="card-grid">
            <a href="addProduct.jsp" class="card">
                <i class="fa-solid fa-plus"></i>
                <h3>Add Product</h3>
            </a>

            <a href="products.jsp" class="card">
                <i class="fa-solid fa-boxes-stacked"></i>
                <h3>View / Edit Products</h3>
            </a>

            <a href="adminOrders.jsp" class="card">
                <i class="fa-solid fa-clipboard-list"></i>
                <h3>View Orders</h3>
            </a>

            <a href="logout.jsp" class="card" style="background:#ff4d4d; color:white;">
                <i class="fa-solid fa-right-from-bracket"></i>
                <h3>Logout</h3>
            </a>
        </div>
    </div>

</body>
</html>
