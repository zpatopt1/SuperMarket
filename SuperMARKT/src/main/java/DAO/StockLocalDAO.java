package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import DBconnection.DBconnection;
import model.Local;
import model.Produto;
import model.StockLocal;

public class StockLocalDAO {

    private static final String STOCK_SELECT_BASE =
            "SELECT s.quantidade, " +
            "p.id_produto, p.nome, p.marca, p.unidade_medida, p.cod_barras, p.preco, " +
            "c.id_categoria, c.nome AS nome_categoria, c.descricao AS desc_categoria, " +
            "l.id_local, l.nome AS local_nome, l.tipo_local " +
            "FROM stock_local s " +
            "INNER JOIN produto p ON s.id_produto = p.id_produto " +
            "INNER JOIN categoria c ON p.id_categoria = c.id_categoria " +
            "INNER JOIN `local` l ON s.id_local = l.id_local";

    public StockLocal selectStock(int idProduto, int idLocal) {
        String sql = "SELECT s.quantidade, " +
                     "p.id_produto, p.nome, p.marca, p.unidade_medida, p.cod_barras, p.preco, " +
                     "c.id_categoria, c.nome AS nome_categoria, c.descricao AS desc_categoria, " +
                     "l.id_local, l.nome AS local_nome, l.tipo_local " +
                     "FROM stock_local s " +
                     "INNER JOIN produto p ON s.id_produto = p.id_produto " +
                     "INNER JOIN categoria c ON p.id_categoria = c.id_categoria " +
                     "INNER JOIN `local` l ON s.id_local = l.id_local " +
                     "WHERE s.id_produto = ? AND s.id_local = ?";
        StockLocal stock = null;

        try (Connection conn = DBconnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idProduto);
            stmt.setInt(2, idLocal);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Produto produto = buildProduto(rs);
                    Local local = buildLocal(rs);
                    int quantidade = rs.getInt("quantidade");

                    stock = new StockLocal(produto, local, quantidade);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }

