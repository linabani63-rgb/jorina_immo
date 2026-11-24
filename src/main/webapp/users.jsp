<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Jorina – Utilisateurs</title>
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

    <c:if test="${not empty sessionScope.success}">
        <div class="alert alert-success">${sessionScope.success}</div>
        <c:remove var="success" scope="session"/>
    </c:if>

    <div class="page-header">
        <div>
            <div class="page-title">👥 Utilisateurs</div>
            <div class="page-subtitle">Gérez les comptes admin, gestionnaires et locataires</div>
        </div>
        <button class="btn btn-primary" onclick="openModal('modalAdd')">+ Ajouter un utilisateur</button>
    </div>

    <%-- ── Tableau ──────────────────────────────────────────────────────────── --%>
    <div class="card">
        <div class="card-header">
            <span class="card-title">Liste des utilisateurs</span>
            <span style="color:var(--muted);font-size:.85rem">${users.size()} résultat(s)</span>
        </div>
        <table>
            <thead>
                <tr>
                    <th>#</th>
                    <th>Nom complet</th>
                    <th>Email</th>
                    <th>Téléphone</th>
                    <th>CIN</th>
                    <th>Rôle</th>
                    <th>Appartement</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="u" items="${users}">
                    <tr>
                        <td>${u.id}</td>
                        <td><strong>${u.prenom} ${u.nom}</strong></td>
                        <td>${u.email}</td>
                        <td>${u.telephone}</td>
                        <td>${u.cin}</td>
                        <td>
                            <c:choose>
                                <c:when test="${u.role == 'admin'}">      <span class="badge badge-danger">Admin</span></c:when>
                                <c:when test="${u.role == 'gestionnaire'}"><span class="badge badge-info">Gestionnaire</span></c:when>
                                <c:when test="${u.role == 'locataire'}">  <span class="badge badge-success">Locataire</span></c:when>
                                <c:otherwise><span class="badge badge-muted">${u.role}</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${u.apartment != null}">${u.apartment.nom}</c:when>
                                <c:otherwise><span style="color:var(--muted)">–</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <form action="Controller" method="post" style="display:inline"
                                  onsubmit="return confirm('Supprimer cet utilisateur ?')">
                                <input type="hidden" name="action" value="deleteUser">
                                <input type="hidden" name="id"     value="${u.id}">
                                <button type="submit" class="btn btn-danger btn-sm">🗑 Supprimer</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty users}">
                    <tr><td colspan="8" style="text-align:center;color:var(--muted);padding:28px">Aucun utilisateur trouvé</td></tr>
                </c:if>
            </tbody>
        </table>
    </div>

</main>

<%-- ══════════════════════════════════════════════════════
     Modal – Ajouter un utilisateur
     ══════════════════════════════════════════════════════ --%>
<div id="modalAdd" class="modal-overlay">
    <div class="modal">
        <div class="modal-title">👤 Nouvel Utilisateur</div>
        <form action="Controller" method="post">
            <input type="hidden" name="action" value="addUser">

            <div class="form-row">
                <div class="form-group">
                    <label>Prénom *</label>
                    <input type="text" name="prenom" placeholder="Mohamed" required>
                </div>
                <div class="form-group">
                    <label>Nom *</label>
                    <input type="text" name="nom" placeholder="Ben Ali" required>
                </div>
            </div>

            <div class="form-group">
                <label>Email *</label>
                <input type="email" name="email" placeholder="m.benali@email.tn" required>
            </div>

            <div class="form-group">
                <label>Mot de passe *</label>
                <input type="password" name="password" placeholder="••••••••" required>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>Téléphone</label>
                    <input type="text" name="telephone" placeholder="+216 XX XXX XXX">
                </div>
                <div class="form-group">
                    <label>CIN</label>
                    <input type="text" name="cin" placeholder="12345678">
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>Rôle *</label>
                    <select name="role" required>
                        <option value="locataire">Locataire</option>
                        <option value="gestionnaire">Gestionnaire</option>
                        <option value="admin">Admin</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Appartement (si locataire)</label>
                    <select name="apId">
                        <option value="">-- Aucun --</option>
                        <c:forEach var="ap" items="${apartments}">
                            <option value="${ap.id}">${ap.nom} (${ap.code})</option>
                        </c:forEach>
                    </select>
                </div>
            </div>

            <div style="display:flex;gap:10px;justify-content:flex-end;margin-top:8px">
                <button type="button" class="btn btn-danger" onclick="closeModal('modalAdd')">Annuler</button>
                <button type="submit" class="btn btn-primary">Créer le compte</button>
            </div>
        </form>
    </div>
</div>

<script>
    function openModal(id)  { document.getElementById(id).classList.add('open'); }
    function closeModal(id) { document.getElementById(id).classList.remove('open'); }
    document.querySelectorAll('.modal-overlay').forEach(o =>
        o.addEventListener('click', e => { if (e.target === o) o.classList.remove('open'); })
    );
</script>
<script src="chatbot.js"></script>
</body>
</html>
