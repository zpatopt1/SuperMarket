<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% request.setAttribute("seccao", "Sistema"); %>
<!DOCTYPE html>
<html lang="pt-PT">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1" />
    <title>Gestão de Utilizadores</title>
    
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
                <h2 class="page-title">Gestão de Utilizadores</h2>
                <p class="page-subtitle">Lista de funcionários com acesso ao sistema</p>
              </div>
            </div>

            <section class="card">
                <div class="toolbar" style="display: flex; justify-content: space-between; align-items: stretch; gap: 15px; margin-bottom: 20px;">
                    <div class="search" style="flex: 1;">
                        <span class="search-ico" aria-hidden="true">⌕</span>
                        <input type="text" placeholder="Pesquisar utilizadores..." id="searchInput">
                    </div>
                    
                    <div style="display: flex; gap: 10px;">
                        <select id="cargoFilter" style="border: 1px solid #e2e8f0; border-radius: 6px; padding: 0 15px; outline: none; font-family: inherit; font-size: 14px; background: white; color: #4a5568; cursor: pointer;">
                            <option value="">Todos os Cargos</option>
                            <option value="Administrador">Administrador</option>
                            <option value="Operador de Caixa">Operador de Caixa</option>
                            <option value="Gestor do Sistema">Gestor do Sistema</option>
                        </select>
                        <button class="btn-primary" id="btnFiltrar">Filtrar</button>
                    </div>
                </div>
                
                <div class="table-wrap">
                    <table id="utilizadoresTable" class="table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Nome</th>
                                <th>Email</th>
                                <th>Cargo</th>
                                <th>Estado</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>#001</td>
                                <td>Ahmed Al-Majmaie</td>
                                <td>ahmed.maj@supermart.pt</td>
                                <td>Operador de Caixa</td>
                                <td style="color: #059669; font-weight: 600;">Ativo</td>
                            </tr>
                            <tr>
                                <td>#002</td>
                                <td>José Pedro Moreira</td>
                                <td>jose.moreira@supermart.pt</td>
                                <td>Administrador</td>
                                <td style="color: #059669; font-weight: 600;">Ativo</td>
                            </tr>
                            <tr>
                                <td>#003</td>
                                <td>Pedro Marques</td>
                                <td>pedro.marques@supermart.pt</td>
                                <td>Gestor do Sistema</td>
                                <td style="color: #059669; font-weight: 600;">Ativo</td>
                            </tr>                                                           
                        </tbody>
                    </table>
                </div>
            </section>
        </section>
    </main>
  </div>

  <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
  <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
  <script>
      $(document).ready(function() {
          var table = $('#utilizadoresTable').DataTable({
              "pageLength": 10,
              "dom": 't<"pagination-wrapper d-flex justify-center"p>',
              "language": {
                  "zeroRecords": "Nenhum utilizador encontrado",
                  "paginate": { "previous": "«", "next": "»" }
              }
          });

          $('#searchInput').on('keyup', function() {
              table.search(this.value).draw();
          });

          $('#btnFiltrar').on('click', function() {
              table.column(3).search($('#cargoFilter').val()).draw();
          });
      });
  </script>
</body>
</html>