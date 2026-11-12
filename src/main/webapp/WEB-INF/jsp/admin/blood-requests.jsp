<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="ui" tagdir="/WEB-INF/tags" %>

<ui:page title="Blood Requirement Requests" activeNav="blood-requests">

    <header class="page-header" style="justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 1rem;">
        <div>
            <h1 class="page-title">Blood Requirement Requests</h1>
            <p class="page-subtitle">
                Review urgent blood requests from patients and hospitals, match with compatible donors, and track fulfillment.
            </p>
        </div>
        <div>
            <span style="background-color: #fee2e2; color: #991b1b; font-size: 0.875rem; font-weight: 600; padding: 0.375rem 0.75rem; border-radius: 9999px;">
                ${pendingCount} Pending Requirements
            </span>
        </div>
    </header>

    <!-- Status filter chips -->
    <nav class="chip-list filter-bar" aria-label="Filter by request status" style="margin-bottom: 1.5rem;">
        <a class="chip" href="<c:url value='/admin/blood-requests'/>" ${empty selectedStatus ? 'aria-current="page"' : ''}>All (${requests.size()})</a>
        <c:forEach items="${statuses}" var="status">
            <c:url var="statusUrl" value="/admin/blood-requests">
                <c:param name="status" value="${status}"/>
            </c:url>
            <a class="chip" href="${statusUrl}" ${selectedStatus == status ? 'aria-current="page"' : ''}>${status.label}</a>
        </c:forEach>
    </nav>

    <c:choose>
        <c:when test="${empty requests}">
            <div class="empty-state">
                <p class="empty-state-title">No blood requirements found</p>
                <p class="empty-state-text">
                    <c:choose>
                        <c:when test="${empty selectedStatus}">No blood requirement requests have been submitted yet.</c:when>
                        <c:otherwise>No requests found with status "${selectedStatus.label}".</c:otherwise>
                    </c:choose>
                </p>
            </div>
        </c:when>
        <c:otherwise>
            <div style="display: grid; gap: 1.25rem;">
                <c:forEach items="${requests}" var="req">
                    <div class="card" style="padding: 1.25rem; border-left: 4px solid ${req.urgency == 'CRITICAL' ? '#dc2626' : (req.urgency == 'URGENT' ? '#f59e0b' : '#0284c7')};">
                        <div style="display: flex; justify-content: space-between; align-items: flex-start; flex-wrap: wrap; gap: 0.75rem; margin-bottom: 1rem;">
                            <div style="display: flex; align-items: center; gap: 0.75rem;">
                                <ui:blood-group-badge group="${req.bloodGroup}"/>
                                <div>
                                    <div style="display: flex; align-items: center; gap: 0.5rem; flex-wrap: wrap;">
                                        <h3 style="font-size: 1.125rem; font-weight: 700; color: #1c1917; margin: 0;">
                                            Patient: <c:out value="${req.patientName}"/>
                                        </h3>
                                        <c:choose>
                                            <c:when test="${req.urgency == 'CRITICAL'}">
                                                <span style="background-color: #fee2e2; color: #991b1b; font-size: 0.6875rem; font-weight: 800; padding: 0.125rem 0.5rem; border-radius: 9999px;">CRITICAL</span>
                                            </c:when>
                                            <c:when test="${req.urgency == 'URGENT'}">
                                                <span style="background-color: #fef3c7; color: #92400e; font-size: 0.6875rem; font-weight: 700; padding: 0.125rem 0.5rem; border-radius: 9999px;">URGENT</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span style="background-color: #f5f5f4; color: #57534e; font-size: 0.6875rem; font-weight: 600; padding: 0.125rem 0.5rem; border-radius: 9999px;">Normal</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <p style="font-size: 0.8125rem; color: #78716c; margin: 0.125rem 0 0 0;">
                                        <strong>${req.unitsNeeded} unit(s)</strong> needed at <strong><c:out value="${req.hospitalName}"/></strong> (<c:out value="${req.city}"/>)
                                        <c:if test="${not empty req.hospitalAddress}">&middot; <c:out value="${req.hospitalAddress}"/></c:if>
                                    </p>
                                </div>
                            </div>
                            <div style="display: flex; align-items: center; gap: 0.5rem;">
                                <span class="status ${req.status.badgeClass}">${req.status.label}</span>
                                <span style="font-size: 0.75rem; color: #a8a29e;">#${req.id}</span>
                            </div>
                        </div>

                        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)); gap: 0.75rem; background-color: #fafaf9; border-radius: 0.5rem; padding: 0.75rem; font-size: 0.875rem; margin-bottom: 1rem;">
                            <div>
                                <span style="color: #78716c; font-size: 0.75rem; display: block; font-weight: 600;">REQUIRED BY DATE</span>
                                <strong style="color: #dc2626;"><ui:date value="${req.requiredDate}"/></strong>
                            </div>
                            <div>
                                <span style="color: #78716c; font-size: 0.75rem; display: block; font-weight: 600;">CONTACT PERSON</span>
                                <span style="color: #1c1917; font-weight: 600;"><c:out value="${req.contactName}"/></span>
                                <div style="font-size: 0.75rem;"><a href="tel:+91${req.contactPhone}" style="color: #0284c7;"><c:out value="${req.contactPhone}"/></a></div>
                            </div>
                            <div style="grid-column: span 2;">
                                <span style="color: #78716c; font-size: 0.75rem; display: block; font-weight: 600;">NOTES / DIAGNOSIS</span>
                                <span style="color: #44403c;"><c:out value="${empty req.notes ? 'No specific notes given' : req.notes}"/></span>
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
                            <div>
                                <!-- Quick Match Donors Tool -->
                                <c:url var="matchUrl" value="/search">
                                    <c:param name="bloodGroup" value="${req.bloodGroup}"/>
                                    <c:param name="city" value="${req.city}"/>
                                    <c:param name="includeCompatible" value="true"/>
                                </c:url>
                                <a class="btn btn-secondary btn-sm" href="${matchUrl}" target="_blank" style="color: #0369a1; border-color: #bae6fd; background-color: #f0f9ff;">
                                    &#128269; Find Matching Donors in <c:out value="${req.city}"/> &rarr;
                                </a>
                            </div>

                            <div style="display: flex; gap: 0.5rem; flex-wrap: wrap; align-items: center;">
                                <c:if test="${req.status == 'PENDING'}">
                                    <!-- Action 1: Approve -->
                                    <form method="post" action="<c:url value='/admin/blood-requests/${req.id}/status'/>" style="display: inline;">
                                        <input type="hidden" name="status" value="APPROVED">
                                        <input type="hidden" name="adminNotes" value="Approved. Coordinating with hospital blood bank.">
                                        <button class="btn btn-secondary btn-sm" type="submit">
                                            Approve Request
                                        </button>
                                    </form>

                                    <!-- Action 2: Fulfill directly -->
                                    <form method="post" action="<c:url value='/admin/blood-requests/${req.id}/status'/>" style="display: inline;">
                                        <input type="hidden" name="status" value="FULFILLED">
                                        <input type="hidden" name="adminNotes" value="Blood units arranged and delivered to hospital.">
                                        <button class="btn btn-primary btn-sm" type="submit" style="background-color: #059669; border-color: #059669;">
                                            &#10003; Mark as Fulfilled
                                        </button>
                                    </form>

                                    <!-- Action 3: Reject -->
                                    <form method="post" action="<c:url value='/admin/blood-requests/${req.id}/status'/>" style="display: inline;"
                                          data-confirm="Reject this blood requirement request?">
                                        <input type="hidden" name="status" value="REJECTED">
                                        <input type="hidden" name="adminNotes" value="Unable to supply required units at this time.">
                                        <button class="btn btn-danger btn-sm" type="submit">
                                            Reject
                                        </button>
                                    </form>
                                </c:if>

                                <c:if test="${req.status == 'APPROVED'}">
                                    <form method="post" action="<c:url value='/admin/blood-requests/${req.id}/status'/>" style="display: inline;">
                                        <input type="hidden" name="status" value="FULFILLED">
                                        <input type="hidden" name="adminNotes" value="Blood units arranged and delivered to hospital.">
                                        <button class="btn btn-primary btn-sm" type="submit" style="background-color: #059669; border-color: #059669;">
                                            &#10003; Mark as Fulfilled
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
