<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>SuperMart - Registar Produto</title>
    <link rel="stylesheet" href="../styles/styles.css" />
</head>
<body>
    <div class="container">
        <h2>Registar Novo Produto</h2>
        
        <%-- O action deve ser o nome do Servlet --%>
		<form action="${pageContext.request.contextPath}/ProdutoServlet" method="POST">            
            <label>ID Produto:</label>
            <input type="number" name="id_produto" required>

            <label>ID Categoria:</label>
            <input type="number" name="id_categoria" required>

            <label>Nome do Produto:</label>
            <input type="text" name="nome" required>

            <label>Marca:</label>
            <input type="text" name="marca">

            <label>Unidade Medida (Ex: Kg, Un):</label>
            <input type="text" name="unidade">

            <label>Código de Barras:</label>
            <input type="text" name="cod_barras">

            <label>Preço:</label>
            <input type="number" step="0.01" name="preco" required>

            <button type="submit">Guardar Produto</button>
        </form>
    </div>
</body>
</html>
