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
}