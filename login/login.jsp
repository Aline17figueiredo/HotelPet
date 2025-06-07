<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8" />
  <title>Login</title>
  <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
</head>
<body class="w3-light-grey w3-padding-large">

  <div class="w3-container w3-white w3-padding-32 w3-card-4 w3-round-large" style="max-width:400px; margin:auto; margin-top:100px;">
    <h2 class="w3-center w3-text-teal">Login</h2>
    
    <form action="loginProcess.jsp" method="post" class="w3-container">
      <label for="login"><b>Usuário</b></label>
      <input class="w3-input w3-border w3-margin-bottom" type="text" id="login" name="login" required>

      <label for="senha"><b>Senha</b></label>
      <input class="w3-input w3-border w3-margin-bottom" type="password" id="senha" name="senha" required>

      <button type="submit" class="w3-button w3-teal w3-block w3-round">Entrar</button>
    </form>

    <p class="w3-center w3-margin-top">
      <a href="cadastro.jsp" class="w3-text-blue">Criar uma conta</a>
    </p>
  </div>

</body>
</html>
