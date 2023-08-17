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

<%--
/**
 * UPV/EHU
 *
 *	- Se limita la posibilidad de modificar (boton Seleccionar) el theme a los roles Administrator y Theme Administrator
 *	- Solo OMNIADMIN tiene posibilidad de incluir estilos en las paginas o grupos de páginas
 *
 */
--%>

<%@ include file="/init.jsp" %>

<%-- Begin UPV/EHU --%>
<%@ page import="com.liferay.portal.kernel.service.RoleLocalServiceUtil" %>
<%@ page import="com.liferay.portal.kernel.log.LogFactoryUtil" %>
<%@ page import="com.liferay.portal.kernel.log.Log" %>
<%-- End UPV/EHU --%>

<%! private static Log _log = LogFactoryUtil.getLog("look_and_feel_themes_edit.jsp"); %>


<%
/* Begin UPV/EHU */
String ROLE_THEME_ADMINISTRATOR = "Theme Administrator";
long userId = PortalUtil.getUserId( request );
Boolean permChgThemeConcretSettings = false;
if( permissionChecker.isOmniadmin() ) {
	permChgThemeConcretSettings = true;
}else if( RoleLocalServiceUtil.hasUserRole( userId, themeDisplay.getCompanyId(), ROLE_THEME_ADMINISTRATOR, true) ) {
	permChgThemeConcretSettings = true;
}

_log.error("look_and_feel_themes_edit permChgThemeConcretSettings:" + permChgThemeConcretSettings);
_log.error("look_and_feel_themes_edit permissionChecker.isOmniadmin() :" + permissionChecker.isOmniadmin() );
/* End UPV/EHU */

Layout selLayout = layoutsAdminDisplayContext.getSelLayout();
LayoutSet selLayoutSet = layoutsAdminDisplayContext.getSelLayoutSet();

Theme selTheme = null;

if (selLayout != null) {
	selTheme = selLayout.getTheme();
}
else {
	selTheme = selLayoutSet.getTheme();
}
%>

<p class="h4 mb-3 mt-3"><liferay-ui:message key="current-theme" /></p>

<div id="<portlet:namespace />currentThemeContainer">
	<liferay-util:include page="/look_and_feel_theme_details.jsp" servletContext="<%= application %>" />
</div>

<%-- Begin UPV/EHU --%>
<c:if test="<%=permissionChecker.isOmniadmin()%>">
<%-- End UPV/EHU --%>
<aui:input label="insert-custom-css-that-is-loaded-after-the-theme" name="regularCss" placeholder="css" type="textarea" value="<%= (selLayout != null) ? selLayout.getCssText() : selLayoutSet.getCss() %>" />
<%-- Begin UPV/EHU --%>
</c:if>
<%-- End UPV/EHU --%>

<%-- Begin UPV/EHU --%>
<c:if test="<%= permChgThemeConcretSettings %>">
<%-- End UPV/EHU --%>
<aui:button id="changeTheme" value="change-current-theme" />
<%-- Begin UPV/EHU --%>
</c:if>
<%-- End UPV/EHU --%>

<portlet:renderURL var="selectThemeURL" windowState="<%= LiferayWindowState.POP_UP.toString() %>">
	<portlet:param name="mvcPath" value="/select_theme.jsp" />
	<portlet:param name="redirect" value="<%= currentURL %>" />
</portlet:renderURL>

<portlet:renderURL copyCurrentRenderParameters="<%= true %>" var="lookAndFeelDetailURL" windowState="<%= LiferayWindowState.EXCLUSIVE.toString() %>">
	<portlet:param name="mvcPath" value="/look_and_feel_theme_details.jsp" />
</portlet:renderURL>

<%-- Begin UPV/EHU --%>
<c:if test="<%= permChgThemeConcretSettings %>">
<%-- End UPV/EHU --%>
<liferay-frontend:component
	context='<%=
		HashMapBuilder.<String, Object>put(
			"changeThemeButtonId", liferayPortletResponse.getNamespace() + "changeTheme"
		).put(
			"initialSelectedThemeId", selTheme.getThemeId()
		).put(
			"lookAndFeelDetailURL", lookAndFeelDetailURL
		).put(
			"selectThemeURL", selectThemeURL
		).put(
			"themeContainerId", liferayPortletResponse.getNamespace() + "currentThemeContainer"
		).build()
	%>'
	module="js/LookAndFeelThemeEdit"
/>
<%-- Begin UPV/EHU --%>
</c:if>
<%-- End UPV/EHU --%>