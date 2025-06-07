<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String jdbcURL = "jdbc:mysql://localhost:3306/empresa";
    String jdbcUser = "root";
    String jdbcPassword = "";

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    String acao = request.getParameter("acao");

    // ADICIONAR USUÁRIO
    if ("adicionar".equals(acao)) {
        String login = request.getParameter("login");
        String senha = request.getParameter("senha");
        String cargo = request.getParameter("cargo");
        if (login != null && senha != null && cargo != null &&
            !login.trim().isEmpty() && !senha.trim().isEmpty() && !cargo.trim().isEmpty()) {
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(jdbcURL, jdbcUser, jdbcPassword);
                stmt = conn.prepareStatement("INSERT INTO Login (login, senha, cargo) VALUES (?, ?, ?)");
                stmt.setString(1, login);
                stmt.setString(2, senha);
                stmt.setString(3, cargo);
                stmt.executeUpdate();
            } catch (Exception e) {
                out.println("<p style='color:red;'>Erro ao adicionar usuário: " + e.getMessage() + "</p>");
            } finally {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            }
        }
    }

    // EXCLUIR USUÁRIO
    if ("excluir".equals(acao)) {
        String id = request.getParameter("id");
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(jdbcURL, jdbcUser, jdbcPassword);
            stmt = conn.prepareStatement("DELETE FROM Login WHERE id_login = ?");
            stmt.setInt(1, Integer.parseInt(id));
            stmt.executeUpdate();
        } catch (Exception e) {
            out.println("<p style='color:red;'>Erro ao excluir usuário: " + e.getMessage() + "</p>");
        } finally {
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8" />
  <title>Gerenciar Usuários</title>
  <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css" />
</head>
<body class="w3-light-grey w3-padding">

<div class="w3-container w3-white w3-card-4 w3-round-large w3-padding-32" style="max-width:800px; margin:auto;">
  <h2 class="w3-center w3-text-teal">Gerenciar Usuários</h2>

  <!-- Formulário de Adição -->
  <form method="post" class="w3-section">
    <input class="w3-input w3-margin-bottom" type="text" name="login" placeholder="Novo usuário" required>
    <input class="w3-input w3-margin-bottom" type="password" name="senha" placeholder="Senha" required>
    <input class="w3-input w3-margin-bottom" type="text" name="cargo" placeholder="Cargo (ex: administrador)" required>
    <input type="hidden" name="acao" value="adicionar">
    <button type="submit" class="w3-button w3-teal w3-round">Adicionar Usuário</button>
  </form>

  <!-- Lista de Usuários -->
  <div class="w3-margin-top">
    <h5>Usuários Ativos</h5>
    <ul class="w3-ul">
      <%
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(jdbcURL, jdbcUser, jdbcPassword);
            stmt = conn.prepareStatement("SELECT * FROM Login");
            rs = stmt.executeQuery();
            while (rs.next()) {
      %>
      <li>
        <strong>ID:</strong> <%= rs.getInt("id_login") %> |
        <strong>Usuário:</strong> <%= rs.getString("login") %> |
        <strong>Cargo:</strong> <%= rs.getString("cargo") %>
        <form method="post" style="display:inline">
          <input type="hidden" name="acao" value="excluir">
          <input type="hidden" name="id" value="<%= rs.getInt("id_login") %>">
          <button class="w3-button w3-small w3-red w3-round w3-right">Excluir</button>
        </form>
      </li>
      <%
            }
        } catch (Exception e) {
            out.println("<p style='color:red;'>Erro ao listar usuários: " + e.getMessage() + "</p>");
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
      %>
    </ul>
  </div>
</div>

</body>
</html>
