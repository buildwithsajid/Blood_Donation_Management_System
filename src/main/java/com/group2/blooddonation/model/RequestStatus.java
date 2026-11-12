package com.group2.blooddonation.model;

/**
 * Status lifecycle for blood donation and requirement requests.
 */
public enum RequestStatus {
    PENDING("Pending", "status-waiting"),
    APPROVED("Approved", "status-ready"),
    REJECTED("Rejected", "status-off"),
    COMPLETED("Completed", "status-ready"),
    FULFILLED("Fulfilled", "status-ready"),
    CANCELLED("Cancelled", "status-off");

    private final String label;
    private final String badgeClass;

    RequestStatus(String label, String badgeClass) {
        this.label = label;
        this.badgeClass = badgeClass;
    }

    public String getLabel() {
        return label;
    }

    public String getBadgeClass() {
        return badgeClass;
    }
}
