<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<% request.setAttribute("seccao", "Vendas"); %>
<%
    
    Integer idVendaProcurada = (request.getAttribute("idVendaProcurada") != null) ? (Integer) request.getAttribute("idVendaProcurada") : null;
    Float valorVenda = (request.getAttribute("valorVenda") != null) ? (Float) request.getAttribute("valorVenda") : 0.00f;
    String erroProcura = (request.getAttribute("erroProcura") != null) ? (String) request.getAttribute("erroProcura") : null;
    List<String[]> produtosFatura = (List<String[]>) request.getAttribute("produtosFatura");
    
    
    String idStr = (idVendaProcurada != null) ? String.valueOf(idVendaProcurada) : "";
    String valorStr = String.format("%.2f", valorVenda);
%>

<!doctype html>
<html lang="pt-PT">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <title>Reembolso</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/Front-end/styles/styles.css" />
  
  <style>
    .radio-group { display: flex; flex-direction: column; gap: 10px; margin-top: 15px; }
    .radio-card { display: flex; align-items: center; padding: 12px 16px; border: 2px solid #e2e8f0; border-radius: 8px; cursor: pointer; transition: all 0.2s; }
    .radio-card:hover { border-color: #3b82f6; background-color: #eff6ff; }
    .radio-card input { margin-right: 15px; transform: scale(1.3); cursor: pointer; }
    .prod-details { display: flex; justify-content: space-between; width: 100%; }
    .prod-name { font-weight: 700; color: #1e293b; }
    .prod-price { font-weight: 800; color: #059669; }
  </style>
</head>
<body>
  <div class="app">
 	<jsp:include page="/Front-end/pages/components/sidebar.jsp" />

    <main class="main">
	<jsp:include page="/Front-end/pages/components/topbar.jsp" />     
      
      <section class="content">
        <div class="refund-head">
          <a class="back" href="${pageContext.request.contextPath}/DashboardServlet">← <span>Voltar ao Dashboard</span></a>
          <div class="refund-title">
            <h2 class="page-title">Reembolso de Fatura</h2>
            <p class="page-subtitle">Selecione os produtos exatos que o cliente deseja devolver.</p>
          </div>
        </div>

        <div class="grid grid-refund">
          <section class="card">
            <div class="card-body" style="padding: 30px;">
              <div class="sale-head" style="margin-bottom: 20px;">
                <strong style="font-size: 1.2rem; color: #1e293b;">Procurar Fatura</strong>
              </div>

              <form action="${pageContext.request.contextPath}/DevolucaoServlet" method="POST" style="display: flex; gap: 12px; align-items: flex-end;">
                <input type="hidden" name="acao" value="procurar">
                <div style="display: flex; flex-direction: column; gap: 8px; flex: 1;">
                  <input type="number" id="idVenda" name="idVenda" placeholder="Introduza o N.º da Fatura..." required 
                         value="<%= idStr %>"
                         style="padding: 14px 16px; border: 2px solid #e2e8f0; border-radius: 8px; font-size: 1.1rem; outline: none;">
                </div>
                <button type="submit" style="background-color: #3b82f6; color: white; border: none; padding: 14px 24px; border-radius: 8px; font-weight: bold; cursor: pointer; font-size: 1rem;">
                    Procurar
                </button>
              </form>

              <% if (produtosFatura != null && !produtosFatura.isEmpty()) { %>
                  <div class="sale-head" style="margin-top: 40px; margin-bottom: 10px;">
                    <strong style="font-size: 1.2rem; color: #1e293b;">Selecionar Artigos a Devolver</strong>
                  </div>
                  
                  <form id="formReembolso" action="${pageContext.request.contextPath}/DevolucaoServlet" method="POST">
                      <input type="hidden" name="acao" value="confirmar">
                      <input type="hidden" name="idVenda" value="<%= idStr %>">
                      
                      <div class="radio-group">
                          <% for (String[] prod : produtosFatura) { %>
                              <label class="radio-card">
                                  <input type="checkbox" name="idLinhaVenda" value="<%= prod[0] %>">
                                  <div class="prod-details">
                                      <span class="prod-name"><%= prod[1] %> <span style="color:#64748b; font-weight:500;">(x<%= prod[2] %>)</span></span>
                                      <span class="prod-price"><%= prod[3] %>€</span>
                                  </div>
                              </label>
                          <% } %>
                      </div>
                  </form>
              <% } %>

            </div>
          </section>

          <aside class="card">
            <div class="card-body">
              <h3 class="side-title">Resumo do Reembolso</h3>
              <div class="info-box info-blue">
                <div class="info-label">Fatura Selecionada</div>
                <div class="info-value" style="font-size: 1.1rem;">
                    <%= (idVendaProcurada != null) ? "#" + idStr : "Nenhuma" %>
                </div>
              </div>
              <div class="info-box info-green">
                <div class="info-label">Valor Total da Fatura</div>
                <div class="info-value" id="ui-total" style="font-size: 1.6rem; font-weight: 800;">
                    <%= valorStr %>€
                </div>
              </div>
              
              <div class="refund-actions" style="margin-top: 24px;">
                <% if (produtosFatura == null) { %>
                    <button type="button" class="btn-warn" disabled style="opacity: 0.5; cursor: not-allowed; width: 100%; margin-bottom: 12px; padding: 14px;">
                        Confirmar Reembolso
                    </button>
                <% } else { %>
                    <button type="button" onclick="document.getElementById('formReembolso').submit();" class="btn-warn" style="width: 100%; margin-bottom: 12px; padding: 14px; background-color: #f59e0b; color: white; border: none; font-weight: bold; cursor: pointer; border-radius: 8px;">
                        Confirmar Reembolso
                    </button>
                <% } %>
                
                <button class="btn-outline" type="button" style="width: 100%; padding: 14px;" onclick="window.location.href='${pageContext.request.contextPath}/DashboardServlet'">
                    Cancelar
                </button>
              </div>
              
            </div>
          </aside>
        </div>
      </section>
    </main>
  </div>
</body>
<script type="module" src="${pageContext.request.contextPath}/Front-end/js/pages/dashboard.js"></script>
</html>