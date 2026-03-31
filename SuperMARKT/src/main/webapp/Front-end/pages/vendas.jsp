<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!doctype html>
<html lang="pt-PT">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <title>SuperMart â¢ Iniciar Venda</title>

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
        <div class="pagehead">
          <div>
            <h2 class="page-title">Iniciar Venda</h2>
            <p class="page-subtitle">Registo rÃ¡pido de produtos e pagamento</p>
          </div>
        </div>

        <div class="grid grid-sale">
          <!-- Ãrea principal -->
          <section class="card">
            <div class="toolbar">
              <div class="search">
                <span class="search-ico">â</span>
                <input type="text" placeholder="CÃ³digo de barras ou cÃ³digo do produto..." />
              </div>
              <button class="btn-primary">Adicionar</button>
            </div>

            <div class="card-body">
              <div class="sale-head">
                <strong>Itens da Venda</strong>
                <button class="link">Limpar</button>
              </div>

              <table class="table sale-table">
                <thead>
                  <tr>
                    <th>Produto</th>
                    <th>Quantidade</th>
                    <th>PreÃ§o Unit.</th>
                    <th>Total</th>
                    <th></th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td>
                      <div class="prod">
                        <strong>Cerveja Super Bock 6un</strong>
                        <span>BEB001</span>
                      </div>
                    </td>
                    <td class="qty">
                      <button>-</button>
                      <span>1</span>
                      <button>+</button>
                    </td>
                    <td>4.99â¬</td>
                    <td>4.99â¬</td>
                    <td class="remove">Ã</td>
                  </tr>

                  <tr>
                    <td>
                      <div class="prod">
                        <strong>Leite Meio Gordo 1L</strong>
                        <span>LAC001</span>
                      </div>
                    </td>
                    <td class="qty">
                      <button>-</button>
                      <span>1</span>
                      <button>+</button>
                    </td>
                    <td>0.89â¬</td>
                    <td>0.89â¬</td>
                    <td class="remove">Ã</td>
                  </tr>

                  <tr>
                    <td>
                      <div class="prod">
                        <strong>Iogurte Natural Pack 4</strong>
                        <span>LAC002</span>
                      </div>
                    </td>
                    <td class="qty">
                      <button>-</button>
                      <span>1</span>
                      <button>+</button>
                    </td>
                    <td>2.29â¬</td>
                    <td>2.29â¬</td>
                    <td class="remove">Ã</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </section>

          <!-- Sidebar direita -->
          <aside class="card">
            <div class="card-body">
              <h3 class="side-title">Resumo da Venda</h3>

              <div class="summary">
                <div><span>Subtotal</span><strong>8.17â¬</strong></div>
                <div><span>IVA (23%)</span><strong>1.88â¬</strong></div>
                <div class="total"><span>Total</span><strong>10.05â¬</strong></div>
              </div>

              <button class="btn-success">Finalizar Venda</button>
              <button class="btn-outline">Cancelar Venda</button>

              <hr />

              <h3 class="side-title">Produtos RÃ¡pidos</h3>
              <div class="quick-products">
                <button>Arroz Carolino 1kg<br><span>1.99â¬</span></button>
                <button>Azeite Virgem Extra 750ml<br><span>5.49â¬</span></button>
                <button>Leite Meio Gordo 1L<br><span>0.89â¬</span></button>
                <button>Iogurte Natural Pack 4<br><span>2.29â¬</span></button>
                <button>Cerveja Super Bock 6un<br><span>4.99â¬</span></button>
                <button>Ãgua Mineral 1.5L<br><span>0.49â¬</span></button>
              </div>
            </div>
          </aside>
        </div>
      </section>
    </main>
  </div>
</body>
<script type="module" src="/SuperMARKT/Front-end/js/pages/dashboard.js"></script>
</html>
