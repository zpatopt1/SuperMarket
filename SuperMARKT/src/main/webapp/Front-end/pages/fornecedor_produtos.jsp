<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% request.setAttribute("seccao", "Fornecedor Produtos"); %>
<%@ page import="java.util.List" %>
<%@ page import="model.FornecedorProduto" %>
<%@ page import="model.Fornecedor" %>
<%@ page import="model.Produto" %>
<%@ page import="model.Local" %>

<!DOCTYPE html>
<html lang="pt-PT">
<head>
  <meta charset="UTF-8">
  <title>Fornecedor Produtos</title>
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
        <h2 class="page-title">Fornecedor Produtos</h2>
        <p class="page-subtitle">Gestão de preços por fornecedor</p>
      </div>
    </div>
    <section class="card">
      <div class="toolbar">
        <div class="search">
          <span class="search-ico" aria-hidden="true">⌕</span>
          <input type="text" id="searchInput" placeholder="Pesquisar...">
        </div>
        <div>
            <button class="btn-secondary" type="button" id="btnLimparSelecao">Limpar seleção</button>
            <button class="btn-primary" type="button" onclick="abrirModalConfirmar()">Criar Encomenda</button>
            <button class="btn-primary" type="button" onclick="abrirModalAdd()">Adicionar Novo Produto</button>
        </div>
      </div>
      <% if(request.getAttribute("mensagem") != null) { %>
          <div style="color: green; margin-bottom: 15px;"><%= request.getAttribute("mensagem") %></div>
      <% } %>
      <% if(request.getAttribute("erro") != null) { %>
          <div style="color: red; margin-bottom: 15px;"><%= request.getAttribute("erro") %></div>
      <% } %>
      <div class="table-wrap">
        <form id="formEncomenda" action="${pageContext.request.contextPath}/ConsultarFornecedorProdutosServlet" method="post">
          <input type="hidden" name="action" value="encomendar">
          <input type="hidden" name="id_fornecedor_comum" id="id_fornecedor_comum">
          <input type="hidden" id="id_local" name="id_local">
          <table id="fornecedorProdutosTable" class="table">
            <thead>
              <tr>
                <th>Sel.</th>
                <th>Qty</th>
                <th>ID Fornecedor</th>
                <th>Fornecedor</th>
                <th>ID Produto</th>
                <th>Produto</th>
                <th>Preço (€)</th>
                <th>Editar</th>
                <th>Apagar</th>
              </tr>
            </thead>
            <tbody>
            <%
              List<FornecedorProduto> lista = (List<FornecedorProduto>) request.getAttribute("fornecedorProdutos");
              if (lista != null) {
                for (FornecedorProduto fp : lista) {
                  String fornecedorNome = fp.getFornecedor().getTipoFornecedor();
                  String produtoNome = fp.getProduto().getNome();
            %>
            <tr>
              <td>
                <input type="checkbox" name="selected_produtos" 
                      value="<%= fp.getProduto().getIdProduto() %>"
                      onclick="atualizarFornecedorComum('<%= fp.getFornecedor().getIdFornecedor() %>')">
              </td>
              <td>
                <input type="number" name="qtd_<%= fp.getProduto().getIdProduto() %>" 
                      class="input-quantidade" min="1" value="1" style="width:60px;">
                <input type="hidden" name="preco_<%= fp.getProduto().getIdProduto() %>" value="<%= fp.getPreco()%>">
              </td>
              <td><%= fp.getFornecedor().getIdFornecedor() %></td>
              <td><%= fornecedorNome %></td>
              <td><%= fp.getProduto().getIdProduto() %></td>
              <td><%= produtoNome %></td>
              <td><%= String.format("%.2f", fp.getPreco()) %></td>
              <td>
                <button class="btn-action btn-edit" type="button"
                        onclick="abrirModalEdit('<%= fp.getFornecedor().getIdFornecedor() %>','<%= fornecedorNome %>','<%= fp.getProduto().getIdProduto() %>','<%= produtoNome %>','<%= fp.getPreco() %>')">
                  Editar
                </button>
              </td>
              <td>
                <form method="post" action="${pageContext.request.contextPath}/ConsultarFornecedorProdutosServlet" style="margin:0;">
                  <input type="hidden" name="action" value="delete">
                  <input type="hidden" name="id_fornecedor" value="<%= fp.getFornecedor().getIdFornecedor() %>">
                  <input type="hidden" name="id_produto" value="<%= fp.getProduto().getIdProduto() %>">
                  <button class="btn-action btn-delete" type="submit">Apagar</button>
                </form>
              </td>
            </tr>
            <% } } %>
            </tbody>
          </table>
        </form>
      </div>
    </section>
  </section>
