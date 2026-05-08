package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import model.Devolucao;
import DBconnection.DBconnection;

public class DevolucaoDAO {

    public void inserir(Devolucao dev) throws SQLException, Exception {
        Connection conn = null;
        PreparedStatement stmtMov = null;
        PreparedStatement stmtDev = null;
        ResultSet rsMov = null;
        ResultSet rsNif = null;

        try {
            conn = DBconnection.getConnection();
            
            
            String nifFuncionario = "000000000"; 
            Statement stmtBusca = conn.createStatement();
            rsNif = stmtBusca.executeQuery("SELECT nif FROM funcionario LIMIT 1");
            if (rsNif.next()) {
                nifFuncionario = rsNif.getString("nif");
            }

            
            String sqlMovimento = "INSERT INTO movimentos (nif, status, data, hora) VALUES (?, 'Devolucao', CURDATE(), CURTIME())";
            stmtMov = conn.prepareStatement(sqlMovimento, Statement.RETURN_GENERATED_KEYS);
            stmtMov.setString(1, nifFuncionario);
            stmtMov.executeUpdate();

            
            int idGerado = -1;
            rsMov = stmtMov.getGeneratedKeys();
            if (rsMov.next()) {
                idGerado = rsMov.getInt(1);
            }

            if (idGerado == -1) {
                throw new Exception("Falha ao gerar o ID do Movimento.");
            }

            
            String sqlDevolucao = "INSERT INTO devolucao (id_devolucao, id_linhavenda, motivo, quantidade, valor, repor_stock) VALUES (?, ?, ?, ?, ?, ?)";
            stmtDev = conn.prepareStatement(sqlDevolucao);
            
            stmtDev.setInt(1, idGerado); 
            
            
            stmtDev.setInt(2, dev.getIdLinhavenda().getIdLinhaVenda()); 
            
            stmtDev.setString(3, dev.getMotivo());
            stmtDev.setInt(4, dev.getQuantidade());
            stmtDev.setFloat(5, dev.getValor());
            stmtDev.setInt(6, dev.isReporStock() ? 1 : 0);

            stmtDev.executeUpdate();
            System.out.println("SUCESSO TOTAL! Movimento criado (ID: " + idGerado + ") e Devolução gravada!");

        } catch (Exception e) {
            System.err.println("ERRO NA GRAVAÇÃO DA DEVOLUÇÃO: " + e.getMessage());
            throw e;
        } finally {
            
            if(rsNif != null) rsNif.close();
            if(rsMov != null) rsMov.close();
            if(stmtMov != null) stmtMov.close();
            if(stmtDev != null) stmtDev.close();
            if(conn != null) conn.close();
        }
    }
}