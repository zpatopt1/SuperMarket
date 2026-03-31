<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!doctype html>
<html lang="pt-PT">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <title>SuperMart â¢ Consultar Stock</title>

  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&display=swap" rel="stylesheet">

  <link rel="stylesheet" href="../styles/styles.css" />
</head>
<body>
  <div class="app">
	<!-- Sidebar -->
	<jsp:include page="/Front-end/pages/components/sidebar.jsp" />

    <!-- Main -->
    <main class="main">

	<!-- Topbar -->
	<jsp:include page="/Front-end/pages/components/topbar.jsp" />
      <section class="content">
        <!-- Page header -->
        <div class="pagehead">
          <div>
            <h2 class="page-title">Consultar Stock</h2>
            <p class="page-subtitle">GestÃ£o e consulta de inventÃ¡rio</p>
          </div>

          <button class="btn-primary" type="button">Exportar RelatÃ³rio</button>
        </div>

        <!-- KPIs -->
        <div class="kpis kpis-stock">
          <div class="kpi">
            <div class="kpi-label">Total Produtos</div>
            <div class="kpi-value">8</div>
          </div>

          <div class="kpi">
            <div class="kpi-label">Stock Baixo</div>
            <div class="kpi-value">3</div>
          </div>

          <div class="kpi">
            <div class="kpi-label">Stock Loja</div>
            <div class="kpi-value">200</div>
          </div>

          <div class="kpi">
            <div class="kpi-label">Valor Total</div>
            <div class="kpi-value">1913.32 <span>â¬</span></div>
          </div>
        </div>

        <!-- Search + filter -->
        <div class="card">
          <div class="toolbar">
            <div class="search">
              <span class="search-ico" aria-hidden="true">â</span>
              <input type="text" placeholder="Pesquisar por nome ou cÃ³digo..." />
            </div>

            <button class="filterbtn" type="button">Todas as Categorias â¾</button>
          </div>
        </div>

        <!-- Table -->
        <section class="card">
          <div class="table-wrap">
            <table class="table">
              <thead>
                <tr>
                  <th>CÃ³digo</th>
                  <th>Produto</th>
                  <th>Categoria</th>
                  <th>Stock Loja</th>
                  <th>Stock ArmazÃ©m</th>
                  <th>Stock MÃ­nimo</th>
                  <th>LocalizaÃ§Ã£o</th>
                  <th>PreÃ§o</th>
                  <th>Estado</th>
                </tr>
              </thead>

              <tbody>
                <tr>
                  <td>MER001</td>
                  <td>Arroz Carolino 1kg</td>
                  <td><span class="pill">Mercearia</span></td>
                  <td>45</td>
                  <td>120</td>
                  <td>20</td>
                  <td>A-12</td>
                  <td>1.99â¬</td>
                  <td><span class="badge ok">Normal</span></td>
                </tr>

                <tr>
                  <td>MER002</td>
                  <td>Azeite Virgem Extra 750ml</td>
                  <td><span class="pill">Mercearia</span></td>
                  <td>8</td>
                  <td>35</td>
                  <td>10</td>
                  <td>A-15</td>
                  <td>5.49â¬</td>
                  <td><span class="badge low">Stock Baixo</span></td>
                </tr>

                <tr>
                  <td>LAC001</td>
                  <td>Leite Meio Gordo 1L</td>
                  <td><span class="pill">LacticÃ­nios</span></td>
                  <td>32</td>
                  <td>80</td>
                  <td>25</td>
                  <td>B-03</td>
                  <td>0.89â¬</td>
                  <td><span class="badge ok">Normal</span></td>
                </tr>

                <tr>
                  <td>LAC002</td>
                  <td>Iogurte Natural Pack 4</td>
                  <td><span class="pill">LacticÃ­nios</span></td>
                  <td>5</td>
                  <td>15</td>
                  <td>15</td>
                  <td>B-05</td>
                  <td>2.29â¬</td>
                  <td><span class="badge low">Stock Baixo</span></td>
                </tr>

                <tr>
                  <td>BEB001</td>
                  <td>Cerveja Super Bock 6un</td>
                  <td><span class="pill">Bebidas</span></td>
                  <td>28</td>
                  <td>95</td>
                  <td>20</td>
                  <td>C-08</td>
                  <td>4.99â¬</td>
                  <td><span class="badge ok">Normal</span></td>
                </tr>

                <tr>
                  <td>BEB002</td>
                  <td>Ãgua Mineral 1.5L</td>
                  <td><span class="pill">Bebidas</span></td>
                  <td>67</td>
                  <td>200</td>
                  <td>40</td>
                  <td>C-02</td>
                  <td>0.49â¬</td>
                  <td><span class="badge ok">Normal</span></td>
                </tr>

                <tr>
                  <td>LIM001</td>
                  <td>Detergente Roupa 2L</td>
                  <td><span class="pill">Limpeza</span></td>
                  <td>12</td>
                  <td>45</td>
                  <td>10</td>
                  <td>D-10</td>
                  <td>6.99â¬</td>
                  <td><span class="badge ok">Normal</span></td>
                </tr>

                <tr>
                  <td>HIG001</td>
                  <td>Papel HigiÃ©nico 12 rolos</td>
                  <td><span class="pill">Higiene</span></td>
                  <td>3</td>
                  <td>8</td>
                  <td>15</td>
                  <td>D-15</td>
                  <td>5.49â¬</td>
                  <td><span class="badge low">Stock Baixo</span></td>
                </tr>
              </tbody>
            </table>
          </div>
        </section>

        <button class="help" type="button" aria-label="Ajuda" onclick="location.href='Ajuda.html'">?</button>
      </section>
    </main>
  </div>
</body>
<script type="module" src="w/SuperMARKT/Front-end/js/pages/dashboard.js"></script>
</html>
