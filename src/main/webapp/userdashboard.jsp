<%@ page session="true" %>
<%
    String name = (String) session.getAttribute("name");
    String role = (String) session.getAttribute("role");
    if (name == null || !"user".equalsIgnoreCase(role)) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>User Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/home3.css">
</head>
<body>

  
    <div class="navbar">
        <h1>User Dashboard</h1>
        <a href="logout.jsp" class="logout">Logout</a>
    </div>

   
    <div class="dashboard-container">
        <div class="welcome">
            Welcome, <strong><%= name %></strong>
            <p style="font-size:14px; color:#555;">Browse products, manage your cart, and track your orders.</p>
        </div>

       
        <div class="card-grid">
            <a href="userProduct.jsp" class="card">
                <i class="fa-solid fa-store"></i>
                <h3>Browse Products</h3>
            </a>

            <a href="cart.jsp" class="card">
                <i class="fa-solid fa-cart-shopping"></i>
                <h3>My Cart</h3>
            </a>

            <a href="myOrders.jsp" class="card">
                <i class="fa-solid fa-box"></i>
                <h3>My Orders</h3>
            </a>
        </div>
    </div>

</body>
</html>
