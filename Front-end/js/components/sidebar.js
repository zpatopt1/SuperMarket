export async function loadSidebar() {
    const response = await fetch("/Front-end/pages/components/sidebar.html");
    const html = await response.text();

    document.getElementById("sidebar").innerHTML = html;
}