<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Encomenda" %>
<%@ page import="model.LinhaEnc" %>
<%
  Encomenda encomenda = (Encomenda) request.getAttribute("encomenda");
  List<LinhaEnc> linhas = (List<LinhaEnc>) request.getAttribute("linhas");
  request.setAttribute("seccao", "Confirmar Encomenda");
%>
<!doctype html>
<html lang="pt-PT">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <title>Confirmar Encomenda</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/Front-end/styles/styles.css" />
  <style>
    /* Estilos específicos para a lógica de lotes */
    .caixa-soma { font-weight: 700; padding: 4px 8px; border-radius: 4px; font-size: 0.9em; }
    .ok { background-color: #d1fae5; color: #065f46; border: 1px solid #10b981; }
    .erro { background-color: #fee2e2; color: #991b1b; border: 1px solid #ef4444; }
    .lote-item { 
        display: flex; align-items: center; gap: 10px; 
        background: #f9fafb; padding: 8px; border-radius: 6px; margin-bottom: 5px;
        border: 1px solid #e5e7eb;
    }
    .lote-item input { padding: 5px; border: 1px solid #ccc; border-radius: 4px; }
    .btn-add-lote { background: #6366f1; color: white; border: none; padding: 4px 8px; border-radius: 4px; cursor: pointer; font-size: 12px; }
    .btn-remove-lote { color: #ef4444; background: none; border: none; font-weight: bold; cursor: pointer; }
    .td-lotes { min-width: 350px; }
  </style>
</head>
<body>
  <div class="app">
    <jsp:include page="/Front-end/pages/components/sidebar.jsp" />
    <main class="main">
      <jsp:include page="/Front-end/pages/components/topbar.jsp" />
      
      <section class="content">
        <div class="pagehead">
          <div>
            <h2 class="page-title">Confirmar Encomenda #<%= encomenda != null && encomenda.getIdMovimentos() != null ? encomenda.getIdMovimentos().getIdMovimentos() : "" %></h2>
            <p class="page-subtitle">Distribua a quantidade total por lotes e validades.</p>
          </div>
          <a class="btn-secondary" style="text-decoration:none;" href="${pageContext.request.contextPath}/EncomendasServlet">Voltar</a>
        </div>

        <section class="card">
          <form id="formConfirmar" action="${pageContext.request.contextPath}/ConfirmarEncomendaFornecedorServlet" method="post" enctype="multipart/form-data">
            <input type="hidden" name="id_encomenda" value="<%= encomenda != null && encomenda.getIdMovimentos()!=null ? encomenda.getIdMovimentos().getIdMovimentos() : 0 %>">

            <div class="toolbar" style="gap: 20px;">
              <div class="search" style="max-width:200px;">
                <label>Custo Envio (€)</label>
                <input type="number" step="0.01" min="0" name="custo_envio" value="<%= encomenda != null ? encomenda.getCustoEnvio() : 0 %>" />
              </div>
              <div class="search" style="max-width:200px;">
                <label>Data Prevista Entrega</label>
                <input type="date" name="data_prevista" />
              </div>
            </div>

            <div class="table-wrap" style="margin-top:20px;">
              <table class="table">
                <thead>
                  <tr>
                    <th>Produto</th>
                    <th>Meta (Qtd)</th>
                    <th class="td-lotes">Lotes e Validades</th>
                    <th>Soma Atual</th>
                    <th>Ações</th>
                  </tr>
                </thead>
                <tbody>
                <% if (linhas != null && !linhas.isEmpty()) {
                    for (LinhaEnc l : linhas) { %>
                  <tr class="item-linha" data-meta="<%= l.getQuantidade() %>">
                    <td>
                        <strong><%= l.getProduto() != null ? l.getProduto().getNome() : "Desconhecido" %></strong>
                        <input type="hidden" name="linha_id" value="<%= l.getIdLinhaOrder() %>">
                    </td>
                    <td><%= l.getQuantidade() %></td>
                    <td class="area-lotes">
                      <div class="lote-item">
                        <span>Qtd:</span>
                        <input type="number" name="qtd_lote_<%= l.getIdLinhaOrder() %>" 
                               value="<%= l.getQuantidade() %>" step="1" min="1"
                               class="valor-lote" oninput="fazerSoma(this)" style="width:80px;">
                        <span>Val:</span>
                        <input type="date" name="validade_<%= l.getIdLinhaOrder() %>">
                      </div>
                    </td>
                    <td style="text-align:center;">
                      <span class="caixa-soma ok">--</span>
                    </td>
                    <td>
                      <button type="button" class="btn-add-lote" onclick="criarLote(this, <%= l.getIdLinhaOrder() %>)">+ Adicionar Lote</button>
                    </td>
                  </tr>
                <% } } else { %>
                  <tr><td colspan="5" style="text-align:center;">Nenhum produto encontrado nesta encomenda.</td></tr>
                <% } %>
                </tbody>
              </table>
            </div>

            <!-- Seção de Upload (Opcional) -->
            <div class="card-body" style="border-top: 1px solid #eee; margin-top: 20px;">
                <div class="upload-box" id="dropzone" style="margin-bottom: 20px;">
                    <div class="upload-icon">📄</div>
                    <div class="upload-text">Ou importe um ficheiro CSV para preenchimento automático</div>
                    <input type="file" name="csvFile" id="file-input" accept=".csv">
                    <div class="selected-file" id="fileNameDisplay" style="display:none;"></div>
                </div>
                <button type="submit" class="btn-submit" id="submitBtn">Confirmar Encomenda</button>
            </div>
          </form>
        </section>
      </section>
    </main>
  </div>

  <script>
    // Inicialização
    document.addEventListener('DOMContentLoaded', () => {
        document.querySelectorAll('.valor-lote').forEach(el => fazerSoma(el));
    });

    function fazerSoma(elemento) {
        const tr = elemento.closest('.item-linha');
        const meta = parseFloat(tr.getAttribute('data-meta'));
        let total = 0;

        tr.querySelectorAll('.valor-lote').forEach(input => {
            total += parseFloat(input.value || 0);
        });

        const display = tr.querySelector('.caixa-soma');
        display.innerText = total.toFixed(2) + " / " + meta.toFixed(2);

        // Validação visual (margem de erro para floats)
        if (Math.abs(total - meta) < 0.001) {
            display.className = "caixa-soma ok";
        } else {
            display.className = "caixa-soma erro";
        }
    }

    function criarLote(botao, idOriginal) {
        const container = botao.closest('.item-linha').querySelector('.area-lotes');
        const novoId = Date.now();
        
        const div = document.createElement('div');
        div.className = 'lote-item';
        div.innerHTML =
            '<span>Qtd:</span>' +
            '<input type="number" name="qtd_lote_' + idOriginal + '_extra_' + novoId + '" ' +
                   'class="valor-lote" step="1" min="1" required ' +
                   'oninput="fazerSoma(this)" style="width:80px;">' +
            '<span>Val:</span>' +
            '<input type="date" name="validade_' + idOriginal + '_extra_' + novoId + '" required>' +
            '<button type="button" class="btn-remove-lote" onclick="removerLote(this)">✕</button>';
        
        container.appendChild(div);
        const novoInputQtd = div.querySelector('.valor-lote');
        if (novoInputQtd) novoInputQtd.focus();
    }

    function removerLote(botao) {
        const tr = botao.closest('.item-linha');
        botao.parentElement.remove();
        // Recalcular após remover
        const primeiroInput = tr.querySelector('.valor-lote');
        if(primeiroInput) fazerSoma(primeiroInput);
    }

    // Validação Final antes de submeter
    document.getElementById('formConfirmar').addEventListener('submit', function(e) {
        const usouCsv = fileInput.files.length > 0;
        const erros = document.querySelectorAll('.caixa-soma.erro');
        if (erros.length > 0) {
            e.preventDefault();
            alert("Atenção: As quantidades totais dos lotes não correspondem à meta da encomenda!");
            return;
        }

        // Sem CSV, exigir validade manual em todos os lotes
        if (!usouCsv) {
            const inputsValidade = document.querySelectorAll("input[name^='validade_']");
            for (const input of inputsValidade) {
                if (!input.value || input.value.trim() === "") {
                    e.preventDefault();
                    alert("Preencha a validade de todos os lotes ou use o CSV.");
                    return;
                }
            }
        }
    });

    // Lógica do Upload de ficheiro
    const fileInput = document.getElementById('file-input');
    const fileNameDisplay = document.getElementById('fileNameDisplay');
    
    fileInput.addEventListener('change', (e) => {
        if(e.target.files.length > 0) {
            const fileName = e.target.files[0].name;
            fileNameDisplay.textContent = 'Ficheiro: ' + fileName;
            fileNameDisplay.style.display = 'block';
        }
    });
  </script>
</body>
</html>
