package com.nuvo.auth.domain.ports.in;

import com.nuvo.auth.application.services.AuthenticationResponse;
import com.nuvo.auth.application.services.RegisterRequest;

public interface RegisterUseCase {
    AuthenticationResponse register(RegisterRequest request);
}
