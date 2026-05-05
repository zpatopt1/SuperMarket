package controller;

import java.io.IOException;

import DAO.PerdaStockDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Funcionario;
import model.Local;
import model.PerdaStock;
import model.Produto;

@WebServlet("/RegistarPerdaServlet")
public class RegistarPerdaServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private PerdaStockDAO perdaStockDAO;

    public RegistarPerdaServlet() {
        super();
        this.perdaStockDAO = new PerdaStockDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Funcionario funcionario = (Funcionario) session.getAttribute("utilizadorLogado");

        if (funcionario == null) {
            response.sendRedirect(request.getContextPath() + "/Front-end/pages/login.jsp");
            return;
        }

        try {
            int idProduto = Integer.parseInt(request.getParameter("idProduto"));
            int idLocal = Integer.parseInt(request.getParameter("idLocal"));
            int quantidade = Integer.parseInt(request.getParameter("quantidade"));
            String motivo = request.getParameter("motivo");

            Produto produto = new Produto();
            produto.setIdProduto(idProduto);

            Local local = new Local();
            local.setIdLocal(idLocal);

            PerdaStock perda = new PerdaStock();
            perda.setProduto(produto);
            perda.setLocal(local);
            perda.setQuantidade(quantidade);
            perda.setMotivo(motivo);

            boolean success = perdaStockDAO.registarPerda(perda, funcionario.getNif());

            if (success) {
                request.getSession().setAttribute("mensagemSucesso", "Quebra de stock registada com sucesso!");
            } else {
                request.getSession().setAttribute("mensagemErro", "Erro ao registar a quebra de stock.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("mensagemErro", "Erro: " + e.getMessage());
        }

        // Redirect back to the stock view
        String redirectUrl = request.getContextPath() + "/ConsultarStockLocalServlet";
        String filterLocal = request.getParameter("filterIdLocal");
        if (filterLocal != null && !filterLocal.isEmpty()) {
            redirectUrl += "?idLocal=" + filterLocal;
        }
        response.sendRedirect(redirectUrl);
    }
}
