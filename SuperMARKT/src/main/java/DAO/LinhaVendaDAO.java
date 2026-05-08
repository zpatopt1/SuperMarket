package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;

import DBconnection.DBconnection;
import model.LinhaVenda;

public class LinhaVendaDAO {

    public void inserir(LinhaVenda linha) {
        
        String sql = "INSERT INTO linha_venda (id_venda, id_produto, quantidade, preco_venda, iva, subtotal, desconto) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBconnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            
        	stmt.setInt(1, linha.getIdMovimentos().getIdMovimentos().getIdMovimentos());

            
            stmt.setInt(2, linha.getIdProduto().getIdProduto());

            
            stmt.setInt(3, linha.getQuantidade());
            stmt.setFloat(4, linha.getPrecoVenda());
            stmt.setFloat(5, linha.getIva());
            stmt.setFloat(6, linha.getSubtotal());
            stmt.setFloat(7, linha.getDesconto());

            
            stmt.executeUpdate();

        } catch (Exception e) {
            System.out.println("Erro ao criar Linha de Venda: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
