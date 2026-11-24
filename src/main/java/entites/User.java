package entites;

import jakarta.persistence.*;
import java.io.Serializable;
import java.util.List;

@Entity
@Table(name = "users")
@NamedQueries({
    @NamedQuery(name = "User.findAll",      query = "SELECT u FROM User u ORDER BY u.nom"),
    @NamedQuery(name = "User.findByEmail",  query = "SELECT u FROM User u WHERE u.email = :email"),
    @NamedQuery(name = "User.findByRole",   query = "SELECT u FROM User u WHERE u.role = :role"),
    @NamedQuery(name = "User.findTenants",  query = "SELECT u FROM User u WHERE u.role = 'locataire'")
})
public class User implements Serializable {
    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @Column(name = "nom", length = 100, nullable = false)
    private String nom;

    @Column(name = "prenom", length = 100, nullable = false)
    private String prenom;

    @Column(name = "email", length = 150, nullable = false, unique = true)
    private String email;

    @Column(name = "password", length = 255, nullable = false)
    private String password;

    @Column(name = "telephone", length = 20)
    private String telephone;

    @Column(name = "cin", length = 20)
    private String cin;

    /** admin | locataire | gestionnaire */
    @Column(name = "role", length = 30)
    private String role;

    // Un utilisateur (locataire) est lié à un appartement
    @ManyToOne(fetch =  FetchType.EAGER)
    @JoinColumn(name = "apartment_id")
    private Apartment apartment;

    // Un locataire peut avoir plusieurs contrats
    @OneToMany(mappedBy = "tenant", fetch = FetchType.EAGER)
    private List<Contract> contracts;

    // ── Constructeurs ──────────────────────────────────────────────────────────
    public User() {}

    // ── Getters & Setters ──────────────────────────────────────────────────────
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }

    public String getPrenom() { return prenom; }
    public void setPrenom(String prenom) { this.prenom = prenom; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getTelephone() { return telephone; }
    public void setTelephone(String telephone) { this.telephone = telephone; }

    public String getCin() { return cin; }
    public void setCin(String cin) { this.cin = cin; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public Apartment getApartment() { return apartment; }
    public void setApartment(Apartment apartment) { this.apartment = apartment; }

    public List<Contract> getContracts() { return contracts; }
    public void setContracts(List<Contract> contracts) { this.contracts = contracts; }

    /** Nom complet utilitaire */
    public String getNomComplet() { return prenom + " " + nom; }
}
