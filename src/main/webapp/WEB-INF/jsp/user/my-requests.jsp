<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="ui" tagdir="/WEB-INF/tags" %>

<ui:page title="My Requests" activeNav="my-requests">

    <header class="page-header">
        <div>
            <h1 class="page-title">My Requests</h1>
            <p class="page-subtitle">Track status and administrative updates for your blood donation and requirement requests.</p>
        </div>
        <div style="display: flex; gap: 0.5rem; flex-wrap: wrap;">
            <a class="btn btn-primary btn-sm" href="<c:url value='/user/donate'/>">+ Donate Blood</a>
            <a class="btn btn-secondary btn-sm" href="<c:url value='/user/request-blood'/>">+ Request Blood</a>
        </div>
    </header>

    <!-- SECTION 1: Blood Donation Requests -->
    <section class="section" style="margin-bottom: 3rem;">
        <div class="section-header">
            <h2 class="section-title">Blood Donation Requests (${donationRequests.size()})</h2>
        </div>

        <c:choose>
            <c:when test="${empty donationRequests}">
                <div class="empty-state" style="padding: 2rem 1rem;">
                    <p class="empty-state-title">No donation requests yet</p>
                    <p class="empty-state-text">Ready to save a life? Submit your first blood donation request.</p>
                    <div class="empty-state-actions">
                        <a class="btn btn-primary" href="<c:url value='/user/donate'/>">Send Donation Request</a>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="data-table-wrap">
                    <table class="data-table">
                        <thead>
                        <tr>
                            <th scope="col">ID</th>
                            <th scope="col">Donor Name</th>
                            <th scope="col">Blood Group</th>
                            <th scope="col">City</th>
                            <th scope="col">Preferred Date</th>
                            <th scope="col">Status</th>
                            <th scope="col">Admin Remarks</th>
                            <th scope="col">Action</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${donationRequests}" var="req">
                            <tr>
                                <td>#${req.id}</td>
                                <td>
                                    <span style="font-weight: 600;"><c:out value="${req.fullName}"/></span>
                                    <div style="font-size: 0.75rem; color: #78716c;">${req.age} yrs &middot; ${req.gender.label}</div>
                                </td>
                                <td><ui:blood-group-badge group="${req.bloodGroup}"/></td>
                                <td><c:out value="${req.city}"/></td>
                                <td><ui:date value="${req.preferredDate}" fallback="Any day"/></td>
                                <td>
                                    <span class="status ${req.status.badgeClass}">${req.status.label}</span>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty req.adminNotes}">
                                            <span style="color: #44403c;"><c:out value="${req.adminNotes}"/></span>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: #a8a29e; font-size: 0.8125rem;">Under review</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:if test="${req.status == 'PENDING'}">
                                        <form method="post" action="<c:url value='/user/requests/donation/${req.id}/cancel'/>"
                                              data-confirm="Are you sure you want to cancel this donation request?">
                                            <button class="btn btn-secondary btn-sm" type="submit" style="color: #dc2626;">Cancel</button>
                                        </form>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </section>

    <!-- SECTION 2: Blood Requirement Requests -->
    <section class="section">
        <div class="section-header">
            <h2 class="section-title">Blood Requirement Requests (${bloodRequests.size()})</h2>
        </div>

        <c:choose>
            <c:when test="${empty bloodRequests}">
                <div class="empty-state" style="padding: 2rem 1rem;">
                    <p class="empty-state-title">No blood requirement requests yet</p>
                    <p class="empty-state-text">Need blood units for surgery or emergency? Submit a requirement request.</p>
                    <div class="empty-state-actions">
                        <a class="btn btn-secondary" href="<c:url value='/user/request-blood'/>">Submit Blood Requirement</a>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="data-table-wrap">
                    <table class="data-table">
                        <thead>
                        <tr>
                            <th scope="col">ID</th>
                            <th scope="col">Patient & Hospital</th>
                            <th scope="col">Blood Group</th>
                            <th scope="col">Units</th>
                            <th scope="col">Needed By</th>
                            <th scope="col">Urgency</th>
                            <th scope="col">Status</th>
                            <th scope="col">Admin Notes</th>
                            <th scope="col">Action</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${bloodRequests}" var="req">
                            <tr>
                                <td>#${req.id}</td>
                                <td>
                                    <span style="font-weight: 600;"><c:out value="${req.patientName}"/></span>
                                    <div style="font-size: 0.75rem; color: #78716c;">
                                        <c:out value="${req.hospitalName}"/> (<c:out value="${req.city}"/>)
                                    </div>
                                </td>
                                <td><ui:blood-group-badge group="${req.bloodGroup}"/></td>
                                <td><strong>${req.unitsNeeded}</strong></td>
                                <td><ui:date value="${req.requiredDate}"/></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${req.urgency == 'CRITICAL'}">
                                            <span style="display: inline-block; padding: 0.125rem 0.5rem; border-radius: 9999px; font-size: 0.75rem; font-weight: 700; background-color: #fee2e2; color: #991b1b;">CRITICAL</span>
                                        </c:when>
                                        <c:when test="${req.urgency == 'URGENT'}">
                                            <span style="display: inline-block; padding: 0.125rem 0.5rem; border-radius: 9999px; font-size: 0.75rem; font-weight: 600; background-color: #fef3c7; color: #92400e;">URGENT</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="display: inline-block; padding: 0.125rem 0.5rem; border-radius: 9999px; font-size: 0.75rem; font-weight: 500; background-color: #f5f5f4; color: #57534e;">Normal</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <span class="status ${req.status.badgeClass}">${req.status.label}</span>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty req.adminNotes}">
                                            <span style="color: #44403c;"><c:out value="${req.adminNotes}"/></span>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: #a8a29e; font-size: 0.8125rem;">Processing</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:if test="${req.status == 'PENDING'}">
                                        <form method="post" action="<c:url value='/user/requests/blood/${req.id}/cancel'/>"
                                              data-confirm="Are you sure you want to cancel this blood requirement request?">
                                            <button class="btn btn-secondary btn-sm" type="submit" style="color: #dc2626;">Cancel</button>
                                        </form>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </section>

</ui:page>
