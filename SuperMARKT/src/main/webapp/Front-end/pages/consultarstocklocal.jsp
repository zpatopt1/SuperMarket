	<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% request.setAttribute("seccao", "Gestão de Stock Local"); %>
<%@ page import="java.util.List" %>
<%@ page import="model.StockLocal" %>
<%
  List<StockLocal> stocks = (List<StockLocal>) request.getAttribute("stocks");
  String idProduto = (String) request.getAttribute("idProduto");
  String idLocal = (String) request.getAttribute("idLocal");
  String orderBy = (String) request.getAttribute("orderBy");
  String orderDir = (String) request.getAttribute("orderDir");
  if (idProduto == null) idProduto = "";
  if (idLocal == null) idLocal = "";
  if (orderBy == null) orderBy = "id_produto";
  if (orderDir == null) orderDir = "ASC";
%>
<!DOCTYPE html>
<html lang="pt-PT">
<head>
    <meta charset="UTF-8">
    <title>Stock Local</title>
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
            <h2 class="page-title">Stock Local</h2>
            <p class="page-subtitle">Consulta de stock por local</p>
          </div>
        </div>
        <section class="card">
          <form action="${pageContext.request.contextPath}/ConsultarStockLocalServlet" method="get" class="toolbar">
            <div class="search">
              <span class="search-ico" aria-hidden="true">⌕</span>
              <input type="number" name="idProduto" min="1" placeholder="Filtrar por ID Produto" value="<%= idProduto %>" />
            </div>
            <div class="search">
              <span class="search-ico" aria-hidden="true">⌕</span>
              <input type="number" name="idLocal" min="1" placeholder="Filtrar por ID Local" value="<%= idLocal %>" />
            </div>
            <input type="hidden" name="orderBy" value="<%= orderBy %>">
            <input type="hidden" name="orderDir" value="<%= orderDir %>">
            <button type="submit" class="btn-primary">Filtrar</button>
          </form>

          <div class="table-wrap">
            <table class="table">
              <thead>
                <tr>
                  <th class="<%= "id_produto".equals(orderBy) ? "active" : "" %>">
                    <a href="?idProduto=<%= idProduto %>&idLocal=<%= idLocal %>&orderBy=id_produto&orderDir=<%= ("id_produto".equals(orderBy) && "ASC".equals(orderDir)) ? "DESC" : "ASC" %>">
                      ID Produto <%= "id_produto".equals(orderBy) ? ("ASC".equals(orderDir) ? "▲" : "▼") : "" %>
                    </a>
                  </th>
                  <th class="<%= "nome".equals(orderBy) ? "active" : "" %>">
                    <a href="?idProduto=<%= idProduto %>&idLocal=<%= idLocal %>&orderBy=nome&orderDir=<%= ("nome".equals(orderBy) && "ASC".equals(orderDir)) ? "DESC" : "ASC" %>">
                      Produto <%= "nome".equals(orderBy) ? ("ASC".equals(orderDir) ? "▲" : "▼") : "" %>
                    </a>
                  </th>
                  <th class="<%= "local_nome".equals(orderBy) ? "active" : "" %>">
                    <a href="?idProduto=<%= idProduto %>&idLocal=<%= idLocal %>&orderBy=local_nome&orderDir=<%= ("local_nome".equals(orderBy) && "ASC".equals(orderDir)) ? "DESC" : "ASC" %>">
                      Local <%= "local_nome".equals(orderBy) ? ("ASC".equals(orderDir) ? "▲" : "▼") : "" %>
                    </a>
                  </th>
                  <th class="<%= "quantidade".equals(orderBy) ? "active" : "" %>">
                    <a href="?idProduto=<%= idProduto %>&idLocal=<%= idLocal %>&orderBy=quantidade&orderDir=<%= ("quantidade".equals(orderBy) && "ASC".equals(orderDir)) ? "DESC" : "ASC" %>">
                      Quantidade <%= "quantidade".equals(orderBy) ? ("ASC".equals(orderDir) ? "▲" : "▼") : "" %>
                    </a>
                  </th>
                </tr>
              </thead>
              <tbody>
                <% if (stocks != null && !stocks.isEmpty()) {
                     for (StockLocal s : stocks) {
                %>
                <tr>
                  <td><%= s.getProduto() != null ? s.getProduto().getIdProduto() : "" %></td>
                  <td><%= s.getProduto() != null ? s.getProduto().getNome() : "" %></td>
                  <td><%= s.getLocal() != null ? s.getLocal().getNome() : "" %></td>
                  <td><%= s.getQuantidade() %></td>
                </tr>
                <%   }
                   } else { %>
                <tr>
                  <td colspan="4" style="text-align:center;">Nenhum registo de stock local encontrado.</td>
                </tr>
                <% } %>
              </tbody>
            </table>
          </div>
        </section>
      </section>
    </main>
  </div>
  <script type="module" src="/SuperMARKT/Front-end/js/pages/dashboard.js"></script>
</body>
</html>
	
