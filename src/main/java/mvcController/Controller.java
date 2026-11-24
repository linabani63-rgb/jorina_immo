package mvcController;

import entites.*;
import mvcModel.*;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

/**
 * Contrôleur principal de l'application Jorina.
 * Toutes les requêtes passent par /Controller?action=...
 */
@WebServlet("/Controller")
public class Controller extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // ── Injection des services EJB ─────────────────────────────────────────────
    @EJB private DepartmentService departmentService;
    @EJB private ApartmentService  apartmentService;
    @EJB private ContractService   contractService;
    @EJB private FactureService    factureService;
    @EJB private UserService       userService;

    // ═══════════════════════════════════════════════════════════════════════════
    //  doGet  –  Affichage
    // ═══════════════════════════════════════════════════════════════════════════
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        if (action == null) action = "dashboard";

        switch (action) {

            // ── Authentification ─────────────────────────────────────────────
            case "login":
                req.getRequestDispatcher("login.jsp").forward(req, resp);
                break;

            case "logout":
                req.getSession().invalidate();
                resp.sendRedirect("Controller?action=login");
                break;

            // ── Dashboard ────────────────────────────────────────────────────
            case "dashboard":
                requireLogin(req, resp);
                req.setAttribute("totalDepts",   departmentService.count());
                req.setAttribute("totalDispos",  apartmentService.countDisponibles());
                req.setAttribute("totalContrats",contractService.countActifs());
                req.setAttribute("recentFactures", factureService.getAll());
                req.getRequestDispatcher("dashboard.jsp").forward(req, resp);
                break;

            // ── Départements ─────────────────────────────────────────────────
            case "listDepartments":
                requireLogin(req, resp);
                req.setAttribute("departments", departmentService.getAll());
                req.getRequestDispatcher("departments.jsp").forward(req, resp);
                break;

            // ── Appartements ─────────────────────────────────────────────────
            case "listApartments":
                requireLogin(req, resp);
                List<Apartment> apartments = apartmentService.getAll();
                // Force le chargement du département pour chaque appartement
                for (Apartment ap : apartments) {
                    if (ap.getDepartment() != null) {
                        ap.getDepartment().getNom(); // force le chargement
                    }
                }
                req.setAttribute("apartments", apartments);
                req.setAttribute("departments", departmentService.getAll());
                req.getRequestDispatcher("apartments.jsp").forward(req, resp);
                break;
            case "listApartmentsByDepartment": {
                requireLogin(req, resp);
                Long deptId = parseLong(req.getParameter("deptId"));
                if (deptId != null) {
                    Department dept = departmentService.findById(deptId);
                    req.setAttribute("department", dept);
                    req.setAttribute("apartments", apartmentService.findByDepartment(deptId));
                }
                req.setAttribute("departments", departmentService.getAll());
                req.getRequestDispatcher("apartments.jsp").forward(req, resp);
                break;
            }

            // ── Contrats ─────────────────────────────────────────────────────
            case "listContracts":
                requireLogin(req, resp);
                req.setAttribute("contracts", contractService.getAll());
                req.setAttribute("apartments", apartmentService.getAll());
                req.setAttribute("tenants",    userService.getAllTenants());
                req.getRequestDispatcher("contracts.jsp").forward(req, resp);
                break;

            case "listContractsByApartment": {
                requireLogin(req, resp);
                Long apId = parseLong(req.getParameter("apId"));
                if (apId != null) {
                    Apartment ap = apartmentService.findById(apId);
                    req.setAttribute("apartment", ap);
                    req.setAttribute("contracts", contractService.findByApartment(apId));
                }
                req.setAttribute("apartments", apartmentService.getAll());
                req.setAttribute("tenants",    userService.getAllTenants());
                req.getRequestDispatcher("contracts.jsp").forward(req, resp);
                break;
            }

            // ── Factures ─────────────────────────────────────────────────────
            case "listFactures": {
                requireLogin(req, resp);
                String statusFilter = req.getParameter("statusFilter");
                List<Facture> factures = (statusFilter != null && !statusFilter.isEmpty())
                        ? factureService.findByStatus(statusFilter)
                        : factureService.getAll();
                req.setAttribute("factures",     factures);
                req.setAttribute("statusFilter", statusFilter);
                req.setAttribute("contracts",    contractService.getAll());
                req.getRequestDispatcher("factures.jsp").forward(req, resp);
                break;
            }

            case "listFacturesByContract": {
                requireLogin(req, resp);
                Long contractId = parseLong(req.getParameter("contractId"));
                if (contractId != null) {
                    Contract c = contractService.findById(contractId);
                    req.setAttribute("contract", c);
                    req.setAttribute("factures", factureService.findByContract(contractId));
                }
                req.setAttribute("contracts", contractService.getAll());
                req.getRequestDispatcher("factures.jsp").forward(req, resp);
                break;
            }

            // ── Utilisateurs ─────────────────────────────────────────────────
            case "listUsers":
                requireLogin(req, resp);
                req.setAttribute("users",      userService.getAll());
                req.setAttribute("apartments", apartmentService.getAll());
                req.getRequestDispatcher("users.jsp").forward(req, resp);
                break;

            default:
                resp.sendRedirect("Controller?action=dashboard");
        }
    }

    // ═══════════════════════════════════════════════════════════════════════════
    //  doPost  –  Modifications (ajout / suppression)
    // ═══════════════════════════════════════════════════════════════════════════
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        if (action == null) { doGet(req, resp); return; }

        switch (action) {

            // ── Login ────────────────────────────────────────────────────────
            case "login": {
                String email    = req.getParameter("email");
                String password = req.getParameter("password");
                User user = userService.authenticate(email, password);
                if (user != null && password.equals(user.getPassword())) {
                    req.getSession().setAttribute("loggedUser", user);
                    resp.sendRedirect("Controller?action=dashboard");
                } else {
                    req.setAttribute("error", "Email ou mot de passe incorrect.");
                    req.getRequestDispatcher("login.jsp").forward(req, resp);
                }
                break;
            }

            // ── Ajouter département ──────────────────────────────────────────
            case "addDepartment": {
                Department dept = new Department();
                dept.setNom(req.getParameter("nom"));
                dept.setAddress(req.getParameter("address"));
                dept.setCodePostal(req.getParameter("codePostal"));
                dept.setVille(req.getParameter("ville"));
                departmentService.add(dept);
                req.getSession().setAttribute("success", "Département ajouté avec succès !");
                resp.sendRedirect("Controller?action=listDepartments");
                break;
            }

            // ── Supprimer département ────────────────────────────────────────
            case "deleteDepartment": {
                Long id = parseLong(req.getParameter("id"));
                if (id != null) departmentService.delete(id);
                req.getSession().setAttribute("success", "Département supprimé.");
                resp.sendRedirect("Controller?action=listDepartments");
                break;
            }

            // ── Ajouter appartement ──────────────────────────────────────────
            case "addApartment": {
                Apartment ap = new Apartment();
                ap.setNom(req.getParameter("nom"));
                ap.setCode(req.getParameter("code"));
                ap.setEtage(parseInt(req.getParameter("etage")));
                ap.setPrice(parseBigDecimal(req.getParameter("price")));
                ap.setStatus(req.getParameter("status"));
                ap.setDescription(req.getParameter("description"));
                Long deptId = parseLong(req.getParameter("deptId"));
                if (deptId != null) {
                    ap.setDepartment(departmentService.findById(deptId));
                }
                apartmentService.add(ap);
                req.getSession().setAttribute("success", "Appartement ajouté avec succès !");
                resp.sendRedirect("Controller?action=listApartments");
                break;
            }

            // ── Supprimer appartement ────────────────────────────────────────
            case "deleteApartment": {
                Long id = parseLong(req.getParameter("id"));
                if (id != null) apartmentService.delete(id);
                req.getSession().setAttribute("success", "Appartement supprimé.");
                resp.sendRedirect("Controller?action=listApartments");
                break;
            }

            // ── Ajouter contrat ──────────────────────────────────────────────
            case "addContract": {
                Contract contract = new Contract();
                contract.setDateDebut(parseDate(req.getParameter("dateDebut")));
                contract.setDateFin(parseDate(req.getParameter("dateFin")));
                contract.setMontantTotal(parseBigDecimal(req.getParameter("montantTotal")));
                contract.setCaution(parseBigDecimal(req.getParameter("caution")));
                contract.setStatus("actif");
                Long apId = parseLong(req.getParameter("apId"));
                Long tenantId = parseLong(req.getParameter("tenantId"));
                if (apId != null)     contract.setApartment(apartmentService.findById(apId));
                if (tenantId != null) contract.setTenant(userService.findById(tenantId));
                contractService.add(contract);
                req.getSession().setAttribute("success", "Contrat créé avec succès !");
                resp.sendRedirect("Controller?action=listContracts");
                break;
            }

            // ── Supprimer contrat ────────────────────────────────────────────
            case "deleteContract": {
                Long id = parseLong(req.getParameter("id"));
                if (id != null) contractService.delete(id);
                req.getSession().setAttribute("success", "Contrat supprimé.");
                resp.sendRedirect("Controller?action=listContracts");
                break;
            }

            // ── Ajouter facture ──────────────────────────────────────────────
            case "addFacture": {
                Facture facture = new Facture();
                facture.setMontant(parseBigDecimal(req.getParameter("montant")));
                facture.setDateFacture(parseDate(req.getParameter("dateFacture")));
                facture.setType(req.getParameter("type"));
                facture.setStatus("non_payee");
                Long contractId = parseLong(req.getParameter("contractId"));
                if (contractId != null) facture.setContract(contractService.findById(contractId));
                factureService.add(facture);
                req.getSession().setAttribute("success", "Facture ajoutée avec succès !");
                resp.sendRedirect("Controller?action=listFactures");
                break;
            }

            // ── Supprimer facture ────────────────────────────────────────────
            case "deleteFacture": {
                Long id = parseLong(req.getParameter("id"));
                if (id != null) factureService.delete(id);
                req.getSession().setAttribute("success", "Facture supprimée.");
                resp.sendRedirect("Controller?action=listFactures");
                break;
            }

            // ── Marquer facture comme payée ──────────────────────────────────
            case "payFacture": {
                Long id = parseLong(req.getParameter("id"));
                if (id != null) {
                    Facture f = factureService.findById(id);
                    if (f != null) { f.setStatus("payee"); factureService.update(f); }
                }
                req.getSession().setAttribute("success", "Facture marquée comme payée !");
                resp.sendRedirect("Controller?action=listFactures");
                break;
            }

            // ── Ajouter utilisateur ──────────────────────────────────────────
            case "addUser": {
                User u = new User();
                u.setNom(req.getParameter("nom"));
                u.setPrenom(req.getParameter("prenom"));
                u.setEmail(req.getParameter("email"));
                u.setPassword(req.getParameter("password"));
                u.setTelephone(req.getParameter("telephone"));
                u.setCin(req.getParameter("cin"));
                u.setRole(req.getParameter("role"));
                Long apId = parseLong(req.getParameter("apId"));
                if (apId != null) u.setApartment(apartmentService.findById(apId));
                userService.add(u);
                req.getSession().setAttribute("success", "Utilisateur créé avec succès !");
                resp.sendRedirect("Controller?action=listUsers");
                break;
            }

            // ── Supprimer utilisateur ────────────────────────────────────────
            case "deleteUser": {
                Long id = parseLong(req.getParameter("id"));
                if (id != null) userService.delete(id);
                req.getSession().setAttribute("success", "Utilisateur supprimé.");
                resp.sendRedirect("Controller?action=listUsers");
                break;
            }

            default:
                doGet(req, resp);
        }
    }

    // ═══════════════════════════════════════════════════════════════════════════
    //  Utilitaires privés
    // ═══════════════════════════════════════════════════════════════════════════

    /** Vérifie que l'utilisateur est connecté, sinon redirige vers login. */
    private void requireLogin(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        if (req.getSession().getAttribute("loggedUser") == null) {
            resp.sendRedirect("Controller?action=login");
        }
    }

    private Long parseLong(String s) {
        try { return (s != null && !s.isEmpty()) ? Long.parseLong(s) : null; }
        catch (NumberFormatException e) { return null; }
    }

    private Integer parseInt(String s) {
        try { return (s != null && !s.isEmpty()) ? Integer.parseInt(s) : null; }
        catch (NumberFormatException e) { return null; }
    }

    private BigDecimal parseBigDecimal(String s) {
        try { return (s != null && !s.isEmpty()) ? new BigDecimal(s) : null; }
        catch (NumberFormatException e) { return null; }
    }

    private Date parseDate(String s) {
        try { return (s != null && !s.isEmpty()) ? new SimpleDateFormat("yyyy-MM-dd").parse(s) : null; }
        catch (ParseException e) { return null; }
    }
}
