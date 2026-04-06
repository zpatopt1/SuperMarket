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
                </tr>
                <%  
                        }
                    }
                %>
            </tbody>
        </table>
    </div>
    </section>
    

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

            // Ligando input customizado com DataTables
            $('#searchInput').on('keyup', function() {
                table.search(this.value).draw();
            });
        });
    </script>

</div>
</body>
</html>