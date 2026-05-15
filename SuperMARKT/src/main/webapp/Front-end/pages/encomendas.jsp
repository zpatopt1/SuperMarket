<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% request.setAttribute("seccao", "Encomendas"); %>
<%@ page import="java.util.List" %>
<%@ page import="model.Encomenda" %>
<!doctype html>
<html lang="pt-PT">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <title>Encomendas</title>
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
            <h2 class="page-title">Encomendas</h2>
            <p class="page-subtitle">Histórico e acompanhamento de encomendas</p>
          </div>
        </div>
    <section class="card">
    <div class="toolbar">
        <div class="search">
            <span class="search-ico" aria-hidden="true">⌕</span>
            <input type="text" placeholder="Pesquisar Encomendas" id="searchInput">
        </div>
        <button class="btn-primary" type="button">Filtrar</button>
        </div>


          <div class="table-wrap">
            <table class="table" id="encomendasTable">
              <thead>
                <tr>
                  <th>ID</th>
                  <th>Fornecedor</th>
                  <th>Destino</th>
                  <th>Data Pedido</th>
                  <th>Status</th>
                  <th>Data Prevista</th>
                  <th>Data Chegada</th>
                  <th>Valor Envio</th>
                  <th>Total</th>
                  <th>Encomenda</th>
                  <th>CSV</th>
                  <th>Confirmar</th>
                  <th>Rececao</th>
                </tr>
              </thead>
              <tbody>
              <%
                List<Encomenda> lista = (List<Encomenda>) request.getAttribute("encomendas");
                if (lista != null && !lista.isEmpty()) {
                  for (Encomenda e : lista) {
              %>
                <tr>
                  <td><%= e.getIdMovimentos().getIdMovimentos() %></td>
                  <td><%= e.getIdFornecedor().getTipoFornecedor() %></td>
                  <td><%= e.getIdLocal().getNome() %></td>
                  <td><%= e.getIdMovimentos().getData() %></td>
                  <td><%= e.getIdMovimentos().getStatus() %></td>
                  <td><%= e.getDataPrevista() %></td>
                  <td><%= e.getDataChegada() %></td>
                  <td><%= e.getCustoEnvio() %> €</td>
                  <td><%= e.getValorTotal() %> €</td>
                  <td>
                    <a class="btn-action btn-edit" style="text-decoration:none;"
                       href="${pageContext.request.contextPath}/DetalhesEncomendaServlet?id=<%= e.getIdMovimentos().getIdMovimentos() %>">
                      Abrir
                    </a>
                  </td>
                  <td>
                    <a class="btn-secondary" style="text-decoration:none;"
                       href="${pageContext.request.contextPath}/DownloadEncomendaCsvServlet?id=<%= e.getIdMovimentos().getIdMovimentos() %>">
                      Download CSV
                    </a>
                  </td>
                  <td>
                    <a class="btn-primary" style="text-decoration:none;"
                       href="${pageContext.request.contextPath}/ConfirmarEncomendaFornecedorServlet?id=<%= e.getIdMovimentos().getIdMovimentos() %>">
                      Confirmar
                    </a>
                  </td>
                  <td>
                    <a class="btn-action btn-edit" style="text-decoration:none;"
                       href="${pageContext.request.contextPath}/ConfirmarRececaoEncomendaServlet?id=<%= e.getIdMovimentos().getIdMovimentos() %>">
                      Rececao
                    </a>
                  </td>
                </tr>
              <% } } else { %>
                <tr>
                  <td colspan="13" style="text-align:center;">Nenhuma encomenda encontrada.</td>
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
      var table = $('#encomendasTable').DataTable({
        pageLength: 5,
        language: {
          search: "Pesquisar:",
          lengthMenu: "Mostrar _MENU_ encomendas por página",
          info: "Mostrando _START_ a _END_ de _TOTAL_ encomendas",
          zeroRecords: "Nenhuma encomenda encontrada",
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
