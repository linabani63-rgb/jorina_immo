package mvcModel;

import entites.Facture;
import jakarta.ejb.LocalBean;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;

import java.util.List;

/**
 * Service EJB pour la gestion des factures.
 */
@Stateless
@LocalBean
public class FactureService {

    @PersistenceContext(unitName = "jorinaPU")
    private EntityManager em;

    /** Retourne toutes les factures. */
    public List<Facture> getAll() {
        return em.createNamedQuery("Facture.findAll", Facture.class)
                 .getResultList();
    }

    /** Retourne les factures d'un contrat. */
    public List<Facture> findByContract(Long contractId) {
        return em.createNamedQuery("Facture.findByContract", Facture.class)
                 .setParameter("contractId", contractId)
                 .getResultList();
    }

    /** Filtre les factures par statut (payee / non_payee / en_retard). */
    public List<Facture> findByStatus(String status) {
        return em.createNamedQuery("Facture.findByStatus", Facture.class)
                 .setParameter("status", status)
                 .getResultList();
    }

    /** Filtre les factures par type (loyer / charges / caution / autre). */
    public List<Facture> findByType(String type) {
        return em.createNamedQuery("Facture.findByType", Facture.class)
                 .setParameter("type", type)
                 .getResultList();
    }

    /** Cherche une facture par son id. */
    public Facture findById(Long id) {
        return em.find(Facture.class, id);
    }

    /** Persiste une nouvelle facture. */
    public void add(Facture facture) {
        em.persist(facture);
    }

    /** Met à jour une facture existante. */
    public Facture update(Facture facture) {
        return em.merge(facture);
    }

    /** Supprime une facture par son id. */
    public void delete(Long id) {
        Facture f = em.find(Facture.class, id);
        if (f != null) {
            em.remove(f);
        }
    }
}
