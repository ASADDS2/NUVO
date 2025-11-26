package com.nuvo.loan.infrastructure.mappers;

import com.nuvo.loan.domain.model.Loan;
import com.nuvo.loan.infrastructure.entities.LoanEntity;
import org.springframework.stereotype.Component;

@Component
public class LoanMapper {

    public Loan toDomain(LoanEntity entity) {
        if (entity == null)
            return null;
        return Loan.builder()
                .id(entity.getId())
                .userId(entity.getUserId())
                .amount(entity.getAmount())
                .termMonths(entity.getTermMonths())
                .interestRate(entity.getInterestRate())
                .status(entity.getStatus())
                .createdAt(entity.getCreatedAt())
                .approvedAt(entity.getApprovedAt())
                .paidAmount(entity.getPaidAmount())
                .build();
    }

    public LoanEntity toEntity(Loan domain) {
        if (domain == null)
            return null;
        return LoanEntity.builder()
                .id(domain.getId())
                .userId(domain.getUserId())
                .amount(domain.getAmount())
                .termMonths(domain.getTermMonths())
                .interestRate(domain.getInterestRate())
                .status(domain.getStatus())
                .createdAt(domain.getCreatedAt())
                .approvedAt(domain.getApprovedAt())
                .paidAmount(domain.getPaidAmount())
                .build();
    }
}
