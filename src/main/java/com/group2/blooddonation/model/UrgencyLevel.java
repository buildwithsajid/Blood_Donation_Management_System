package com.group2.blooddonation.model;

/**
 * Urgency priority for blood requirement requests.
 */
public enum UrgencyLevel {
    NORMAL("Normal"),
    URGENT("Urgent"),
    CRITICAL("Critical");

    private final String label;

    UrgencyLevel(String label) {
        this.label = label;
    }

    public String getLabel() {
        return label;
    }
}
