package com.nuvo.auth.infrastructure.adapters;

import com.nuvo.auth.domain.model.User;
import com.nuvo.auth.domain.ports.out.JwtPort;
import com.nuvo.auth.infrastructure.config.JwtService;
import com.nuvo.auth.infrastructure.entities.UserEntity;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class JwtAdapter implements JwtPort {

    private final JwtService jwtService;

    @Override
    public String generateToken(User user) {
        // Convert Domain User to UserDetails (UserEntity)
        UserEntity userDetails = UserEntity.builder()
                .email(user.getEmail())
                .password(user.getPassword())
                .role(user.getRole())
                .build();
        return jwtService.generateToken(userDetails);
    }
}
