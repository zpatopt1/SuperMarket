<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% request.setAttribute("seccao", "Fornecedor Produtos"); %>
<%@ page import="java.util.List" %>
<%@ page import="model.FornecedorProduto" %>
<%@ page import="model.Fornecedor" %>
<%@ page import="model.Produto" %>
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
          <button class="btn-secondary" type="button" id="btnLimparSelecao">Limpar seleção</button>
          <button class="btn-primary" type="button" id="btnCriarEncomenda">Criar encomenda</button>
          <button class="btn-primary" type="button" onclick="abrirModalAdd()">Adicionar</button>
        </div>

        <div class="table-wrap">
          <table id="fornecedorProdutosTable" class="table">
            <thead>
            <tr>
              <th>Sel.</th>
              <th>Qty</th>
              <th>ID Fornecedor</th>
              <th>Fornecedor</th>
              <th>ID Produto</th>
              <th>Produto</th>
              <th>Preço</th>
              <th>Editar</th>
              <th>Apagar</th>
            </tr>
            </thead>
            <tbody>
            <%
              List<FornecedorProduto> lista = (List<FornecedorProduto>) request.getAttribute("fornecedorProdutos");
              if (lista != null) {
                for (FornecedorProduto fp : lista) {
                  String fornecedorNome = fp.getFornecedor().getTipoFornecedor() != null
                      ? fp.getFornecedor().getTipoFornecedor().replace("\\", "\\\\").replace("'", "\\'")
                      : "";
                  String produtoNome = fp.getProduto().getNome() != null
                      ? fp.getProduto().getNome().replace("\\", "\\\\").replace("'", "\\'")
                      : "";
            %>
				<tr>
				  <td>
				    <input type="checkbox"
				           class="check-encomenda"
				           data-fornecedor-id="<%= fp.getFornecedor().getIdFornecedor() %>"
				           data-produto-id="<%= fp.getProduto().getIdProduto() %>">
				  </td>
				  
				  <td>
				    <input type="number"
				           class="input-quantidade"
				           min="1"
				           value="1"
				           style="width:70px;">
				  </td>
				  <td><%= fp.getFornecedor().getIdFornecedor() %></td>
				  <td><%= fp.getFornecedor().getTipoFornecedor() %></td>
				  <td><%= fp.getProduto().getIdProduto() %></td>
				  <td><%= fp.getProduto().getNome() %></td>
				  <td><%= fp.getPreco() %></td>
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

<script>
  let fornecedorSelecionado = null;

  function atualizarFornecedorSelecionado() {
    const checksMarcados = Array.from(document.querySelectorAll('.check-encomenda:checked'));
    if (checksMarcados.length === 0) {
      fornecedorSelecionado = null;
      return;
    }
    fornecedorSelecionado = checksMarcados[0].dataset.fornecedorId;
  }

  function aplicarFiltrosTabela() {
    const filtro = document.getElementById('searchInput').value.toLowerCase();
    const linhas = document.querySelectorAll('#fornecedorProdutosTable tbody tr');
    linhas.forEach(function (linha) {
      const txt = linha.innerText.toLowerCase();
      const passaTexto = txt.includes(filtro);
      const chk = linha.querySelector('.check-encomenda');
      const fornecedorLinha = chk ? chk.dataset.fornecedorId : null;
      const passaFornecedor = !fornecedorSelecionado || fornecedorLinha === fornecedorSelecionado;
      linha.style.display = (passaTexto && passaFornecedor) ? '' : 'none';
    });
  }

  document.getElementById('searchInput').addEventListener('keyup', function () {
    aplicarFiltrosTabela();
  });

  document.querySelectorAll('.check-encomenda').forEach(function (chk) {
    chk.addEventListener('change', function () {
      const fornecedorId = this.dataset.fornecedorId;

      if (this.checked) {
        if (fornecedorSelecionado && fornecedorSelecionado !== fornecedorId) {
          alert('Só é permitido 1 fornecedor por encomenda. Limpa a seleção atual para trocar de fornecedor.');
          this.checked = false;
          return;
        }
        fornecedorSelecionado = fornecedorId;
      } else {
        atualizarFornecedorSelecionado();
      }
      aplicarFiltrosTabela();
    });
  });

  document.getElementById('btnLimparSelecao').addEventListener('click', function () {
    document.querySelectorAll('.check-encomenda').forEach(function (chk) { chk.checked = false; });
    fornecedorSelecionado = null;
    aplicarFiltrosTabela();
  });

  document.getElementById('btnCriarEncomenda').addEventListener('click', function () {

	    const checksMarcados = Array.from(
	        document.querySelectorAll('.check-encomenda:checked')
	    );

	    // =========================================
	    // VALIDAR
	    // =========================================

	    if (checksMarcados.length === 0) {

	        alert('Seleciona pelo menos 1 produto.');

	        return;
	    }

	    // =========================================
	    // FORNECEDOR
	    // =========================================

	    const fornecedorId =
	        checksMarcados[0].dataset.fornecedorId;

	    // =========================================
	    // FORM DINÂMICO
	    // =========================================

	    const form = document.createElement('form');

	    form.method = 'POST';

	    form.action =
	        '${pageContext.request.contextPath}/ConsultarFornecedorProdutosServlet';

	    // =========================================
	    // ACTION
	    // =========================================

	    const actionInput =
	        document.createElement('input');

	    actionInput.type = 'hidden';

	    actionInput.name = 'action';

	    actionInput.value = 'createEncomenda';

	    form.appendChild(actionInput);

	    // =========================================
	    // FORNECEDOR
	    // =========================================

	    const fornecedorInput =
	        document.createElement('input');

	    fornecedorInput.type = 'hidden';

	    fornecedorInput.name = 'id_fornecedor';

	    fornecedorInput.value = fornecedorId;

	    form.appendChild(fornecedorInput);

	    // =========================================
	    // LOCAL
	    // =========================================
	    // TEMPORÁRIO FIXO
	    // depois podes trocar por select

	    const localInput =
	        document.createElement('input');

	    localInput.type = 'hidden';

	    localInput.name = 'id_local';

	    localInput.value = '1';

	    form.appendChild(localInput);

	    // =========================================
	    // PRODUTOS
	    // =========================================

	    for (const chk of checksMarcados) {

	        const linha =
	            chk.closest('tr');

	        const produtoId =
	            chk.dataset.produtoId;

	        const quantidadeInput =
	            linha.querySelector(
	                '.input-quantidade'
	            );

	        const quantidade =
	            quantidadeInput.value;

	        // =====================================
	        // VALIDAR QUANTIDADE
	        // =====================================

	        if (
	            isNaN(quantidade) ||
	            quantidade < 1
	        ) {

	            alert(
	                'Quantidade inválida no produto ' +
	                produtoId
	            );

	            quantidadeInput.focus();

	            return;
	        }

	        // =====================================
	        // ID PRODUTO
	        // =====================================

	        const produtoInput =
	            document.createElement('input');

	        produtoInput.type = 'hidden';

	        produtoInput.name = 'id_produto';

	        produtoInput.value = produtoId;

	        form.appendChild(produtoInput);

	        // =====================================
	        // QUANTIDADE
	        // =====================================

	        const qtyInput =
	            document.createElement('input');

	        qtyInput.type = 'hidden';

	        qtyInput.name = 'qty_produtos';

	        qtyInput.value = quantidade;

	        form.appendChild(qtyInput);
	    }

	    // =========================================
	    // ENVIAR
	    // =========================================

	    document.body.appendChild(form);

	    form.submit();
	});  
  
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
</script>
</body>
</html>
