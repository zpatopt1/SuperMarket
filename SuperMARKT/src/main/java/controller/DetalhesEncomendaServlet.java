package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

import DAO.EncomendaDAO;

/**
 * Servlet implementation class DetalhesEncomendaServlet
 */
@WebServlet("/DetalhesEncomendaServlet")
public class DetalhesEncomendaServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public DetalhesEncomendaServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    
        int id = Integer.parseInt(request.getParameter("id"));

        EncomendaDAO dao = new EncomendaDAO();

        request.setAttribute("linhas", dao.getLinhasEncomenda(id));
        request.setAttribute("encomenda", dao.getEncomendaById(id));

        request.getRequestDispatcher(
            "/Front-end/pages/linhas_encomenda.jsp"
        ).forward(request, response);
    }
	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int idEncomenda = Integer.parseInt(request.getParameter("id_encomenda"));
            int idLinha = Integer.parseInt(request.getParameter("id_linhaenc"));
            int quantidade = Integer.parseInt(request.getParameter("quantidade"));

            EncomendaDAO dao = new EncomendaDAO();
            boolean ok = dao.atualizarQuantidadeLinhaEncomenda(idEncomenda, idLinha, quantidade);
            if (ok) {
                request.getSession().setAttribute("mensagemSucesso", "Quantidade atualizada.");
            } else {
                request.getSession().setAttribute("mensagemErro", "Nao foi possivel atualizar a quantidade.");
            }
            response.sendRedirect(request.getContextPath() + "/DetalhesEncomendaServlet?id=" + idEncomenda);
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/EncomendasServlet");
        }
	}

}
