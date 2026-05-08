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
}