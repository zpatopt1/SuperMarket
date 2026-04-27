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
        String orderBy = request.getParameter("orderBy");
        String orderDir = request.getParameter("orderDir");

        if (orderBy == null || orderBy.isBlank()) orderBy = "id_produto";
        if (orderDir == null || orderDir.isBlank()) orderDir = "ASC";

        Integer idProduto = parseInteger(produtoFiltro);
        Integer idLocal = parseInteger(localFiltro);

        List<StockLocal> stocks = dao.getStockFilteredOrdered(idProduto, idLocal, orderBy, orderDir);

        request.setAttribute("stocks", stocks);
        request.setAttribute("idProduto", produtoFiltro);
        request.setAttribute("idLocal", localFiltro);
        request.setAttribute("orderBy", orderBy);
        request.setAttribute("orderDir", orderDir);
        request.getRequestDispatcher("/Front-end/pages/consultarstocklocal.jsp").forward(request, response);
    }

    private Integer parseInteger(String value) {
        if (value == null || value.isBlank()) return null;
        try {
            return Integer.valueOf(value.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }
}
