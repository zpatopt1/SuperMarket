<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% request.setAttribute("seccao", "Sistema"); %>
<%@ page import="java.util.List" %>
<%@ page import="model.Funcionario" %>
<%@ page import="model.Funcao" %>
<!DOCTYPE html>
<html lang="pt-PT">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1" />
    <title>Gestao de Utilizadores</title>

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
    .status-badge {
      padding: 4px 10px;
      border-radius: 999px;
      font-size: 0.75rem;
      font-weight: 700;
      text-transform: uppercase;
    }
    .status-active {
      background-color: #ecfdf5;
      color: #10b981;
    }
    .status-inactive {
      background-color: #fef2f2;
      color: #ef4444;
    }
    .role-badge {
      background-color: #eff6ff;
      color: #3b82f6;
      padding: 4px 8px;
      border-radius: 6px;
      font-size: 0.8rem;
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
            <h2 class="page-title">Gestão de Utilizadores</h2>
            <p class="page-subtitle">Gestão e consulta de funcionários e acessos</p>
          </div>
        </div>

        <!-- KPIs -->
        <%
          Object tu = request.getAttribute("totalUtilizadores");
          Object ta = request.getAttribute("totalAtivos");
          Object tadm = request.getAttribute("totalAdmins");
        %>
        <div class="kpis kpis-stock" style="display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 24px; margin-bottom: 32px;">
          <div class="kpi" style="background: linear-gradient(135deg, #ffffff 0%, #f8fafc 100%); border-left: 5px solid #3b82f6;">
            <div style="display: flex; justify-content: space-between; align-items: center;">
              <div>
                <div class="kpi-label" style="text-transform: uppercase; letter-spacing: 0.05em; font-size: 0.75rem; color: #64748b;">Total Utilizadores</div>
                <div class="kpi-value" style="font-size: 1.75rem; color: #1e293b;"><%= tu != null ? tu : "0" %></div>
              </div>
              <div style="background: #eff6ff; padding: 10px; border-radius: 12px; color: #3b82f6; font-size: 1.5rem;">👤</div>
            </div>
          </div>

          <div class="kpi" style="background: linear-gradient(135deg, #ffffff 0%, #f8fafc 100%); border-left: 5px solid #10b981;">
            <div style="display: flex; justify-content: space-between; align-items: center;">
              <div>
                <div class="kpi-label" style="text-transform: uppercase; letter-spacing: 0.05em; font-size: 0.75rem; color: #64748b;">Contas Ativas</div>
                <div class="kpi-value" style="font-size: 1.75rem; color: #1e293b;"><%= ta != null ? ta : "0" %></div>
              </div>
              <div style="background: #ecfdf5; padding: 10px; border-radius: 12px; color: #10b981; font-size: 1.5rem;">✅</div>
            </div>
          </div>

          <div class="kpi" style="background: linear-gradient(135deg, #ffffff 0%, #f8fafc 100%); border-left: 5px solid #8b5cf6;">
            <div style="display: flex; justify-content: space-between; align-items: center;">
              <div>
                <div class="kpi-label" style="text-transform: uppercase; letter-spacing: 0.05em; font-size: 0.75rem; color: #64748b;">Administradores</div>
                <div class="kpi-value" style="font-size: 1.75rem; color: #1e293b;"><%= tadm != null ? tadm : "0" %></div>
              </div>
              <div style="background: #f5f3ff; padding: 10px; border-radius: 12px; color: #8b5cf6; font-size: 1.5rem;">🛡️</div>
            </div>
          </div>
        </div>

        <section class="card">
          <div class="toolbar">
            <div class="search">
              <span class="search-ico" aria-hidden="true">⌕</span>
              <input type="text" placeholder="Pesquisar utilizadores..." id="searchInput">
            </div>
            <button class="btn-primary" type="button" id="btnFiltrar">Filtrar</button>
            <button type="button" class="btn-primary" onclick="abrirModalAddFuncionario()">Adicionar Funcionário</button>
          </div>

          <div class="table-wrap">
            <table id="utilizadoresTable" class="table">
              <thead>
                <tr>
                  <th>NIF</th>
                  <th>Nome</th>
                  <th>Email</th>
                  <th>Função</th>
                  <th>Estado</th>
                  <th>Editar</th>
                  <th>Apagar</th>
                </tr>
              </thead>
              <tbody>
                <%
                  List<Funcionario> funcionarios = (List<Funcionario>) request.getAttribute("funcionarios");
                  if (funcionarios != null) {
                    for (Funcionario f : funcionarios) {
                      String nif = f.getNif() != null ? f.getNif() : "";
                      String nome = f.getNome() != null ? f.getNome() : "";
                      String contacto = f.getContacto() != null ? f.getContacto() : "";
                      String email = f.getEmail() != null ? f.getEmail() : "";
                      int idFuncao = (f.getIdFuncao() != null) ? f.getIdFuncao().getIdFuncao() : 0;
                      String nomeJs = nome.replace("\\", "\\\\").replace("'", "\\'");
                      String contactoJs = contacto.replace("\\", "\\\\").replace("'", "\\'");
                      String emailJs = email.replace("\\", "\\\\").replace("'", "\\'");
                %>
                  <tr>
                    <td><%= nif %></td>
                    <td><strong><%= nome %></strong></td>
                    <td><%= email %></td>
                    <td><span class="role-badge"><%= (f.getIdFuncao() != null && f.getIdFuncao().getDescricao() != null) ? f.getIdFuncao().getDescricao() : "N/A" %></span></td>
                    <td>
                        <span class="status-badge <%= f.isAtivo() ? "status-active" : "status-inactive" %>">
                            <%= f.isAtivo() ? "Ativo" : "Inativo" %>
                        </span>
                    </td>
                    <td>
                      <button type="button" class="btn-action btn-edit"
                        onclick="abrirModal('<%= nif %>', '<%= nomeJs %>', '<%= contactoJs %>', '<%= emailJs %>', '<%= idFuncao %>', <%= f.isAtivo() ? "true" : "false" %>)">Editar</button>
                    </td>
                    <td>
                      <form method="post" action="${pageContext.request.contextPath}/ConsultarUtilizadoresServlet" style="margin:0;">
                        <input type="hidden" name="delete_nif" value="<%= nif %>">
                        <input type="hidden" name="action" value="delete">
                        <button type="submit" class="btn-action btn-delete">Apagar</button>
                      </form>
                    </td>
                  </tr>
                <%
                    }
                  }
                %>
              </tbody>
            </table>
          </div>
        </section>
      </section>
    </main>
  </div>

  <div id="modal" class="modal">
    <div class="registo-card">
      <span class="close" onclick="fecharModal()">x</span>
      <h3>Editar Funcionario</h3>
      <form action="${pageContext.request.contextPath}/ConsultarUtilizadoresServlet" method="POST">
        <input type="hidden" name="action" value="update">

        <div class="input-group full-width">
          <label>NIF</label>
          <input type="text" id="edit_nif" name="edit_nif" readonly>
        </div>

        <div class="input-group full-width">
          <label>Nome</label>
          <input type="text" id="edit_nome" name="edit_nome" required>
        </div>

        <div class="input-group full-width">
          <label>Contacto</label>
          <input type="text" id="edit_contacto" name="edit_contacto">
        </div>

        <div class="input-group full-width">
          <label>Email</label>
          <input type="email" id="edit_email" name="edit_email" required>
        </div>

        <div class="input-group full-width">
          <label>Nova Password (opcional)</label>
          <input type="text" id="edit_password" name="edit_password" placeholder="Deixe vazio para manter">
        </div>

        <div class="input-group full-width">
          <label>Funcao</label>
          <select id="edit_id_funcao" name="edit_id_funcao"  style="width: 100%; padding: 8px; border-radius: 4px; border: 1px solid #ddd;" required>
            <option value="">Selecione uma funcao</option>
            <%
              List<Funcao> funcoes = (List<Funcao>) request.getAttribute("funcoes");
              if (funcoes != null) {
                for (Funcao funcao : funcoes) {
            %>
              <option value="<%= funcao.getIdFuncao() %>"><%= funcao.getDescricao() %></option>
            <%
                }
              }
            %>
          </select>
        </div>

        <div class="input-group full-width">
          <label>
            <input type="checkbox" id="edit_ativo" name="edit_ativo" value="true">
            Ativo
          </label>
        </div>

        <div class="button-group full-width">
          <button type="submit" class="btn-guardar">Atualizar Funcionario</button>
        </div>
      </form>
    </div>
  </div>

  <div id="modalAddFuncionario" class="modal">
    <div class="registo-card">
      <span class="close" onclick="fecharModalAddFuncionario()">x</span>
      <h3>Adicionar Funcionario</h3>
      <form action="${pageContext.request.contextPath}/ConsultarUtilizadoresServlet" method="POST">
        <input type="hidden" name="action" value="insert">

        <div class="input-group full-width">
          <label>NIF</label>
          <input type="text" name="nif" required>
        </div>

        <div class="input-group full-width">
          <label>Nome</label>
          <input type="text" name="nome" required>
        </div>

        <div class="input-group full-width">
          <label>Contacto</label>
          <input type="text" name="contacto">
        </div>

        <div class="input-group full-width">
          <label>Email</label>
          <input type="email" name="email" required>
        </div>

        <div class="input-group full-width">
          <label>Password</label>
          <input type="text" name="password" required>
        </div>

        <div class="input-group full-width">
          <label>Funcao</label>
          <select name="id_funcao" style="width: 100%; padding: 8px; border-radius: 4px; border: 1px solid #ddd;" required>
            <option value="">Selecione uma funcao</option>
            <%
              if (funcoes != null) {
                for (Funcao funcao : funcoes) {
            %>
              <option value="<%= funcao.getIdFuncao() %>"><%= funcao.getDescricao() %></option>
            <%
                }
              }
            %>
          </select>
        </div>

        <div class="input-group full-width">
          <label>
            <input type="checkbox" name="ativo" value="true" checked>
            Ativo
          </label>
        </div>

        <div class="button-group full-width">
          <button type="submit" class="btn-guardar">Criar Funcionario</button>
        </div>
      </form>
    </div>
  </div>

  <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
  <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
  <script>
    $(document).ready(function() {
      var table = $('#utilizadoresTable').DataTable({
        "pageLength": 5,
        "language": {
          "search": "Pesquisar:",
          "lengthMenu": "Mostrar _MENU_ utilizadores por pagina",
          "info": "Mostrando _START_ a _END_ de _TOTAL_ utilizadores",
          "paginate": {
            "previous": "« Anterior",
            "next": "Proximo »"
          },
          "zeroRecords": "Nenhum utilizador encontrado"
        },
        "dom": '<"table-wrap"t><"pagination-wrapper d-flex justify-center"p>'
      });

      function atualizarKPIs() {
        var filtrado = table.rows({ search: 'applied' }).count();
        $('#totalFiltrado').text(filtrado);
      }

      atualizarKPIs();

      $('#searchInput').on('keyup', function() {
        table.search(this.value).draw();
      });

      $('#btnFiltrar').on('click', function() {
        table.search($('#searchInput').val()).draw();
      });

      table.on('draw', function() {
        atualizarKPIs();
      });
    });

    function abrirModal(nif, nome, contacto, email, idFuncao, ativo) {
      document.getElementById("modal").style.display = "flex";
      document.getElementById("edit_nif").value = nif;
      document.getElementById("edit_nome").value = nome;
      document.getElementById("edit_contacto").value = contacto;
      document.getElementById("edit_email").value = email;
      document.getElementById("edit_id_funcao").value = idFuncao;
      document.getElementById("edit_ativo").checked = !!ativo;
      document.getElementById("edit_password").value = "";
    }

    function fecharModal() {
      document.getElementById("modal").style.display = "none";
    }

    function abrirModalAddFuncionario() {
      document.getElementById("modalAddFuncionario").style.display = "flex";
    }

    function fecharModalAddFuncionario() {
      document.getElementById("modalAddFuncionario").style.display = "none";
    }
  </script>
</body>
</html>