package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Produto;
import model.ProdutoDAO;

import java.io.IOException;
import java.util.List;

/**
 * Servlet implementation class ListarProdutoServlet
 */
@WebServlet("/ConsultarStockServlet")
public class ConsultarStockServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ConsultarStockServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	int currentPage = 1;
    	int pageSize = 5; // 20 produtos por página

    	try {
    		currentPage = Integer.parseInt(request.getParameter("page"));
    	} catch (Exception e) { }
    	
    	int offset = (currentPage - 1) * pageSize;

        ProdutoDAO dao = new ProdutoDAO();
        String nomePesquisa = request.getParameter("txtNome");
        String orderBy = request.getParameter("orderBy");
        String orderDir = request.getParameter("orderDir");

        List<Produto> produtos = dao.getProdutos(nomePesquisa, orderBy, orderDir, pageSize, offset);
        
        int totalProdutos = dao.getTotalProdutos(nomePesquisa); 

        int totalPages = (int) Math.ceil((double) totalProdutos / pageSize);
        
        request.setAttribute("produtos", produtos);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalProdutos", totalProdutos);
        request.setAttribute("totalPages", totalPages);

        //  Encaminhar para o JSP
        request.getRequestDispatcher("/Front-end/pages/consultarstock.jsp").forward(request, response);
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
