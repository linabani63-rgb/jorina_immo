<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Jorina – Dashboard</title>
    <link rel="stylesheet" href="jorina.css">
</head>
<body>

<%-- ── Sidebar ── --%>

<aside class="sidebar">
    <div class="sidebar-brand">
        <span class="brand-name">Jorina</span>
    </div>
    <nav class="sidebar-nav">
        <a href="Controller?action=dashboard" class="nav-item active">Dashboard</a>
        <a href="Controller?action=listDepartments" class="nav-item">Departements</a>
        <a href="Controller?action=listApartments" class="nav-item">Appartements</a>
        <a href="Controller?action=listContracts" class="nav-item">Contrats</a>
        <a href="Controller?action=listFactures" class="nav-item">Factures</a>
        <a href="Controller?action=listUsers" class="nav-item">Utilisateurs</a>
    </nav>
    <div class="sidebar-footer">
        <a href="Controller?action=logout" class="logout-btn">Deconnexion</a>
    </div>
</aside>

<main class="main">

    <%-- Message de succès de session --%>
    <c:if test="${not empty sessionScope.success}">
        <div class="alert alert-success">${sessionScope.success}</div>
        <c:remove var="success" scope="session"/>
    </c:if>

    <div class="page-header">
        <div>
            <div class="page-title">Tableau de bord</div>
            <div class="page-subtitle">Bienvenue, ${sessionScope.loggedUser.prenom} !</div>
        </div>
    </div>

    <%-- ── Statistiques ─────────────────────────────────────────────────────── --%>
    <div class="stats-grid">
        <div class="stat-card">
            <div class="stat-label">🏙️ Départements</div>
            <div class="stat-value">${totalDepts}</div>
        </div>
        <div class="stat-card">
            <div class="stat-label">🏠 Apparts. disponibles</div>
            <div class="stat-value">${totalDispos}</div>
        </div>
        <div class="stat-card">
            <div class="stat-label">📄 Contrats actifs</div>
            <div class="stat-value">${totalContrats}</div>
        </div>
    </div>

    <%-- ── Dernières factures ──────────────────────────────────────────────── --%>
    <div class="card">
        <div class="card-header">
            <span class="card-title">💳 Dernières factures</span>
            <a href="Controller?action=listFactures" class="btn btn-primary btn-sm">Voir tout</a>
        </div>
        <table>
            <thead>
                <tr>
                    <th>#</th>
                    <th>Date</th>
                    <th>Montant</th>
                    <th>Type</th>
                    <th>Statut</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="f" items="${recentFactures}" end="9">
                    <tr>
                        <td>${f.id}</td>
                        <td><fmt:formatDate value="${f.dateFacture}" pattern="dd/MM/yyyy"/></td>
                        <td><fmt:formatNumber value="${f.montant}" type="currency" currencyCode="TND"/></td>
                        <td><span class="badge badge-info">${f.type}</span></td>
                        <td>
                            <c:choose>
                                <c:when test="${f.status == 'payee'}"><span class="badge badge-success">Payée</span></c:when>
                                <c:when test="${f.status == 'en_retard'}"><span class="badge badge-danger">En retard</span></c:when>
                                <c:otherwise><span class="badge badge-warning">Non payée</span></c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty recentFactures}">
                    <tr><td colspan="5" style="text-align:center;color:var(--muted);padding:24px">Aucune facture enregistrée</td></tr>
                </c:if>
            </tbody>
        </table>
    </div>

    <%-- ── Raccourcis ──────────────────────────────────────────────────────── --%>
    <div style="display:grid;grid-template-columns:repeat(auto-fill,minmax(180px,1fr));gap:16px">
        <a href="Controller?action=listDepartments" class="btn btn-primary">🏙️ Départements</a>
        <a href="Controller?action=listApartments"  class="btn btn-primary">🏠 Appartements</a>
        <a href="Controller?action=listContracts"   class="btn btn-primary">📄 Contrats</a>
        <a href="Controller?action=listFactures"    class="btn btn-primary">💳 Factures</a>
        <a href="Controller?action=listUsers"       class="btn btn-primary">👥 Utilisateurs</a>
    </div>

</main>
<script src="chatbot.js"></script>
</body>
</html>
