
console.log("JS RUNNING");
// FADE-IN ON SCROLL
const elements = document.querySelectorAll('.fade');

function showOnScroll() {
    elements.forEach(el => {
        const top = el.getBoundingClientRect().top;
        if (top < window.innerHeight - 100) {
            el.classList.add('show');
        }
    });
}

window.addEventListener('scroll', showOnScroll);
window.addEventListener('load', showOnScroll);


// ---------------- MODAL ----------------
// DEBUG
console.log("JS WORKING");

// OPEN MODAL
function openModal(type) {
    console.log("OPEN CLICKED");

    document.getElementById("modal").style.display = "flex";

    if(type === "login"){
        document.getElementById("loginForm").classList.add("active");
        document.getElementById("registerForm").classList.remove("active");
    } else {
        document.getElementById("registerForm").classList.add("active");
        document.getElementById("loginForm").classList.remove("active");
    }
}

// CLOSE MODAL
function closeModal() {
    console.log("CLOSE CLICKED");
    document.getElementById("modal").style.display = "none";
}


function openModal(type) {
    document.getElementById("modal").style.display = "flex";
    document.body.classList.add("modal-open");
    showTab(type);
}

function closeModal() {
    document.getElementById("modal").style.display = "none";
    document.body.classList.remove("modal-open");
}

// CLICK OUTSIDE
window.onclick = function(event) {
    const modal = document.getElementById("modal");

    if (event.target === modal) {
        console.log("OUTSIDE CLICK");
        closeModal();
    }
};

//CLOSE ON ESC KEY
document.addEventListener("keydown", function(e){
    if(e.key === "Escape"){
        closeModal();
    }
});

// SWITCH TAB
function showTab(tab){
    document.getElementById("loginMsg").innerText = "";
    document.getElementById("registerMsg").innerText = "";

    const loginForm = document.getElementById("loginForm");
    const registerForm = document.getElementById("registerForm");

    const loginTab = document.getElementById("loginTab");
    const registerTab = document.getElementById("registerTab");

    loginForm.classList.remove("active");
    registerForm.classList.remove("active");
    loginTab.classList.remove("active");
    registerTab.classList.remove("active");

    if(tab === "login"){
        loginForm.classList.add("active");
        loginTab.classList.add("active");
    } else {
        registerForm.classList.add("active");
        registerTab.classList.add("active");
    }
}

document.addEventListener("DOMContentLoaded", function(){

    console.log("JS LOADED");

    const params = new URLSearchParams(window.location.search);

    const login = params.get("login");
    const register = params.get("register");

    if(register === "success"){
        openModal('login');

        const msg = document.getElementById("loginMsg");
        if(msg){
            msg.innerText = "Registered successfully! Login now.";
            msg.className = "success-msg";
        }
    }

    if(register === "exists"){
        openModal('register');

        const msg = document.getElementById("registerMsg");
        if(msg){
            msg.innerText = "User already exists! Login?";
            msg.className = "error-msg";
        }
    }

    if(login === "invalid"){
        openModal('login');

        const msg = document.getElementById("loginMsg");
        if(msg){
            msg.innerText = "Invalid username or password";
            msg.className = "error-msg";
        }
    }

    // clean URL
    if(login || register){
        window.history.replaceState({}, document.title, "home.jsp");
    }

});

//--------------------- JS for Dashboard ------------------------

// highlight active menu
const menuItems = document.querySelectorAll(".menu li");

menuItems.forEach(item => {
    item.addEventListener("click", () => {
        document.querySelector(".menu .active").classList.remove("active");
        item.classList.add("active");
    });
});