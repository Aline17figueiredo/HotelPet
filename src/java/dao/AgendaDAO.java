package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Agenda;
import util.ConnectaDB;

public class AgendaDAO {

    public void adicionarTarefa(Agenda agenda) {
        String sql = "INSERT INTO Agenda (cod_pet, data, hora, descricao) VALUES (?, ?, ?, ?)";

        try (Connection conn = ConnectaDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, agenda.getCodPet());

            // Converter String (yyyy-MM-dd) para java.sql.Date
            java.sql.Date sqlDate = java.sql.Date.valueOf(agenda.getData());
            stmt.setDate(2, sqlDate);

            // Converter String (HH:mm) para java.sql.Time adicionando :00 segundos
            String horaCompleta = agenda.getHora();
            if (horaCompleta.length() == 5) { // formato HH:mm
                horaCompleta += ":00";
            }
            java.sql.Time sqlTime = java.sql.Time.valueOf(horaCompleta);
            stmt.setTime(3, sqlTime);

            stmt.setString(4, agenda.getDescricao());

            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<Agenda> listarTarefas() {
        List<Agenda> lista = new ArrayList<>();
        String sql = "SELECT a.id_agenda, a.cod_pet, a.data, a.hora, a.descricao, p.nome AS nome_pet " +
                     "FROM Agenda a " +
                     "JOIN Pet p ON a.cod_pet = p.cod_pet " +
                     "ORDER BY a.data, a.hora";

        try (Connection conn = ConnectaDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Agenda a = new Agenda();
                a.setIdAgenda(rs.getInt("id_agenda"));
                a.setCodPet(rs.getInt("cod_pet"));

                // Converte Date para String yyyy-MM-dd
                Date data = rs.getDate("data");
                a.setData(data != null ? data.toString() : null);

                // Converte Time para String HH:mm:ss, pode adaptar para HH:mm se quiser
                Time hora = rs.getTime("hora");
                a.setHora(hora != null ? hora.toString().substring(0,5) : null); // pegando só HH:mm

                a.setDescricao(rs.getString("descricao"));
                a.setNomePet(rs.getString("nome_pet"));
                lista.add(a);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return lista;
    }
}
