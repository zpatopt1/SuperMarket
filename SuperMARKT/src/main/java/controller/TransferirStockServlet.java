package controller;

import java.io.IOException;

import DAO.StockLocalDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/TransferirStockServlet")
public class TransferirStockServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/Front-end/pages/transferir_stock.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int idProduto = Integer.parseInt(request.getParameter("idProduto"));
            int idOrigem = Integer.parseInt(request.getParameter("idOrigem"));
            int idDestino = Integer.parseInt(request.getParameter("idDestino"));
            int quantidade = Integer.parseInt(request.getParameter("quantidade"));

            StockLocalDAO dao = new StockLocalDAO();
            dao.transferirStock(idProduto, idOrigem, idDestino, quantidade);

            request.setAttribute("sucesso", "A quantidade (" + quantidade + ") foi transferida com sucesso da origem para o destino!");
        } catch (NumberFormatException e) {
            request.setAttribute("erro", "Por favor, preenche todos os campos com valores numéricos válidos.");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("erro", "Falha na transferência: " + e.getMessage());
        }

        doGet(request, response);
    }
}
