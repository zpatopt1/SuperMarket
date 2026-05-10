package controller;

import java.io.IOException;
import java.util.List;

import DAO.FornecedorDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Fornecedor;

@WebServlet("/ConsultarFornecedoresServlet")
public class ConsultarFornecedoresServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        FornecedorDAO dao = new FornecedorDAO();
        List<Fornecedor> fornecedores = dao.getAllFornecedores();
        request.setAttribute("fornecedores", fornecedores);
        request.getRequestDispatcher("/Front-end/pages/consultarfornecedores.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        FornecedorDAO dao = new FornecedorDAO();
        try {
            if ("insert".equals(action)) {
                Fornecedor f = new Fornecedor();
                f.setTipoFornecedor(request.getParameter("tipo_fornecedor"));
                f.setContacto(request.getParameter("contacto"));
                f.setNif(request.getParameter("nif"));
                dao.insertFornecedor(f);
            } else if ("update".equals(action)) {
                Fornecedor f = new Fornecedor();
                f.setIdFornecedor(Integer.parseInt(request.getParameter("id_fornecedor")));
                f.setTipoFornecedor(request.getParameter("tipo_fornecedor"));
                f.setContacto(request.getParameter("contacto"));
                f.setNif(request.getParameter("nif"));
                dao.updateFornecedor(f);
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id_fornecedor"));
                dao.deleteFornecedor(id);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect("ConsultarFornecedoresServlet");
    }
}
