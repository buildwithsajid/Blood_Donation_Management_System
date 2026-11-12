<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="ui" tagdir="/WEB-INF/tags" %>

<ui:page title="Home">

    <section class="hero">
        <div>
            <p class="hero-eyebrow">Every drop counts</p>
            <h1 class="hero-title">Find the right blood donor, fast.</h1>
            <p class="hero-lead">
                Keep donor details in one place and search by blood group to find donors
                who can give blood today.
            </p>
            <div class="hero-actions">
                <a class="btn btn-primary" href="<c:url value='/donors/new'/>">Register a donor</a>
                <a class="btn btn-secondary" href="<c:url value='/donors'/>">View all donors</a>
            </div>
        </div>

        <form class="card quick-search" action="<c:url value='/search'/>" method="get">
            <h2 class="card-title">Need blood?</h2>
            <label class="label" for="quick-blood-group">Patient's blood group</label>
            <div class="quick-search-row">
                <select class="input" id="quick-blood-group" name="bloodGroup" required>
                    <option value="">Select blood group</option>
                    <c:forEach items="${bloodGroups}" var="group">
                        <option value="${group}">${group.label}</option>
                    </c:forEach>
                </select>
                <button class="btn btn-primary" type="submit">Find donors</button>
            </div>
            <p class="hint">Lists donors with a compatible blood group who can donate today.</p>
        </form>
    </section>

    <!-- Portal Bar for Users and Admin -->
    <section class="section" style="margin-top: 1.5rem; margin-bottom: 1.5rem;">
        <c:choose>
            <c:when test="${isAdmin}">
                <div class="card" style="background-color: #fafaf9; border-left: 4px solid #1c1917; display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 1rem; padding: 1.25rem;">
                    <div>
                        <h3 style="font-size: 1rem; font-weight: 700; color: #1c1917; margin: 0;">Logged in as Administrator</h3>
                        <p style="font-size: 0.875rem; color: #57534e; margin: 0.25rem 0 0 0;">Manage new donor requests, approve blood requirements, and maintain the blood registry.</p>
                    </div>
                    <div style="display: flex; gap: 0.5rem; flex-wrap: wrap;">
                        <a class="btn btn-primary btn-sm" href="<c:url value='/admin/donor-requests'/>">Donor Requests (${pendingDonorRequestsCount} pending)</a>
                        <a class="btn btn-secondary btn-sm" href="<c:url value='/admin/blood-requests'/>">Blood Requests (${pendingBloodRequestsCount} pending)</a>
                        <a class="btn btn-secondary btn-sm" href="<c:url value='/admin/dashboard'/>">Admin Portal</a>
                    </div>
                </div>
            </c:when>
            <c:when test="${isUser}">
                <div class="card" style="background-color: #fff1f2; border-left: 4px solid #e11d48; display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 1rem; padding: 1.25rem;">
                    <div>
                        <h3 style="font-size: 1rem; font-weight: 700; color: #9f1239; margin: 0;">Welcome back, <c:out value="${currentUser.fullName}"/>!</h3>
                        <p style="font-size: 0.875rem; color: #881337; margin: 0.25rem 0 0 0;">Send blood donation requests, request blood for emergencies, or track your requests.</p>
                    </div>
                    <div style="display: flex; gap: 0.5rem; flex-wrap: wrap;">
                        <a class="btn btn-primary btn-sm" href="<c:url value='/user/donate'/>">+ Donate Blood</a>
                        <a class="btn btn-secondary btn-sm" href="<c:url value='/user/request-blood'/>">+ Request Blood</a>
                        <a class="btn btn-secondary btn-sm" href="<c:url value='/user/my-requests'/>">My Requests</a>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 1rem;">
                    <div class="card" style="display: flex; align-items: center; justify-content: space-between; gap: 1rem; border-left: 4px solid #dc2626; padding: 1rem 1.25rem;">
                        <div>
                            <strong style="color: #1c1917; display: block; font-size: 0.9375rem;">User Portal</strong>
                            <span style="font-size: 0.8125rem; color: #78716c;">Donate blood or request blood units</span>
                        </div>
                        <div style="display: flex; gap: 0.5rem;">
                            <a class="btn btn-primary btn-sm" href="<c:url value='/login'/>">Login</a>
                            <a class="btn btn-secondary btn-sm" href="<c:url value='/register'/>">Sign Up</a>
                        </div>
                    </div>
                    <div class="card" style="display: flex; align-items: center; justify-content: space-between; gap: 1rem; border-left: 4px solid #44403c; padding: 1rem 1.25rem;">
                        <div>
                            <strong style="color: #1c1917; display: block; font-size: 0.9375rem;">Admin Portal</strong>
                            <span style="font-size: 0.8125rem; color: #78716c;">Manage requests and blood bank</span>
                        </div>
                        <a class="btn btn-secondary btn-sm" href="<c:url value='/admin/login'/>">Admin Login &rarr;</a>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </section>

    <section class="stats" aria-label="Donor numbers">
        <div class="stat-card">
            <span class="stat-value">${stats.totalDonors}</span>
            <span class="stat-label">Registered donors</span>
        </div>
        <div class="stat-card">
            <span class="stat-value">${stats.availableDonors}</span>
            <span class="stat-label">Available to donate</span>
        </div>
        <div class="stat-card stat-card-highlight">
            <span class="stat-value">${stats.readyDonors}</span>
            <span class="stat-label">Can donate today</span>
        </div>
    </section>

    <section class="section">
        <div class="section-header">
            <h2 class="section-title">Donors by blood group</h2>
            <a class="section-link" href="<c:url value='/donors'/>">View all</a>
        </div>
        <div class="group-grid">
            <c:forEach items="${bloodGroups}" var="group">
                <c:url var="groupUrl" value="/donors">
                    <c:param name="bloodGroup" value="${group}"/>
                </c:url>
                <c:set var="count" value="${stats.donorsPerBloodGroup[group]}"/>
                <a class="group-tile" href="${groupUrl}">
                    <span class="group-tile-label">${group.label}</span>
                    <span class="group-tile-count">${count} ${count == 1 ? 'donor' : 'donors'}</span>
                </a>
            </c:forEach>
        </div>
    </section>

    <section class="section">
        <div class="section-header">
            <h2 class="section-title">Recently registered</h2>
        </div>
        <c:choose>
            <c:when test="${empty recentDonors}">
                <div class="empty-state">
                    <p class="empty-state-title">No donors yet</p>
                    <p class="empty-state-text">Register the first donor to get started.</p>
                    <div class="empty-state-actions">
                        <a class="btn btn-primary" href="<c:url value='/donors/new'/>">Register a donor</a>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <ul class="donor-list">
                    <c:forEach items="${recentDonors}" var="donor">
                        <li>
                            <a class="donor-list-item" href="<c:url value='/donors/${donor.id}'/>">
                                <ui:blood-group-badge group="${donor.bloodGroup}"/>
                                <span class="donor-list-text">
                                    <span class="donor-list-name"><c:out value="${donor.fullName}"/></span>
                                    <span class="donor-list-meta"><c:out value="${donor.city}"/></span>
                                </span>
                                <ui:availability-badge donor="${donor}"/>
                            </a>
                        </li>
                    </c:forEach>
                </ul>
            </c:otherwise>
        </c:choose>
    </section>

</ui:page>
