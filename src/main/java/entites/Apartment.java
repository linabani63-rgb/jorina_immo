package entites;

import jakarta.persistence.*;
import java.io.Serializable;
import java.math.BigDecimal;
import java.util.List;

@Entity
@Table(name = "apartments")
@NamedQueries({
    @NamedQuery(name = "Apartment.findAll",      
        query = "SELECT a FROM Apartment a JOIN FETCH a.department ORDER BY a.nom"),
    @NamedQuery(name = "Apartment.findByDept",   
        query = "SELECT a FROM Apartment a JOIN FETCH a.department WHERE a.department.id = :deptId"),
    @NamedQuery(name = "Apartment.findByStatus", 
        query = "SELECT a FROM Apartment a JOIN FETCH a.department WHERE a.status = :status")
})
public class Apartment implements Serializable {
    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @Column(name = "nom", length = 100, nullable = false)
    private String nom;

    @Column(name = "code", length = 30, unique = true)
    private String code;

    @Column(name = "etage")
    private Integer etage;

    @Column(name = "price", precision = 10, scale = 2)
    private BigDecimal price;

    /** disponible | loue | en_maintenance */
    @Column(name = "status", length = 30)
    private String status;

    @Column(name = "photo", columnDefinition = "TEXT")
    private String photo;

    @Column(name = "description", columnDefinition = "TEXT")
    private String description;

    // ── Relations ─────────────────────────────────────────────────────────────
    @ManyToOne(fetch =  FetchType.EAGER)
    @JoinColumn(name = "department_id", nullable = false)
    private Department department;

    @OneToMany(mappedBy = "apartment", fetch = FetchType.EAGER, cascade = CascadeType.ALL)
    private List<Contract> contracts;

    @OneToMany(mappedBy = "apartment", fetch =FetchType.EAGER)
    private List<User> tenants;

    // ── Constructeurs ──────────────────────────────────────────────────────────
    public Apartment() {}

    // ── Getters & Setters ──────────────────────────────────────────────────────
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }

    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }

    public Integer getEtage() { return etage; }
    public void setEtage(Integer etage) { this.etage = etage; }

    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getPhoto() { return photo; }
    public void setPhoto(String photo) { this.photo = photo; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public Department getDepartment() { return department; }
    public void setDepartment(Department department) { this.department = department; }

    public List<Contract> getContracts() { return contracts; }
    public void setContracts(List<Contract> contracts) { this.contracts = contracts; }

    public List<User> getTenants() { return tenants; }
    public void setTenants(List<User> tenants) { this.tenants = tenants; }
}
