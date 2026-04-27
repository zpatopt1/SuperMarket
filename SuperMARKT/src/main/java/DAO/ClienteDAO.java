package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import DBconnection.DBconnection;
import model.Cliente;

public class ClienteDAO {

    public List<Cliente> getClientes(String nomePesquisa, String orderBy, String orderDir, int pageSize, int offset) {
        List<Cliente> clientes = new ArrayList<>();
        List<String> colunasValidas = List.of("id_cliente", "nome", "contacto", "nif");

        if (orderBy == null || !colunasValidas.contains(orderBy)) {
            orderBy = "id_cliente";
        }
        if (orderDir == null || !"DESC".equalsIgnoreCase(orderDir)) {
            orderDir = "ASC";
        }

        StringBuilder sql = new StringBuilder("SELECT id_cliente, nome, contacto, nif FROM cliente ");
        if (nomePesquisa != null && !nomePesquisa.isBlank()) {
            sql.append("WHERE nome LIKE ? ");
        }
        sql.append("ORDER BY ").append(orderBy).append(" ").append(orderDir).append(" ");
        sql.append("LIMIT ? OFFSET ?");

        try (Connection conn = DBconnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            int index = 1;
            if (nomePesquisa != null && !nomePesquisa.isBlank()) {
                stmt.setString(index++, "%" + nomePesquisa + "%");
            }
            stmt.setInt(index++, pageSize);
            stmt.setInt(index, offset);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Cliente c = new Cliente();
                    c.setIdCliente(rs.getInt("id_cliente"));
                    c.setNome(rs.getString("nome"));
                    c.setContacto(rs.getString("contacto"));
                    c.setNif(rs.getString("nif"));
                    clientes.add(c);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }

        return clientes;
    }

    public int getTotalClientes(String nomePesquisa) {
        int total = 0;
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM cliente ");
        if (nomePesquisa != null && !nomePesquisa.isBlank()) {
            sql.append("WHERE nome LIKE ?");
        }

        try (Connection conn = DBconnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            if (nomePesquisa != null && !nomePesquisa.isBlank()) {
                stmt.setString(1, "%" + nomePesquisa + "%");
            }

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    total = rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }

        return total;
    }

    public void insertCliente(Cliente cliente) {
        String sql = "INSERT INTO cliente (nome, contacto, nif) VALUES (?, ?, ?)";

        try (Connection conn = DBconnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, cliente.getNome());
            stmt.setString(2, cliente.getContacto());
            stmt.setString(3, cliente.getNif());
            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    public boolean updateCliente(Cliente cliente) {
        String sql = "UPDATE cliente SET nome = ?, contacto = ?, nif = ? WHERE id_cliente = ?";

        try (Connection conn = DBconnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, cliente.getNome());
            stmt.setString(2, cliente.getContacto());
            stmt.setString(3, cliente.getNif());
            stmt.setInt(4, cliente.getIdCliente());
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    public boolean deleteCliente(int idCliente) {
        String sql = "DELETE FROM cliente WHERE id_cliente = ?";

        try (Connection conn = DBconnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idCliente);
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    public Cliente selectCliente(int idCliente) {
        String sql = "SELECT id_cliente, nome, contacto, nif FROM cliente WHERE id_cliente = ?";
        Cliente cliente = null;

        try (Connection conn = DBconnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idCliente);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    cliente = new Cliente();
                    cliente.setIdCliente(rs.getInt("id_cliente"));
                    cliente.setNome(rs.getString("nome"));
                    cliente.setContacto(rs.getString("contacto"));
                    cliente.setNif(rs.getString("nif"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }

        return cliente;
    }
}
