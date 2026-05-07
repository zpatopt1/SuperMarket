package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Local;

import java.io.IOException;
import java.util.List;

import DAO.LocalDAO;

/**
 * Servlet implementation class ConsultarLocalServlet
 */
@WebServlet("/ConsultarLocalServlet")
public class ConsultarLocalServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public ConsultarLocalServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        LocalDAO dao = new LocalDAO();
        List<Local> locais = dao.getAllLocais();
        request.setAttribute("locais", locais);
        request.getRequestDispatcher("/Front-end/pages/consultarlocal.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        LocalDAO dao = new LocalDAO();

        try {
            if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("delete_id_local"));
                dao.deleteLocal(id);
                response.sendRedirect("GestaoEspacosServlet");

            } else if ("insert".equals(action)) {
                String nome = request.getParameter("nome_local");
                String tipo = request.getParameter("tipo_local");
                if (nome != null && !nome.trim().isEmpty()) {
                    Local local = new Local();
                    local.setNome(nome.trim());
                    local.setTipoLocal(tipo != null ? tipo.trim() : "");
                    dao.insertLocal(local);
                }
                response.sendRedirect("GestaoEspacosServlet");

            } else if ("update".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id_local"));
                String nome = request.getParameter("nome");
                String tipo = request.getParameter("tipo_local");

                Local local = new Local();
                local.setIdLocal(id);
                local.setNome(nome);
                local.setTipoLocal(tipo);

                dao.updateLocal(local);
                response.sendRedirect("GestaoEspacosServlet");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("msg", "Erro ao processar a ação");
            doGet(request, response);
        }
    }
}
