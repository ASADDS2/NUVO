package com.nuvo.auth.application.usecases;

import com.nuvo.auth.domain.model.User;
import com.nuvo.auth.domain.ports.in.RetrieveUserUseCase;
import com.nuvo.auth.domain.ports.out.UserRepositoryPort;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class RetrieveUserUseCaseImpl implements RetrieveUserUseCase {

    private final UserRepositoryPort repository;

    @Override
    public User getUserById(Integer id) {
        return repository.findById(id).orElseThrow();
    }
}
