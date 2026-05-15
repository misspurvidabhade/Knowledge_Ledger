<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.time.*, java.time.format.DateTimeFormatter" %>
<%@ include file="db.jsp" %>
<%
    Integer userId = (Integer) session.getAttribute("user_id");
    String userName = (String) session.getAttribute("username");

    if(userId == null){ response.sendRedirect("home.jsp"); return; }
    
    String filter = request.getParameter("filter");
    if(filter == null) filter = "all";
%>

<%
String sidParam = request.getParameter("s_id");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Resources - PKM</title>
    <link rel="stylesheet" href="css/resource.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body>
    <div class="dashboard">
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
                <a href="subject.jsp" class="nav-item"><i class="fa-solid fa-book"></i> Subjects</a>
                <a href="resource.jsp" class="nav-item active"><i class="fa-regular fa-file-lines"></i> Resources</a>
                <a href="profile.jsp" class="nav-item"><i class="fa-regular fa-user"></i> Profile</a>
            </nav>
            <a href="logout.jsp" class="logout"><i class="fa-solid fa-right-from-bracket"></i> Logout</a>
        </aside>

        <main class="main">
            <div class="page-header">
                <h1>Resources</h1>
                <a href="addResource.jsp" class="btn-add">
                    <i class="fa-solid fa-plus"></i> Add Resource
                </a>
            </div>

            <div class="search-box">
                <i class="fa-solid fa-magnifying-glass"></i>
                <input type="text" placeholder="Search notes..." id="searchInput">
            </div>

            <div class="filter-tabs">
                <a href="notes.jsp?filter=all" class="tab <%= filter.equals("all") ? "active" : "" %>">All</a>
                <a href="notes.jsp?filter=completed" class="tab <%= filter.equals("completed") ? "active" : "" %>">Completed</a>
                <a href="notes.jsp?filter=in-progress" class="tab <%= filter.equals("in-progress") ? "active" : "" %>">In Progress</a>
                <a href="notes.jsp?filter=pending" class="tab <%= filter.equals("pending") ? "active" : "" %>">Pending</a>
            </div>

            <section class="notes-grid">
                <%
                    PreparedStatement ps = null;
                    ResultSet rs = null;
                    boolean hasData = false;
                    DateTimeFormatter dtf = DateTimeFormatter.ofPattern("MMM dd, yyyy");

                    try {
                        // con comes from db.jsp - don't redeclare it

                        String sql = "SELECT r.r_id, r.r_name, r.type, r.link, s.s_name AS subject_name, " +
                                    "COALESCE(t.status, 'pending') AS status, t.completed_date " +
                                    "FROM resource r " +
                                    "JOIN subject s ON r.s_id = s.s_id " +
                                    "JOIN domain d ON s.d_no = d.d_no " +
                                    "LEFT JOIN tracking t ON r.r_id = t.r_id AND t.user_id = ? " +
                                    "WHERE d.user_id = ? ";

                        if(sidParam != null){
                            sql += "AND r.s_id = ? ";
                        }

                        sql += "ORDER BY t.completed_date DESC, r.r_id DESC";

                        ps = con.prepareStatement(sql);

                        ps.setInt(1, userId);
                        ps.setInt(2, userId);

                        if(sidParam != null){
                            ps.setInt(3, Integer.parseInt(sidParam));
                        }

                        rs = ps.executeQuery();
                        while(rs.next()){
                            hasData = true;
                            String rName = rs.getString("r_name");
                            String subjectName = rs.getString("subject_name");
                            String type = rs.getString("type");
                            String status = rs.getString("status");
                            java.sql.Date completedDate = rs.getDate("completed_date");

                            if(type == null) type = "Article";
                            
                            String icon = "fa-file-lines";
                            if(type.equalsIgnoreCase("video")) icon = "fa-video";
                            else if(type.equalsIgnoreCase("pdf")) icon = "fa-file-pdf";
                            else if(type.equalsIgnoreCase("link")) icon = "fa-link";

                            String statusClass = "pending";
                            String statusIcon = "fa-circle";
                            if("completed".equals(status)){ 
                                statusClass = "completed"; 
                                statusIcon = "fa-circle-check"; 
                            } else if("in-progress".equals(status)){ 
                                statusClass = "in-progress"; 
                                statusIcon = "fa-clock"; 
                            }
                %>
                <div class="card note-card">
                    <div class="note-header">
                        <div class="note-icon"><i class="fa-solid <%= icon %>"></i></div>
                        <div>
                            <h3><%= rName %></h3>
                            <p class="subject-name"><%= subjectName %></p>
                        </div>
                    </div>
                    <div class="note-footer">
                        <span class="note-type"><%= type %></span>
                        <span class="status-badge <%= statusClass %>">
                            <i class="fa-regular <%= statusIcon %>"></i> <%= status.substring(0,1).toUpperCase() + status.substring(1) %>
                        </span>
                        <% if(completedDate != null) { %>
                        <span class="note-date"><%= dtf.format(completedDate.toLocalDate()) %></span>
                        <% } %>
                    </div>
                </div>
                <%
                        }
                    } catch(Exception e) {
                        out.println("<div class='card' style='grid-column: 1/-1;'><p style='color:red;'>DB Error: " + e.getMessage() + "</p></div>");
                    } finally {
                        if(rs != null) try { rs.close(); } catch(Exception e) {}
                        if(ps != null) try { ps.close(); } catch(Exception e) {}
                        // Don't close con here - db.jsp handles it
                    }
                    
                    if(!hasData){
                %>
                <div class="card" style="grid-column: 1/-1; text-align: center; padding: 60px 20px;">
                    <i class="fa-regular fa-file-lines" style="font-size: 48px; color: #9ca3af; margin-bottom: 16px;"></i>
                    <h3 style="margin-bottom: 8px;">No resources found</h3>
                    <p style="color: #6b7280; margin-bottom: 20px;">Start adding resources to track your study material.</p>
                    <a href="addResource.jsp" class="btn-add" style="display: inline-flex;">
                        <i class="fa-solid fa-plus"></i> Add Resource
                    </a>
                </div>
                <% } %>
            </section>
        </main>
    </div>

<script>
document.getElementById('searchInput').addEventListener('keyup', function() {
    let filter = this.value.toLowerCase();
    let cards = document.querySelectorAll('.note-card');
    cards.forEach(card => {
        let text = card.innerText.toLowerCase();
        card.style.display = text.includes(filter) ? '' : 'none';
    });
});
</script>
</body>
</html>