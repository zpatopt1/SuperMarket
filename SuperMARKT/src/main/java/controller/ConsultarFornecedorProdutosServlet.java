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
        String idFornFilter = request.getParameter("id_fornecedor");
        String idEnc = request.getParameter("id_encomenda");
        
        LocalDAO daolocal = new LocalDAO();
        List<Local> locais = daolocal.getAllLocais();
        List<FornecedorProduto> lista = dao.getAll();
        List<Fornecedor> fornecedores = dao.getAllFornecedores();
        List<Produto> produtos = dao.getAllProdutos();
        request.setAttribute("fornecedorProdutos", lista);
        request.setAttribute("fornecedores", fornecedores);
        request.setAttribute("produtos", produtos);
        request.setAttribute("locais", locais);
        request.setAttribute("idFornFilter", idFornFilter);
        request.setAttribute("idEncExistente", idEnc);
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
                    linha.setPrecoEncomenda(preco);
                    linhas.add(linha);
                }

                String idEncExistenteStr = request.getParameter("id_encomenda_existente");
                boolean sucesso;

                if (idEncExistenteStr != null && !idEncExistenteStr.isEmpty() && !idEncExistenteStr.equals("0")) {
                    // MODO EDIÇÃO: Adicionar itens a uma encomenda que já existe
                    int idEncExistente = Integer.parseInt(idEncExistenteStr);
                    sucesso = daoEnc.adicionarLinhasAEncomendaExistente(idEncExistente, linhas);
                    
                    if (sucesso) {
                        // Redireciona de volta para os detalhes da encomenda para visualizar os novos itens
                        response.sendRedirect(request.getContextPath() + "/DetalhesEncomendaServlet?id=" + idEncExistente);
                        return;
                    }
                } else {
                    // MODO CRIAÇÃO: Lógica original para criar nova encomenda e movimento
                    Movimentos mov = new Movimentos();
                    Funcionario func = (Funcionario) request.getSession().getAttribute("utilizadorLogado"); 
                    mov.setFuncionario(func);
                    mov.setStatus("Pendente");

                    Encomenda enc = new Encomenda();
                    Fornecedor forn = new Fornecedor();
                    forn.setIdFornecedor(Integer.parseInt(request.getParameter("id_fornecedor_comum")));
                    enc.setIdFornecedor(forn);
                    
                    Local local = new Local();
                    local.setIdLocal(Integer.parseInt(request.getParameter("id_local"))); 
                    enc.setIdLocal(local);

                    sucesso = daoEnc.finalizarEncomendaCompleta(mov, enc, linhas);
                }

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