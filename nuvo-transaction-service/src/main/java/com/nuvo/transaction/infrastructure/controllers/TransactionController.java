package com.nuvo.transaction.infrastructure.controllers;

import com.nuvo.transaction.application.services.TransferRequest;
import com.nuvo.transaction.domain.model.Transaction;
import com.nuvo.transaction.domain.ports.in.DepositUseCase;
import com.nuvo.transaction.domain.ports.in.GetHistoryUseCase;
import com.nuvo.transaction.domain.ports.in.TransferUseCase;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.List;

@RestController
@RequestMapping("/api/v1/transactions")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class TransactionController {

    private final GetHistoryUseCase getHistoryUseCase;
    private final DepositUseCase depositUseCase;
    private final TransferUseCase transferUseCase;

    @GetMapping("/history/{userId}")
    public ResponseEntity<List<Transaction>> getHistory(@PathVariable Integer userId) {
        return ResponseEntity.ok(getHistoryUseCase.getHistory(userId));
    }

    @GetMapping("/user/{userId}")
    public ResponseEntity<List<Transaction>> getHistoryByUser(@PathVariable Integer userId) {
        return ResponseEntity.ok(getHistoryUseCase.getHistory(userId));
    }

    @PostMapping("/deposit")
    public ResponseEntity<Void> deposit(@RequestParam Integer userId, @RequestParam BigDecimal amount) {
        depositUseCase.deposit(userId, amount);
        return ResponseEntity.ok().build();
    }

    @PostMapping("/transfer")
    public ResponseEntity<Void> transfer(@RequestBody TransferRequest request) {
        transferUseCase.transfer(request);
        return ResponseEntity.ok().build();
    }
}
