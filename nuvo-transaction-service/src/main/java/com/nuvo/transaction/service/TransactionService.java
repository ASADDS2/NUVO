package com.nuvo.transaction.service;

import com.nuvo.transaction.client.AccountClient;
import com.nuvo.transaction.dto.TransferRequest;
import com.nuvo.transaction.entity.Transaction;
import com.nuvo.transaction.repository.TransactionRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.math.BigDecimal;
import java.util.List;

@Service
@RequiredArgsConstructor
public class TransactionService {

    private final TransactionRepository repository;
    private final AccountClient accountClient;

    // LOGICA DE TRANSFERENCIA (Ya la tenías)
    @Transactional
    public Transaction transfer(TransferRequest request) {
        if (request.getAmount().compareTo(BigDecimal.ZERO) <= 0) throw new RuntimeException("Monto inválido");

        // Retirar de Origen
        accountClient.updateBalance(request.getSourceUserId(), request.getAmount().negate());
        // Depositar a Destino
        accountClient.updateBalance(request.getTargetUserId(), request.getAmount());

        return repository.save(Transaction.builder()
                .sourceUserId(request.getSourceUserId())
                .targetUserId(request.getTargetUserId())
                .amount(request.getAmount())
                .type("TRANSFER")
                .build());
    }

    // 👇 NUEVO: LOGICA DE DEPÓSITO (Recarga de saldo)
    @Transactional
    public Transaction deposit(Integer userId, BigDecimal amount) {
        if (amount.compareTo(BigDecimal.ZERO) <= 0) throw new RuntimeException("Monto inválido");

        // 1. Llamar a Account para sumar dinero real
        accountClient.updateBalance(userId, amount);

        // 2. Guardar el registro histórico
        return repository.save(Transaction.builder()
                .targetUserId(userId) // Solo hay destino, no origen
                .amount(amount)
                .type("DEPOSIT")
                .build());
    }

    public List<Transaction> getHistory(Integer userId) {
        return repository.findBySourceUserIdOrTargetUserIdOrderByTimestampDesc(userId, userId);
    }
}