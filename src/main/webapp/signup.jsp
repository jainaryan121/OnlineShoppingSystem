<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Signup</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/home.css">
    
</head>
<body>

    <div class="signup-container">
        <h2>Create Account</h2>
        <form action="SignupServlet" method="post">
            <input type="text" name="name" placeholder="Full Name" required>
            <input type="email" name="email" placeholder="Email Address" required>
            <input type="password" name="password" placeholder="Password" required>

            <select name="role" required>
                <option value="" disabled selected>Select Role</option>
                <option value="user">User</option>
                <option value="admin">Admin</option>
            </select>

            <input type="submit" value="Sign Up">
        </form>

        <a class="login-link" href="login.jsp">Already have an account? Login</a>
    </div>

</body>
</html>
