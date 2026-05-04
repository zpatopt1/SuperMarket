package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

import DAO.LocalDAO;
import DAO.ZonaDAO;
import model.Local;
import model.Zona;

/**
 * Servlet implementation class GestaoEspacosServlet
 * Controlador único para gerir Locais e Zonas na mesma página.
 */
@WebServlet("/GestaoEspacosServlet")
public class GestaoEspacosServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public GestaoEspacosServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Instanciar os DAOs
            LocalDAO localDAO = new LocalDAO();
            ZonaDAO zonaDAO = new ZonaDAO();
            
            // Buscar os dados
            List<Local> locais = localDAO.getAllLocais();
            List<Zona> zonas = zonaDAO.getAllZonas();
            
            // Passar os dados para a view
            request.setAttribute("locais", locais);
            request.setAttribute("zonas", zonas);
            
            // Encaminhar para o JSP unificado
            request.getRequestDispatcher("/Front-end/pages/gestao_espacos.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erro ao carregar dados dos espaços.");
        }
    }
}
