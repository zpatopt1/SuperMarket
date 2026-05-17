package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.ArrayList;
import java.util.List;

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

    
    public List<String[]> getProdutosDaVenda(int idVenda) {
        List<String[]> produtos = new ArrayList<>();
        
        
        String sql = "SELECT lv.id_linhavenda, p.nome, lv.quantidade, lv.subtotal " +
                     "FROM linha_venda lv " +
                     "INNER JOIN produto p ON lv.id_produto = p.id_produto " +
                     "WHERE lv.id_venda = ?";

        try (Connection conn = DBconnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idVenda);
            
            try (java.sql.ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    
                    String idLinha = String.valueOf(rs.getInt("id_linhavenda"));
                    String nome = rs.getString("nome");
                    String qtd = String.valueOf(rs.getInt("quantidade"));
                    String subtotal = String.valueOf(rs.getFloat("subtotal"));

                    
                    produtos.add(new String[]{idLinha, nome, qtd, subtotal});
                }
            }
        } catch (Exception e) {
            System.out.println("Erro ao buscar produtos da fatura na BD: " + e.getMessage());
            e.printStackTrace();
        }
        return produtos;
    }
}