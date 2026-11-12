package com.group2.blooddonation.dto;

import com.group2.blooddonation.model.BloodGroup;
import com.group2.blooddonation.model.UrgencyLevel;
import com.group2.blooddonation.model.User;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import java.time.LocalDate;
import org.springframework.format.annotation.DateTimeFormat;

/**
 * Form for submitting a blood requirement request.
 */
public class BloodRequestForm {

    @NotBlank(message = "Patient name is required")
    @Size(max = 100, message = "Patient name can be at most 100 characters")
    private String patientName;

    @NotNull(message = "Select required blood group")
    private BloodGroup bloodGroup;

    @NotNull(message = "Enter units needed")
    @Min(value = 1, message = "At least 1 unit is needed")
    @Max(value = 20, message = "Maximum 20 units can be requested at once")
    private Integer unitsNeeded = 1;

    @NotBlank(message = "Hospital name is required")
    @Size(max = 150, message = "Hospital name can be at most 150 characters")
    private String hospitalName;

    @Size(max = 255, message = "Hospital address can be at most 255 characters")
    private String hospitalAddress;

    @NotBlank(message = "City is required")
    @Size(max = 60, message = "City can be at most 60 characters")
    private String city;

    @NotBlank(message = "Contact person name is required")
    @Size(max = 100, message = "Contact person name can be at most 100 characters")
    private String contactName;

    @NotBlank(message = "Contact mobile number is required")
    @Pattern(regexp = "[6-9]\\d{9}", message = "Enter a valid 10-digit mobile number")
    private String contactPhone;

    @NotNull(message = "Required date is required")
    @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)
    private LocalDate requiredDate;

    @NotNull(message = "Select urgency level")
    private UrgencyLevel urgency = UrgencyLevel.NORMAL;

    @Size(max = 500, message = "Notes cannot exceed 500 characters")
    private String notes;

    public static BloodRequestForm prefill(User user) {
        BloodRequestForm form = new BloodRequestForm();
        if (user != null) {
            form.setContactName(user.getFullName());
            form.setContactPhone(user.getPhone());
            form.setCity(user.getCity());
        }
        form.setRequiredDate(LocalDate.now());
        form.setUrgency(UrgencyLevel.NORMAL);
        form.setUnitsNeeded(1);
        return form;
    }

    public String getPatientName() {
        return patientName;
    }

    public void setPatientName(String patientName) {
        this.patientName = patientName == null ? null : patientName.trim();
    }

    public BloodGroup getBloodGroup() {
        return bloodGroup;
    }

    public void setBloodGroup(BloodGroup bloodGroup) {
        this.bloodGroup = bloodGroup;
    }

    public Integer getUnitsNeeded() {
        return unitsNeeded;
    }

    public void setUnitsNeeded(Integer unitsNeeded) {
        this.unitsNeeded = unitsNeeded;
    }

    public String getHospitalName() {
        return hospitalName;
    }

    public void setHospitalName(String hospitalName) {
        this.hospitalName = hospitalName == null ? null : hospitalName.trim();
    }

    public String getHospitalAddress() {
        return hospitalAddress;
    }

    public void setHospitalAddress(String hospitalAddress) {
        this.hospitalAddress = hospitalAddress == null ? null : hospitalAddress.trim();
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city == null ? null : city.trim();
    }

    public String getContactName() {
        return contactName;
    }

    public void setContactName(String contactName) {
        this.contactName = contactName == null ? null : contactName.trim();
    }

    public String getContactPhone() {
        return contactPhone;
    }

    public void setContactPhone(String contactPhone) {
        if (contactPhone != null) {
            String clean = contactPhone.replaceAll("[\\s-]", "");
            if (clean.startsWith("+91")) {
                clean = clean.substring(3);
            }
            this.contactPhone = clean;
        } else {
            this.contactPhone = null;
        }
    }

    public LocalDate getRequiredDate() {
        return requiredDate;
    }

    public void setRequiredDate(LocalDate requiredDate) {
        this.requiredDate = requiredDate;
    }

    public UrgencyLevel getUrgency() {
        return urgency;
    }

    public void setUrgency(UrgencyLevel urgency) {
        this.urgency = urgency;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes == null ? null : notes.trim();
    }
}
