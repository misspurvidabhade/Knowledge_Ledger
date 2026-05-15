<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="db.jsp" %>

<%! 
public String md5(String input) {
    try {
        java.security.MessageDigest md = java.security.MessageDigest.getInstance("MD5");
        byte[] messageDigest = md.digest(input.getBytes());
        java.math.BigInteger no = new java.math.BigInteger(1, messageDigest);
        String hashtext = no.toString(16);
        while (hashtext.length() < 32) {
            hashtext = "0" + hashtext;
        }
        return hashtext;
    } catch (Exception e) {
        return null;
    }
}
%>

<%
String uname = request.getParameter("username");
String pass = request.getParameter("password");

if(uname != null && pass != null){

    try {
        PreparedStatement ps = con.prepareStatement(
            "SELECT * FROM user WHERE username=? AND password=?"
        );

        ps.setString(1, uname);
        ps.setString(2, md5(pass));

        ResultSet rs = ps.executeQuery();

        if(rs.next()) {

            int userId = rs.getInt("user_id");         
            String username = rs.getString("user_name"); 

            //SET SESSION
            session.setAttribute("user_id", userId);
            session.setAttribute("username", username);

            response.sendRedirect("dashboard.jsp");

        } else {
            response.sendRedirect("home.jsp?login=invalid");
        }

    } catch(Exception e){
        out.print(e); 
    }
}
%>


