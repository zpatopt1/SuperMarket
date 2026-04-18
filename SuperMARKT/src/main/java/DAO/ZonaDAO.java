package DAO;

import java.sql.Connection;
import java.sql.*;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import DBconnection.DBconnection;
import model.Categoria;
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
	            local.setNome(rs.getString("local_nome")); // ✔️ corrigido
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

// ➕ Inserir zona
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

// ✏️ Atualizar zona
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
}

