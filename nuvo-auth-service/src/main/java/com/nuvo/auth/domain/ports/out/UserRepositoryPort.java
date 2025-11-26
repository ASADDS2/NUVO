package com.nuvo.auth.domain.ports.out;

import com.nuvo.auth.domain.model.User;
import java.util.Optional;

public interface UserRepositoryPort {
    User save(User user);

    Optional<User> findByEmail(String email);

    Optional<User> findById(Integer id);
}