        return stock;
    }

    public List<StockLocal> getStockByProduto(int idProduto) {
        String sql = "SELECT s.quantidade, " +
                     "p.id_produto, p.nome, p.marca, p.unidade_medida, p.cod_barras, p.preco, " +
                     "c.id_categoria, c.nome AS nome_categoria, c.descricao AS desc_categoria, " +
                     "l.id_local, l.nome AS local_nome, l.tipo_local " +
                     "FROM stock_local s " +
                     "INNER JOIN produto p ON s.id_produto = p.id_produto " +
                     "INNER JOIN categoria c ON p.id_categoria = c.id_categoria " +
                     "INNER JOIN `local` l ON s.id_local = l.id_local " +
                     "WHERE s.id_produto = ?";
        List<StockLocal> lista = new ArrayList<>();

        try (Connection conn = DBconnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idProduto);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Produto produto = buildProduto(rs);
                    Local local = buildLocal(rs);
                    int quantidade = rs.getInt("quantidade");
                    lista.add(new StockLocal(produto, local, quantidade));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }

        return lista;
    }

    public List<StockLocal> getAllStock() {
        String sql = STOCK_SELECT_BASE;
        List<StockLocal> lista = new ArrayList<>();

        try (Connection conn = DBconnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Produto produto = buildProduto(rs);
                Local local = buildLocal(rs);
                int quantidade = rs.getInt("quantidade");
                lista.add(new StockLocal(produto, local, quantidade));
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }

        return lista;
    }

    public List<StockLocal> getStockFilteredOrdered(Integer idProduto, Integer idLocal, String orderBy, String orderDir) {
        StringBuilder sql = new StringBuilder(STOCK_SELECT_BASE);
        List<Object> params = new ArrayList<>();
        boolean hasWhere = false;

        if (idProduto != null) {
            sql.append(" WHERE s.id_produto = ?");
            params.add(idProduto);
            hasWhere = true;
        }

        if (idLocal != null) {
            sql.append(hasWhere ? " AND" : " WHERE");
            sql.append(" s.id_local = ?");
            params.add(idLocal);
        }

        sql.append(" ORDER BY ").append(resolveOrderBy(orderBy)).append(" ").append(resolveOrderDir(orderDir));

        List<StockLocal> lista = new ArrayList<>();
        try (Connection conn = DBconnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Produto produto = buildProduto(rs);
                    Local local = buildLocal(rs);
                    int quantidade = rs.getInt("quantidade");
                    lista.add(new StockLocal(produto, local, quantidade));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }

        return lista;
    }

    public List<StockLocal> getStockByLocal(int idLocal) {
        String sql = "SELECT s.quantidade, " +
                     "p.id_produto, p.nome, p.marca, p.unidade_medida, p.cod_barras, p.preco, " +
                     "c.id_categoria, c.nome AS nome_categoria, c.descricao AS desc_categoria, " +
                     "l.id_local, l.nome AS local_nome, l.tipo_local " +
                     "FROM stock_local s " +
                     "INNER JOIN produto p ON s.id_produto = p.id_produto " +
                     "INNER JOIN categoria c ON p.id_categoria = c.id_categoria " +
                     "INNER JOIN `local` l ON s.id_local = l.id_local " +
                     "WHERE s.id_local = ?";
        List<StockLocal> lista = new ArrayList<>();

        try (Connection conn = DBconnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idLocal);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Produto produto = buildProduto(rs);
                    Local local = buildLocal(rs);
                    int quantidade = rs.getInt("quantidade");
                    lista.add(new StockLocal(produto, local, quantidade));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }

        return lista;
    }

    public boolean insertStock(StockLocal stock) {
        String sql = "INSERT INTO stock_local (id_produto, id_local, quantidade) VALUES (?, ?, ?)";
        try (Connection conn = DBconnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, stock.getProduto().getIdProduto());
            stmt.setInt(2, stock.getLocal().getIdLocal());
            stmt.setInt(3, stock.getQuantidade());
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    public boolean updateStock(StockLocal stock) {
        String sql = "UPDATE stock_local SET quantidade = ? WHERE id_produto = ? AND id_local = ?";
        try (Connection conn = DBconnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, stock.getQuantidade());
            stmt.setInt(2, stock.getProduto().getIdProduto());
            stmt.setInt(3, stock.getLocal().getIdLocal());
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    public boolean deleteStock(int idProduto, int idLocal) {
        String sql = "DELETE FROM stock_local WHERE id_produto = ? AND id_local = ?";
        try (Connection conn = DBconnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idProduto);
            stmt.setInt(2, idLocal);
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    private Produto buildProduto(ResultSet rs) throws Exception {
        Produto produto = new Produto();
        produto.setIdProduto(rs.getInt("id_produto"));
        produto.setNome(rs.getString("nome"));
        produto.setMarca(rs.getString("marca"));
        produto.setUnidadeMedida(rs.getString("unidade_medida"));
        produto.setCodBarras(rs.getString("cod_barras"));
        produto.setPreco(rs.getFloat("preco"));

        model.Categoria categoria = new model.Categoria();
        categoria.setIdCategoria(rs.getInt("id_categoria"));
        categoria.setNome(rs.getString("nome_categoria"));
        categoria.setDescricao(rs.getString("desc_categoria"));
        produto.setCategoria(categoria);
        return produto;
    }

    private Local buildLocal(ResultSet rs) throws Exception {
        Local local = new Local();
        local.setIdLocal(rs.getInt("id_local"));
        local.setNome(rs.getString("local_nome"));
        local.setTipoLocal(rs.getString("tipo_local"));
        return local;
    }

    private String resolveOrderBy(String orderBy) {
        if ("nome".equalsIgnoreCase(orderBy)) return "p.nome";
        if ("local_nome".equalsIgnoreCase(orderBy)) return "l.nome";
        if ("quantidade".equalsIgnoreCase(orderBy)) return "s.quantidade";
        return "p.id_produto";
    }

    private String resolveOrderDir(String orderDir) {
        return "DESC".equalsIgnoreCase(orderDir) ? "DESC" : "ASC";
    }
}
