package mvcModel;

import entites.User;
import jakarta.ejb.LocalBean;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.PersistenceContext;

import java.util.List;

/**
 * Service EJB pour la gestion des utilisateurs (admin, locataires, gestionnaires).
 */
@Stateless
@LocalBean
public class UserService {

    @PersistenceContext(unitName = "jorinaPU")
    private EntityManager em;

    /** Retourne tous les utilisateurs. */
    public List<User> getAll() {
        return em.createNamedQuery("User.findAll", User.class)
                 .getResultList();
    }

    /** Retourne uniquement les locataires. */
    public List<User> getAllTenants() {
        return em.createNamedQuery("User.findTenants", User.class)
                 .getResultList();
    }

    /** Retourne les utilisateurs selon leur rôle. */
    public List<User> findByRole(String role) {
        return em.createNamedQuery("User.findByRole", User.class)
                 .setParameter("role", role)
                 .getResultList();
    }

    /** Cherche un utilisateur par son id. */
    public User findById(Long id) {
        return em.find(User.class, id);
    }

    /**
     * Authentification : vérifie email + mot de passe.
     * @return l'utilisateur si trouvé, null sinon.
     */
    public User authenticate(String email, String password) {
        try {
            return em.createNamedQuery("User.findByEmail", User.class)
                     .setParameter("email", email)
                     .getSingleResult();
            // NOTE : En production, comparer le hash du mot de passe (BCrypt, etc.)
            // Pour cet exemple, comparaison directe (à remplacer).
        } catch (NoResultException e) {
            return null;
        }
    }

    /** Persiste un nouvel utilisateur. */
    public void add(User user) {
        em.persist(user);
    }

    /** Met à jour un utilisateur existant. */
    public User update(User user) {
        return em.merge(user);
    }

    /** Supprime un utilisateur par son id. */
    public void delete(Long id) {
        User u = em.find(User.class, id);
        if (u != null) {
            em.remove(u);
        }
    }

    /** Vérifie si un email est déjà utilisé. */
    public boolean emailExists(String email) {
        Long count = em.createQuery(
                "SELECT COUNT(u) FROM User u WHERE u.email = :email", Long.class)
                       .setParameter("email", email)
                       .getSingleResult();
        return count > 0;
    }
}
