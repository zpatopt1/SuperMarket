package controller;

import java.io.IOException;
import java.util.List;

import DAO.StockLocalDAO;
import model.StockLocal;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class ConsultarStockLocalServlet
 */
@WebServlet("/ConsultarStockLocalServlet")
public class ConsultarStockLocalServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public ConsultarStockLocalServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        StockLocalDAO dao = new StockLocalDAO();
        String produtoFiltro = request.getParameter("idProduto");
        String localFiltro = request.getParameter("idLocal");
        List<StockLocal> stocks;

        if (produtoFiltro != null && !produtoFiltro.isEmpty()) {
            stocks = dao.getStockByProduto(Integer.parseInt(produtoFiltro));
        } else if (localFiltro != null && !localFiltro.isEmpty()) {
            stocks = dao.getStockByLocal(Integer.parseInt(localFiltro));
        } else {
            stocks = dao.getAllStock();
        }

        request.setAttribute("stocks", stocks);
        request.setAttribute("idProduto", produtoFiltro);
        request.setAttribute("idLocal", localFiltro);
        request.getRequestDispatcher("/Front-end/pages/consultarstocklocal.jsp").forward(request, response);
    }
}
