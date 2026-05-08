<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% request.setAttribute("seccao", "Vendas"); %>

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
 	<jsp:include page="/Front-end/pages/components/sidebar.jsp" />

    <main class="main">

	<jsp:include page="/Front-end/pages/components/topbar.jsp" />     
      
      <section class="content">
        <div class="refund-head">
          <a class="back" href="../index.html">← <span>Voltar</span></a>

          <div class="refund-title">
            <h2 class="page-title">Reembolso - V001</h2>
            <p class="page-subtitle">04/12/2024 às 10:23 · Total original: 18.45€</p>
          </div>
        </div>

        <div class="grid grid-refund">
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
                    <button class="btn-soft" type="button" onclick="selecionarParaReembolso(4, 1.99)">Reembolsar</button>
                  </div>
                </div>

                <div class="refund-item">
                  <div class="prod">
                    <strong>Azeite Virgem Extra 750ml</strong>
                    <span>MER002</span>
                  </div>
                  <div class="refund-right">
                    <span class="muted2">1x 5.49€</span>
                    <button class="btn-soft" type="button" onclick="selecionarParaReembolso(5, 5.49)">Reembolsar</button>
                  </div>
                </div>

                <div class="refund-item">
                  <div class="prod">
                    <strong>Leite Meio Gordo 1L</strong>
                    <span>LAC001</span>
                  </div>
                  <div class="refund-right">
                    <span class="muted2">3x 0.89€</span>
                    <button class="btn-soft" type="button" onclick="selecionarParaReembolso(6, 0.89)">Reembolsar</button>
                  </div>
                </div>
              </div>
            </div>
          </section>

          <aside class="card">
            <div class="card-body">
              <h3 class="side-title">Resumo do Reembolso</h3>

              <div class="info-box info-blue">
                <div class="info-label">Produtos Selecionados</div>
                <div class="info-value" id="ui-qtd">0</div>
              </div>

              <div class="info-box info-green">
                <div class="info-label">Total a Reembolsar</div>
                <div class="info-value" id="ui-total">0.00€</div>
              </div>

              <div class="info-box info-gray">
                <div class="info-label">Método Original</div>
                <div class="info-small">Dinheiro</div>
              </div>

              <div class="refund-actions">
                <form action="${pageContext.request.contextPath}/DevolucaoServlet" method="POST" style="width: 100%; margin: 0; padding: 0;">
                    <input type="hidden" name="idLinhaVenda" id="form-idLinha" value="">
                    <input type="hidden" name="motivo" value="Devolução a pedido do cliente">
                    <input type="hidden" name="quantidade" id="form-qtd" value="0">
                    <input type="hidden" name="valor" id="form-valor" value="0.00">
                    <input type="hidden" name="reporStock" value="sim">
                    
                    <button class="btn-warn" type="submit" style="width: 100%; margin-bottom: 8px;">Processar Reembolso</button>
                </form>

                <button class="btn-outline" type="button" style="width: 100%;" onclick="location.reload();">Cancelar</button>
              </div>
            </div>
          </aside>
        </div>

      </section>
    </main>
  </div>

  <script>
    function selecionarParaReembolso(idLinha, precoUnitario) {
        
        document.getElementById('ui-qtd').innerText = "1";
        document.getElementById('ui-total').innerText = precoUnitario + "€";

       
        document.getElementById('form-idLinha').value = idLinha;
        document.getElementById('form-valor').value = precoUnitario;
        document.getElementById('form-qtd').value = "1";
    }
  </script>

</body>
<script type="module" src="/SuperMARKT/Front-end/js/pages/dashboard.js"></script>
</html>