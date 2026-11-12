<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="ui" tagdir="/WEB-INF/tags" %>

<ui:page title="User Dashboard" activeNav="dashboard">

    <header class="page-header" style="align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 1rem;">
        <div style="display: flex; align-items: center; gap: 1rem;">
            <c:if test="${not empty user.bloodGroup}">
                <ui:blood-group-badge group="${user.bloodGroup}" size="lg"/>
            </c:if>
            <div>
                <h1 class="page-title">Welcome, <c:out value="${user.fullName}"/></h1>
                <p class="page-subtitle">
                    <c:out value="${user.city}"/> &middot; Mobile: <c:out value="${user.phone}"/> &middot; <c:out value="${user.email}"/>
                </p>
            </div>
        </div>
        <div style="display: flex; gap: 0.75rem; flex-wrap: wrap;">
            <a class="btn btn-primary" href="<c:url value='/user/donate'/>">+ Donate Blood Request</a>
            <a class="btn btn-secondary" href="<c:url value='/user/request-blood'/>">+ Blood Requirement Request</a>
        </div>
    </header>

    <section class="stats" aria-label="My Requests Summary" style="margin-top: 1.5rem; margin-bottom: 2rem;">
        <div class="stat-card">
            <span class="stat-value">${donationRequests.size()}</span>
            <span class="stat-label">Donation Requests (${pendingDonations} Pending, ${approvedDonations} Approved)</span>
        </div>
        <div class="stat-card">
            <span class="stat-value">${bloodRequests.size()}</span>
            <span class="stat-label">Requirement Requests (${pendingRequirements} Pending, ${fulfilledRequirements} Fulfilled)</span>
        </div>
        <div class="stat-card stat-card-highlight">
            <span class="stat-value"><c:out value="${user.bloodGroup.label}"/></span>
            <span class="stat-label">Your Blood Group</span>
        </div>
    </section>

    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(320px, 1fr)); gap: 1.5rem; margin-bottom: 2.5rem;">
        <!-- Card 1: Donate Blood -->
        <div class="card" style="display: flex; flex-direction: column; justify-content: space-between;">
            <div>
                <div style="display: inline-flex; align-items: center; justify-content: center; width: 2.5rem; height: 2.5rem; border-radius: 0.5rem; background-color: #fee2e2; color: #dc2626; margin-bottom: 0.75rem;">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
                        <path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"/>
                    </svg>
                </div>
                <h2 class="card-title" style="font-size: 1.125rem;">Want to Donate Blood?</h2>
                <p style="color: #57534e; font-size: 0.875rem; margin-top: 0.5rem;">
                    Submit a blood donation request to the blood bank. The admin will verify your request and approve your slot for donation.
                </p>
            </div>
            <div style="margin-top: 1.25rem;">
                <a class="btn btn-primary btn-block" href="<c:url value='/user/donate'/>">Send Blood Donation Request &rarr;</a>
            </div>
        </div>

        <!-- Card 2: Need Blood -->
        <div class="card" style="display: flex; flex-direction: column; justify-content: space-between;">
            <div>
                <div style="display: inline-flex; align-items: center; justify-content: center; width: 2.5rem; height: 2.5rem; border-radius: 0.5rem; background-color: #e0f2fe; color: #0284c7; margin-bottom: 0.75rem;">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M19 14c1.49-1.46 3-3.21 3-5.5A5.5 5.5 0 0 0 16.5 3c-1.76 0-3 .5-4.5 2-1.5-1.5-2.74-2-4.5-2A5.5 5.5 0 0 0 2 8.5c0 2.3 1.5 4.05 3 5.5l7 7Z"/>
                    </svg>
                </div>
                <h2 class="card-title" style="font-size: 1.125rem;">Need Blood for a Patient?</h2>
                <p style="color: #57534e; font-size: 0.875rem; margin-top: 0.5rem;">
                    Submit an urgent blood requirement request specifying required blood group, hospital details, and urgency level.
                </p>
            </div>
            <div style="margin-top: 1.25rem;">
                <a class="btn btn-secondary btn-block" href="<c:url value='/user/request-blood'/>">Submit Blood Requirement &rarr;</a>
            </div>
        </div>
    </div>

    <!-- Recent requests overview -->
    <section class="section">
        <div class="section-header">
            <h2 class="section-title">My Recent Activity</h2>
            <a class="section-link" href="<c:url value='/user/my-requests'/>">View all requests &rarr;</a>
        </div>

        <c:choose>
            <c:when test="${empty donationRequests and empty bloodRequests}">
                <div class="empty-state">
                    <p class="empty-state-title">No requests submitted yet</p>
                    <p class="empty-state-text">You haven't sent any blood donation or requirement requests yet.</p>
                    <div class="empty-state-actions">
                        <a class="btn btn-primary" href="<c:url value='/user/donate'/>">Send Donation Request</a>
                        <a class="btn btn-secondary" href="<c:url value='/user/request-blood'/>">Submit Blood Requirement</a>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="data-table-wrap">
                    <table class="data-table">
                        <thead>
                        <tr>
                            <th scope="col">Type</th>
                            <th scope="col">Details</th>
                            <th scope="col">Blood Group</th>
                            <th scope="col">Date</th>
                            <th scope="col">Status</th>
                            <th scope="col">Admin Notes</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${donationRequests}" var="req" end="2">
                            <tr>
                                <td><span style="font-weight: 600; color: #dc2626;">Blood Donation</span></td>
                                <td><c:out value="${req.fullName}"/> (<c:out value="${req.city}"/>)</td>
                                <td><ui:blood-group-badge group="${req.bloodGroup}"/></td>
                                <td><ui:date value="${req.createdAt}"/></td>
                                <td><span class="status ${req.status.badgeClass}">${req.status.label}</span></td>
                                <td><c:out value="${empty req.adminNotes ? '—' : req.adminNotes}"/></td>
                            </tr>
                        </c:forEach>
                        <c:forEach items="${bloodRequests}" var="req" end="2">
                            <tr>
                                <td><span style="font-weight: 600; color: #0284c7;">Blood Requirement</span></td>
                                <td>Patient: <c:out value="${req.patientName}"/> &middot; ${req.unitsNeeded} unit(s) @ <c:out value="${req.hospitalName}"/></td>
                                <td><ui:blood-group-badge group="${req.bloodGroup}"/></td>
                                <td><ui:date value="${req.requiredDate}"/></td>
                                <td><span class="status ${req.status.badgeClass}">${req.status.label}</span></td>
                                <td><c:out value="${empty req.adminNotes ? '—' : req.adminNotes}"/></td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </section>

</ui:page>
