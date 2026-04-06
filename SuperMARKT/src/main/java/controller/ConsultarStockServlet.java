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
        
        // Padrao caso nao tenha nada
        if (nomePesquisa == null) nomePesquisa = "";
        if (orderBy == null) orderBy = "id_produto";
        if (orderDir == null) orderDir = "ASC";
        
        List<Produto> produtos = dao.getProdutos(nomePesquisa, orderBy, orderDir, pageSize, offset);
        
        int totalProdutos = dao.getTotalProdutos(nomePesquisa); 

        int totalPages = (int) Math.ceil((double) totalProdutos / pageSize);
        
        request.setAttribute("produtos", produtos);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalProdutos", totalProdutos);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("txtNome", nomePesquisa);
        request.setAttribute("orderBy", orderBy);
        request.setAttribute("orderDir", orderDir);
        
 
        //  Encaminhar para o JSP
        request.getRequestDispatcher("/Front-end/pages/consultarstock.jsp").forward(request, response);
    }
    

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        String action = request.getParameter("action");
        ProdutoDAO dao = new ProdutoDAO();

        try {
            String page = request.getParameter("page");
            String txtNome = request.getParameter("txtNome");
            String orderBy = request.getParameter("orderBy");
            String orderDir = request.getParameter("orderDir");
            // evitar null
            if (page == null) page = "1";
            if (txtNome == null) txtNome = "";
            if (orderBy == null) orderBy = "id_produto";
            if (orderDir == null) orderDir = "ASC";
            
            if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("delete_id_produto"));
                Produto p = dao.selectProduto(id);
                dao.deleteProduto(id);
                response.sendRedirect("ConsultarStockServlet?page=" + page +
                			"&txtNome=" + txtNome +
                            "&orderBy=" + orderBy +
                            "&orderDir=" + orderDir);
         
            } else if ("update".equals(action)) {

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

                // 3. Atualizar no banco
                if (dao.selectProduto(id) != null) {
                    dao.updateProduto(p);
                    request.setAttribute("msg", "Produto atualizado com sucesso");
                } else {
                    request.setAttribute("msg", "Produto nao encontrado para atualizacao");
                }

                response.sendRedirect("ConsultarStockServlet?page=" + page +
                        "&txtNome=" + txtNome +
                        "&orderBy=" + orderBy +
                        "&orderDir=" + orderDir);
            }
               
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("msg", "Erro");
            request.getRequestDispatcher("/Front-end/pages/consultarstock.jsp")
                   .forward(request, response);
        }
    }
}