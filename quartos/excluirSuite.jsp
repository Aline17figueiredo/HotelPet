<%@ page import="dao.SuiteDAO" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    int idSuite = 0;
    if (request.getParameter("id") != null) {
        idSuite = Integer.parseInt(request.getParameter("id"));
    } else {
        response.sendRedirect("suites.jsp");
        return;
    }

    SuiteDAO dao = new SuiteDAO();

    // Confirmar exclusão (GET)
    if (!"POST".equalsIgnoreCase(request.getMethod())) {
%>
        <!DOCTYPE html>
        <html lang="pt-BR">
        <head>
          <meta charset="UTF-8" />
          <title>Excluir Suíte</title>
          <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css" />
        </head>
        <body class="w3-light-grey w3-padding-large">

        <div class="w3-container w3-white w3-padding-32 w3-card-4 w3-round-large" style="max-width:400px; margin:auto;">
          <h2 class="w3-center w3-text-red">Excluir Suíte</h2>
          <p>Tem certeza que deseja excluir a suíte de ID <strong><%= idSuite %></strong>?</p>

          <form method="post" action="excluirSuite.jsp?id=<%= idSuite %>">
            <button type="submit" class="w3-button w3-red w3-round">Sim, excluir</button>
            <a href="suites.jsp" class="w3-button w3-light-grey w3-round">Cancelar</a>
          </form>
        </div>

        </body>
        </html>
<%
    } else {
        // POST: Executa exclusão
        try {
            dao.excluir(idSuite);
            response.sendRedirect("suites.jsp");
            return;
        } catch (Exception e) {
            out.println("<p style='color:red;'>Erro ao excluir suíte: " + e.getMessage() + "</p>");
        }
    }
%>
