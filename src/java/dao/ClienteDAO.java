package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.ClientePet;

public class ClienteDAO {
    private final String URL = "jdbc:mysql://localhost:3306/empresa";
    private final String USUARIO = "root";
    private final String SENHA = "";

    public void adicionarClienteComPet(String nomeCliente, String endereco, String nomePet) throws Exception {
        Connection conn = null;
        PreparedStatement psCliente = null;
        PreparedStatement psPet = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(URL, USUARIO, SENHA);
            conn.setAutoCommit(false);

            String sqlCliente = "INSERT INTO Cliente (nome, endereco) VALUES (?, ?)";
            psCliente = conn.prepareStatement(sqlCliente, Statement.RETURN_GENERATED_KEYS);
            psCliente.setString(1, nomeCliente);
            psCliente.setString(2, endereco);
            psCliente.executeUpdate();

            rs = psCliente.getGeneratedKeys();
            int idCliente = 0;
            if (rs.next()) {
                idCliente = rs.getInt(1);
            }

            String sqlPet = "INSERT INTO Pet (nome, id_cliente) VALUES (?, ?)";
            psPet = conn.prepareStatement(sqlPet);
            psPet.setString(1, nomePet);
            psPet.setInt(2, idCliente);
            psPet.executeUpdate();

            conn.commit();
        } catch (Exception e) {
            if (conn != null) conn.rollback();
            throw e;
        } finally {
            if (rs != null) rs.close();
        }
    }
}