</main>
</div>

<div id="modalAdd" class="modal">
  <div class="registo-card">
    <span class="close" onclick="fecharModalAdd()">x</span>
    <h3>Adicionar Fornecedor Produto</h3>
    <form action="${pageContext.request.contextPath}/ConsultarFornecedorProdutosServlet" method="post">
      <input type="hidden" name="action" value="insert">
    
      
      <div class="input-group full-width">
        <label>Fornecedor</label>
        <select name="id_fornecedor" required>
          <option value="">Selecione...</option>
          <%
            List<Fornecedor> fornecedores = (List<Fornecedor>) request.getAttribute("fornecedores");
            if (fornecedores != null) for (Fornecedor f : fornecedores) {
          %>
          <option value="<%= f.getIdFornecedor() %>"><%= f.getIdFornecedor() %> - <%= f.getTipoFornecedor() %></option>
          <% } %>
        </select>
      </div>
      <div class="input-group full-width">
        <label>Produto</label>
        <select name="id_produto" required>
          <option value="">Selecione...</option>
          <%
            List<Produto> produtos = (List<Produto>) request.getAttribute("produtos");
            if (produtos != null) for (Produto p : produtos) {
          %>
          <option value="<%= p.getIdProduto() %>"><%= p.getIdProduto() %> - <%= p.getNome() %></option>
          <% } %>
        </select>
      </div>
      <div class="input-group full-width">
        <label>Preço</label>
        <input type="number" step="0.01" min="0" name="preco" required>
      </div>
      <div class="button-group full-width">
        <button class="btn-guardar" type="submit">Guardar</button>
      </div>
    </form>
  </div>
</div>

<div id="modalEdit" class="modal">
  <div class="registo-card">
    <span class="close" onclick="fecharModalEdit()">x</span>
    <h3>Editar Preço</h3>
    <form action="${pageContext.request.contextPath}/ConsultarFornecedorProdutosServlet" method="post">
      <input type="hidden" name="action" value="update">
      <input type="hidden" id="edit_id_fornecedor" name="id_fornecedor">
      <input type="hidden" id="edit_id_produto" name="id_produto">
      <div class="input-group full-width">
        <label>Fornecedor</label>
        <input type="text" id="edit_fornecedor_nome" readonly>
      </div>
      <div class="input-group full-width">
        <label>Produto</label>
        <input type="text" id="edit_produto_nome" readonly>
      </div>
      <div class="input-group full-width">
        <label>Preço</label>
        <input type="number" step="0.01" min="0" id="edit_preco" name="preco" required>
      </div>
      <div class="button-group full-width">
        <button class="btn-guardar" type="submit">Atualizar</button>
      </div>
    </form>
  </div>
</div>

<!-- Modal de Confirmação para selecionar o Local -->
<div id="modalConfirmar" class="modal">
  <div class="registo-card">
    <span class="close" onclick="fecharModalConfirmar()">x</span>
    <h3>Finalizar Encomenda</h3>
    <p>Selecione o local de destino:</p>
    
    <div class="input-group full-width">
      <label>Local de Destino</label>
      <select id="select_local_modal" class="input-field" required>
        <option value="">Selecione um local...</option>
        <%
          List<Local> listaLocais = (List<Local>) request.getAttribute("locais");
          if (listaLocais != null) {
            for (model.Local l : listaLocais) {
        %>
          <option value="<%= l.getIdLocal() %>"><%= l.getNome() %></option>
        <% 
            } 
          } 
        %>
      </select>
    </div>
    <div class="button-group full-width">
      <button class="btn-guardar" type="button" onclick="confirmarEnvioFinal()">Confirmar e Enviar</button>
    </div>
  </div>
</div>


