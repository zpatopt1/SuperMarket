<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!doctype html>
<html lang="pt-PT">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <title>SuperMart - Transferir Stock</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800;900&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/Front-end/styles/styles.css" />
  <style>
    .form-group {
      margin-bottom: 20px;
    }
    
    .form-label {
      display: block;
      font-size: 0.95rem;
      font-weight: 700;
      color: #334155;
      margin-bottom: 8px;
    }
    
    .form-control {
      width: 100%;
      padding: 12px 16px;
      border: 1px solid #cbd5e1;
      border-radius: 8px;
      font-size: 1rem;
      color: #1e293b;
      transition: all 0.2s;
    }
    
    .form-control:focus {
      outline: none;
      border-color: #3b82f6;
      box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
    }
    
    .btn-submit {
      background-color: #3b82f6;
      color: white;
      border: none;
      padding: 14px 24px;
      border-radius: 12px;
      font-weight: 800;
      font-size: 1rem;
      cursor: pointer;
      transition: background-color 0.2s;
      width: 100%;
      margin-top: 10px;
    }
    
    .btn-submit:hover {
      background-color: #2563eb;
    }
    
    .alert {
      padding: 16px;
      border-radius: 12px;
      margin-bottom: 24px;
      font-weight: 600;
      display: none;
    }

    .alert.success {
      display: block;
      background-color: #d1fae5;
      color: #065f46;
      border: 1px solid #10b981;
    }

    .alert.error {
      display: block;
      background-color: #fee2e2;
      color: #991b1b;
      border: 1px solid #ef4444;
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
        
        <div style="margin-bottom: 24px;">
            <h1 style="font-size: 1.8rem; font-weight: 900; color: #0f172a; margin: 0;">Transferir Stock</h1>
            <p style="color: #64748b; margin-top: 4px; font-size: 0.95rem;">Move as tuas mercadorias entre o Armazém e a Loja de forma segura.</p>
        </div>

        <!-- Mensagens de Erro/Sucesso -->
        <% String msgSucesso = (String) request.getAttribute("sucesso"); %>
        <% String msgErro = (String) request.getAttribute("erro"); %>
        
        <% if (msgSucesso != null) { %>
            <div class="alert success">✅ <%= msgSucesso %></div>
        <% } %>
        
        <% if (msgErro != null) { %>
            <div class="alert error">❌ <%= msgErro %></div>
        <% } %>

        <div class="grid grid-top">
          <!-- Formulário -->
          <section class="card">
            <div class="card-head simple">
              <h2>Detalhes da Movimentação</h2>
            </div>
            <div class="card-body">
              <form action="${pageContext.request.contextPath}/TransferirStockServlet" method="post">
                
                <div class="form-group">
                  <label class="form-label" for="idProduto">ID do Produto</label>
                  <input type="number" name="idProduto" id="idProduto" class="form-control" placeholder="Ex: 5" required min="1">
                </div>
                
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                    <div class="form-group">
                      <label class="form-label" for="idOrigem">De (Origem)</label>
                      <select name="idOrigem" id="idOrigem" class="form-control" required>
                          <option value="2">Armazém</option>
                          <option value="1">Loja</option>
                      </select>
                    </div>
                    
                    <div class="form-group">
                      <label class="form-label" for="idDestino">Para (Destino)</label>
                      <select name="idDestino" id="idDestino" class="form-control" required>
                          <option value="1">Loja</option>
                          <option value="2">Armazém</option>
                      </select>
                    </div>
                </div>

                <div class="form-group">
                  <label class="form-label" for="quantidade">Quantidade a Transferir</label>
                  <input type="number" name="quantidade" id="quantidade" class="form-control" placeholder="Ex: 20" required min="1">
                </div>

                <button type="submit" class="btn-submit">Confirmar Transferência</button>
              </form>
            </div>
          </section>

          <!-- Instruções -->
          <section class="card">
            <div class="card-head simple">
              <h2>Instruções</h2>
            </div>
            <div class="card-body">
              <p style="font-size: 0.9rem; color: #475569; line-height: 1.6;">
                Nesta página podes gerir a localização física da tua mercadoria. Sê cuidadoso para não esgotar acidentalmente o armazém.
              </p>
              <ul style="font-size: 0.9rem; color: #1e293b; font-weight: 500; margin-top: 15px; line-height: 1.8; padding-left: 20px;">
                <li>O sistema verifica automaticamente se tens unidades suficientes na Origem antes de aprovar.</li>
                <li>Se transferires para um Destino onde o produto ainda não existe, ele é criado com essa quantidade.</li>
                <li>Podes consultar o <strong style="color: #3b82f6;">ID do Produto</strong> na página "Produtos".</li>
              </ul>
              
              <div style="background-color: #f8fafc; padding: 12px; border-left: 4px solid #f59e0b; border-radius: 0 8px 8px 0; font-size: 0.85rem; color: #334155; margin-top: 20px;">
                <strong>Nota de Segurança:</strong> As transferências são irreversíveis diretamente. Se te enganares, basta fazeres a transferência inversa.
              </div>
            </div>
          </section>
        </div>

      </section>
    </main>
  </div>
  
  <script type="module" src="${pageContext.request.contextPath}/Front-end/js/pages/dashboard.js"></script>
</body>
</html>
