package com.nuvo.transaction.entity;

import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "transactions")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Transaction {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private Integer sourceUserId; // Quién envía
    private Integer targetUserId; // Quién recibe
    
    @Column(nullable = false)
    private BigDecimal amount;
    
    private String type; // TRANSFER, DEPOSIT, WITHDRAW
    
    private LocalDateTime timestamp;

    @PrePersist
    public void onCreate() {
        this.timestamp = LocalDateTime.now();
    }
}