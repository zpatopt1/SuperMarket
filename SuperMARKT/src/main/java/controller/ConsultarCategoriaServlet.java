package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Categoria;
import DAO.CategoriaDAO;

import java.io.IOException;
import java.util.List;

/**
 * Servlet implementation class ConsultarCategoriaServlet
 */
@WebServlet("/ConsultarCategoriaServlet")
public class ConsultarCategoriaServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ConsultarCategoriaServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        CategoriaDAO dao = new CategoriaDAO();
        List<Categoria> categorias = dao.getAllCategorias();
        
        int totalCategorias = dao.getTotalCategorias();
        String categoriaMaisProdutos = dao.getCategoriaMaisProdutos();
        int categoriasVazias = dao.getCategoriasVazias();
        String categoriaMaiorValor = dao.getCategoriaMaiorValor();
        
        request.setAttribute("categorias", categorias);
        request.setAttribute("totalCategorias", totalCategorias);
        request.setAttribute("categoriaMaisProdutos", categoriaMaisProdutos);
        request.setAttribute("categoriasVazias", categoriasVazias);
        request.setAttribute("categoriaMaiorValor", categoriaMaiorValor);
        request.getRequestDispatcher("/Front-end/pages/consultarcategorias.jsp").forward(request, response);
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        CategoriaDAO dao = new CategoriaDAO();

        try {
            if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("delete_id_categoria"));
                dao.deleteCategoria(id);
                response.sendRedirect("ConsultarCategoriaServlet");

            } else if ("insert".equals(action)) {
                String nome = request.getParameter("nome_categoria");
                String descricao = request.getParameter("descricao_categoria");
                if (nome != null && !nome.trim().isEmpty()) {
                    Categoria c = new Categoria();
                    c.setNome(nome.trim());
                    c.setDescricao(descricao != null ? descricao.trim() : "");
                    dao.insertCategoria(c);
                }
                response.sendRedirect("ConsultarCategoriaServlet");

            } else if ("update".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id_categoria"));
                String nome = request.getParameter("nome");
                String descricao = request.getParameter("descricao");

                Categoria c = new Categoria();
                c.setIdCategoria(id);
                c.setNome(nome);
                c.setDescricao(descricao);

                dao.updateCategoria(c);
                response.sendRedirect("ConsultarCategoriaServlet");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("msg", "Erro ao processar a ação");
            doGet(request, response);
        }
    }

}
