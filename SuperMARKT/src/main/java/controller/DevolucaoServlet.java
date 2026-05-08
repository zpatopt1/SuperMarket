package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import DAO.DevolucaoDAO;
import model.Devolucao;
import model.LinhaVenda;

@WebServlet("/DevolucaoServlet")
public class DevolucaoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            
            int idLinhaVenda = Integer.parseInt(request.getParameter("idLinhaVenda"));
            String motivo = request.getParameter("motivo");
            int quantidade = Integer.parseInt(request.getParameter("quantidade"));
            float valor = Float.parseFloat(request.getParameter("valor"));
            boolean reporStock = request.getParameter("reporStock") != null;

            
            LinhaVenda linha = new LinhaVenda();
            linha.setIdLinhaVenda(idLinhaVenda); 

            
            Devolucao dev = new Devolucao();
            dev.setIdLinhavenda(linha);
            dev.setMotivo(motivo);
            dev.setQuantidade(quantidade);
            dev.setValor(valor);
            dev.setReporStock(reporStock);

            
            DevolucaoDAO dao = new DevolucaoDAO();
            dao.inserir(dev);

            
            response.sendRedirect(request.getContextPath() + "/Front-end/pages/reembolso.jsp?sucesso=devolucao");

        } catch (Exception e) {
            e.printStackTrace();
            
            response.sendRedirect(request.getContextPath() + "/Front-end/pages/reembolso.jsp?erro=devolucao");
        }
    }
}