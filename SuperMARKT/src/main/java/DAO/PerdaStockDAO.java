package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

import DBconnection.DBconnection;
import model.PerdaStock;

public class PerdaStockDAO {

    private StockLocalDAO stockLocalDAO;

    public PerdaStockDAO() {
        this.stockLocalDAO = new StockLocalDAO();
    }

    public boolean registarPerda(PerdaStock perda, String nifFuncionario) throws Exception {
        String insertMovimentoSql = "INSERT INTO movimentos (nif, status, data, hora) VALUES (?, 'Concluído', CURDATE(), CURTIME())";
        String insertPerdaSql = "INSERT INTO perda_stock (id_perda, id_produto, id_local, quantidade, motivo) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DBconnection.getConnection()) {
            conn.setAutoCommit(false); // Iniciar transação

            try {
                int idMovimento = -1;

                // 1. Inserir na tabela movimentos
                try (PreparedStatement stmtMov = conn.prepareStatement(insertMovimentoSql, Statement.RETURN_GENERATED_KEYS)) {
                    stmtMov.setString(1, nifFuncionario);
                    stmtMov.executeUpdate();
                    
                    try (ResultSet rsKeys = stmtMov.getGeneratedKeys()) {
                        if (rsKeys.next()) {
                            idMovimento = rsKeys.getInt(1);
                        } else {
                            throw new Exception("Falha ao gerar o ID do movimento.");
                        }
                    }
                }

                // 2. Inserir na tabela perda_stock
                try (PreparedStatement stmtPerda = conn.prepareStatement(insertPerdaSql)) {
                    stmtPerda.setInt(1, idMovimento);
                    stmtPerda.setInt(2, perda.getProduto().getIdProduto());
                    stmtPerda.setInt(3, perda.getLocal().getIdLocal());
                    stmtPerda.setInt(4, perda.getQuantidade());
                    stmtPerda.setString(5, perda.getMotivo());
                    stmtPerda.executeUpdate();
                }

                // 3. Abater stock
                stockLocalDAO.reduzirStock(perda.getProduto().getIdProduto(), perda.getLocal().getIdLocal(), perda.getQuantidade(), conn);

                conn.commit();
                return true;
            } catch (Exception e) {
                conn.rollback();
                throw e;
            } finally {
                conn.setAutoCommit(true);
            }
        }
    }
}
