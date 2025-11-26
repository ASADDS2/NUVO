package com.nuvo.loan.infrastructure.entities;

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
public class LoanEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private Integer userId;

    @Column(nullable = false)
    private BigDecimal amount;

    @Column(nullable = false)
    private Integer termMonths;

    @Column(nullable = false)
    private BigDecimal interestRate;

    @Enumerated(EnumType.STRING)
    private com.nuvo.loan.domain.model.LoanStatus status;

    private LocalDateTime createdAt;
    private LocalDateTime approvedAt;

    @Column(nullable = false)
    private BigDecimal paidAmount;

    @PrePersist
    public void onCreate() {
        this.createdAt = LocalDateTime.now();
        if (this.status == null)
            this.status = com.nuvo.loan.domain.model.LoanStatus.PENDING;
        if (this.paidAmount == null)
            this.paidAmount = BigDecimal.ZERO;
    }
}
