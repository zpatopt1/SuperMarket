<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% request.setAttribute("seccao", "Gestao de Clientes"); %>
<%@ page import="java.util.List" %>
<%@ page import="model.Cliente" %>
<%
  List<Cliente> clientes = (List<Cliente>) request.getAttribute("clientes");
  String txtNome = (String) request.getAttribute("txtNome");
  String orderBy = (String) request.getAttribute("orderBy");
  String orderDir = (String) request.getAttribute("orderDir");
  if (txtNome == null) txtNome = "";
  if (orderBy == null) orderBy = "id_cliente";
  if (orderDir == null) orderDir = "ASC";
%>
<!doctype html>
<html lang="pt-PT">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <title>Clientes</title>
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
    .btn-action {
      padding: 6px 12px;
      border-radius: 8px;
      font-size: 0.85rem;
      font-weight: 600;
      border: none;
      cursor: pointer;
      transition: all 0.2s;
    }
    .btn-edit {
      background-color: #f1f5f9;
      color: #475569;
    }
    .btn-edit:hover {
      background-color: #e2e8f0;
      color: #1e293b;
    }
    .btn-delete {
      background-color: #fee2e2;
      color: #ef4444;
    }
    .btn-delete:hover {
      background-color: #fca5a5;
      color: #b91c1c;
    }
    .badge-nif {
      background-color: #f1f5f9;
      color: #475569;
      padding: 4px 8px;
      border-radius: 6px;
      font-family: monospace;
      font-weight: 600;
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
            <h2 class="page-title">Clientes</h2>
            <p class="page-subtitle">Gestão e consulta de clientes</p>
          </div>
        </div>

        <!-- KPIs -->
        <%
          Object tc = request.getAttribute("totalClientes");
          Object mc = request.getAttribute("melhorCliente");
          Object mg = request.getAttribute("mediaGastos");
        %>
        <div class="kpis kpis-stock" style="display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 24px; margin-bottom: 32px;">
          <div class="kpi" style="background: linear-gradient(135deg, #ffffff 0%, #f8fafc 100%); border-left: 5px solid #3b82f6;">
            <div style="display: flex; justify-content: space-between; align-items: center;">
              <div>
                <div class="kpi-label" style="text-transform: uppercase; letter-spacing: 0.05em; font-size: 0.75rem; color: #64748b;">Total Clientes</div>
                <div class="kpi-value" style="font-size: 1.75rem; color: #1e293b;"><%= tc != null ? tc : "0" %></div>
              </div>
              <div style="background: #eff6ff; padding: 10px; border-radius: 12px; color: #3b82f6; font-size: 1.5rem;">👥</div>
            </div>
          </div>

          <div class="kpi" style="background: linear-gradient(135deg, #ffffff 0%, #f8fafc 100%); border-left: 5px solid #8b5cf6;">
            <div style="display: flex; justify-content: space-between; align-items: center;">
              <div>
                <div class="kpi-label" style="text-transform: uppercase; letter-spacing: 0.05em; font-size: 0.75rem; color: #64748b;">Melhor Cliente</div>
                <div class="kpi-value" style="font-size: 1.25rem; color: #1e293b; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; max-width: 150px;"><%= mc != null ? mc : "N/A" %></div>
              </div>
              <div style="background: #f5f3ff; padding: 10px; border-radius: 12px; color: #8b5cf6; font-size: 1.5rem;">🏆</div>
            </div>
          </div>

          <div class="kpi" style="background: linear-gradient(135deg, #ffffff 0%, #f8fafc 100%); border-left: 5px solid #f59e0b;">
            <div style="display: flex; justify-content: space-between; align-items: center;">
              <div>
                <div class="kpi-label" style="text-transform: uppercase; letter-spacing: 0.05em; font-size: 0.75rem; color: #64748b;">Média de Gastos</div>
                <div class="kpi-value" style="font-size: 1.75rem; color: #1e293b;"><%= mg != null ? String.format("%.2f", (Double)mg) : "0.00" %>€</div>
              </div>
              <div style="background: #fffbeb; padding: 10px; border-radius: 12px; color: #f59e0b; font-size: 1.5rem;">💳</div>
            </div>
          </div>
        </div>

        <section class="card">
          <form action="${pageContext.request.contextPath}/ConsultarClientesServlet" method="get" class="toolbar">
            <div class="search">
              <span class="search-ico" aria-hidden="true">⌕</span>
              <input type="text" name="txtNome" placeholder="Pesquisar por nome..." value="<%= txtNome %>" />
            </div>
            <button type="submit" class="btn-primary">Filtrar</button>
            <button class="btn-primary" type="button" onclick="abrirModalAddCliente()">Adicionar Cliente</button>
          </form>

          <div class="table-wrap">
            <table class="table">
              <thead>
                <tr>
                  <th class="<%= "id_cliente".equals(orderBy) ? "active" : "" %>">
                    <a href="?txtNome=<%= txtNome %>&orderBy=id_cliente&orderDir=<%= ("id_cliente".equals(orderBy) && "ASC".equals(orderDir)) ? "DESC" : "ASC" %>">
                      Código <%= "id_cliente".equals(orderBy) ? ("ASC".equals(orderDir) ? "▲" : "▼") : "" %>
                    </a>
                  </th>
                  <th class="<%= "nome".equals(orderBy) ? "active" : "" %>">
                    <a href="?txtNome=<%= txtNome %>&orderBy=nome&orderDir=<%= ("nome".equals(orderBy) && "ASC".equals(orderDir)) ? "DESC" : "ASC" %>">
                      Nome <%= "nome".equals(orderBy) ? ("ASC".equals(orderDir) ? "▲" : "▼") : "" %>
                    </a>
                  </th>
                  <th class="<%= "contacto".equals(orderBy) ? "active" : "" %>">
                    <a href="?txtNome=<%= txtNome %>&orderBy=contacto&orderDir=<%= ("contacto".equals(orderBy) && "ASC".equals(orderDir)) ? "DESC" : "ASC" %>">
                      Contacto <%= "contacto".equals(orderBy) ? ("ASC".equals(orderDir) ? "▲" : "▼") : "" %>
                    </a>
                  </th>
                  <th class="<%= "nif".equals(orderBy) ? "active" : "" %>">
                    <a href="?txtNome=<%= txtNome %>&orderBy=nif&orderDir=<%= ("nif".equals(orderBy) && "ASC".equals(orderDir)) ? "DESC" : "ASC" %>">
                      NIF <%= "nif".equals(orderBy) ? ("ASC".equals(orderDir) ? "▲" : "▼") : "" %>
                    </a>
                  </th>
                  <th>Editar</th>
                  <th>Apagar</th>
                </tr>
              </thead>
              <tbody>
                <%
                  if (clientes != null && !clientes.isEmpty()) {
                    for (Cliente c : clientes) {
                      String nomeJs = c.getNome() != null ? c.getNome().replace("\\", "\\\\").replace("'", "\\'") : "";
                      String contactoJs = c.getContacto() != null ? c.getContacto().replace("\\", "\\\\").replace("'", "\\'") : "";
                      String nifJs = c.getNif() != null ? c.getNif().replace("\\", "\\\\").replace("'", "\\'") : "";
                %>
                <tr>
                  <td><%= c.getIdCliente() %></td>
                  <td><strong><%= c.getNome() != null ? c.getNome() : "" %></strong></td>
                  <td><%= c.getContacto() != null ? c.getContacto() : "" %></td>
                  <td><span class="badge-nif"><%= c.getNif() != null ? c.getNif() : "---" %></span></td>
                  <td>
                    <button type="button" class="btn-action btn-edit"
                      onclick="abrirModal('<%= c.getIdCliente() %>', '<%= nomeJs %>', '<%= contactoJs %>', '<%= nifJs %>')">Editar</button>
                  </td>
                  <td>
                    <form action="${pageContext.request.contextPath}/ConsultarClientesServlet" method="POST" style="margin:0;">
                      <input type="hidden" name="action" value="delete" />
                      <input type="hidden" name="page" value="${currentPage}">
                      <input type="hidden" name="txtNome" value="${txtNome}">
                      <input type="hidden" name="orderBy" value="${orderBy}">
                      <input type="hidden" name="orderDir" value="${orderDir}">
                      <input type="hidden" name="delete_id_cliente" value="<%= c.getIdCliente() %>" />
                      <button type="submit" class="btn-action btn-delete">Apagar</button>
                    </form>
                  </td>
                </tr>
                <%
                    }
                  } else {
                %>
                <tr><td colspan="6" style="text-align:center;">Nenhum cliente encontrado.</td></tr>
                <% } %>
              </tbody>
            </table>
          </div>

          <div class="pagination">
            <%
              Integer currentPage = (Integer) request.getAttribute("currentPage");
              Integer totalPages = (Integer) request.getAttribute("totalPages");
              if (totalPages != null && totalPages > 1) {
            %>
              <% if (currentPage > 1) { %>
                <a class="page-btn" href="?txtNome=<%= txtNome %>&orderBy=<%= orderBy %>&orderDir=<%= orderDir %>&page=<%= currentPage - 1 %>">« Anterior</a>
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
                <a class="page-btn" href="?txtNome=<%= txtNome %>&orderBy=<%= orderBy %>&orderDir=<%= orderDir %>&page=<%= i %>"><%= i %></a>
              <% }
                }
              %>

              <% if (currentPage < totalPages) { %>
                <a class="page-btn" href="?txtNome=<%= txtNome %>&orderBy=<%= orderBy %>&orderDir=<%= orderDir %>&page=<%= currentPage + 1 %>">Proximo »</a>
              <% } else { %>
                <span class="page-btn disabled">Proximo »</span>
              <% } %>
            <% } %>
          </div>
        </section>

        <div id="modal" class="modal">
          <div class="registo-card">
            <span class="close" onclick="fecharModal()">x</span>
            <h3>Editar Cliente</h3>
            <form action="${pageContext.request.contextPath}/ConsultarClientesServlet" method="POST" class="form-grid">
              <input type="hidden" name="action" value="update">
              <input type="hidden" id="modal_id_cliente" name="id_cliente">

              <div class="input-group full-width">
                <label>Nome</label>
                <input type="text" id="modal_nome" name="nome" required>
              </div>

              <div class="input-group full-width">
                <label>Contacto</label>
                <input type="text" id="modal_contacto" name="contacto">
              </div>

              <div class="input-group full-width">
                <label>NIF</label>
                <input type="text" id="modal_nif" name="nif">
              </div>

              <input type="hidden" name="page" value="${currentPage}">
              <input type="hidden" name="txtNome" value="${txtNome}">
              <input type="hidden" name="orderBy" value="${orderBy}">
              <input type="hidden" name="orderDir" value="${orderDir}">

              <div class="button-group full-width">
                <button type="submit" class="btn-guardar">Atualizar Cliente</button>
              </div>
            </form>
          </div>
        </div>

        <div id="modalAddCliente" class="modal">
          <div class="registo-card">
            <span class="close" onclick="fecharModalAddCliente()">x</span>
            <h3>Adicionar Cliente</h3>
            <form action="${pageContext.request.contextPath}/ConsultarClientesServlet" method="POST" class="form-grid">
              <input type="hidden" name="action" value="insert">

              <div class="input-group full-width">
                <label>Nome</label>
                <input type="text" id="modal_add_nome" name="nome" required>
              </div>

              <div class="input-group full-width">
                <label>Contacto</label>
                <input type="text" id="modal_add_contacto" name="contacto">
              </div>

              <div class="input-group full-width">
                <label>NIF</label>
                <input type="text" id="modal_add_nif" name="nif">
              </div>

              <input type="hidden" name="page" value="${currentPage}">
              <input type="hidden" name="txtNome" value="${txtNome}">
              <input type="hidden" name="orderBy" value="${orderBy}">
              <input type="hidden" name="orderDir" value="${orderDir}">

              <div class="button-group full-width">
                <button type="submit" class="btn-guardar">Criar Cliente</button>
              </div>
            </form>
          </div>
        </div>

      </section>
    </main>
  </div>

  <script>
    function abrirModal(id, nome, contacto, nif) {
      document.getElementById("modal").style.display = "flex";
      document.getElementById("modal_id_cliente").value = id;
      document.getElementById("modal_nome").value = nome;
      document.getElementById("modal_contacto").value = contacto;
      document.getElementById("modal_nif").value = nif;
    }

    function fecharModal() {
      document.getElementById("modal").style.display = "none";
    }

    function abrirModalAddCliente() {
      document.getElementById("modalAddCliente").style.display = "flex";
    }

    function fecharModalAddCliente() {
      document.getElementById("modalAddCliente").style.display = "none";
    }
  </script>

  <script type="module" src="/SuperMARKT/Front-end/js/pages/dashboard.js"></script>
</body>
</html>
