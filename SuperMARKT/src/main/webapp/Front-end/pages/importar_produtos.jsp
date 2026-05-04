<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!doctype html>
<html lang="pt-PT">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <title>SuperMart - Importar Produtos CSV</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800;900&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/Front-end/styles/styles.css" />
  <style>
    .upload-box {
      border: 2px dashed #cbd5e1;
      border-radius: 20px;
      padding: 60px 40px;
      text-align: center;
      background-color: #f8fafc;
      transition: all 0.3s ease;
      cursor: pointer;
      position: relative;
    }
    
    .upload-box:hover, .upload-box.dragover {
      border-color: #3b82f6;
      background-color: #eff6ff;
    }
    
    .upload-icon {
      font-size: 48px;
      color: #94a3b8;
      margin-bottom: 16px;
    }
    
    .upload-text {
      font-size: 1.1rem;
      font-weight: 700;
      color: #334155;
      margin-bottom: 8px;
    }
    
    .upload-subtext {
      font-size: 0.9rem;
      color: #64748b;
      font-weight: 500;
    }
    
    #file-input {
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      opacity: 0;
      cursor: pointer;
    }
    
    .btn-submit {
      background-color: #2563eb;
      color: white;
      border: none;
      padding: 12px 24px;
      border-radius: 12px;
      font-weight: 800;
      font-size: 1rem;
      cursor: pointer;
      transition: background-color 0.2s;
      width: 100%;
      margin-top: 24px;
    }
    
    .btn-submit:hover {
      background-color: #1d4ed8;
    }
    
    .btn-submit:disabled {
      background-color: #94a3b8;
      cursor: not-allowed;
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

    .selected-file {
      margin-top: 16px;
      padding: 12px;
      background-color: #e2e8f0;
      border-radius: 8px;
      font-weight: 700;
      color: #1e293b;
      display: none;
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
            <h1 style="font-size: 1.8rem; font-weight: 900; color: #0f172a; margin: 0;">Importar Produtos (CSV)</h1>
            <p style="color: #64748b; margin-top: 4px; font-size: 0.95rem;">Adiciona dezenas de produtos à base de dados num só clique.</p>
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
          
          <!-- Formulário de Upload -->
          <section class="card">
            <div class="card-head simple">
              <h2>Carregar Ficheiro</h2>
            </div>
            <div class="card-body">
              <form action="${pageContext.request.contextPath}/ImportarProdutosServlet" method="post" enctype="multipart/form-data" id="uploadForm">
                
                <div class="upload-box" id="dropzone">
                  <div class="upload-icon">📄</div>
                  <div class="upload-text">Clica para escolher ou arrasta o teu ficheiro .csv para aqui</div>
                  <div class="upload-subtext">Apenas ficheiros CSV são suportados. Ponto e vírgula (;) ou vírgula (,) como separador.</div>
                  <input type="file" name="csvFile" id="file-input" accept=".csv" required>
                </div>
                
                <div class="selected-file" id="fileNameDisplay">Nenhum ficheiro selecionado.</div>

                <button type="submit" class="btn-submit" id="submitBtn" disabled>Importar Base de Dados</button>
              </form>
            </div>
          </section>

          <!-- Instruções -->
          <section class="card">
            <div class="card-head simple" style="display: flex; justify-content: space-between; align-items: center;">
              <h2 style="margin: 0;">Instruções do Ficheiro</h2>
              <a href="${pageContext.request.contextPath}/ImportarProdutosServlet?action=template" style="background-color: #10b981; color: white; padding: 6px 14px; border-radius: 8px; font-weight: 700; font-size: 0.85rem; text-decoration: none; display: inline-flex; align-items: center; gap: 6px;">
                Download Template CSV
              </a>
            </div>
            <div class="card-body">
              <p style="font-size: 0.9rem; color: #475569; line-height: 1.6;">
                O ficheiro Excel (.csv) deve conter as seguintes colunas pela ordem exata:
              </p>
              <ol style="font-size: 0.9rem; color: #1e293b; font-weight: 700; margin-top: 10px; margin-bottom: 20px; line-height: 1.8;">
                <li>Categoria <span style="color: #94a3b8; font-weight: 400;">(ex: Bebidas)</span></li>
                <li>Unidade de Medida <span style="color: #94a3b8; font-weight: 400;">(ex: L, kg, un)</span></li>
                <li>Marca <span style="color: #94a3b8; font-weight: 400;">(ex: Compal)</span></li>
                <li>Nome do Produto <span style="color: #94a3b8; font-weight: 400;">(ex: Néctar Maçã)</span></li>
                <li>Código de Barras <span style="color: #94a3b8; font-weight: 400;">(Numérico)</span></li>
                <li>Preço <span style="color: #94a3b8; font-weight: 400;">(ex: 1.45)</span></li>
                <li>Qtd. Inicial (Armazém) <span style="color: #94a3b8; font-weight: 400;">(ex: 50)</span></li>
              </ol>
              
              <div style="background-color: #f1f5f9; padding: 12px; border-radius: 8px; font-size: 0.85rem; color: #334155;">
                <strong>Dica:</strong> A primeira linha do ficheiro (o cabeçalho) será automaticamente ignorada. As Categorias que não existirem no sistema serão criadas automaticamente!
              </div>
            </div>
          </section>
        </div>

      </section>
    </main>
  </div>
  
  <script type="module" src="${pageContext.request.contextPath}/Front-end/js/pages/dashboard.js"></script>
  <script>
    // Scripts simples para interação do Upload
    document.addEventListener('DOMContentLoaded', () => {
      const fileInput = document.getElementById('file-input');
      const dropzone = document.getElementById('dropzone');
      const fileNameDisplay = document.getElementById('fileNameDisplay');
      const submitBtn = document.getElementById('submitBtn');

      fileInput.addEventListener('change', (e) => {
        if(e.target.files.length > 0) {
          const fileName = e.target.files[0].name;
          if(!fileName.endsWith('.csv')) {
             alert('Por favor, seleciona apenas um ficheiro .csv');
             fileInput.value = '';
             return;
          }
          fileNameDisplay.textContent = 'Ficheiro selecionado: ' + fileName;
          fileNameDisplay.style.display = 'block';
          submitBtn.disabled = false;
        } else {
          fileNameDisplay.style.display = 'none';
          submitBtn.disabled = true;
        }
      });

      // Efeitos de Drag and Drop
      ['dragenter', 'dragover', 'dragleave', 'drop'].forEach(eventName => {
        dropzone.addEventListener(eventName, preventDefaults, false);
      });

      function preventDefaults (e) {
        e.preventDefault();
        e.stopPropagation();
      }

      ['dragenter', 'dragover'].forEach(eventName => {
        dropzone.addEventListener(eventName, () => dropzone.classList.add('dragover'), false);
      });

      ['dragleave', 'drop'].forEach(eventName => {
        dropzone.addEventListener(eventName, () => dropzone.classList.remove('dragover'), false);
      });
    });
  </script>
</body>
</html>
