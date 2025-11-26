package com.nuvo.loan.infrastructure.entities;

import com.nuvo.loan.domain.model.InvestmentStatus; 
import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "pools")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PoolEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length = 100)
    private String name;

    @Column(length = 1000)
    private String description;

    @Column(nullable = false)
    private Double interestRatePerDay;

    @Column(nullable = false)
    private Integer maxParticipants;

    @Column(nullable = false)
    @Builder.Default
    private Boolean active = true;

    @Column(nullable = false)
    private LocalDateTime createdAt;

    @OneToMany(mappedBy = "pool", fetch = FetchType.LAZY)
    private List<InvestmentEntity> investments;

    @PrePersist
    public void onCreate() {
        this.createdAt = LocalDateTime.now();
        if (this.active == null) {
            this.active = true;
        }
    }
}
