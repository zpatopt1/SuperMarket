	<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% request.setAttribute("seccao", "Gestão de Stock Local"); %>
<%@ page import="java.util.List" %>
<%@ page import="model.StockLocal" %>
<%@ page import="model.Zona" %>
<%
  List<StockLocal> stocks = (List<StockLocal>) request.getAttribute("stocks");
  List<Zona> todasZonas = (List<Zona>) request.getAttribute("todasZonas");
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
                  <th>Gerir Zonas</th>
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
                <%
                    List<Zona> zonasLinha = s.getZonas();
                
                    if (zonasLinha != null && !zonasLinha.isEmpty()) {
                        for (Zona z : zonasLinha) {
                %>
                    <span class="badge-qty badge-warning" style="margin-right:6px; margin-bottom:4px; display:inline-block;">
                        <%= z.getNome() %>
                    </span>
                <%
                        }
                    } else {
                %>
                    <span style="color:#64748b;">Sem zonas</span>
                <%
                    }
                %>
                </td>
                  <td>
                    <button type="button" class="btn-danger" style="font-size: 0.75rem; padding: 6px 10px;" onclick="openPerdaModal(<%= s.getProduto() != null ? s.getProduto().getIdProduto() : 0 %>, <%= s.getLocal() != null ? s.getLocal().getIdLocal() : 0 %>, <%= q %>)">
                      Registar Quebra
                    </button>
                    <a class="btn-primary" style="font-size: 0.75rem; padding: 6px 10px; text-decoration: none;"
                       href="${pageContext.request.contextPath}/TransferirStockServlet?idProduto=<%= s.getProduto() != null ? s.getProduto().getIdProduto() : 0 %>&idOrigem=<%= s.getLocal() != null ? s.getLocal().getIdLocal() : 0 %>">
                      Transferir Stock
                    </a>
                    <button type="button" class="btn-secondary" style="font-size: 0.75rem; padding: 6px 10px;"
                      onclick="openZonasModal(<%= s.getProduto() != null ? s.getProduto().getIdProduto() : 0 %>, <%= s.getLocal() != null ? s.getLocal().getIdLocal() : 0 %>)">
                      Gerir Zonas
                    </button>
                  </td>
                </tr>
                <%   }
                   } else { %>
                <tr>
                  <td colspan="6" style="text-align:center;">Nenhum registo de stock local encontrado.</td>
                </tr>
                <% } %>
              </tbody>
            </table>
          </div>

          <div class="pagination">
            <%
              Integer currentPage = (Integer) request.getAttribute("currentPage");
              Integer totalPages = (Integer) request.getAttribute("totalPages");
              if (currentPage == null) currentPage = 1;
              if (totalPages == null || totalPages < 1) totalPages = 1;
            %>
              <% if (currentPage > 1) { %>
                <a class="page-btn" href="?idProduto=<%= idProduto %>&idLocal=<%= idLocal %>&orderBy=<%= orderBy %>&orderDir=<%= orderDir %>&page=<%= currentPage - 1 %>">« Anterior</a>
              <% } else { %>
                <span class="page-btn disabled">« Anterior</span>
              <% } %>

              <%
                int startPage = Math.max(1, currentPage - 2);
                int endPage = Math.min(totalPages, currentPage + 2);
                for (int i = startPage; i <= endPage; i++) {
                  if (i == currentPage) {
              %>
                <span class="page-btn current"><%= i %></span>
              <% } else { %>
                <a class="page-btn" href="?idProduto=<%= idProduto %>&idLocal=<%= idLocal %>&orderBy=<%= orderBy %>&orderDir=<%= orderDir %>&page=<%= i %>"><%= i %></a>
              <% }
                }
              %>

              <% if (currentPage < totalPages) { %>
                <a class="page-btn" href="?idProduto=<%= idProduto %>&idLocal=<%= idLocal %>&orderBy=<%= orderBy %>&orderDir=<%= orderDir %>&page=<%= currentPage + 1 %>">Próximo »</a>
              <% } else { %>
                <span class="page-btn disabled">Próximo »</span>
              <% } %>
            <% %>
          </div>
        </section>
      </section>
    </main>
  </div>

  <div id="modalZonas" class="modal-overlay" style="display: none;">
    <div class="modal-content">
      <h3 style="margin-top: 0;">Gerir Zonas do Produto</h3>
      <p style="font-size: 0.9rem; color: #64748b; margin-bottom: 15px;">Associe ou remova zonas para este produto no local selecionado.</p>

      <div style="margin-bottom: 10px;">
        <strong>Zonas atuais:</strong>
        <ul id="listaZonasAtuais" style="margin-top: 8px; padding-left: 18px;"></ul>
      </div>

      <form action="${pageContext.request.contextPath}/ConsultarStockLocalServlet" method="post" style="margin-bottom: 12px;">
        <input type="hidden" name="action" value="addZona" />
        <input type="hidden" name="idProduto" id="zonaIdProdutoAdd" />
        <input type="hidden" name="idLocal" id="zonaIdLocalAdd" />
        <input type="hidden" name="filterIdProduto" value="<%= idProduto %>" />
        <input type="hidden" name="filterIdLocal" value="<%= idLocal %>" />
        <input type="hidden" name="filterOrderBy" value="<%= orderBy %>" />
        <input type="hidden" name="filterOrderDir" value="<%= orderDir %>" />
        <input type="hidden" name="filterPage" value="<%= request.getAttribute("currentPage") %>" />

        <label style="display:block; margin-bottom:6px;">Adicionar zona</label>
        <select id="zonaSelectAdd" name="idZona" required style="width:100%; padding:10px; border:1px solid #cbd5e1; border-radius:8px;">
          <option value="">Selecione uma zona...</option>
        </select>
        <div style="margin-top:10px;">
          <button type="submit" class="btn-primary">Adicionar</button>
        </div>
      </form>

      <form action="${pageContext.request.contextPath}/ConsultarStockLocalServlet" method="post">
        <input type="hidden" name="action" value="removeZona" />
        <input type="hidden" name="idProduto" id="zonaIdProdutoRemove" />
        <input type="hidden" name="idLocal" id="zonaIdLocalRemove" />
        <input type="hidden" name="filterIdProduto" value="<%= idProduto %>" />
        <input type="hidden" name="filterIdLocal" value="<%= idLocal %>" />
        <input type="hidden" name="filterOrderBy" value="<%= orderBy %>" />
        <input type="hidden" name="filterOrderDir" value="<%= orderDir %>" />
        <input type="hidden" name="filterPage" value="<%= request.getAttribute("currentPage") %>" />

        <label style="display:block; margin-bottom:6px;">Remover zona</label>
        <select id="zonaSelectRemove" name="idZona" required style="width:100%; padding:10px; border:1px solid #cbd5e1; border-radius:8px;">
          <option value="">Selecione uma zona...</option>
        </select>
        <div style="margin-top:10px;">
          <button type="submit" class="btn-danger">Remover</button>
          <button type="button" class="btn-secondary" onclick="closeZonasModal()">Fechar</button>
        </div>
      </form>
    </div>
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
  <script>
    const todasZonas = {
      <% if (todasZonas != null) { 
           for (Zona z : todasZonas) { 
             int zid = z.getIdZona();
             String zn = z.getNome() != null ? z.getNome().replace("\\", "\\\\").replace("'", "\\'") : "";
             int lid = (z.getLocal() != null) ? z.getLocal().getIdLocal() : 0;
      %>
      "<%= zid %>": { id: <%= zid %>, nome: "<%= zn %>", idLocal: <%= lid %> },
      <% } } %>
    };

    const zonasAtuaisMap = {
      <% if (stocks != null) {
           for (StockLocal s : stocks) {
             if (s.getProduto() != null && s.getLocal() != null) {
               String key = s.getProduto().getIdProduto() + "-" + s.getLocal().getIdLocal();
               List<Zona> zonasLinha = s.getZonas();
      %>
      "<%= key %>": [
        <% if (zonasLinha != null) {
             for (Zona z : zonasLinha) {
               String zn = z.getNome() != null ? z.getNome().replace("\\", "\\\\").replace("'", "\\'") : ""; %>
        { id: <%= z.getIdZona() %>, nome: "<%= zn %>" },
        <%   }
           } %>
      ],
      <%     }
           }
         } %>
    };

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

    function openZonasModal(idProduto, idLocal) {
      const localIdNum = Number(idLocal);
      const key = idProduto + "-" + idLocal;
      const atuais = zonasAtuaisMap[key] || [];
      const ul = document.getElementById('listaZonasAtuais');
      const selectAdd = document.getElementById('zonaSelectAdd');
      const selectRemove = document.getElementById('zonaSelectRemove');

      document.getElementById('zonaIdProdutoAdd').value = idProduto;
      document.getElementById('zonaIdLocalAdd').value = idLocal;
      document.getElementById('zonaIdProdutoRemove').value = idProduto;
      document.getElementById('zonaIdLocalRemove').value = idLocal;

      ul.innerHTML = "";
      if (atuais.length === 0) {
        ul.innerHTML = "<li>Nenhuma zona associada.</li>";
      } else {
        atuais.forEach(z => {
          const li = document.createElement('li');
          li.textContent = z.nome + " (#" + z.id + ")";
          ul.appendChild(li);
        });
      }

      selectAdd.innerHTML = '<option value="">Selecione uma zona...</option>';
      selectRemove.innerHTML = '<option value="">Selecione uma zona...</option>';

      const atuaisIds = new Set(atuais.map(z => String(z.id)));
      let addCount = 0;
      let removeCount = 0;
      Object.values(todasZonas).forEach(z => {
        if (Number(z.idLocal) === localIdNum) {
          if (!atuaisIds.has(String(z.id))) {
            const op = document.createElement('option');
            op.value = z.id;
            op.textContent = z.nome + " (#" + z.id + ")";
            selectAdd.appendChild(op);
            addCount++;
          }
          if (atuaisIds.has(String(z.id))) {
            const op2 = document.createElement('option');
            op2.value = z.id;
            op2.textContent = z.nome + " (#" + z.id + ")";
            selectRemove.appendChild(op2);
            removeCount++;
          }
        }
      });

      if (addCount === 0) {
        const op = document.createElement('option');
        op.value = "";
        op.disabled = true;
        op.textContent = "Sem zonas disponíveis neste local";
        selectAdd.appendChild(op);
      }
      if (removeCount === 0) {
        const op = document.createElement('option');
        op.value = "";
        op.disabled = true;
        op.textContent = "Sem zonas associadas para remover";
        selectRemove.appendChild(op);
      }

      document.getElementById('modalZonas').style.display = 'flex';
    }

    function closeZonasModal() {
      document.getElementById('modalZonas').style.display = 'none';
    }
    </script>
</body>
</html>
