// js/pages/components/topbar.js
export async function loadTopbar() {
    const response = await fetch("/Front-end/pages/components/topbar.html"); // caminho correto para o teu caso
    const html = await response.text();

    document.getElementById("topbar").innerHTML = html;
}