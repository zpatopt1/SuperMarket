<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% request.setAttribute("seccao", "Gestão de Produtos"); %>

<%@ page import="java.util.List" %>
<%@ page import="model.Produto" %>
<%@ page import="DAO.ProdutoDAO" %>
<%@ page import="model.Categoria" %>
<%
  List<Categoria> categorias = (List<Categoria>) request.getAttribute("categorias");
  String txtNome = (String) request.getAttribute("txtNome");
  String orderBy = (String) request.getAttribute("orderBy");
  String orderDir = (String) request.getAttribute("orderDir");
%>

<!doctype html>
<html lang="pt-PT">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <title>Produtos</title>
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
            <h2 class="page-title">Produtos</h2>
            <p class="page-subtitle">Gestão do catálogo de produtos</p>
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
            <div class="kpi-value">1913.32 €</div>
          </div>
        </div>


        <section class="card">
          <!-- Search + filter -->   
          <form action="${pageContext.request.contextPath}/ConsultarProdutosServlet" method="get" class="toolbar">
            <div class="search">
              <span class="search-ico" aria-hidden="true">⌕</span>
              <input type="text" name="txtNome" placeholder="Pesquisar por nome..." value="<%=txtNome %>" />
            </div>
            <button type="submit" class="btn-primary">Filtrar</button>
            <button class="btn-primary" type="button" onclick="abrirModalAddProduto()">Adicionar Produto</button>

          </form>

          <!-- Table -->
          <div class="table-wrap">
            <table class="table">
              <thead>
                <tr>
                  <th class="<%="id_produto".equals(orderBy)?"active":""%>">
                    <a href="?txtNome=<%=txtNome%>&orderBy=id_produto&orderDir=<%=("id_produto".equals(orderBy)&&"ASC".equals(orderDir))?"DESC":"ASC"%>">
                      Código <%= "id_produto".equals(orderBy)?("ASC".equals(orderDir)?"▲":"▼"):"" %>
                    </a>
                  </th>
                  <th class="<%= "nome".equals(orderBy)?"active":"" %>">
                    <a href="?txtNome=<%=txtNome%>&orderBy=nome&orderDir=<%=("nome".equals(orderBy)&&"ASC".equals(orderDir))?"DESC":"ASC"%>">
                      Produto <%= "nome".equals(orderBy)?("ASC".equals(orderDir)?"▲":"▼"):"" %>
                    </a>
                  </th>
                  <th>Categoria</th>
                  <th class="<%= "marca".equals(orderBy)?"active":"" %>">
                    <a href="?txtNome=<%=txtNome%>&orderBy=marca&orderDir=<%=("marca".equals(orderBy)&&"ASC".equals(orderDir))?"DESC":"ASC"%>">
                      Marca <%= "marca".equals(orderBy)?("ASC".equals(orderDir)?"▲":"▼"):"" %>
                    </a>
                  </th>
                  <th class="<%= "unidade_medida".equals(orderBy)?"active":"" %>">
                    <a href="?txtNome=<%=txtNome%>&orderBy=unidade_medida&orderDir=<%=("unidade_medida".equals(orderBy)&&"ASC".equals(orderDir))?"DESC":"ASC"%>">
                      Unidade <%= "unidade_medida".equals(orderBy)?("ASC".equals(orderDir)?"▲":"▼"):"" %>
                    </a>
                  </th>
                  <th class="<%= "cod_barras".equals(orderBy)?"active":"" %>">
                    <a href="?txtNome=<%=txtNome%>&orderBy=cod_barras&orderDir=<%=("cod_barras".equals(orderBy)&&"ASC".equals(orderDir))?"DESC":"ASC"%>">
                      Código de Barras <%= "cod_barras".equals(orderBy)?("ASC".equals(orderDir)?"▲":"▼"):"" %>
                    </a>
                  </th>
                  <th class="<%= "preco".equals(orderBy)?"active":"" %>">
                    <a href="?txtNome=<%=txtNome%>&orderBy=preco&orderDir=<%=("preco".equals(orderBy)&&"ASC".equals(orderDir))?"DESC":"ASC"%>">
                      Preço <%= "preco".equals(orderBy)?("ASC".equals(orderDir)?"▲":"▼"):"" %>
                    </a>
                  </th>
                  <th>Editar</th>
                  <th>Deletar</th>
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

                  <!-- Botão Editar -->
                  <td>
                    <button type="button" class="btn-guardar"  style="background-color:gray;"
                      onclick="abrirModal(
                        '<%= p.getIdProduto() %>',
                        '<%= p.getCategoria().getIdCategoria() %>',
                        '<%= p.getNome() %>',
                        '<%= p.getMarca() %>',
                        '<%= p.getUnidadeMedida() %>',
                        '<%= p.getCodBarras() %>',
                        '<%= p.getPreco() %>'
                      )">
                      Editar
                    </button>
                  </td>

                  <!-- Botão Deletar -->
                  <td>
                    <form action="${pageContext.request.contextPath}/ConsultarProdutosServlet" method="POST">
                      <input type="hidden" name="action" value="delete" />
                      <input type="hidden" name="page" value="${currentPage}">
                      <input type="hidden" name="txtNome" value="${txtNome}">
                      <input type="hidden" name="orderBy" value="${orderBy}">
                      <input type="hidden" name="orderDir" value="${orderDir}">
                      <input type="hidden" name="delete_id_produto" value="<%= p.getIdProduto() %>" />
                      <button type="submit" class="btn-guardar" style="background-color:red;">Apagar</button>
                    </form>
                  </td>
                </tr>
              <%
                    }
                } else {
              %>
                <tr><td colspan="9" style="text-align:center;">Nenhum produto encontrado.</td></tr>
              <%
                }
              %>
              </tbody>
            </table>
          </div>

          <!-- Pagination -->
          <div class="pagination">
            <% 
              Integer currentPage = (Integer) request.getAttribute("currentPage");
              Integer totalPages = (Integer) request.getAttribute("totalPages");
              if (totalPages != null && totalPages > 1) {
            %>
              <% if (currentPage > 1) { %>
                <a class="page-btn" href="?txtNome=<%= txtNome %>&orderBy=<%= orderBy %>&orderDir=<%= orderDir %>&page=<%= currentPage - 1 %>">« Anterior</a>
              <% } else { %>
                <span class="page-btn disabled">« Anterior</span>
              <% } %>
              <%
                int startPage = Math.max(1, currentPage - 2);
                int endPage = Math.min(totalPages, currentPage + 2);
                for (int i = startPage; i <= endPage; i++) {
                  if (i == currentPage) {
              %>
                <span class="page-btn current"><%= i %></span>
              <% } else { %>
                <a class="page-btn" href="?txtNome=<%= txtNome %>&orderBy=<%= orderBy %>&orderDir=<%= orderDir %>&page=<%= i %>"><%= i %></a>
              <%  }
                }
              %>
              <% if (currentPage < totalPages) { %>
                <a class="page-btn" href="?txtNome=<%= txtNome %>&orderBy=<%= orderBy %>&orderDir=<%= orderDir %>&page=<%= currentPage + 1 %>">Próximo »</a>
              <% } else { %>
                <span class="page-btn disabled">Próximo »</span>
              <% } %>
            <% } %>
          </div>

        </section>

  <!-- Modal -->
