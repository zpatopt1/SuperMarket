package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import DBconnection.DBconnection;
import model.Fornecedor;

public class FornecedorDAO {

    public List<Fornecedor> getAllFornecedores() {
        List<Fornecedor> lista = new ArrayList<>();
        String sql = "SELECT id_fornecedor, tipo_fornecedor, contacto, nif FROM fornecedor ORDER BY id_fornecedor";
        try (Connection conn = DBconnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Fornecedor f = new Fornecedor();
                f.setIdFornecedor(rs.getInt("id_fornecedor"));
                f.setTipoFornecedor(rs.getString("tipo_fornecedor"));
                f.setContacto(rs.getString("contacto"));
                f.setNif(rs.getString("nif"));
                lista.add(f);
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
        return lista;
    }

    public boolean insertFornecedor(Fornecedor fornecedor) {
        String sql = "INSERT INTO fornecedor (tipo_fornecedor, contacto, nif) VALUES (?, ?, ?)";
        try (Connection conn = DBconnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, fornecedor.getTipoFornecedor());
            stmt.setString(2, fornecedor.getContacto());
            stmt.setString(3, fornecedor.getNif());
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    public boolean updateFornecedor(Fornecedor fornecedor) {
        String sql = "UPDATE fornecedor SET tipo_fornecedor = ?, contacto = ?, nif = ? WHERE id_fornecedor = ?";
        try (Connection conn = DBconnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, fornecedor.getTipoFornecedor());
            stmt.setString(2, fornecedor.getContacto());
            stmt.setString(3, fornecedor.getNif());
            stmt.setInt(4, fornecedor.getIdFornecedor());
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    public boolean deleteFornecedor(int idFornecedor) {
        String sql = "DELETE FROM fornecedor WHERE id_fornecedor = ?";
        try (Connection conn = DBconnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idFornecedor);
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }
}
