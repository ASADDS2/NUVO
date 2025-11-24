package com.nuvo.loan.repository;

import com.nuvo.loan.entity.Investment;
import com.nuvo.loan.entity.InvestmentStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface InvestmentRepository extends JpaRepository<Investment, Long> {
    List<Investment> findByUserIdAndStatus(Integer userId, InvestmentStatus status);
}