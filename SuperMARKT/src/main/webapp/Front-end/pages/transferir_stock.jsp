<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Local" %>
<%
  String preIdProduto = request.getParameter("idProduto");
  String preIdOrigem = request.getParameter("idOrigem");
  String preIdDestino = request.getParameter("idDestino");
  if (preIdProduto == null) preIdProduto = "";
  if (preIdOrigem == null) preIdOrigem = "";
  if (preIdDestino == null) preIdDestino = "";
  List<Local> locais = (List<Local>) request.getAttribute("locais");
%>
<!doctype html>
<html lang="pt-PT">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <title>SuperMart - Transferir Stock</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800;900&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/Front-end/styles/styles.css" />
</head>
<body>
  <div class="app">
    <jsp:include page="/Front-end/pages/components/sidebar.jsp" />

    <main class="main">
      <jsp:include page="/Front-end/pages/components/topbar.jsp" />

      <section class="content">
        <div style="margin-bottom: 24px;">
          <h1 style="font-size: 1.8rem; font-weight: 900; color: #0f172a; margin: 0;">Transferir Stock</h1>
          <p style="color: #64748b; margin-top: 4px; font-size: 0.95rem;">Move as tuas mercadorias entre locais de forma segura.</p>
        </div>

        <% String msgSucesso = (String) request.getAttribute("sucesso"); %>
        <% String msgErro = (String) request.getAttribute("erro"); %>

        <% if (msgSucesso != null) { %>
          <div class="alert success">✅ <%= msgSucesso %></div>
        <% } %>

        <% if (msgErro != null) { %>
          <div class="alert error">❌ <%= msgErro %></div>
        <% } %>

        <div class="grid grid-top">
          <section class="card">
            <div class="card-head simple">
              <h2>Detalhes da Movimentacao</h2>
            </div>
            <div class="card-body">
              <form action="${pageContext.request.contextPath}/TransferirStockServlet" method="post">
                <div class="form-group">
                  <label class="form-label" for="idProduto">ID do Produto</label>
                  <input type="number" name="idProduto" id="idProduto" class="form-control" placeholder="Ex: 5" required min="1" value="<%= preIdProduto %>">
                </div>

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                  <div class="form-group">
                    <label class="form-label" for="idOrigem">De (Origem)</label>
                    <select name="idOrigem" id="idOrigem" class="form-control" required>
                      <option value="">-- Selecione --</option>
                      <% if (locais != null) { for (Local l : locais) { %>
                        <option value="<%= l.getIdLocal() %>" <%= String.valueOf(l.getIdLocal()).equals(preIdOrigem) ? "selected" : "" %>>
                          <%= l.getNome() %> (<%= l.getTipoLocal() %>)
                        </option>
                      <% } } %>
                    </select>
                  </div>

                  <div class="form-group">
                    <label class="form-label" for="idDestino">Para (Destino)</label>
                    <select name="idDestino" id="idDestino" class="form-control" required>
                      <option value="">-- Selecione --</option>
                      <% if (locais != null) { for (Local l : locais) { %>
                        <option value="<%= l.getIdLocal() %>" <%= String.valueOf(l.getIdLocal()).equals(preIdDestino) ? "selected" : "" %>>
                          <%= l.getNome() %> (<%= l.getTipoLocal() %>)
                        </option>
                      <% } } %>
                    </select>
                  </div>
                </div>

                <div class="form-group">
                  <label class="form-label" for="quantidade">Quantidade a Transferir</label>
                  <input type="number" name="quantidade" id="quantidade" class="form-control" placeholder="Ex: 20" required min="1">
                </div>

                <button type="submit" class="btn-submit">Confirmar Transferencia</button>
              </form>
            </div>
          </section>

          <section class="card">
            <div class="card-head simple">
              <h2>Instrucoes</h2>
            </div>
            <div class="card-body">
              <p style="font-size: 0.9rem; color: #475569; line-height: 1.6;">
                Nesta pagina podes gerir a localizacao fisica da tua mercadoria.
              </p>
              <ul style="font-size: 0.9rem; color: #1e293b; font-weight: 500; margin-top: 15px; line-height: 1.8; padding-left: 20px;">
                <li>O sistema verifica automaticamente se tens unidades suficientes na Origem antes de aprovar.</li>
                <li>Se transferires para um Destino onde o produto ainda nao existe, ele e criado com essa quantidade.</li>
                <li>Podes consultar o <strong style="color: #3b82f6;">ID do Produto</strong> na pagina "Produtos".</li>
              </ul>
            </div>
          </section>
        </div>
      </section>
    </main>
  </div>

  <script type="module" src="${pageContext.request.contextPath}/Front-end/js/pages/dashboard.js"></script>
</body>
</html>
