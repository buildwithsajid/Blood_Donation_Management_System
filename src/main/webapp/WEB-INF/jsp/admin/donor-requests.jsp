<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="ui" tagdir="/WEB-INF/tags" %>

<ui:page title="New Donor Requests" activeNav="donor-requests">

    <header class="page-header" style="justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 1rem;">
        <div>
            <h1 class="page-title">New Donor Requests</h1>
            <p class="page-subtitle">
                Review user blood donation requests, approve slots, or directly add donors to the system registry.
            </p>
        </div>
        <div>
            <span style="background-color: #fef3c7; color: #92400e; font-size: 0.875rem; font-weight: 600; padding: 0.375rem 0.75rem; border-radius: 9999px;">
                ${pendingCount} Pending Review
            </span>
        </div>
    </header>

    <!-- Status filter chips -->
    <nav class="chip-list filter-bar" aria-label="Filter by request status" style="margin-bottom: 1.5rem;">
        <a class="chip" href="<c:url value='/admin/donor-requests'/>" ${empty selectedStatus ? 'aria-current="page"' : ''}>All (${requests.size()})</a>
        <c:forEach items="${statuses}" var="status">
            <c:url var="statusUrl" value="/admin/donor-requests">
                <c:param name="status" value="${status}"/>
            </c:url>
            <a class="chip" href="${statusUrl}" ${selectedStatus == status ? 'aria-current="page"' : ''}>${status.label}</a>
        </c:forEach>
    </nav>

    <c:choose>
        <c:when test="${empty requests}">
            <div class="empty-state">
                <p class="empty-state-title">No donor requests found</p>
                <p class="empty-state-text">
                    <c:choose>
                        <c:when test="${empty selectedStatus}">No blood donation requests have been submitted by users yet.</c:when>
                        <c:otherwise>No requests found with status "${selectedStatus.label}".</c:otherwise>
                    </c:choose>
                </p>
            </div>
        </c:when>
        <c:otherwise>
            <div style="display: grid; gap: 1.25rem;">
                <c:forEach items="${requests}" var="req">
                    <div class="card" style="padding: 1.25rem; border-left: 4px solid ${req.status == 'PENDING' ? '#f59e0b' : (req.status == 'APPROVED' ? '#10b981' : '#a8a29e')};">
                        <div style="display: flex; justify-content: space-between; align-items: flex-start; flex-wrap: wrap; gap: 0.75rem; margin-bottom: 1rem;">
                            <div style="display: flex; align-items: center; gap: 0.75rem;">
                                <ui:blood-group-badge group="${req.bloodGroup}"/>
                                <div>
                                    <h3 style="font-size: 1.125rem; font-weight: 700; color: #1c1917; margin: 0;">
                                        <c:out value="${req.fullName}"/>
                                    </h3>
                                    <p style="font-size: 0.8125rem; color: #78716c; margin: 0.125rem 0 0 0;">
                                        ${req.age} yrs &middot; ${req.gender.label} &middot; <c:out value="${req.city}"/> &middot; Mobile: <a href="tel:+91${req.phone}" style="color: #dc2626; font-weight: 600;"><c:out value="${req.phone}"/></a>
                                        <c:if test="${not empty req.email}">&middot; <c:out value="${req.email}"/></c:if>
                                    </p>
                                </div>
                            </div>
                            <div style="display: flex; align-items: center; gap: 0.5rem;">
                                <span class="status ${req.status.badgeClass}">${req.status.label}</span>
                                <span style="font-size: 0.75rem; color: #a8a29e;">#${req.id} &middot; <ui:date value="${req.createdAt}"/></span>
                            </div>
                        </div>

                        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 0.75rem; background-color: #fafaf9; border-radius: 0.5rem; padding: 0.75rem; font-size: 0.875rem; margin-bottom: 1rem;">
                            <div>
                                <span style="color: #78716c; font-size: 0.75rem; display: block; font-weight: 600;">PREFERRED DATE</span>
                                <strong style="color: #292524;"><ui:date value="${req.preferredDate}" fallback="Flexible / Any date"/></strong>
                            </div>
                            <div style="grid-column: span 2;">
                                <span style="color: #78716c; font-size: 0.75rem; display: block; font-weight: 600;">MEDICAL DETAILS / NOTES</span>
                                <span style="color: #44403c;"><c:out value="${empty req.medicalDetails ? 'None reported' : req.medicalDetails}"/></span>
                            </div>
                            <c:if test="${not empty req.adminNotes}">
                                <div style="grid-column: 1 / -1; border-top: 1px dashed #e7e5e4; padding-top: 0.5rem; margin-top: 0.25rem;">
                                    <span style="color: #78716c; font-size: 0.75rem; display: block; font-weight: 600;">ADMIN REMARKS</span>
                                    <span style="color: #1c1917; font-weight: 500;"><c:out value="${req.adminNotes}"/></span>
                                </div>
                            </c:if>
                        </div>

                        <!-- Action Bar for Administrator -->
                        <div style="display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 0.75rem; border-top: 1px solid #f5f5f4; pt: 0.75rem;">
                            <div style="font-size: 0.8125rem; color: #78716c;">
                                Actions:
                            </div>
                            <div style="display: flex; gap: 0.5rem; flex-wrap: wrap; align-items: center;">
                                <!-- Action 1: Approve and Add to Registry -->
                                <c:if test="${req.status == 'PENDING'}">
                                    <form method="post" action="<c:url value='/admin/donor-requests/${req.id}/approve-and-add'/>" style="display: inline;">
                                        <input type="hidden" name="adminNotes" value="Approved by admin and registered in donors registry">
                                        <button class="btn btn-primary btn-sm" type="submit" style="background-color: #059669; border-color: #059669;">
                                            &#10003; Approve & Add to Donors
                                        </button>
                                    </form>

                                    <!-- Action 2: Simple Approve -->
                                    <form method="post" action="<c:url value='/admin/donor-requests/${req.id}/status'/>" style="display: inline;">
                                        <input type="hidden" name="status" value="APPROVED">
                                        <input type="hidden" name="adminNotes" value="Request verified. Slot confirmed.">
                                        <button class="btn btn-secondary btn-sm" type="submit">
                                            Approve Slot
                                        </button>
                                    </form>

                                    <!-- Action 3: Reject -->
                                    <form method="post" action="<c:url value='/admin/donor-requests/${req.id}/status'/>" style="display: inline;"
                                          data-confirm="Reject this blood donation request?">
                                        <input type="hidden" name="status" value="REJECTED">
                                        <input type="hidden" name="adminNotes" value="Declined after health/eligibility review.">
                                        <button class="btn btn-danger btn-sm" type="submit">
                                            Reject
                                        </button>
                                    </form>
                                </c:if>

                                <c:if test="${req.status == 'APPROVED'}">
                                    <form method="post" action="<c:url value='/admin/donor-requests/${req.id}/status'/>" style="display: inline;">
                                        <input type="hidden" name="status" value="COMPLETED">
                                        <input type="hidden" name="adminNotes" value="Donation completed at blood bank center.">
                                        <button class="btn btn-primary btn-sm" type="submit">
                                            Mark as Completed
                                        </button>
                                    </form>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>

</ui:page>
