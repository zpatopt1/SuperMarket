package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Local;
import model.Zona;

import java.io.IOException;
import java.util.List;

import DAO.LocalDAO;
import DAO.ZonaDAO;

/**
 * Servlet implementation class ConsultarLocalServlet
 */
@WebServlet("/ConsultarZonaServlet")
public class ConsultarZonaServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public ConsultarZonaServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	ZonaDAO dao = new ZonaDAO();
        List<Zona> zonas = dao.getAllZonas();
        request.setAttribute("zonas", zonas);
        request.getRequestDispatcher("/Front-end/pages/consultarzona.jsp").forward(request, response);
    }

protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    String action = request.getParameter("action");
    ZonaDAO dao = new ZonaDAO();

    try {

        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("delete_id_zona"));
            dao.deleteZona(id);
            response.sendRedirect("GestaoEspacosServlet");
        }

        else if ("insert".equals(action)) {
        	String nome = request.getParameter("modal_add_nome");
        	int idLocal = Integer.parseInt(request.getParameter("modal_add_id_local"));
        	
            if (nome != null && !nome.trim().isEmpty()) {
                Zona zona = new Zona();
                zona.setNome(nome.trim());
                // criar local só com ID (foreign key)
                Local local = new Local();
                local.setIdLocal(idLocal);
                zona.setLocal(local);
                dao.insertZona(zona);
            }

            response.sendRedirect("GestaoEspacosServlet");
        }

        else if ("update".equals(action)) {
            int idZona = Integer.parseInt(request.getParameter("id_zona"));
            String nome = request.getParameter("nome");
            int idLocal = Integer.parseInt(request.getParameter("id_local"));

            Zona zona = new Zona();
            zona.setIdZona(idZona);
            zona.setNome(nome);

            Local local = new Local();
            local.setIdLocal(idLocal);
            
            zona.setLocal(local);

            dao.updateZona(zona);
            response.sendRedirect("GestaoEspacosServlet");
        }

    } catch (Exception e) {
        e.printStackTrace();
        request.setAttribute("msg", "Erro ao processar a ação");
        doGet(request, response);
    }
}
}