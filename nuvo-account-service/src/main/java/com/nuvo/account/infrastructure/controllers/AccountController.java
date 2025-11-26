package com.nuvo.account.infrastructure.controllers;

import com.nuvo.account.application.services.CreateAccountRequest;
import com.nuvo.account.domain.model.Account;
import com.nuvo.account.domain.ports.in.CreateAccountUseCase;
import com.nuvo.account.domain.ports.out.AccountRepositoryPort;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.math.BigDecimal;
import java.util.List;

@RestController
@RequestMapping("/api/v1/accounts")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class AccountController {

    private final CreateAccountUseCase createAccountUseCase;
    private final AccountRepositoryPort accountRepository;

    @PostMapping
    public ResponseEntity<Account> createAccount(@RequestBody CreateAccountRequest request) {
        return ResponseEntity.ok(createAccountUseCase.createAccount(request));
    }

    @GetMapping("/{userId}")
    public ResponseEntity<Account> getAccount(@PathVariable Integer userId) {
        return ResponseEntity.ok(accountRepository.findByUserId(userId)
                .orElseThrow(() -> new RuntimeException("Cuenta no encontrada")));
    }

    @GetMapping
    public ResponseEntity<List<Account>> getAll() {
        return ResponseEntity.ok(accountRepository.findAll());
    }

    @PostMapping("/{userId}/deposit")
    public ResponseEntity<Account> deposit(@PathVariable Integer userId, @RequestParam BigDecimal amount) {
        Account account = accountRepository.findByUserId(userId)
                .orElseThrow(() -> new RuntimeException("Cuenta no encontrada"));
        account.setBalance(account.getBalance().add(amount));
        return ResponseEntity.ok(accountRepository.save(account));
    }
}
