package com.nuvo.auth.domain.ports.out;

import com.nuvo.auth.domain.model.User;

public interface JwtPort {
    String generateToken(User user);
}
