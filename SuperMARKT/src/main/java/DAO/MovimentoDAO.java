package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

import DBconnection.DBconnection;
import model.Movimentos;

public class MovimentoDAO {

    // Método original (mantém para uso simples)
    public int insert(Movimentos movimentoos) {
        try (Connection conn = DBconnection.getConnection()) {
            return insert(movimentoos, conn); // Chama a versão com conexão
        } catch (Exception e) {
            e.printStackTrace();
            return -1;
        }
    }

    // NOVA VERSÃO: Aceita a conexão da transação
    public int insert(Movimentos movimentoos, Connection conn) throws Exception {
        String sql = "INSERT INTO movimentos (nif, status, data, hora) " +
                     "VALUES (?, ?, CURRENT_DATE, CURRENT_TIME)";

        // NOTA: Não usamos try-with-resources aqui para a conexão, 
        // pois quem a abriu (o EncomendaDAO) é que deve fechá-la.
        try (PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, movimentoos.getFuncionario().getNif());
            stmt.setString(2, movimentoos.getStatus());

            stmt.executeUpdate();

            try (ResultSet rs = stmt.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return -1;
    }
}

 
