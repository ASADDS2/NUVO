package com.nuvo.auth.infrastructure.controllers;

import com.nuvo.auth.application.services.AuthenticationRequest;
import com.nuvo.auth.application.services.AuthenticationResponse;
import com.nuvo.auth.application.services.RegisterRequest;
import com.nuvo.auth.domain.model.User;
import com.nuvo.auth.domain.ports.in.LoginUseCase;
import com.nuvo.auth.domain.ports.in.RegisterUseCase;
import com.nuvo.auth.domain.ports.in.RetrieveUserUseCase;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/auth")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class AuthenticationController {

    private final RegisterUseCase registerUseCase;
    private final LoginUseCase loginUseCase;
    private final RetrieveUserUseCase retrieveUserUseCase;

    @PostMapping("/register")
    public ResponseEntity<AuthenticationResponse> register(@RequestBody RegisterRequest request) {
        return ResponseEntity.ok(registerUseCase.register(request));
    }

    @PostMapping("/authenticate")
    public ResponseEntity<AuthenticationResponse> authenticate(@RequestBody AuthenticationRequest request) {
        return ResponseEntity.ok(loginUseCase.authenticate(request));
    }

    @GetMapping("/{id}")
    public ResponseEntity<User> getUserById(@PathVariable Integer id) {
        return ResponseEntity.ok(retrieveUserUseCase.getUserById(id));
    }
}
