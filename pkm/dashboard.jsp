<%@ page import="java.sql.*" %>
<%@ include file="db.jsp" %>

<%
/* ================= SESSION CHECK ================= */
Integer userIdObj = (Integer) session.getAttribute("user_id");

if(userIdObj == null){
    response.sendRedirect("login.jsp");
    return;
}

int userId = userIdObj;

String username = (String) session.getAttribute("username");
if(username == null){
    username = "User";
}

/* ================= DECLARATIONS ================= */
PreparedStatement ps = null;
ResultSet rs = null;

/* ================= ADD NOTE ================= */
if(request.getParameter("addNote") != null){

    String title = request.getParameter("title");
    String content = request.getParameter("content");

    ps = con.prepareStatement(
        "INSERT INTO notes(title, content, user_id) VALUES (?, ?, ?)"
    );

    ps.setString(1, title);
    ps.setString(2, content);
    ps.setInt(3, userId);

    ps.executeUpdate();

    session.setAttribute("msg", "Note added successfully");
    response.sendRedirect("dashboard.jsp");
    return;
}

/* ================= ADD GOAL ================= */
if(request.getParameter("addGoal") != null){

    String g_title = request.getParameter("title");   // renamed (important)
    String desc = request.getParameter("description");
    String date = request.getParameter("target_date");

    ps = con.prepareStatement(
        "INSERT INTO goals(title, description, target_date, user_id) VALUES (?, ?, ?, ?)"
    );

    ps.setString(1, g_title);
    ps.setString(2, desc);
    ps.setString(3, date);
    ps.setInt(4, userId);

    ps.executeUpdate();

    session.setAttribute("msg", "Goal added successfully");
    response.sendRedirect("dashboard.jsp");
    return;
}

/* ================= COUNTS ================= */

// TOTAL DOMAINS
int totalDomains = 0;
ps = con.prepareStatement("SELECT COUNT(*) FROM domain WHERE user_id=?");
ps.setInt(1, userId);
rs = ps.executeQuery();
if(rs.next()) totalDomains = rs.getInt(1);

// TOTAL SUBJECTS
int totalSubjects = 0;
ps = con.prepareStatement(
    "SELECT COUNT(*) FROM subject s JOIN domain d ON s.d_no=d.d_no WHERE d.user_id=?"
);
ps.setInt(1, userId);
rs = ps.executeQuery();
if(rs.next()) totalSubjects = rs.getInt(1);

// TOTAL RESOURCES
int totalResources = 0;
ps = con.prepareStatement(
    "SELECT COUNT(*) FROM resource r JOIN subject s ON r.s_id=s.s_id JOIN domain d ON s.d_no=d.d_no WHERE d.user_id=?"
);
ps.setInt(1, userId);
rs = ps.executeQuery();
if(rs.next()) totalResources = rs.getInt(1);

// COMPLETED
int completed = 0;
ps = con.prepareStatement("SELECT COUNT(*) FROM tracking WHERE user_id=? AND status='Completed'");
ps.setInt(1, userId);
rs = ps.executeQuery();
if(rs.next()) completed = rs.getInt(1);

// PENDING
int pending = 0;
ps = con.prepareStatement("SELECT COUNT(*) FROM tracking WHERE user_id=? AND status='Pending'");
ps.setInt(1, userId);
rs = ps.executeQuery();
if(rs.next()) pending = rs.getInt(1);

// IN PROGRESS
int inProgress = 0;
ps = con.prepareStatement("SELECT COUNT(*) FROM tracking WHERE user_id=? AND status='In Progress'");
ps.setInt(1, userId);
rs = ps.executeQuery();
if(rs.next()) inProgress = rs.getInt(1);

int totalTasks = completed + pending + inProgress;

/* ================= STREAK ================= */
int streak = 0;

ps = con.prepareStatement(
    "SELECT DISTINCT completed_date FROM tracking " +
    "WHERE user_id=? AND completed_date IS NOT NULL " +
    "ORDER BY completed_date DESC"
);
ps.setInt(1, userId);
rs = ps.executeQuery();

java.time.LocalDate today = java.time.LocalDate.now();
java.time.LocalDate expectedDate = today;

while(rs.next()){
    java.sql.Date dbDate = rs.getDate("completed_date");
    java.time.LocalDate studyDate = dbDate.toLocalDate();

    if(studyDate.equals(expectedDate)){
        streak++;
        expectedDate = expectedDate.minusDays(1);
    } else {
        break;
    }
}

/* ================= PERCENTAGES ================= */
int completedPercent = 0;
int progressPercent = 0;
int pendingPercent = 0;

