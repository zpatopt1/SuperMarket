<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Categoria" %>
<!DOCTYPE html>
<html lang="pt-PT">
<head>
    <meta charset="UTF-8">
    <title>Consultar Categorias</title>
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
  	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  	<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Front-end/styles/styles.css" />
</head>
<body>
  <div class="app">
	<!-- Sidebar -->
	<jsp:include page="/Front-end/pages/components/sidebar.jsp" />

    <!-- Main -->
    <main class="main">

	<!-- Topbar -->
	<jsp:include page="/Front-end/pages/components/topbar.jsp" />
	      <section class="content">
        <!-- Page header -->
        <div class="pagehead">
          <div>
            <h2 class="page-title">Consultar Stock</h2>
            <p class="page-subtitle">Gestão e consulta de inventário</p>
          </div>

          <button class="btn-primary" type="button">Exportar Relatorio</button>
        </div>
		
        <!-- KPIs -->
        <div class="kpis kpis-stock">
          <div class="kpi">
			<div class="kpi-label">Categorias (filtradas)</div>
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
            <input type="text" placeholder="Pesquisar categorias..." id="searchInput">
        </div>
        <!-- <button class="filterbtn">Filtrar</button> -->
        <button class="btn-primary">Filtrar</button>
        </div>
        
    <div class="table-wrap">
        <table id="categoriasTable" class="table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Nome</th>
                    <th>Descrição</th>
                    <th>Editar</th>
                    <th>Apagar</th>
                </tr>
            </thead>
            <tbody>
                <%
                    List<Categoria> categorias = (List<Categoria>) request.getAttribute("categorias");
                    if (categorias != null) {
                        for (Categoria c : categorias) {
                %>
                <tr>
                    <td><%= c.getIdCategoria() %></td>
                    <td><%= c.getNome() %></td>
                    <td><%= c.getDescricao() %></td>
					<td>
				    <button type="button" class="btn-guardar"
                            onclick="abrirModal(<%=c.getIdCategoria()%>, '<%=c.getNome()%>', '<%=c.getDescricao()%>')"
                            style="background-color:gray;">Editar</button>		
					</td>
					<td>
					<form method="post" action="${pageContext.request.contextPath}/ConsultarCategoriaServlet" style="display:inline;">
					    <input type="hidden" name="delete_id_categoria" value="<%= c.getIdCategoria() %>">
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
    

          <!-- Modal Editar Categoria -->
		  <div id="modal" class="modal">
			  <div class="registo-card">
    				<span class="close" onclick="fecharModal()">x</span>
    				<h3>Editar Categoria</h3>
                    <form action="${pageContext.request.contextPath}/ConsultarCategoriaServlet" method="POST">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" id="modal_id_categoria" name="id_categoria">

                        <div class="input-group full-width">
                            <label>Nome</label>
                            <input type="text" id="modal_nome" name="nome" required>
                        </div>

                        <div class="input-group full-width">
                            <label>Descrição</label>
                            <input type="text" id="modal_descricao" name="descricao">
                        </div>

                        <div class="button-group full-width">
                            <button type="submit" class="btn-guardar">Atualizar Categoria</button>
                        </div>
                    </form>
                </div>
            </div>


    <!-- DataTables JS -->
    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script>
        $(document).ready(function() {
            var table = $('#categoriasTable').DataTable({
                "pageLength": 2,
                "language": {
                    "search": "Pesquisar:",
                    "lengthMenu": "Mostrar _MENU_ categorias por página",
                    "info": "Mostrando _START_ a _END_ de _TOTAL_ categorias",
                    "paginate": {
                        "previous": "« Anterior",
                        "next": "Próximo »"
                    },
                    "zeroRecords": "Nenhuma categoria encontrada"
                },
                "dom": '<"table-wrap"t><"pagination-wrapper d-flex justify-center"p>'            });

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

        // Funções modal
        function abrirModal(id, nome, descricao) {
            document.getElementById("modal").style.display = "flex";
            document.getElementById("modal_id_categoria").value = id;
            document.getElementById("modal_nome").value = nome;
            document.getElementById("modal_descricao").value = descricao;
        }
        function fecharModal() {
            document.getElementById("modal").style.display = "none";
        }
        
    </script>

</div>
</body>
</html>