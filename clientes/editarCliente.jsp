<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String idStr = request.getParameter("id");
    int id = Integer.parseInt(idStr);
    String nome = "", endereco = "", nomePet = "";
    int petId = 0;

    String url = "jdbc:mysql://localhost:3306/empresa";
    String usuario = "root";
    String senha = "";

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String novoNome = request.getParameter("nome");
        String novoEndereco = request.getParameter("endereco");
        String novoNomePet = request.getParameter("nomePet");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(url, usuario, senha);

            String sqlCliente = "UPDATE Cliente SET nome=?, endereco=? WHERE id_cliente=?";
            PreparedStatement ps1 = conn.prepareStatement(sqlCliente);
            ps1.setString(1, novoNome);
            ps1.setString(2, novoEndereco);
            ps1.setInt(3, id);
            ps1.executeUpdate();

            String sqlPet = "UPDATE Pet SET nome=? WHERE id_cliente=?";
            PreparedStatement ps2 = conn.prepareStatement(sqlPet);
            ps2.setString(1, novoNomePet);
            ps2.setInt(2, id);
            ps2.executeUpdate();

            ps1.close();
            ps2.close();
            conn.close();

            response.sendRedirect("clientes.jsp");
            return;

        } catch (Exception e) {
            out.println("Erro: " + e.getMessage());
        }
    } else {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(url, usuario, senha);
            String sql = "SELECT c.nome, c.endereco, p.nome AS nomePet FROM Cliente c LEFT JOIN Pet p ON c.id_cliente = p.id_cliente WHERE c.id_cliente=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                nome = rs.getString("nome");
                endereco = rs.getString("endereco");
                nomePet = rs.getString("nomePet");
            }

            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            out.println("Erro ao carregar dados: " + e.getMessage());
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Editar Cliente</title>
    <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
</head>
<body class="w3-light-grey w3-padding-large">

<div class="w3-container w3-white w3-card-4 w3-round-large w3-padding-32" style="max-width:600px; margin:auto;">
    <h2 class="w3-text-teal">Editar Cliente</h2>

    <form method="post" class="w3-container">
        <label>Nome:</label>
        <input class="w3-input w3-border w3-round" type="text" name="nome" value="<%= nome %>" required>

        <label>Email (Endereço):</label>
        <input class="w3-input w3-border w3-round" type="text" name="endereco" value="<%= endereco %>" required>

        <label>Nome do Pet:</label>
        <input class="w3-input w3-border w3-round" type="text" name="nomePet" value="<%= nomePet %>" required>

        <button type="submit" class="w3-button w3-teal w3-margin-top w3-round">Salvar Alterações</button>
        <a href="clientes.jsp" class="w3-button w3-gray w3-margin-top w3-round">Cancelar</a>
    </form>
</div>

</body>
</html>
