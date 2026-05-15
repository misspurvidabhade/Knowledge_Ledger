<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>PKM - Home</title>
    <link rel="stylesheet" href="/pkm/css/style.css?v=final">
    
</head>

<body>

<!-- NAVBAR -->
<nav class="navbar">

    <!-- LOGO -->
    <div class="logo">
        <img src="image/logo.png" alt="PKM Logo">
    </div>

    <!-- LINKS -->
    <ul class="nav-links">
        <li><a href="#">Home</a></li>
        <li><a href="#about">About</a></li>
        <li><a href="#why">Why</a></li>
        <li><a href="#journey">Journey</a></li>
        <li><a href="#stories">Stories</a></li>
        <li><a href="#contact">Contact</a></li>
    </ul>

    <!-- BUTTONS -->
    <div class="nav-buttons">
        <button class="btn-outline" onclick="openModal('login')">Login</button>
        <button class="btn-primary" onclick="openModal('register')">Register</button>
    </div>

</nav>

<!-- HERO -->
<section class="hero">

    <div class="overlay"></div>

    <div class="hero-content">
        <h1>
            Manage Your Knowledge.<br>
            Shape Your Future.
        </h1>

        <p>
            Build skills. Track progress. Become unstoppable.
        </p>

        <div class="hero-buttons">
            <button class="btn-primary" onclick="openModal('register')">Register</button>
            <button class="btn-outline" onclick="openModal('login')">Login</button>
        </div>
    </div>
</section>

<!-- INSPIRING TEXT -->
<section class="inspire">

    <div class="inspire-overlay"></div>

    <div class="inspire-content">
        <p>
            The difference between where you are and where you want to be lies in how you manage what you learn every day.
            Every piece of knowledge you capture, every skill you develop, and every insight you document becomes
            a stepping stone toward your greatest potential.
        </p>
    </div>
</section>

<!-- ABOUT -->
<section id="about" class="section about-section">

    <h2>What is Personal Knowledge Management?</h2>

    <img src="image/about.jpeg" class="about-img">

    <!-- 3 FEATURE POINTS -->
    <div class="about-features">

        <div class="about-card">
            <div class="about-icon blue">🧠</div>
            <h3>Organize Knowledge</h3>
            <p>Capture, structure, and connect your learning in a systematic way.</p>
        </div>

        <div class="about-card">
            <div class="about-icon green">📈</div>
            <h3>Track Growth</h3>
            <p>Monitor your progress, celebrate milestones, and see how far you've come.</p>
        </div>

        <div class="about-card">
            <div class="about-icon blue">🎯</div>
            <h3>Build Consistency</h3>
            <p>Develop sustainable learning habits that compound over time.</p>
        </div>

    </div>

    <!-- DESCRIPTION -->
    <p class="about-text">
        Personal Knowledge Management is the practice of consciously capturing, organizing, and developing
        your ideas, insights, and learnings. It's not just about storing information; it's about creating a system
        that helps you think better, learn faster, and achieve your goals. By building a personal knowledge base,
        you transform scattered thoughts into actionable wisdom, enabling continuous growth and mastery in
        any field you choose to pursue.
    </p>

</section>

<!-- WHY -->
<section id="why" class="section">

    <h2>Why Personal Knowledge Management?</h2>

    <div class="why-grid">

        <div class="why-card">
            <div class="why-icon blue">💡</div>
            <h3>Clarity</h3>
            <p>Know what to learn and where to focus your energy.</p>
        </div>

        <div class="why-card">
            <div class="why-icon green">📅</div>
            <h3>Consistency</h3>
            <p>Track daily progress and build lasting habits.</p>
        </div>

        <div class="why-card">
            <div class="why-icon blue">🚀</div>
            <h3>Growth</h3>
            <p>Achieve goals through systematic learning.</p>
        </div>

        <div class="why-card">
            <div class="why-icon orange">🎯</div>
            <h3>Focus</h3>
            <p>Eliminate distractions and stay on track.</p>
        </div>

        <div class="why-card">
            <div class="why-icon green">📘</div>
            <h3>Retention</h3>
            <p>Remember what you learn and apply it.</p>
        </div>

        <div class="why-card">
            <div class="why-icon blue">📈</div>
            <h3>Progress</h3>
            <p>Measure improvement and celebrate wins.</p>
        </div>

    </div>

</section>

<!-- JOURNEY -->
<section id="journey" class="section journey-section">

    <h2>Know Where You Are in Your Journey</h2>
    <p class="journey-subtitle">
        Every expert was once a beginner. Identify your current phase and take the next step forward.
    </p>

    <div class="journey-grid">

        <!-- CARD 1 -->
        <div class="journey-card">
            <div class="journey-img" style="background-image: url('image/journey1.jpeg');">
                <span class="phase phase-red">Phase 1</span>
            </div>
            <div class="journey-content">
                <h3>Directionless</h3>
                <p>
                    Feeling overwhelmed and unsure where to start. Multiple interests, scattered focus,
                    and no clear path forward.
                </p>
            </div>
        </div>

        <!-- CARD 2 -->
        <div class="journey-card">
            <div class="journey-img" style="background-image: url('image/journey2.jpeg');">
                <span class="phase phase-yellow">Phase 2</span>
            </div>
            <div class="journey-content">
                <h3>Learning</h3>
                <p>
                    Building momentum with structured learning. Developing systems, tracking progress,
                    and seeing tangible improvements.
                </p>
            </div>
        </div>

        <!-- CARD 3 -->
        <div class="journey-card">
            <div class="journey-img" style="background-image: url('image/journey3.jpeg');">
                <span class="phase phase-green">Phase 3</span>
            </div>
            <div class="journey-content">
                <h3>Mastery</h3>
                <p>
                    Achieving expertise and becoming a thought leader. Your knowledge compounds,
                    and you inspire others on their journey.
                </p>
            </div>
        </div>
    </div>
