package com.nuvo.auth.domain.ports.in;

import com.nuvo.auth.application.services.AuthenticationRequest;
import com.nuvo.auth.application.services.AuthenticationResponse;

public interface LoginUseCase {
    AuthenticationResponse authenticate(AuthenticationRequest request);
}
