<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    class Suite {
        int id;
        String nome;
        String descricao;
        String status;
        public Suite(int id, String nome, String descricao, String status) {
            this.id = id; this.nome = nome; this.descricao = descricao; this.status = status;
        }
    }

    List<Suite> disponiveis = new ArrayList<>();
    List<Suite> ocupadas = new ArrayList<>();

    // Conexão JDBC (ajuste usuário, senha e URL conforme seu banco)
    String url = "jdbc:mysql://localhost:3306/empresa";
    String user = "root";
    String pass = "";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection(url, user, pass);
        String sql = "SELECT id, nome, descricao, status FROM suites ORDER BY id";
        PreparedStatement ps = con.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();

        while(rs.next()) {
            Suite s = new Suite(
                rs.getInt("id"),
                rs.getString("nome"),
                rs.getString("descricao"),
                rs.getString("status")
            );
            if ("Disponível".equalsIgnoreCase(s.status)) {
                disponiveis.add(s);
            } else {
                ocupadas.add(s);
            }
        }

        rs.close();
        ps.close();
        con.close();

    } catch(Exception e) {
        out.println("<p style='color:red;'>Erro ao carregar suítes: " + e.getMessage() + "</p>");
    }
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8" />
  <title>Hotel de Pets - Controle de Suítes</title>
  <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css" />
</head>
<body class="w3-light-grey w3-padding-large">

  <div class="w3-container w3-white w3-padding-32 w3-card-4 w3-round-large" style="max-width:900px; margin:auto;">
    <h2 class="w3-center w3-text-teal">Hotel de Pets - Controle de Suítes</h2>

    <h3 class="w3-text-teal">Suítes Disponíveis</h3>
    <table class="w3-table w3-striped w3-bordered w3-hoverable w3-white w3-margin-bottom">
      <thead>
        <tr class="w3-teal">
          <th>ID Suíte</th>
          <th>Tipo</th>
          <th>Descrição</th>
          <th>Status</th>
        </tr>
      </thead>
      <tbody>
        <% for(Suite s : disponiveis) { %>
        <tr>
          <td><%= s.id %></td>
          <td><%= s.nome %></td>
          <td><%= s.descricao %></td>
          <td><span class="w3-tag w3-green w3-round"><%= s.status %></span></td>
        </tr>
        <% } %>
        <% if(disponiveis.isEmpty()) { %>
        <tr><td colspan="4" class="w3-center">Nenhuma suíte disponível no momento.</td></tr>
        <% } %>
      </tbody>
    </table>

    <h3 class="w3-text-teal">Suítes Ocupadas</h3>
    <table class="w3-table w3-striped w3-bordered w3-hoverable w3-white">
      <thead>
        <tr class="w3-red">
          <th>ID Suíte</th>
          <th>Tipo</th>
          <th>Descrição</th>
          <th>Status</th>
        </tr>
      </thead>
      <tbody>
        <% for(Suite s : ocupadas) { %>
        <tr>
          <td><%= s.id %></td>
          <td><%= s.nome %></td>
          <td><%= s.descricao %></td>
          <td><span class="w3-tag w3-red w3-round"><%= s.status %></span></td>
        </tr>
        <% } %>
        <% if(ocupadas.isEmpty()) { %>
        <tr><td colspan="4" class="w3-center">Nenhuma suíte ocupada no momento.</td></tr>
        <% } %>
      </tbody>
    </table>
  </div>

</body>
</html>
