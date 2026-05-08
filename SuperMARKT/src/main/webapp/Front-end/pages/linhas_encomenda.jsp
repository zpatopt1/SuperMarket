<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>
<%@ page import="model.Encomenda" %>
<%@ page import="model.LinhaEnc" %>

<%
List<LinhaEnc> linhas =
    (List<LinhaEnc>) request.getAttribute("linhas");
%>

<h3>Linhas da Encomenda</h3>

<table border="1" width="100%">

<tr>
    <th>Produto</th>
    <th>Quantidade</th>
    <th>Preço</th>
    <th>Validade</th>
    <th>Total</th>
</tr>

<%
if (linhas != null) {
    for (LinhaEnc l : linhas) {
%>

<tr>
    <td><%= l.getProduto().getNome() %></td>
    <td><%= l.getQuantidade() %></td>
    <td><%= l.getPrecoEncomenda() %> €</td>
    <td><%= l.getDataValidade() %></td>
    <td><%= l.getQuantidade() * l.getPrecoEncomenda() %> €</td>
</tr>

<%
    }
}
%>

</table>