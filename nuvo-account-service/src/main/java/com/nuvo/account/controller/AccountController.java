package com.nuvo.account.controller;

import com.nuvo.account.dto.CreateAccountRequest;
import com.nuvo.account.entity.Account;
import com.nuvo.account.service.AccountService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.math.BigDecimal;
import java.util.List;

@RestController
@RequestMapping("/api/v1/accounts")
@RequiredArgsConstructor
@CrossOrigin(origins = "*") // Habilitamos CORS para Angular
public class AccountController {

    private final AccountService service; // ✅ Solo inyectamos el Servicio

    @PostMapping
    public ResponseEntity<Account> createAccount(@RequestBody CreateAccountRequest request) {
        return ResponseEntity.ok(service.createAccount(request));
    }

    @GetMapping("/{userId}")
    public ResponseEntity<Account> getAccount(@PathVariable Integer userId) {
        return ResponseEntity.ok(service.getAccountByUserId(userId));
    }

    // 👇 AHORA SÍ: Usamos el servicio correctamente
    @GetMapping
    public ResponseEntity<List<Account>> getAll() {
        return ResponseEntity.ok(service.getAllAccounts());
    }

    @PostMapping("/{userId}/deposit")
    public ResponseEntity<Account> deposit(@PathVariable Integer userId, @RequestParam BigDecimal amount) {
        return ResponseEntity.ok(service.deposit(userId, amount));
    }
}