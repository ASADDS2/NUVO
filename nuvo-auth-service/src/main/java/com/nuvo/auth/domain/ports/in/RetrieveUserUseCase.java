package com.nuvo.auth.domain.ports.in;

import com.nuvo.auth.domain.model.User;

public interface RetrieveUserUseCase {
    User getUserById(Integer id);
}
