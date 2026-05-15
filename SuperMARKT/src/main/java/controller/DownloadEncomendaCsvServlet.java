package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.nio.charset.StandardCharsets;
import java.util.List;

import DAO.EncomendaDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Encomenda;
import model.LinhaEnc;

@WebServlet("/DownloadEncomendaCsvServlet")
public class DownloadEncomendaCsvServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/EncomendasServlet");
            return;
        }

        int idEncomenda;
        try {
            idEncomenda = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/EncomendasServlet");
            return;
        }

        EncomendaDAO dao = new EncomendaDAO();
        Encomenda enc = dao.getEncomendaById(idEncomenda);
        List<LinhaEnc> linhas = dao.getLinhasEncomenda(idEncomenda);
        if (enc == null) {
            response.sendRedirect(request.getContextPath() + "/EncomendasServlet");
            return;
        }

        response.setCharacterEncoding(StandardCharsets.UTF_8.name());
        response.setContentType("text/csv; charset=UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=\"encomenda_" + idEncomenda + "_fornecedor.csv\"");

        try (PrintWriter out = response.getWriter()) {
            // Header com campos que o fornecedor deve completar
            out.println("id_encomenda;id_linhaenc;id_produto;produto;quantidade;preco_info;data_validade;data_prevista;custo_envio");

            String dataPrevista = enc.getDataPrevista() != null ? enc.getDataPrevista().toString() : "";
            String custoEnvio = enc.getCustoEnvio() > 0 ? String.valueOf(enc.getCustoEnvio()) : "";

            for (int i = 0; i < linhas.size(); i++) {
                LinhaEnc l = linhas.get(i);
                String produtoNome = l.getProduto() != null ? escape(l.getProduto().getNome()) : "";
                String base =
                        idEncomenda + ";" +
                        l.getIdLinhaOrder() + ";" +
                        (l.getProduto() != null ? l.getProduto().getIdProduto() : "") + ";" +
                        produtoNome + ";" +
                        l.getQuantidade() + ";" +
                        l.getPrecoEncomenda() + ";" +
                        ";" + // data_validade (fornecedor preenche)
                        (i == 0 ? dataPrevista : "") + ";" + // preenche 1x
                        (i == 0 ? custoEnvio : "");          // preenche 1x
                out.println(base);
            }
        }
    }

    private String escape(String value) {
        if (value == null) return "";
        String v = value.replace("\"", "\"\"");
        if (v.contains(";") || v.contains("\"") || v.contains("\n") || v.contains("\r")) {
            return "\"" + v + "\"";
        }
        return v;
    }
}
