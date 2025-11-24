package com.nuvo.loan.entity;

import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "investments")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Investment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private Integer userId;

    @Column(nullable = false)
    private BigDecimal investedAmount; // Cuánto puso

    @Column(nullable = false)
    private LocalDateTime investedAt; // Cuándo lo puso

    @Enumerated(EnumType.STRING)
    private InvestmentStatus status; // ACTIVE, WITHDRAWN

    @PrePersist
    public void onCreate() {
        this.investedAt = LocalDateTime.now();
        if (this.status == null)
            this.status = InvestmentStatus.ACTIVE;
    }
}