<div id="modal" class="modal">
  <div class="registo-card">
    <span class="close" onclick="fecharModal()">x</span>
    <h3>Editar Produto</h3>
    <form action="${pageContext.request.contextPath}/ConsultarProdutosServlet" method="POST" class="form-grid">
      <input type="hidden" name="action" value="update">
      <input type="hidden" id="modal_id_produto" name="id_produto">

      <div class="input-group full-width">
        <label>Categoria</label>
        <select id="modal_categoria_select" onchange="atualizarCategoria()" style="width: 100%; padding: 8px; border-radius: 4px; border: 1px solid #ddd;">
          <option value="">-- Selecione uma categoria --</option>
          <%
            if (categorias != null) {
              for (Categoria cat : categorias) {
          %>
            <option value="<%= cat.getIdCategoria() %>"><%= cat.getNome() %></option>
          <%
              }
            }
          %>
        </select>
        <input type="hidden" id="modal_id_categoria" name="id_categoria" required>
      </div>

      <div class="input-group full-width">
        <label>Nome</label>
        <input type="text" id="modal_nome" name="nome" required>
      </div>

      <div class="input-group">
        <label>Marca</label>
        <input type="text" id="modal_marca" name="marca">
      </div>

      <div class="input-group">
        <label>Unidade</label>
		<input type="text" id="modal_unidade" name="unidade">
      </div>

      <div class="input-group">
        <label>Código Barras</label>
        <input type="text" id="modal_cod_barras" name="cod_barras">
      </div>

      <div class="input-group">
        <label>Preço</label>
        <input type="number" step="0.01" id="modal_preco" name="preco" required>
      </div>

      <div class="button-group full-width">
        <button type="submit" class="btn-guardar">Atualizar Produto</button>
      </div>
    </form>
  </div>
