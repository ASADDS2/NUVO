package com.nuvo.transaction.domain.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Transaction {
    private Long id;
    private Integer sourceUserId;
    private Integer targetUserId;
    private BigDecimal amount;
    private String type;
    private LocalDateTime timestamp;
}
