package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import DAO.MovimentosDAO;
import DAO.VendaDAO;
import DAO.LinhaVendaDAO;
import model.Movimentos;
import model.Venda;
import model.Funcionario;
import model.LinhaVenda;
import model.Produto;

@WebServlet("/RegistarVenda")
public class RegistarVendaServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        try {
            // Receber o valor total e as listas de produtos do JSP
            String valorDoJsp = request.getParameter("totalVendaReal");
            String[] idsProdutos = request.getParameterValues("idProduto");
            String[] quantidades = request.getParameterValues("quantidade");
            String[] precosVenda = request.getParameterValues("precoVenda");

            float valorFinal = (valorDoJsp != null) ? Float.parseFloat(valorDoJsp) : 0.0f;

            
            Funcionario func = new Funcionario();
            func.setNif("123456789");
            
            // Criar Movimento
            Movimentos mov = new Movimentos();
            mov.setFuncionario(func);
            
            MovimentosDAO movDAO = new MovimentosDAO();
            int idMovimentoGerado = movDAO.inserir(mov);
            
            if (idMovimentoGerado > 0) {
                System.out.println("SUCESSO: Movimento criado com o ID: " + idMovimentoGerado);
                mov.setIdMovimentos(idMovimentoGerado); 
                
                // Criar uma venda
                Venda venda = new Venda();
                venda.setIdMovimentos(mov); 
                venda.setValorTotal(valorFinal);
                
                VendaDAO vendaDAO = new VendaDAO();
                vendaDAO.inserir(venda); 
                System.out.println("SUCESSO: Venda de " + valorFinal + "€ registada!");

                // Criação linhas da venda
                if (idsProdutos != null) {
                    LinhaVendaDAO lvDAO = new LinhaVendaDAO();
                    
                    for (int i = 0; i < idsProdutos.length; i++) {
                        LinhaVenda lv = new LinhaVenda();
                        
                        
                        Produto p = new Produto();
                        p.setIdProduto(Integer.parseInt(idsProdutos[i]));
                        
                        lv.setIdMovimentos(venda); 
                        lv.setIdProduto(p);
                        lv.setQuantidade(Integer.parseInt(quantidades[i]));
                        lv.setPrecoVenda(Float.parseFloat(precosVenda[i]));
                        
                        
                        lv.setIva(23.0f); 
                        lv.setSubtotal(lv.getQuantidade() * lv.getPrecoVenda());
                        
                        lvDAO.inserir(lv);
                        System.out.println("Item " + (i+1) + " guardado: Produto ID " + idsProdutos[i]);
                    }
                }
            }

            
            response.sendRedirect("Front-end/dashboard.jsp?venda=sucesso");

        } catch (Exception e) {
            System.out.println("ERRO no Servlet: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("Front-end/dashboard.jsp?venda=erro");
        }
    }
}