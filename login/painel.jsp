<%@ page import="model.Cadastro" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<%
    Cadastro usuarioLogado = (Cadastro) session.getAttribute("usuarioLogado");

    if (usuarioLogado == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <title>Painel do Usuário</title>
  <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
  <style>
    /* Estilo do modal de carregamento */
    #loadingModal {
      display: none; /* escondido inicialmente */
      position: fixed;
      z-index: 1000;
      left: 0; top: 0; right: 0; bottom: 0;
      background: rgba(255, 255, 255, 0.9);
      align-items: center;
      justify-content: center;
      flex-direction: column;
      font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
    }
    #loadingBar {
      width: 300px;
      height: 24px;
      background-color: #ddd;
      border-radius: 12px;
      overflow: hidden;
      margin-top: 20px;
    }
    #loadingProgress {
      height: 100%;
      width: 0%;
      background-color: #008080;
      border-radius: 12px;
      animation: progress 2s linear forwards;
    }
    @keyframes progress {
      from { width: 0%; }
      to { width: 100%; }
    }
  </style>

  <script>
    function irParaPaginaPrincipal() {
      // mostra o modal de carregamento
      var modal = document.getElementById("loadingModal");
      modal.style.display = "flex";

      // após 2 segundos redireciona para a página principal
      setTimeout(function() {
        window.location.href = "http://localhost:8080/WebApplicationPetHotelJ7/admin/index.html";
      }, 2000);
    }
  </script>
</head>
<body class="w3-light-grey w3-padding-large">

  <div class="w3-container w3-white w3-padding-32 w3-card-4 w3-round-large" style="max-width:600px; margin:auto; margin-top:100px;">
    <h2 class="w3-center w3-text-teal">Bem-vindo(a), <%= usuarioLogado.getNome() %>!</h2>
    
    <p class="w3-center w3-margin-top">O que deseja fazer agora?</p>

    <div class="w3-center w3-margin-top">
      <button onclick="irParaPaginaPrincipal()" class="w3-button w3-teal w3-margin w3-round-large">
        Ir para Página Principal
      </button>
      <a href="logout.jsp" class="w3-button w3-red w3-margin w3-round-large">Logout</a>
    </div>
  </div>

  <!-- Modal de carregamento -->
  <div id="loadingModal">
    <h3 class="w3-text-teal">Redirecionando para a Página Principal...</h3>
    <div id="loadingBar">
      <div id="loadingProgress"></div>
    </div>
  </div>

</body>
</html>
