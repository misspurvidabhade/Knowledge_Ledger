<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="db.jsp" %>

<%
Integer userId = (Integer) session.getAttribute("user_id");
String userName = (String) session.getAttribute("username");

if(userId == null){
    response.sendRedirect("home.jsp");
    return;
}
%>

<%
/* GET DOMAIN ID ONCE (NO DUPLICATE) */
String dnoParam = request.getParameter("d_no");
Integer d_no = null;

if(dnoParam != null){
    d_no = Integer.parseInt(dnoParam);
}
%>

<!-- SUCCESS MESSAGE -->
<%
String msg = (String) session.getAttribute("msg");
if(msg != null){
%>
    <div class="success-msg"><%= msg %></div>
<%
    session.removeAttribute("msg");
}
%>

<!-- ADD SUBJECT -->
<%
if(request.getParameter("s_name") != null){

    String s_name = request.getParameter("s_name");
    String desc = request.getParameter("description");

    int domainId = Integer.parseInt(request.getParameter("d_no"));

    String r_name = request.getParameter("r_name");
    String r_type = request.getParameter("r_type");

    try{
        PreparedStatement ps1 = con.prepareStatement(
            "INSERT INTO subject(s_name, d_no, description) VALUES (?, ?, ?)",
            Statement.RETURN_GENERATED_KEYS
        );

        ps1.setString(1, s_name);
        ps1.setInt(2, domainId);
        ps1.setString(3, desc);
        ps1.executeUpdate();

        ResultSet keys = ps1.getGeneratedKeys();
        int s_id = 0;

        if(keys.next()){
            s_id = keys.getInt(1);
        }

        if(r_name != null && !r_name.trim().isEmpty()){
            PreparedStatement ps2 = con.prepareStatement(
                "INSERT INTO resource(r_name, r_type, s_id) VALUES (?, ?, ?)"
            );

            ps2.setString(1, r_name);
            ps2.setString(2, r_type);
            ps2.setInt(3, s_id);
            ps2.executeUpdate();
            ps2.close();
        }

        ps1.close();

        session.setAttribute("msg", "Subject added successfully");
        response.sendRedirect("subject.jsp?d_no=" + domainId);
        return;

    } catch(Exception e){
        out.println(e);
    }
}
%>

<!-- DELETE SUBJECT -->
<%
String deleteId = request.getParameter("delete_subject_id");

if(deleteId != null){
    PreparedStatement dps = con.prepareStatement(
        "DELETE FROM subject WHERE s_id=? AND d_no IN (SELECT d_no FROM domain WHERE user_id=?)"
    );

    dps.setInt(1, Integer.parseInt(deleteId));
    dps.setInt(2, userId);

    dps.executeUpdate();
    dps.close();

    if(d_no != null){
        response.sendRedirect("subject.jsp?d_no=" + d_no);
    } else {
        response.sendRedirect("subject.jsp");
    }
    return;
}
%>

<!-- FETCH SUBJECTS (FINAL FIXED BLOCK) -->
<%
PreparedStatement ps = null;
ResultSet rs = null;

if(d_no != null){

    ps = con.prepareStatement(
        "SELECT * FROM subject WHERE d_no=?"
    );
    ps.setInt(1, d_no);

} else {

    ps = con.prepareStatement(
        "SELECT * FROM subject WHERE d_no IN (SELECT d_no FROM domain WHERE user_id=?)"
    );
    ps.setInt(1, userId);
}

