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
</head>
<body>
  <div class="app">
    <jsp:include page="/Front-end/pages/components/sidebar.jsp" />

    <main class="main">
      <jsp:include page="/Front-end/pages/components/topbar.jsp" />

      <section class="content">
        <div class="pagehead">
          <div>
            <h2 class="page-title">Gestao de Utilizadores</h2>
            <p class="page-subtitle">Gestao e consulta de funcionarios</p>
          </div>
          <button class="btn-primary" type="button">Exportar Relatorio</button>
        </div>

        <div class="kpis kpis-stock">
          <div class="kpi">
            <div class="kpi-label">Utilizadores (filtrados)</div>
            <div class="kpi-value" id="totalFiltrado">0</div>
          </div>
          <div class="kpi">
            <div class="kpi-label">Stock Armazem</div>
            <div class="kpi-value">3</div>
          </div>
          <div class="kpi">
            <div class="kpi-label">Stock Loja</div>
            <div class="kpi-value">200</div>
          </div>
          <div class="kpi">
            <div class="kpi-label">Valor Total</div>
            <div class="kpi-value">1913.32 EUR</div>
          </div>
        </div>

        <section class="card">
          <div class="toolbar">
            <div class="search">
              <span class="search-ico" aria-hidden="true">⌕</span>
              <input type="text" placeholder="Pesquisar utilizadores..." id="searchInput">
            </div>
            <button class="btn-primary" type="button" id="btnFiltrar">Filtrar</button>
            <button type="button" class="btn-primary" onclick="abrirModalAddFuncionario()">Adicionar Funcionario</button>
          </div>

          <div class="table-wrap">
            <table id="utilizadoresTable" class="table">
              <thead>
                <tr>
                  <th>NIF</th>
                  <th>Nome</th>
                  <th>Contacto</th>
                  <th>Email</th>
                  <th>Funcao</th>
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
                    <td><%= nome %></td>
                    <td><%= contacto %></td>
                    <td><%= email %></td>
                    <td><%= (f.getIdFuncao() != null && f.getIdFuncao().getDescricao() != null) ? f.getIdFuncao().getDescricao() : "" %></td>
                    <td><%= f.isAtivo() ? "Ativo" : "Inativo" %></td>
                    <td>
                      <button type="button" class="btn-guardar" style="background-color:gray;"
                        onclick="abrirModal('<%= nif %>', '<%= nomeJs %>', '<%= contactoJs %>', '<%= emailJs %>', '<%= idFuncao %>', <%= f.isAtivo() ? "true" : "false" %>)">Editar</button>
                    </td>
                    <td>
                      <form method="post" action="${pageContext.request.contextPath}/ConsultarUtilizadoresServlet" style="display:inline;">
                        <input type="hidden" name="delete_nif" value="<%= nif %>">
                        <input type="hidden" name="action" value="delete">
                        <button type="submit" class="btn-guardar" style="background-color:red;">Apagar</button>
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