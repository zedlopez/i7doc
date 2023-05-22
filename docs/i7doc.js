function pasteCode(text) { Navigator.clipboard.writeText(text); }
function copyCode(text) { Navigator.clipboard.writeText(text); }

window.addEventListener("load", function(e) { let el = document.getElementById('current_year'); el.innerHTML = new Date().getFullYear(); }, false);
