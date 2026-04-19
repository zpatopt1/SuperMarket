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
    f
    </div>  
  <nav class="nav">
    <div class="nav-section">
      <div class="nav-label">Dashboard</div>
      <a class="nav-item" href="/SuperMARKT/Front-end/dashboard.jsp">Dashboard</a>
    </div>

    <div class="nav-section">
      <div class="nav-label">Gestão de Produtos</div>
      <a class="nav-item" href="${pageContext.request.contextPath}/ConsultarProdutosServlet">Produtos</a>
      <a class="nav-item" href="${pageContext.request.contextPath}/ConsultarLocalServlet">Locais</a>
      <a class="nav-item" href="${pageContext.request.contextPath}/ConsultarCategoriaServlet">Consultar Categorias</a>
      <a class="nav-item" href="${pageContext.request.contextPath}/ConsultarZonaServlet">Consultar Zonas</a>
      <a class="nav-item" href="${pageContext.request.contextPath}/ConsultarStockLocalServlet">Consultar stock</a>

      
    </div>

    <div class="nav-section">
      <div class="nav-label">Vendas</div>
      <a class="nav-item" href="/SuperMARKT/Front-end/pages/vendas.jsp">Iniciar Venda</a>
      <a class="nav-item" href="/SuperMARKT/Front-end/pages/cancelar.jsp">Anular Venda</a>
      <a class="nav-item" href="/SuperMARKT/Front-end/pages/reembolso.jsp">Reembolso</a>
    </div>

    <div class="nav-section">
      <div class="nav-label">Sistema</div>
      <a class="nav-item" href="/SuperMARKT/Front-end/pages/admin/utilizadores.jsp">Gest�o de Utilizadores</a>
      <a class="nav-item" href="/SuperMARKT/Front-end/pages/admin/promocoes.jsp">Gerir Promo��es</a>
    </div>

  </nav>

  <button class="logout" onclick="location.href='/SuperMARKT/Front-end/pages/logout.jsp'">
    Terminar Sess�o
  </button>
</aside>
<script type="module" src="/SuperMARKT/Front-end/js/pages/dashboard.js"></script>

