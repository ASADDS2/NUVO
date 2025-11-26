package com.nuvo.auth.application.usecases;

import com.nuvo.auth.application.services.AuthenticationResponse;
import com.nuvo.auth.application.services.RegisterRequest;
import com.nuvo.auth.domain.model.Role;
import com.nuvo.auth.domain.model.User;
import com.nuvo.auth.domain.ports.in.RegisterUseCase;
import com.nuvo.auth.domain.ports.out.JwtPort;
import com.nuvo.auth.domain.ports.out.PasswordEncoderPort;
import com.nuvo.auth.domain.ports.out.UserRepositoryPort;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class RegisterUseCaseImpl implements RegisterUseCase {

    private final UserRepositoryPort repository;
    private final PasswordEncoderPort passwordEncoder;
    private final JwtPort jwtPort;

    @Override
    public AuthenticationResponse register(RegisterRequest request) {
        var user = User.builder()
                .firstname(request.getFirstname())
                .lastname(request.getLastname())
                .email(request.getEmail())
                .password(passwordEncoder.encode(request.getPassword()))
                .role(Role.USER)
                .build();

        User savedUser = repository.save(user);
        var jwtToken = jwtPort.generateToken(savedUser);
        return AuthenticationResponse.builder().token(jwtToken).build();
    }
}
