function copyCode(text) { navigator.clipboard.writeText(text); }
function pasteCode(text) { navigator.clipboard.writeText(text); }

window.addEventListener("load", function(e) { let el = document.getElementById('current_year'); el.innerHTML = new Date().getFullYear(); }, false);
