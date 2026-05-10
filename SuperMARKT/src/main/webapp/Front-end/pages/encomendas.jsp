<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>
<%@ page import="model.Encomenda" %>

<h2>Encomendas</h2>

<table border="1" width="100%">

<tr>
    <th>ID</th>
    <th>Fornecedor</th>
    <th>Destino</th>
    <th>Status</th>
    <th>Data Pedido</th>
    <th>Data Prevista</th>
    <th>Data Chegada</th>
    <th>Valor Envio
    <th>Total</th>
    <th>Ver Encomenda</th>
</tr>

<%
List<Encomenda> lista =
    (List<Encomenda>) request.getAttribute("encomendas");

if (lista != null) {
    for (Encomenda e : lista) {
%>

<tr>

    <td><%= e.getIdMovimentos().getIdMovimentos() %></td>
    <td><%= e.getIdFornecedor().getIdFornecedor() %></td>
    <td><%= e.getIdLocal().getIdLocal() %></td>
    <td><%= e.getIdMovimentos().getData() %></td>
    <td><%= e.getIdMovimentos().getStatus() %></td>
    <td><%= e.getDataPrevista() %></td>
    <td><%= e.getDataChegada() %></td>
	<td><%= e.getCustoEnvio() %> €</td>
    <td><%= e.getValorTotal() %> €</td>

    <td>
        <a href="DetalhesEncomendaServlet?id=<%= e.getIdMovimentos().getIdMovimentos() %>">
            Abrir
        </a>
    </td>

</tr>

<%
    }
}
%>

</table>