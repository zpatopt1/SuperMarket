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
  <title>SuperMart â¢ Consultar Stock</title>

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
            <p class="page-subtitle">GestÃ£o e consulta de inventÃ¡rio</p>
          </div>

          <button class="btn-primary" type="button">Exportar RelatÃ³rio</button>
        </div>

        <!-- KPIs -->
        <div class="kpis kpis-stock">
          <div class="kpi">
            <div class="kpi-label">Total Produtos</div>
            <div class="kpi-value">8</div>
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
            <div class="kpi-value">1913.32 <span>â¬</span></div>
          </div>
        </div>

        <!-- Search + filter -->		
		<form action="${pageContext.request.contextPath}/ProdutoServlet" method="get" class="toolbar">
		    <div class="search">
		      <span class="search-ico" aria-hidden="true">⌕</span>
		      <input type="text" name="txtNome" placeholder="Pesquisar por nome..." 
		             value="<%= request.getParameter("txtNome") != null ? request.getParameter("txtNome") : "" %>" />
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
		    <button type="submit" class="btn-primary" >Filtrar</button>
		  </form>

        <!-- Table -->
		<section class="card">
          <div class="table-wrap">
            <table class="table">
              <thead>
                <tr>
                  <th>Código</th>
                  <th>Produto</th>
                  <th>Categoria</th>
                  <th>Marca</th>
                  <th>Unidade</th>
                  <th>Código de Barras</th>
                  <th>Preço</th>
                </tr>
              	</thead>  
				<tbody>
			    <%
			      // Tenta apanhar a lista que a Servlet enviou
			      List<Produto> produtos = (List<Produto>) request.getAttribute("produtos");
			
			      // Se for nulo (acesso direto ao JSP), carregamos tudo por segurança
			      if (produtos == null) {
			          ProdutoDAO daoDefault = new ProdutoDAO();
			          produtos = daoDefault.getAllProdutos();
			      }
		            
                  if (produtos != null && !produtos.isEmpty()) {
                      for (Produto p : produtos) {
                      
			    %>
			    <tr>
			      <td><%= p.getIdProduto() %></td>
			      <td><%= p.getNome() %></td>
			      <td>
			        <span class="pill"><%= p.getCategoria().getNome() %></span>
			      </td>
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
        </section>
        
    </main>
  </div>
</body>
<script type="module" src="/SuperMARKT/Front-end/js/pages/dashboard.js"></script>
</html>



