package com.nuvo.transaction.client;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import java.math.BigDecimal;

// Le decimos: "Conéctate al servicio que corre en localhost:8082"
@FeignClient(name = "account-service", url = "http://localhost:8082")
public interface AccountClient {

    // Llamamos al endpoint de deposito que ya creamos.
    // Si mandamos monto negativo, sirve como retiro.
    @PostMapping("/api/v1/accounts/{userId}/deposit")
    void updateBalance(@PathVariable("userId") Integer userId, @RequestParam("amount") BigDecimal amount);
}