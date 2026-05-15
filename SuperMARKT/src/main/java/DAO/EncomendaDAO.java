package DAO;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import DBconnection.DBconnection;
import model.Encomenda;
import model.LinhaEnc;
import model.Produto;
import model.Movimentos;
import model.Fornecedor;
import model.Local;

public class EncomendaDAO {
    public static class LoteSplit {
        private final int quantidade;
        private final Date validade;

        public LoteSplit(int quantidade, Date validade) {
            this.quantidade = quantidade;
            this.validade = validade;
        }

        public int getQuantidade() {
            return quantidade;
        }

        public Date getValidade() {
            return validade;
        }
    }

    public List<Encomenda> getAllEncomendas() {
        List<Encomenda> lista = new ArrayList<>();
        String sql = "SELECT e.*, m.status, m.data, f.tipo_fornecedor, l.nome as local_nome " +
                     "FROM encomenda e " +
                     "JOIN movimentos m ON e.id_encomenda = m.id_movimentos " +
                     "JOIN fornecedor f ON e.id_fornecedor = f.id_fornecedor " +
                     "JOIN local l ON e.id_local = l.id_local";
        try (Connection conn = DBconnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Encomenda e = new Encomenda();
                Movimentos m = new Movimentos();
                m.setIdMovimentos(rs.getInt("id_encomenda"));
                m.setStatus(rs.getString("status"));
                m.setData(rs.getDate("data"));
                e.setIdMovimentos(m);
                Fornecedor forn = new Fornecedor();
                forn.setIdFornecedor(rs.getInt("id_fornecedor"));
                forn.setTipoFornecedor(rs.getString("tipo_fornecedor"));
                e.setIdFornecedor(forn);
                Local loc = new Local();
                loc.setIdLocal(rs.getInt("id_local"));
                loc.setNome(rs.getString("local_nome"));
                e.setIdLocal(loc);
                e.setValorTotal(rs.getFloat("valor_total"));
                e.setCustoEnvio(rs.getFloat("custo_envio"));
                e.setDataPrevista(rs.getDate("data_prevista"));
                e.setDataChegada(rs.getDate("data_chegada"));
                lista.add(e);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return lista;
    }



    public Encomenda getEncomendaById(int id) {
        String sql = "SELECT e.*, m.status, m.data FROM encomenda e " +
                     "JOIN movimentos m ON e.id_encomenda = m.id_movimentos " +
                     "WHERE e.id_encomenda = ?";
        try (Connection conn = DBconnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Encomenda e = new Encomenda();
                    Movimentos m = new Movimentos();
                    m.setIdMovimentos(rs.getInt("id_encomenda"));
                    e.setIdMovimentos(m);
                    Fornecedor f = new Fornecedor();
                    f.setIdFornecedor(rs.getInt("id_fornecedor"));
                    e.setIdFornecedor(f);
                    e.setValorTotal(rs.getFloat("valor_total"));
                    e.setCustoEnvio(rs.getFloat("custo_envio"));
                    e.setDataPrevista(rs.getDate("data_prevista"));
                    e.setDataChegada(rs.getDate("data_chegada"));
                    return e;
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    public List<LinhaEnc> getLinhasEncomenda(int idEnc) {
        List<LinhaEnc> lista = new ArrayList<>();
        String sql = "SELECT l.*, p.nome FROM linha_enc l JOIN produto p ON l.id_produto = p.id_produto WHERE id_encomenda = ?";
        try (Connection conn = DBconnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idEnc);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    LinhaEnc l = new LinhaEnc();
                    l.setIdLinhaOrder(rs.getInt("id_linhaenc"));
                    Produto p = new Produto();
                    p.setIdProduto(rs.getInt("id_produto"));
                    p.setNome(rs.getString("nome"));
                    l.setProduto(p);
                    l.setQuantidade(rs.getInt("quantidade"));
                    l.setPrecoEncomenda(rs.getFloat("preco_encomenda"));
                    l.setDataValidade(rs.getDate("data_validade"));
                    lista.add(l);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return lista;
    }

    public boolean atualizarQuantidadeLinhaEncomenda(int idEncomenda, int idLinhaEnc, int novaQuantidade) {
        if (novaQuantidade <= 0) return false;
        Connection conn = null;
        try {
            conn = DBconnection.getConnection();
            conn.setAutoCommit(false);

            String sql = "UPDATE linha_enc SET quantidade = ? WHERE id_linhaenc = ? AND id_encomenda = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, novaQuantidade);
                stmt.setInt(2, idLinhaEnc);
                stmt.setInt(3, idEncomenda);
                int updated = stmt.executeUpdate();
                if (updated == 0) {
                    conn.rollback();
                    return false;
                }
            }

            updateValorTotal(idEncomenda, conn);
            conn.commit();
            return true;
        } catch (Exception e) {
            try { if (conn != null) conn.rollback(); } catch (Exception ex) { ex.printStackTrace(); }
            e.printStackTrace();
            return false;
        } finally {
            try { if (conn != null) conn.close(); } catch (Exception e) { e.printStackTrace(); }
        }
    }

    public boolean adicionarLinhasAEncomendaExistente(int idEncomenda, List<LinhaEnc> linhas) {
        String sqlLinha = "INSERT INTO linha_enc (id_encomenda, id_produto, quantidade, preco_encomenda) VALUES (?, ?, ?, ?)";
        
        Connection conn = null;
        try {
            conn = DBconnection.getConnection();
            conn.setAutoCommit(false);
            
            try (PreparedStatement stmtLinha = conn.prepareStatement(sqlLinha)) {
                for (LinhaEnc l : linhas) {
                    stmtLinha.setInt(1, idEncomenda);
                    stmtLinha.setInt(2, l.getProduto().getIdProduto());
                    stmtLinha.setInt(3, l.getQuantidade());
                    stmtLinha.setFloat(4, l.getPrecoEncomenda());
                    stmtLinha.addBatch();
                }
                stmtLinha.executeBatch();
            }
            
            // Recalcula o total corretamente usando o método centralizado
            this.updateValorTotal(idEncomenda, conn);
            
            conn.commit();
            return true;
        } catch (Exception e) {
            if (conn != null) try { conn.rollback(); } catch (Exception ex) {}
            e.printStackTrace();
            return false;
        } finally {
            if (conn != null) try { conn.close(); } catch (Exception ex) {}
        }
    }


  public void createLinhaEnc(
        List<LinhaEnc> linhas,
        Connection conn) {

    String sql =
        "INSERT INTO linha_enc " +
        "(id_encomenda, id_produto, quantidade, preco_encomenda) " +
        "VALUES (?, ?, ?, ?)";

    try (
        PreparedStatement stmt =
            conn.prepareStatement(sql)
    ) {

        for (LinhaEnc linha : linhas) {

            stmt.setInt(
                1,
                linha.getEncomenda()
                     .getIdMovimentos()
                     .getIdMovimentos()
            );

            stmt.setInt(
                2,
                linha.getProduto()
                     .getIdProduto()
            );

            stmt.setInt(
                3,
                linha.getQuantidade()
            );

            stmt.setFloat(
                4,
                linha.getPrecoEncomenda()
            );

            stmt.addBatch();
        }

        stmt.executeBatch();

    } catch (Exception e) {
        e.printStackTrace();
    }
    }
    public void updateValorTotal(
            int idEncomenda,
            Connection conn) {

        String sql =
            "UPDATE encomenda " +
            "SET valor_total = (" +
            "   SELECT SUM(preco_encomenda * quantidade) " +
            "   FROM linha_enc " +
            "   WHERE id_encomenda = ?" +
            ") " +
            "WHERE id_encomenda = ?";

        
        try (
            PreparedStatement stmt =
                conn.prepareStatement(sql)
        ) {

            stmt.setInt(1, idEncomenda);
            stmt.setInt(2, idEncomenda);

            stmt.executeUpdate();
            

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public boolean createEncomenda(Encomenda encomenda, Connection conn) {

        String sql = "insert into encomenda (id_encomenda, id_fornecedor, id_local, valor_total, custo_envio) VALUES (?,?,?,?,?)";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {

            // 1. Criar encomenda

            stmt.setInt(1, encomenda.getIdMovimentos().getIdMovimentos());
            stmt.setInt(2, encomenda.getIdFornecedor().getIdFornecedor());
            stmt.setInt(3, encomenda.getIdLocal().getIdLocal());

            stmt.setFloat(4, 0);
            stmt.setFloat(5, 0);
            return stmt.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;

    }
    
    public boolean finalizarEncomendaCompleta(Movimentos mov, Encomenda enc, List<LinhaEnc> linhas) {
    Connection conn = null;
    MovimentoDAO movDAO = new MovimentoDAO(); // Instancia o DAO de movimentos

    try {
        conn = DBconnection.getConnection();
        conn.setAutoCommit(false); // IMPORTANTE: Inicia a transação

        // 1. Usa o MovimentoDAO passando a conexão da transação
        int idMovimento = movDAO.insert(mov, conn);
        
        if (idMovimento > 0) {
            mov.setIdMovimentos(idMovimento);
            enc.setIdMovimentos(mov);

            // 2. Inserir a Encomenda (já tens este método)
            if (this.createEncomenda(enc, conn)) {
                
                // Associar o ID da encomenda às linhas
                for(LinhaEnc l : linhas) {
                    l.setEncomenda(enc);
                }

                // 3. Inserir as Linhas
                this.createLinhaEnc(linhas, conn);

                // 4. Atualizar o Total
                this.updateValorTotal(idMovimento, conn);

                conn.commit(); // TUDO OK: Grava no banco
                return true;
            }
        }

        if (conn != null) conn.rollback(); // ALGO FALHOU: Desfaz tudo
    } catch (Exception e) {
        try { if (conn != null) conn.rollback(); } catch (Exception ex) { ex.printStackTrace(); }
        e.printStackTrace();
    } finally {
        try { if (conn != null) conn.close(); } catch (Exception e) { e.printStackTrace(); }
    }
    return false;
}

    public boolean confirmarFornecedor(
            int idEncomenda,
            float custoEnvio,
            Date dataPrevista,
            Map<Integer, Date> validadePorLinha) {
        Connection conn = null;
        try {
            System.out.println("[EncomendaDAO.confirmarFornecedor] idEncomenda=" + idEncomenda + ", custoEnvio=" + custoEnvio + ", dataPrevista=" + dataPrevista + ", validades=" + (validadePorLinha != null ? validadePorLinha.size() : 0));
            conn = DBconnection.getConnection();
            conn.setAutoCommit(false);

            String updateEnc = "UPDATE encomenda SET custo_envio = ?, data_prevista = COALESCE(?, data_prevista) WHERE id_encomenda = ?";
            try (PreparedStatement stmt = conn.prepareStatement(updateEnc)) {
                stmt.setFloat(1, custoEnvio);
                stmt.setDate(2, dataPrevista);
                stmt.setInt(3, idEncomenda);
                stmt.executeUpdate();
            }
         // atualizar valor_total = soma linhas + custo envio
            String updateTotal =
                "UPDATE encomenda " +
                "SET valor_total = (SELECT COALESCE(SUM(preco_encomenda * quantidade),0) FROM linha_enc WHERE id_encomenda = ?) + ? " +
                "WHERE id_encomenda = ?";

            try (PreparedStatement stmt = conn.prepareStatement(updateTotal)) {
                stmt.setInt(1, idEncomenda);
                stmt.setFloat(2, custoEnvio);
                stmt.setInt(3, idEncomenda);
                stmt.executeUpdate();
            }
            
            String updateLinha = "UPDATE linha_enc SET data_validade = ? WHERE id_linhaenc = ? AND id_encomenda = ?";
            try (PreparedStatement stmt = conn.prepareStatement(updateLinha)) {
                for (Map.Entry<Integer, Date> e : validadePorLinha.entrySet()) {
                    int idLinha = e.getKey();
                    Date validade = validadePorLinha.get(idLinha);
                    if (validade == null) continue;
                    stmt.setDate(1, validade);
                    stmt.setInt(2, idLinha);
                    stmt.setInt(3, idEncomenda);
                    stmt.addBatch();
                }
                stmt.executeBatch();
            }

            String updateMov = "UPDATE movimentos SET status = ? WHERE id_movimentos = ?";
            try (PreparedStatement stmt = conn.prepareStatement(updateMov)) {
                stmt.setString(1, "Confirmada Fornecedor");
                stmt.setInt(2, idEncomenda);
                stmt.executeUpdate();
            }

            conn.commit();
            System.out.println("[EncomendaDAO.confirmarFornecedor] commit OK");
            return true;
        } catch (Exception e) {
            try { if (conn != null) conn.rollback(); } catch (Exception ex) { ex.printStackTrace(); }
            System.out.println("[EncomendaDAO.confirmarFornecedor] rollback por erro: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            try { if (conn != null) conn.close(); } catch (Exception e) { e.printStackTrace(); }
        }
    }

    public boolean confirmarFornecedorComLotes(
            int idEncomenda,
            float custoEnvio,
            Date dataPrevista,
            Map<Integer, List<LoteSplit>> lotesPorLinha) {
        Connection conn = null;
        try {
            System.out.println("[EncomendaDAO.confirmarFornecedorComLotes] idEncomenda=" + idEncomenda + ", custoEnvio=" + custoEnvio + ", dataPrevista=" + dataPrevista + ", linhasLote=" + (lotesPorLinha != null ? lotesPorLinha.size() : 0));
            conn = DBconnection.getConnection();
            conn.setAutoCommit(false);

            String updateEnc = "UPDATE encomenda SET custo_envio = ?, data_prevista = COALESCE(?, data_prevista) WHERE id_encomenda = ?";
            try (PreparedStatement stmt = conn.prepareStatement(updateEnc)) {
                stmt.setFloat(1, custoEnvio);
                stmt.setDate(2, dataPrevista);
                stmt.setInt(3, idEncomenda);
                stmt.executeUpdate();
            }

            String findLinha = "SELECT id_produto, quantidade, preco_encomenda FROM linha_enc WHERE id_linhaenc = ? AND id_encomenda = ?";
            String updateLinha = "UPDATE linha_enc SET quantidade = ?, data_validade = ? WHERE id_linhaenc = ? AND id_encomenda = ?";
            String insertLinha = "INSERT INTO linha_enc (id_encomenda, id_produto, quantidade, preco_encomenda, data_validade) VALUES (?, ?, ?, ?, ?)";

            try (PreparedStatement stmtFind = conn.prepareStatement(findLinha);
                 PreparedStatement stmtUpdate = conn.prepareStatement(updateLinha);
                 PreparedStatement stmtInsert = conn.prepareStatement(insertLinha)) {

                for (Map.Entry<Integer, List<LoteSplit>> e : lotesPorLinha.entrySet()) {
                    int idLinhaOriginal = e.getKey();
                    List<LoteSplit> lotes = e.getValue();
                    if (lotes == null || lotes.isEmpty()) {
                        continue;
                    }

                    stmtFind.setInt(1, idLinhaOriginal);
                    stmtFind.setInt(2, idEncomenda);
                    try (ResultSet rs = stmtFind.executeQuery()) {
                        if (!rs.next()) {
                            System.out.println("[EncomendaDAO.confirmarFornecedorComLotes] FAIL linha nao encontrada idLinha=" + idLinhaOriginal + " idEncomenda=" + idEncomenda);
                            conn.rollback();
                            return false;
                        }

                        int idProduto = rs.getInt("id_produto");
                        int qtdOriginal = rs.getInt("quantidade");
                        float precoUnit = rs.getFloat("preco_encomenda");

                        int soma = 0;
                        for (LoteSplit l : lotes) {
                            // Modo teste: aceitar qualquer quantidade informada
                            soma += l.getQuantidade();
                        }

                        // Modo teste: não bloquear se a soma diferir da linha original
                        if (soma != qtdOriginal) {
                            System.out.println("[EncomendaDAO.confirmarFornecedorComLotes] WARN modo teste: soma lotes (" + soma + ") != quantidade original (" + qtdOriginal + ") idLinha=" + idLinhaOriginal);
                        }

                        // Atualiza linha original com o primeiro lote
                        LoteSplit primeiro = lotes.get(0);
                        stmtUpdate.setInt(1, primeiro.getQuantidade());
                        stmtUpdate.setDate(2, primeiro.getValidade());
                        stmtUpdate.setInt(3, idLinhaOriginal);
                        stmtUpdate.setInt(4, idEncomenda);
                        stmtUpdate.addBatch();

                        // Cria as linhas extra para os outros lotes
                        for (int i = 1; i < lotes.size(); i++) {
                            LoteSplit extra = lotes.get(i);
                            stmtInsert.setInt(1, idEncomenda);
                            stmtInsert.setInt(2, idProduto);
                            stmtInsert.setInt(3, extra.getQuantidade());
                            stmtInsert.setFloat(4, precoUnit);
                            stmtInsert.setDate(5, extra.getValidade());
                            stmtInsert.addBatch();
                        }
                    }
                }

                stmtUpdate.executeBatch();
                stmtInsert.executeBatch();
            }

            String updateTotal =
                    "UPDATE encomenda " +
                    "SET valor_total = (SELECT COALESCE(SUM(preco_encomenda * quantidade),0) FROM linha_enc WHERE id_encomenda = ?) + ? " +
                    "WHERE id_encomenda = ?";
            try (PreparedStatement stmt = conn.prepareStatement(updateTotal)) {
                stmt.setInt(1, idEncomenda);
                stmt.setFloat(2, custoEnvio);
                stmt.setInt(3, idEncomenda);
                stmt.executeUpdate();
            }

            String updateMov = "UPDATE movimentos SET status = ? WHERE id_movimentos = ?";
            try (PreparedStatement stmt = conn.prepareStatement(updateMov)) {
                stmt.setString(1, "Confirmada Fornecedor");
                stmt.setInt(2, idEncomenda);
                stmt.executeUpdate();
            }

            conn.commit();
            System.out.println("[EncomendaDAO.confirmarFornecedorComLotes] commit OK");
            return true;
        } catch (Exception ex) {
            try { if (conn != null) conn.rollback(); } catch (Exception e) { e.printStackTrace(); }
            System.out.println("[EncomendaDAO.confirmarFornecedorComLotes] rollback por erro: " + ex.getMessage());
            ex.printStackTrace();
            return false;
        } finally {
            try { if (conn != null) conn.close(); } catch (Exception e) { e.printStackTrace(); }
        }
    }

    public boolean confirmarRececaoEncomenda(int idEncomenda) {
        Connection conn = null;
        try {
            System.out.println("[EncomendaDAO.confirmarRececaoEncomenda] idEncomenda=" + idEncomenda);
            conn = DBconnection.getConnection();
            conn.setAutoCommit(false);

            String sqlLinhas = "SELECT le.id_linhaenc, le.id_produto, le.quantidade, le.data_validade, e.id_local " +
                               "FROM linha_enc le " +
                               "INNER JOIN encomenda e ON e.id_encomenda = le.id_encomenda " +
                               "WHERE le.id_encomenda = ?";

            String insertLote = "INSERT INTO stock_lote (id_produto, id_local, id_linhaenc, quantidade, data_validade, ativo) " +
                                "VALUES (?, ?, ?, ?, ?, ?)";
            String updateStock = "UPDATE stock_local SET quantidade = quantidade + ? WHERE id_produto = ? AND id_local = ?";
            String insertStock = "INSERT INTO stock_local (id_produto, id_local, quantidade) VALUES (?, ?, ?)";

            try (PreparedStatement psLinhas = conn.prepareStatement(sqlLinhas);
                 PreparedStatement psInsertLote = conn.prepareStatement(insertLote);
                 PreparedStatement psUpdateStock = conn.prepareStatement(updateStock);
                 PreparedStatement psInsertStock = conn.prepareStatement(insertStock)) {

                psLinhas.setInt(1, idEncomenda);
                try (ResultSet rs = psLinhas.executeQuery()) {
                    while (rs.next()) {
                        int idLinha = rs.getInt("id_linhaenc");
                        int idProduto = rs.getInt("id_produto");
                        int quantidade = rs.getInt("quantidade");
                        int idLocal = rs.getInt("id_local");
                        Date dataValidade = rs.getDate("data_validade");

                        psInsertLote.setInt(1, idProduto);
                        psInsertLote.setInt(2, idLocal);
                        psInsertLote.setInt(3, idLinha);
                        psInsertLote.setInt(4, quantidade);
                        psInsertLote.setDate(5, dataValidade);
                        psInsertLote.setBoolean(6, true);
                        psInsertLote.addBatch();

                        psUpdateStock.setInt(1, quantidade);
                        psUpdateStock.setInt(2, idProduto);
                        psUpdateStock.setInt(3, idLocal);
                        int rows = psUpdateStock.executeUpdate();
                        if (rows == 0) {
                            psInsertStock.setInt(1, idProduto);
                            psInsertStock.setInt(2, idLocal);
                            psInsertStock.setInt(3, quantidade);
                            psInsertStock.addBatch();
                        }
                    }
                }

                psInsertLote.executeBatch();
                psInsertStock.executeBatch();
            }

            String updateEnc = "UPDATE encomenda SET data_chegada = CURRENT_DATE WHERE id_encomenda = ?";
            try (PreparedStatement stmt = conn.prepareStatement(updateEnc)) {
                stmt.setInt(1, idEncomenda);
                stmt.executeUpdate();
            }

            String updateMov = "UPDATE movimentos SET status = ? WHERE id_movimentos = ?";
            try (PreparedStatement stmt = conn.prepareStatement(updateMov)) {
                stmt.setString(1, "Recebida");
                stmt.setInt(2, idEncomenda);
                stmt.executeUpdate();
            }

            conn.commit();
            System.out.println("[EncomendaDAO.confirmarRececaoEncomenda] commit OK");
            return true;
        } catch (Exception e) {
            try { if (conn != null) conn.rollback(); } catch (Exception ex) { ex.printStackTrace(); }
            System.out.println("[EncomendaDAO.confirmarRececaoEncomenda] rollback por erro: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            try { if (conn != null) conn.close(); } catch (Exception e) { e.printStackTrace(); }
        }
    }

}
