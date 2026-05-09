package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import DBconnection.DBconnection;
import model.Encomenda;
import model.Fornecedor;
import model.LinhaEnc;
import model.Local;
import model.Movimentos;
import model.Produto;


public class EncomendaDAO {
    
    public List<Encomenda> getAllEncomendas() {

        List<Encomenda> lista = new ArrayList<>();

        String sql =
            "SELECT " +
            "e.id_encomenda, e.id_fornecedor, e.id_local, e.valor_total, e.custo_envio, " +
            "e.data_prevista, e.data_chegada, " +
            "m.id_movimentos, m.status, m.data " +
            "FROM encomenda e " +
            "INNER JOIN movimentos m " +
            "ON m.id_movimentos = e.id_encomenda " +
            "ORDER BY e.id_encomenda DESC";

        try (
            Connection conn = DBconnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery()
        ) {

            while (rs.next()) {

                Encomenda e = new Encomenda();

                Movimentos m = new Movimentos();
                m.setIdMovimentos(rs.getInt("id_movimentos"));
                m.setStatus(rs.getString("status"));
                m.setData(rs.getDate("data"));
                e.setIdMovimentos(m);

                Fornecedor f = new Fornecedor();
                f.setIdFornecedor(rs.getInt("id_fornecedor"));
                e.setIdFornecedor(f);


                Local l = new Local();
                l.setIdLocal(rs.getInt("id_local"));
                e.setIdLocal(l);

                e.setValorTotal(rs.getFloat("valor_total"));
                e.setCustoEnvio(rs.getFloat("custo_envio"));

                e.setDataPrevista(rs.getDate("data_prevista"));
                e.setDataChegada(rs.getDate("data_chegada"));

                lista.add(e);
            }

        } catch (Exception ex) {
            ex.printStackTrace();
        }

        return lista;
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



    public List<LinhaEnc> getLinhasEncomenda(int idEncomenda) {

        List<LinhaEnc> lista = new ArrayList<>();

        String sql =
            "SELECT le.id_linhaenc, le.id_produto, le.quantidade, le.preco_encomenda, le.data_validade, " +
            "p.nome " +
            "FROM linha_enc le " +
            "INNER JOIN produto p ON p.id_produto = le.id_produto " +
            "WHERE le.id_encomenda = ?";

        try (Connection conn = DBconnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idEncomenda);

            ResultSet rs = stmt.executeQuery();

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

        } catch (Exception e) {
            e.printStackTrace();
        }

        return lista;
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
            "   SELECT SUM(preco_encomenda) " +
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

}