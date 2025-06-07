<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String idStr = request.getParameter("id");
    int id = Integer.parseInt(idStr);

    String url = "jdbc:mysql://localhost:3306/empresa";
    String usuario = "root";
    String senha = "";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection(url, usuario, senha);

        // Excluir pets vinculados
        String sqlPet = "DELETE FROM Pet WHERE id_cliente=?";
        PreparedStatement psPet = conn.prepareStatement(sqlPet);
        psPet.setInt(1, id);
        psPet.executeUpdate();

        // Excluir cliente
        String sqlCliente = "DELETE FROM Cliente WHERE id_cliente=?";
        PreparedStatement psCliente = conn.prepareStatement(sqlCliente);
        psCliente.setInt(1, id);
        psCliente.executeUpdate();

        psPet.close();
        psCliente.close();
        conn.close();

        response.sendRedirect("clientes.jsp");
    } catch (Exception e) {
        out.println("Erro ao excluir: " + e.getMessage());
    }
%>
