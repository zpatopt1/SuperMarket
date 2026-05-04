<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% request.setAttribute("seccao", "Gestão de Produtos"); %>
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
    </style>
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
            <h2 class="page-title">Consultar Categorias</h2>
            <p class="page-subtitle">Gestão e consulta de Categorias</p>
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
            <input type="text" placeholder="Pesquisar categorias" id="searchInput">
        </div>
        <!-- <button class="filterbtn">Filtrar</button> -->
        <button class="btn-primary">Filtrar</button>
        <button type="button" class="btn-primary" onclick="abrirModalAddCategoria()">Adicionar Categoria</button>
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
				    <button type="button" class="btn-action btn-edit"
                            onclick="abrirModal('<%=c.getIdCategoria()%>', '<%=c.getNome()%>', '<%=c.getDescricao()%>')">
                            Editar</button>		
					</td>
					<td>
					<form method="post" action="${pageContext.request.contextPath}/ConsultarCategoriaServlet" style="margin:0;">
					    <input type="hidden" name="delete_id_categoria" value="<%= c.getIdCategoria() %>">
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


    <!-- Modal Adicionar Categoria -->
    <div id="modalAddCategoria" class="modal">
      <div class="registo-card">
        <span class="close" onclick="fecharModalAddCategoria()">x</span>
        <h3>Adicionar Categoria</h3>
        <form action="${pageContext.request.contextPath}/ConsultarCategoriaServlet" method="POST">
          <input type="hidden" name="action" value="insert">

          <div class="input-group full-width">
            <label>Nome</label>
            <input type="text" id="modal_add_nome" name="nome_categoria" required>
          </div>

          <div class="input-group full-width">
            <label>Descrição</label>
            <input type="text" id="modal_add_descricao" name="descricao_categoria">
          </div>

          <div class="button-group full-width">
            <button type="submit" class="btn-guardar">Criar Categoria</button>
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
                "pageLength": 5,
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
        
        function abrirModalAddCategoria() {
            document.getElementById("modalAddCategoria").style.display = "flex";
        }

        function fecharModalAddCategoria() {
            document.getElementById("modalAddCategoria").style.display = "none";
        }
        
    </script>

</div>
 <script type="module" src="/SuperMARKT/Front-end/js/pages/dashboard.js"></script>

</body>
</html>