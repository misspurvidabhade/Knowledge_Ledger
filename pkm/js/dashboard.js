document.addEventListener("DOMContentLoaded", function () {

    const calendar = document.getElementById("calendarDays");
    const monthYear = document.getElementById("monthYear");

    const today = new Date();

    const year = today.getFullYear();
    const month = today.getMonth();
    const date = today.getDate();

    const firstDay = new Date(year, month, 1).getDay();
    const lastDate = new Date(year, month + 1, 0).getDate();

    const months = [
        "January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December"
    ];

    monthYear.innerText = months[month] + " " + year;

    calendar.innerHTML = "";

    // Empty spaces
    for (let i = 0; i < firstDay; i++) {
        calendar.innerHTML += `<div class="calendar-day empty"></div>`;
    }

    // Dates
    for (let i = 1; i <= lastDate; i++) {
        if (i === date) {
            calendar.innerHTML += `<div class="calendar-day today">${i}</div>`;
        } else {
            calendar.innerHTML += `<div class="calendar-day">${i}</div>`;
        }
    }

});