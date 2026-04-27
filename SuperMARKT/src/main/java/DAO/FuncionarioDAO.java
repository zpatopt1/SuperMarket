package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import DBconnection.DBconnection;
import model.Funcao;
import model.Funcionario;

public class FuncionarioDAO {

    public Funcionario autenticar(String email, String password) {
        String sql = "SELECT f.nif, f.nome, f.contacto, f.email, f.ativo, " +
                "fn.id_funcao, fn.descricao " +
                "FROM funcionario f " +
                "INNER JOIN funcao fn ON fn.id_funcao = f.id_funcao " +
                "WHERE f.email = ? AND f.password = ? AND f.ativo = TRUE";

        try (Connection conn = DBconnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);
            stmt.setString(2, password);

            try (ResultSet rs = stmt.executeQuery()) {
                if (!rs.next()) {
                    return null;
                }

                Funcao funcao = new Funcao(rs.getInt("id_funcao"), rs.getString("descricao"));
                Funcionario funcionario = new Funcionario();
                funcionario.setNif(rs.getString("nif"));
                funcionario.setNome(rs.getString("nome"));
                funcionario.setContacto(rs.getString("contacto"));
                funcionario.setEmail(rs.getString("email"));
                funcionario.setAtivo(rs.getBoolean("ativo"));
                funcionario.setIdFuncao(funcao);
                return funcionario;
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    public List<Funcionario> getAllFuncionarios() {
        String sql = "SELECT f.nif, f.nome, f.contacto, f.email, f.ativo, fn.id_funcao, fn.descricao " +
                "FROM funcionario f " +
                "INNER JOIN funcao fn ON fn.id_funcao = f.id_funcao " +
                "ORDER BY f.nome ASC";
        List<Funcionario> lista = new ArrayList<>();

        try (Connection conn = DBconnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Funcao funcao = new Funcao(rs.getInt("id_funcao"), rs.getString("descricao"));
                Funcionario funcionario = new Funcionario();
                funcionario.setNif(rs.getString("nif"));
                funcionario.setNome(rs.getString("nome"));
                funcionario.setContacto(rs.getString("contacto"));
                funcionario.setEmail(rs.getString("email"));
                funcionario.setAtivo(rs.getBoolean("ativo"));
                funcionario.setIdFuncao(funcao);
                lista.add(funcionario);
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }

        return lista;
    }

    public void insertFuncionario(Funcionario funcionario) {
        String sql = "INSERT INTO funcionario (nif, id_funcao, nome, contacto, email, password, ativo) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBconnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, funcionario.getNif());
            stmt.setInt(2, funcionario.getIdFuncao().getIdFuncao());
            stmt.setString(3, funcionario.getNome());
            stmt.setString(4, funcionario.getContacto());
            stmt.setString(5, funcionario.getEmail());
            stmt.setString(6, funcionario.getPassword());
            stmt.setBoolean(7, funcionario.isAtivo());
            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    public boolean deleteFuncionario(String nif) {
        String sql = "DELETE FROM funcionario WHERE nif = ?";

        try (Connection conn = DBconnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, nif);
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    public boolean updateFuncionario(Funcionario funcionario, boolean updatePassword) {
        String sql;
        if (updatePassword) {
            sql = "UPDATE funcionario SET id_funcao = ?, nome = ?, contacto = ?, email = ?, password = ?, ativo = ? WHERE nif = ?";
        } else {
            sql = "UPDATE funcionario SET id_funcao = ?, nome = ?, contacto = ?, email = ?, ativo = ? WHERE nif = ?";
        }

        try (Connection conn = DBconnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            int idx = 1;
            stmt.setInt(idx++, funcionario.getIdFuncao().getIdFuncao());
            stmt.setString(idx++, funcionario.getNome());
            stmt.setString(idx++, funcionario.getContacto());
            stmt.setString(idx++, funcionario.getEmail());

            if (updatePassword) {
                stmt.setString(idx++, funcionario.getPassword());
            }

            stmt.setBoolean(idx++, funcionario.isAtivo());
            stmt.setString(idx, funcionario.getNif());
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }
}
