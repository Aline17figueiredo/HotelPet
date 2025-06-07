<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8" />
  <title>Clientes Cadastrados</title>
  <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
</head>
<body class="w3-light-grey w3-padding-large">

  <div class="w3-container w3-white w3-padding-32 w3-card-4 w3-round-large" style="max-width:900px; margin:auto;">
    <h2 class="w3-center w3-text-teal">Clientes Cadastrados</h2>

    <a href="adicionarCliente.jsp" class="w3-button w3-teal w3-margin-bottom w3-round">➕ Adicionar Novo Cliente</a>

    <table class="w3-table w3-striped w3-bordered w3-hoverable w3-white">
      <thead>
        <tr class="w3-teal">
          <th>ID</th>
          <th>Nome</th>
          <th>Email</th>
          <th>PetId</th>
          <th>Nome Pet</th>
          <th>Ações</th>
        </tr>
      </thead>
      <tbody>
        <%
          String url = "jdbc:mysql://localhost:3306/empresa";
          String usuario = "root";
          String senha = "";

          try {
              Class.forName("com.mysql.cj.jdbc.Driver");
              Connection conn = DriverManager.getConnection(url, usuario, senha);

              String sql = "SELECT c.id_cliente, c.nome, c.endereco, p.cod_pet, p.nome AS nomePet " +
                           "FROM Cliente c LEFT JOIN Pet p ON c.id_cliente = p.id_cliente ORDER BY c.id_cliente";
              PreparedStatement ps = conn.prepareStatement(sql);
              ResultSet rs = ps.executeQuery();

              while (rs.next()) {
                  int id = rs.getInt("id_cliente");
                  String nome = rs.getString("nome");
                  String endereco = rs.getString("endereco");
                  int petId = rs.getInt("cod_pet");
                  String nomePet = rs.getString("nomePet");
        %>
        <tr>
          <td><%= id %></td>
          <td><%= nome %></td>
          <td><%= endereco %></td>
          <td><%= (petId > 0 ? petId : "—") %></td>
          <td><%= (nomePet != null ? nomePet : "—") %></td>
          <td>
            <a href="editarCliente.jsp?id=<%= id %>" class="w3-button w3-blue w3-small w3-round">Editar</a>
            <a href="excluirCliente.jsp?id=<%= id %>" class="w3-button w3-red w3-small w3-round"
               onclick="return confirm('Confirma exclusão do cliente <%= nome %>?')">Excluir</a>
          </td>
        </tr>
        <%
              }
              rs.close();
              ps.close();
              conn.close();
          } catch (Exception e) {
              out.println("<tr><td colspan='6'>Erro: " + e.getMessage() + "</td></tr>");
          }
        %>
      </tbody>
    </table>
  </div>

</body>
</html>
