package controller;

import java.io.IOException;
import java.util.List;

import DAO.FuncaoDAO;
import DAO.FuncionarioDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Funcao;
import model.Funcionario;

@WebServlet("/ConsultarUtilizadoresServlet")
public class ConsultarUtilizadoresServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        FuncionarioDAO funcionarioDAO = new FuncionarioDAO();
        FuncaoDAO funcaoDAO = new FuncaoDAO();
        List<Funcionario> funcionarios = funcionarioDAO.getAllFuncionarios();
        List<Funcao> funcoes = funcaoDAO.getAllFuncoes();

        request.setAttribute("funcionarios", funcionarios);
        request.setAttribute("funcoes", funcoes);
        request.getRequestDispatcher("/Front-end/pages/admin/utilizadores.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        FuncionarioDAO funcionarioDAO = new FuncionarioDAO();

        try {
            if ("insert".equals(action)) {
                String nif = request.getParameter("nif");
                String nome = request.getParameter("nome");
                String contacto = request.getParameter("contacto");
                String email = request.getParameter("email");
                String password = request.getParameter("password");
                String idFuncaoParam = request.getParameter("id_funcao");
                String ativoParam = request.getParameter("ativo");

                if (nif != null && !nif.isBlank() &&
                    nome != null && !nome.isBlank() &&
                    email != null && !email.isBlank() &&
                    password != null && !password.isBlank() &&
                    idFuncaoParam != null && !idFuncaoParam.isBlank()) {

                    Funcao funcao = new Funcao(Integer.parseInt(idFuncaoParam), "");
                    Funcionario funcionario = new Funcionario();
                    funcionario.setNif(nif.trim());
                    funcionario.setNome(nome.trim());
                    funcionario.setContacto(contacto != null ? contacto.trim() : "");
                    funcionario.setEmail(email.trim());
                    funcionario.setPassword(password);
                    funcionario.setIdFuncao(funcao);
                    funcionario.setAtivo("true".equalsIgnoreCase(ativoParam) || "on".equalsIgnoreCase(ativoParam));

                    funcionarioDAO.insertFuncionario(funcionario);
                }
            } else if ("delete".equals(action)) {
                String nif = request.getParameter("delete_nif");
                if (nif != null && !nif.isBlank()) {
                    funcionarioDAO.deleteFuncionario(nif.trim());
                }
            } else if ("update".equals(action)) {
                String nif = request.getParameter("edit_nif");
                String nome = request.getParameter("edit_nome");
                String contacto = request.getParameter("edit_contacto");
                String email = request.getParameter("edit_email");
                String password = request.getParameter("edit_password");
                String idFuncaoParam = request.getParameter("edit_id_funcao");
                String ativoParam = request.getParameter("edit_ativo");

                if (nif != null && !nif.isBlank() &&
                    nome != null && !nome.isBlank() &&
                    email != null && !email.isBlank() &&
                    idFuncaoParam != null && !idFuncaoParam.isBlank()) {

                    Funcao funcao = new Funcao(Integer.parseInt(idFuncaoParam), "");
                    Funcionario funcionario = new Funcionario();
                    funcionario.setNif(nif.trim());
                    funcionario.setNome(nome.trim());
                    funcionario.setContacto(contacto != null ? contacto.trim() : "");
                    funcionario.setEmail(email.trim());
                    funcionario.setIdFuncao(funcao);
                    funcionario.setAtivo("true".equalsIgnoreCase(ativoParam) || "on".equalsIgnoreCase(ativoParam));

                    boolean updatePassword = password != null && !password.isBlank();
                    if (updatePassword) {
                        funcionario.setPassword(password);
                    }

                    funcionarioDAO.updateFuncionario(funcionario, updatePassword);
                }
            }

            response.sendRedirect("ConsultarUtilizadoresServlet");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("msg", "Erro ao processar utilizador.");
            doGet(request, response);
        }
    }
}
