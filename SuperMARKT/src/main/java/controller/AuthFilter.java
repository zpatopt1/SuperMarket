package controller;

import java.io.IOException;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Funcao;
import model.Funcionario;

@WebFilter(urlPatterns = {"/*"})
public class AuthFilter implements Filter {

    private static final Set<String> REPOSITOR_ONLY = new HashSet<>(Arrays.asList(
            "/ConsultarProdutosServlet",
            "/ConsultarCategoriaServlet",
            "/ConsultarLocalServlet",
            "/ConsultarZonaServlet",
            "/ConsultarStockLocalServlet",
            "/Front-end/pages/consultarProdutos.jsp",
            "/Front-end/pages/consultarcategorias.jsp",
            "/Front-end/pages/consultarlocal.jsp",
            "/Front-end/pages/consultarzona.jsp",
            "/Front-end/pages/consultarstocklocal.jsp"
    ));

    private static final Set<String> ADMIN_ONLY = new HashSet<>(Arrays.asList(
            "/ConsultarUtilizadoresServlet",
            "/Front-end/pages/admin/utilizadores.jsp",
            "/Front-end/pages/admin/promocoes.jsp"
    ));

    private static final Set<String> CAIXA_ONLY = new HashSet<>(Arrays.asList(
        "/ConsultarClientesServlet",
        "/Front-end/pages/consultarclientes.jsp",
        "/Front-end/pages/vendas.jsp",
        "/Front-end/pages/reembolso.jsp"
    ));


    @Override
    public void init(FilterConfig filterConfig) {
    }
    // PARA DEV MODE APAGAR DPS
    private static final boolean DEV_MODE = true;
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
    	
        // PARA DEV MODE APAGAR DPS
    	if (DEV_MODE) {
    	    HttpServletRequest req = (HttpServletRequest) request;
    	    HttpSession session = req.getSession(true);

    	    if (session.getAttribute("utilizadorLogado") == null) {

    	        Funcionario fake = new Funcionario();

    	        // garantir que não dá NullPointer
    	        Funcao funcao = new Funcao(0, "administrador");

    	        fake.setIdFuncao(funcao);

    	        session.setAttribute("utilizadorLogado", fake);
    	        session.setAttribute("funcao", "administrador");
    	    }

    	    chain.doFilter(request, response);
    	    return;
    	}
        
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        String path = req.getRequestURI().substring(req.getContextPath().length());

        if (isPublic(path)) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = req.getSession(false);
        Funcionario user = session == null ? null : (Funcionario) session.getAttribute("utilizadorLogado");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/Front-end/pages/login.jsp");
            return;
        }

        String funcao = user.getIdFuncao() != null ? user.getIdFuncao().getDescricao() : "";
        
        if (isForbidden(path, funcao)) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Sem permissao para aceder a este recurso.");
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }

    private boolean isPublic(String path) {
        return "/login".equals(path)
                || "/logout".equals(path)
                || "/Front-end/pages/login.jsp".equals(path)
                || "/Front-end/pages/logout.jsp".equals(path)
                || path.startsWith("/Front-end/styles/")
                || path.startsWith("/Front-end/js/")
                || path.startsWith("/Front-end/assets/")
                || path.startsWith("/META-INF/");
    }

    private boolean isForbidden(String path, String funcao) {
        String role = funcao == null ? "" : funcao.trim().toLowerCase();
        boolean admin = "administrador".equals(role);
        boolean repositor = "repositor".equals(role) || admin;
        boolean caixa = "caixa".equals(role) || admin;

        if (ADMIN_ONLY.contains(path)) return !admin;
        if (REPOSITOR_ONLY.contains(path)) return !repositor;
        if (CAIXA_ONLY.contains(path)) return !caixa;

        return false;
    }
}
