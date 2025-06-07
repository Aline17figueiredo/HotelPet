<%@ page import="java.sql.*, modelo.Suite, dao.SuiteDAO" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    int idSuite = 0;
    if (request.getParameter("id") != null) {
        idSuite = Integer.parseInt(request.getParameter("id"));
    }

    SuiteDAO dao = new SuiteDAO();
    Suite suite = null;

    // Se POST, atualiza suite e redireciona
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        try {
            idSuite = Integer.parseInt(request.getParameter("id"));
            String nome = request.getParameter("nome");
            int capacidade = Integer.parseInt(request.getParameter("capacidade"));
            float valor = Float.parseFloat(request.getParameter("valor"));

            suite = new Suite(idSuite, nome, capacidade, valor);
            dao.atualizar(suite);

            response.sendRedirect("suites.jsp");
            return;
        } catch (Exception e) {
            out.println("<p style='color:red;'>Erro ao atualizar suíte: " + e.getMessage() + "</p>");
        }
    } else {
        suite = dao.buscarPorId(idSuite);
    }

    if (suite == null) {
        out.println("<p>Suíte não encontrada.</p>");
        return;
    }
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8" />
  <title>Editar Suíte</title>
  <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css" />
</head>
<body class="w3-light-grey w3-padding-large">

<div class="w3-container w3-white w3-padding-32 w3-card-4 w3-round-large" style="max-width:500px; margin:auto;">
  <h2 class="w3-center w3-text-teal">Editar Suíte</h2>

  <form method="post" action="editarSuite.jsp?id=<%= idSuite %>">
    <label>Nome</label>
    <input type="text" name="nome" class="w3-input w3-margin-bottom" value="<%= suite.getNome() %>" required />

    <label>Capacidade</label>
    <input type="number" name="capacidade" class="w3-input w3-margin-bottom" value="<%= suite.getCapacidade() %>" required />

    <label>Valor</label>
    <input type="number" step="0.01" name="valor" class="w3-input w3-margin-bottom" value="<%= suite.getValor() %>" required />

    <button type="submit" class="w3-button w3-teal w3-round">Atualizar</button>
    <a href="suites.jsp" class="w3-button w3-light-grey w3-round">Cancelar</a>
  </form>
</div>

</body>
</html>
