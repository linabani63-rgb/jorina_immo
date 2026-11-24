package entites;

import jakarta.persistence.*;
import java.io.Serializable;
import java.util.List;

@Entity
@Table(name = "departments")
@NamedQueries({
    @NamedQuery(name = "Department.findAll", query = "SELECT d FROM Department d ORDER BY d.nom"),
    @NamedQuery(name = "Department.findByVille", query = "SELECT d FROM Department d WHERE d.ville = :ville")
})
public class Department implements Serializable {
    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @Column(name = "nom", length = 100, nullable = false)
    private String nom;

    @Column(name = "address", columnDefinition = "TEXT")
    private String address;

    @Column(name = "code_postal", length = 10)
    private String codePostal;

    @Column(name = "ville", length = 100)
    private String ville;

    // Un département possède plusieurs appartements
    @OneToMany(mappedBy = "department", fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    private List<Apartment> apartments;

    // ── Constructeurs ──────────────────────────────────────────────────────────
    public Department() {}

    public Department(String nom, String address, String codePostal, String ville) {
        this.nom = nom;
        this.address = address;
        this.codePostal = codePostal;
        this.ville = ville;
    }

    // ── Getters & Setters ──────────────────────────────────────────────────────
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getCodePostal() { return codePostal; }
    public void setCodePostal(String codePostal) { this.codePostal = codePostal; }

    public String getVille() { return ville; }
    public void setVille(String ville) { this.ville = ville; }

    public List<Apartment> getApartments() { return apartments; }
    public void setApartments(List<Apartment> apartments) { this.apartments = apartments; }

    @Override
    public String toString() {
        return "Department{id=" + id + ", nom='" + nom + "', ville='" + ville + "'}";
    }
}
