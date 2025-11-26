package com.nuvo.loan.infrastructure.controllers;

import com.nuvo.loan.application.services.LoanRequest;
import com.nuvo.loan.domain.model.Loan;
import com.nuvo.loan.domain.ports.in.ApproveLoanUseCase;
import com.nuvo.loan.domain.ports.in.CreateLoanUseCase;
import com.nuvo.loan.domain.ports.in.GetLoansUseCase;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/loans")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class LoanController {

    private final CreateLoanUseCase createLoanUseCase;
    private final ApproveLoanUseCase approveLoanUseCase;
    private final GetLoansUseCase getLoansUseCase;

    @PostMapping
    public ResponseEntity<Loan> createLoan(@RequestBody LoanRequest request) {
        return ResponseEntity.ok(createLoanUseCase.createLoan(request));
    }

    @PutMapping("/{loanId}/approve")
    public ResponseEntity<Loan> approveLoan(@PathVariable Long loanId) {
        return ResponseEntity.ok(approveLoanUseCase.approveLoan(loanId));
    }

    @GetMapping
    public ResponseEntity<List<Loan>> getAllLoans() {
        return ResponseEntity.ok(getLoansUseCase.getAllLoans());
    }

    @GetMapping("/my-loans/{userId}")
    public ResponseEntity<List<Loan>> getMyLoans(@PathVariable Integer userId) {
        return ResponseEntity.ok(getLoansUseCase.getLoansByUserId(userId));
    }

    @GetMapping("/{loanId}")
    public ResponseEntity<Loan> getLoanById(@PathVariable Long loanId) {
        return ResponseEntity.ok(getLoansUseCase.getLoanById(loanId));
    }
}
