// helpers generales 
function isEmpty(value) {
    return value === null || value === undefined || (String(value).trim() === "");
}

function isValidEmail(email) {
    if (isEmpty(email)) return false;
    email = String(email).trim();
    var re = /^[^\s@]+@[^\s@]+\.[^\s@]{2,}$/i;
    return re.test(email);
}

function setMessage(targetId, message, isOk) {
    var el = document.getElementById(targetId);
    if (!el) return;

    el.className = "msg " + (isOk ? "msg-ok" : "msg-error");
    el.innerText = message;
    el.style.display = "block";
}

function clearMessage(targetId) {
    var el = document.getElementById(targetId);
    if (!el) return;
    el.style.display = "none";
    el.innerText = "";
    el.className = "msg";
}

function toLocalIsoMinute(date) {
    // yyyy-MM-ddTHH:mm
    var pad = n => String(n).padStart(2, '0');
    return date.getFullYear() + "-" + pad(date.getMonth() + 1) + "-" + pad(date.getDate()) +
        "T" + pad(date.getHours()) + ":" + pad(date.getMinutes());
}