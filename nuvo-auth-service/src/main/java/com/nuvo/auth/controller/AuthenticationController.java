package com.nuvo.auth.controller;

import com.nuvo.auth.dto.AuthenticationRequest;
import com.nuvo.auth.dto.AuthenticationResponse;
import com.nuvo.auth.dto.RegisterRequest;
import com.nuvo.auth.service.AuthenticationService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
// 👇 ESTA LÍNEA ES LA QUE FALTABA 👇
import org.springframework.web.bind.annotation.CrossOrigin; 
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/auth")
@RequiredArgsConstructor
@CrossOrigin(origins = "*") // Ahora sí funcionará porque tiene el import arriba
public class AuthenticationController {

    private final AuthenticationService service;

    @PostMapping("/register")
    public ResponseEntity<AuthenticationResponse> register(@RequestBody RegisterRequest request) {
        return ResponseEntity.ok(service.register(request));
    }

    @PostMapping("/authenticate")
    public ResponseEntity<AuthenticationResponse> authenticate(@RequestBody AuthenticationRequest request) {
        return ResponseEntity.ok(service.authenticate(request));
    }
}