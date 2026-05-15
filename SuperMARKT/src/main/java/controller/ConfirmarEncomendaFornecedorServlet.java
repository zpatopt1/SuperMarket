package controller;

import java.io.IOException;
import java.sql.Date;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.ArrayList;

import DAO.EncomendaDAO;
import DAO.EncomendaDAO.LoteSplit;
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
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@WebServlet("/ConfirmarEncomendaFornecedorServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 1024 * 1024 * 10,
    maxRequestSize = 1024 * 1024 * 15
)
public class ConfirmarEncomendaFornecedorServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private Date parseDateFlexible(String raw) {
        if (raw == null) return null;
        String v = raw.trim();
        if (v.isEmpty()) return null;
        try {
            return Date.valueOf(v);
        } catch (Exception ignored) {
        }
        try {
            LocalDate d = LocalDate.parse(v, DateTimeFormatter.ofPattern("dd/MM/yyyy"));
            return Date.valueOf(d);
        } catch (DateTimeParseException ignored) {
        }
        return null;
    }

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
        System.out.println("[ConfirmarEncomendaFornecedorServlet] Confirmar encomenda id=" + idEncomenda);
        for (Map.Entry<String, String[]> p : request.getParameterMap().entrySet()) {
            String k = p.getKey();
            if (k.startsWith("qtd_lote_") || k.startsWith("validade_") || "linha_id".equals(k) || "data_prevista".equals(k)) {
                String[] v = p.getValue();
                String first = (v != null && v.length > 0) ? v[0] : "";
                System.out.println("[ConfirmarEncomendaFornecedorServlet] param " + k + " = " + first + " (count=" + (v != null ? v.length : 0) + ")");
            }
        }

        float custoEnvio = 0f;
        try {
            String custo = request.getParameter("custo_envio");
            if (custo != null && !custo.isBlank()) custoEnvio = Float.parseFloat(custo);
        } catch (Exception ignored) {
        }

        Date dataPrevista = null;
        try {
            String dp = request.getParameter("data_prevista");
            if (dp != null && !dp.isBlank()) dataPrevista = parseDateFlexible(dp);
        } catch (Exception ignored) {
        }

        Map<Integer, Date> validadePorLinha = new HashMap<>();
        Map<Integer, List<LoteSplit>> lotesPorLinha = new HashMap<>();
        Map<Integer, List<LoteSplit>> lotesPorLinhaCsv = new HashMap<>();

        boolean csvImportado = false;
        Part csvFile = null;
        try {
            csvFile = request.getPart("csvFile");
        } catch (Exception ignored) {
        }

        if (csvFile != null && csvFile.getSize() > 0) {
            System.out.println("[ConfirmarEncomendaFornecedorServlet] CSV recebido, size=" + csvFile.getSize());
            try (BufferedReader reader = new BufferedReader(new InputStreamReader(csvFile.getInputStream(), "UTF-8"))) {
                String line;
                boolean firstLine = true;
                while ((line = reader.readLine()) != null) {
                    if (firstLine) {
                        firstLine = false;
                        continue; // cabeçalho
                    }
                    if (line.trim().isEmpty()) continue;
                    String[] cols = line.split(";", -1);
                    // formato download: id_encomenda;id_linhaenc;id_produto;produto;quantidade;preco_info;data_validade;data_prevista;custo_envio
                    if (cols.length >= 9) {
                        try {
                            int idLinha = Integer.parseInt(cols[1].trim());
                            int qtdCsv = Integer.parseInt(cols[4].trim());
                            // validade por linha (fluxo antigo)
                            Date validade = parseDateFlexible(cols[6]);
                            if (validade != null) validadePorLinha.put(idLinha, validade);
                            // lotes por linha (fluxo novo CSV)
                            lotesPorLinhaCsv.computeIfAbsent(idLinha, k -> new ArrayList<>())
                                           .add(new LoteSplit(qtdCsv, validade));

                            // data prevista (global da encomenda) só preenche se formulário não trouxe valor
                            if ((request.getParameter("data_prevista") == null || request.getParameter("data_prevista").isBlank())
                                    && cols[7] != null && !cols[7].trim().isEmpty()) {
                                Date dpCsv = parseDateFlexible(cols[7].trim());
                                if (dpCsv != null) dataPrevista = dpCsv;
                            }

                            if (cols[8] != null && !cols[8].trim().isEmpty()) {
                                custoEnvio = Float.parseFloat(cols[8].trim().replace(",", "."));
                            }
                           

                            csvImportado = true;
                            System.out.println("[ConfirmarEncomendaFornecedorServlet] linha csv ok -> idLinha=" + idLinha + ", validade=" + validade);
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

        if (csvImportado && !lotesPorLinhaCsv.isEmpty()) {
            lotesPorLinha.putAll(lotesPorLinhaCsv);
            System.out.println("[ConfirmarEncomendaFornecedorServlet] lotes carregados do CSV, linhas=" + lotesPorLinha.size());
        } else {
            // Lê lotes por regex para apanhar SEMPRE campos dinâmicos "qtd_lote_<id>[_extra_<x>]"
            Pattern lotePattern = Pattern.compile("^qtd_lote_(\\d+)(.*)$");
            for (String paramName : request.getParameterMap().keySet()) {
                Matcher matcher = lotePattern.matcher(paramName);
                if (!matcher.matches()) continue;
                try {
                    int idLinha = Integer.parseInt(matcher.group(1));
                    String sufixo = matcher.group(2) == null ? "" : matcher.group(2);
                    String qtdStr = request.getParameter(paramName);
                    if (qtdStr == null || qtdStr.isBlank()) continue;

                    double qtdDouble = Double.parseDouble(qtdStr.replace(",", "."));
                    int qtd = (int) Math.round(qtdDouble);
                    if (qtd <= 0) continue;

                    String validadeParam = "validade_" + idLinha + sufixo;
                    Date validade = parseDateFlexible(request.getParameter(validadeParam));

                    lotesPorLinha.computeIfAbsent(idLinha, k -> new ArrayList<>()).add(new LoteSplit(qtd, validade));
                    System.out.println("[ConfirmarEncomendaFornecedorServlet] lote campo=" + paramName + " -> idLinha=" + idLinha + ", qtd=" + qtd + ", validade=" + validade);
                } catch (Exception ignored) {
                }
            }
        }

        EncomendaDAO dao = new EncomendaDAO();
        System.out.println("[ConfirmarEncomendaFornecedorServlet] custoEnvio=" + custoEnvio + ", dataPrevista=" + dataPrevista + ", validades=" + validadePorLinha.size() + ", lotesLinhas=" + lotesPorLinha.size());
        for (Map.Entry<Integer, List<LoteSplit>> e : lotesPorLinha.entrySet()) {
            Integer idLinha = e.getKey();
            List<LoteSplit> lotes = e.getValue();
            for (int i = 0; i < lotes.size(); i++) {
                LoteSplit lote = lotes.get(i);
                System.out.println("[ConfirmarEncomendaFornecedorServlet] lote idLinha=" + idLinha + " idx=" + i + " qtd=" + lote.getQuantidade() + " validade=" + lote.getValidade());
            }
        }
        boolean ok;
        if (!lotesPorLinha.isEmpty()) {
            System.out.println("[ConfirmarEncomendaFornecedorServlet] fluxo=confirmarFornecedorComLotes");
            ok = dao.confirmarFornecedorComLotes(idEncomenda, custoEnvio, dataPrevista, lotesPorLinha);
        } else {
            System.out.println("[ConfirmarEncomendaFornecedorServlet] fluxo=confirmarFornecedor");
            ok = dao.confirmarFornecedor(idEncomenda, custoEnvio, dataPrevista, validadePorLinha);
        }
        System.out.println("[ConfirmarEncomendaFornecedorServlet] resultado=" + ok);
        if (ok) {
            request.getSession().setAttribute("mensagemSucesso", "Encomenda confirmada com sucesso.");
        } else {
            request.getSession().setAttribute("mensagemErro", "Erro ao confirmar encomenda.");
        }
        response.sendRedirect(request.getContextPath() + "/EncomendasServlet");
    }
}
    
