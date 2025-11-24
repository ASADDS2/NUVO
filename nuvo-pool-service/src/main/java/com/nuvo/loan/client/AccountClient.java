package com.nuvo.loan.client;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import java.math.BigDecimal;

@FeignClient(name = "account-service", url = "http://localhost:8082")
public interface AccountClient {

    // updateBalance recibe valores negativos para RESTAR y positivos para SUMAR
    @PostMapping("/api/v1/accounts/{userId}/deposit")
    void updateBalance(@PathVariable("userId") Integer userId, @RequestParam("amount") BigDecimal amount);
}