if(totalTasks > 0){
    completedPercent = (completed * 100) / totalTasks;
    progressPercent = (inProgress * 100) / totalTasks;
    pendingPercent = (pending * 100) / totalTasks;
}

/* ================= UPCOMING TASKS ================= */
PreparedStatement taskPs = con.prepareStatement(
    "SELECT s.s_name AS r_name, t.status, t.target_date " +
    "FROM tracking t " +
    "JOIN subject s ON t.s_id = s.s_id " +
    "JOIN domain d ON s.d_no = d.d_no " +
    "WHERE t.user_id = ? " +
    "AND t.status = 'Pending' " +
    "AND t.target_date >= CURDATE() " +
    "ORDER BY t.target_date ASC " +
    "LIMIT 5"
);

taskPs.setInt(1, userId);

rs = taskPs.executeQuery();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PKM Dashboard</title>
    <link rel="stylesheet" href="../pkm/css/dashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body>
    <div class="dashboard">
        <!-- Sidebar -->
        <aside class="sidebar">
            <div class="logo">
                <i class="fa-solid fa-brain"></i>
                <div>
                    <span>PKM</span>
                    <small>Knowledge Manager</small>
                </div>
            </div>
            <nav class="nav">
                <a href="dashboard.jsp" class="nav-item active">
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
                <a href="profile.jsp" class="nav-item">
                    <i class="fa-regular fa-user"></i> Profile
                </a>
            </nav>
            <a href="logout.jsp" class="logout">
                <i class="fa-solid fa-right-from-bracket"></i> Logout
            </a>
        </aside>

        <!-- Main Content -->
        <main class="main">
            <!-- Header -->
            <header class="header">
                <div class="welcome">
                    <h2>Welcome, <%= username %></h2>
                    <p>Here's what's happening with your knowledge today</p>
                </div>
                <div class="header-right">
                    <div class="search">
                        <i class="fa-solid fa-magnifying-glass"></i>
                        <input type="text" placeholder="Search notes, domains...">
                    </div>
                    <i class="fa-regular fa-bell notification"></i>
                    <div class="avatar">
                        <%= username.substring(0,2).toUpperCase() %>
                    </div>
                </div>
            </header>

            <!-- Stats Cards -->
            <section class="stats">
                <div class="card stat-card">
                    <div class="card-top">
                        <div class="icon blue"><i class="fa-regular fa-folder"></i></div>
                        <i class="fa-solid fa-arrow-trend-up trend"></i>
                    </div>
                    <h2><%= totalDomains %></h2>
                    <p>Total Domains</p>
                </div>
                <div class="card stat-card">
                    <div class="card-top">
                        <div class="icon purple"><i class="fa-regular fa-file-lines"></i></div>
                        <i class="fa-solid fa-arrow-trend-up trend"></i>
                    </div>
                    <h2><%= totalSubjects %></h2>
                    <p>Notes Created</p>
                </div>
                <div class="card stat-card">
                    <div class="card-top">
                        <div class="icon green"><i class="fa-solid fa-check"></i></div>
                        <i class="fa-solid fa-arrow-trend-up trend"></i>
                    </div>
                    <h2><%= completed %></h2>
                    <p>Tasks Completed</p>
                </div>
                <div class="card stat-card">
                    <div class="card-top">
                        <div class="icon red"><i class="fa-solid fa-fire"></i></div>
                        <i class="fa-solid fa-arrow-trend-up trend"></i>
                    </div>
                    <h2><%= streak %> days</h2>
                    <p>Learning Streak</p>
                </div>
            </section>

            <!-- Content Grid -->
            <section class="content-grid">
                <div class="card progress-card">
                    <h3>Overall Progress</h3>
                    <div class="progress-circle">
                        <svg>
                            <circle cx="70" cy="70" r="60" class="progress"
                                style="stroke-dashoffset: <%= 377 - (377 * completedPercent / 100) %>;">
                            </circle>
                        </svg>
                        <div class="progress-text">
                            <span><%= completedPercent %>%</span>
                            <p>Total</p>
                        </div>
                    </div>
                    <div class="legend">
                        <div><span class="dot completed"></span> Completed <%= completedPercent %>%</div>
                        <div><span class="dot in-progress"></span> In Progress <%= progressPercent %>%</div>
                        <div><span class="dot pending"></span>Pending <%= pendingPercent %>%</div>
                    </div>
                </div>

                <div class="card tasks-card">
                    <div class="card-header">
                        <h3>Upcoming Tasks</h3>
                        <a href="#">View All</a>
                    </div>
                    
                    <table>
                            <tr>
                                <th>TASK NAME</th>
                                <th>STATUS</th>
                                <th>DUE DATE</th>
                            </tr>

                        <%
                        while(rs.next()){
                        %>
                            <tr>
                                <td><%= rs.getString("r_name") %></td>
                                <td><%= rs.getString("status") %></td>
                                <td><%= rs.getDate("target_date") %></td>
                            </tr>
                        <%
                        }
                        %>

                    </table>
                </div>

                <div class="card calendar-card">
                    <h3>Calendar</h3>
                    <div class="calendar-header">
                        <span>April 2026</span>
                        <div>
                            <i class="fa-solid fa-chevron-left"></i>
                            <i class="fa-solid fa-chevron-right"></i>
                        </div>
                    </div>
                    <div class="calendar-grid">
                        <span>Sun</span><span>Mon</span><span>Tue</span><span>Wed</span><span>Thu</span><span>Fri</span><span>Sat</span>
                        <span>1</span><span>2</span><span>3</span><span>4</span><span>5</span><span>6</span><span>7</span>
                        <span>8</span><span>9</span><span>10</span><span>11</span><span>12</span><span>13</span><span>14</span>
                        <span>15</span><span>16</span><span>17</span><span>18</span><span>19</span><span class="active">20</span><span>21</span>
                        <span>22</span><span>23</span><span>24</span><span>25</span><span>26</span><span>27</span><span>28</span>
                        <span>29</span><span>30</span>
                    </div>
                </div>

                <div class="card actions-card">
                    <h3>Quick Actions</h3>
                    <button class="action-btn" onclick="openGoalModal()"><i class="fa-solid fa-plus"></i> Add Goal</button>
                    <button class="action-btn" onclick="openNoteModal()"><i class="fa-solid fa-plus"></i> Add Note</button>
                    <button class="action-btn" onclick="openDomainModal()"><i class="fa-solid fa-plus"></i> Create Domain</button>
                    <div class="tip">
                        <i class="fa-solid fa-lightbulb"></i>
                        <div>
                            <h4>Tip of the day</h4>
                            <p>Use tags to organize your notes better and find them faster!</p>
                        </div>
                    </div>
                </div>
            </section>
        </main>
    </div>

    <!------------ NOTES MODAL ------------->
