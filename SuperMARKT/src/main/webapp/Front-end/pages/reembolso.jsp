<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!doctype html>
<html lang="pt-PT">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <title>Reembolso</title>

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
	<jsp:include page="/Front-end/pages/components/topbar.jsp" />     <!-- CONTENT -->
      <section class="content">
        <div class="refund-head">
          <a class="back" href="../index.html">← <span>Voltar</span></a>

          <div class="refund-title">
            <h2 class="page-title">Reembolso - V001</h2>
            <p class="page-subtitle">04/12/2024 às 10:23 · Total original: 18.45€</p>
          </div>
        </div>

        <div class="grid grid-refund">
          <!-- ESQUERDA -->
          <section class="card">
            <div class="toolbar">
              <div class="search">
                <span class="search-ico">⌕</span>
                <input type="text" placeholder="Ler código de barras do produto..." />
              </div>
              <button class="btn-primary" type="button">Adicionar</button>
            </div>

            <div class="card-body">
              <div class="sale-head">
                <strong>Produtos da Venda Original</strong>
              </div>

              <div class="refund-list">
                <div class="refund-item">
                  <div class="prod">
                    <strong>Arroz Carolino 1kg</strong>
                    <span>MER001</span>
                  </div>
                  <div class="refund-right">
                    <span class="muted2">2x 1.99€</span>
                    <button class="btn-soft" type="button">Reembolsar</button>
                  </div>
                </div>

                <div class="refund-item">
                  <div class="prod">
                    <strong>Azeite Virgem Extra 750ml</strong>
                    <span>MER002</span>
                  </div>
                  <div class="refund-right">
                    <span class="muted2">1x 5.49€</span>
                    <button class="btn-soft" type="button">Reembolsar</button>
                  </div>
                </div>

                <div class="refund-item">
                  <div class="prod">
                    <strong>Leite Meio Gordo 1L</strong>
                    <span>LAC001</span>
                  </div>
                  <div class="refund-right">
                    <span class="muted2">3x 0.89€</span>
                    <button class="btn-soft" type="button">Reembolsar</button>
                  </div>
                </div>
              </div>
            </div>
          </section>

          <!-- DIREITA -->
          <aside class="card">
            <div class="card-body">
              <h3 class="side-title">Resumo do Reembolso</h3>

              <div class="info-box info-blue">
                <div class="info-label">Produtos Selecionados</div>
                <div class="info-value">0</div>
              </div>

              <div class="info-box info-green">
                <div class="info-label">Total a Reembolsar</div>
                <div class="info-value">0.00€</div>
              </div>

              <div class="info-box info-gray">
                <div class="info-label">Método Original</div>
                <div class="info-small">Dinheiro</div>
              </div>

              <div class="refund-actions">
                <button class="btn-warn" type="button">Processar Reembolso</button>
                <button class="btn-outline" type="button">Cancelar</button>
              </div>
            </div>
          </aside>
        </div>

        <button class="help" type="button" aria-label="Ajuda" onclick="location.href='Ajuda.html'">?</button>
      </section>
    </main>
  </div>
</body>
<script type="module" src="/SuperMARKT/Front-end/js/pages/dashboard.js"></script>
</html>
