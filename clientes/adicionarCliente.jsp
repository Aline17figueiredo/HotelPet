<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String nome = request.getParameter("nome");
        String endereco = request.getParameter("endereco");
        String nomePet = request.getParameter("nomePet");

        String url = "jdbc:mysql://localhost:3306/empresa";
        String usuario = "root";
        String senha = "";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(url, usuario, senha);

            // Inserir cliente
            String sqlCliente = "INSERT INTO Cliente (nome, endereco) VALUES (?, ?)";
            PreparedStatement psCliente = conn.prepareStatement(sqlCliente, Statement.RETURN_GENERATED_KEYS);
            psCliente.setString(1, nome);
            psCliente.setString(2, endereco);
            psCliente.executeUpdate();

            // Obter ID gerado do cliente
            ResultSet rs = psCliente.getGeneratedKeys();
            int idCliente = 0;
            if (rs.next()) {
                idCliente = rs.getInt(1);
            }

            // Inserir pet vinculado ao cliente
            String sqlPet = "INSERT INTO Pet (nome, id_cliente) VALUES (?, ?)";
            PreparedStatement psPet = conn.prepareStatement(sqlPet);
            psPet.setString(1, nomePet);
            psPet.setInt(2, idCliente);
            psPet.executeUpdate();

            psCliente.close();
            psPet.close();
            conn.close();

            response.sendRedirect("clientes.jsp");
            return;

        } catch (Exception e) {
            out.println("Erro: " + e.getMessage());
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Adicionar Cliente</title>
    <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
</head>
<body class="w3-light-grey w3-padding-large">

<div class="w3-container w3-white w3-card-4 w3-round-large w3-padding-32" style="max-width:600px; margin:auto;">
    <h2 class="w3-text-teal">Adicionar Novo Cliente</h2>

    <form method="post" class="w3-container">
        <label>Nome do Cliente:</label>
        <input class="w3-input w3-border w3-round" type="text" name="nome" required>

        <label>Email (Endereço):</label>
        <input class="w3-input w3-border w3-round" type="text" name="endereco" required>

        <label>Nome do Pet:</label>
        <input class="w3-input w3-border w3-round" type="text" name="nomePet" required>

        <button type="submit" class="w3-button w3-teal w3-margin-top w3-round">Salvar</button>
        <a href="clientes.jsp" class="w3-button w3-gray w3-margin-top w3-round">Cancelar</a>
    </form>
</div>

</body>
</html>
