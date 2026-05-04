package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.LinkedHashMap;
import java.util.Map;

import DBconnection.DBconnection;

public class DashboardDAO {

    public int getTotalProdutos() {
        String sql = "SELECT COUNT(*) FROM produto";
        try (Connection conn = DBconnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getTotalUnidadesStock() {
        String sql = "SELECT SUM(quantidade) FROM stock_local";
        try (Connection conn = DBconnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public double getValorTotalStock() {
        String sql = "SELECT SUM(sl.quantidade * p.preco) FROM stock_local sl JOIN produto p ON sl.id_produto = p.id_produto";
        try (Connection conn = DBconnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) return rs.getDouble(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    public int getTotalFornecedores() {
        String sql = "SELECT COUNT(*) FROM fornecedor";
        try (Connection conn = DBconnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getTotalFuncionariosAtivos() {
        String sql = "SELECT COUNT(*) FROM funcionario WHERE ativo = TRUE";
        try (Connection conn = DBconnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getTotalPerdas() {
        String sql = "SELECT SUM(quantidade) FROM perda_stock";
        try (Connection conn = DBconnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Retorna nome do produto e a quantidade total dele em stock (se < limite)
    public Map<String, Integer> getProdutosBaixoStock(int limite) {
        Map<String, Integer> baixoStock = new LinkedHashMap<>();
        String sql = "SELECT p.nome, SUM(sl.quantidade) as total_qtd " +
                     "FROM stock_local sl " +
                     "JOIN produto p ON sl.id_produto = p.id_produto " +
                     "GROUP BY p.id_produto, p.nome " +
                     "HAVING total_qtd < ? " +
                     "ORDER BY total_qtd ASC";
        try (Connection conn = DBconnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, limite);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    baixoStock.put(rs.getString("nome"), rs.getInt("total_qtd"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return baixoStock;
    }
    
    // Retorna a distribuição de stock por categoria para o gráfico
    public Map<String, Integer> getDistribucaoStockPorCategoria() {
        Map<String, Integer> distribuicao = new LinkedHashMap<>();
        String sql = "SELECT c.nome, SUM(sl.quantidade) as total_qtd " +
                     "FROM stock_local sl " +
                     "JOIN produto p ON sl.id_produto = p.id_produto " +
                     "JOIN categoria c ON p.id_categoria = c.id_categoria " +
                     "GROUP BY c.id_categoria, c.nome " +
                     "ORDER BY total_qtd DESC";
        try (Connection conn = DBconnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                distribuicao.put(rs.getString("nome"), rs.getInt("total_qtd"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return distribuicao;
    }
}
