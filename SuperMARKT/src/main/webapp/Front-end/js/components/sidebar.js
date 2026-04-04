export function activateSidebar() {
    const links = document.querySelectorAll(".nav-item");
    const currentPath = window.location.pathname;

    links.forEach(link => {
        const linkPath = new URL(link.href).pathname;
        if (currentPath === linkPath) {
            link.classList.add("active");
        }
    });
	
	const sidebar = document.querySelector('.sidebar');
	const toggleBtn = document.getElementById('toggleBtn');
	const toggleBtnInside = document.getElementById('toggleBtn-inside');
	

	// Ao clicar em qualquer toggle, abre/fecha a sidebar
	[toggleBtn, toggleBtnInside].forEach(btn => {
	    btn?.addEventListener('click', () => {
	        sidebar.classList.toggle('open');
	        document.body.classList.toggle('sidebar-open');
	    });
	});
	}
	
/* 
const sidebar = document.querySelector('.sidebar');
const toggleBtn = document.getElementById('toggleBtn');
const toggleBtnInside = document.getElementById('toggleBtn-inside');
const titulo = document.getElementById("mostrar");

function updateTituloVisibility() {
    const isToggleVisible = toggleBtn && toggleBtn.offsetParent !== null;

    if (isToggleVisible) {
        titulo?.classList.add("hidden");
    } else {
        titulo?.classList.remove("hidden");
    }
}

// Inicial
updateTituloVisibility();

// Atualiza se a janela mudar de tamanho
window.addEventListener('resize', updateTituloVisibility);

// Toggle da sidebar
toggleBtn?.addEventListener('click', () => {
    sidebar.classList.toggle('open');
    document.body.classList.toggle('sidebar-open');
});

toggleBtnInside?.addEventListener('click', () => {
    sidebar.classList.toggle('open');
    document.body.classList.toggle('sidebar-open');
});
*/
