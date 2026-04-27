<%@ page import="model.Funcionario" %>
<%
  Funcionario user = (Funcionario) session.getAttribute("utilizadorLogado");
  String role = "";
  if (user != null && user.getIdFuncao() != null && user.getIdFuncao().getDescricao() != null) {
    role = user.getIdFuncao().getDescricao().toLowerCase();
  }
  boolean isAdmin = "administrador".equals(role);
  boolean isRepositor = "repositor".equals(role) || isAdmin;
  boolean isCaixa = "caixa".equals(role) || isAdmin;
%>
<aside class="sidebar">
  <div class="brand">
    <a href="/SuperMARKT/Front-end/dashboard.jsp">
      <div class="logo">S</div>
    </a>
    <a href="/SuperMARKT/Front-end/dashboard.jsp">
      <div class="name">SuperMart</div>
    </a>
<button id="toggleBtn-inside" class="toggle-btn left">
  <img src="${pageContext.request.contextPath}/Front-end/assets/sidebar-2.svg" alt="Toggle Sidebar" width="32px">
</button>
    </div>
  <nav class="nav">
    <div class="nav-section">
          <% if (isAdmin) { %>
      <div class="nav-label">Dashboard</div>
      <a class="nav-item" href="/SuperMARKT/Front-end/dashboard.jsp">Dashboard</a>
    </div>
        <% } %>
    
      <div class="nav-section">
      <% if (isRepositor) { %>
      <div class="nav-label">Gestao de Produtos</div>
      <a class="nav-item" href="${pageContext.request.contextPath}/ConsultarProdutosServlet">Produtos</a>
      <a class="nav-item" href="${pageContext.request.contextPath}/ConsultarCategoriaServlet">Categorias</a>
      <a class="nav-item" href="${pageContext.request.contextPath}/ConsultarLocalServlet">Locais</a>
      <a class="nav-item" href="${pageContext.request.contextPath}/ConsultarZonaServlet">Zonas</a>
      <a class="nav-item" href="${pageContext.request.contextPath}/ConsultarStockLocalServlet">Stock Local</a>
      <% } %>
    </div>
    
     <% if (isCaixa) { %>
    <div class="nav-section">
      <div class="nav-label">Vendas</div>
      <a class="nav-item" href="/SuperMARKT/Front-end/pages/vendas.jsp">Iniciar Venda</a>
      <a class="nav-item" href="/SuperMARKT/Front-end/pages/cancelar.jsp">Anular Venda</a>
      <a class="nav-item" href="/SuperMARKT/Front-end/pages/reembolso.jsp">Reembolso</a>
      <a class="nav-item" href="${pageContext.request.contextPath}/ConsultarClientesServlet">Clientes</a>
    </div>
    <% } %>
    
    
      <% if (isAdmin) { %>
    <div class="nav-section">
      <div class="nav-label">Sistema</div>
      <a class="nav-item" href="${pageContext.request.contextPath}/ConsultarUtilizadoresServlet">Gestao de Utilizadores</a>
      <a class="nav-item" href="/SuperMARKT/Front-end/pages/admin/promocoes.jsp">Gerir Promocoes</a>
      <% } %>
    </div>

  </nav>

  <button class="logout" onclick="location.href='${pageContext.request.contextPath}/logout'">
    Terminar Sessao
  </button>
</aside>
<script type="module" src="/SuperMARKT/Front-end/js/pages/dashboard.js"></script>
