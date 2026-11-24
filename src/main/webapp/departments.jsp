<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Jorina – Départements</title>
    <link rel="stylesheet" href="jorina.css">
</head>
<body>

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

    <%-- Message de succès --%>
    <c:if test="${not empty sessionScope.success}">
        <div class="alert alert-success">${sessionScope.success}</div>
        <c:remove var="success" scope="session"/>
    </c:if>

    <div class="page-header">
        <div>
            <div class="page-title">🏙️ Départements</div>
            <div class="page-subtitle">Gérez vos résidences et immeubles</div>
        </div>
        <button class="btn btn-primary" id="btn-ajout" onclick="openModal('modalAdd')">+ Ajouter un département</button>
    </div>

    <%-- ── Tableau des départements ─────────────────────────────────────────── --%>
    <div class="card">
        <div class="card-header">
            <span class="card-title">Liste des départements</span>
            <span style="color:var(--muted);font-size:.85rem">${departments.size()} résultat(s)</span>
        </div>
        <table>
            <thead>
                <tr>
                    <th>#</th>
                    <th>Nom</th>
                    <th>Adresse</th>
                    <th>Code Postal</th>
                    <th>Ville</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="dept" items="${departments}">
                    <tr>
                        <td>${dept.id}</td>
                        <td><strong>${dept.nom}</strong></td>
                        <td>${dept.address}</td>
                        <td>${dept.codePostal}</td>
                        <td>${dept.ville}</td>
                        <td>
                            <a href="Controller?action=listApartmentsByDepartment&deptId=${dept.id}"
                               class="btn btn-success btn-sm">🏠 Voir Apparts</a>
                            <form action="Controller" method="post" style="display:inline"
                                  onsubmit="return confirm('Supprimer ce département ?')">
                                <input type="hidden" name="action" value="deleteDepartment">
                                <input type="hidden" name="id"     value="${dept.id}">
                                <button type="submit" id="btn-supp" class="btn btn-danger btn-sm">🗑 Supprimer</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty departments}">
                    <tr><td colspan="6" style="text-align:center;color:var(--muted);padding:28px">Aucun département trouvé</td></tr>
                </c:if>
            </tbody>
        </table>
    </div>

</main>

<%-- ══════════════════════════════════════════════════════
     Modal – Ajouter un département
     ══════════════════════════════════════════════════════ --%>
<div id="modalAdd" class="modal-overlay">
    <div class="modal">
        <div class="modal-title">🏙️ Nouveau Département</div>
        <form action="Controller" method="post">
            <input type="hidden" name="action" value="addDepartment">

            <div class="form-group">
                <label>Nom *</label>
                <input type="text" id="nom" name="nom" placeholder="Résidence Les Oliviers" required>
            </div>
            <div class="form-group">
                <label>Adresse</label>
                <input type="text" id="adress" name="address" placeholder="12 Rue de la Paix">
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label>Code Postal</label>
                    <input type="text" id="code" name="codePostal" placeholder="1000">
                </div>
                <div class="form-group">
                    <label>Ville</label>
                    <input type="text" id="ville" name="ville" placeholder="Tunis">
                </div>
            </div>

            <div style="display:flex;gap:10px;justify-content:flex-end;margin-top:8px">
                <button type="button" id="annuler" class="btn btn-danger" onclick="closeModal('modalAdd')">Annuler</button>
                <button type="submit" id="enregistre" class="btn btn-primary">Enregistrer</button>
            </div>
        </form>
    </div>
</div>

<script>
    function openModal(id)  { document.getElementById(id).classList.add('open'); }
    function closeModal(id) { document.getElementById(id).classList.remove('open'); }
    // Fermer en cliquant sur l'overlay
    document.querySelectorAll('.modal-overlay').forEach(o =>
        o.addEventListener('click', e => { if (e.target === o) o.classList.remove('open'); })
    );
</script>
<script src="chatbot.js"></script>
</body>
</html>
