package com.nuvo.auth.domain.ports.out;

public interface PasswordEncoderPort {
    String encode(String password);
}
