package controller;

import java.io.IOException;

import DAO.FuncionarioDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Funcionario;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/Front-end/pages/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || email.isBlank() || password == null || password.isBlank()) {
            request.setAttribute("erro", "Preencha email e palavra-passe.");
            request.getRequestDispatcher("/Front-end/pages/login.jsp").forward(request, response);
            return;
        }

        FuncionarioDAO dao = new FuncionarioDAO();
        Funcionario funcionario = dao.autenticar(email.trim(), password);
        if (funcionario == null) {
            request.setAttribute("erro", "Credenciais invalidas.");
            request.getRequestDispatcher("/Front-end/pages/login.jsp").forward(request, response);
            return;
        }

        HttpSession session = request.getSession(true);
        session.setAttribute("utilizadorLogado", funcionario);
        session.setAttribute("funcao", funcionario.getIdFuncao().getDescricao());
        String funcao = funcionario.getIdFuncao().getDescricao();

        if (funcao.equalsIgnoreCase("administrador")) {
        	response.sendRedirect(request.getContextPath() + "/DashboardServlet");
        }else if(funcao.equalsIgnoreCase("caixa")) {
            response.sendRedirect(request.getContextPath() + "/Front-end/pages/vendas.jsp");
        }else if(funcao.equalsIgnoreCase("repositor")) {
            response.sendRedirect(request.getContextPath() + "/ConsultarProdutosServlet");

        }
    }
}
