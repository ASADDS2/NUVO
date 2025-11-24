package com.nuvo.loan.controller;

import com.nuvo.loan.dto.InvestRequest;
import com.nuvo.loan.dto.PoolStats;
import com.nuvo.loan.entity.Investment;
import com.nuvo.loan.service.PoolService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/v1/pool")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class PoolController {

    private final PoolService service;

    @PostMapping("/invest")
    public ResponseEntity<Investment> invest(@RequestBody InvestRequest request) {
        return ResponseEntity.ok(service.invest(request));
    }

    @PostMapping("/withdraw/{investmentId}")
    public ResponseEntity<Void> withdraw(@PathVariable Long investmentId) {
        service.withdraw(investmentId);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/my-investments/{userId}")
    public ResponseEntity<List<Investment>> getMyInvestments(@PathVariable Integer userId) {
        return ResponseEntity.ok(service.getMyInvestments(userId));
    }

    @GetMapping("/stats/{userId}")
    public ResponseEntity<PoolStats> getStats(@PathVariable Integer userId) {
        return ResponseEntity.ok(service.getStats(userId));
    }

    @GetMapping
    public ResponseEntity<List<Investment>> getAll() {
        return ResponseEntity.ok(service.getAllInvestments());
    }
}