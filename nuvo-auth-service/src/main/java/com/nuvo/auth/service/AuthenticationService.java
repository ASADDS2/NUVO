package com.nuvo.auth.service;

import com.nuvo.auth.config.JwtService;
import com.nuvo.auth.dto.AuthenticationRequest;
import com.nuvo.auth.dto.AuthenticationResponse;
import com.nuvo.auth.dto.RegisterRequest;
import com.nuvo.auth.entity.Role;
import com.nuvo.auth.entity.User;
import com.nuvo.auth.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class AuthenticationService {
    private final UserRepository repository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    private final AuthenticationManager authenticationManager;

    public AuthenticationResponse register(RegisterRequest request) {
        var user = User.builder()
                // CAMBIO AQUÍ: Usar getFirstname() en lugar de firstname()
                .firstname(request.getFirstname())
                .lastname(request.getLastname())
                .email(request.getEmail())
                .password(passwordEncoder.encode(request.getPassword()))
                .role(Role.USER)
                .build();

        repository.save(user);
        var jwtToken = jwtService.generateToken(user);
        return AuthenticationResponse.builder().token(jwtToken).build();
    }

    public AuthenticationResponse authenticate(AuthenticationRequest request) {
        authenticationManager.authenticate(
                // CAMBIO AQUÍ TAMBIÉN: Usar get...()
                new UsernamePasswordAuthenticationToken(request.getEmail(), request.getPassword()));
        var user = repository.findByEmail(request.getEmail())
                .orElseThrow();
        var jwtToken = jwtService.generateToken(user);
        return AuthenticationResponse.builder().token(jwtToken).build();
    }

    public User getUserById(Integer id) {
        return repository.findById(id).orElseThrow();
    }
}