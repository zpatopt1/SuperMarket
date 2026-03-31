export function activateSidebar() {
    const links = document.querySelectorAll(".nav-item");
    const currentPath = window.location.pathname;

    links.forEach(link => {
        const linkPath = new URL(link.href).pathname;
        if (currentPath === linkPath) {
            link.classList.add("active");
        }
    });
}		