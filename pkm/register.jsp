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
String name = request.getParameter("user_name");
String uname = request.getParameter("username");
String pass = request.getParameter("password");

if(name != null && uname != null && pass != null){

    try {

        // check if user exists
        PreparedStatement check = con.prepareStatement(
            "SELECT * FROM user WHERE username=?"
        );
        check.setString(1, uname);
        ResultSet rs = check.executeQuery();

        if(rs.next()){
            response.sendRedirect("home.jsp?register=exists");
        } else {

            // INSERT (YOU MISSED THIS)
            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO user(user_name, username, password) VALUES (?, ?, ?)"
            );

            ps.setString(1, name);
            ps.setString(2, uname);
            ps.setString(3, md5(pass));

            int result = ps.executeUpdate();

            if(result > 0){
                response.sendRedirect("home.jsp?register=success");
            } else {
                response.sendRedirect("home.jsp?register=error");
            }
        }

    } catch(Exception e){
        out.println(e); // for debug
    }
}
%>