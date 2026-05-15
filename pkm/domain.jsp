<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="db.jsp" %>

<%
PreparedStatement ps = null;
ResultSet rs = null;

Integer userId = (Integer) session.getAttribute("user_id");

if(userId == null){
    response.sendRedirect("home.jsp");
    return;
}
%>

<!-- MESSAGE -->
<%
String msg = (String) session.getAttribute("msg");
if(msg != null){
%>
    <div class="toast-msg"><%= msg %></div>
<%
    session.removeAttribute("msg");
}
%>

<!-- ADD DOMAIN -->
<%
if(request.getParameter("addDomain") != null){
    try{
        String d_name = request.getParameter("d_name");
        String desc = request.getParameter("description");

        ps = con.prepareStatement(
            "INSERT INTO domain(d_name, description, user_id) VALUES (?, ?, ?)"
        );

        ps.setString(1, d_name);
        ps.setString(2, desc);
        ps.setInt(3, userId);

        ps.executeUpdate();

        session.setAttribute("msg", "Domain added successfully");
        response.sendRedirect("domain.jsp");
        return;

    } catch(Exception e){
        out.println(e);
    }
}
%>

<!-- DELETE DOMAIN -->
<%
if(request.getParameter("deleteId") != null){
    try{
        int deleteId = Integer.parseInt(request.getParameter("deleteId"));

        ps = con.prepareStatement(
            "DELETE FROM domain WHERE d_no=? AND user_id=?"
        );

        ps.setInt(1, deleteId);
        ps.setInt(2, userId);

        ps.executeUpdate();

        session.setAttribute("msg", "Domain deleted successfully");
        response.sendRedirect("domain.jsp");
        return;

    } catch(Exception e){
        out.println(e);
    }
}
%>

<!-- EDIT DOMAIN -->
<%
if(request.getParameter("editDomain") != null){
    try{
        int d_no = Integer.parseInt(request.getParameter("d_no"));
        String d_name = request.getParameter("d_name");
        String desc = request.getParameter("description");

        ps = con.prepareStatement(
            "UPDATE domain SET d_name=?, description=? WHERE d_no=? AND user_id=?"
        );

        ps.setString(1, d_name);
        ps.setString(2, desc);
        ps.setInt(3, d_no);
        ps.setInt(4, userId);

        ps.executeUpdate();

        session.setAttribute("msg", "Domain updated successfully");
        response.sendRedirect("domain.jsp");
        return;

    } catch(Exception e){
        out.println(e);
    }
}
%>

