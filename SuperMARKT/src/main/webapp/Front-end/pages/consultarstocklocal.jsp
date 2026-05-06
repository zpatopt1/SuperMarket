	<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% request.setAttribute("seccao", "Gestão de Stock Local"); %>
<%@ page import="java.util.List" %>
<%@ page import="model.StockLocal" %>
<%
  List<StockLocal> stocks = (List<StockLocal>) request.getAttribute("stocks");
  String idProduto = (String) request.getAttribute("idProduto");
  String idLocal = (String) request.getAttribute("idLocal");
  String orderBy = (String) request.getAttribute("orderBy");
  String orderDir = (String) request.getAttribute("orderDir");
  if (idProduto == null) idProduto = "";
  if (idLocal == null) idLocal = "";
  if (orderBy == null) orderBy = "id_produto";
  if (orderDir == null) orderDir = "ASC";
%>
<!DOCTYPE html>
<html lang="pt-PT">
<head>
    <meta charset="UTF-8">
    <title>Stock Local</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Front-end/styles/styles.css" />
    <style>
      /* Premium Table Styling */
      .table-wrap {
        border-radius: 12px;
        overflow: hidden;
        box-shadow: 0 4px 15px -3px rgba(0,0,0,0.05);
        border: 1px solid #e2e8f0;
        background: white;
      }
      .table th {
        background-color: #f8fafc;
        color: #334155;
        font-weight: 700;
        text-transform: uppercase;
        font-size: 0.8rem;
        letter-spacing: 0.05em;
        padding: 16px;
        border-bottom: 2px solid #e2e8f0;
      }
      .table td {
        padding: 14px 16px;
        color: #1e293b;
        vertical-align: middle;
        border-bottom: 1px solid #f1f5f9;
      }
      .table tbody tr:hover {
        background-color: #f8fafc;
        transition: background-color 0.2s ease;
      }
      
      .badge-qty {
        padding: 6px 12px;
        border-radius: 999px;
        font-size: 0.85rem;
        font-weight: 700;
        display: inline-block;
        text-align: center;
        min-width: 60px;
      }
      .badge-danger {
        background-color: #fee2e2;
        color: #b91c1c;
      }
      .badge-warning {
        background-color: #fef3c7;
        color: #b45309;
      }
      .badge-success {
        background-color: #d1fae5;
        color: #047857;
      }
      
      .search input {
        border-radius: 8px;
        border: 1px solid #cbd5e1;
        padding: 10px 10px 10px 36px;
        transition: border-color 0.2s, box-shadow 0.2s;
      }
      .search input:focus {
        border-color: #3b82f6;
        box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
        outline: none;
      }
    </style>
