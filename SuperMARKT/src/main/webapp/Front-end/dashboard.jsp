<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map" %>
<!doctype html>
<html lang="pt-PT">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <title>SuperMart - Dashboard Premium</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/Front-end/styles/styles.css" />
  <!-- Chart.js -->
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

  <style>
    /* Estilos Premium Injetados */
    .content {
      background-color: #f8fafc;
      font-family: 'Inter', sans-serif;
    }
    
    .kpi {
      background: linear-gradient(135deg, #ffffff 0%, #f8fafc 100%);
      border: none;
      border-radius: 20px;
      box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.05), 0 8px 10px -6px rgba(0, 0, 0, 0.01);
      padding: 24px;
      transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1), box-shadow 0.3s cubic-bezier(0.4, 0, 0.2, 1);
      position: relative;
      overflow: hidden;
    }
    
    .kpi:hover {
      transform: translateY(-5px);
      box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
    }
    
    .kpi::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 4px;
      background: linear-gradient(90deg, #3b82f6, #8b5cf6);
    }

    .kpi-label {
      font-size: 0.875rem;
      color: #64748b;
      font-weight: 600;
      text-transform: uppercase;
      letter-spacing: 0.05em;
      margin-bottom: 8px;
    }

    .kpi-value {
      font-weight: 900;
      font-size: 2.25rem;
      color: #0f172a;
      display: flex;
      align-items: baseline;
      gap: 8px;
    }

    .kpi-value span {
      font-size: 1rem;
      color: #94a3b8;
      font-weight: 600;
    }
    
    /* Highlight do Valor Financeiro */
    .kpi.highlight::before {
      background: linear-gradient(90deg, #10b981, #34d399);
    }
    .kpi.highlight .kpi-value {
      color: #059669;
    }

    .card {
      background: #ffffff;
      border: none;
      border-radius: 20px;
      box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05), 0 2px 4px -1px rgba(0, 0, 0, 0.03);
      padding: 24px;
    }

    .card-head h2 {
      font-size: 1.25rem;
      color: #1e293b;
      font-weight: 800;
      margin-bottom: 20px;
      display: flex;
      align-items: center;
      gap: 10px;
    }
    
    .badge-status {
      padding: 4px 12px;
      border-radius: 9999px;
      font-size: 0.75rem;
      font-weight: 700;
      letter-spacing: 0.025em;
      text-transform: uppercase;
    }
    
    .badge-critical {
      background-color: #fef2f2;
      color: #dc2626;
      border: 1px solid #f87171;
    }
    
    .badge-warning {
      background-color: #fffbeb;
      color: #d97706;
      border: 1px solid #fbbf24;
    }
    
    .table-premium {
      width: 100%;
      border-collapse: separate;
      border-spacing: 0;
    }
    
    .table-premium th {
      text-align: left;
      padding: 12px 16px;
      font-size: 0.75rem;
      font-weight: 600;
      color: #64748b;
      text-transform: uppercase;
      letter-spacing: 0.05em;
      border-bottom: 2px solid #e2e8f0;
    }
    
    .table-premium td {
      padding: 16px;
      font-size: 0.875rem;
      color: #334155;
      font-weight: 600;
      border-bottom: 1px solid #f1f5f9;
      transition: background-color 0.2s;
    }
    
    .table-premium tr:hover td {
      background-color: #f8fafc;
    }
    
    .table-premium tr:last-child td {
      border-bottom: none;
    }
    
    .chart-container {
      position: relative;
      height: 300px;
      width: 100%;
      display: flex;
      justify-content: center;
      align-items: center;
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
        
        <!-- Banner da Loja -->
        <div style="margin-bottom: 24px; position: relative; border-radius: 20px; overflow: hidden; box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.1);">
            <img src="${pageContext.request.contextPath}/Front-end/assets/loja.png" alt="Interior do Supermercado" style="width: 100%; height: 160px; object-fit: cover; display: block;" />
            <div style="position: absolute; top: 0; left: 0; width: 100%; height: 100%; background: linear-gradient(to right, rgba(15, 23, 42, 0.85) 0%, rgba(15, 23, 42, 0.1) 100%); display: flex; flex-direction: column; justify-content: center; padding: 0 30px;">
                <h1 style="font-size: 2rem; font-weight: 900; color: #ffffff; margin: 0; letter-spacing: -0.02em; text-shadow: 0 2px 4px rgba(0,0,0,0.3);">Resumo Geral</h1>
                <p style="color: #e2e8f0; margin-top: 6px; font-size: 1rem; font-weight: 500; text-shadow: 0 1px 2px rgba(0,0,0,0.3);">Visão panorâmica e valorizada do teu armazém.</p>
            </div>
        </div>

        <!-- KPIs Premium -->
        <div class="kpis">
          <div class="kpi">
            <div class="kpi-label">Produtos Registados</div>
            <div class="kpi-value">${totalProdutos}</div>
          </div>

          <div class="kpi">
            <div class="kpi-label">Volume Físico (Stock)</div>
            <div class="kpi-value">${unidadesStock} <span>unid.</span></div>
          </div>

          <div class="kpi highlight">
            <div class="kpi-label">Valor do Inventário</div>
            <div class="kpi-value">${valorTotalStock} <span>€</span></div>
          </div>


        </div>

        <div class="grid grid-top" style="margin-top: 24px;">
          
          <!-- Gráfico Interativo -->
          <section class="card">
            <div class="card-head simple">
              <h2>Distribuição por Categoria</h2>
            </div>
            <div class="chart-container">
              <canvas id="categoriaChart"></canvas>
            </div>
          </section>

          <!-- Alertas de Baixo Stock Modernizados -->
          <section class="card">
            <div class="card-head simple">
              <h2>Ação Necessária (Rutura Iminente)</h2>
            </div>
            <div class="card-body" style="padding: 0; overflow-y: auto; max-height: 300px;">
              <table class="table-premium">
                <thead>
                  <tr>
                    <th>Produto</th>
                    <th>Qtd</th>
                    <th>Estado</th>
                  </tr>
                </thead>
                <tbody>
                  <% 
                    Map<String, Integer> baixoStockMap = (Map<String, Integer>) request.getAttribute("baixoStock");
                    if (baixoStockMap != null && !baixoStockMap.isEmpty()) {
                        for (Map.Entry<String, Integer> entry : baixoStockMap.entrySet()) {
                            int qtd = entry.getValue();
                            String badgeClass = qtd <= 5 ? "badge-critical" : "badge-warning";
                            String badgeText = qtd <= 5 ? "Crítico" : "Baixo";
                  %>
                        <tr>
                          <td><%= entry.getKey() %></td>
                          <td style="font-weight: 800;"><%= qtd %></td>
                          <td><span class="badge-status <%= badgeClass %>"><%= badgeText %></span></td>
                        </tr>
                  <% 
                        }
                    } else {
                  %>
                      <tr>
                        <td colspan="3" style="text-align: center; color: #94a3b8; padding: 30px;">Stock perfeitamente controlado! 🚀</td>
                      </tr>
                  <% 
                    }
                  %>
                </tbody>
              </table>
            </div>
          </section>
        </div>
      </section>
    </main>
  </div>
  
  <script type="module" src="${pageContext.request.contextPath}/Front-end/js/pages/dashboard.js"></script>
  
  <!-- Inicialização do Gráfico -->
  <script>
    document.addEventListener('DOMContentLoaded', function() {
        const ctx = document.getElementById('categoriaChart').getContext('2d');
        
        // Dados injetados pelo Servlet
        const rawLabels = "${chartLabels}";
        const rawData = "${chartData}";
        
        const labels = rawLabels ? rawLabels.replace(/'/g, "").split(',') : [];
        const data = rawData ? rawData.split(',') : [];
        
        // Paleta de cores vibrantes
        const backgroundColors = [
            'rgba(59, 130, 246, 0.85)', // Blue
            'rgba(139, 92, 246, 0.85)', // Violet
            'rgba(16, 185, 129, 0.85)', // Emerald
            'rgba(245, 158, 11, 0.85)', // Amber
            'rgba(239, 68, 68, 0.85)',  // Red
            'rgba(14, 165, 233, 0.85)'  // Sky
        ];

        new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: labels,
                datasets: [{
                    data: data,
                    backgroundColor: backgroundColors,
                    borderWidth: 0,
                    hoverOffset: 10
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                cutout: '70%',
                plugins: {
                    legend: {
                        position: 'right',
                        labels: {
                            font: {
                                family: "'Inter', sans-serif",
                                size: 12,
                                weight: '600'
                            },
                            color: '#475569',
                            padding: 20,
                            usePointStyle: true,
                            pointStyle: 'circle'
                        }
                    },
                    tooltip: {
                        backgroundColor: 'rgba(15, 23, 42, 0.9)',
                        titleFont: { size: 13, family: "'Inter', sans-serif" },
                        bodyFont: { size: 14, weight: 'bold', family: "'Inter', sans-serif" },
                        padding: 12,
                        cornerRadius: 8,
                        displayColors: false
                    }
                }
            }
        });
    });
  </script>
</body>
</html>
