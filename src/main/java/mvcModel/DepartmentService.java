package mvcModel;

import entites.Department;
import jakarta.ejb.LocalBean;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;

import java.util.List;

/**
 * Service EJB pour la gestion des départements.
 */
@Stateless
@LocalBean
public class DepartmentService {

    @PersistenceContext(unitName = "jorinaPU")
    private EntityManager em;

    /** Retourne tous les départements triés par nom. */
    public List<Department> getAll() {
        return em.createNamedQuery("Department.findAll", Department.class)
                 .getResultList();
    }

    /** Cherche un département par son id. */
    public Department findById(Long id) {
        return em.find(Department.class, id);
    }

    /** Persiste un nouveau département. */
    public void add(Department dept) {
        em.persist(dept);
    }

    /** Met à jour un département existant. */
    public Department update(Department dept) {
        return em.merge(dept);
    }

    /** Supprime un département par son id. */
    public void delete(Long id) {
        Department d = em.find(Department.class, id);
        if (d != null) {
            em.remove(d);
        }
    }

    /** Compte le nombre total de départements. */
    public long count() {
        return em.createQuery("SELECT COUNT(d) FROM Department d", Long.class)
                 .getSingleResult();
    }
}
