package com.nuvo.loan.application.services;

import com.nuvo.loan.domain.model.Loan;
import com.nuvo.loan.domain.model.LoanStatus;
import com.nuvo.loan.domain.ports.in.ApproveLoanUseCase;
import com.nuvo.loan.domain.ports.in.CreateLoanUseCase;
import com.nuvo.loan.domain.ports.in.GetLoansUseCase;
import com.nuvo.loan.domain.ports.out.AccountPort;
import com.nuvo.loan.domain.ports.out.LoanRepositoryPort;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
public class LoanService implements CreateLoanUseCase, ApproveLoanUseCase, GetLoansUseCase {

    private final LoanRepositoryPort loanRepositoryPort;
    private final AccountPort accountPort;

    @Override
    @Transactional
    public Loan createLoan(LoanRequest request) {
        Loan loan = Loan.builder()
                .userId(request.getUserId())
                .amount(request.getAmount())
                .termMonths(request.getTermMonths())
                .interestRate(new BigDecimal("0.05")) // 5% interest rate default
                .status(LoanStatus.PENDING)
                .createdAt(LocalDateTime.now())
                .paidAmount(BigDecimal.ZERO)
                .build();
        return loanRepositoryPort.save(loan);
    }

    @Override
    @Transactional
    public Loan approveLoan(Long loanId) {
        Loan loan = loanRepositoryPort.findById(loanId)
                .orElseThrow(() -> new RuntimeException("Loan not found"));

        if (loan.getStatus() != LoanStatus.PENDING) {
            throw new RuntimeException("Loan is not pending");
        }

        loan.setStatus(LoanStatus.APPROVED);
        loan.setApprovedAt(LocalDateTime.now());

        // Deposit money to user account
        accountPort.deposit(loan.getUserId(), loan.getAmount());

        return loanRepositoryPort.save(loan);
    }

    @Override
    public List<Loan> getAllLoans() {
        return loanRepositoryPort.findAll();
    }

    @Override
    public List<Loan> getLoansByUserId(Integer userId) {
        return loanRepositoryPort.findByUserId(userId);
    }

    @Override
    public Loan getLoanById(Long loanId) {
        return loanRepositoryPort.findById(loanId)
                .orElseThrow(() -> new RuntimeException("Loan not found"));
    }
}