</head>
<body>
  <div class="app">
    <jsp:include page="/Front-end/pages/components/sidebar.jsp" />
    <main class="main">
      <jsp:include page="/Front-end/pages/components/topbar.jsp" />
      <section class="content">
        <div class="pagehead">
          <div>
            <h2 class="page-title">Stock Local</h2>
            <p class="page-subtitle">Consulta de stock por local</p>
          </div>
        </div>
        <section class="card">
          <form action="${pageContext.request.contextPath}/ConsultarStockLocalServlet" method="get" class="toolbar">
            <div class="search">
              <span class="search-ico" aria-hidden="true">⌕</span>
              <input type="number" name="idProduto" min="1" placeholder="Filtrar por ID Produto" value="<%= idProduto %>" />
            </div>
            <div class="search">
              <span class="search-ico" aria-hidden="true">⌕</span>
              <input type="number" name="idLocal" min="1" placeholder="Filtrar por ID Local" value="<%= idLocal %>" />
            </div>
            <input type="hidden" name="orderBy" value="<%= orderBy %>">
            <input type="hidden" name="orderDir" value="<%= orderDir %>">
            <button type="submit" class="btn-primary">Filtrar</button>
          </form>

          <div class="table-wrap">
            <table class="table">
              <thead>
                <tr>
                  <th class="<%= "id_produto".equals(orderBy) ? "active" : "" %>">
                    <a href="?idProduto=<%= idProduto %>&idLocal=<%= idLocal %>&orderBy=id_produto&orderDir=<%= ("id_produto".equals(orderBy) && "ASC".equals(orderDir)) ? "DESC" : "ASC" %>">
                      ID Produto <%= "id_produto".equals(orderBy) ? ("ASC".equals(orderDir) ? "▲" : "▼") : "" %>
                    </a>
                  </th>
                  <th class="<%= "nome".equals(orderBy) ? "active" : "" %>">
                    <a href="?idProduto=<%= idProduto %>&idLocal=<%= idLocal %>&orderBy=nome&orderDir=<%= ("nome".equals(orderBy) && "ASC".equals(orderDir)) ? "DESC" : "ASC" %>">
                      Produto <%= "nome".equals(orderBy) ? ("ASC".equals(orderDir) ? "▲" : "▼") : "" %>
                    </a>
                  </th>
                  <th class="<%= "local_nome".equals(orderBy) ? "active" : "" %>">
                    <a href="?idProduto=<%= idProduto %>&idLocal=<%= idLocal %>&orderBy=local_nome&orderDir=<%= ("local_nome".equals(orderBy) && "ASC".equals(orderDir)) ? "DESC" : "ASC" %>">
                      Local <%= "local_nome".equals(orderBy) ? ("ASC".equals(orderDir) ? "▲" : "▼") : "" %>
                    </a>
                  </th>
                  <th class="<%= "quantidade".equals(orderBy) ? "active" : "" %>">
                    <a href="?idProduto=<%= idProduto %>&idLocal=<%= idLocal %>&orderBy=quantidade&orderDir=<%= ("quantidade".equals(orderBy) && "ASC".equals(orderDir)) ? "DESC" : "ASC" %>">
                      Quantidade <%= "quantidade".equals(orderBy) ? ("ASC".equals(orderDir) ? "▲" : "▼") : "" %>
                    </a>
                  </th>
                  <th>Ações</th>
                </tr>
              </thead>
              <tbody>
                <% if (stocks != null && !stocks.isEmpty()) {
                     for (StockLocal s : stocks) {
                %>
                <tr>
                  <td><%= s.getProduto() != null ? s.getProduto().getIdProduto() : "" %></td>
                  <td><%= s.getProduto() != null ? s.getProduto().getNome() : "" %></td>
                  <td><%= s.getLocal() != null ? s.getLocal().getNome() : "" %></td>
                  <td>
                    <% 
                       int q = s.getQuantidade();
                       String badgeClass = "badge-success";
                       if (q < 10) badgeClass = "badge-danger";
                       else if (q < 50) badgeClass = "badge-warning";
                    %>
                    <span class="badge-qty <%= badgeClass %>"><%= q %></span>
                  </td>
                  <td>
                    <button type="button" class="btn-danger" style="font-size: 0.75rem; padding: 6px 10px;" onclick="openPerdaModal(<%= s.getProduto() != null ? s.getProduto().getIdProduto() : 0 %>, <%= s.getLocal() != null ? s.getLocal().getIdLocal() : 0 %>, <%= q %>)">
                      Registar Quebra
                    </button>
                  </td>
                </tr>
                <%   }
                   } else { %>
                <tr>
                  <td colspan="5" style="text-align:center;">Nenhum registo de stock local encontrado.</td>
                </tr>
                <% } %>
              </tbody>
            </table>
          </div>
        </section>
      </section>
    </main>
  </div>

  <!-- Modal para Registar Quebra de Stock -->
  <div id="modalPerda" class="modal-overlay" style="display: none;">
    <div class="modal-content">
      <h3 style="margin-top: 0; color: #b91c1c;">Registar Quebra de Stock</h3>
      <p style="font-size: 0.9rem; color: #64748b; margin-bottom: 20px;">Preencha os dados abaixo para justificar a perda do artigo.</p>
      
      <form action="${pageContext.request.contextPath}/RegistarPerdaServlet" method="post">
        <input type="hidden" name="idProduto" id="perdaIdProduto">
        <input type="hidden" name="idLocal" id="perdaIdLocal">
        <input type="hidden" name="filterIdLocal" value="<%= idLocal %>">
        
        <div style="margin-bottom: 15px;">
          <label style="display: block; margin-bottom: 5px; font-weight: 600; font-size: 0.9rem;">Quantidade Perdida</label>
          <input type="number" name="quantidade" id="perdaQuantidade" min="1" required style="width: 100%; border-radius: 8px; border: 1px solid #cbd5e1; padding: 10px; box-sizing: border-box;" />
          <small id="maxQtdText" style="color: #64748b; display: block; margin-top: 5px;"></small>
        </div>
        
        <div style="margin-bottom: 20px;">
          <label style="display: block; margin-bottom: 5px; font-weight: 600; font-size: 0.9rem;">Motivo da Perda</label>
          <select name="motivo" required style="width: 100%; border-radius: 8px; border: 1px solid #cbd5e1; padding: 10px; box-sizing: border-box; background: white;">
            <option value="">Selecione um motivo...</option>
            <option value="Prazo de Validade Expirado">Prazo de Validade Expirado</option>
            <option value="Produto Danificado">Produto Danificado</option>
            <option value="Furto / Roubo">Furto / Roubo</option>
            <option value="Qualidade Comprometida">Qualidade Comprometida</option>
            <option value="Outro">Outro</option>
          </select>
        </div>
        
        <div style="display: flex; justify-content: flex-end; gap: 10px;">
          <button type="button" class="btn-secondary" onclick="closePerdaModal()">Cancelar</button>
          <button type="submit" class="btn-danger">Confirmar Registo</button>
        </div>
      </form>
    </div>
  </div>

  <style>
    .modal-overlay {
      position: fixed;
      top: 0; left: 0; right: 0; bottom: 0;
      background: rgba(15, 23, 42, 0.6);
      display: flex;
      align-items: center;
      justify-content: center;
      z-index: 1000;
      backdrop-filter: blur(4px);
    }
    .modal-content {
      background: white;
      padding: 30px;
      border-radius: 12px;
      width: 100%;
      max-width: 450px;
      box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
    }
    .btn-danger {
      background-color: #ef4444;
      color: white;
      border: none;
      border-radius: 6px;
      padding: 10px 16px;
      font-weight: 600;
      cursor: pointer;
      transition: background-color 0.2s;
    }
    .btn-danger:hover {
      background-color: #dc2626;
    }
    .btn-secondary {
      background-color: #e2e8f0;
      color: #475569;
      border: none;
      border-radius: 6px;
      padding: 10px 16px;
      font-weight: 600;
      cursor: pointer;
      transition: background-color 0.2s;
    }
    .btn-secondary:hover {
      background-color: #cbd5e1;
    }
  </style>

  <script>
    function openPerdaModal(idProduto, idLocal, maxQuantidade) {
      document.getElementById('perdaIdProduto').value = idProduto;
      document.getElementById('perdaIdLocal').value = idLocal;
      document.getElementById('perdaQuantidade').max = maxQuantidade;
      document.getElementById('maxQtdText').innerText = 'Máximo disponível: ' + maxQuantidade;
      document.getElementById('modalPerda').style.display = 'flex';
    }

    function closePerdaModal() {
      document.getElementById('modalPerda').style.display = 'none';
    }
  </script>

  <script type="module" src="${pageContext.request.contextPath}/Front-end/js/pages/dashboard.js"></script>
  
  <%-- Notificações de Sucesso/Erro --%>
  <% if(session.getAttribute("mensagemSucesso") != null) { %>
    <script>
      alert("<%= session.getAttribute("mensagemSucesso") %>");
    </script>
    <% session.removeAttribute("mensagemSucesso"); %>
  <% } %>
  
  <% if(session.getAttribute("mensagemErro") != null) { %>
    <script>
      alert("<%= session.getAttribute("mensagemErro") %>");
    </script>
    <% session.removeAttribute("mensagemErro"); %>
  <% } %>

</body>
</html>
