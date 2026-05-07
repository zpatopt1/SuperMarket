<%@ page import="model.Funcionario" %>
<%
  Funcionario user = (Funcionario) session.getAttribute("utilizadorLogado");
  String seccao = (request.getAttribute("seccao") != null) ? String.valueOf(request.getAttribute("seccao")) : "SuperMart";

  String nome = "Utilizador";
  String role = "Sem funcao";

  if (user != null) {
    if (user.getNome() != null && !user.getNome().isBlank()) {
      nome = user.getNome();
    }
}
    if (user.getIdFuncao() != null && user.getIdFuncao().getDescricao() != null && !user.getIdFuncao().getDescricao().isBlank()) {
      role = user.getIdFuncao().getDescricao();
    }
  

  String initials = "U";
  String[] parts = nome.trim().split("\\s+");
  if (parts.length >= 2) {
    initials = (parts[0].substring(0, 1) + parts[1].substring(0, 1)).toUpperCase();
  } else if (parts.length == 1 && !parts[0].isBlank()) {
    initials = parts[0].substring(0, 1).toUpperCase();
  }
%>

<header class="topbar">
  <button id="toggleBtn" class="toggle-btn">
    <div class="brand no-padding">
      <div class="logo">S</div>
      <div class="name">SuperMart</div>
    </div>
  </button>

  <h1 id="mostrar" class="mostrar"><%= seccao %></h1>

  <div class="topbar-right">
    <div class="select">
      <span class="muted"></span>
    </div>

    <div class="user">
      <div class="avatar"><%= initials %></div>
      <div>
        <div class="user-name"><%= nome %></div>
        <div class="user-role"><%= role %></div>
    </div>
  </div>
</header>