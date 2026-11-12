package com.group2.blooddonation.dto;

import jakarta.validation.constraints.NotBlank;

/**
 * Credentials submitted on the User or Admin login form.
 */
public class LoginForm {

    @NotBlank(message = "Please enter your username or email")
    private String usernameOrEmail;

    @NotBlank(message = "Please enter your password")
    private String password;

    public String getUsernameOrEmail() {
        return usernameOrEmail;
    }

    public void setUsernameOrEmail(String usernameOrEmail) {
        this.usernameOrEmail = usernameOrEmail == null ? null : usernameOrEmail.trim();
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }
}
