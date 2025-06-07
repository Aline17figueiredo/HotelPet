<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String url = "jdbc:mysql://localhost:3306/empresa";
    String usuario = "root";
    String senha = "";

    // Processamento do agendamento, se o formulário foi enviado
    String msg = null;
    if (request.getMethod().equalsIgnoreCase("POST")) {
        String idSuiteStr = request.getParameter("id_suite");
        String dataInicio = request.getParameter("data_inicio");
        String dataFim = request.getParameter("data_fim");

        if (idSuiteStr != null && dataInicio != null && dataFim != null) {
            int idSuite = Integer.parseInt(idSuiteStr);

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection con = DriverManager.getConnection(url, usuario, senha);

                // Atualiza o status da suíte para "Ocupada"
                String sqlUpdate = "UPDATE Suite SET status = 'Ocupada' WHERE id_suite = ?";
                PreparedStatement psUpdate = con.prepareStatement(sqlUpdate);
                psUpdate.setInt(1, idSuite);
                int linhasAfetadas = psUpdate.executeUpdate();
                if (linhasAfetadas > 0) {
                    msg = "Suíte ID " + idSuite + " agendada com sucesso!";
                } else {
                    msg = "Falha ao agendar a suíte.";
                }

                psUpdate.close();
                con.close();
            } catch (Exception e) {
                msg = "Erro ao agendar: " + e.getMessage();
                e.printStackTrace();
            }
        } else {
            msg = "Preencha todos os campos do formulário.";
        }
    }

    // Classe suite e listas
    class Suite {
        int id;
        String tipo;
        String descricao;
        String status;
    }

    List<Suite> suitesDisponiveis = new ArrayList<>();
    List<Suite> suitesOcupadas = new ArrayList<>();

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection(url, usuario, senha);

        String sql = "SELECT id_suite, tipo, descricao, status FROM Suite ORDER BY id_suite";
        PreparedStatement ps = con.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();

        while(rs.next()) {
            Suite s = new Suite();
            s.id = rs.getInt("id_suite");
            s.tipo = rs.getString("tipo");
            s.descricao = rs.getString("descricao");
            s.status = rs.getString("status");

            if ("Disponível".equalsIgnoreCase(s.status)) {
                suitesDisponiveis.add(s);
            } else {
                suitesOcupadas.add(s);
            }
        }

        rs.close();
        ps.close();
        con.close();

    } catch (Exception e) {
        out.println("<p style='color:red;'>Erro: " + e.getMessage() + "</p>");
        e.printStackTrace();
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

    <% if (msg != null) { %>
      <div class="w3-panel w3-blue w3-round w3-padding">
        <p><%= msg %></p>
      </div>
    <% } %>

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
        <%
          for(Suite s : suitesDisponiveis) {
        %>
        <tr>
          <td><%= s.id %></td>
          <td><%= s.tipo %></td>
          <td><%= s.descricao %></td>
          <td><span class="w3-tag w3-green w3-round"><%= s.status %></span></td>
        </tr>
        <% } %>
        <%
          if (suitesDisponiveis.isEmpty()) {
        %>
          <tr><td colspan="4" class="w3-center">Nenhuma suíte disponível</td></tr>
        <% } %>
      </tbody>
    </table>

    <h3 class="w3-text-teal">Suítes Ocupadas</h3>
    <table class="w3-table w3-striped w3-bordered w3-hoverable w3-white w3-margin-bottom">
      <thead>
        <tr class="w3-red">
          <th>ID Suíte</th>
          <th>Tipo</th>
          <th>Descrição</th>
          <th>Status</th>
        </tr>
      </thead>
      <tbody>
        <%
          for(Suite s : suitesOcupadas) {
        %>
        <tr>
          <td><%= s.id %></td>
          <td><%= s.tipo %></td>
          <td><%= s.descricao %></td>
          <td><span class="w3-tag w3-red w3-round"><%= s.status %></span></td>
        </tr>
        <% } %>
        <%
          if (suitesOcupadas.isEmpty()) {
        %>
          <tr><td colspan="4" class="w3-center">Nenhuma suíte ocupada</td></tr>
        <% } %>
      </tbody>
    </table>

    <h3 class="w3-text-teal">Agendar Suíte</h3>
    <form method="post" action="suites.jsp" class="w3-container w3-card-4 w3-padding w3-margin-bottom" style="max-width:600px;">
      <label>Escolha uma Suíte Disponível:</label>
      <select name="id_suite" class="w3-input w3-margin-bottom" required>
        <option value="" disabled selected>Selecione a suíte</option>
        <%
          for(Suite s : suitesDisponiveis) {
        %>
          <option value="<%= s.id %>"><%= s.tipo %> (ID: <%= s.id %>)</option>
        <% } %>
      </select>

      <label>Data de Início</label>
      <input type="date" name="data_inicio" class="w3-input w3-margin-bottom" required />

      <label>Data de Fim</label>
      <input type="date" name="data_fim" class="w3-input w3-margin-bottom" required />

      <button type="submit" class="w3-button w3-teal w3-round">Agendar</button>
    </form>

  </div>

</body>
</html>
