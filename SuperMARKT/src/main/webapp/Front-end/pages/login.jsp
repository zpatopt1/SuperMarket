<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="pt-pt">
  <head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="stylesheet" href="../styles/stylelogin.css" />
    <title>LogIn page</title>
  </head>
  <body class="d-flex-column">
    <section class="container d-flex-column">
      <img src="../assets/cart-icon.svg" alt="cart-icon" />
      
      <!-- <h1 style="color: white;padding-top: 40px;font-family: serif;">SuperMarkT</H1> -->
      <form>
        <div class="inp-container">
          <img src="../assets/user-icon.svg" alt="user icon" />
          <input class="inp" type="text" name="name" placeholder="Username" id="username" />
        </div>
        <div class="inp-container">
          <img src="../assets/lock-item.svg" alt="user icon" />
          <input
            class="inp"
            type="password"
            name="password"
            placeholder="Password"
            id="password"
          />
        </div>
        <a href="/SuperMARKT/Front-end/dashboard.jsp" class="btn">LogIn</a>
      </form>
    </section>
  </body>
  <script type="module" src="/SuperMARKT/Front-end/js/pages/dashboard.js"></script>
</html>