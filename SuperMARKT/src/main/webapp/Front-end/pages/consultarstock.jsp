<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Produto" %>
<%@ page import="model.ProdutoDAO" %>
<%@ page import="model.Categoria" %>
<%--<%@ page import="model.CategoriaDAO" %> --%>

<!doctype html>
<html lang="pt-PT">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <title>Consultar Stock</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/Front-end/styles/styles.css" />
</head>
<body>
  <div class="app">
	<!-- Sidebar -->
	<jsp:include page="/Front-end/pages/components/sidebar.jsp" />

    <!-- Main -->
    <main class="main">

	<!-- Topbar -->
	<jsp:include page="/Front-end/pages/components/topbar.jsp" />
      <section class="content">
        <!-- Page header -->
        <div class="pagehead">
          <div>
            <h2 class="page-title">Consultar Stock</h2>
            <p class="page-subtitle">Gestão e consulta de inventário</p>
          </div>

          <button class="btn-primary" type="button">Exportar Relatorio</button>
        </div>
		
        <!-- KPIs -->
        <div class="kpis kpis-stock">
          <div class="kpi">
            <div class="kpi-label">Total Produtos</div>
            <div class="kpi-value"><%= request.getAttribute("totalProdutos")%></div>
          </div>

          <div class="kpi">
            <div class="kpi-label">Stock Armazem</div>
            <div class="kpi-value">3</div>
          </div>

          <div class="kpi">
            <div class="kpi-label">Stock Loja</div>
            <div class="kpi-value">200</div>
          </div>

          <div class="kpi">
            <div class="kpi-label">Valor Total</div>
            <div class="kpi-value">1913.32 $</div>
          </div>
        </div>

		<div class="card">
        <!-- Search + filter -->		
		<form action="${pageContext.request.contextPath}/ProdutoServlet" method="get" class="toolbar">
        <div class="search">
            <span class="search-ico" aria-hidden="true">⌕</span>
            <input type="text" name="txtNome" placeholder="Pesquisar por nome..." 
                   value="<%= request.getParameter("txtNome") != null ? request.getParameter("txtNome") : "" %>" />
        </div>
        <button type="submit" class="btn-primary"">Filtrar</button>
        </form>
        </div>
		    
		    
<%-- 
    <select name="selCategoria" class="filterbtn" onchange="this.form.submit()">
        <option value="0">Todas as Categorias</option>
        <%
            CategoriaDAO catDao = new CategoriaDAO();
            List<Categoria> listaCategorias = catDao.getAllCategorias();
            String catSelecionada = request.getParameter("selCategoria");

            for (Categoria c : listaCategorias) {
                String selectedAttr = String.valueOf(c.getIdCategoria()).equals(catSelecionada) ? "selected" : "";
        %>
            <option value="<%= c.getIdCategoria() %>" <%= selectedAttr %>>
                <%= c.getNome() %>
            </option>
        <%
            }
        %>
    </select>
