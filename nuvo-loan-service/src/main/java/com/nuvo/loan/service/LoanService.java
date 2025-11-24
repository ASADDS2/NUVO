package com.nuvo.loan.service;

import com.nuvo.loan.client.AccountClient;
import com.nuvo.loan.dto.LoanRequest;
import com.nuvo.loan.entity.Loan;
import com.nuvo.loan.entity.LoanStatus;
import com.nuvo.loan.repository.LoanRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
public class LoanService {

    private final LoanRepository repository;
    private final AccountClient accountClient;

    // Tasa DIARIA del 1% para pruebas rápidas (en la vida real sería mensual)
    private static final BigDecimal DAILY_INTEREST_RATE = new BigDecimal("0.01"); 

    public Loan requestLoan(LoanRequest request) {
        Loan loan = Loan.builder()
                .userId(request.getUserId())
                .amount(request.getAmount())
                .termMonths(request.getTermMonths()) // Trataremos esto como DÍAS en la lógica
                .interestRate(DAILY_INTEREST_RATE) 
                .status(LoanStatus.PENDING)
                .paidAmount(BigDecimal.ZERO)
                .build();
        return repository.save(loan);
    }

    @Transactional
    public Loan approveLoan(Long loanId) {
        Loan loan = repository.findById(loanId).orElseThrow();
        if (loan.getStatus() != LoanStatus.PENDING) throw new RuntimeException("No pendiente");

        loan.setStatus(LoanStatus.APPROVED);
        loan.setApprovedAt(LocalDateTime.now());
        
        // Desembolsar dinero al usuario
        accountClient.deposit(loan.getUserId(), loan.getAmount());

        return repository.save(loan);
    }

    // 👇 NUEVA LÓGICA: PAGAR UNA CUOTA
    @Transactional
    public Loan payInstallment(Long loanId) {
        Loan loan = repository.findById(loanId).orElseThrow();
        
        if (loan.getStatus() != LoanStatus.APPROVED) {
            throw new RuntimeException("El préstamo no está activo o ya fue pagado");
        }

        // 1. Calcular Total a Pagar (Capital + Interés Simple)
        // Formula: Monto * (1 + (Tasa * Dias))
        BigDecimal interestFactor = loan.getInterestRate().multiply(new BigDecimal(loan.getTermMonths()));
        BigDecimal totalToPay = loan.getAmount().add(loan.getAmount().multiply(interestFactor));

        // 2. Calcular valor de UNA cuota
        // Cuota = Total / Dias
        BigDecimal installmentValue = totalToPay.divide(new BigDecimal(loan.getTermMonths()), 2, RoundingMode.HALF_UP);

        // 3. Cobrar al usuario (Llama a Account Service para restar saldo)
        // Usamos amount negativo para restar
        try {
            accountClient.deposit(loan.getUserId(), installmentValue.negate());
        } catch (Exception e) {
            throw new RuntimeException("Saldo insuficiente para pagar la cuota de: " + installmentValue);
        }

        // 4. Actualizar lo pagado
        BigDecimal newPaidAmount = loan.getPaidAmount().add(installmentValue);
        loan.setPaidAmount(newPaidAmount);

        // 5. Verificar si ya terminó de pagar (con un margen de error pequeño por redondeo)
        if (newPaidAmount.compareTo(totalToPay) >= 0) {
            loan.setStatus(LoanStatus.PAID);
        }

        return repository.save(loan);
    }

    public List<Loan> getMyLoans(Integer userId) {
        return repository.findByUserId(userId);
    }

    public List<Loan> getAllLoans() {
    return repository.findAll();
    }
}