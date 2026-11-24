package entites;

import jakarta.persistence.*;
import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

@Entity
@Table(name = "factures")
@NamedQueries({
    @NamedQuery(name = "Facture.findAll",         query = "SELECT f FROM Facture f ORDER BY f.dateFacture DESC"),
    @NamedQuery(name = "Facture.findByContract",  query = "SELECT f FROM Facture f WHERE f.contract.id = :contractId"),
    @NamedQuery(name = "Facture.findByStatus",    query = "SELECT f FROM Facture f WHERE f.status = :status"),
    @NamedQuery(name = "Facture.findByType",      query = "SELECT f FROM Facture f WHERE f.type = :type")
})
public class Facture implements Serializable {
    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @Column(name = "montant", precision = 10, scale = 2, nullable = false)
    private BigDecimal montant;

    @Column(name = "date_facture", nullable = false)
    @Temporal(TemporalType.DATE)
    private Date dateFacture;

    /** payee | non_payee | en_retard */
    @Column(name = "status", length = 30)
    private String status;

    /** loyer | charges | caution | autre */
    @Column(name = "type", length = 30)
    private String type;

    // ── Relation ──────────────────────────────────────────────────────────────
    @ManyToOne(fetch =  FetchType.EAGER)
    @JoinColumn(name = "contract_id", nullable = false)
    private Contract contract;

    // ── Constructeurs ──────────────────────────────────────────────────────────
    public Facture() {}

    // ── Getters & Setters ──────────────────────────────────────────────────────
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public BigDecimal getMontant() { return montant; }
    public void setMontant(BigDecimal montant) { this.montant = montant; }

    public Date getDateFacture() { return dateFacture; }
    public void setDateFacture(Date dateFacture) { this.dateFacture = dateFacture; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public Contract getContract() { return contract; }
    public void setContract(Contract contract) { this.contract = contract; }
}
