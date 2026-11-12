package com.group2.blooddonation.model;

/**
 * Access role for users in the system.
 */
public enum UserRole {
    ADMIN("Administrator"),
    USER("Donor / Recipient");

    private final String label;

    UserRole(String label) {
        this.label = label;
    }

    public String getLabel() {
        return label;
    }
}
