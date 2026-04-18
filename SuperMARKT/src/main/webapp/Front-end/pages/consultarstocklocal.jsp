	<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% request.setAttribute("seccao", "Gestão de Stock Local"); %>
<%@ page import="java.util.List" %>
<%@ page import="model.StockLocal" %>

<%
  List<StockLocal> stocks = (List<StockLocal>) request.getAttribute("stocks");
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
          <div class="table-wrap">
            <table class="table">
              <thead>
                <tr>
                  <th>ID Produto</th>
                  <th>Produto</th>
                  <th>Local</th>
                  <th>Quantidade</th>
                  <th>Data Validade mais proixma </th>
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
	