--%>
        <!-- Table -->
		<section class="card">
          <div class="table-wrap">
            <table class="table">
            <thead>
			<tr>
			<th class="<%= "id_produto".equals(request.getParameter("orderBy")) ? "active" : "" %>">
			    <a href="?txtNome=<%= request.getParameter("txtNome") != null ? request.getParameter("txtNome") : "" %>&orderBy=id_produto&orderDir=<%= "id_produto".equals(request.getParameter("orderBy")) && "ASC".equals(request.getParameter("orderDir")) ? "DESC" : "ASC" %>">
			        Código
			        <% if ("id_produto".equals(request.getParameter("orderBy"))) { %>
			            <%= "ASC".equals(request.getParameter("orderDir")) ? "▲" : "▼" %>
			        <% } %>
			    </a>
			  </th>
			
			<th class="<%= "nome".equals(request.getParameter("orderBy")) ? "active" : "" %>">
			    <a href="?txtNome=<%= request.getParameter("txtNome") != null ? request.getParameter("txtNome") : "" %>&orderBy=nome&orderDir=<%= "nome".equals(request.getParameter("orderBy")) && "ASC".equals(request.getParameter("orderDir")) ? "DESC" : "ASC" %>">
			        Produto
			        <% if ("nome".equals(request.getParameter("orderBy"))) { %>
			            <%= "ASC".equals(request.getParameter("orderDir")) ? "▲" : "▼" %>
			        <% } %>
			    </a>
			  </th>
			
			  <th>Categoria</th> 
			
			<th class="<%= "marca".equals(request.getParameter("orderBy")) ? "active" : "" %>">
			    <a href="?txtNome=<%= request.getParameter("txtNome") != null ? request.getParameter("txtNome") : "" %>&orderBy=marca&orderDir=<%= "marca".equals(request.getParameter("orderBy")) && "ASC".equals(request.getParameter("orderDir")) ? "DESC" : "ASC" %>">
			        Marca
			        <% if ("marca".equals(request.getParameter("orderBy"))) { %>
			            <%= "ASC".equals(request.getParameter("orderDir")) ? "▲" : "▼" %>
			        <% } %>
			    </a>
			  </th>
			
			<th class="<%= "unidade_medida".equals(request.getParameter("orderBy")) ? "active" : "" %>">
			    <a href="?txtNome=<%= request.getParameter("txtNome") != null ? request.getParameter("txtNome") : "" %>&orderBy=unidade_medida&orderDir=<%= "unidade_medida".equals(request.getParameter("orderBy")) && "ASC".equals(request.getParameter("orderDir")) ? "DESC" : "ASC" %>">
			        Unidade
			        <% if ("unidade_medida".equals(request.getParameter("orderBy"))) { %>
			            <%= "ASC".equals(request.getParameter("orderDir")) ? "▲" : "▼" %>
			        <% } %>
			    </a>
			  </th>
			
			<th class="<%= "cod_barras".equals(request.getParameter("orderBy")) ? "active" : "" %>">
			    <a href="?txtNome=<%= request.getParameter("txtNome") != null ? request.getParameter("txtNome") : "" %>&orderBy=cod_barras&orderDir=<%= "cod_barras".equals(request.getParameter("orderBy")) && "ASC".equals(request.getParameter("orderDir")) ? "DESC" : "ASC" %>">
			        Código de Barras
			        <% if ("cod_barras".equals(request.getParameter("orderBy"))) { %>
			            <%= "ASC".equals(request.getParameter("orderDir")) ? "▲" : "▼" %>
			        <% } %>
			    </a>
			  </th>
			
			<th class="<%= "preco".equals(request.getParameter("orderBy")) ? "active" : "" %>">
			    <a href="?txtNome=<%= request.getParameter("txtNome") != null ? request.getParameter("txtNome") : "" %>&orderBy=preco&orderDir=<%= "preco".equals(request.getParameter("orderBy")) && "ASC".equals(request.getParameter("orderDir")) ? "DESC" : "ASC" %>">
			        Preço
			        <% if ("preco".equals(request.getParameter("orderBy"))) { %>
			            <%= "ASC".equals(request.getParameter("orderDir")) ? "▲" : "▼" %>
			        <% } %>
			    </a>
			  </th>
			</tr>
			</thead>
			<tbody>
			   <%
				List<Produto> produtos = (List<Produto>) request.getAttribute("produtos");
				if (produtos != null && !produtos.isEmpty()) {
				    for (Produto p : produtos) {
				%>
				<tr>
				  <td><%= p.getIdProduto() %></td>
				  <td><%= p.getNome() %></td>
				  <td><span class="pill"><%= p.getCategoria().getNome() %></span></td>
				  <td><%= p.getMarca() %></td>
				  <td><%= p.getUnidadeMedida() %></td>
				  <td><%= p.getCodBarras() %></td>
				  <td><%= String.format("%.2f", p.getPreco()) %>€</td>
				</tr>
				<%
				    }
				} else {
				%>
				<tr><td colspan="7" style="text-align:center;">Nenhum produto encontrado.</td></tr>
				<%
				}
				%>
			</tbody>
            </table>
          </div>
<!-- Pagination buttons -->
<div class="pagination">
    <% 
        Integer currentPage = (Integer) request.getAttribute("currentPage");
        Integer totalPages = (Integer) request.getAttribute("totalPages");
        String txtNome = request.getParameter("txtNome") != null ? request.getParameter("txtNome") : "";
        String orderBy = request.getParameter("orderBy") != null ? request.getParameter("orderBy") : "";
        String orderDir = request.getParameter("orderDir") != null ? request.getParameter("orderDir") : "";
        
        if (totalPages != null && totalPages > 1) {
    %>
    
    <!-- Botão Anterior -->
    <% if (currentPage > 1) { %>
        <a class="page-btn" href="?txtNome=<%= txtNome %>&orderBy=<%= orderBy %>&orderDir=<%= orderDir %>&page=<%= currentPage - 1 %>">« Anterior</a>
    <% } else { %>
        <span class="page-btn disabled">« Anterior</span>
    <% } %>

    <!-- Botões de página  -->
    <%
        int startPage = Math.max(1, currentPage - 2);
        int endPage = Math.min(totalPages, currentPage + 2);
        for (int i = startPage; i <= endPage; i++) {
            if (i == currentPage) {
    %>
        <span class="page-btn current"><%= i %></span>
    <%  } else { %>
        <a class="page-btn" href="?txtNome=<%= txtNome %>&orderBy=<%= orderBy %>&orderDir=<%= orderDir %>&page=<%= i %>"><%= i %></a>
    <%      }
        }
    %>

    <!-- Botão Próximo -->
    <% if (currentPage < totalPages) { %>
        <a class="page-btn" href="?txtNome=<%= txtNome %>&orderBy=<%= orderBy %>&orderDir=<%= orderDir %>&page=<%= currentPage + 1 %>">Próximo »</a>
    <% } else { %>
        <span class="page-btn disabled">Próximo »</span>
    <% } %>

    <% } %>
</div>
 
        </section>
        
    </main>
  </div>
</body>
<script type="module" src="/SuperMARKT/Front-end/js/pages/dashboard.js"></script>
</html>



