package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import DAO.ProdutoDAO;
import DBconnection.DBconnection;
import model.Produto;
import model.Funcionario;

@WebServlet("/RegistarVenda")
public class RegistarVendaServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            ProdutoDAO produtoDAO = new ProdutoDAO();
            List<Produto> listaDeProdutos = produtoDAO.getProdutos("", "id_produto", "ASC", 1000, 0);
            request.setAttribute("produtos", listaDeProdutos);
        } catch (Exception e) {
            e.printStackTrace();
        }
        request.getRequestDispatcher("/Front-end/pages/vendas.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String[] idsProdutos = request.getParameterValues("idProduto");
            String[] quantidades = request.getParameterValues("quantidade");

            if (idsProdutos != null && idsProdutos.length > 0) {
                ProdutoDAO prodDAO = new ProdutoDAO();
                int idFaturaGerada = (int)(Math.random() * 100000); 
                float valorTotalVenda = 0.0f;

                try (Connection conn = DBconnection.getConnection()) {
                    
                    
                    String sqlPreco = "SELECT preco FROM produto WHERE id_produto = ?";
                    try (PreparedStatement stmtPreco = conn.prepareStatement(sqlPreco)) {
                        for (int i = 0; i < idsProdutos.length; i++) {
                            stmtPreco.setInt(1, Integer.parseInt(idsProdutos[i]));
                            try (ResultSet rs = stmtPreco.executeQuery()) {
                                if (rs.next()) {
                                    valorTotalVenda += (rs.getFloat("preco") * Integer.parseInt(quantidades[i]));
                                }
                            }
                        }
                    }

                    
                    String sqlInsertMovimento = "INSERT INTO movimentos (id_movimentos) VALUES (?)";
                    try (PreparedStatement stmtMov = conn.prepareStatement(sqlInsertMovimento)) {
                        stmtMov.setInt(1, idFaturaGerada);
                        stmtMov.executeUpdate(); 
                    }

                    
                    String sqlInsertVenda = "INSERT INTO venda (id_venda, id_cliente, valor_total) VALUES (?, NULL, ?)";
                    try (PreparedStatement stmtVenda = conn.prepareStatement(sqlInsertVenda)) {
                        stmtVenda.setInt(1, idFaturaGerada);
                        stmtVenda.setFloat(2, valorTotalVenda);
                        stmtVenda.executeUpdate(); 
                    }

                   
                    String sqlInsertLinha = "INSERT INTO linha_venda (id_venda, id_produto, quantidade, preco_venda, iva, subtotal, desconto) VALUES (?, ?, ?, ?, ?, ?, ?)";
                    try (PreparedStatement stmtPreco = conn.prepareStatement(sqlPreco);
                         PreparedStatement stmtLinha = conn.prepareStatement(sqlInsertLinha)) {
                         
                        for (int i = 0; i < idsProdutos.length; i++) {
                            int idProd = Integer.parseInt(idsProdutos[i]);
                            int qtdComprada = Integer.parseInt(quantidades[i]);
                            
                            prodDAO.reduzirStock(idProd, qtdComprada); 

                            float precoReal = 0.0f;
                            stmtPreco.setInt(1, idProd);
                            try (ResultSet rs = stmtPreco.executeQuery()) {
                                if (rs.next()) precoReal = rs.getFloat("preco"); 
                            }

                            stmtLinha.setInt(1, idFaturaGerada);
                            stmtLinha.setInt(2, idProd);
                            stmtLinha.setInt(3, qtdComprada);
                            stmtLinha.setFloat(4, precoReal);
                            stmtLinha.setFloat(5, 23.0f);
                            stmtLinha.setFloat(6, precoReal * qtdComprada);
                            stmtLinha.setFloat(7, 0.0f); 
                            
                            stmtLinha.executeUpdate(); 
                        }
                    }
                }
                
                
                response.sendRedirect(request.getContextPath() + "/DashboardServlet?venda=sucesso&fatura=" + idFaturaGerada);
                return; 
            }
            response.sendRedirect(request.getContextPath() + "/DashboardServlet?venda=erro");

        } catch (Exception e) {
            
            response.setContentType("text/html;charset=UTF-8");
            PrintWriter out = response.getWriter();
            out.println("<div style='padding: 50px; font-family: Arial, sans-serif;'>");
            out.println("<h1 style='color: #dc3545;'>⚠️ ERRO NA BASE DE DADOS</h1>");
            out.println("<div style='background: #f8d7da; padding: 25px; border: 2px solid #f5c6cb; border-radius: 8px;'>");
            out.println("<h2 style='color: #721c24; margin: 0;'>" + e.getMessage() + "</h2>");
            out.println("</div></div>");
            e.printStackTrace();
        }
    }
}