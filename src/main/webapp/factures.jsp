<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Jorina – Factures</title>
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
            <div class="page-title">💳 Factures
                <c:if test="${not empty contract}">
                    – Contrat #${contract.id}
                </c:if>
            </div>
            <div class="page-subtitle">
                <c:if test="${not empty contract}">
                    <a href="Controller?action=listContracts" style="color:var(--primary)">← Tous les contrats</a>
                </c:if>
            </div>
        </div>
        <button class="btn btn-primary" onclick="openModal('modalAdd')">+ Ajouter une facture</button>
    </div>

    <%-- ── Barre de filtres ────────────────────────────────────────────────────── --%>
    <div class="filter-bar">
        <%-- Filtre par contrat --%>
        <form action="Controller" method="get" style="display:flex;gap:8px;align-items:center">
            <input type="hidden" name="action" value="listFacturesByContract">
            <label style="margin:0;white-space:nowrap">Contrat :</label>
            <select name="contractId" onchange="this.form.submit()">
                <option value="">-- Tous --</option>
                <c:forEach var="ct" items="${contracts}">
                    <option value="${ct.id}" ${contract != null && contract.id == ct.id ? 'selected' : ''}>
                        #${ct.id} – ${ct.tenant.prenom} ${ct.tenant.nom}
                    </option>
                </c:forEach>
            </select>
            <c:if test="${not empty contract}">
                <a href="Controller?action=listFactures" class="btn btn-sm" style="background:var(--bg)">✕ Effacer</a>
            </c:if>
        </form>

        <%-- Filtre par statut --%>
        <form action="Controller" method="get" style="display:flex;gap:8px;align-items:center">
            <input type="hidden" name="action" value="listFactures">
            <label style="margin:0;white-space:nowrap">Statut :</label>
            <select name="statusFilter" onchange="this.form.submit()">
                <option value="">-- Tous --</option>
                <option value="non_payee"  ${statusFilter == 'non_payee'  ? 'selected' : ''}>Non payée</option>
                <option value="payee"      ${statusFilter == 'payee'      ? 'selected' : ''}>Payée</option>
                <option value="en_retard"  ${statusFilter == 'en_retard'  ? 'selected' : ''}>En retard</option>
            </select>
            <c:if test="${not empty statusFilter}">
                <a href="Controller?action=listFactures" class="btn btn-sm" style="background:var(--bg)">✕ Effacer</a>
            </c:if>
        </form>
    </div>

    <%-- ── Tableau ──────────────────────────────────────────────────────────── --%>
    <div class="card">
        <div class="card-header">
            <span class="card-title">Liste des factures</span>
            <span style="color:var(--muted);font-size:.85rem">${factures.size()} résultat(s)</span>
        </div>
        <table>
            <thead>
                <tr>
                    <th>#</th>
                    <th>Contrat / Locataire</th>
                    <th>Date</th>
                    <th>Montant</th>
                    <th>Type</th>
                    <th>Statut</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="f" items="${factures}">
                    <tr>
                        <td>${f.id}</td>
                        <td>
                            Contrat #${f.contract.id}<br>
                            <small style="color:var(--muted)">
                                ${f.contract.tenant.prenom} ${f.contract.tenant.nom}
                            </small>
                        </td>
                        <td><fmt:formatDate value="${f.dateFacture}" pattern="dd/MM/yyyy"/></td>
                        <td><strong><fmt:formatNumber value="${f.montant}" type="number" maxFractionDigits="2"/> TND</strong></td>
                        <td>
                            <c:choose>
                                <c:when test="${f.type == 'loyer'}">   <span class="badge badge-info">Loyer</span></c:when>
                                <c:when test="${f.type == 'charges'}"> <span class="badge badge-warning">Charges</span></c:when>
                                <c:when test="${f.type == 'caution'}"> <span class="badge badge-muted">Caution</span></c:when>
                                <c:otherwise><span class="badge badge-muted">${f.type}</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${f.status == 'payee'}">    <span class="badge badge-success">✓ Payée</span></c:when>
                                <c:when test="${f.status == 'en_retard'}"><span class="badge badge-danger">⚠ En retard</span></c:when>
                                <c:otherwise><span class="badge badge-warning">Non payée</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <%-- Marquer comme payée --%>
                            <c:if test="${f.status != 'payee'}">
                                <form action="Controller" method="post" style="display:inline">
                                    <input type="hidden" name="action" value="payFacture">
                                    <input type="hidden" name="id"     value="${f.id}">
                                    <button type="submit" class="btn btn-success btn-sm">✓ Payer</button>
                                </form>
                            </c:if>
                            <%-- Supprimer --%>
                            <form action="Controller" method="post" style="display:inline"
                                  onsubmit="return confirm('Supprimer cette facture ?')">
                                <input type="hidden" name="action" value="deleteFacture">
                                <input type="hidden" name="id"     value="${f.id}">
                                <button type="submit" class="btn btn-danger btn-sm">🗑</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty factures}">
                    <tr><td colspan="7" style="text-align:center;color:var(--muted);padding:28px">Aucune facture trouvée</td></tr>
                </c:if>
            </tbody>
        </table>
    </div>

</main>

<%-- ══════════════════════════════════════════════════════
     Modal – Ajouter une facture
     ══════════════════════════════════════════════════════ --%>
<div id="modalAdd" class="modal-overlay">
    <div class="modal">
        <div class="modal-title">💳 Nouvelle Facture</div>
        <form action="Controller" method="post">
            <input type="hidden" name="action" value="addFacture">

            <div class="form-group">
                <label>Contrat *</label>
                <select name="contractId" required>
                    <option value="">-- Choisir un contrat --</option>
                    <c:forEach var="ct" items="${contracts}">
                        <option value="${ct.id}" ${contract != null && contract.id == ct.id ? 'selected' : ''}>
                            #${ct.id} – ${ct.tenant.prenom} ${ct.tenant.nom} / ${ct.apartment.nom}
                        </option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>Montant (TND) *</label>
                    <input type="number" name="montant" placeholder="800" step="0.01" min="0" required>
                </div>
                <div class="form-group">
                    <label>Date facture *</label>
                    <input type="date" name="dateFacture" required>
                </div>
            </div>

            <div class="form-group">
                <label>Type *</label>
                <select name="type" required>
                    <option value="loyer">Loyer</option>
                    <option value="charges">Charges</option>
                    <option value="caution">Caution</option>
                    <option value="autre">Autre</option>
                </select>
            </div>

            <div style="display:flex;gap:10px;justify-content:flex-end;margin-top:8px">
                <button type="button" class="btn btn-danger" onclick="closeModal('modalAdd')">Annuler</button>
                <button type="submit" class="btn btn-primary">Enregistrer</button>
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
