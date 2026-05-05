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

    // TRANSFERIR STOCK
    public void transferirStock(int idProduto, int idOrigem, int idDestino, int quantidadeTransferir) throws Exception {
        if (quantidadeTransferir <= 0) {
            throw new Exception("A quantidade a transferir deve ser maior que zero.");
        }
        if (idOrigem == idDestino) {
            throw new Exception("O local de origem e destino não podem ser iguais.");
        }

        String checkOrigemSql = "SELECT quantidade FROM stock_local WHERE id_produto = ? AND id_local = ? FOR UPDATE";
        String updateOrigemSql = "UPDATE stock_local SET quantidade = quantidade - ? WHERE id_produto = ? AND id_local = ?";
        String checkDestinoSql = "SELECT quantidade FROM stock_local WHERE id_produto = ? AND id_local = ? FOR UPDATE";
        String updateDestinoSql = "UPDATE stock_local SET quantidade = quantidade + ? WHERE id_produto = ? AND id_local = ?";
        String insertDestinoSql = "INSERT INTO stock_local (id_produto, id_local, quantidade) VALUES (?, ?, ?)";

        try (Connection conn = DBconnection.getConnection()) {
            conn.setAutoCommit(false); // Início da transação

            try {
                // 1. Verificar Origem
                int qtdOrigem = 0;
                try (PreparedStatement stmtCheckO = conn.prepareStatement(checkOrigemSql)) {
                    stmtCheckO.setInt(1, idProduto);
                    stmtCheckO.setInt(2, idOrigem);
                    try (ResultSet rs = stmtCheckO.executeQuery()) {
                        if (rs.next()) {
                            qtdOrigem = rs.getInt("quantidade");
                        } else {
                            throw new Exception("Produto não encontrado no local de origem.");
                        }
                    }
                }

                if (qtdOrigem < quantidadeTransferir) {
                    throw new Exception("Stock insuficiente na origem (Disponível: " + qtdOrigem + ").");
                }

                // 2. Descontar Origem
                try (PreparedStatement stmtUpdO = conn.prepareStatement(updateOrigemSql)) {
                    stmtUpdO.setInt(1, quantidadeTransferir);
                    stmtUpdO.setInt(2, idProduto);
                    stmtUpdO.setInt(3, idOrigem);
                    stmtUpdO.executeUpdate();
                }

                // 3. Verificar Destino
                boolean destinoExiste = false;
                try (PreparedStatement stmtCheckD = conn.prepareStatement(checkDestinoSql)) {
                    stmtCheckD.setInt(1, idProduto);
                    stmtCheckD.setInt(2, idDestino);
                    try (ResultSet rs = stmtCheckD.executeQuery()) {
                        if (rs.next()) {
                            destinoExiste = true;
                        }
                    }
                }

                // 4. Somar ou Inserir Destino
                if (destinoExiste) {
                    try (PreparedStatement stmtUpdD = conn.prepareStatement(updateDestinoSql)) {
                        stmtUpdD.setInt(1, quantidadeTransferir);
                        stmtUpdD.setInt(2, idProduto);
                        stmtUpdD.setInt(3, idDestino);
                        stmtUpdD.executeUpdate();
                    }
                } else {
                    try (PreparedStatement stmtInsD = conn.prepareStatement(insertDestinoSql)) {
                        stmtInsD.setInt(1, idProduto);
                        stmtInsD.setInt(2, idDestino);
                        stmtInsD.setInt(3, quantidadeTransferir);
                        stmtInsD.executeUpdate();
                    }
                }

                conn.commit(); // Confirma
            } catch (Exception e) {
                conn.rollback(); // Cancela tudo se der erro
                throw e;
            } finally {
                conn.setAutoCommit(true);
            }
        }
    }

    public void reduzirStock(int idProduto, int idLocal, int quantidade, Connection conn) throws Exception {
        if (quantidade <= 0) {
            throw new Exception("A quantidade a reduzir deve ser maior que zero.");
        }

        String checkSql = "SELECT quantidade FROM stock_local WHERE id_produto = ? AND id_local = ? FOR UPDATE";
        String updateSql = "UPDATE stock_local SET quantidade = quantidade - ? WHERE id_produto = ? AND id_local = ?";
        
        int qtdAtual = 0;
        try (PreparedStatement stmtCheck = conn.prepareStatement(checkSql)) {
            stmtCheck.setInt(1, idProduto);
            stmtCheck.setInt(2, idLocal);
            try (ResultSet rs = stmtCheck.executeQuery()) {
                if (rs.next()) {
                    qtdAtual = rs.getInt("quantidade");
                } else {
                    throw new Exception("Produto não encontrado no local para redução de stock.");
                }
            }
        }

        if (qtdAtual < quantidade) {
            throw new Exception("Stock insuficiente para a perda registada (Disponível: " + qtdAtual + ").");
        }

        try (PreparedStatement stmtUpd = conn.prepareStatement(updateSql)) {
            stmtUpd.setInt(1, quantidade);
            stmtUpd.setInt(2, idProduto);
            stmtUpd.setInt(3, idLocal);
            stmtUpd.executeUpdate();
        }
    }
}
