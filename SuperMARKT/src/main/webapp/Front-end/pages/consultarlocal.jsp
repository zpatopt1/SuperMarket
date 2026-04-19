<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% request.setAttribute("seccao", "Gestão de Locais"); %>
<%@ page import="java.util.List" %>
<%@ page import="model.Local" %>
<!DOCTYPE html>
<html lang="pt-PT">
<head>
    <meta charset="UTF-8">
    <title>Consultar Locais</title>
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
            <h2 class="page-title">Consultar Locais</h2>
            <p class="page-subtitle">Gestão de locais</p>
          </div>
          <button class="btn-primary" type="button">Exportar Relatorio</button>
        </div>
        <!-- KPIs -->
        <div class="kpis kpis-stock">
          <div class="kpi">
            <div class="kpi-label">Total Locais</div>
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
            <div class="kpi-value">1913.32 €</div>
          </div>
        </div>

        <section class="card">
	 <!-- Search + filter -->
    <div class="toolbar">
        <div class="search">
             <!--  <span class="search-ico">&#128269;</span> -->
            <span class="search-ico" aria-hidden="true">⌕</span>
            <input type="text" placeholder="Pesquisar categorias" id="searchInput">
        </div>
        <button class="btn-primary">Filtrar</button>
        <button type="button" class="btn-primary" onclick="abrirModalAddLocal()">Adicionar Local</button>
        </div>

          <div class="table-wrap">
            <table id="locaisTable" class="table">
              <thead>
                <tr>
                  <th>ID</th>
                  <th>Nome</th>
                  <th>Tipo</th>
                  <th>Editar</th>
                  <th>Apagar</th>
                </tr>
              </thead>
              <tbody>
                <%
                  List<Local> locais = (List<Local>) request.getAttribute("locais");
                  if (locais != null) {
                    for (Local local : locais) {
                %>
                <tr>
                  <td><%= local.getIdLocal() %></td>
                  <td><%= local.getNome() %></td>
                  <td><%= local.getTipoLocal() %></td>
                  <td>
                    <button type="button" class="btn-guardar" style="background-color:gray;"
                      onclick="abrirModal(<%= local.getIdLocal() %>, '<%= local.getNome() %>', '<%= local.getTipoLocal() %>')">
                      Editar
                    </button>
                  </td>
                  <td>
                    <form method="post" action="${pageContext.request.contextPath}/ConsultarLocalServlet" style="display:inline;">
                      <input type="hidden" name="delete_id_local" value="<%= local.getIdLocal() %>" />
                      <input type="hidden" name="action" value="delete" />
                      <button type="submit" class="btn-guardar" style="background-color:red;">Apagar</button>
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

        <div id="modal" class="modal">
          <div class="registo-card">
            <span class="close" onclick="fecharModal()">x</span>
            <h3>Editar Local</h3>
            <form action="${pageContext.request.contextPath}/ConsultarLocalServlet" method="POST">
              <input type="hidden" name="action" value="update" />
              <input type="hidden" id="modal_id_local" name="id_local" />

              <div class="input-group full-width">
                <label>Nome</label>
                <input type="text" id="modal_nome" name="nome" required />
              </div>

              <div class="input-group full-width">
                <label>Tipo</label>
                <input type="text" id="modal_tipo" name="tipo_local" />
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
                <input type="text" id="modal_add_nome" name="nome_local" required />
              </div>

              <div class="input-group full-width">
                <label>Tipo</label>
                <input type="text" id="modal_add_tipo" name="tipo_local" />
              </div>

              <div class="button-group full-width">
                <button type="submit" class="btn-guardar">Criar Local</button>
              </div>
            </form>
          </div>
        </div>

        <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
        <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
        <script>
          $(document).ready(function() {
            var table = $('#locaisTable').DataTable({
              pageLength: 5,
              language: {
                search: 'Pesquisar:',
                lengthMenu: 'Mostrar _MENU_ locais por página',
                info: 'Mostrando _START_ a _END_ de _TOTAL_ locais',
                paginate: { previous: '« Anterior', next: 'Próximo »' },
                zeroRecords: 'Nenhum local encontrado'
              },
              dom: '<"table-wrap"t><"pagination-wrapper d-flex justify-center"p>'
            });
            
            // Atualizar KPIs
            function atualizarKPIs() {
                var total = table.data().count();
                var filtrado = table.rows({ search: 'applied' }).count();

                $('#totalFiltrado').text(filtrado);
            }
            // Inicial
            atualizarKPIs();
            
            // Ligando input customizado com DataTables
            $('#searchInput').on('keyup', function() {
                table.search(this.value).draw();
            });
            
            // Sempre que a tabela muda
            table.on('draw', function() {
                atualizarKPIs();
            }); 
        });


          function abrirModal(id, nome, tipo) {
            document.getElementById('modal').style.display = 'flex';
            document.getElementById('modal_id_local').value = id;
            document.getElementById('modal_nome').value = nome;
            document.getElementById('modal_tipo').value = tipo;
          }

          function fecharModal() {
            document.getElementById('modal').style.display = 'none';
          }

          function abrirModalAddLocal() {
            document.getElementById('modalAddLocal').style.display = 'flex';
          }

          function fecharModalAddLocal() {
            document.getElementById('modalAddLocal').style.display = 'none';
          }
        </script>
      </section>
    </main>
  </div>
  <script type="module" src="/SuperMARKT/Front-end/js/pages/dashboard.js"></script>
</body>
</html>
