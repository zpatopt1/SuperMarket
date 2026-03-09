import { loadSidebar } from "../components/sidebar.js";
import { loadTopbar } from "../components/topbar.js";
import { getProdutos } from "../api/produtos.js";

loadSidebar();
loadTopbar();


getProdutos().then(data => {
    console.log(data);
});