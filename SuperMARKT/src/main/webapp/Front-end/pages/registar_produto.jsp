<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="pt-PT">
<head>
    <meta charset="UTF-8">
    <title>SuperMart - Registar Produto</title>
    
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

            <div class="registo-container">
            <div class="registo-card">
            <h2>Registar Novo Produto</h2>

                    
		<form action="${pageContext.request.contextPath}/ProdutoServlet" method="POST" class="form-grid">
		
		    <div class="input-group">
		        <label>ID Produto</label>
		        <input type="number" name="id_produto"
		        value="${produto != null ? produto.idProduto : ''}"
		        ${produto != null ? 'readonly' : ''}
		        required>
		    </div>
		
		    <div class="input-group">
		        <label>ID Categoria</label>
		        <input type="number" name="id_categoria"
		        value="${produto != null ? produto.categoria.idCategoria : ''}"
		        required>
		    </div>
		
		    <div class="input-group full-width">
		        <label>Nome</label>
		        <input type="text" name="nome"
		        value="${produto != null ? produto.nome : ''}"
		        required>
		    </div>
		
		    <div class="input-group">
		        <label>Marca</label>
		        <input type="text" name="marca"
		        value="${produto != null ? produto.marca : ''}">
		    </div>
		
		    <div class="input-group">
		        <label>Unidade</label>
		        <input type="text" name="unidade"
		        value="${produto != null ? produto.unidadeMedida : ''}">
		    </div>
		
		    <div class="input-group">
		        <label>Código Barras</label>
		        <input type="text" name="cod_barras"
		        value="${produto != null ? produto.codBarras : ''}">
		    </div>
		
		    <div class="input-group">
		        <label>Preço</label>
		        <input type="number" step="0.01" name="preco"
		        value="${produto != null ? produto.preco : ''}"
		        required>
		    </div>
		
		    <div class="button-group full-width">
		        <button type="submit" name="action"
		        value="${produto != null ? 'update' : 'insert'}"
		        class="btn-guardar">
		
		        ${produto != null ? 'Atualizar Produto' : 'Guardar Produto'}
		
		        </button>
		    </div>
		
		</form>
	
	
	    <div class="form-grid">
	       <form action="${pageContext.request.contextPath}/ProdutoServlet" method="POST">
	           		<div class="input-group" style="padding-top: 10px">
	        	<label>Insira o ID do Produto para Editar</label>
	          	<input type="number" name="update_id_produto">
	          	</div>
	          	<div class="button-group full-width">
	          		<button type="submit" name="action" value="updateForm" class="btn-guardar" style="background-color:green;">Editar</button>
	          	</div>
	       </form>
	            
	            
	            <form action="${pageContext.request.contextPath}/ProdutoServlet" method="POST">
	           		<div class="input-group" style="padding-top: 10px">
	        		<label>Insira o ID do Produto para Deletar</label>
	          		<input type="number" name="delete_id_produto">
	          		</div>
	          		<div class="button-group full-width">
	          			<button type="submit" name="action" value="delete" class="btn-guardar" style="background-color:red;">Apagar</button>
	          		</div>
	            </form>
	  	</div>
	            
	  	<div class="mensagem-container">
	  	<%
	    	String msg = (String) request.getAttribute("msg"); // Mensagem vinda do Servlet

	  		if(msg != null) {
	 	%>
			<h1  style="font-size:20px;"><%=msg%></h1> 
		<%
			}
	  	%>
	  	</div>
	  	
	</body>
	<script type="module" src="/SuperMARKT/Front-end/js/pages/dashboard.js"></script>

</html>
