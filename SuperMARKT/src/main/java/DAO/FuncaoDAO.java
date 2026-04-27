package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import DBconnection.DBconnection;
import model.Funcao;

public class FuncaoDAO {

    public List<Funcao> getAllFuncoes() {
        String sql = "SELECT id_funcao, descricao FROM funcao ORDER BY descricao ASC";
        List<Funcao> funcoes = new ArrayList<>();

        try (Connection conn = DBconnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                funcoes.add(new Funcao(rs.getInt("id_funcao"), rs.getString("descricao")));
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }

        return funcoes;
    }
}
