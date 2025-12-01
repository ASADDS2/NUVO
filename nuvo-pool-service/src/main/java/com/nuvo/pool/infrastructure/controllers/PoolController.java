package com.nuvo.pool.infrastructure.controllers;

import com.nuvo.pool.application.services.InvestRequest;
import com.nuvo.pool.application.services.PoolStats;
import com.nuvo.pool.domain.model.Investment;
import com.nuvo.pool.domain.ports.in.GetInvestmentsUseCase;
import com.nuvo.pool.domain.ports.in.InvestUseCase;
import com.nuvo.pool.domain.ports.in.WithdrawUseCase;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/v1/pool")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class PoolController {

    private final InvestUseCase investUseCase;
    private final WithdrawUseCase withdrawUseCase;
    private final GetInvestmentsUseCase getInvestmentsUseCase;

    @PostMapping("/invest")
    public ResponseEntity<Investment> invest(@RequestBody InvestRequest request) {
        return ResponseEntity.ok(investUseCase.invest(request));
    }

    @PostMapping("/withdraw/{investmentId}")
    public ResponseEntity<Void> withdraw(@PathVariable Long investmentId) {
        withdrawUseCase.withdraw(investmentId);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/my-investments/{userId}")
    public ResponseEntity<List<Investment>> getMyInvestments(@PathVariable Integer userId) {
        return ResponseEntity.ok(getInvestmentsUseCase.getMyInvestments(userId));
    }

    @GetMapping("/stats/{userId}")
    public ResponseEntity<PoolStats> getStats(@PathVariable Integer userId) {
        return ResponseEntity.ok(getInvestmentsUseCase.getStats(userId));
    }

    @GetMapping
    public ResponseEntity<List<Investment>> getAll() {
        return ResponseEntity.ok(getInvestmentsUseCase.getAllInvestments());
    }
}