<!-- FETCH DOMAINS -->
<%
try{
    ps = con.prepareStatement(
        "SELECT * FROM domain WHERE user_id=? ORDER BY d_no DESC"
    );

    ps.setInt(1, userId);
    rs = ps.executeQuery();

} catch(Exception e){
    out.println(e);
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Domains - PKM</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/domain.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">>
</head>
<body>
    <div class="dashboard">
        <!--SIDEBAR-->
        <aside class="sidebar">
            <div class="logo">
                <i class="fa-solid fa-brain"></i>
                <div>
                    <span>PKM</span>
                    <small>Knowledge Manager</small>
                </div>
            </div>
            <nav class="nav">
                <a href="dashboard.jsp" class="nav-item">
                    <i class="fa-solid fa-border-all"></i> Dashboard
                </a>
                <a href="domain.jsp" class="nav-item">
                    <i class="fa-regular fa-folder"></i> Domains
                </a>
                <a href="subject.jsp" class="nav-item">
                    <i class="fa-solid fa-book"></i> Subjects
                </a>
                <a href="resource.jsp" class="nav-item">
                    <i class="fa-regular fa-file-lines"></i> Resources
                </a>
                <a href="profile.jsp" class="nav-item active">
                    <i class="fa-regular fa-user"></i> Profile
                </a>
            </nav>
            <a href="logout.jsp" class="logout">
                <i class="fa-solid fa-right-from-bracket"></i> Logout
            </a>
        </aside>

        <main class="main">
            <div class="page-header">
                <h1>Domains</h1>
                <a class="btn-add" type="button" onclick="openDomainModal()">
                    <i class="fa-solid fa-plus"></i> Add Domain
                </a>
            </div>

            <!-- Search Bar -->
            <div class="search-box">
                <i class="fa-solid fa-magnifying-glass"></i>
                <input type="text" placeholder="Search domain..." id="searchInput">
            </div>

            <!-- Domain Cards Grid -->
            <section class="domain-grid">
                <%
                    try {

                        ps = con.prepareStatement(
                            "SELECT d.d_no, d.d_name, d.description, " +
                            "COUNT(s.s_id) as subject_count, " +
                            "COALESCE(AVG(CASE WHEN t.status = 'completed' THEN 100 ELSE 0 END), 0) as progress " +
                            "FROM domain d " +
                            "LEFT JOIN subject s ON d.d_no = s.d_no " +
                            "LEFT JOIN resource r ON s.s_id = r.s_id " +
                            "LEFT JOIN tracking t ON r.r_id = t.r_id AND t.user_id = ? " +
                            "WHERE d.user_id = ? " +
                            "GROUP BY d.d_no, d.d_name, d.description"
                        );

                        ps.setInt(1, userId);
                        ps.setInt(2, userId);

                        rs = ps.executeQuery();

                        if(!rs.isBeforeFirst()){
                            %>
                                <p>No domains yet. Click "Add Domain"</p>
                            <%
                        }

                        while(rs.next()){
                            String dName = rs.getString("d_name");
                            String desc = rs.getString("description");
                            if(desc == null || desc.trim().isEmpty()){
                                desc = "No description";
                            }
                            int subCount = rs.getInt("subject_count");
                            int progress = (int) rs.getDouble("progress");

                            if(desc == null) desc = "No description";
                %>


                    <div class="card domain-card">
                        <h3><%= dName %></h3>
                        <p class="desc"><%= desc %></p>

                        <div class="domain-footer">
                            <span><%= subCount %> subjects</span>
                            <span><%= progress %>%</span>
                        </div>

                        <div class="progress-bar">
                            <div class="progress-fill" style="width:<%= progress %>%"></div>
                        </div>

                        <a href="subject.jsp?d_no=<%= rs.getInt("d_no") %>" class="view-btn">
                            View Subjects
                        </a>

                        <div class="card-actions">

                            <!-- EDIT BUTTON -->
                            <button class="btn-edit"
                                onclick="openEditModal('<%= rs.getInt("d_no") %>', 
                                                    '<%= rs.getString("d_name") %>', 
                                                    '<%= rs.getString("description") %>')">
                                Edit
                            </button>

                            <!-- DELETE BUTTON -->
                            <a href="domain.jsp?deleteId=<%= rs.getInt("d_no") %>" 
                            class="btn-delete"
                            onclick="return confirm('Are you sure you want to delete this domain?');">
                                Delete
                            </a>

                        </div>
                    </div>

                <%
                        }

                    } catch(Exception e){
                        e.printStackTrace();
                    }
                %>
            </section>
        </main>
    </div>

<!-------- ADD DOMAIN --------->
    <div id="domainModal" class="modal">
        <div class="modal-content">

            <span class="close-btn" onclick="closeDomainModal()">×</span>

            <h2>Add Domain</h2>

            <form method="post">

                <input type="text" name="d_name" placeholder="Domain Name" required>

                <textarea name="description" placeholder="Description"></textarea>

                <button type="submit" name="addDomain">Add Domain</button>
                <span class="close-btn" onclick="closeModal()">×</span>
            </form>

        </div>
    </div>


<script>
// Simple search filter
document.getElementById('searchInput').addEventListener('keyup', function() {
    let filter = this.value.toLowerCase();
    let cards = document.querySelectorAll('.domain-card');
    cards.forEach(card => {
        let text = card.innerText.toLowerCase();
        card.style.display = text.includes(filter) ? '' : 'none';
    });
});


// For adding domain
function openDomainModal() {
    document.getElementById("domainModal").style.display = "flex";
}

function closeDomainModal() {
    document.getElementById("domainModal").style.display = "none";
}

/* CLICK OUTSIDE TO CLOSE */
window.onclick = function(event) {
    let modal = document.getElementById("domainModal");
    if (event.target === modal) {
        modal.style.display = "none";
    }
};

// For editing domain
function openEditModal(id, name, desc) {
    let modal = document.getElementById("editDomainModal");

    modal.style.display = "flex";

    document.getElementById("edit_d_no").value = id;
    document.getElementById("edit_d_name").value = name;
    document.getElementById("edit_desc").value = desc;
}

function closeEditModal() {
    document.getElementById("editDomainModal").style.display = "none";
}

/* CLICK OUTSIDE CLOSE */
window.onclick = function(e) {
    let modal = document.getElementById("editDomainModal");
    if (e.target === modal) {
        modal.style.display = "none";
    }
};
</script>

<!-------------- EDIT DOMAIN ------------------>
<div id="editDomainModal" style="display:none;">
    <div class="modal-content">

        <span class="close-btn" onclick="closeEditModal()">×</span>

        <h2>Edit Domain</h2>

        <form method="post">
            <input type="hidden" name="d_no" id="edit_d_no">

            <input type="text" name="d_name" id="edit_d_name" required>

            <textarea name="description" id="edit_desc"></textarea>

            <button type="submit" name="editDomain">Update</button>
            <span class="close-btn" onclick="closeModal()">×</span>
        </form>

    </div>
</div>

</body>
</html>