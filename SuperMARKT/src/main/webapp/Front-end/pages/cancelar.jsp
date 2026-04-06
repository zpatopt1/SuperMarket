<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% request.setAttribute("seccao", "Vendas"); %>

<!doctype html>
<html lang="pt-PT">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1" />

  <title>SuperMart • Anular Venda</title>

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
            <h2 class="page-title">Anular Venda</h2>
            <p class="page-subtitle">Pesquise o talão e confirme a anulação total da transação</p>
          </div>
        </div>

        <div style="background-color: #fff3cd; color: #856404; border-left: 5px solid #ffeeba; padding: 15px 20px; margin-bottom: 20px; border-radius: 6px; font-size: 14px; font-family: inherit;">
            <strong style="display: block; margin-bottom: 5px; font-size: 15px;">Atenção!</strong>
            A anulação de uma venda é uma ação <strong>irreversível</strong>. O stock dos produtos será devolvido automaticamente e o valor será subtraído do fecho de caixa do dia.
        </div>

        <div class="grid grid-sale">
          
          <section class="card">
            <div class="toolbar" style="display: flex; gap: 15px; padding: 15px; border-bottom: 1px solid #e5e7eb;">
              <div class="search" style="flex: 1; border: 1px solid #d1d5db; border-radius: 6px; padding: 8px 15px; display: flex; align-items: center;">
                <span class="search-ico" style="color: #6b7280; margin-right: 8px;">⌕</span>
                <input type="text" placeholder="Ler código de barras do talão ou ID da Venda..." style="border: none; outline: none; width: 100%; font-family: inherit; font-size: 14px;" />
              </div>
              <button class="btn-primary" style="padding: 8px 25px; border-radius: 6px; background-color: #2563eb; color: white; border: none; font-weight: 600; cursor: pointer;">Procurar</button>
            </div>

            <div class="card-body" style="padding: 20px;">
              <h3 style="margin-bottom: 15px; font-size: 16px; color: #111827;">Produtos da Venda Original</h3>
              
              <div style="border: 1px solid #e5e7eb; border-radius: 6px; padding: 15px; margin-bottom: 10px; display: flex; justify-content: space-between; align-items: center; background: #f9fafb;">
                <div>
                    <strong style="color: #111827; display: block;">Arroz Carolino 1kg</strong> 
                    <span style="color:#6b7280; font-size:13px;">MER001</span>
                </div>
                <div style="font-weight: 600; color: #374151;">2 × 1.99€</div>
              </div>

              <div style="border: 1px solid #e5e7eb; border-radius: 6px; padding: 15px; margin-bottom: 10px; display: flex; justify-content: space-between; align-items: center; background: #f9fafb;">
                <div>
                    <strong style="color: #111827; display: block;">Azeite Virgem Extra 750ml</strong> 
                    <span style="color:#6b7280; font-size:13px;">MER002</span>
                </div>
                <div style="font-weight: 600; color: #374151;">1 × 5.49€</div>
              </div>

              <div style="border: 1px solid #e5e7eb; border-radius: 6px; padding: 15px; margin-bottom: 10px; display: flex; justify-content: space-between; align-items: center; background: #f9fafb;">
                <div>
                    <strong style="color: #111827; display: block;">Leite Meio Gordo 1L</strong> 
                    <span style="color:#6b7280; font-size:13px;">LAC001</span>
                </div>
                <div style="font-weight: 600; color: #374151;">3 × 0.89€</div>
              </div>

            </div>
          </section>

          <aside class="card">
            <div class="card-body" style="padding: 20px;">
              <h3 class="side-title" style="font-size: 16px; margin-bottom: 20px; color: #111827;">Resumo da Anulação</h3>

              <div style="background: #fef2f2; border: 1px solid #fecaca; border-radius: 6px; padding: 15px; margin-bottom: 15px;">
                <span style="display:block; font-size: 13px; color: #991b1b; margin-bottom: 5px;">Total a Retirar da Caixa</span>
                <strong style="font-size: 24px; color: #991b1b;">12.14€</strong>
              </div>

              <div style="background: #f9fafb; border: 1px solid #e5e7eb; border-radius: 6px; padding: 15px; margin-bottom: 25px;">
                <span style="display:block; font-size: 13px; color: #6b7280; margin-bottom: 5px;">Método Original</span>
                <strong style="font-size: 15px; color: #374151;">Dinheiro</strong>
              </div>

              <button style="width: 100%; padding: 14px; background: #dc2626; color: white; border: none; border-radius: 6px; font-weight: 600; cursor: pointer; margin-bottom: 10px; font-size: 15px; font-family: inherit;">Confirmar Anulação</button>
              
              <button style="width: 100%; padding: 14px; background: white; color: #374151; border: 1px solid #d1d5db; border-radius: 6px; font-weight: 600; cursor: pointer; font-size: 15px; font-family: inherit;">Limpar Ecrã</button>

            </div>
          </aside>
        </div>
      </section>
    </main>
  </div>
</body>
</html>