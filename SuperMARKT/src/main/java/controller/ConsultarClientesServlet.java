package controller;

import java.io.IOException;
import java.util.List;

import DAO.ClienteDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Cliente;

@WebServlet("/ConsultarClientesServlet")
public class ConsultarClientesServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int currentPage = 1;
        int pageSize = 5;

        try {
            currentPage = Integer.parseInt(request.getParameter("page"));
        } catch (Exception e) {
            // default page
        }

        int offset = (currentPage - 1) * pageSize;
        String nomePesquisa = request.getParameter("txtNome");
        String orderBy = request.getParameter("orderBy");
        String orderDir = request.getParameter("orderDir");

        if (nomePesquisa == null) nomePesquisa = "";
        if (orderBy == null) orderBy = "id_cliente";
        if (orderDir == null) orderDir = "ASC";

        ClienteDAO dao = new ClienteDAO();
        List<Cliente> clientes = dao.getClientes(nomePesquisa, orderBy, orderDir, pageSize, offset);
        int totalClientes = dao.getTotalClientes(nomePesquisa);
        int totalPages = (int) Math.ceil((double) totalClientes / pageSize);
        
        // KPIs
        int clientesAtivos = dao.getClientesComCompras();
        String melhorCliente = dao.getMelhorCliente();
        double mediaGastos = dao.getMediaGastos();

        request.setAttribute("clientes", clientes);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalClientes", totalClientes);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("clientesAtivos", clientesAtivos);
        request.setAttribute("melhorCliente", melhorCliente);
        request.setAttribute("mediaGastos", mediaGastos);
        request.setAttribute("txtNome", nomePesquisa);
        request.setAttribute("orderBy", orderBy);
        request.setAttribute("orderDir", orderDir);
        request.getRequestDispatcher("/Front-end/pages/consultarclientes.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        ClienteDAO dao = new ClienteDAO();

        try {
            String page = request.getParameter("page");
            String txtNome = request.getParameter("txtNome");
            String orderBy = request.getParameter("orderBy");
            String orderDir = request.getParameter("orderDir");

            if (page == null) page = "1";
            if (txtNome == null) txtNome = "";
            if (orderBy == null) orderBy = "id_cliente";
            if (orderDir == null) orderDir = "ASC";

            if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("delete_id_cliente"));
                dao.deleteCliente(id);
            } else if ("insert".equals(action)) {
                String nome = request.getParameter("nome");
                String contacto = request.getParameter("contacto");
                String nif = request.getParameter("nif");

                if (nome != null && !nome.isBlank()) {
                    Cliente c = new Cliente();
                    c.setNome(nome.trim());
                    c.setContacto(contacto != null ? contacto.trim() : "");
                    c.setNif(nif != null ? nif.trim() : "");
                    dao.insertCliente(c);
                }
            } else if ("update".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id_cliente"));
                String nome = request.getParameter("nome");
                String contacto = request.getParameter("contacto");
                String nif = request.getParameter("nif");

                Cliente c = new Cliente();
                c.setIdCliente(id);
                c.setNome(nome);
                c.setContacto(contacto);
                c.setNif(nif);
                dao.updateCliente(c);
            }

            response.sendRedirect("ConsultarClientesServlet?page=" + page +
                    "&txtNome=" + txtNome +
                    "&orderBy=" + orderBy +
                    "&orderDir=" + orderDir);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("msg", "Erro ao processar cliente.");
            doGet(request, response);
        }
    }
}
