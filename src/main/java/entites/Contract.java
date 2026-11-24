package entites;

import jakarta.persistence.*;
import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

@Entity
@Table(name = "contracts")
@NamedQueries({
    @NamedQuery(name = "Contract.findAll",           query = "SELECT c FROM Contract c ORDER BY c.dateDebut DESC"),
    @NamedQuery(name = "Contract.findByApartment",   query = "SELECT c FROM Contract c WHERE c.apartment.id = :apId"),
    @NamedQuery(name = "Contract.findByTenant",      query = "SELECT c FROM Contract c WHERE c.tenant.id = :tenantId"),
    @NamedQuery(name = "Contract.findByStatus",      query = "SELECT c FROM Contract c WHERE c.status = :status")
})
public class Contract implements Serializable {
    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @Column(name = "date_debut", nullable = false)
    @Temporal(TemporalType.DATE)
    private Date dateDebut;

    @Column(name = "date_fin")
    @Temporal(TemporalType.DATE)
    private Date dateFin;

    @Column(name = "montant_total", precision = 10, scale = 2)
    private BigDecimal montantTotal;

    @Column(name = "caution", precision = 10, scale = 2)
    private BigDecimal caution;

    /** actif | termine | resilie */
    @Column(name = "status", length = 30)
    private String status;

    // ── Relations ─────────────────────────────────────────────────────────────
    @ManyToOne(fetch =  FetchType.EAGER)
    @JoinColumn(name = "apartment_id", nullable = false)
    private Apartment apartment;

    @ManyToOne(fetch =  FetchType.EAGER)
    @JoinColumn(name = "tenant_id", nullable = false)
    private User tenant;

    @OneToMany(mappedBy = "contract", fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    private List<Facture> factures;

    // ── Constructeurs ──────────────────────────────────────────────────────────
    public Contract() {}

    // ── Getters & Setters ──────────────────────────────────────────────────────
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Date getDateDebut() { return dateDebut; }
    public void setDateDebut(Date dateDebut) { this.dateDebut = dateDebut; }

    public Date getDateFin() { return dateFin; }
    public void setDateFin(Date dateFin) { this.dateFin = dateFin; }

    public BigDecimal getMontantTotal() { return montantTotal; }
    public void setMontantTotal(BigDecimal montantTotal) { this.montantTotal = montantTotal; }

    public BigDecimal getCaution() { return caution; }
    public void setCaution(BigDecimal caution) { this.caution = caution; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Apartment getApartment() { return apartment; }
    public void setApartment(Apartment apartment) { this.apartment = apartment; }

    public User getTenant() { return tenant; }
    public void setTenant(User tenant) { this.tenant = tenant; }

    public List<Facture> getFactures() { return factures; }
    public void setFactures(List<Facture> factures) { this.factures = factures; }
}
