package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import DBconnection.DBconnection;
import model.Fornecedor;
import model.FornecedorProduto;
import model.Produto;

public class FornecedorProdutoDAO {

    public List<FornecedorProduto> getAll() {
        List<FornecedorProduto> lista = new ArrayList<>();
        String sql = "SELECT fp.id_fornecedor, fp.id_produto, fp.preco, " +
                "f.tipo_fornecedor, f.contacto, f.nif, " +
                "p.nome AS produto_nome, p.cod_barras " +
                "FROM fornecedor_produto fp " +
                "INNER JOIN fornecedor f ON f.id_fornecedor = fp.id_fornecedor " +
                "INNER JOIN produto p ON p.id_produto = fp.id_produto " +
                "ORDER BY fp.id_fornecedor, fp.id_produto";

        try (Connection conn = DBconnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Fornecedor fornecedor = new Fornecedor();
                fornecedor.setIdFornecedor(rs.getInt("id_fornecedor"));
                fornecedor.setTipoFornecedor(rs.getString("tipo_fornecedor"));
                fornecedor.setContacto(rs.getString("contacto"));
                fornecedor.setNif(rs.getString("nif"));

                Produto produto = new Produto();
                produto.setIdProduto(rs.getInt("id_produto"));
                produto.setNome(rs.getString("produto_nome"));
                produto.setCodBarras(rs.getString("cod_barras"));

                FornecedorProduto fp = new FornecedorProduto();
                fp.setFornecedor(fornecedor);
                fp.setProduto(produto);
                fp.setPreco(rs.getFloat("preco"));
                lista.add(fp);
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
        return lista;
    }

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

    public List<Produto> getAllProdutos() {
        List<Produto> lista = new ArrayList<>();
        String sql = "SELECT id_produto, nome, cod_barras FROM produto ORDER BY id_produto";
        try (Connection conn = DBconnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Produto p = new Produto();
                p.setIdProduto(rs.getInt("id_produto"));
                p.setNome(rs.getString("nome"));
                p.setCodBarras(rs.getString("cod_barras"));
                lista.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
        return lista;
    }

    public boolean insert(int idFornecedor, int idProduto, float preco) {
        String sql = "INSERT INTO fornecedor_produto (id_fornecedor, id_produto, preco) VALUES (?, ?, ?)";
        try (Connection conn = DBconnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idFornecedor);
            stmt.setInt(2, idProduto);
            stmt.setFloat(3, preco);
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    public boolean update(int idFornecedor, int idProduto, float preco) {
        String sql = "UPDATE fornecedor_produto SET preco = ? WHERE id_fornecedor = ? AND id_produto = ?";
        try (Connection conn = DBconnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setFloat(1, preco);
            stmt.setInt(2, idFornecedor);
            stmt.setInt(3, idProduto);
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    public boolean delete(int idFornecedor, int idProduto) {
        String sql = "DELETE FROM fornecedor_produto WHERE id_fornecedor = ? AND id_produto = ?";
        try (Connection conn = DBconnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idFornecedor);
            stmt.setInt(2, idProduto);
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }
}
