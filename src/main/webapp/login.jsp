<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Jorina – Connexion</title>
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600&family=Playfair+Display:wght@700&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        :root {
            --primary:   #1a56db;
            --primary-d: #1447b6;
            --bg:        #f0f4ff;
            --card:      #ffffff;
            --text:      #111827;
            --muted:     #6b7280;
            --border:    #e5e7eb;
            --danger:    #ef4444;
        }

        body {
            font-family: 'DM Sans', sans-serif;
            background: var(--bg);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .login-card {
            background: var(--card);
            border-radius: 16px;
            box-shadow: 0 8px 40px rgba(26,86,219,.12);
            padding: 48px 40px;
            width: 100%;
            max-width: 420px;
        }

        .brand {
            text-align: center;
            margin-bottom: 32px;
        }
        .brand h1 {
            font-family: 'Playfair Display', serif;
            font-size: 2rem;
            color: var(--primary);
        }
        .brand p { color: var(--muted); margin-top: 4px; font-size: .9rem; }

        .alert-error {
            background: #fef2f2;
            border: 1px solid #fecaca;
            color: var(--danger);
            padding: 10px 14px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: .875rem;
        }

        .form-group { margin-bottom: 20px; }
        label { display: block; font-weight: 500; margin-bottom: 6px; color: var(--text); font-size: .9rem; }
        input[type="email"], input[type="password"] {
            width: 100%;
            padding: 10px 14px;
            border: 1.5px solid var(--border);
            border-radius: 8px;
            font-size: .95rem;
            font-family: inherit;
            color: var(--text);
            transition: border-color .2s;
            outline: none;
        }
        input:focus { border-color: var(--primary); }

        .btn-login {
            width: 100%;
            padding: 12px;
            background: var(--primary);
            color: #fff;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 600;
            font-family: inherit;
            cursor: pointer;
            transition: background .2s;
        }
        .btn-login:hover { background: var(--primary-d); }

        .demo-hint {
            margin-top: 20px;
            text-align: center;
            font-size: .8rem;
            color: var(--muted);
        }
    </style>
</head>
<body>
<div class="login-card">
    <div class="brand">
        <h1>Jorina</h1>
        <p>Gestion Immobilière</p>
    </div>

    <!-- Message d'erreur -->
    <c:if test="${not empty error}">
        <div class="alert-error">${error}</div>
    </c:if>

    <form action="Controller" method="post">
        <input type="hidden" name="action" value="login">

        <div class="form-group">
            <label for="email">Adresse e-mail</label>
            <input type="email" id="email" name="email" placeholder="admin@jorina.tn" required>
        </div>

        <div class="form-group">
            <label for="password">Mot de passe</label>
            <input type="password" id="password" name="password" placeholder="••••••••" required>
        </div>

        <button type="submit" class="btn-login">Se connecter</button>
    </form>

    <p class="demo-hint">Demo : admin@jorina.tn / admin123</p>
</div>
</body>
</html>
