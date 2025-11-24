package com.nuvo.loan.repository;

import com.nuvo.loan.entity.Loan;
import com.nuvo.loan.entity.LoanStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface LoanRepository extends JpaRepository<Loan, Long> {
    List<Loan> findByUserId(Integer userId);
    List<Loan> findByStatus(LoanStatus status);
}