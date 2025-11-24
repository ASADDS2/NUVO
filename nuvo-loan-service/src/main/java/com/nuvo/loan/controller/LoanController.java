package com.nuvo.loan.controller;

import com.nuvo.loan.dto.LoanRequest;
import com.nuvo.loan.entity.Loan;
import com.nuvo.loan.service.LoanService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
// 👇 IMPORTANTE: Asegúrate de que estos imports estén aquí
import org.springframework.web.bind.annotation.CrossOrigin; 
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/v1/loans")
@RequiredArgsConstructor
@CrossOrigin(origins = "*") // <--- ¡ESTO ES VITAL!
public class LoanController {

    private final LoanService service;

    @PostMapping("/request")
    public ResponseEntity<Loan> requestLoan(@RequestBody LoanRequest request) {
        return ResponseEntity.ok(service.requestLoan(request));
    }

    @PutMapping("/{loanId}/approve")
    public ResponseEntity<Loan> approveLoan(@PathVariable Long loanId) {
        return ResponseEntity.ok(service.approveLoan(loanId));
    }

    @PostMapping("/{loanId}/pay")
    public ResponseEntity<Loan> payInstallment(@PathVariable Long loanId) {
        return ResponseEntity.ok(service.payInstallment(loanId));
    }

    @GetMapping("/my-loans/{userId}")
    public ResponseEntity<List<Loan>> getMyLoans(@PathVariable Integer userId) {
        return ResponseEntity.ok(service.getMyLoans(userId));
    }

    // EL MÉTODO QUE USA EL ADMIN
    @GetMapping
    public ResponseEntity<List<Loan>> getAll() {
        return ResponseEntity.ok(service.getAllLoans());
    }
}