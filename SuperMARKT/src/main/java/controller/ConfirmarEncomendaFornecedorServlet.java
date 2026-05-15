package controller;

import java.io.IOException;
import java.sql.Date;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

import DAO.EncomendaDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import model.Encomenda;
import model.LinhaEnc;
import java.io.BufferedReader;
import java.io.InputStreamReader;

@WebServlet("/ConfirmarEncomendaFornecedorServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 1024 * 1024 * 10,
    maxRequestSize = 1024 * 1024 * 15
)
public class ConfirmarEncomendaFornecedorServlet extends HttpServlet {
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
        Encomenda encomenda = dao.getEncomendaById(idEncomenda);
        List<LinhaEnc> linhas = dao.getLinhasEncomenda(idEncomenda);
        if (encomenda == null) {
            response.sendRedirect(request.getContextPath() + "/EncomendasServlet");
            return;
        }

        request.setAttribute("encomenda", encomenda);
        request.setAttribute("linhas", linhas);
        request.getRequestDispatcher("/Front-end/pages/confirmar_encomenda_fornecedor.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id_encomenda");
        if (idParam == null || idParam.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/EncomendasServlet");
            return;
        }
        int idEncomenda = Integer.parseInt(idParam);

        float custoEnvio = 0f;
        try {
            String custo = request.getParameter("custo_envio");
            if (custo != null && !custo.isBlank()) custoEnvio = Float.parseFloat(custo);
        } catch (Exception ignored) {
        }

        Date dataPrevista = null;
        try {
            String dp = request.getParameter("data_prevista");
            if (dp != null && !dp.isBlank()) dataPrevista = Date.valueOf(dp);
        } catch (Exception ignored) {
        }

        Map<Integer, Date> validadePorLinha = new HashMap<>();

        boolean csvImportado = false;
        Part csvFile = null;
        try {
            csvFile = request.getPart("csvFile");
        } catch (Exception ignored) {
        }

        if (csvFile != null && csvFile.getSize() > 0) {
            try (BufferedReader reader = new BufferedReader(new InputStreamReader(csvFile.getInputStream(), "UTF-8"))) {
                String line;
                boolean firstLine = true;
                while ((line = reader.readLine()) != null) {
                    if (firstLine) {
                        firstLine = false;
                        continue; // cabeçalho
                    }
                    if (line.trim().isEmpty()) continue;
                    String[] cols = line.split(";");
                    // formato download: id_encomenda;id_linhaenc;id_produto;produto;quantidade;preco_info;data_validade;data_prevista;custo_envio
                    if (cols.length >= 9) {
                        try {
                            int idLinha = Integer.parseInt(cols[1].trim());
                            Date validade = Date.valueOf(cols[6].trim());
                            validadePorLinha.put(idLinha, validade);
                            if ((request.getParameter("data_prevista") == null || request.getParameter("data_prevista").isBlank())
                                    && cols[7] != null && !cols[7].trim().isEmpty()) {
                                dataPrevista = Date.valueOf(cols[7].trim());
                            }
                            custoEnvio = Float.parseFloat(cols[8].trim());
                            System.out.println("DEBUG custo_envio raw: [" + cols[8] + "]");
                            
                            csvImportado = true;
                        } catch (Exception ignored) {
                        }
                    }
                }
            } catch (Exception ignored) {
            }
        
        }
        if (!csvImportado) {
            String[] linhaIds = request.getParameterValues("linha_id");
            if (linhaIds != null) {
                for (String idLinhaStr : linhaIds) {
                    try {
                        int idLinha = Integer.parseInt(idLinhaStr);
                        String validadeStr = request.getParameter("validade_" + idLinha);
                        if (validadeStr == null || validadeStr.isBlank()) continue;
                        Date validade = Date.valueOf(validadeStr);
                        validadePorLinha.put(idLinha, validade);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            }
        }

        EncomendaDAO dao = new EncomendaDAO();
        boolean ok = dao.confirmarFornecedor(idEncomenda, custoEnvio, dataPrevista, validadePorLinha);
        if (ok) {
            request.getSession().setAttribute("mensagemSucesso", "Encomenda confirmada com sucesso.");
        } else {
            request.getSession().setAttribute("mensagemErro", "Erro ao confirmar encomenda.");
        }
        response.sendRedirect(request.getContextPath() + "/EncomendasServlet");
    }
}
    
