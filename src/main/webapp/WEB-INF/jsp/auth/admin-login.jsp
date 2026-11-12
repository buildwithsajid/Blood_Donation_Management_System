<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" tagdir="/WEB-INF/tags" %>

<ui:page title="Admin Login" activeNav="admin-login">
<div class="form-page" style="max-width: 28rem;">

    <a class="back-link" href="<c:url value='/'/>">&larr; Back to Home</a>

    <div class="card">
        <header class="form-header" style="text-align: center; margin-bottom: 1.5rem;">
            <div style="display: inline-flex; align-items: center; justify-content: center; width: 3rem; height: 3rem; border-radius: 9999px; background-color: #f5f5f4; color: #1c1917; margin-bottom: 0.75rem;">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                </svg>
            </div>
            <h1 class="page-title">Administrator Login</h1>
            <p class="page-subtitle">Sign in to manage donors, reviews, and requirement requests</p>
        </header>

        <c:if test="${not empty errorMessage}">
            <p class="alert alert-danger" style="margin-bottom: 1.25rem; color: #b91c1c; background-color: #fef2f2; border-color: #fecaca;"><c:out value="${errorMessage}"/></p>
        </c:if>

        <form:form modelAttribute="loginForm" action="${pageContext.request.contextPath}/admin/login" method="post" cssClass="form">
            <c:if test="${not empty redirectUrl}">
                <input type="hidden" name="redirectUrl" value="<c:out value='${redirectUrl}'/>">
            </c:if>

            <form:errors path="" cssClass="alert alert-danger" element="p" style="margin-bottom: 1rem; color: #b91c1c; background-color: #fef2f2; border-color: #fecaca;"/>

            <div class="field">
                <form:label path="usernameOrEmail" cssClass="label">Admin Username <span class="required">*</span></form:label>
                <form:input path="usernameOrEmail" cssClass="input" cssErrorClass="input input-error"
                            autocomplete="username" placeholder="admin" required="required"/>
                <form:errors path="usernameOrEmail" cssClass="field-error" element="p"/>
            </div>

            <div class="field">
                <form:label path="password" cssClass="label">Password <span class="required">*</span></form:label>
                <form:input path="password" type="password" cssClass="input" cssErrorClass="input input-error"
                            autocomplete="current-password" placeholder="Enter password" required="required"/>
                <form:errors path="password" cssClass="field-error" element="p"/>
            </div>

            <div style="margin-top: 0.5rem;">
                <button class="btn btn-primary btn-block" style="background-color: #1c1917; border-color: #1c1917;" type="submit">Log in to Admin Panel</button>
            </div>
        </form:form>

        <div style="margin-top: 1.5rem; padding-top: 1.25rem; border-top: 1px solid #e7e5e4; text-align: center; font-size: 0.875rem;">
            <p style="color: #78716c;">
                Looking for regular user access? <a href="<c:url value='/login'/>" style="font-weight: 600; color: #dc2626;">User Login &rarr;</a>
            </p>
        </div>

        <div style="margin-top: 1rem; background-color: #fafaf9; border: 1px dashed #d6d3d1; border-radius: 0.5rem; padding: 0.75rem; font-size: 0.75rem; color: #78716c;">
            <strong>Default Administrator Credentials:</strong><br>
            Username: <code>admin</code> &middot; Password: <code>admin123</code>
        </div>
    </div>

</div>
</ui:page>
