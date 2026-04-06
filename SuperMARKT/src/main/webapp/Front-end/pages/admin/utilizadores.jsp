<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% request.setAttribute("seccao", "Sistema"); %>
<!DOCTYPE html>
<html lang="pt-PT">
<head>
    <meta charset="UTF-8">
    <title>Gestão de Utilizadores</title>
    
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">
    
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&display=swap" rel="stylesheet">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Front-end/styles/styles.css" />
</head>
<body>
  <div class="app">
    <jsp:include page="/Front-end/pages/components/sidebar.jsp" />

    <main class="main">
        <jsp:include page="/Front-end/pages/components/topbar.jsp" />
        
        <section class="content">
            <div class="pagehead">
              <div>
                <h2 class="page-title">Gestão de Utilizadores</h2>
                <p class="page-subtitle">Lista de funcionários com acesso ao sistema (Consulta)</p>
              </div>
            </div>

            <section class="card">
                <div class="toolbar" style="display: flex; justify-content: space-between; align-items: stretch; gap: 15px;">
                    
                    <div class="search" style="flex: 1;">
                        <span class="search-ico" aria-hidden="true">⌕</span>
                        <input type="text" placeholder="Pesquisar utilizadores..." id="searchInput">
                    </div>
                    
                    <div style="display: flex; gap: 10px;">
                        <select id="cargoFilter" style="border: 1px solid #e2e8f0; border-radius: 6px; padding: 0 15px; outline: none; font-family: inherit; font-size: 14px; background: white; color: #4a5568; cursor: pointer;">
                            <option value="">Todos os Cargos</option>
                            <option value="Administrador">Administrador</option>
                            <option value="Operador de Caixa">Operador de Caixa</option>
                        </select>
                        <button class="btn-primary" id="btnFiltrar">Filtrar</button>
                    </div>
                    
                </div>
                
                <div class="table-wrap">
                    <table id="utilizadoresTable" class="table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Nome</th>
                                <th>Email</th>
                                <th>Cargo</th>
                                <th>Estado</th>
                            </tr>
                        </thead>
                        <tbody>