</div>

<!-- Modal Adicionar Produto -->
<div id="modalAddProduto" class="modal">
  <div class="registo-card">
    <span class="close" onclick="fecharModalAddProduto()">x</span>
    <h3>Adicionar Produto</h3>
    <form action="${pageContext.request.contextPath}/ConsultarProdutosServlet" method="POST" class="form-grid">
      <input type="hidden" name="action" value="insert">

      <div class="input-group full-width">
        <label>Categoria</label>
        <select id="modal_categoria_select_add" onchange="atualizarCategoriaAdd()" style="width: 100%; padding: 8px; border-radius: 4px; border: 1px solid #ddd;" required>
          <option value="">-- Selecione uma categoria --</option>
          <%
            if (categorias != null) {
              for (Categoria cat : categorias) {
          %>
            <option value="<%= cat.getIdCategoria() %>"><%= cat.getNome() %></option>
          <%
              }
            }
          %>
        </select>
        <input type="hidden" id="modal_id_categoria_add" name="id_categoria" required>
      </div>

      <div class="input-group full-width">
        <label>Nome</label>
        <input type="text" id="modal_add_nome" name="nome" required>
      </div>

      <div class="input-group">
        <label>Marca</label>
        <input type="text" id="modal_add_marca" name="marca">
      </div>

      <div class="input-group">
        <label>Unidade</label>
        <input type="text" id="modal_add_unidade" name="unidade">
      </div>

      <div class="input-group">
        <label>Código Barras</label>
        <input type="text" id="modal_add_cod_barras" name="cod_barras">
      </div>

      <div class="input-group">
        <label>Preço</label>
        <input type="number" step="0.01" id="modal_add_preco" name="preco" required>
      </div>

      <div class="button-group full-width">
        <button type="submit" class="btn-guardar">Criar Produto</button>
      </div>
    </form>
  </div>
</div>

      </main>
  </div>

  <script>
    const categoriaMap = {};
    
    // Construir mapa de categorias (ID -> Nome)
    <%
      if (categorias != null) {
        for (Categoria cat : categorias) {
    %>
    categoriaMap[<%= cat.getIdCategoria() %>] = "<%= cat.getNome() %>";
    <%
        }
      }
    %>
    
    function atualizarCategoria() {
        const select = document.getElementById("modal_categoria_select");
        const hiddenInput = document.getElementById("modal_id_categoria");
        hiddenInput.value = select.value;
    }

    function atualizarCategoriaAdd() {
        const select = document.getElementById("modal_categoria_select_add");
        const hiddenInput = document.getElementById("modal_id_categoria_add");
        hiddenInput.value = select.value;
    }
    
    function abrirModal(id, idCat, nome, marca, unidade, codBarras, preco) {
        document.getElementById("modal").style.display = "flex";
        document.getElementById("modal_id_produto").value = id;
        document.getElementById("modal_id_categoria").value = idCat;
        document.getElementById("modal_categoria_select").value = idCat;
        document.getElementById("modal_nome").value = nome;
        document.getElementById("modal_marca").value = marca;
        document.getElementById("modal_unidade").value = unidade;
        document.getElementById("modal_cod_barras").value = codBarras;
        document.getElementById("modal_preco").value = preco;
    }

    function abrirModalAddProduto() {
        document.getElementById("modalAddProduto").style.display = "flex";
    }
    
    function fecharModal() {
        document.getElementById("modal").style.display = "none";
    }

    function fecharModalAddProduto() {
        document.getElementById("modalAddProduto").style.display = "none";
    }
  </script>

  <script type="module" src="/SuperMARKT/Front-end/js/pages/dashboard.js"></script>
</body>
</html>