package com.group2.blooddonation.dto;

import com.group2.blooddonation.model.BloodGroup;
import com.group2.blooddonation.model.Gender;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import java.util.Locale;

/**
 * Registration form for a new user.
 */
public class RegisterForm {

    @NotBlank(message = "Username is required")
    @Size(min = 3, max = 50, message = "Username must be between 3 and 50 characters")
    private String username;

    @NotBlank(message = "Password is required")
    @Size(min = 6, max = 50, message = "Password must be at least 6 characters")
    private String password;

    @NotBlank(message = "Full name is required")
    @Size(max = 100, message = "Name can be at most 100 characters")
    private String fullName;

    @NotBlank(message = "Email is required")
    @Email(message = "Enter a valid email address")
    @Size(max = 120, message = "Email can be at most 120 characters")
    private String email;

    @NotBlank(message = "Mobile number is required")
    @Pattern(regexp = "[6-9]\\d{9}", message = "Enter a valid 10-digit mobile number")
    private String phone;

    @NotNull(message = "Select a blood group")
    private BloodGroup bloodGroup;

    @NotNull(message = "Select a gender")
    private Gender gender;

    @NotNull(message = "Enter age")
    @Min(value = 18, message = "Must be at least 18 years old")
    @Max(value = 65, message = "Must be 65 years old or younger")
    private Integer age;

    @NotBlank(message = "City is required")
    @Size(max = 60, message = "City can be at most 60 characters")
    private String city;

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username == null ? null : username.trim();
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName == null ? null : fullName.trim();
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email == null ? null : email.trim().toLowerCase(Locale.ROOT);
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        if (phone != null) {
            String clean = phone.replaceAll("[\\s-]", "");
            if (clean.startsWith("+91")) {
                clean = clean.substring(3);
            }
            this.phone = clean;
        } else {
            this.phone = null;
        }
    }

    public BloodGroup getBloodGroup() {
        return bloodGroup;
    }

    public void setBloodGroup(BloodGroup bloodGroup) {
        this.bloodGroup = bloodGroup;
    }

    public Gender getGender() {
        return gender;
    }

    public void setGender(Gender gender) {
        this.gender = gender;
    }

    public Integer getAge() {
        return age;
    }

    public void setAge(Integer age) {
        this.age = age;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city == null ? null : city.trim();
    }
}
