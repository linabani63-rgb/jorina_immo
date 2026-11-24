package mvcModel;

import entites.Apartment;
import entites.Department;
import jakarta.ejb.LocalBean;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;

import java.util.List;

/**
 * Service EJB pour la gestion des appartements.
 */
@Stateless
@LocalBean
public class ApartmentService {

    @PersistenceContext(unitName = "jorinaPU")
    private EntityManager em;

    /** Retourne tous les appartements. */
    public List<Apartment> getAll() {
        return em.createNamedQuery("Apartment.findAll", Apartment.class)
                 .getResultList();
    }

    /** Retourne les appartements d'un département. */
    public List<Apartment> findByDepartment(Long deptId) {
        return em.createNamedQuery("Apartment.findByDept", Apartment.class)
                 .setParameter("deptId", deptId)
                 .getResultList();
    }

    /** Retourne les appartements selon leur statut. */
    public List<Apartment> findByStatus(String status) {
        return em.createNamedQuery("Apartment.findByStatus", Apartment.class)
                 .setParameter("status", status)
                 .getResultList();
    }

    /** Cherche un appartement par son id. */
    public Apartment findById(Long id) {
        return em.find(Apartment.class, id);
    }

    /** Persiste un nouvel appartement. */
    public void add(Apartment apartment) {
        em.persist(apartment);
    }

    /** Met à jour un appartement existant. */
    public Apartment update(Apartment apartment) {
        return em.merge(apartment);
    }

    /** Supprime un appartement par son id. */
    public void delete(Long id) {
        Apartment a = em.find(Apartment.class, id);
        if (a != null) {
            em.remove(a);
        }
    }

    /** Compte le nombre d'appartements disponibles. */
    public long countDisponibles() {
        return em.createQuery(
                "SELECT COUNT(a) FROM Apartment a WHERE a.status = 'disponible'", Long.class)
                 .getSingleResult();
    }
}
