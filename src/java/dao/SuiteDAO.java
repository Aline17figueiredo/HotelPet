package dao;

import model.Suite;
import java.sql.*;
import java.util.*;

public class SuiteDAO {
    private final String url = "jdbc:mysql://localhost:3306/empresa";
    private final String usuario = "root";
    private final String senha = "";

    private Connection getConnection() throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(url, usuario, senha);
    }

    public List<Suite> listar() {
        List<Suite> lista = new ArrayList<>();
        String sql = "SELECT * FROM Suite ORDER BY nome";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Suite s = new Suite(
                    rs.getInt("id_suite"),
                    rs.getString("nome"),
                    rs.getInt("capacidade"),
                    rs.getFloat("valor")
                );
                lista.add(s);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }

    public Suite buscarPorId(int id) {
        String sql = "SELECT * FROM Suite WHERE id_suite = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Suite(
                    rs.getInt("id_suite"),
                    rs.getString("nome"),
                    rs.getInt("capacidade"),
                    rs.getFloat("valor")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void inserir(Suite s) {
        String sql = "INSERT INTO Suite (nome, capacidade, valor) VALUES (?, ?, ?)";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, s.getNome());
            ps.setInt(2, s.getCapacidade());
            ps.setFloat(3, s.getValor());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void atualizar(Suite s) {
        String sql = "UPDATE Suite SET nome = ?, capacidade = ?, valor = ? WHERE id_suite = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, s.getNome());
            ps.setInt(2, s.getCapacidade());
            ps.setFloat(3, s.getValor());
            ps.setInt(4, s.getId());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void excluir(int id) {
        String sql = "DELETE FROM Suite WHERE id_suite = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
