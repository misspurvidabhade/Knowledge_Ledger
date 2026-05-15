<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="db.jsp" %>

<%
    // ================= SESSION =================
    Integer userId = (Integer) session.getAttribute("user_id");
    String userName = (String) session.getAttribute("username");

    if(userId == null){
        response.sendRedirect("home.jsp");
        return;
    }


    // ================= VARIABLES =================
    String email = "";
    String bio = "Lifelong learner passionate about technology, design, and personal development.";

    int totalDomains = 0;
    int totalSubjects = 0;
    int totalResources = 0;
    int learningStreak = 0;

    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        
        // ================= USER EMAIL =================
        ps = con.prepareStatement("SELECT email FROM user WHERE user_id=?");
        ps.setInt(1, userId);
        rs = ps.executeQuery();

        if(rs.next()){
            email = rs.getString("email");
        }
        rs.close();
        ps.close();


        // ================= TOTAL DOMAINS =================
        ps = con.prepareStatement("SELECT COUNT(*) FROM domain WHERE user_id=?");
        ps.setInt(1, userId);
        rs = ps.executeQuery();

        if(rs.next()){
            totalDomains = rs.getInt(1);
        }
        rs.close();
        ps.close();


        // ================= TOTAL SUBJECTS =================
        ps = con.prepareStatement(
            "SELECT COUNT(*) FROM subject s " +
            "JOIN domain d ON s.d_no = d.d_no " +
            "WHERE d.user_id=?"
        );
        ps.setInt(1, userId);
        rs = ps.executeQuery();

        if(rs.next()){
            totalSubjects = rs.getInt(1);
        }
        rs.close();
        ps.close();


        // ================= TOTAL RESOURCES =================
        ps = con.prepareStatement(
            "SELECT COUNT(*) FROM resource r " +
            "JOIN subject s ON r.s_id = s.s_id " +
            "JOIN domain d ON s.d_no = d.d_no " +
            "WHERE d.user_id=?"
        );
        ps.setInt(1, userId);
        rs = ps.executeQuery();

        if(rs.next()){
            totalResources = rs.getInt(1);
        }
        rs.close();
        ps.close();


        // ================= LEARNING STREAK =================
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
                learningStreak++;
                expectedDate = expectedDate.minusDays(1);
            } else {
                break;
            }
        }

        rs.close();
        ps.close();

    } catch(Exception e){
        e.printStackTrace(); // debug safely
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile - PKM</title>
    <link rel="stylesheet" href="css/profile.css">
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
            <header class="header">
                <div class="search">
                    <i class="fa-solid fa-magnifying-glass"></i>
                    <input type="text" placeholder="Search anything...">
                </div>
                <div class="header-right">
                    <i class="fa-regular fa-bell notification"></i>
                    <div class="avatar"><%= userName.substring(0,1).toUpperCase() %></div>
                </div>
            </header>

            <!-- Profile Header Card -->
            <section class="profile-header">
                <div class="profile-avatar">
                    <img src="https://i.pravatar.cc/80" alt="Avatar">
                    <button class="edit-avatar"><i class="fa-solid fa-pen"></i></button>
                </div>
                <div class="profile-info">
                    <h1><%= userName %> <i class="fa-solid fa-pen edit-icon"></i></h1>
                    <p class="email"><%= email %></p>
                    <p class="bio"><%= bio %></p>
                </div>
            </section>
            
            <!-- Stats Cards -->
            <section class="stats">
                <div class="card stat-card">
                    <div class="stat-icon blue"><i class="fa-regular fa-folder"></i></div>
                    <div class="stat-text">
                        <h2><%= totalDomains %></h2>
                        <p>Total Domains</p>
                    </div>
                </div>
                <div class="card stat-card">
                    <div class="stat-icon purple"><i class="fa-solid fa-book"></i></div>
                    <div class="stat-text">
                        <h2><%= totalSubjects %></h2>
                        <p>Subjects</p>
                    </div>
                </div>
                <div class="card stat-card">
                    <div class="stat-icon green"><i class="fa-regular fa-file-lines"></i></div>
                    <div class="stat-text">
                        <h2><%= totalResources %></h2>
                        <p>Resources</p>
                    </div>
                </div>
                <div class="card stat-card">
                    <div class="stat-icon red"><i class="fa-solid fa-fire"></i></div>
                    <div class="stat-text">
                        <h2><%= learningStreak %> days</h2>
                        <p>Learning Streak</p>
                    </div>
                </div>
            </section>

            <!-- Account Details + Recent Activity -->
            <section class="profile-grid">
                <div class="card details-card">
                    <h3>Account Details</h3>
                    <form action="updateProfile.jsp" method="post">
                        <div class="form-row">
                            <div class="form-group">
                                <label>Full Name</label>
                                <input type="text" name="fullName" value="<%= userName %>">
                            </div>
                            <div class="form-group">
                                <label>Username</label>
                                <input type="text" name="username" value="<%= userName.toLowerCase().replace(" ", ".") %>">
                            </div>
                        </div>
                        <div class="form-group">
                            <label>Email Address</label>
                            <input type="email" name="email" value="<%= email %>">
                        </div>
                        <div class="form-group">
                            <label>Bio</label>
                            <textarea name="bio" rows="4"><%= bio %></textarea>
                        </div>

                        <h3>Change Password</h3>
                        <div class="form-group">
                            <label>Current Password</label>
                            <input type="password" name="currentPass" placeholder="Enter current password">
                        </div>
                        <div class="form-row">
                            <div class="form-group">
                                <label>New Password</label>
                                <input type="password" name="newPass" placeholder="Enter new password">
                            </div>
                            <div class="form-group">
                                <label>Confirm Password</label>
                                <input type="password" name="confirmPass" placeholder="Confirm new password">
                            </div>
                        </div>
                        <button type="submit" class="btn-save">Save Changes</button>
                    </form>
                </div>

                <div class="card activity-card">
                    <h3>Recent Activity</h3>
                    <ul class="activity-list">
                        <li>
                            <div class="activity-icon green"><i class="fa-regular fa-circle-check"></i></div>
                            <div>
                                <p><b>Completed task</b> "Review React Hooks documentation"</p>
                                <small>2 hours ago</small>
                            </div>
                        </li>
                        <li>
                            <div class="activity-icon blue"><i class="fa-regular fa-file-lines"></i></div>
                            <div>
                                <p><b>Added note</b> "Key insights from TypeScript deep dive"</p>
                                <small>5 hours ago</small>
                            </div>
                        </li>
                        <li>
                            <div class="activity-icon purple"><i class="fa-solid fa-book"></i></div>
                            <div>
                                <p><b>Started new subject</b> "Advanced CSS Grid Techniques"</p>
                                <small>1 day ago</small>
                            </div>
                        </li>
                    </ul>
                </div>
            </section>
        </main>
    </div>
</body>
</html>