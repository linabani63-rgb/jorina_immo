<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Jorina – Contrats</title>
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
            <div class="page-title">📄 Contrats
                <c:if test="${not empty apartment}">
                    – <span style="color:var(--primary)">${apartment.nom}</span>
                </c:if>
            </div>
            <div class="page-subtitle">
                <c:if test="${not empty apartment}">
                    <a href="Controller?action=listApartments" style="color:var(--primary)">← Tous les appartements</a>
                </c:if>
            </div>
        </div>
        <button class="btn btn-primary" id="btn-ajout" onclick="openModal('modalAdd')">+ Nouveau contrat</button>
    </div>

    <%-- ── Filtre par appartement ─────────────────────────────────────────────── --%>
    <div class="filter-bar">
        <form action="Controller" method="get" style="display:flex;gap:8px;align-items:center">
            <input type="hidden" name="action" value="listContractsByApartment">
            <label style="margin:0;white-space:nowrap">Appartement :</label>
            <select name="apId" onchange="this.form.submit()">
                <option value="">-- Tous --</option>
                <c:forEach var="ap" items="${apartments}">
                    <option value="${ap.id}" ${apartment != null && apartment.id == ap.id ? 'selected' : ''}>
                        ${ap.nom} (${ap.code})
                    </option>
                </c:forEach>
            </select>
            <c:if test="${not empty apartment}">
                <a href="Controller?action=listContracts" class="btn btn-sm" style="background:var(--bg)">✕ Effacer</a>
            </c:if>
        </form>
    </div>

    <%-- ── Tableau ──────────────────────────────────────────────────────────── --%>
    <div class="card">
        <div class="card-header">
            <span class="card-title">Liste des contrats</span>
            <span style="color:var(--muted);font-size:.85rem">${contracts.size()} résultat(s)</span>
        </div>
        <table>
            <thead>
                <tr>
                    <th>#</th>
                    <th>Locataire</th>
                    <th>Appartement</th>
                    <th>Date début</th>
                    <th>Date fin</th>
                    <th>Montant total</th>
                    <th>Caution</th>
                    <th>Statut</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="c" items="${contracts}">
                    <tr>
                        <td>${c.id}</td>
                        <td>
                            <strong>${c.tenant.prenom} ${c.tenant.nom}</strong><br>
                            <small style="color:var(--muted)">${c.tenant.email}</small>
                        </td>
                        <td>${c.apartment.nom}</td>
                        <td><fmt:formatDate value="${c.dateDebut}" pattern="dd/MM/yyyy"/></td>
                        <td>
                            <c:choose>
                                <c:when test="${c.dateFin != null}"><fmt:formatDate value="${c.dateFin}" pattern="dd/MM/yyyy"/></c:when>
                                <c:otherwise><span style="color:var(--muted)">–</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:if test="${c.montantTotal != null}">
                                <fmt:formatNumber value="${c.montantTotal}" type="number" maxFractionDigits="2"/> TND
                            </c:if>
                        </td>
                        <td>
                            <c:if test="${c.caution != null}">
                                <fmt:formatNumber value="${c.caution}" type="number" maxFractionDigits="2"/> TND
                            </c:if>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${c.status == 'actif'}"><span class="badge badge-success">Actif</span></c:when>
                                <c:when test="${c.status == 'termine'}"><span class="badge badge-muted">Terminé</span></c:when>
                                <c:when test="${c.status == 'resilie'}"><span class="badge badge-danger">Résilié</span></c:when>
                                <c:otherwise><span class="badge badge-info">${c.status}</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <a href="Controller?action=listFacturesByContract&contractId=${c.id}"
                               class="btn btn-success btn-sm">💳 Factures</a>
                            <form action="Controller" method="post" style="display:inline"
                                  onsubmit="return confirm('Supprimer ce contrat ?')">
                                <input type="hidden" name="action" value="deleteContract">
                                <input type="hidden" name="id"     value="${c.id}">
                                <button type="submit" class="btn btn-danger btn-sm">🗑</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty contracts}">
                    <tr><td colspan="9" style="text-align:center;color:var(--muted);padding:28px">Aucun contrat trouvé</td></tr>
                </c:if>
            </tbody>
        </table>
    </div>

</main>

<%-- ══════════════════════════════════════════════════════
     Modal – Nouveau contrat
     ══════════════════════════════════════════════════════ --%>
<div id="modalAdd" class="modal-overlay">
    <div class="modal">
        <div class="modal-title">📄 Nouveau Contrat</div>
        <form action="Controller" method="post">
            <input type="hidden" name="action" value="addContract">

            <div class="form-group">
                <label>Appartement *</label>
                <select name="apId" required>
                    <option value="">-- Choisir un appartement --</option>
                    <c:forEach var="ap" items="${apartments}">
                        <option value="${ap.id}" ${apartment != null && apartment.id == ap.id ? 'selected' : ''}>
                            ${ap.nom} – ${ap.code}
                        </option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-group">
                <label>Locataire *</label>
                <select name="tenantId" required>
                    <option value="">-- Choisir un locataire --</option>
                    <c:forEach var="t" items="${tenants}">
                        <option value="${t.id}">${t.prenom} ${t.nom} (${t.cin})</option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>Date début *</label>
                    <input type="date" name="dateDebut" required>
                </div>
                <div class="form-group">
                    <label>Date fin</label>
                    <input type="date" name="dateFin">
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>Montant total (TND)</label>
                    <input type="number" name="montantTotal" placeholder="12000" step="0.01" min="0">
                </div>
                <div class="form-group">
                    <label>Caution (TND)</label>
                    <input type="number" name="caution" placeholder="800" step="0.01" min="0">
                </div>
            </div>

            <div style="display:flex;gap:10px;justify-content:flex-end;margin-top:8px">
                <button type="button" class="btn btn-danger" onclick="closeModal('modalAdd')">Annuler</button>
                <button type="submit" id="enregistrer" class="btn btn-primary">Créer le contrat</button>
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
