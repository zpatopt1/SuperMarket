package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

import DBconnection.DBconnection;
import model.Movimentos;

public class MovimentosDAO {

    
    public int inserir(Movimentos movimento) {
        int idGerado = -1; 
        
        
        String sql = "INSERT INTO movimentos (nif, status, data, hora) VALUES (?, ?, CURDATE(), CURTIME())";

        
        try (Connection conn = DBconnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            
        		stmt.setString(1, movimento.getFuncionario().getNif());
            stmt.setString(2, "Venda Concluída"); 
            
    
            stmt.executeUpdate();

            
            try (ResultSet rs = stmt.getGeneratedKeys()) {
                if (rs.next()) {
                    idGerado = rs.getInt(1); 
                }
            }

        } catch (Exception e) {
            System.out.println("Erro ao criar Movimento: " + e.getMessage());
            e.printStackTrace();
        }

        return idGerado; 
    }
}