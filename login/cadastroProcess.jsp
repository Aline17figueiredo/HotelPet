<%@ page import="dao.CadastroDAO" %>
<%@ page import="model.Cadastro" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    request.setCharacterEncoding("UTF-8");

    String nome = request.getParameter("nome");
    String login = request.getParameter("login");
    String senha = request.getParameter("senha");

    CadastroDAO dao = new CadastroDAO();

    try {
        if (dao.existeLogin(login)) {
            out.println("<script>alert('Usuário já existe!'); window.location='cadastro.jsp';</script>");
        } else {
            Cadastro novo = new Cadastro();
            novo.setNome(nome);
            novo.setLogin(login);
            novo.setSenha(senha);

            boolean sucesso = dao.salvar(novo);
            if (sucesso) {
                out.println("<script>alert('Cadastro realizado com sucesso!'); window.location='login.jsp';</script>");
            } else {
                out.println("<script>alert('Erro ao cadastrar usuário!'); window.location='cadastro.jsp';</script>");
            }
        }
    } catch (Exception e) {
        out.println("<h3>Erro no processamento:</h3>");
        java.io.StringWriter sw = new java.io.StringWriter();
        java.io.PrintWriter pw = new java.io.PrintWriter(sw);
        e.printStackTrace(pw);
        out.println("<pre>" + sw.toString() + "</pre>");
    }
%>
