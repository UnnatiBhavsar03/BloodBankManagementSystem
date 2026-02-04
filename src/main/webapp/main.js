/**
 * 
 */document.addEventListener("DOMContentLoaded", function () {
    loadComponent("header.html", "header-container");
    loadComponent("footer.html", "footer-container");
	loadComponent("adminheader.html", "adminheader-container");
	loadComponent("donorheader.html", "donorheader-container"); 
	loadComponent("recipientheader.html", "recipientheader-container");  
});

function loadComponent(url, containerId) {
    fetch(url)
        .then(response => response.text())
        .then(data => document.getElementById(containerId).innerHTML = data)
        .catch(error => console.error("Error loading component:", error));
}
