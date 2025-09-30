<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login</title>
   <link rel="stylesheet" href="<%= request.getContextPath() %>/css/home1.css">
   
</head>
<body>

    <div class="login-container">
        <h2>🔑 Login</h2>

        <% 
            String msg = request.getParameter("msg");
            if (msg != null) {
        %>
            <p class="error"><%= msg %></p>
        <% 
            }
        %>

        <form action="LoginServlet" method="post">
            <input type="email" name="email" placeholder="Email Address" required>

            <div class="password-container">
                <input type="password" name="password" id="password" placeholder="Password" required>
                <span class="toggle-password" onclick="togglePassword()">👁️</span>
            </div>

            <input type="submit" value="Login">
        </form>

        <a class="signup-link" href="signup.jsp">Don't have an account? Sign Up</a>
    </div>

    <script>
        function togglePassword() {
            const passwordField = document.getElementById("password");
            const toggleIcon = document.querySelector(".toggle-password");
            if (passwordField.type === "password") {
                passwordField.type = "text";
                toggleIcon.textContent = "🙈";
            } else {
                passwordField.type = "password";
                toggleIcon.textContent = "👁️";
            }
        }
    </script>

</body>
</html>
