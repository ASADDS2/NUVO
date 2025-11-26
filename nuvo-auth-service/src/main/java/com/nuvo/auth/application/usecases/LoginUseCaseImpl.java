package com.nuvo.auth.application.usecases;

import com.nuvo.auth.application.services.AuthenticationRequest;
import com.nuvo.auth.application.services.AuthenticationResponse;
import com.nuvo.auth.domain.ports.in.LoginUseCase;
import com.nuvo.auth.domain.ports.out.AuthenticationPort;
import com.nuvo.auth.domain.ports.out.JwtPort;
import com.nuvo.auth.domain.ports.out.UserRepositoryPort;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class LoginUseCaseImpl implements LoginUseCase {

    private final AuthenticationPort authenticationPort;
    private final UserRepositoryPort repository;
    private final JwtPort jwtPort;

    @Override
    public AuthenticationResponse authenticate(AuthenticationRequest request) {
        authenticationPort.authenticate(request.getEmail(), request.getPassword());
        var user = repository.findByEmail(request.getEmail())
                .orElseThrow();
        var jwtToken = jwtPort.generateToken(user);
        return AuthenticationResponse.builder()
                .token(jwtToken)
                .id(user.getId())
                .role(user.getRole().name())
                .build();
    }
}
