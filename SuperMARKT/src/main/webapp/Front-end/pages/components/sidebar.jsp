<aside class="sidebar">
  <div class="brand">
    <a href="/SuperMARKT/Front-end/dashboard.jsp">
      <div class="logo">S</div>
    </a>
    <a href="/SuperMARKT/Front-end/dashboard.jsp">
      <div class="name">SuperMart</div>
    </a>
  </div>

  <nav class="nav">

    <div class="nav-section">
      <div class="nav-label">Dashboard</div>
      <a class="nav-item" href="/SuperMARKT/Front-end/dashboard.jsp">Dashboard</a>
    </div>

    <div class="nav-section">
      <div class="nav-label">Gestão de Produtos</div>
      <a class="nav-item" href="/SuperMARKT/Front-end/pages/registar.jsp">Registar Produto</a>
      <a class="nav-item" href="/SuperMARKT/Front-end/pages/rececao.jsp">Receção de Encomenda</a>
      <a class="nav-item" href="/SuperMARKT/Front-end/pages/movimentar.jsp">Movimentar para Loja</a>
      <a class="nav-item" href="/SuperMARKT/ProdutoServlet">Consultar Stock</a>
    </div>

    <div class="nav-section">
      <div class="nav-label">Vendas</div>
      <a class="nav-item" href="/SuperMARKT/Front-end/pages/vendas.jsp">Iniciar Venda</a>
      <a class="nav-item" href="/SuperMARKT/Front-end/pages/cancelar.jsp">Cancelar Venda</a>
      <a class="nav-item" href="/SuperMARKT/Front-end/pages/reembolso.jsp">Reembolso</a>
    </div>

    <div class="nav-section">
      <div class="nav-label">Sistema</div>
      <a class="nav-item" href="/SuperMARKT/Front-end/pages/admin/utilizadores.jsp">Gestão de Utilizadores</a>
      <a class="nav-item" href="/SuperMARKT/Front-end/pages/admin/promocoes.jsp">Gerir Promoções</a>
    </div>

  </nav>

  <button class="logout" onclick="location.href='/SuperMARKT/Front-end/pages/logout.jsp'">
    Terminar Sessão
  </button>
</aside>