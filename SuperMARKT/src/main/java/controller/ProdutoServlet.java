package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Categoria;
import model.Produto;
import model.ProdutoDAO;

import java.io.IOException;
import java.util.List;

/**
 * Servlet implementation class ProdutoServlet
 */
@WebServlet("/ProdutoServlet")
public class ProdutoServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ProdutoServlet() {
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
		try {
            // 1. Capturar os dados do formulário
            int id = Integer.parseInt(request.getParameter("id_produto"));
            int idCat = Integer.parseInt(request.getParameter("id_categoria"));
            String nome = request.getParameter("nome");
            String marca = request.getParameter("marca");
            String unidade = request.getParameter("unidade");
            String codBarras = request.getParameter("cod_barras");
            float preco = Float.parseFloat(request.getParameter("preco"));

            // 2. Criar os objetos (Model)
            Categoria cat = new Categoria();
            cat.setIdCategoria(idCat);

            Produto p = new Produto();
            p.setIdProduto(id);
            p.setCategoria(cat);
            p.setNome(nome);
            p.setMarca(marca);
            p.setUnidadeMedida(unidade);
            p.setCodBarras(codBarras);
            p.setPreco(preco);

            // 3. Chamar o DAO para salvar
            ProdutoDAO dao = new ProdutoDAO();
            dao.insert(p); 

            // 4. Redirecionar de volta ou para uma página de sucesso
            response.sendRedirect("/SuperMARKT/Front-end/dashboard.jsp?msg=sucesso");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("/SuperMARKT/Front-end/pages/registar_produto.jsp?msg=erro");
        }
    }
}
