package com.nuvo.auth.domain.ports.out;

public interface AuthenticationPort {
    void authenticate(String email, String password);
}
