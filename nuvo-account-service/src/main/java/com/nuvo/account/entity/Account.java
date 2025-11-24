package com.nuvo.account.entity;

import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "accounts")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Account {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true)
    private Integer userId; // Guardamos el ID del usuario que viene del Auth Service

    @Column(nullable = false, unique = true)
    private String accountNumber;

    @Column(nullable = false)
    private BigDecimal balance;

    private LocalDateTime createdAt;

    @PrePersist
    public void prePersist() {
        this.createdAt = LocalDateTime.now();
        if (this.balance == null) this.balance = BigDecimal.ZERO;
    }
}