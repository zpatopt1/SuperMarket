<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="pt-PT">
<head>
    <meta charset="UTF-8">
    <title>SuperMart - Sessão Terminada</title>
    
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Front-end/styles/styles.css" />
</head>
<body class="logout-bg"> 
    
    <div class="logout-wrapper">
        <div class="logout-icon">
            <svg width="72" height="72" viewBox="0 0 24 24" fill="none" stroke="#ffffff" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
                <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path>
                <polyline points="16 17 21 12 16 7"></polyline>
                <line x1="21" y1="12" x2="9" y2="12"></line>
            </svg>
        </div>

        <h2 class="logout-title">Sessão Terminada</h2>
        <p class="logout-message">Obrigado por utilizar o sistema SuperMart. A sua sessão foi encerrada com segurança.</p>

        <a href="${pageContext.request.contextPath}/login" class="btn-outline-white">VOLTAR AO LOGIN</a>
    </div>

</body>
</html>