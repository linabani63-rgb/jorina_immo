<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Jorina – Appartements</title>
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
            <div class="page-title">🏠 Appartements
                <c:if test="${not empty department}">
                    – <span style="color:var(--primary)">${department.nom}</span>
                </c:if>
            </div>
            <div class="page-subtitle">
                <c:choose>
                    <c:when test="${not empty department}">
                        <a href="Controller?action=listDepartments" style="color:var(--primary)">← Tous les départements</a>
                    </c:when>
                    <c:otherwise>Tous les appartements</c:otherwise>
                </c:choose>
            </div>
        </div>
        <button class="btn btn-primary" id="btn-ajout" onclick="openModal('modalAdd')">+ Ajouter un appartement</button>
    </div>

    <%-- ── Filtre par département ─────────────────────────────────────────────── --%>
    <div class="filter-bar">
        <form action="Controller" method="get" style="display:flex;gap:8px;align-items:center">
            <input type="hidden" name="action" value="listApartmentsByDepartment">
            <label style="margin:0;white-space:nowrap">Filtrer par département :</label>
            <select name="deptId" onchange="this.form.submit()">
                <option value="">-- Tous --</option>
                <c:forEach var="d" items="${departments}">
                    <option value="${d.id}" ${department != null && department.id == d.id ? 'selected' : ''}>
                        ${d.nom} – ${d.ville}
                    </option>
                </c:forEach>
            </select>
            <c:if test="${not empty department}">
                <a href="Controller?action=listApartments" class="btn btn-sm" style="background:var(--bg)">✕ Effacer</a>
            </c:if>
        </form>
    </div>

    <%-- ── Tableau ──────────────────────────────────────────────────────────── --%>
    <div class="card">
        <div class="card-header">
            <span class="card-title">Liste des appartements</span>
            <span style="color:var(--muted);font-size:.85rem">${apartments.size()} résultat(s)</span>
        </div>
        <table>
            <thead>
                <tr>
                    <th>#</th>
                    <th>Nom / Code</th>
                    <th>Étage</th>
                    <th>Prix / mois</th>
                    <th>Statut</th>
                    <th>Département</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="ap" items="${apartments}">
                    <tr>
                        <td>${ap.id}</td>
                        <td>
                            <strong>${ap.nom}</strong><br>
                            <small style="color:var(--muted)">${ap.code}</small>
                        </td>
                        <td>Étage ${ap.etage != null ? ap.etage : 'RDC'}</td>
                        <td>
                            <c:if test="${ap.price != null}">
                                <fmt:formatNumber value="${ap.price}" type="number" maxFractionDigits="2"/> TND
                            </c:if>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${ap.status == 'disponible'}"><span class="badge badge-success">Disponible</span></c:when>
                                <c:when test="${ap.status == 'loue'}"><span class="badge badge-warning">Loué</span></c:when>
                                <c:when test="${ap.status == 'en_maintenance'}"><span class="badge badge-danger">Maintenance</span></c:when>
                                <c:otherwise><span class="badge badge-muted">${ap.status}</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td>${ap.department.nom}</td>
                        <td>
                            <a href="Controller?action=listContractsByApartment&apId=${ap.id}"
                               class="btn btn-success btn-sm">📄 Contrats</a>
                            <form action="Controller" method="post" style="display:inline"
                                  onsubmit="return confirm('Supprimer cet appartement ?')">
                                <input type="hidden" name="action" value="deleteApartment">
                                <input type="hidden" name="id"     value="${ap.id}">
                                <button type="submit" class="btn btn-danger btn-sm">🗑</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty apartments}">
                    <tr><td colspan="7" style="text-align:center;color:var(--muted);padding:28px">Aucun appartement trouvé</td></tr>
                </c:if>
            </tbody>
        </table>
    </div>

</main>

<%-- ══════════════════════════════════════════════════════
     Modal – Ajouter un appartement
     ══════════════════════════════════════════════════════ --%>
<div id="modalAdd" class="modal-overlay">
    <div class="modal">
        <div class="modal-title">🏠 Nouvel Appartement</div>
        <form action="Controller" method="post">
            <input type="hidden" name="action" value="addApartment">

            <div class="form-row">
                <div class="form-group">
                    <label>Nom *</label>
                    <input type="text" name="nom" placeholder="Appart. 3A" required>
                </div>
                <div class="form-group">
                    <label>Code</label>
                    <input type="text" name="code" placeholder="APT-003A">
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>Étage</label>
                    <input type="number" name="etage" placeholder="1" min="0">
                </div>
                <div class="form-group">
                    <label>Prix / mois (TND)</label>
                    <input type="number" name="price" placeholder="800" step="0.01" min="0">
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>Statut *</label>
                    <select name="status" required>
                        <option value="disponible">Disponible</option>
                        <option value="loue">Loué</option>
                        <option value="en_maintenance">En maintenance</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Département *</label>
                    <select name="deptId" required>
                        <option value="">-- Choisir --</option>
                        <c:forEach var="d" items="${departments}">
                            <option value="${d.id}" ${department != null && department.id == d.id ? 'selected' : ''}>
                                ${d.nom}
                            </option>
                        </c:forEach>
                    </select>
                </div>
            </div>

            <div class="form-group">
                <label>Description</label>
                <textarea name="description" placeholder="Description de l'appartement..."></textarea>
            </div>

            <div style="display:flex;gap:10px;justify-content:flex-end;margin-top:8px">
                <button type="button" class="btn btn-danger" onclick="closeModal('modalAdd')">Annuler</button>
                <button type="submit" id="enregistrer" class="btn btn-primary">Enregistrer</button>
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
