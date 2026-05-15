<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% request.setAttribute("seccao", "Confirmar Rececao"); %>
<%@ page import="java.util.List" %>
<%@ page import="model.Encomenda" %>
<%@ page import="model.LinhaEnc" %>
<%
  Encomenda encomenda = (Encomenda) request.getAttribute("encomenda");
  List<LinhaEnc> linhas = (List<LinhaEnc>) request.getAttribute("linhas");
%>
<!doctype html>
<html lang="pt-PT">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <title>Confirmar Rececao Encomenda</title>
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
            <h2 class="page-title">Confirmar Rececao #<%= encomenda != null && encomenda.getIdMovimentos() != null ? encomenda.getIdMovimentos().getIdMovimentos() : "" %></h2>
            <p class="page-subtitle">Esta acao cria lotes no stock e atualiza quantidade no local de destino.</p>
          </div>
          <a class="btn-secondary" style="text-decoration:none;" href="${pageContext.request.contextPath}/EncomendasServlet">Voltar</a>
        </div>

        <section class="card">
          <div class="table-wrap">
            <table class="table">
              <thead>
                <tr>
                  <th>ID Linha</th>
                  <th>Produto</th>
                  <th>Quantidade</th>
                  <th>Validade</th>
                </tr>
              </thead>
              <tbody>
              <% if (linhas != null && !linhas.isEmpty()) {
                   for (LinhaEnc l : linhas) { %>
                <tr>
                  <td><%= l.getIdLinhaOrder() %></td>
                  <td><%= l.getProduto() != null ? l.getProduto().getNome() : "" %></td>
                  <td><%= l.getQuantidade() %></td>
                  <td><%= l.getDataValidade() %></td>
                </tr>
              <% } } else { %>
                <tr><td colspan="4" style="text-align:center;">Sem linhas para rececao.</td></tr>
              <% } %>
              </tbody>
            </table>
          </div>

          <form action="${pageContext.request.contextPath}/ConfirmarRececaoEncomendaServlet" method="post" style="margin-top:14px;">
            <input type="hidden" name="id_encomenda" value="<%= encomenda != null && encomenda.getIdMovimentos()!=null ? encomenda.getIdMovimentos().getIdMovimentos() : 0 %>">
            <button class="btn-submit" type="submit">Confirmar Rececao</button>
          </form>
        </section>
      </section>
    </main>
  </div>
  <script type="module" src="${pageContext.request.contextPath}/Front-end/js/pages/dashboard.js"></script>
</body>
</html>
