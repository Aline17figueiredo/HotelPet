<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    // Configurações da conexão — ajuste para seu banco
    String url = "jdbc:mysql://localhost:3306/empresa";
    String usuario = "root";
    String senha = "";

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    // Se veio POST com dados do formulário, salva no banco
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        try {
            int petId = Integer.parseInt(request.getParameter("taskPetId"));
            String petName = request.getParameter("taskPetName"); // opcional, não usado no insert
            String data = request.getParameter("taskDate");
            String hora = request.getParameter("taskTime");
            String descricao = request.getParameter("taskDesc");

            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection(url, usuario, senha);

            String insertSQL = "INSERT INTO Agenda (cod_pet, data, hora, descricao) VALUES (?, ?, ?, ?)";
            ps = con.prepareStatement(insertSQL);
            ps.setInt(1, petId);
            ps.setDate(2, java.sql.Date.valueOf(data));
            ps.setTime(3, java.sql.Time.valueOf(hora + ":00")); // adiciona segundos
            ps.setString(4, descricao);

            ps.executeUpdate();

            // Fecha para poder seguir com consulta depois
            ps.close();
            con.close();

            // Redireciona para GET para evitar reenvio do form ao atualizar a página
            response.sendRedirect("agenda.jsp");
            return;

        } catch (Exception e) {
            e.printStackTrace();
            out.println("<p style='color:red;'>Erro ao salvar tarefa: " + e.getMessage() + "</p>");
        }
    }

    // Classe para carregar tarefas do banco
    class Tarefa {
        int codPet;
        String nomePet;
        String data;
        String hora;
        String descricao;
    }

    List<Tarefa> listaTarefas = new ArrayList<>();

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection(url, usuario, senha);

        String sql = "SELECT a.cod_pet, p.nome, a.data, a.hora, a.descricao " +
                     "FROM Agenda a JOIN Pet p ON a.cod_pet = p.cod_pet " +
                     "ORDER BY a.data, a.hora";

        ps = con.prepareStatement(sql);
        rs = ps.executeQuery();

        while (rs.next()) {
            Tarefa t = new Tarefa();
            t.codPet = rs.getInt("cod_pet");
            t.nomePet = rs.getString("nome");
            t.data = rs.getDate("data").toString();
            t.hora = rs.getTime("hora").toString().substring(0,5);
            t.descricao = rs.getString("descricao");
            listaTarefas.add(t);
        }

    } catch(Exception e) {
        e.printStackTrace();
    } finally {
        if(rs != null) try { rs.close(); } catch(Exception e) {}
        if(ps != null) try { ps.close(); } catch(Exception e) {}
        if(con != null) try { con.close(); } catch(Exception e) {}
    }

    // Criar um Set para nomes únicos dos pets
    Set<String> nomesPets = new TreeSet<>(); // ordena alfabeticamente
    for (Tarefa t : listaTarefas) {
        nomesPets.add(t.nomePet);
    }
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8" />
  <title>Agenda do Pet</title>
  <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css" />
  <style>
    .task-done {
      text-decoration: line-through;
      color: gray;
    }
  </style>
</head>
<body class="w3-light-grey w3-padding-large">

  <div class="w3-container w3-white w3-padding-32 w3-card-4 w3-round-large" style="max-width:700px; margin:auto;">
    <h2 class="w3-center w3-text-teal">Agenda do Pet</h2>

    <!-- Formulário de filtro -->
    <form id="filterForm" class="w3-row-padding w3-margin-bottom" onsubmit="filterTasks(event)">
      <div class="w3-col s4">
        <input type="text" id="filterPetId" placeholder="ID do Pet" class="w3-input" />
      </div>
      <div class="w3-col s4">
        <input type="text" id="filterPetName" placeholder="Nome do Pet" class="w3-input" />
      </div>
      <div class="w3-col s4">
        <input type="date" id="filterDate" class="w3-input" />
      </div>
      <div class="w3-col s12 w3-center w3-margin-top">
        <button type="submit" class="w3-button w3-teal w3-round">Filtrar</button>
        <button type="button" onclick="resetFilter()" class="w3-button w3-light-grey w3-round">Limpar</button>
      </div>
    </form>

    <div class="w3-margin-bottom">
      <strong>Pets cadastrados:</strong> 
      <%
        if (nomesPets.isEmpty()) {
          out.print("Nenhum pet cadastrado.");
        } else {
          out.print(String.join(", ", nomesPets));
        }
      %>
    </div>

    <button onclick="document.getElementById('newTaskForm').style.display='block'" 
            class="w3-button w3-teal w3-round w3-margin-bottom">➕ Adicionar tarefa</button>

    <ul id="taskList" class="w3-ul w3-card-4">
      <% for (Tarefa t : listaTarefas) { %>
        <li class="w3-padding" 
            data-petid="<%= t.codPet %>" 
            data-petname="<%= t.nomePet.toLowerCase() %>" 
            data-date="<%= t.data %>">
          <input type="checkbox" onchange="toggleDone(this)" /> 
          <strong><%= t.hora %></strong> - <%= t.descricao %>
        </li>
      <% } %>
    </ul>

    <!-- Formulário para adicionar nova tarefa -->
    <div id="newTaskForm" class="w3-modal" style="display:none;">
      <div class="w3-modal-content w3-animate-top w3-card-4">
        <header class="w3-container w3-teal">
          <span onclick="document.getElementById('newTaskForm').style.display='none'" 
                class="w3-button w3-display-topright">&times;</span>
          <h3>Nova tarefa</h3>
        </header>
        <div class="w3-container w3-padding">
          <form method="post" action="agenda.jsp">
            <label>ID do Pet</label>
            <input type="number" name="taskPetId" class="w3-input w3-margin-bottom" required />
            <label>Nome do Pet</label>
            <input type="text" name="taskPetName" class="w3-input w3-margin-bottom" required />
            <label>Data</label>
            <input type="date" name="taskDate" class="w3-input w3-margin-bottom" required />
            <label>Horário</label>
            <input type="time" name="taskTime" class="w3-input w3-margin-bottom" required />
            <label>Descrição</label>
            <input type="text" name="taskDesc" class="w3-input w3-margin-bottom" required />
            <button type="submit" class="w3-button w3-teal w3-round">Adicionar</button>
          </form>
        </div>
      </div>
    </div>

  </div>

  <script>
    function toggleDone(checkbox) {
      const li = checkbox.parentElement;
      li.classList.toggle('task-done', checkbox.checked);
    }

    function filterTasks(event) {
      event.preventDefault();

      const filterPetId = document.getElementById('filterPetId').value.trim();
      const filterPetName = document.getElementById('filterPetName').value.trim().toLowerCase();
      const filterDate = document.getElementById('filterDate').value;

      const taskList = document.getElementById('taskList');
      const tasks = taskList.getElementsByTagName('li');

      for (let task of tasks) {
        const petId = task.getAttribute('data-petid');
        const petName = task.getAttribute('data-petname');
        const date = task.getAttribute('data-date');

        let show = true;

        if (filterPetId && petId !== filterPetId) show = false;
        if (filterPetName && !petName.includes(filterPetName)) show = false;
        if (filterDate && date !== filterDate) show = false;

        task.style.display = show ? '' : 'none';
      }
    }

    function resetFilter() {
      document.getElementById('filterForm').reset();
      const tasks = document.getElementById('taskList').getElementsByTagName('li');
      for (let task of tasks) task.style.display = '';
    }
  </script>

</body>
</html>
