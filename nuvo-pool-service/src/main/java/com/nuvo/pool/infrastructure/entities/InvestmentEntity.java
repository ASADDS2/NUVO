package com.nuvo.pool.infrastructure.entities;

import com.nuvo.pool.domain.model.InvestmentStatus;
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
public class InvestmentEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private Integer userId;

    @Column(nullable = false)
    private BigDecimal investedAmount;

    @Column(nullable = false)
    private LocalDateTime investedAt;

    @Enumerated(EnumType.STRING)
    private InvestmentStatus status;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "pool_id")
    private PoolEntity pool;

    @PrePersist
    public void onCreate() {
        this.investedAt = LocalDateTime.now();
        if (this.status == null)
            this.status = InvestmentStatus.ACTIVE;
    }
}
