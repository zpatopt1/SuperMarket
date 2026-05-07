package DAO;

import java.sql.Connection;
import java.sql.*;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import DBconnection.DBconnection;
import model.Local;
import model.Zona;

public class ZonaDAO {

	public List<Zona> getAllZonas() {
	    List<Zona> zonas = new ArrayList<>();

	    String sql = "SELECT z.id_zona, z.nome AS zona_nome, z.id_local, " +
	                 "l.nome AS local_nome, l.tipo_local " +
	                 "FROM zona z " +
	                 "INNER JOIN local l ON z.id_local = l.id_local";

	    try (Connection conn = DBconnection.getConnection();
	         PreparedStatement stmt = conn.prepareStatement(sql);
	         ResultSet rs = stmt.executeQuery()) {

	        while (rs.next()) {
	            Zona zona = new Zona();
	            zona.setIdZona(rs.getInt("id_zona"));
	            zona.setNome(rs.getString("zona_nome"));

	            Local local = new Local();
	            local.setIdLocal(rs.getInt("id_local"));
	            local.setNome(rs.getString("local_nome")); 
	            local.setTipoLocal(rs.getString("tipo_local"));

	            zona.setLocal(local);

	            zonas.add(zona);
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	        throw new RuntimeException(e);
	    }

	    return zonas;
	}

public boolean insertZona(Zona zona) {
    String sql = "INSERT INTO zona (nome, id_local) VALUES (?, ?)";

    try (Connection conn = DBconnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {

        stmt.setString(1, zona.getNome());
        stmt.setInt(2, zona.getLocal().getIdLocal());

        return stmt.executeUpdate() > 0;

    } catch (Exception e) {
        e.printStackTrace();
        throw new RuntimeException(e);
    }
}

public boolean updateZona(Zona zona) {
    String sql = "UPDATE zona SET nome = ?, id_local = ? WHERE id_zona = ?";

    try (Connection conn = DBconnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {

        stmt.setString(1, zona.getNome());
        stmt.setInt(2, zona.getLocal().getIdLocal());
        stmt.setInt(3, zona.getIdZona());

        return stmt.executeUpdate() > 0;

    } catch (Exception e) {
        e.printStackTrace();
        throw new RuntimeException(e);
    }
}

// ❌ Apagar zona
public boolean deleteZona(int idZona) {
    String sql = "DELETE FROM zona WHERE id_zona = ?";

    try (Connection conn = DBconnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {

        stmt.setInt(1, idZona);

        return stmt.executeUpdate() > 0;

    } catch (Exception e) {
        e.printStackTrace();
        throw new RuntimeException(e);
    }
}
    public int getTotalZonas() {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM zona";
        try (Connection conn = DBconnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) count = rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return count;
    }

    public String getZonaMaisOcupada() {
        String nome = "N/A";
        String sql = "SELECT z.nome FROM zona z JOIN stock_local sl ON z.id_zona = sl.id_zona GROUP BY z.id_zona ORDER BY SUM(sl.quantidade) DESC LIMIT 1";
        try (Connection conn = DBconnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) nome = rs.getString(1);
        } catch (Exception e) { e.printStackTrace(); }
        return nome;
    }
}

