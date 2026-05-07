<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% request.setAttribute("seccao", "Gestão de Fornecedores"); %>
<%@ page import="java.util.List" %>
<%@ page import="model.Fornecedor" %>
<!DOCTYPE html>
<html lang="pt-PT">
<head>
  <meta charset="UTF-8">
  <title>Consultar Fornecedores</title>
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
          <h2 class="page-title">Consultar Fornecedores</h2>
          <p class="page-subtitle">Gestão de fornecedores</p>
        </div>
      </div>

      <section class="card">
        <div class="toolbar">
          <div class="search">
            <span class="search-ico" aria-hidden="true">⌕</span>
            <input type="text" placeholder="Pesquisar fornecedores" id="searchInput">
          </div>
          <button type="button" class="btn-primary" onclick="abrirModalAdd()">Adicionar Fornecedor</button>
        </div>

        <div class="table-wrap">
          <table id="fornecedoresTable" class="table">
            <thead>
            <tr>
              <th>ID</th>
              <th>Tipo</th>
              <th>Contacto</th>
              <th>NIF</th>
              <th>Editar</th>
              <th>Apagar</th>
            </tr>
            </thead>
            <tbody>
            <%
              List<Fornecedor> fornecedores = (List<Fornecedor>) request.getAttribute("fornecedores");
              if (fornecedores != null) {
                for (Fornecedor f : fornecedores) {
                  String tipo = f.getTipoFornecedor() != null ? f.getTipoFornecedor().replace("\\", "\\\\").replace("'", "\\'") : "";
                  String contacto = f.getContacto() != null ? f.getContacto().replace("\\", "\\\\").replace("'", "\\'") : "";
                  String nif = f.getNif() != null ? f.getNif().replace("\\", "\\\\").replace("'", "\\'") : "";
            %>
            <tr>
              <td><%= f.getIdFornecedor() %></td>
              <td><%= f.getTipoFornecedor() %></td>
              <td><%= f.getContacto() %></td>
              <td><%= f.getNif() %></td>
              <td>
                <button type="button" class="btn-action btn-edit"
                        onclick="abrirModalEdit('<%= f.getIdFornecedor() %>','<%= tipo %>','<%= contacto %>','<%= nif %>')">Editar</button>
              </td>
              <td>
                <form method="post" action="${pageContext.request.contextPath}/ConsultarFornecedoresServlet" style="margin:0;">
                  <input type="hidden" name="action" value="delete">
                  <input type="hidden" name="id_fornecedor" value="<%= f.getIdFornecedor() %>">
                  <button type="submit" class="btn-action btn-delete">Apagar</button>
                </form>
              </td>
            </tr>
            <% } } %>
            </tbody>
          </table>
        </div>
      </section>
    </section>
  </main>
</div>

<div id="modalEdit" class="modal">
  <div class="registo-card">
    <span class="close" onclick="fecharModalEdit()">x</span>
    <h3>Editar Fornecedor</h3>
    <form action="${pageContext.request.contextPath}/ConsultarFornecedoresServlet" method="post">
      <input type="hidden" name="action" value="update">
      <input type="hidden" id="edit_id_fornecedor" name="id_fornecedor">
      <div class="input-group full-width">
        <label>Tipo</label>
        <input type="text" id="edit_tipo_fornecedor" name="tipo_fornecedor" required>
      </div>
      <div class="input-group full-width">
        <label>Contacto</label>
        <input type="text" id="edit_contacto" name="contacto">
      </div>
      <div class="input-group full-width">
        <label>NIF</label>
        <input type="text" id="edit_nif" name="nif">
      </div>
      <div class="button-group full-width">
        <button type="submit" class="btn-guardar">Atualizar</button>
      </div>
    </form>
  </div>
</div>

<div id="modalAdd" class="modal">
  <div class="registo-card">
    <span class="close" onclick="fecharModalAdd()">x</span>
    <h3>Adicionar Fornecedor</h3>
    <form action="${pageContext.request.contextPath}/ConsultarFornecedoresServlet" method="post">
      <input type="hidden" name="action" value="insert">
      <div class="input-group full-width">
        <label>Tipo</label>
        <input type="text" name="tipo_fornecedor" required>
      </div>
      <div class="input-group full-width">
        <label>Contacto</label>
        <input type="text" name="contacto">
      </div>
      <div class="input-group full-width">
        <label>NIF</label>
        <input type="text" name="nif">
      </div>
      <div class="button-group full-width">
        <button type="submit" class="btn-guardar">Criar</button>
      </div>
    </form>
  </div>
</div>

<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
<script>
  $(document).ready(function() {
    var table = $('#fornecedoresTable').DataTable({
      pageLength: 5,
      language: {
        search: "Pesquisar:",
        lengthMenu: "Mostrar _MENU_ fornecedores por página",
        info: "Mostrando _START_ a _END_ de _TOTAL_ fornecedores",
        paginate: { previous: "« Anterior", next: "Próximo »" },
        zeroRecords: "Nenhum fornecedor encontrado"
      },
      dom: '<"table-wrap"t><"pagination-wrapper d-flex justify-center"p>'
    });
    $('#searchInput').on('keyup', function() { table.search(this.value).draw(); });
  });

  function abrirModalEdit(id, tipo, contacto, nif) {
    document.getElementById('edit_id_fornecedor').value = id;
    document.getElementById('edit_tipo_fornecedor').value = tipo;
    document.getElementById('edit_contacto').value = contacto;
    document.getElementById('edit_nif').value = nif;
    document.getElementById('modalEdit').style.display = 'flex';
  }
  function fecharModalEdit() { document.getElementById('modalEdit').style.display = 'none'; }
  function abrirModalAdd() { document.getElementById('modalAdd').style.display = 'flex'; }
  function fecharModalAdd() { document.getElementById('modalAdd').style.display = 'none'; }
</script>
</body>
</html>
