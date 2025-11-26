package com.nuvo.loan.infrastructure.repositories;

import com.nuvo.loan.infrastructure.entities.LoanEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface JpaLoanRepository extends JpaRepository<LoanEntity, Long> {
    List<LoanEntity> findByUserId(Integer userId);
}
