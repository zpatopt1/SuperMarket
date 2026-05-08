package controller;

import java.io.IOException;
import java.util.List;

import DAO.FornecedorProdutoDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Fornecedor;
import model.FornecedorProduto;
import model.Produto;

@WebServlet("/ConsultarFornecedorProdutosServlet")
public class ConsultarFornecedorProdutosServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        FornecedorProdutoDAO dao = new FornecedorProdutoDAO();
        List<FornecedorProduto> lista = dao.getAll();
        List<Fornecedor> fornecedores = dao.getAllFornecedores();
        List<Produto> produtos = dao.getAllProdutos();

        request.setAttribute("fornecedorProdutos", lista);
        request.setAttribute("fornecedores", fornecedores);
        request.setAttribute("produtos", produtos);
        request.getRequestDispatcher("/Front-end/pages/fornecedor_produtos.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        FornecedorProdutoDAO dao = new FornecedorProdutoDAO();
        try {
            if ("insert".equals(action)) {
                int idFornecedor = Integer.parseInt(request.getParameter("id_fornecedor"));
                int idProduto = Integer.parseInt(request.getParameter("id_produto"));
                float preco = Float.parseFloat(request.getParameter("preco"));
                dao.insert(idFornecedor, idProduto, preco);
            } else if ("update".equals(action)) {
                int idFornecedor = Integer.parseInt(request.getParameter("id_fornecedor"));
                int idProduto = Integer.parseInt(request.getParameter("id_produto"));
                float preco = Float.parseFloat(request.getParameter("preco"));
                dao.update(idFornecedor, idProduto, preco);
            } else if ("delete".equals(action)) {
                int idFornecedor = Integer.parseInt(request.getParameter("id_fornecedor"));
                int idProduto = Integer.parseInt(request.getParameter("id_produto"));
                dao.delete(idFornecedor, idProduto);
            }
            else if ("createEncomenda".equals(action)) {
                String nif = (String) request.getSession().getAttribute("nif");
                int idFornecedor = Integer.parseInt(request.getParameter("id_fornecedor"));
                int idLocal = Integer.parseInt(request.getParameter("id_local"));
                String[] produtos = request.getParameterValues("id_produto");
                String[] quantidades = request.getParameterValues("qty_produtos");

                dao.createEncomendaCompleta(nif, idFornecedor, idLocal, produtos, quantidades);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("ConsultarFornecedorProdutosServlet");
    }
}
