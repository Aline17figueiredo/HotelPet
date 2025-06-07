package dao;

import java.sql.*;
import java.util.*;
import modelo.Pet;
import util.ConnectaDB;

public class PetDAO {

    // Lista pets com nome do dono (para usar no select da agenda)
    public List<Pet> listar() {
        List<Pet> lista = new ArrayList<>();
        String sql = """
            SELECT p.cod_pet, p.nome AS nome_pet, p.especie, p.raca, p.idade, 
                   p.id_cliente, c.nome AS nome_dono
              FROM Pet p
              JOIN Cliente c ON p.id_cliente = c.id_cliente
              ORDER BY p.nome
        """;

        try (Connection conn = util.ConnectaDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Pet p = new Pet();
                p.setCodPet(rs.getInt("cod_pet"));
                p.setNome(rs.getString("nome_pet"));
                p.setEspecie(rs.getString("especie"));
                p.setRaca(rs.getString("raca"));
                p.setIdade(rs.getInt("idade"));
                p.setIdCliente(rs.getInt("id_cliente"));
                p.setNomeDono(rs.getString("nome_dono"));
                lista.add(p);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return lista;
    }

    // Insere novo pet
    public void inserir(Pet p) {
        String sql = "INSERT INTO Pet (especie, nome, raca, idade, id_cliente) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = util.ConnectaDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, p.getEspecie());
            stmt.setString(2, p.getNome());
            stmt.setString(3, p.getRaca());
            stmt.setInt(4, p.getIdade());
            stmt.setInt(5, p.getIdCliente());

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Buscar pet por ID (útil se necessário no futuro)
    public Pet buscarPorId(int id) {
        String sql = "SELECT * FROM Pet WHERE cod_pet = ?";
        Pet p = null;

        try (Connection conn = util.ConnectaDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    p = new Pet();
                    p.setCodPet(rs.getInt("cod_pet"));
                    p.setNome(rs.getString("nome"));
                    p.setEspecie(rs.getString("especie"));
                    p.setRaca(rs.getString("raca"));
                    p.setIdade(rs.getInt("idade"));
                    p.setIdCliente(rs.getInt("id_cliente"));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return p;
    }
}
