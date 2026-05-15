<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% request.setAttribute("seccao", "Linhas da Encomenda"); %>
<%@ page import="java.util.List" %>
<%@ page import="model.LinhaEnc" %>
<%@ page import="model.Encomenda" %>
<!doctype html>
<html lang="pt-PT">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <title>Linhas da Encomenda</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">
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
            <h2 class="page-title">Linhas da Encomenda</h2>
            <p class="page-subtitle">Detalhe dos produtos encomendados</p>
          </div>
          <a class="btn-secondary" style="text-decoration:none;" href="${pageContext.request.contextPath}/EncomendasServlet">Voltar</a>
        </div>
    <section class="card">
    <div class="toolbar">
        <div class="search">
            <span class="search-ico" aria-hidden="true">⌕</span>
            <input type="text" placeholder="Pesquisar Encomendas" id="searchInput">
        </div>
        <%
          Encomenda enc = (Encomenda) request.getAttribute("encomenda");
          int idFornecedor = (enc != null && enc.getIdFornecedor() != null) ? enc.getIdFornecedor().getIdFornecedor() : 0;
          int idEnc = (enc != null && enc.getIdMovimentos() != null) ? enc.getIdMovimentos().getIdMovimentos() : 0;
        %>
        <a href="${pageContext.request.contextPath}/ConsultarFornecedorProdutosServlet?id_fornecedor=<%= idFornecedor %>&id_encomenda=<%= idEnc %>"
           class="btn-primary" style="text-decoration:none;">+ Adicionar Itens</a>
        </div>
          <div class="table-wrap">
            <table class="table" id="linhasTable">
              <thead>
                <tr>
                  <th>Produto</th>
                  <th>Quantidade</th>
                  <th>Preço</th>
                  <th>Validade</th>
                  <th>Total</th>
                  <th>Acoes</th>
                </tr>
              </thead>
              <tbody>
              <%
                List<LinhaEnc> linhas = (List<LinhaEnc>) request.getAttribute("linhas");
                if (linhas != null && !linhas.isEmpty()) {
                  for (LinhaEnc l : linhas) {
                    float totalLinha = l.getQuantidade() * l.getPrecoEncomenda();
                    String formId = "formQtd_" + l.getIdLinhaOrder();
              %>
                <tr>
                  <td><%= l.getProduto().getNome() %></td>
                  <td>
                    <input type="number" name="quantidade" min="1" value="<%= l.getQuantidade() %>" style="width:90px;" form="<%= formId %>">
                  </td>
                  <td><%= l.getPrecoEncomenda() %> €</td>
                  <td><%= l.getDataValidade() %></td>
                  <td><%= totalLinha %> €</td>
                  <td>
                    <form id="<%= formId %>" action="${pageContext.request.contextPath}/DetalhesEncomendaServlet" method="post" style="display:inline;">
                      <input type="hidden" name="id_encomenda" value="<%= idEnc %>">
                      <input type="hidden" name="id_linhaenc" value="<%= l.getIdLinhaOrder() %>">
                      <button type="submit" class="btn-action btn-edit">Guardar</button>
                    </form>
                  </td>
                </tr>
              <% } } else { %>
                <tr>
                  <td colspan="6" style="text-align:center;">Nenhuma linha encontrada para esta encomenda.</td>
                </tr>
              <% } %>
              </tbody>
            </table>
          </div>
        </section>
      </section>
    </main>
  </div>
  <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
  <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
  <script>
    $(document).ready(function () {
    	var table = $('#linhasTable').DataTable({
        pageLength: 5,
        language: {
          search: "Pesquisar:",
          lengthMenu: "Mostrar _MENU_ linhas por página",
          info: "Mostrando _START_ a _END_ de _TOTAL_ linhas",
          zeroRecords: "Nenhuma linha encontrada",
          paginate: { previous: "« Anterior", next: "Próximo »" }
        },
        dom: '<"table-wrap"t><"pagination-wrapper d-flex justify-center"p>'
      });
      
      $('#searchInput').on('keyup', function() {
        table.search(this.value).draw();
      });

    });
  </script>
  <script type="module" src="${pageContext.request.contextPath}/Front-end/js/pages/dashboard.js"></script>
</body>
</html>
