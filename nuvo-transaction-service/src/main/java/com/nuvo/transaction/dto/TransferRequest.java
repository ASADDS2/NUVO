package com.nuvo.transaction.dto;
import lombok.Data;
import java.math.BigDecimal;

@Data
public class TransferRequest {
    private Integer sourceUserId;
    private Integer targetUserId;
    private BigDecimal amount;
}