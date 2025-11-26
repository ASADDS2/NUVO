package com.nuvo.loan.infrastructure.adapters;

import com.nuvo.loan.domain.model.Loan;
import com.nuvo.loan.domain.ports.out.LoanRepositoryPort;
import com.nuvo.loan.infrastructure.entities.LoanEntity;
import com.nuvo.loan.infrastructure.mappers.LoanMapper;
import com.nuvo.loan.infrastructure.repositories.JpaLoanRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Component
@RequiredArgsConstructor
public class LoanRepositoryAdapter implements LoanRepositoryPort {

    private final JpaLoanRepository jpaLoanRepository;
    private final LoanMapper loanMapper;

    @Override
    public Loan save(Loan loan) {
        LoanEntity entity = loanMapper.toEntity(loan);
        LoanEntity savedEntity = jpaLoanRepository.save(entity);
        return loanMapper.toDomain(savedEntity);
    }

    @Override
    public Optional<Loan> findById(Long id) {
        return jpaLoanRepository.findById(id).map(loanMapper::toDomain);
    }

    @Override
    public List<Loan> findByUserId(Integer userId) {
        return jpaLoanRepository.findByUserId(userId).stream()
                .map(loanMapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<Loan> findAll() {
        return jpaLoanRepository.findAll().stream()
                .map(loanMapper::toDomain)
                .collect(Collectors.toList());
    }
}
