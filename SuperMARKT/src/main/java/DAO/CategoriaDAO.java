package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import DBconnection.DBconnection;
import model.Categoria;

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
	
	public boolean deleteCategoria(int idCategoria) {
	    String sql = "DELETE FROM categoria WHERE id_categoria = ?";
	    System.out.print(sql);
	    try (Connection conn = DBconnection.getConnection();
	         PreparedStatement stmt = conn.prepareStatement(sql)) {

	        stmt.setInt(1, idCategoria);
	        int rows = stmt.executeUpdate();
	        return rows > 0;

	    } catch (Exception e) {
	        e.printStackTrace();
	        throw new RuntimeException(e);
	    }
	}
	
	public Categoria selectCategoria(int idCategoria) {
	    String sql = "SELECT * FROM categoria WHERE id_categoria = ?";
	    Categoria c = null;

	    try (Connection conn = DBconnection.getConnection();
	         PreparedStatement stmt = conn.prepareStatement(sql)) {

	        stmt.setInt(1, idCategoria);
	        try (ResultSet rs = stmt.executeQuery()) {
	            if (rs.next()) {
	                c = new Categoria();
	                c.setIdCategoria(rs.getInt("id_categoria"));
	                c.setNome(rs.getString("nome"));
	                c.setDescricao(rs.getString("descricao"));
	            }
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	        throw new RuntimeException(e);
	    }
	    return c;
	}
	
	public boolean updateCategoria(Categoria categoria) {
	    String sql = "UPDATE categoria SET nome = ?, descricao = ? WHERE id_categoria = ?";

	    try (Connection conn = DBconnection.getConnection();
	         PreparedStatement stmt = conn.prepareStatement(sql)) {

	        stmt.setString(1, categoria.getNome());
	        stmt.setString(2, categoria.getDescricao());
	        stmt.setInt(3, categoria.getIdCategoria());

	        int rows = stmt.executeUpdate();
	        return rows > 0;

	    } catch (Exception e) {
	        e.printStackTrace();
	        throw new RuntimeException(e);
	    }
	}
	

	public void insertCategoria(Categoria categoria) {
    	String sql = "INSERT INTO categoria (nome, descricao) VALUES (?, ?)";

    	try (Connection conn = DBconnection.getConnection();
    	     PreparedStatement stmt = conn.prepareStatement(sql)) {

    	    stmt.setString(1, categoria.getNome());
    	    stmt.setString(2, categoria.getDescricao());
    	    stmt.executeUpdate();

    	} catch (Exception e) {
    	    e.printStackTrace();
    	    throw new RuntimeException(e);
    	}
	}
	}
