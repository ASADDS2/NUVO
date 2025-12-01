package com.nuvo.transaction.application.services;

import com.nuvo.transaction.domain.model.Transaction;
import com.nuvo.transaction.domain.ports.in.DepositUseCase;
import com.nuvo.transaction.domain.ports.in.GetHistoryUseCase;
import com.nuvo.transaction.domain.ports.in.TransferUseCase;
import com.nuvo.transaction.domain.ports.out.AccountPort;
import com.nuvo.transaction.domain.ports.out.TransactionRepositoryPort;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
public class TransactionService implements GetHistoryUseCase, DepositUseCase, TransferUseCase {

    private final TransactionRepositoryPort transactionRepository;
    private final AccountPort accountPort;

    @Override
    public List<Transaction> getHistory(Integer userId) {
        return transactionRepository.findBySourceUserIdOrTargetUserId(userId);
    }

    @Override
    @Transactional
    public void deposit(Integer userId, BigDecimal amount) {
        accountPort.deposit(userId, amount);

        Transaction transaction = Transaction.builder()
                .sourceUserId(userId)
                .targetUserId(userId)
                .amount(amount)
                .type("DEPOSIT")
                .timestamp(LocalDateTime.now())
                .build();

        transactionRepository.save(transaction);
    }

    @Override
    @Transactional
    public void transfer(TransferRequest request) {
        // Debit source
        accountPort.deposit(request.getSourceUserId(), request.getAmount().negate());
        // Credit target
        accountPort.deposit(request.getTargetUserId(), request.getAmount());

        Transaction transaction = Transaction.builder()
                .sourceUserId(request.getSourceUserId())
                .targetUserId(request.getTargetUserId())
                .amount(request.getAmount())
                .type("TRANSFER")
                .timestamp(LocalDateTime.now())
                .build();

        transactionRepository.save(transaction);
    }
}
