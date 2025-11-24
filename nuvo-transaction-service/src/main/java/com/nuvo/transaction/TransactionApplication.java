package com.nuvo.transaction;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.openfeign.EnableFeignClients;

@SpringBootApplication
@EnableFeignClients // <--- ¡IMPORTANTE! Permite la comunicación entre servicios
public class TransactionApplication {
    public static void main(String[] args) {
        SpringApplication.run(TransactionApplication.class, args);
    }
}