<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="pt-pt">
  <head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>LogIn page</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Front-end/styles/stylelogin.css" />
  </head>
  <body class="d-flex-column">
    <section class="container d-flex-column">
    <img src="${pageContext.request.contextPath}/Front-end/assets/cart-icon.svg" alt="cart-icon" />  
      <!-- <h1 style="color: white;padding-top: 40px;font-family: serif;">SuperMarkT</H1> -->
      <form method="post" action="${pageContext.request.contextPath}/login">
        <div class="inp-container">
          <img src="${pageContext.request.contextPath}/Front-end/assets/user-icon.svg" alt="user icon" />
          <input class="inp" type="email" name="email" placeholder="Email" id="email" />
        </div>
        <div class="inp-container">
          <img src="${pageContext.request.contextPath}/Front-end/assets/lock-item.svg" alt="user icon" />
          <input
            class="inp"
            type="password"
            name="password"
            placeholder="Password"
            id="password"
          />
        </div>
        <%
          String erro = (String) request.getAttribute("erro");
          if (erro != null && !erro.isEmpty()) {
        %>
          <div style="margin:8px 0;color:#ffd9d9;font-size:14px;"><%= erro %></div>
        <% } %>
        <button type="submit" class="btn">LogIn</button>
      </form>
      
      
    </section>
  </body>
  <script type="module" src="/SuperMARKT/Front-end/js/pages/dashboard.js"></script>
</html>