<div id="noteModal" class="modal">
  <div class="modal-content">
    <span class="close-btn" onclick="closeNoteModal()">x</span>
    <h3>Add Note</h3>

    <form method="post">
      <input type="text" name="title" placeholder="Title" required>
      <textarea name="content" placeholder="Write note..." required></textarea>
      <button type="submit" name="addNote">Save</button>
    </form>
  </div>
</div>

<!---------------- GOAL MODAL -------------------------->
<div id="goalModal" class="modal">
  <div class="modal-content">
    <span class="close-btn" onclick="closeGoalModal()">x</span>
    <h3>Add Goal</h3>

    <form method="post">
      <input type="text" name="title" placeholder="Goal Title" required>
      <textarea name="description" placeholder="Description"></textarea>
      <input type="date" name="target_date" required>
      <button type="submit" name="addGoal">Save</button>
    </form>
  </div>
</div>

<!--------------------- ADD DOMAIN MODAL ----------------------->
<!-- DOMAIN MODAL -->
<div id="domainModal" class="modal">
    <div class="modal-content">
        <span class="close-btn" onclick="closeDomainModal()">x</span>
        <h2>Add Domain</h2>

        <form method="post" action="domain.jsp">
            <input type="text" name="d_name" placeholder="Domain Name" required>
            <textarea name="description" placeholder="Description"></textarea>

            <button type="submit" name="addDomain">Add Domain</button>
        </form>
    </div>
</div>

<script>
function openDomainModal() {
    document.getElementById("domainModal").style.display = "flex";
}

function closeDomainModal() {
    document.getElementById("domainModal").style.display = "none";
}

    function openNoteModal(){
    document.getElementById("noteModal").style.display = "flex";
}

function closeNoteModal(){
    document.getElementById("noteModal").style.display = "none";
}

function openGoalModal(){
    document.getElementById("goalModal").style.display = "flex";
}

function closeGoalModal(){
    document.getElementById("goalModal").style.display = "none";
}

window.onclick = function(event) {
    let modals = document.querySelectorAll(".modal");

    modals.forEach(function(modal){
        if(event.target === modal){
            modal.style.display = "none";
        }
    });
}
</script>
</body>
</html>