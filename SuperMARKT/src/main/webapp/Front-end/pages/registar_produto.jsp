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
                            <input type="number" name="id_produto" placeholder="Ex: 101" required>
                        </div>

                        <div class="input-group">
                            <label>ID Categoria</label>
                            <input type="number" name="id_categoria" placeholder="Ex: 5" required>
                        </div>

                        <div class="input-group full-width">
                            <label>Nome do Produto</label>
                            <input type="text" name="nome" placeholder="Ex: Maçã Fuji" required>
                        </div>

                        <div class="input-group">
                            <label>Marca</label>
                            <input type="text" name="marca" placeholder="Ex: Pingo Doce">
                        </div>

                        <div class="input-group">
                            <label>Unidade Medida</label>
                            <input type="text" name="unidade" placeholder="Ex: Kg, Un">
                        </div>

                        <div class="input-group">
                            <label>Código de Barras</label>
                            <input type="text" name="cod_barras" placeholder="Ex: 560123456789">
                        </div>

                        <div class="input-group">
                            <label>Preço (€)</label>
                            <input type="number" step="0.01" name="preco" placeholder="0.00" required>
                        </div>

                        <div class="button-group full-width">
                            <button type="submit" class="btn-guardar">Guardar Produto</button>
                        </div>

                    </form>
                </div>
            </div>
            </main>
    </div>
</body>
</html>
