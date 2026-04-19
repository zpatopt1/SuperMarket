package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import DBconnection.DBconnection;
import model.Local;

public class LocalDAO {

    public List<Local> getAllLocais() {
        List<Local> locais = new ArrayList<>();
        String sql = "SELECT * FROM local";

        try (Connection conn = DBconnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Local local = new Local();
                local.setIdLocal(rs.getInt("id_local"));
                local.setNome(rs.getString("nome"));
                local.setTipoLocal(rs.getString("tipo_local"));
                locais.add(local);
            }

        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
        return locais;
    }

    public Local selectLocal(int idLocal) {
        String sql = "SELECT * FROM local WHERE id_local = ?";
        Local local = null;

        try (Connection conn = DBconnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idLocal);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    local = new Local();
                    local.setIdLocal(rs.getInt("id_local"));
                    local.setNome(rs.getString("nome"));
                    local.setTipoLocal(rs.getString("tipo_local"));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
        return local;
    }

    public boolean insertLocal(Local local) {
        String sql = "INSERT INTO local (nome, tipo_local) VALUES (?, ?)";

        try (Connection conn = DBconnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, local.getNome());
            stmt.setString(2, local.getTipoLocal());
            return stmt.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    public boolean updateLocal(Local local) {
        String sql = "UPDATE local SET nome = ?, tipo_local = ? WHERE id_local = ?";

        try (Connection conn = DBconnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, local.getNome());
            stmt.setString(2, local.getTipoLocal());
            stmt.setInt(3, local.getIdLocal());
            return stmt.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    public boolean deleteLocal(int idLocal) {
        String sql = "DELETE FROM local WHERE id_local = ?";

        try (Connection conn = DBconnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idLocal);
            return stmt.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }
}
