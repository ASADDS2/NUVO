package com.nuvo.loan.entity;

import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "loans")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Loan {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private Integer userId;

    @Column(nullable = false)
    private BigDecimal amount; // Monto solicitado

    @Column(nullable = false)
    private Integer termMonths; // Plazo (ej: 12 meses)

    @Column(nullable = false)
    private BigDecimal interestRate; // Tasa mensual (ej: 0.02 = 2%)

    @Enumerated(EnumType.STRING)
    private LoanStatus status; // PENDING, APPROVED, REJECTED, PAID

    
    private LocalDateTime createdAt;
    private LocalDateTime approvedAt;
    
    @Column(nullable = false)
    private BigDecimal paidAmount; // Cuanto lleva pagado

    @PrePersist
    public void onCreate() {
        this.createdAt = LocalDateTime.now();
        if (this.status == null) this.status = LoanStatus.PENDING;
        if (this.paidAmount == null) this.paidAmount = BigDecimal.ZERO; // Inicializar en 0
    }
}