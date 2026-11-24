package mvcModel;

import entites.Contract;
import jakarta.ejb.LocalBean;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;

import java.util.List;

/**
 * Service EJB pour la gestion des contrats de location.
 */
@Stateless
@LocalBean
public class ContractService {

    @PersistenceContext(unitName = "jorinaPU")
    private EntityManager em;

    /** Retourne tous les contrats. */
    public List<Contract> getAll() {
        return em.createNamedQuery("Contract.findAll", Contract.class)
                 .getResultList();
    }

    /** Retourne les contrats d'un appartement. */
    public List<Contract> findByApartment(Long apartmentId) {
        return em.createNamedQuery("Contract.findByApartment", Contract.class)
                 .setParameter("apId", apartmentId)
                 .getResultList();
    }

    /** Retourne les contrats d'un locataire. */
    public List<Contract> findByTenant(Long tenantId) {
        return em.createNamedQuery("Contract.findByTenant", Contract.class)
                 .setParameter("tenantId", tenantId)
                 .getResultList();
    }

    /** Retourne les contrats selon leur statut. */
    public List<Contract> findByStatus(String status) {
        return em.createNamedQuery("Contract.findByStatus", Contract.class)
                 .setParameter("status", status)
                 .getResultList();
    }

    /** Cherche un contrat par son id. */
    public Contract findById(Long id) {
        return em.find(Contract.class, id);
    }

    /** Persiste un nouveau contrat. */
    public void add(Contract contract) {
        em.persist(contract);
    }

    /** Met à jour un contrat existant. */
    public Contract update(Contract contract) {
        return em.merge(contract);
    }

    /** Supprime un contrat par son id. */
    public void delete(Long id) {
        Contract c = em.find(Contract.class, id);
        if (c != null) {
            em.remove(c);
        }
    }

    /** Compte les contrats actifs. */
    public long countActifs() {
        return em.createQuery(
                "SELECT COUNT(c) FROM Contract c WHERE c.status = 'actif'", Long.class)
                 .getSingleResult();
    }
}
