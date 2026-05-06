package controller;

import java.io.IOException;
import java.util.List;

import DAO.StockLocalDAO;
import DAO.ZonaDAO;
import model.StockLocal;
import model.Zona;
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
        int currentPage = 1;
        int pageSize = 5;

        try {
            currentPage = Integer.parseInt(request.getParameter("page"));
        } catch (Exception e) {
            // default page
        }
        int offset = (currentPage - 1) * pageSize;

        String produtoFiltro = request.getParameter("idProduto");
        String localFiltro = request.getParameter("idLocal");
        String orderBy = request.getParameter("orderBy");
        String orderDir = request.getParameter("orderDir");

        if (orderBy == null || orderBy.isBlank()) orderBy = "id_produto";
        if (orderDir == null || orderDir.isBlank()) orderDir = "ASC";

        Integer idProduto = parseInteger(produtoFiltro);
        Integer idLocal = parseInteger(localFiltro);

        List<StockLocal> stocks = dao.getStockFilteredOrdered(idProduto, idLocal, orderBy, orderDir, pageSize, offset);
        int totalStocks = dao.getTotalStockFiltered(idProduto, idLocal);
        int totalPages = (int) Math.ceil((double) totalStocks / pageSize);
        ZonaDAO zonaDAO = new ZonaDAO();
        List<Zona> todasZonas = zonaDAO.getAllZonas();

        for (StockLocal s : stocks) {
            if (s.getProduto() != null && s.getLocal() != null) {
                int p = s.getProduto().getIdProduto();
                int l = s.getLocal().getIdLocal();
                List<Zona> zonas = dao.getZonasByProdutoLocal(p, l);
                s.setZonas(zonas);
            }
        }

        request.setAttribute("stocks", stocks);
        request.setAttribute("todasZonas", todasZonas);
        request.setAttribute("idProduto", produtoFiltro);
        request.setAttribute("idLocal", localFiltro);
        request.setAttribute("orderBy", orderBy);
        request.setAttribute("orderDir", orderDir);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.getRequestDispatcher("/Front-end/pages/consultarstocklocal.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        StockLocalDAO dao = new StockLocalDAO();
        try {
            int idProduto = Integer.parseInt(request.getParameter("idProduto"));
            int idLocal = Integer.parseInt(request.getParameter("idLocal"));
            int idZona = Integer.parseInt(request.getParameter("idZona"));

            if ("addZona".equals(action)) {
                dao.addZonaProdutoLocal(idProduto, idLocal, idZona);
            } else if ("removeZona".equals(action)) {
                dao.removeZonaProdutoLocal(idProduto, idLocal, idZona);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        String idProdutoFiltro = request.getParameter("filterIdProduto");
        String idLocalFiltro = request.getParameter("filterIdLocal");
        String orderBy = request.getParameter("filterOrderBy");
        String orderDir = request.getParameter("filterOrderDir");
        String page = request.getParameter("filterPage");
        if (idProdutoFiltro == null) idProdutoFiltro = "";
        if (idLocalFiltro == null) idLocalFiltro = "";
        if (orderBy == null || orderBy.isBlank()) orderBy = "id_produto";
        if (orderDir == null || orderDir.isBlank()) orderDir = "ASC";
        if (page == null || page.isBlank()) page = "1";

        response.sendRedirect(request.getContextPath() + "/ConsultarStockLocalServlet?idProduto=" + idProdutoFiltro +
                "&idLocal=" + idLocalFiltro +
                "&orderBy=" + orderBy +
                "&orderDir=" + orderDir +
                "&page=" + page);
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
