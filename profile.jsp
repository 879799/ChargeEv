<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.*" %>
<%@ page session="true" %>
<%
    // Check if user is logged in
String username = (String) session.getAttribute("user");
String email = (String) session.getAttribute("email");
String state = (String) session.getAttribute("state");
String mob_no = (String) session.getAttribute("mob_no");

/* 
    if (username == null) {
        // Not logged in, redirect to login page
        response.sendRedirect("SignUp_Login_Form.html");
        return;
    }
    
    // Set up DB connection parameters - update these as per your environment
    String dbURL = "jdbc:mysql://localhost:3306/charge_ev_platform";
    String dbUser = "root";
    String dbPassword = "password";

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    String fullName = "";
    String email = "";
    String phone = "";
    String address = "";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

        String sql = "SELECT fullname, email, phone, address FROM users WHERE username = ?";
        ps = conn.prepareStatement(sql);
        ps.setString(1, username);
        rs = ps.executeQuery();

        if (rs.next()) {
            fullName = rs.getString("fullname");
            email = rs.getString("email");
            phone = rs.getString("phone");
            address = rs.getString("address");
        } else {
            // User not found in DB (unlikely since logged in)
            fullName = "Unknown User";
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception e) {}
        if (ps != null) try { ps.close(); } catch (Exception e) {}
        if (conn != null) try { conn.close(); } catch (Exception e) {}
    }
    
    */
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>Profile - Charge EV Platform</title>
<style>
    @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap');

    body {
        margin: 0;
        font-family: 'Poppins', sans-serif;
        background: #e0f7fa;
        color: #333;
    }

    .container {
        max-width: 600px;
        margin: 60px auto;
        background: #fff;
      border-radius: 15px;
      box-shadow: 0 10px 25px rgba(0,0,0,0.1);
      padding: 30px 40px;
      max-width: 400px;
      width: 100%;
      text-align: center;
    }

    h1 {
        margin-bottom: 10px;
        font-weight: 600;
        color: #00796b;
    }

    .profile-info {
        margin-top: 30px;
        text-align: left;
    }

    .profile-info label {
        font-weight: 600;
        display: block;
        margin-top: 20px;
        color: #004d40;
    }

    .profile-info div {
        background: #b2dfdb;
        padding: 12px 15px;
        border-radius: 6px;
        margin-top: 6px;
        font-size: 1.1rem;
        color: #004d40;
        user-select: text;
    }
	 .profile-card {
      background: #fff;
      border-radius: 15px;
      box-shadow: 0 10px 25px rgba(0,0,0,0.1);
      padding: 30px 40px;
      max-width: 400px;
      width: 100%;
      text-align: center;
    }
    .btn-logout {
        margin-top: 40px;
        padding: 12px 25px;
        background: #00796b;
        color: white;
        border: none;
        border-radius: 25px;
        font-weight: 600;
        cursor: pointer;
        transition: background-color 0.3s ease;
        text-decoration: none;
        display: inline-block;
    }

    .btn-logout:hover {
        background: #004d40;
    }
</style>
</head>
<body>

        
       
 <div class="container">
  <div class="profile-card">
    <img src="https://i.pravatar.cc/100" alt="User Avatar" class="profile-avatar" /> 
    <h1>Welcome, <%= username %>!</h1>
    <p>Your profile details:</p>
    <div class="profile-info">
 <label>Email:</label>
        <div><%= email %></div>
  <label>Mobile Number:</label>
        <div><%= mob_no %></div>
 <label>State:</label>
        <div><%= state %></div>
    </div>
    <a href="SignUp_LogIn_Form.html" class="btn-logout">Logout</a>
</div>


</body>
</html>
