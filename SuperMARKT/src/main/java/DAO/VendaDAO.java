package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;

import DBconnection.DBconnection;
import model.Venda;

public class VendaDAO {

    
    public void inserir(Venda venda) {
        
        String sql = "INSERT INTO venda (id_venda, id_cliente, valor_total) VALUES (?, ?, ?)";

        try (Connection conn = DBconnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, venda.getIdMovimentos().getIdMovimentos());

            if (venda.getIdCliente() != null) {
                stmt.setInt(2, venda.getIdCliente().getIdCliente()); 
            } else {
                stmt.setNull(2, java.sql.Types.INTEGER);
            }

            stmt.setFloat(3, venda.getValorTotal());

            stmt.executeUpdate();

        } catch (Exception e) {
            System.out.println("Erro ao criar Venda: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    
    public boolean reembolsarVenda(int idVenda) {
        
        String sqlReporStock = "UPDATE stock_local s " +
                               "INNER JOIN linha_venda lv ON s.id_produto = lv.id_produto " +
                               "SET s.quantidade = s.quantidade + lv.quantidade " +
                               "WHERE lv.id_venda = ?";

        
        String sqlApagarLinhas = "DELETE FROM linha_venda WHERE id_venda = ?";
        String sqlApagarVenda = "DELETE FROM venda WHERE id_venda = ?";

        try (Connection conn = DBconnection.getConnection()) { 
            
            
            try (PreparedStatement stmt = conn.prepareStatement(sqlReporStock)) {
                stmt.setInt(1, idVenda);
                stmt.executeUpdate();
            }
            
            
            try (PreparedStatement stmt = conn.prepareStatement(sqlApagarLinhas)) {
                stmt.setInt(1, idVenda);
                stmt.executeUpdate();
            }
            
            
            try (PreparedStatement stmt = conn.prepareStatement(sqlApagarVenda)) {
                stmt.setInt(1, idVenda);
                stmt.executeUpdate();
            }
            
            return true; 
            
        } catch (Exception e) {
            System.out.println("Erro no reembolso: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}