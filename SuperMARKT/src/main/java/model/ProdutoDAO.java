package model;

import java.sql.Connection;
import java.sql.*;
import java.sql.PreparedStatement;

import DBconnection.DBconnection;

public class ProdutoDAO {
	//CRUD - Create
	public void insert(Produto produto) {
		
		String sql = "INSERT INTO produto (id_produto, id_categoria, unidade_medida, marca, nome, cod_barras, preco) VALUES (?, ?, ?, ?, ?, ?, ?)";

		try (Connection conn = DBconnection.getConnection();
	    	PreparedStatement stmt = conn.prepareStatement(sql)){

	    	stmt.setInt(1, produto.getIdProduto());
            stmt.setInt(2, produto.getCategoria().getIdCategoria()); // Pegamos o ID do objeto Categoria
            stmt.setString(3, produto.getUnidadeMedida());
            stmt.setString(4, produto.getMarca());
            stmt.setString(5, produto.getNome());
            stmt.setString(6, produto.getCodBarras());
            stmt.setFloat(7, produto.getPreco());
            
            int rows = stmt.executeUpdate();        
            
            if (rows > 0) {
                System.out.println("Produto salvo com sucesso!");
            } else {
                System.out.println("Nenhum produto foi inserido!");
            }
            } catch (Exception e) {
			e.printStackTrace();
		    throw new RuntimeException(e); 

		}
	}
}
