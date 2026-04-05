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
import java.net.URLEncoder;
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
    	request.getRequestDispatcher("/Front-end/pages/registar_produto.jsp")
        .forward(request, response);    
    	}
    
    
	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	    String action = request.getParameter("action");

        ProdutoDAO dao = new ProdutoDAO();
       

		try {
			//mostrar dados no form
			if ("updateForm".equals(action)) {
			    int id = Integer.parseInt(request.getParameter("update_id_produto"));

			    Produto p = dao.selectProduto(id);
			    //boolean deleted = dao.deleteProduto(id); // retorna true se deletou
	            //if (deleted) {

			    if (p != null) {
	                request.setAttribute("produto", p);
	                request.getRequestDispatcher("/Front-end/pages/registar_produto.jsp").forward(request, response);
	            } else {
	                request.setAttribute("msg", "Produto nao encontrado");
	                request.getRequestDispatcher("/Front-end/pages/registar_produto.jsp").forward(request, response);
	            }
			    return;
			}
			else if ("delete".equals(action)) {				
				 int id = Integer.parseInt(request.getParameter("delete_id_produto"));
				 Produto p = dao.selectProduto(id);
				 if (p != null) {
				    dao.deleteProduto(id);
				    request.setAttribute("msg", "Produto apagado com sucesso");
				    request.getRequestDispatcher("/Front-end/pages/registar_produto.jsp").forward(request, response);
				} else {
				    request.setAttribute("msg", "Produto nao encontrado");
				    request.getRequestDispatcher("/Front-end/pages/registar_produto.jsp").forward(request, response);
				}
		    } else if ("update".equals(action) || "insert".equals(action)) {
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
//	            boolean updated = dao.updateProduto(p); // retorna true se atualizou
//	            if (updated) {
	            if ("update".equals(action)) {
	            	if (dao.selectProduto(id) != null) {
	            	    dao.updateProduto(p);
	            	    request.setAttribute("msg", "Produto atualizado com sucesso");
	            	    request.getRequestDispatcher("/Front-end/pages/registar_produto.jsp").forward(request, response);
	            	} else {
	            	    request.setAttribute("msg", "Produto nao encontrado para atualizacao");
	            	    request.getRequestDispatcher("/Front-end/pages/registar_produto.jsp").forward(request, response);
	            	}
	            }else {
	                dao.insert(p);
            	    request.setAttribute("msg", "Produto inserido com sucesso");
            	    request.getRequestDispatcher("/Front-end/pages/registar_produto.jsp").forward(request, response);	            }
	        }


        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("msg", "Erro");
            request.getRequestDispatcher("/Front-end/pages/registar_produto.jsp").forward(request, response);       
            }
    }
}
