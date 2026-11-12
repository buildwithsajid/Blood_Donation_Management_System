<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" tagdir="/WEB-INF/tags" %>

<ui:page title="User Login" activeNav="login">
<div class="form-page" style="max-width: 28rem;">

    <a class="back-link" href="<c:url value='/'/>">&larr; Back to Home</a>

    <div class="card">
        <header class="form-header" style="text-align: center; margin-bottom: 1.5rem;">
            <div style="display: inline-flex; align-items: center; justify-content: center; width: 3rem; height: 3rem; border-radius: 9999px; background-color: #fee2e2; color: #dc2626; margin-bottom: 0.75rem;">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"></path>
                    <circle cx="12" cy="7" r="4"></circle>
                </svg>
            </div>
            <h1 class="page-title">User Login</h1>
            <p class="page-subtitle">Log in to send blood donation or requirement requests</p>
        </header>

        <c:if test="${not empty errorMessage}">
            <p class="alert alert-danger" style="margin-bottom: 1.25rem; color: #b91c1c; background-color: #fef2f2; border-color: #fecaca;"><c:out value="${errorMessage}"/></p>
        </c:if>

        <form:form modelAttribute="loginForm" action="${pageContext.request.contextPath}/login" method="post" cssClass="form">
            <c:if test="${not empty redirectUrl}">
                <input type="hidden" name="redirectUrl" value="<c:out value='${redirectUrl}'/>">
            </c:if>

            <form:errors path="" cssClass="alert alert-danger" element="p" style="margin-bottom: 1rem; color: #b91c1c; background-color: #fef2f2; border-color: #fecaca;"/>

            <div class="field">
                <form:label path="usernameOrEmail" cssClass="label">Username or Email <span class="required">*</span></form:label>
                <form:input path="usernameOrEmail" cssClass="input" cssErrorClass="input input-error"
                            autocomplete="username" placeholder="e.g. aditi or aditi@example.com" required="required"/>
                <form:errors path="usernameOrEmail" cssClass="field-error" element="p"/>
            </div>

            <div class="field">
                <form:label path="password" cssClass="label">Password <span class="required">*</span></form:label>
                <form:input path="password" type="password" cssClass="input" cssErrorClass="input input-error"
                            autocomplete="current-password" placeholder="Enter your password" required="required"/>
                <form:errors path="password" cssClass="field-error" element="p"/>
            </div>

            <div style="margin-top: 0.5rem;">
                <button class="btn btn-primary btn-block" type="submit">Log in to User Portal</button>
            </div>
        </form:form>

        <div style="margin-top: 1.5rem; padding-top: 1.25rem; border-top: 1px solid #e7e5e4; text-align: center; font-size: 0.875rem;">
            <p style="color: #57534e; margin-bottom: 0.75rem;">
                New to the platform? <a href="<c:url value='/register'/>" style="font-weight: 600; color: #dc2626;">Create an account</a>
            </p>
            <p style="color: #78716c; font-size: 0.8125rem;">
                Are you an administrator? <a href="<c:url value='/admin/login'/>" style="font-weight: 600; color: #44403c;">Admin Login &rarr;</a>
            </p>
        </div>

        <div style="margin-top: 1rem; background-color: #fafaf9; border: 1px dashed #d6d3d1; border-radius: 0.5rem; padding: 0.75rem; font-size: 0.75rem; color: #78716c;">
            <strong>Demo User Account:</strong><br>
            Username: <code>user</code> &middot; Password: <code>user123</code>
        </div>
    </div>

</div>
</ui:page>