</section>

<!-- STORIES -->
<section id="stories" class="section stories-section">

    <h2>Great Minds Who Managed Their Knowledge</h2>
    <p class="stories-subtitle">
        History's greatest achievers all had one thing in common: they mastered the art of learning and knowledge management.
    </p>

    <div class="stories-grid">

        <!-- CARD 1 -->
        <div class="story-card">
            <img src="image/kalam.jpeg" class="story-img">
            <h3>Dr. A.P.J Abdul Kalam</h3>
            <span>Aerospace Scientist & President of India</span>
            <p>
                The Missile Man of India who transformed from humble beginnings
                to President through relentless learning and knowledge management.
            </p>
        </div>

        <!-- CARD 2 -->
        <div class="story-card">
            <img src="image/musk.jpeg" class="story-img">
            <h3>Elon Musk</h3>
            <span>CEO of Tesla & SpaceX</span>
            <p>
                Built multiple billion-dollar companies by systematically learning
                complex subjects from first principles.
            </p>
        </div>

        <!-- CARD 3 -->
        <div class="story-card">
            <img src="image/buffett.jpeg" class="story-img">
            <h3>Warren Buffett</h3>
            <span>Legendary Investor</span>
            <p>
                Reads 500 pages daily, attributing his investment success to continuous
                learning and knowledge accumulation.
            </p>
        </div>

        <!-- CARD 4 -->
        <div class="story-card">
            <img src="image/curie.jpeg" class="story-img">
            <h3>Marie Curie</h3>
            <span>Nobel Prize Winner in Physics & Chemistry</span>
            <p>
                First person to win Nobel Prizes in two different sciences through
                meticulous research and documentation.
            </p>
        </div>

        <!-- CARD 5 -->
        <div class="story-card">
            <img src="image/davinci.jpeg" class="story-img">
            <h3>Leonardo da Vinci</h3>
            <span>Renaissance Polymath</span>
            <p>
                Master of multiple disciplines who filled thousands of notebook pages
                with observations, sketches, and ideas.
            </p>
        </div>
    </div>
</section>

<!-- QUOTE -->
<section class="quote-section">
    <div class="quote-container">
        <div class="quote-overlay"></div>
        <div class="quote-icon">❝</div>

        <p class="quote-text">
            An investment in knowledge pays the best interest.
        </p>

        <p class="quote-author">
            — Benjamin Franklin
        </p>
    </div>
</section>

<!-- CONTACT -->
<section id="contact" class="contact-section">
    <div class="contact-container">

        <h2>Get in Touch</h2>

        <p class="contact-subtitle">
            Personal Knowledge Management System
        </p>

        <div class="contact-details">
            <p>
                <span>Email:</span> 
                <a href="mailto:pkmsystem@gmail.com">pkmsystem@gmail.com</a>
            </p>

            <p>
                <span>Contact:</span> 
                <a href="tel:+919087654321">+91 9087654321</a>
            </p>
        </div>
    </div>
</section>

<!-- FOOTER -->
<footer class="footer">
    <div class="footer-container">

        <h2 class="footer-logo">PKM</h2>

        <p class="footer-subtitle">
            Personal Knowledge Management System | Privacy Policy
        </p>

        <p class="footer-copy">
            © 2026 PKM. All rights reserved.
        </p>
    </div>
</footer>

<div id="modal" class="modal">

    <div class="modal-box">

        <span class="close" onclick="closeModal()">×</span>

        <!-- TABS -->
        <div class="tabs">
            <span id="loginTab" onclick="showTab('login')" class="active">Login</span>
            <span id="registerTab" onclick="showTab('register')">Register</span>
        </div>

        <!-- LOGIN FORM -->
        <form id="loginForm" class="form active" action="login.jsp" method="post">
            <input type="text" name="username" placeholder="Username" required>
            <input type="password" name="password" placeholder="Password" required>

            <button type="submit" class="primary-btn">Login</button>
            <p id="loginMsg"></p>
        </form>

        <!-- REGISTER FORM -->
        <form id="registerForm" class="form" action="register.jsp" method="post">
            <input type="text" name="user_name" placeholder="Full Name" required>
            <input type="text" name="username" placeholder="Username" required>
            <input type="password" name="password" placeholder="Password" required>

            <button type="submit" class="primary-btn">Register</button>
            <p id="registerMsg"></p>
        </form>
    </div>
</div>
<script src="js/script.js"></script>

</body>
</html>