package com.group2.blooddonation.dto;

import com.group2.blooddonation.model.BloodGroup;
import com.group2.blooddonation.model.Gender;
import com.group2.blooddonation.model.User;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import java.time.LocalDate;
import java.util.Locale;
import org.springframework.format.annotation.DateTimeFormat;

/**
 * Form for submitting a blood donation request.
 */
public class DonationRequestForm {

    @NotBlank(message = "Full name is required")
    @Size(max = 100, message = "Name can be at most 100 characters")
    private String fullName;

    @NotBlank(message = "Mobile number is required")
    @Pattern(regexp = "[6-9]\\d{9}", message = "Enter a valid 10-digit mobile number")
    private String phone;

    @Email(message = "Enter a valid email address")
    @Size(max = 120, message = "Email can be at most 120 characters")
    private String email;

    @NotNull(message = "Select a blood group")
    private BloodGroup bloodGroup;

    @NotNull(message = "Select a gender")
    private Gender gender;

    @NotNull(message = "Enter age")
    @Min(value = 18, message = "Donors must be at least 18 years old")
    @Max(value = 65, message = "Donors must be 65 years old or younger")
    private Integer age;

    @NotBlank(message = "City is required")
    @Size(max = 60, message = "City can be at most 60 characters")
    private String city;

    @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)
    private LocalDate preferredDate;

    @Size(max = 500, message = "Notes cannot exceed 500 characters")
    private String medicalDetails;

    public static DonationRequestForm prefill(User user) {
        DonationRequestForm form = new DonationRequestForm();
        if (user != null) {
            form.setFullName(user.getFullName());
            form.setPhone(user.getPhone());
            form.setEmail(user.getEmail());
            form.setBloodGroup(user.getBloodGroup());
            form.setGender(user.getGender());
            form.setAge(user.getAge());
            form.setCity(user.getCity());
        }
        form.setPreferredDate(LocalDate.now().plusDays(1));
        return form;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName == null ? null : fullName.trim();
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

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email == null ? null : email.trim().toLowerCase(Locale.ROOT);
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

    public LocalDate getPreferredDate() {
        return preferredDate;
    }

    public void setPreferredDate(LocalDate preferredDate) {
        this.preferredDate = preferredDate;
    }

    public String getMedicalDetails() {
        return medicalDetails;
    }

    public void setMedicalDetails(String medicalDetails) {
        this.medicalDetails = medicalDetails == null ? null : medicalDetails.trim();
    }
}
