<%--
/**
 * Copyright (c) 2000-present Liferay, Inc. All rights reserved.
 *
 * The contents of this file are subject to the terms of the Liferay Enterprise
 * Subscription License ("License"). You may not use this file except in
 * compliance with the License. You can obtain a copy of the License by
 * contacting Liferay, Inc. See the License for the specific language governing
 * permissions and limitations under the License, including but not limited to
 * distribution rights of the Software.
 *
 *
 *
 */
--%>

<%@ include file="/init.jsp" %>

<%-- Begin Gestion estructuras y plantillas por roles especificos --%>
<%@page import="com.liferay.portal.kernel.service.UserGroupRoleLocalServiceUtil"%>
<%-- End Gestion estructuras y plantillas por roles especificos --%>

<%
/* Begin Gestion estructuras y plantillas por roles especificos */
//EHU: Roles para mostrar u ocultar las pestainas de gestion de estructuras y plantillas
final String ROLE_EHU_ADMIN_ST_TMPL = "ehu-structures-templates-administrator";
/* End Gestion estructuras y plantillas por roles especificos */

JournalManagementToolbarDisplayContext journalManagementToolbarDisplayContext = null;

if (!journalDisplayContext.isSearch() || journalDisplayContext.isWebContentTabSelected()) {
	journalManagementToolbarDisplayContext = new JournalManagementToolbarDisplayContext(request, liferayPortletRequest, liferayPortletResponse, journalDisplayContext, trashHelper);
}
else if (journalDisplayContext.isVersionsTabSelected()) {
	journalManagementToolbarDisplayContext = new JournalArticleVersionsManagementToolbarDisplayContext(request, liferayPortletRequest, liferayPortletResponse, journalDisplayContext, trashHelper);
}
else if (journalDisplayContext.isCommentsTabSelected()) {
	journalManagementToolbarDisplayContext = new JournalArticleCommentsManagementToolbarDisplayContext(request, liferayPortletRequest, liferayPortletResponse, journalDisplayContext, trashHelper);
}
else {
	journalManagementToolbarDisplayContext = new JournalManagementToolbarDisplayContext(request, liferayPortletRequest, liferayPortletResponse, journalDisplayContext, trashHelper);
}
%>

<liferay-ui:success key='<%= portletDisplay.getId() + "requestProcessed" %>' message="your-request-completed-successfully" />

<portlet:actionURL name="/journal/restore_trash_entries" var="restoreTrashEntriesURL" />

<liferay-trash:undo
	portletURL="<%= restoreTrashEntriesURL %>"
/>



<%-- Begin Modificado para poder gestionar estructuras y plantillas por roles especificos --%>
<%
	List<com.liferay.frontend.taglib.clay.servlet.taglib.util.NavigationItem> navigationBarItems = journalDisplayContext.getNavigationItems("web-content");
	if( !permissionChecker.isOmniadmin() ) {
		if( UserGroupRoleLocalServiceUtil.hasUserGroupRole( user.getUserId(), themeDisplay.getScopeGroupId(), ROLE_EHU_ADMIN_ST_TMPL, true ) )
			navigationBarItems = ListUtil.subList(navigationBarItems, 0, 3);
		else
			navigationBarItems = ListUtil.subList(navigationBarItems, 0, 1);
	}
%>
<%-- 
<clay:navigation-bar
	inverted="<%= true %>"
	navigationItems='<%= journalDisplayContext.getNavigationItems("web-content") %>'
/>--%>

<clay:navigation-bar
	inverted="<%= true %>"
	navigationItems='<%= navigationBarItems %>'
/>
<%-- End Modificado para poder gestionar estructuras y plantillas por roles especificos --%>

<clay:management-toolbar
	managementToolbarDisplayContext="<%= journalManagementToolbarDisplayContext %>"
	propsTransformer="js/ManagementToolbarPropsTransformer"
/>

