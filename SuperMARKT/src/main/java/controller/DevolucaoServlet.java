package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import DAO.DevolucaoDAO;
import DAO.LinhaVendaDAO;
import DBconnection.DBconnection; 
import model.Devolucao;
import model.LinhaVenda;

@WebServlet("/DevolucaoServlet")
public class DevolucaoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/Front-end/pages/reembolso.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        try {
            String acao = request.getParameter("acao");

            
            if ("procurar".equals(acao)) {
                int idVenda = Integer.parseInt(request.getParameter("idVenda"));
                
                LinhaVendaDAO linhaDAO = new LinhaVendaDAO();
                List<String[]> produtosBD = linhaDAO.getProdutosDaVenda(idVenda);
                
                List<Integer> idsDevolvidos = (List<Integer>) session.getAttribute("idsDevolvidos");
                if (idsDevolvidos == null) {
                    idsDevolvidos = new ArrayList<>();
                }

                List<String[]> produtosParaMostrar = new ArrayList<>();
                float valorCalculado = 0.00f;
                
                for (String[] prod : produtosBD) {
                    int idLinha = Integer.parseInt(prod[0]);
                    
                    if (!idsDevolvidos.contains(idLinha)) {
                        produtosParaMostrar.add(prod);
                        valorCalculado += Float.parseFloat(prod[3]); 
                    }
                }
                
                request.setAttribute("idVendaProcurada", idVenda);
                request.setAttribute("valorVenda", valorCalculado);
                request.setAttribute("produtosFatura", produtosParaMostrar); 
                
                request.getRequestDispatcher("/Front-end/pages/reembolso.jsp").forward(request, response);
                return;
            }

            
            if ("confirmar".equals(acao)) {
                String[] idsLinhaVenda = request.getParameterValues("idLinhaVenda");
                
                if (idsLinhaVenda == null || idsLinhaVenda.length == 0) {
                    response.sendRedirect(request.getContextPath() + "/DevolucaoServlet?reembolso=erro");
                    return;
                }

                List<Integer> idsDevolvidos = (List<Integer>) session.getAttribute("idsDevolvidos");
                if (idsDevolvidos == null) idsDevolvidos = new ArrayList<>();

                DevolucaoDAO dao = new DevolucaoDAO();
                
                for (String idStr : idsLinhaVenda) {
                    int idLinha = Integer.parseInt(idStr);
                    idsDevolvidos.add(idLinha);

                    LinhaVenda linha = new LinhaVenda();
                    linha.setIdLinhaVenda(idLinha); 

                    Devolucao dev = new Devolucao();
                    dev.setIdLinhavenda(linha);
                    dev.setMotivo("Devolução de artigo");
                    dev.setQuantidade(1);
                    dev.setValor(0.00f);  
                    dev.setReporStock(true);

                    
                    dao.inserir(dev);
                    
                    
                    try (Connection conn = DBconnection.getConnection()) {
                        String sqlRepor = "UPDATE stock_local s " +
                                          "INNER JOIN linha_venda lv ON s.id_produto = lv.id_produto " +
                                          "SET s.quantidade = s.quantidade + lv.quantidade " +
                                          "WHERE lv.id_linhavenda = ?";
                        try (PreparedStatement stmtRepor = conn.prepareStatement(sqlRepor)) {
                            stmtRepor.setInt(1, idLinha);
                            stmtRepor.executeUpdate();
                        }
                    } catch (Exception ex) {
                        System.out.println("Erro ao repor o stock: " + ex.getMessage());
                    }
                }

                session.setAttribute("idsDevolvidos", idsDevolvidos);
                response.sendRedirect(request.getContextPath() + "/DashboardServlet?reembolso=sucesso");
                return;
            }

        } catch (Exception e) {
            System.out.println("Erro crítico no DevolucaoServlet: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/DashboardServlet?reembolso=erro");
        }
    }
}