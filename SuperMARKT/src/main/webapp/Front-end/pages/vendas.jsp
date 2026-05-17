<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Produto" %>
<% request.setAttribute("seccao", "Vendas"); %>

<!doctype html>
<html lang="pt-PT">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <title>SuperMart • Iniciar Venda</title>

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
            <h2 class="page-title">Iniciar Venda</h2>
            <p class="page-subtitle">Registo rápido de produtos e pagamento</p>
          </div>
        </div>

        <div class="grid grid-sale">
          <section class="card">
            <div class="toolbar">
              <div class="search" style="flex: 1; display: flex; gap: 10px;">
                <span class="search-ico">⌕</span>
                <input type="text" id="input-codigo" placeholder="Código de barras..." style="flex: 1;" />
              </div>
              <button class="btn-primary" type="button" onclick="pesquisarPorCodigo()">Adicionar</button>
            </div>

            <div class="card-body">
              <div class="sale-head">
                <strong>Itens da Venda</strong>
                <button class="link" type="button" onclick="limparCarrinho()">Limpar</button>
              </div>

              <table class="table sale-table">
                <thead>
                  <tr>
                    <th>Produto</th>
                    <th>Quantidade</th>
                    <th>Preço Unit.</th>
                    <th>Total</th>
                    <th></th>
                  </tr>
                </thead>
                <tbody id="carrinho-body">
                  <tr>
                    <td colspan="5" style="text-align: center; padding: 20px; color: #94a3b8;">
                      O carrinho está vazio. Adicione produtos à direita.
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
          </section>

          <aside class="card">
            <div class="card-body">
              <h3 class="side-title">Resumo da Venda</h3>

              <div class="summary">
                <div><span>Subtotal</span><strong id="ui-subtotal">0.00€</strong></div>
                <div><span>IVA (23%)</span><strong id="ui-iva">0.00€</strong></div>
                <div class="total"><span>Total</span><strong id="ui-total">0.00€</strong></div>
              </div>

              <form id="form-venda" action="${pageContext.request.contextPath}/RegistarVenda" method="POST" style="display: contents;" onsubmit="return prepararFormulario()">
                  <input type="hidden" name="totalVendaReal" id="form-total" value="0.00">
                  
                  <div id="hidden-inputs-container"></div>
                  
                  <button type="submit" class="btn btn-success w-100 mb-2" style="background-color: #28a745; border: none; padding: 12px; border-radius: 8px; font-weight: bold; color: white;">
                      Finalizar Venda
                  </button>
              </form>

              <button class="btn-outline" type="button" onclick="limparCarrinho()">Cancelar Venda</button>

              <hr />

              <h3 class="side-title">Produtos Rápidos</h3>
              <div class="quick-products">
                <%
                    List<Produto> lista = (List<Produto>) request.getAttribute("produtos");
                    if (lista != null && !lista.isEmpty()) {
                        for (Produto prod : lista) {
                %>
                            <button type="button" onclick="adicionarAoCarrinho(<%= prod.getIdProduto() %>, '<%= prod.getNome() %>', '<%= prod.getCodBarras() %>', <%= prod.getPreco() %>)">
                                <%= prod.getNome() %><br><span><%= prod.getPreco() %>€</span>
                            </button>
                <%
                        }
                    } else {
                %>
                        <p style="color: #94a3b8; font-size: 0.9rem; text-align: center; width: 100%;">Nenhum produto carregado.</p>
                <%
                    }
                %>
              </div>
            </div>
          </aside>
        </div>
      </section>
    </main>
  </div>

  <script>
    let carrinho = [];
 
    let catalogo = [];
    <%
        if (lista != null && !lista.isEmpty()) {
            for (Produto p : lista) {
    %>
                catalogo.push({
                    id: <%= p.getIdProduto() %>,
                    nome: '<%= p.getNome().replace("'", "\\'") %>',
                    codigo: '<%= p.getCodBarras() %>',
                    preco: <%= p.getPreco() %>
                });
    <%
            }
        }
    %>

    
    function pesquisarPorCodigo() {
        let codigoDigitado = document.getElementById('input-codigo').value.trim();
        
        if (codigoDigitado === '') return; 

     
        let produtoEncontrado = catalogo.find(p => p.codigo === codigoDigitado);

        if (produtoEncontrado) {
           
            adicionarAoCarrinho(produtoEncontrado.id, produtoEncontrado.nome, produtoEncontrado.codigo, produtoEncontrado.preco);
            document.getElementById('input-codigo').value = ''; 
        } else {
            alert("Produto não encontrado! Verifica se o código de barras está correto.");
        }
    }

    function adicionarAoCarrinho(id, nome, codigo, preco) {
        let itemExistente = carrinho.find(item => item.id === id);
        
        if (itemExistente) {
            itemExistente.quantidade++;
        } else {
            carrinho.push({ id: id, nome: nome, codigo: codigo, preco: preco, quantidade: 1 });
        }
        atualizarInterface();
    }

    function alterarQtd(index, valor) {
        carrinho[index].quantidade += valor;
        if (carrinho[index].quantidade <= 0) {
            removerItem(index);
        } else {
            atualizarInterface();
        }
    }

    function removerItem(index) {
        carrinho.splice(index, 1);
        atualizarInterface();
    }

    function limparCarrinho() {
        carrinho = [];
        atualizarInterface();
    }

    function atualizarInterface() {
        let tbody = document.getElementById('carrinho-body');
        tbody.innerHTML = '';
        let subtotal = 0;

        if (carrinho.length === 0) {
            tbody.innerHTML = '<tr><td colspan="5" style="text-align: center; padding: 20px; color: #94a3b8;">O carrinho está vazio. Adicione produtos à direita.</td></tr>';
        } else {
            carrinho.forEach((item, index) => {
                let totalItem = item.preco * item.quantidade;
                subtotal += totalItem;

                tbody.innerHTML += `
                  <tr>
                    <td>
                      <div class="prod">
                        <strong>\${item.nome}</strong>
                        <span>\${item.codigo}</span>
                      </div>
                    </td>
                    <td class="qty">
                      <button type="button" onclick="alterarQtd(\${index}, -1)">-</button>
                      <span>\${item.quantidade}</span>
                      <button type="button" onclick="alterarQtd(\${index}, 1)">+</button>
                    </td>
                    <td>\${item.preco.toFixed(2)}€</td>
                    <td>\${totalItem.toFixed(2)}€</td>
                    <td class="remove" onclick="removerItem(\${index})" style="cursor: pointer; color: #dc2626; font-weight: bold; font-size: 1.2rem;">×</td>
                  </tr>
                `;
            });
        }

        let iva = subtotal * 0.23;
        let total = subtotal + iva;

        document.getElementById('ui-subtotal').innerText = subtotal.toFixed(2) + '€';
        document.getElementById('ui-iva').innerText = iva.toFixed(2) + '€';
        document.getElementById('ui-total').innerText = total.toFixed(2) + '€';
        
        document.getElementById('form-total').value = total.toFixed(2);
    }

    function prepararFormulario() {
        if (carrinho.length === 0) {
            alert("O carrinho está vazio! Adicione produtos antes de finalizar.");
            return false;
        }

        let container = document.getElementById('hidden-inputs-container');
        container.innerHTML = '';

        carrinho.forEach(item => {
            container.innerHTML += `<input type="hidden" name="idProduto" value="\${item.id}">`;
            container.innerHTML += `<input type="hidden" name="quantidade" value="\${item.quantidade}">`;
            container.innerHTML += `<input type="hidden" name="precoVenda" value="\${item.preco}">`;
        });

        return true;
    }
  </script>
</body>
<script type="module" src="${pageContext.request.contextPath}/Front-end/js/pages/dashboard.js"></script>
</html>