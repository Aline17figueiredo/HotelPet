package dao;

import java.sql.*;
import model.Cadastro;

public class CadastroDAO {
    private final String URL = "jdbc:mysql://localhost:3306/empresa";
    private final String USUARIO = "root";
    private final String SENHA = "";

    // Salvar novo cadastro
    public boolean salvar(Cadastro cadastro) {
        String sql = "INSERT INTO Cadastro (nome, login, senha) VALUES (?, ?, ?)";
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(URL, USUARIO, SENHA);
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, cadastro.getNome());
            stmt.setString(2, cadastro.getLogin());
            stmt.setString(3, cadastro.getSenha());

            int rows = stmt.executeUpdate();
            return rows > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            try { if (stmt != null) stmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }

    // Verifica se login já existe
    public boolean existeLogin(String login) {
        String sql = "SELECT COUNT(*) FROM Cadastro WHERE login = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(URL, USUARIO, SENHA);
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, login);
            rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (stmt != null) stmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }

        return false;
    }

    // Autenticar login e senha (para loginProcess)
    public Cadastro autenticar(String login, String senha) {
        String sql = "SELECT * FROM Cadastro WHERE login = ? AND senha = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(URL, USUARIO, SENHA);
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, login);
            stmt.setString(2, senha);

            rs = stmt.executeQuery();
            if (rs.next()) {
                Cadastro c = new Cadastro();
                c.setId(rs.getInt("id_cadastro"));
                c.setNome(rs.getString("nome"));
                c.setLogin(rs.getString("login"));
                c.setSenha(rs.getString("senha"));
                return c;
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (stmt != null) stmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }

        return null;
    }
}