<div class="closed sidenav-container sidenav-right" id="<portlet:namespace />infoPanelId">
	<c:if test="<%= journalDisplayContext.isShowInfoButton() %>">
		<liferay-portlet:resourceURL copyCurrentRenderParameters="<%= false %>" id="/journal/info_panel" var="sidebarPanelURL">
			<portlet:param name="folderId" value="<%= String.valueOf(journalDisplayContext.getFolderId()) %>" />
		</liferay-portlet:resourceURL>

		<liferay-frontend:sidebar-panel
			resourceURL="<%= sidebarPanelURL %>"
			searchContainerId="articles"
		>
			<liferay-util:include page="/info_panel.jsp" servletContext="<%= application %>" />
		</liferay-frontend:sidebar-panel>
	</c:if>

	<clay:container-fluid
		cssClass="container-view sidenav-content"
	>
		<c:if test="<%= !journalDisplayContext.isNavigationMine() && !journalDisplayContext.isNavigationRecent() %>">
			<liferay-site-navigation:breadcrumb
				breadcrumbEntries="<%= JournalPortletUtil.getPortletBreadcrumbEntries(journalDisplayContext.getFolder(), request, journalDisplayContext.getPortletURL()) %>"
			/>
		</c:if>

		<aui:form action="<%= journalDisplayContext.getPortletURL() %>" method="get" name="fm">
			<aui:input name="<%= ActionRequest.ACTION_NAME %>" type="hidden" />
			<aui:input name="redirect" type="hidden" value="<%= currentURL %>" />
			<aui:input name="groupId" type="hidden" value="<%= scopeGroupId %>" />
			<aui:input name="newFolderId" type="hidden" />

			<c:choose>
				<c:when test="<%= !journalDisplayContext.isSearch() %>">
					<liferay-util:include page="/view_entries.jsp" servletContext="<%= application %>" />
				</c:when>
				<c:otherwise>

					<%
					String[] tabsNames = new String[0];
					String[] tabsValues = new String[0];

					if (journalDisplayContext.hasResults()) {
						String tabName = StringUtil.appendParentheticalSuffix(LanguageUtil.get(request, "web-content"), journalDisplayContext.getTotalItems());

						tabsNames = ArrayUtil.append(tabsNames, tabName);

						tabsValues = ArrayUtil.append(tabsValues, "web-content");
					}

					if (journalDisplayContext.hasVersionsResults()) {
						String tabName = StringUtil.appendParentheticalSuffix(LanguageUtil.get(request, "versions"), journalDisplayContext.getVersionsTotal());

						tabsNames = ArrayUtil.append(tabsNames, tabName);

						tabsValues = ArrayUtil.append(tabsValues, "versions");
					}

					if (journalDisplayContext.hasCommentsResults()) {
						String tabName = StringUtil.appendParentheticalSuffix(LanguageUtil.get(request, "comments"), journalDisplayContext.getCommentsTotal());

						tabsNames = ArrayUtil.append(tabsNames, tabName);

						tabsValues = ArrayUtil.append(tabsValues, "comments");
					}
					%>

					<liferay-ui:tabs
						names="<%= StringUtil.merge(tabsNames) %>"
						portletURL="<%= journalDisplayContext.getPortletURL() %>"
						tabsValues="<%= StringUtil.merge(tabsValues) %>"
					/>

					<c:choose>
						<c:when test="<%= journalDisplayContext.isWebContentTabSelected() %>">
							<liferay-util:include page="/view_entries.jsp" servletContext="<%= application %>" />
						</c:when>
						<c:when test="<%= journalDisplayContext.isVersionsTabSelected() %>">
							<liferay-util:include page="/view_versions.jsp" servletContext="<%= application %>" />
						</c:when>
						<c:when test="<%= journalDisplayContext.isCommentsTabSelected() %>">
							<liferay-util:include page="/view_comments.jsp" servletContext="<%= application %>" />
						</c:when>
						<c:otherwise>
							<liferay-util:include page="/view_entries.jsp" servletContext="<%= application %>" />
						</c:otherwise>
					</c:choose>
				</c:otherwise>
			</c:choose>
		</aui:form>
	</clay:container-fluid>
</div>

<%@ include file="/friendly_url_changed_message.jspf" %>