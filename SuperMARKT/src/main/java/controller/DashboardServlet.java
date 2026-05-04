package controller;

import java.io.IOException;
import java.util.Map;

import DAO.DashboardDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/DashboardServlet")
public class DashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        DashboardDAO dao = new DashboardDAO();

        int totalProdutos = dao.getTotalProdutos();
        int unidadesStock = dao.getTotalUnidadesStock();
        double valorTotalStock = dao.getValorTotalStock();
        int totalPerdas = dao.getTotalPerdas();
        
        // Define o limite como 10 para avisos críticos de baixo stock
        Map<String, Integer> baixoStock = dao.getProdutosBaixoStock(10);
        
        // Obter dados para o gráfico
        Map<String, Integer> distCategoria = dao.getDistribucaoStockPorCategoria();
        StringBuilder labelsCat = new StringBuilder();
        StringBuilder dataCat = new StringBuilder();
        
        for (Map.Entry<String, Integer> entry : distCategoria.entrySet()) {
            if (labelsCat.length() > 0) {
                labelsCat.append(",");
                dataCat.append(",");
            }
            labelsCat.append("'").append(entry.getKey().replace("'", "\\'")).append("'");
            dataCat.append(entry.getValue());
        }

        request.setAttribute("totalProdutos", totalProdutos);
        request.setAttribute("unidadesStock", unidadesStock);
        request.setAttribute("valorTotalStock", String.format("%.2f", valorTotalStock));
        request.setAttribute("totalPerdas", totalPerdas);
        request.setAttribute("baixoStock", baixoStock);
        
        // Passando strings preparadas para JS
        request.setAttribute("chartLabels", labelsCat.toString());
        request.setAttribute("chartData", dataCat.toString());

        request.getRequestDispatcher("/Front-end/dashboard.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
