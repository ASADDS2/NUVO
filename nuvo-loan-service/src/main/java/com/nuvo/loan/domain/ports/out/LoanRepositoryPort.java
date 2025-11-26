package com.nuvo.loan.domain.ports.out;

import com.nuvo.loan.domain.model.Loan;
import java.util.List;
import java.util.Optional;

public interface LoanRepositoryPort {
    Loan save(Loan loan);

    Optional<Loan> findById(Long id);

    List<Loan> findByUserId(Integer userId);

    List<Loan> findAll();
}
