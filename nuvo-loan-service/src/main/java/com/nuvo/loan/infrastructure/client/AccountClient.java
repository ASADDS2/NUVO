package com.nuvo.loan.infrastructure.client;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import java.math.BigDecimal;

@FeignClient(name = "account-service", url = "http://localhost:8082")
public interface AccountClient {

    @PostMapping("/api/v1/accounts/{userId}/deposit")
    void deposit(@PathVariable("userId") Integer userId, @RequestParam("amount") BigDecimal amount);
}