rs = ps.executeQuery();
%>
<%= "Current d_no = " + d_no %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Subjects - PKM</title>
    <link rel="stylesheet" href="css/subject.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body>
    <div class="dashboard">
        <!-- SIDEBAR - Same as dashboard/profile -->
        <aside class="sidebar">
            <div class="logo">
                <i class="fa-solid fa-brain"></i>
                <div>
                    <span>PKM</span>
                    <small>Knowledge Manager</small>
                </div>
            </div>
            <nav class="nav">
                <a href="dashboard.jsp" class="nav-item"><i class="fa-solid fa-border-all"></i> Dashboard</a>
                <a href="domain.jsp" class="nav-item"><i class="fa-regular fa-folder"></i> Domains</a>
                <a href="subject.jsp" class="nav-item active"><i class="fa-solid fa-book"></i> Subjects</a>
                <a href="resource.jsp" class="nav-item"><i class="fa-regular fa-file-lines"></i> Resources</a>
                <a href="profile.jsp" class="nav-item"><i class="fa-regular fa-user"></i> Profile</a>
            </nav>
            <a href="logout.jsp" class="logout"><i class="fa-solid fa-right-from-bracket"></i> Logout</a>
        </aside>

        <main class="main">
            <div class="page-header">
                <h1>Subjects</h1>
                <a class="btn-add" onclick="openModal()">
                    <i class="fa-solid fa-plus"></i> Add Subject
                </a>
            </div>

            <!-- Search Bar -->
            <div class="search-box">
                <i class="fa-solid fa-magnifying-glass"></i>
                <input type="text" placeholder="Search subjects..." id="searchInput">
            </div>

            <!-- Subject Cards Grid -->
            <section class="subject-grid">
                <%
                    boolean hasData = false;

                    try {
                        if(d_no != null){

                            ps = con.prepareStatement(
                                "SELECT s.s_id, s.s_name, s.description, d.d_name as domain_name, " +
                                "COALESCE( " +
                                "   (COUNT(CASE WHEN t.status='Completed' THEN 1 END) * 100.0) / " +
                                "   NULLIF(COUNT(t.t_id), 0), 0" +
                                ") as progress " +
                                "FROM subject s " +
                                "JOIN domain d ON s.d_no = d.d_no " +
                                "LEFT JOIN tracking t ON s.s_id = t.s_id AND t.user_id = ? " +
                                "WHERE d.user_id = ? AND s.d_no = ? " +
                                "GROUP BY s.s_id, s.s_name, s.description, d.d_name " +
                                "ORDER BY s.s_name"
                            );

                            ps.setInt(1, userId);
                            ps.setInt(2, userId);
                            ps.setInt(3, d_no);

                        } else {

                            ps = con.prepareStatement(
                                "SELECT s.s_id, s.s_name, s.description, d.d_name as domain_name, " +
                                "COALESCE( " +
                                "   (COUNT(CASE WHEN t.status='Completed' THEN 1 END) * 100.0) / " +
                                "   NULLIF(COUNT(t.t_id), 0), 0" +
                                ") as progress " +
                                "FROM subject s " +
                                "JOIN domain d ON s.d_no = d.d_no " +
                                "LEFT JOIN tracking t ON s.s_id = t.s_id AND t.user_id = ? " +
                                "WHERE d.user_id = ? " +
                                "GROUP BY s.s_id, s.s_name, s.description, d.d_name " +
                                "ORDER BY s.s_name"
                            );

                            ps.setInt(1, userId);
                            ps.setInt(2, userId);
                        }
                        
                        rs = ps.executeQuery();

                        while(rs.next()){
                            hasData = true;

                            int s_id = rs.getInt("s_id");
                            String sName = rs.getString("s_name");

                            String desc = rs.getString("description");
                            if(desc == null || desc.trim().isEmpty()){
                                desc = "No description";
                            }

                            String domainName = rs.getString("domain_name");
                            int progress = (int) rs.getDouble("progress");
                    %>

                <a href="resource.jsp?s_id=<%= rs.getInt("s_id") %>" class="card-link">
                <div class="card subject-card">
                    <h3><%= sName %></h3>

                    <p class="desc"><%= desc %></p>
                    <span class="tag"><%= domainName %></span>

                    <div class="subject-footer">
                        <span>Progress</span>
                        <span><%= progress %>%</span>
                    </div>

                    <div class="progress-bar">
                        <div class="progress-fill" style="width:<%= progress %>%"></div>
                    </div>

                    <form method="post" style="margin-top:10px;">
                        <input type="hidden" name="delete_subject_id" value="<%= rs.getInt("s_id") %>">
        
                        <button type="submit" class="delete-btn"
                            onclick="return confirm('Are you sure you want to delete this subject?');">
                            Delete
                        </button>
                    </form>
                </div>
                <%
                        }
                    } catch(Exception e) {
                        out.println("<div class='card' style='grid-column: 1/-1;'><p style='color:red;'>DB Error: " + e.getMessage() + "</p></div>");
                    } finally {
                        if(rs != null) rs.close();
                        if(ps != null) ps.close();
                    }
                    
                    if(!hasData){
                %>
                <div class="card" style="grid-column: 1/-1; text-align: center; padding: 60px 20px;">
                    <i class="fa-solid fa-book" style="font-size: 48px; color: #9ca3af; margin-bottom: 16px;"></i>
                    <h3 style="margin-bottom: 8px;">No subjects yet</h3>
                    <p style="color: #6b7280; margin-bottom: 20px;">Create your first subject to start learning</p>
                    <a href="addSubject.jsp" class="btn-add" style="display: inline-flex;">
                        <i class="fa-solid fa-plus"></i> Add Subject
                    </a>
                </div>
                <% } %>
            </section>
        </main>
    </div>

<script>
// Simple search filter
document.getElementById('searchInput').addEventListener('keyup', function() {
    let filter = this.value.toLowerCase();
    let cards = document.querySelectorAll('.subject-card');
    cards.forEach(card => {
        let text = card.innerText.toLowerCase();
        card.style.display = text.includes(filter) ? '' : 'none';
    });
});
</script>

<!----- Adding new subject through button ------>
<div id="subjectModal" style="display: none;">
    <div class="modal-content">

        <h2>Add Subject</h2>

        <form method="post">
            <input type="text" name="s_name" placeholder="Subject Name" required>

            <textarea name="description" placeholder="Description"></textarea>

            <select name="d_no">
                <option value="">Select Domain</option>
                <%
                    PreparedStatement dps = con.prepareStatement("SELECT d_no, d_name FROM domain WHERE user_id=?");
                    dps.setInt(1, userId);
                    ResultSet drs = dps.executeQuery();
                    while(drs.next()){
                %>
                    <option value="<%= drs.getInt("d_no") %>">
                        <%= drs.getString("d_name") %>
                    </option>
                <%
                    }
                %>
            </select>

            <select name="resource_type">
                <option value="">Select Resource Type</option>
                <option value="Video">Video</option>
                <option value="Article">Article</option>
                <option value="Book">Book</option>
            </select>

            <button type="submit">Add</button>
            <span class="close-btn" onclick="closeModal()">×</span>
        </form>
</div>

<script>
    function openModal(){
        console.log("OPEN MODAL CALLED");
        document.getElementById("subjectModal").style.display = "flex";
        document.body.style.overflow = "hidden";
    }
    function closeModal(){
        document.getElementById("subjectModal").style.display = "none";
        document.body.style.overflow = "auto";
    }

    window.onclick = function(event) {
        let modal = document.getElementById("subjectModal");
        if (event.target === modal) {
            closeModal();
        }
    }

    setTimeout(() => {
        let msg = document.querySelector(".success-msg");
        if(msg){
            msg.style.opacity = "0";
            setTimeout(() => msg.remove(), 300);
        }
    }, 2500);

    if (window.location.search.includes("msg=deleted")) {
        setTimeout(() => {
            window.history.replaceState({}, document.title, "subject.jsp");
        }, 100);
    }

</script>
</body>
</html>