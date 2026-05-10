package controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import DAO.EncomendaDAO;
import DAO.FornecedorProdutoDAO;
import DAO.LocalDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Encomenda;
import model.Fornecedor;
import model.FornecedorProduto;
import model.Funcionario;
import model.LinhaEnc;
import model.Local;
import model.Movimentos;
import model.Produto;

@WebServlet("/ConsultarFornecedorProdutosServlet")
public class ConsultarFornecedorProdutosServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        FornecedorProdutoDAO dao = new FornecedorProdutoDAO();
        LocalDAO daolocal = new LocalDAO();
        List<Local> locais = daolocal.getAllLocais();
        List<FornecedorProduto> lista = dao.getAll();
        List<Fornecedor> fornecedores = dao.getAllFornecedores();
        List<Produto> produtos = dao.getAllProdutos();
        request.setAttribute("fornecedorProdutos", lista);
        request.setAttribute("fornecedores", fornecedores);
        request.setAttribute("produtos", produtos);
        request.setAttribute("locais", locais);
        request.getRequestDispatcher("/Front-end/pages/fornecedor_produtos.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        FornecedorProdutoDAO dao = new FornecedorProdutoDAO();
        EncomendaDAO daoEnc = new EncomendaDAO();
        try {
            if ("insert".equals(action)) {
                int idFornecedor = Integer.parseInt(request.getParameter("id_fornecedor"));
                int idProduto = Integer.parseInt(request.getParameter("id_produto"));
                float preco = Float.parseFloat(request.getParameter("preco"));
                
                Fornecedor fornecedor = new Fornecedor();
                fornecedor.setIdFornecedor(idFornecedor);
                
                Produto produto = new Produto();
                produto.setIdProduto(idProduto);
                
                FornecedorProduto fornecedorProduto = new FornecedorProduto(fornecedor, produto, preco);
                dao.insert(fornecedorProduto);
            } else if ("update".equals(action)) {
                int idFornecedor = Integer.parseInt(request.getParameter("id_fornecedor"));
                int idProduto = Integer.parseInt(request.getParameter("id_produto"));
                float preco = Float.parseFloat(request.getParameter("preco"));
                
                Fornecedor fornecedor = new Fornecedor();
                fornecedor.setIdFornecedor(idFornecedor);
                
                Produto produto = new Produto();
                produto.setIdProduto(idProduto);
                
                FornecedorProduto fornecedorProduto = new FornecedorProduto(fornecedor, produto, preco);
                dao.update(fornecedorProduto);
            } else if ("delete".equals(action)) {
                int idFornecedor = Integer.parseInt(request.getParameter("id_fornecedor"));
                int idProduto = Integer.parseInt(request.getParameter("id_produto"));
                dao.delete(idFornecedor, idProduto);
            } else if ("encomendar".equals(action)) {
            // 1. Capturar IDs dos produtos selecionados
            String[] idsSelecionados = request.getParameterValues("selected_produtos");
            
            if (idsSelecionados != null && idsSelecionados.length > 0) {
                List<LinhaEnc> linhas = new ArrayList<>();
                
                for (String idStr : idsSelecionados) {
                    int idProd = Integer.parseInt(idStr);
                    int qtd = Integer.parseInt(request.getParameter("qtd_" + idProd));
                    float preco = Float.parseFloat(request.getParameter("preco_" + idProd));

                    LinhaEnc linha = new LinhaEnc();
                    Produto p = new Produto();
                    p.setIdProduto(idProd);
                    linha.setProduto(p);
                    linha.setQuantidade(qtd);
                    linha.setPrecoEncomenda(preco * qtd);
                    linhas.add(linha);
                }

                // 2. Criar objeto Movimento
                Movimentos mov = new Movimentos();
                // Assume que guardaste o funcionário na sessão no Login
                Funcionario func = (Funcionario) request.getSession().getAttribute("utilizadorLogado"); 
                mov.setFuncionario(func);
                mov.setStatus("Pendente");

                // 3. Criar objeto Encomenda
                Encomenda enc = new Encomenda();
                Fornecedor forn = new Fornecedor();
                // O ID do fornecedor deve vir de um campo hidden ou do primeiro item
                forn.setIdFornecedor(Integer.parseInt(request.getParameter("id_fornecedor_comum")));
                enc.setIdFornecedor(forn);
                
                Local local = new Local();
                local.setIdLocal(Integer.parseInt(request.getParameter("id_local"))); 
                enc.setIdLocal(local);

                // 4. Executar a transação
                boolean sucesso = daoEnc.finalizarEncomendaCompleta(mov, enc, linhas);

                if (sucesso) {
                    request.setAttribute("mensagem", "Encomenda efetuada com sucesso!");
                } else {
                    request.setAttribute("erro", "Erro ao processar a encomenda na base de dados.");
                }
            } else {
                request.setAttribute("erro", "Nenhum produto selecionado.");
            }
        }
        
        // Após qualquer ação, recarrega a página de consulta
        doGet(request, response);

    } catch (Exception e) {
        e.printStackTrace();
        request.setAttribute("erro", "Erro técnico: " + e.getMessage());
        doGet(request, response);
    }
}
}