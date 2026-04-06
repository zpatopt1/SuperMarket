<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% request.setAttribute("seccao", "Sistema"); %>
<!DOCTYPE html>
<html lang="pt-PT">
<head>
    <meta charset="UTF-8">
    <title>Gerir Promoções</title>
    
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
                <h2 class="page-title">Gerir Promoções</h2>
                <p class="page-subtitle">Consulta de campanhas e descontos em vigor</p>
              </div>
            </div>

            <section class="card">
                <div class="toolbar" style="display: flex; justify-content: space-between; align-items: stretch; gap: 15px;">
                    
                    <div class="search" style="flex: 1;">
                        <span class="search-ico" aria-hidden="true">⌕</span>
                        <input type="text" placeholder="Pesquisar campanha..." id="searchInput">
                    </div>
                    
                    <div style="display: flex; gap: 10px;">
                        <select id="estadoFilter" style="border: 1px solid #e2e8f0; border-radius: 6px; padding: 0 15px; outline: none; font-family: inherit; font-size: 14px; background: white; color: #4a5568; cursor: pointer;">
                            <option value="">Todos os Estados</option>
                            <option value="Ativa">Ativas</option>
                            <option value="Expirada">Expiradas</option>
                        </select>
                        <button class="btn-primary" id="btnFiltrar">Filtrar</button>
                    </div>
                    
                </div>
                
                <div class="table-wrap">
                    <table id="promocoesTable" class="table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Campanha</th>
                                <th>Desconto</th>
                                <th>Validade</th>
                                <th>Estado</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>#P102</td>
                                <td>Especial Bebidas de Verão</td>
                                <td>-15%</td>
                                <td>Até 31 Ago 2026</td>
                                <td>Ativa</td>
                            </tr>
                            <tr>
                                <td>#P098</td>
                                <td>Semana dos Laticínios</td>
                                <td>-10%</td>
                                <td>Até 15 Mar 2026</td>
                                <td>Expirada</td>
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
          var table = $('#promocoesTable').DataTable({
              "pageLength": 5,
              "language": {
                  "search": "Pesquisar:",
                  "lengthMenu": "Mostrar _MENU_ promoções",
                  "info": "Mostrando _START_ a _END_ de _TOTAL_ promoções",
                  "paginate": {
                      "previous": "« Anterior",
                      "next": "Próximo »"
                  },
                  "zeroRecords": "Nenhuma promoção encontrada"
              },
              "dom": '<"table-wrap"t><"pagination-wrapper d-flex justify-center"p>'
          });

          // Ligar a barra de pesquisa de texto
          $('#searchInput').on('keyup', function() {
              table.search(this.value).draw();
          });

          // Ligar o botão de Filtrar ao Dropdown de Estados
          // Procura na coluna 4 (Estado)
          $('#btnFiltrar').on('click', function() {
              var estado = $('#estadoFilter').val();
              table.column(4).search(estado).draw();
          });
      });
  </script>
</body>
</html>