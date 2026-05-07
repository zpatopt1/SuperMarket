package controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;

import DAO.ProdutoDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@WebServlet("/ImportarProdutosServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
    maxFileSize = 1024 * 1024 * 10,      // 10 MB
    maxRequestSize = 1024 * 1024 * 15    // 15 MB
)
public class ImportarProdutosServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("template".equals(action)) {
            response.setContentType("text/csv");
            response.setHeader("Content-Disposition", "attachment; filename=\"template_produtos.csv\"");
            response.getWriter().write("Categoria,Unidade de Medida,Marca,Nome do Produto,Codigo de Barras,Preco,Quantidade\n");
            response.getWriter().write("Bebidas,L,MarcaExemplo,Agua 1.5L,1234567890123,0.50,100\n");
            return;
        }
        
        request.getRequestDispatcher("/Front-end/pages/importar_produtos.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Part filePart = request.getPart("csvFile");
        
        if (filePart == null || filePart.getSize() == 0) {
            request.setAttribute("erro", "Nenhum ficheiro foi enviado.");
            doGet(request, response);
            return;
        }

        String fileName = filePart.getSubmittedFileName();
        if (!fileName.toLowerCase().endsWith(".csv")) {
            request.setAttribute("erro", "Formato inválido. Apenas ficheiros .csv são aceites.");
            doGet(request, response);
            return;
        }

        List<String[]> linhas = new ArrayList<>();
        
        try (InputStream fileContent = filePart.getInputStream();
             BufferedReader reader = new BufferedReader(new InputStreamReader(fileContent, "UTF-8"))) {
            
            String line;
            boolean firstLine = true;
            
            while ((line = reader.readLine()) != null) {
                if (firstLine) {
                    firstLine = false; // Ignorar o cabeçalho
                    continue;
                }
                
                if (line.trim().isEmpty()) continue;
                
                // Dividir por vírgula ou ponto e vírgula
                String[] campos = line.split("[,;]");
                
                if (campos.length >= 7) {
                    linhas.add(campos);
                }
            }
            
            if (linhas.isEmpty()) {
                request.setAttribute("erro", "O ficheiro está vazio ou não tem dados no formato correto.");
            } else {
                ProdutoDAO dao = new ProdutoDAO();
                int importados = dao.importarProdutosCSV(linhas);
                request.setAttribute("sucesso", importados + " produtos foram importados com sucesso!");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("erro", "Erro ao importar: " + e.getMessage());
        }

        doGet(request, response);
    }
}