<script>
  function atualizarFornecedorComum(idFornecedorClicado) {
    const checkboxes = document.querySelectorAll('input[name="selected_produtos"]');
    const inputFornecedorComum = document.getElementById("id_fornecedor_comum");
    const rows = document.querySelectorAll('#fornecedorProdutosTable tbody tr');
    
    // Contar quantas checkboxes estão marcadas
    const selecionados = Array.from(checkboxes).filter(cb => cb.checked);

    if (selecionados.length === 1) {
      // Se for o primeiro a ser selecionado, filtramos a tabela por este fornecedor
      inputFornecedorComum.value = idFornecedorClicado;
      
      rows.forEach(row => {
        const idRow = row.cells[2].innerText.trim();
        if (idRow !== idFornecedorClicado) {
          row.style.display = 'none';
        }
      });
      console.log("Filtro aplicado ao fornecedor: " + idFornecedorClicado);

    } else if (selecionados.length === 0) {
      // Se desmarcou tudo, volta a mostrar todos os produtos
      inputFornecedorComum.value = "";
      rows.forEach(row => row.style.display = '');
      console.log("Filtro removido.");
    }
  }

  // --- Ajuste no Limpar Seleção para restaurar a tabela ---
  document.getElementById('btnLimparSelecao').addEventListener('click', function() {
    const checkboxes = document.querySelectorAll('input[name="selected_produtos"]');
    checkboxes.forEach(cb => cb.checked = false);
    
    document.getElementById("id_fornecedor_comum").value = "";
    
    // Mostrar todas as linhas novamente
    const rows = document.querySelectorAll('#fornecedorProdutosTable tbody tr');
    rows.forEach(row => row.style.display = '');
    
    // Resetar quantidades
    document.querySelectorAll('.input-quantidade').forEach(input => input.value = 1);
  });

  // --- Lógica de Pesquisa (Mantida mas integrada) ---
  document.getElementById('searchInput').addEventListener('keyup', function() {
    const filter = this.value.toLowerCase();
    const rows = document.querySelectorAll('#fornecedorProdutosTable tbody tr');
    const idFornecedorAtivo = document.getElementById("id_fornecedor_comum").value;

    rows.forEach(row => {
      const text = row.textContent.toLowerCase();
      const idRow = row.cells[2].innerText.trim();
      
      // Só mostra se: coincidir com a pesquisa E (não houver filtro de fornecedor OU for o fornecedor correto)
      const matchesSearch = text.includes(filter);
      const matchesSupplier = (idFornecedorAtivo === "" || idRow === idFornecedorAtivo);

      row.style.display = (matchesSearch && matchesSupplier) ? '' : 'none';
    });
  });
  
  function confirmarEnvioFinal() {
	    const selectLocal = document.getElementById("select_local_modal");
	    const localId = selectLocal.value;

	    if (!localId) {
	        alert("Por favor, selecione um local de destino.");
	        return;
	    }

	    // 1. Coloca o ID do local no campo hidden do formulário principal
	    document.getElementById("id_local").value = localId;

	    // 2. Submete o formulário manualmente
	    document.getElementById("formEncomenda").submit();
	}

  function abrirModalAdd() { document.getElementById("modalAdd").style.display = "flex"; }
  function fecharModalAdd() { document.getElementById("modalAdd").style.display = "none"; }
  
  function abrirModalEdit(idFornecedor, fornecedorNome, idProduto, produtoNome, preco) {
    document.getElementById("edit_id_fornecedor").value = idFornecedor;
    document.getElementById("edit_id_produto").value = idProduto;
    document.getElementById("edit_fornecedor_nome").value = fornecedorNome;
    document.getElementById("edit_produto_nome").value = produtoNome;
    document.getElementById("edit_preco").value = preco;
    document.getElementById("modalEdit").style.display = "flex";
  }
  function fecharModalEdit() { document.getElementById("modalEdit").style.display = "none"; }
 
  function abrirModalConfirmar() {
	    // Validar se há produtos selecionados antes de abrir
	    const selecionados = document.querySelectorAll('input[name="selected_produtos"]:checked');
	    if (selecionados.length === 0) {
	        alert("Selecione pelo menos um produto.");
	        return;
	    }
	    document.getElementById("modalConfirmar").style.display = "flex";
  }
  function fecharModalConfirmar() { document.getElementById("modalConfirmar").style.display = "none" }
</script>
</body>
</html>
