package com.nuvo.loan;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.openfeign.EnableFeignClients;

@SpringBootApplication
@EnableFeignClients
public class PoolApplication {
    public static void main(String[] args) {
        SpringApplication.run(PoolApplication.class, args);
    }
}