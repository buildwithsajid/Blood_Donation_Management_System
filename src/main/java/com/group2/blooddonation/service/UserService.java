package com.group2.blooddonation.service;

import com.group2.blooddonation.dto.RegisterForm;
import com.group2.blooddonation.model.User;
import com.group2.blooddonation.model.UserRole;
import com.group2.blooddonation.repository.UserRepository;
import java.util.Locale;
import java.util.Optional;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * Business logic for user management and authentication.
 */
@Service
@Transactional(readOnly = true)
public class UserService {

    private final UserRepository userRepository;

    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    public Optional<User> authenticate(String usernameOrEmail, String password, UserRole expectedRole) {
        if (usernameOrEmail == null || password == null) {
            return Optional.empty();
        }
        String identifier = usernameOrEmail.trim();
        String lowerIdentifier = identifier.toLowerCase(Locale.ROOT);

        Optional<User> userOpt = userRepository.findByUsername(identifier);
        if (userOpt.isEmpty()) {
            userOpt = userRepository.findByEmail(lowerIdentifier);
        }

        if (userOpt.isPresent()) {
            User user = userOpt.get();
            // Verify password match
            if (password.equals(user.getPassword())) {
                if (expectedRole == null || user.getRole() == expectedRole) {
                    return Optional.of(user);
                }
            }
        }
        return Optional.empty();
    }

    public boolean isUsernameTaken(String username) {
        return userRepository.existsByUsername(username);
    }

    public boolean isEmailTaken(String email) {
        return userRepository.existsByEmail(email == null ? null : email.toLowerCase(Locale.ROOT));
    }

    public User getById(Long id) {
        return userRepository.findById(id).orElse(null);
    }

    @Transactional
    public User register(RegisterForm form) {
        User user = new User();
        user.setUsername(form.getUsername());
        user.setPassword(form.getPassword());
        user.setFullName(form.getFullName());
        user.setEmail(form.getEmail().toLowerCase(Locale.ROOT));
        user.setPhone(form.getPhone());
        user.setRole(UserRole.USER);
        user.setBloodGroup(form.getBloodGroup());
        user.setGender(form.getGender());
        user.setAge(form.getAge());
        user.setCity(form.getCity());
        return userRepository.save(user);
    }
}
