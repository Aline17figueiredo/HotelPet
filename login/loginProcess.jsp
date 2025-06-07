<%@ page import="dao.CadastroDAO" %>
<%@ page import="model.Cadastro" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>

<%
    request.setCharacterEncoding("UTF-8");

    String login = request.getParameter("login");
    String senha = request.getParameter("senha");

    CadastroDAO dao = new CadastroDAO();
    Cadastro usuario = null;

    try {
        usuario = dao.autenticar(login, senha);

        if (usuario != null) {
            session.setAttribute("usuarioLogado", usuario);
            session.setAttribute("mensagemLogin", "Login efetuado com sucesso!");
            response.sendRedirect("painel.jsp"); // redireciona após login
        } else {
            out.println("<script>alert('Login ou senha inválidos!'); window.location='login.jsp';</script>");
        }
    } catch (Exception e) {
        out.println("<h3>Erro no processamento do login:</h3>");
        java.io.StringWriter sw = new java.io.StringWriter();
        java.io.PrintWriter pw = new java.io.PrintWriter(sw);
        e.printStackTrace(pw);
        out.println("<pre>" + sw.toString() + "</pre>");
    }
%>
