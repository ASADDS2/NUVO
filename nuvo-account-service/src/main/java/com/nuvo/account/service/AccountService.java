package com.nuvo.account.service;

import com.nuvo.account.dto.CreateAccountRequest;
import com.nuvo.account.entity.Account;
import com.nuvo.account.repository.AccountRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.math.BigDecimal;
import java.util.Random;

@Service
@RequiredArgsConstructor
public class AccountService {

    private final AccountRepository repository;

    public Account createAccount(CreateAccountRequest request) {
        // Verificar si ya tiene cuenta
        if (repository.findByUserId(request.getUserId()).isPresent()) {
            throw new RuntimeException("El usuario ya tiene una cuenta");
        }

        Account account = Account.builder()
                .userId(request.getUserId())
                .accountNumber(generateAccountNumber())
                .balance(BigDecimal.ZERO) // Saldo inicial 0
                .build();
        
        return repository.save(account);
    }

    public Account getAccountByUserId(Integer userId) {
        return repository.findByUserId(userId)
                .orElseThrow(() -> new RuntimeException("Cuenta no encontrada"));
    }

    // Método trampa para meter dinero (Solo para pruebas)
    public Account deposit(Integer userId, BigDecimal amount) {
        Account account = getAccountByUserId(userId);
        account.setBalance(account.getBalance().add(amount));
        return repository.save(account);
    }

    private String generateAccountNumber() {
        // Genera numero aleatorio de 10 digitos
        return String.valueOf(1000000000L + new Random().nextLong(9000000000L));
    }

    // NUEVO MÉTODO: Obtener todas las cuentas (Pasando por el Servicio)
    public java.util.List<Account> getAllAccounts() {
        // Aquí podrías agregar lógica extra en el futuro (ej: filtrar por rol)
        return repository.findAll();
    }
}