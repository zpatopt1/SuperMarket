import { apiRequest } from "./api.js";

export function getProdutos() {
    return apiRequest("/produtos");
}

export function criarProduto(produto) {
    return apiRequest("/produtos", {
        method: "POST",
        body: JSON.stringify(produto)
    });
}