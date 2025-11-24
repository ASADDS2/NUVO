package com.nuvo.transaction.controller;

import com.nuvo.transaction.dto.TransferRequest;
import com.nuvo.transaction.entity.Transaction;
import com.nuvo.transaction.service.TransactionService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.math.BigDecimal;
import java.util.List;

@RestController
@RequestMapping("/api/v1/transactions")
@RequiredArgsConstructor
public class TransactionController {

    private final TransactionService service;

    @PostMapping("/transfer")
    public ResponseEntity<Transaction> transfer(@RequestBody TransferRequest request) {
        return ResponseEntity.ok(service.transfer(request));
    }

    // 👇 NUEVO ENDPOINT
    @PostMapping("/deposit")
    public ResponseEntity<Transaction> deposit(@RequestParam Integer userId, @RequestParam BigDecimal amount) {
        return ResponseEntity.ok(service.deposit(userId, amount));
    }

    @GetMapping("/history/{userId}")
    public ResponseEntity<List<Transaction>> getHistory(@PathVariable Integer userId) {
        return ResponseEntity.ok(service.getHistory(userId));
    }
}