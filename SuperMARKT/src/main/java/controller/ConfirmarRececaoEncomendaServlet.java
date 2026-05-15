package controller;

import java.io.IOException;
import java.util.List;

import DAO.EncomendaDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Encomenda;
import model.LinhaEnc;

@WebServlet("/ConfirmarRececaoEncomendaServlet")
public class ConfirmarRececaoEncomendaServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/EncomendasServlet");
            return;
        }

        int idEncomenda;
        try {
            idEncomenda = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/EncomendasServlet");
            return;
        }

        EncomendaDAO dao = new EncomendaDAO();
        Encomenda encomenda = dao.getEncomendaById(idEncomenda);
        List<LinhaEnc> linhas = dao.getLinhasEncomenda(idEncomenda);
        if (encomenda == null) {
            response.sendRedirect(request.getContextPath() + "/EncomendasServlet");
            return;
        }

        request.setAttribute("encomenda", encomenda);
        request.setAttribute("linhas", linhas);
        request.getRequestDispatcher("/Front-end/pages/confirmar_rececao_encomenda.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id_encomenda");
        if (idParam == null || idParam.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/EncomendasServlet");
            return;
        }

        int idEncomenda;
        try {
            idEncomenda = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/EncomendasServlet");
            return;
        }

        EncomendaDAO dao = new EncomendaDAO();
        boolean ok = dao.confirmarRececaoEncomenda(idEncomenda);

        if (ok) {
            request.getSession().setAttribute("mensagemSucesso", "Rececao da encomenda confirmada e stock atualizado.");
        } else {
            request.getSession().setAttribute("mensagemErro", "Erro ao confirmar rececao da encomenda.");
        }
        response.sendRedirect(request.getContextPath() + "/EncomendasServlet");
    }
}
