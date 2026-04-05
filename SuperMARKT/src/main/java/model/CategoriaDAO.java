package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import DBconnection.DBconnection;

public class CategoriaDAO {

	public List<Categoria> getAllCategorias() {
	    List<Categoria> categorias = new ArrayList<>();
	    String sql = "SELECT * FROM categoria";

	    try (Connection conn = DBconnection.getConnection();
	         PreparedStatement stmt = conn.prepareStatement(sql);
	         ResultSet rs = stmt.executeQuery()) {

	        while (rs.next()) {
	            Categoria c = new Categoria();
	            c.setIdCategoria(rs.getInt("id_categoria"));
	            c.setNome(rs.getString("nome"));
	            c.setDescricao(rs.getString("descricao"));
	            categorias.add(c);
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	        throw new RuntimeException(e);
	    }
	    return categorias;
	}
}
