<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="ui" tagdir="/WEB-INF/tags" %>

<ui:page title="Admin Dashboard" activeNav="admin-dashboard">

    <header class="page-header" style="justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 1rem;">
        <div>
            <h1 class="page-title">Administrator Portal</h1>
            <p class="page-subtitle">Overview of donor registries, new donor verification requests, and urgent blood requirements.</p>
        </div>
        <div style="display: flex; gap: 0.75rem; flex-wrap: wrap;">
            <a class="btn btn-primary btn-sm" href="<c:url value='/admin/donor-requests'/>">Review Donor Requests</a>
            <a class="btn btn-secondary btn-sm" href="<c:url value='/admin/blood-requests'/>">Manage Blood Requirements</a>
            <a class="btn btn-secondary btn-sm" href="<c:url value='/donors/new'/>">+ Register Donor</a>
        </div>
    </header>

    <section class="stats" aria-label="Administrative metrics" style="margin-top: 1.5rem; margin-bottom: 2rem;">
        <div class="stat-card">
            <span class="stat-value">${donorStats.totalDonors}</span>
            <span class="stat-label">Registered Donors</span>
        </div>
        <div class="stat-card ${pendingDonationRequests > 0 ? 'stat-card-highlight' : ''}">
            <span class="stat-value">${pendingDonationRequests}</span>
            <span class="stat-label">Pending Donor Requests</span>
        </div>
        <div class="stat-card ${pendingBloodRequests > 0 ? 'stat-card-highlight' : ''}">
            <span class="stat-value">${pendingBloodRequests}</span>
            <span class="stat-label">Pending Blood Requirements</span>
        </div>
    </section>

    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(320px, 1fr)); gap: 1.5rem; margin-bottom: 2.5rem;">
        <!-- Card 1: Donor Requests -->
        <div class="card" style="display: flex; flex-direction: column; justify-content: space-between;">
            <div>
                <div style="display: flex; justify-content: space-between; align-items: flex-start;">
                    <div style="display: inline-flex; align-items: center; justify-content: center; width: 2.5rem; height: 2.5rem; border-radius: 0.5rem; background-color: #fee2e2; color: #dc2626; margin-bottom: 0.75rem;">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
                            <path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"/>
                        </svg>
                    </div>
                    <c:if test="${pendingDonationRequests > 0}">
                        <span style="background-color: #fef3c7; color: #92400e; font-size: 0.75rem; font-weight: 700; padding: 0.25rem 0.625rem; border-radius: 9999px;">
                            ${pendingDonationRequests} Action Needed
                        </span>
                    </c:if>
                </div>
                <h2 class="card-title">New Donor Requests</h2>
                <p style="color: #57534e; font-size: 0.875rem; margin-top: 0.5rem;">
                    Review requests from users who wish to donate blood. Approve them and optionally add them straight to the official donors registry.
                </p>
            </div>
            <div style="margin-top: 1.25rem;">
                <a class="btn btn-primary btn-block" href="<c:url value='/admin/donor-requests'/>">View All Donor Requests &rarr;</a>
            </div>
        </div>

        <!-- Card 2: Blood Requirements -->
        <div class="card" style="display: flex; flex-direction: column; justify-content: space-between;">
            <div>
                <div style="display: flex; justify-content: space-between; align-items: flex-start;">
                    <div style="display: inline-flex; align-items: center; justify-content: center; width: 2.5rem; height: 2.5rem; border-radius: 0.5rem; background-color: #e0f2fe; color: #0284c7; margin-bottom: 0.75rem;">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M19 14c1.49-1.46 3-3.21 3-5.5A5.5 5.5 0 0 0 16.5 3c-1.76 0-3 .5-4.5 2-1.5-1.5-2.74-2-4.5-2A5.5 5.5 0 0 0 2 8.5c0 2.3 1.5 4.05 3 5.5l7 7Z"/>
                        </svg>
                    </div>
                    <c:if test="${pendingBloodRequests > 0}">
                        <span style="background-color: #fee2e2; color: #991b1b; font-size: 0.75rem; font-weight: 700; padding: 0.25rem 0.625rem; border-radius: 9999px;">
                            ${pendingBloodRequests} Pending
                        </span>
                    </c:if>
                </div>
                <h2 class="card-title">Blood Requirement Requests</h2>
                <p style="color: #57534e; font-size: 0.875rem; margin-top: 0.5rem;">
                    Review patient blood requests, coordinate with hospitals, find matching compatible donors in one click, and fulfill requests.
                </p>
            </div>
            <div style="margin-top: 1.25rem;">
                <a class="btn btn-secondary btn-block" href="<c:url value='/admin/blood-requests'/>">Manage Blood Requirements &rarr;</a>
            </div>
        </div>
    </div>

    <!-- Quick Links to Existing Features -->
    <section class="section">
        <div class="section-header">
            <h2 class="section-title">Donor Registry Quick Access</h2>
            <a class="section-link" href="<c:url value='/donors'/>">All Registered Donors &rarr;</a>
        </div>
        <div style="display: flex; gap: 1rem; flex-wrap: wrap;">
            <a class="btn btn-secondary" href="<c:url value='/donors'/>">View All Registered Donors (${donorStats.totalDonors})</a>
            <a class="btn btn-secondary" href="<c:url value='/search'/>">Find Donors Tool</a>
            <a class="btn btn-primary" href="<c:url value='/donors/new'/>">Register New Donor Manually</a>
        </div>
    </section>

</ui:page>
