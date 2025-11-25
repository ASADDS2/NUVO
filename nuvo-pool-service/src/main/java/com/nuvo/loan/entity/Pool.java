package com.nuvo.loan.entity;

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
public class Pool {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length = 100)
    private String name;

    @Column(length = 1000)
    private String description;

    @Column(nullable = false)
    private Double interestRatePerDay; // Tasa de interés diaria (ej: 0.01 = 1% por día)

    @Column(nullable = false)
    private Integer maxParticipants; // Límite de inversores

    @Column(nullable = false)
    @Builder.Default
    private Boolean active = true; // Estado del pool

    @Column(nullable = false)
    private LocalDateTime createdAt;

    @OneToMany(mappedBy = "pool", fetch = FetchType.LAZY)
    @com.fasterxml.jackson.annotation.JsonManagedReference
    private List<Investment> investments;

    @PrePersist
    public void onCreate() {
        this.createdAt = LocalDateTime.now();
        if (this.active == null) {
            this.active = true;
        }
    }

    /**
     * Obtiene el número actual de inversores activos en este pool
     */
    public int getCurrentParticipantsCount() {
        if (investments == null) {
            return 0;
        }
        return (int) investments.stream()
                .filter(inv -> inv.getStatus() == InvestmentStatus.ACTIVE)
                .map(Investment::getUserId)
                .distinct()
                .count();
    }

    /**
     * Verifica si el pool está lleno
     */
    public boolean isFull() {
        return getCurrentParticipantsCount() >= maxParticipants;
    }

    /**
     * Verifica si el pool puede aceptar un nuevo inversor
     */
    public boolean canAcceptNewInvestor() {
        return active && !isFull();
    }
}
