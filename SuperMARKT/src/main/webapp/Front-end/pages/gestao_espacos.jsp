<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% request.setAttribute("seccao", "Gestão de Espaços"); %>
<%@ page import="java.util.List" %>
<%@ page import="model.Local" %>
<%@ page import="model.Zona" %>
<!DOCTYPE html>
<html lang="pt-PT">
<head>
    <meta charset="UTF-8">
    <title>Gestão de Espaços</title>
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">
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
      
      /* Grid Layout para as tabelas em cima umas das outras */
      .spaces-grid {
          display: grid;
          grid-template-columns: 1fr;
          gap: 32px;
          margin-top: 24px;
      }
      
      @media (max-width: 1024px) {
          .spaces-grid {
              grid-template-columns: 1fr;
          }
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
            <h2 class="page-title">Gestão de Espaços</h2>
            <p class="page-subtitle">Organização física de Locais e Zonas</p>
          </div>
        </div>

        <%
          List<Local> locais = (List<Local>) request.getAttribute("locais");
          List<Zona> zonas = (List<Zona>) request.getAttribute("zonas");
        %>

        <!-- KPIs -->
        <%
          Object tl = request.getAttribute("totalLocais");
          Object tz = request.getAttribute("totalZonas");
          Object zmo = request.getAttribute("zonaMaisOcupada");
        %>
        <div class="kpis kpis-stock" style="display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 24px; margin-bottom: 32px;">
          <div class="kpi" style="background: linear-gradient(135deg, #ffffff 0%, #f8fafc 100%); border-left: 5px solid #3b82f6;">
            <div style="display: flex; justify-content: space-between; align-items: center;">
              <div>
                <div class="kpi-label" style="text-transform: uppercase; letter-spacing: 0.05em; font-size: 0.75rem; color: #64748b;">Total Locais</div>
                <div class="kpi-value" style="font-size: 1.75rem; color: #1e293b;"><%= tl != null ? tl : "0" %></div>
              </div>
              <div style="background: #eff6ff; padding: 10px; border-radius: 12px; color: #3b82f6; font-size: 1.5rem;">📍</div>
            </div>
          </div>

          <div class="kpi" style="background: linear-gradient(135deg, #ffffff 0%, #f8fafc 100%); border-left: 5px solid #10b981;">
            <div style="display: flex; justify-content: space-between; align-items: center;">
              <div>
                <div class="kpi-label" style="text-transform: uppercase; letter-spacing: 0.05em; font-size: 0.75rem; color: #64748b;">Total Zonas</div>
                <div class="kpi-value" style="font-size: 1.75rem; color: #1e293b;"><%= tz != null ? tz : "0" %></div>
              </div>
              <div style="background: #ecfdf5; padding: 10px; border-radius: 12px; color: #10b981; font-size: 1.5rem;">🏗️</div>
            </div>
          </div>

          <div class="kpi" style="background: linear-gradient(135deg, #ffffff 0%, #f8fafc 100%); border-left: 5px solid #8b5cf6;">
            <div style="display: flex; justify-content: space-between; align-items: center;">
              <div>
                <div class="kpi-label" style="text-transform: uppercase; letter-spacing: 0.05em; font-size: 0.75rem; color: #64748b;">Zona Mais Ocupada</div>
                <div class="kpi-value" style="font-size: 1.25rem; color: #1e293b; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; max-width: 150px;"><%= zmo != null ? zmo : "N/A" %></div>
              </div>
              <div style="background: #f5f3ff; padding: 10px; border-radius: 12px; color: #8b5cf6; font-size: 1.5rem;">📦</div>
            </div>
          </div>
        </div>

        <div class="spaces-grid">
            <!-- COLUNA 1: LOCAIS -->
            <section class="card">
                <div class="toolbar" style="justify-content: space-between;">
                    <h3>Locais</h3>
                    <button type="button" class="btn-primary" onclick="abrirModalAddLocal()">+ Adicionar Local</button>
                </div>
                <div class="table-wrap">
                    <table id="locaisTable" class="table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Nome</th>
                                <th>Tipo</th>
                                <th>Ações</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                            if (locais != null) {
                                for (Local local : locais) {
                            %>
                            <tr>
                                <td><%= local.getIdLocal() %></td>
                                <td><strong><%= local.getNome() %></strong></td>
                                <td><%= local.getTipoLocal() %></td>
                                <td style="display: flex; gap: 8px;">
                                    <button type="button" class="btn-action btn-edit" onclick="abrirModalLocal(<%= local.getIdLocal() %>, '<%= local.getNome() %>', '<%= local.getTipoLocal() %>')">Editar</button>
                                    <form method="post" action="${pageContext.request.contextPath}/ConsultarLocalServlet" style="margin:0;">
                                        <input type="hidden" name="delete_id_local" value="<%= local.getIdLocal() %>" />
                                        <input type="hidden" name="action" value="delete" />
                                        <button type="submit" class="btn-action btn-delete">Apagar</button>
                                    </form>
                                </td>
                            </tr>
                            <%    }
                            }
                            %>
                        </tbody>
                    </table>
                </div>
            </section>

            <!-- COLUNA 2: ZONAS -->
            <section class="card">
                <div class="toolbar" style="justify-content: space-between;">
                    <h3>Zonas</h3>
                    <button type="button" class="btn-primary" onclick="abrirModalAddZona()">+ Adicionar Zona</button>
                </div>
                <div class="table-wrap">
                    <table id="zonasTable" class="table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Zona</th>
                                <th>Local Associado</th>
                                <th>Ações</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                            if (zonas != null) {
                                for (Zona zona : zonas) {
                            %>
                            <tr>
                                <td><%= zona.getIdZona() %></td>
                                <td><strong><%= zona.getNome() %></strong></td>
                                <td><%= zona.getLocal().getNome() %> (<%= zona.getLocal().getTipoLocal() %>)</td>
                                <td style="display: flex; gap: 8px;">
                                    <button type="button" class="btn-action btn-edit" onclick="abrirModalZona(<%= zona.getIdZona() %>, '<%= zona.getNome() %>', <%= zona.getLocal().getIdLocal() %>)">Editar</button>
                                    <form method="post" action="${pageContext.request.contextPath}/ConsultarZonaServlet" style="margin:0;">
                                        <input type="hidden" name="delete_id_zona" value="<%= zona.getIdZona() %>" />
                                        <input type="hidden" name="action" value="delete" />
                                        <button type="submit" class="btn-action btn-delete">Apagar</button>
                                    </form>
                                </td>
                            </tr>
                            <% } } %>
                        </tbody>
                    </table>
                </div>
            </section>
        </div>

        <!-- ================= MODAIS LOCAIS ================= -->
        <div id="modalLocal" class="modal">
          <div class="registo-card">
            <span class="close" onclick="fecharModalLocal()">x</span>
            <h3>Editar Local</h3>
            <form action="${pageContext.request.contextPath}/ConsultarLocalServlet" method="POST">
              <input type="hidden" name="action" value="update" />
              <input type="hidden" id="modal_id_local" name="id_local" />

              <div class="input-group full-width">
                <label>Nome</label>
                <input type="text" id="modal_nome_local" name="nome" required />
              </div>

              <div class="input-group full-width">
                <label>Tipo</label>
                <input type="text" id="modal_tipo_local" name="tipo_local" />
              </div>

              <div class="button-group full-width">
                <button type="submit" class="btn-guardar">Atualizar Local</button>
              </div>
            </form>
          </div>
        </div>

        <div id="modalAddLocal" class="modal">
          <div class="registo-card">
            <span class="close" onclick="fecharModalAddLocal()">x</span>
            <h3>Adicionar Local</h3>
            <form action="${pageContext.request.contextPath}/ConsultarLocalServlet" method="POST">
              <input type="hidden" name="action" value="insert" />

              <div class="input-group full-width">
                <label>Nome</label>
                <input type="text" name="nome_local" required />
              </div>

              <div class="input-group full-width">
                <label>Tipo (ex: Loja, Armazém)</label>
                <input type="text" name="tipo_local" />
              </div>

              <div class="button-group full-width">
                <button type="submit" class="btn-guardar">Criar Local</button>
              </div>
            </form>
          </div>
        </div>

        <!-- ================= MODAIS ZONAS ================= -->
        <div id="modalZona" class="modal">
          <div class="registo-card">
            <span class="close" onclick="fecharModalZona()">x</span>
            <h3>Editar Zona</h3>
			<form action="${pageContext.request.contextPath}/ConsultarZonaServlet" method="POST">
			  <input type="hidden" name="action" value="update" />
			  <input type="hidden" id="modal_id_zona" name="id_zona" />
			
			  <div class="input-group full-width">
			    <label>Nome da Zona</label>
			    <input type="text" id="modal_nome_zona" name="nome" required />
			  </div>
			
			  <div class="input-group full-width">
			    <label>Local Associado</label>
			    <select id="modal_id_local_zona" name="id_local" required style="width: 100%; padding: 8px; border-radius: 4px; border: 1px solid #ddd;">
                    <% if (locais != null) { for (Local l : locais) { %>
                        <option value="<%= l.getIdLocal() %>"><%= l.getNome() %> (<%= l.getTipoLocal() %>)</option>
                    <% } } %>
                </select>
			  </div>
			
              <div class="button-group full-width">
			    <button type="submit" class="btn-guardar">Atualizar Zona</button>
              </div>
			</form>
          </div>
        </div>

        <div id="modalAddZona" class="modal">
		  <div class="registo-card">
		    <span class="close" onclick="fecharModalAddZona()">x</span>
		    <h3>Adicionar Zona</h3>
		
		    <form action="${pageContext.request.contextPath}/ConsultarZonaServlet" method="POST">
		      <input type="hidden" name="action" value="insert" />
		
		      <div class="input-group full-width">
		        <label>Nome da Zona</label>
		        <input type="text" name="modal_add_nome" required />
		      </div>
		
		      <div class="input-group full-width">
		        <label>Local Associado</label>
		        <select name="modal_add_id_local" required style="width: 100%; padding: 8px; border-radius: 4px; border: 1px solid #ddd;">
                    <option value="">-- Selecione o Local --</option>
                    <% if (locais != null) { for (Local l : locais) { %>
                        <option value="<%= l.getIdLocal() %>"><%= l.getNome() %> (<%= l.getTipoLocal() %>)</option>
                    <% } } %>
                </select>
		      </div>
		
              <div class="button-group full-width">
		        <button type="submit" class="btn-guardar">Criar Zona</button>
              </div>
		    </form>
		  </div>
		</div>

        <!-- ================= SCRIPTS ================= -->
        <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
        <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
        <script>
          $(document).ready(function() {
            var options = {
              pageLength: 10,
              language: {
                search: 'Pesquisar:',
                lengthMenu: 'Mostrar _MENU_ registos',
                info: 'A mostrar _START_ a _END_ de _TOTAL_',
                paginate: { previous: '«', next: '»' },
                zeroRecords: 'Nenhum registo encontrado'
              },
              dom: '<"table-wrap"t><"pagination-wrapper d-flex justify-center"p>'
            };
            $('#locaisTable').DataTable(options);
            $('#zonasTable').DataTable(options);
        });

        // Controlo Modais Locais
        function abrirModalLocal(id, nome, tipo) {
            document.getElementById('modalLocal').style.display = 'flex';
            document.getElementById('modal_id_local').value = id;
            document.getElementById('modal_nome_local').value = nome;
            document.getElementById('modal_tipo_local').value = tipo;
        }
        function fecharModalLocal() { document.getElementById('modalLocal').style.display = 'none'; }
        function abrirModalAddLocal() { document.getElementById('modalAddLocal').style.display = 'flex'; }
        function fecharModalAddLocal() { document.getElementById('modalAddLocal').style.display = 'none'; }

        // Controlo Modais Zonas
        function abrirModalZona(id, nome, idLocal) {
        	document.getElementById('modalZona').style.display = 'flex';
        	document.getElementById('modal_id_zona').value = id;
        	document.getElementById('modal_nome_zona').value = nome;
        	document.getElementById('modal_id_local_zona').value = idLocal;
        }
        function fecharModalZona() { document.getElementById('modalZona').style.display = 'none'; }
        function abrirModalAddZona() { document.getElementById('modalAddZona').style.display = 'flex'; }
        function fecharModalAddZona() { document.getElementById('modalAddZona').style.display = 'none'; }
        </script>
      </section>
    </main>
  </div>
  <script type="module" src="/SuperMARKT/Front-end/js/pages/dashboard.js"></script>
</body>
</html>
