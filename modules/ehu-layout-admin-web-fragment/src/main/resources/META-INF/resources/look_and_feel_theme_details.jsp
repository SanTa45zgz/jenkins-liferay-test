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
 * Solo se muestran las gamas de colores (y la opcion de cambiar la seleccion del mismo) a los roles Administrator y Theme Administrator
 *
 */
--%>

<%@ include file="/init.jsp" %>

<%-- Begin UPV/EHU --%>
<%@ page import="com.liferay.portal.kernel.service.RoleLocalServiceUtil" %>
<%@ page import="com.liferay.portal.kernel.log.LogFactoryUtil" %>
<%@ page import="com.liferay.portal.kernel.log.Log" %>
<%-- End UPV/EHU --%>

<%! private static Log _log = LogFactoryUtil.getLog("look_and_feel_theme_details.jsp"); %>


<%

/* Begin UPV/EHU */
String ROLE_THEME_ADMINISTRATOR = "Theme Administrator";
long userId = PortalUtil.getUserId( request );
boolean permChgThemeConcretSettings = false;
if( permissionChecker.isOmniadmin() ){
	permChgThemeConcretSettings = true;
}
else if( RoleLocalServiceUtil.hasUserRole( userId, themeDisplay.getCompanyId(), ROLE_THEME_ADMINISTRATOR, true) ) {
	permChgThemeConcretSettings = true;
}

_log.error("look_and_feel_theme_details permChgThemeConcretSettings:" + permChgThemeConcretSettings);
_log.error("look_and_feel_theme_details permissionChecker.isOmniadmin() :" + permissionChecker.isOmniadmin() );
/* End UPV/EHU */


String themeId = ParamUtil.getString(request, "themeId");

Layout selLayout = layoutsAdminDisplayContext.getSelLayout();
LayoutSet selLayoutSet = layoutsAdminDisplayContext.getSelLayoutSet();

Theme selTheme = null;
ColorScheme selColorScheme = null;

boolean useDefaultThemeSettings = false;

if (Validator.isNotNull(themeId)) {
	selTheme = ThemeLocalServiceUtil.getTheme(company.getCompanyId(), themeId);
	selColorScheme = ThemeLocalServiceUtil.getColorScheme(company.getCompanyId(), themeId, StringPool.BLANK);

	useDefaultThemeSettings = true;
}
else {
	if (selLayout != null) {
		selTheme = selLayout.getTheme();
		selColorScheme = selLayout.getColorScheme();
	}
	else {
		selTheme = selLayoutSet.getTheme();
		selColorScheme = selLayoutSet.getColorScheme();
	}
}

PluginPackage selPluginPackage = selTheme.getPluginPackage();

String styleBookWarningMessage = layoutsAdminDisplayContext.getStyleBookWarningMessage();
%>

<c:if test="<%= Validator.isNotNull(styleBookWarningMessage) %>">
	<clay:alert
		displayType="info"
		message="<%= styleBookWarningMessage %>"
	/>
</c:if>

<aui:input name="regularThemeId" type="hidden" value="<%= selTheme.getThemeId() %>" />
<aui:input name="regularColorSchemeId" type="hidden" value="<%= selColorScheme.getColorSchemeId() %>" />

<clay:row>
	<clay:col
		size="6"
		sm="4"
	>
		<div class="card card-type-asset image-card">
			<div class="aspect-ratio card-item-first card-item-last">
				<img alt="<%= HtmlUtil.escapeAttribute(selTheme.getName()) %>" class="aspect-ratio-item aspect-ratio-item-center-middle aspect-ratio-item-fluid" src="<%= themeDisplay.getCDNBaseURL() %><%= HtmlUtil.escapeAttribute(selTheme.getStaticResourcePath()) %><%= HtmlUtil.escapeAttribute(selTheme.getImagesPath()) %>/thumbnail.png" />
			</div>
		</div>
	</clay:col>

	<clay:col
		size="6"
		sm="8"
	>
		<c:if test="<%= Validator.isNotNull(selTheme.getName()) %>">
			<h2 class="h4"><liferay-ui:message key="name" /></h2>

			<p class="text-default">
				<%= HtmlUtil.escape(selTheme.getName()) %>
			</p>
		</c:if>

		<c:if test="<%= (selPluginPackage != null) && Validator.isNotNull(selPluginPackage.getAuthor()) %>">
			<h2 class="h4"><liferay-ui:message key="author" /></h2>

			<p class="text-default">
				<aui:a href="<%= HtmlUtil.escapeHREF(selPluginPackage.getPageURL()) %>" target="_blank"><%= HtmlUtil.escape(selPluginPackage.getAuthor()) %></aui:a>
			</p>
		</c:if>
	</clay:col>
</clay:row>

<c:if test="<%= (selPluginPackage != null) && Validator.isNotNull(selPluginPackage.getShortDescription()) %>">
	<h4><liferay-ui:message key="description" /></h4>

	<p class="text-default">
		<%= HtmlUtil.escape(selPluginPackage.getShortDescription()) %>
	</p>
</c:if>

<%
List<ColorScheme> colorSchemes = selTheme.getColorSchemes();
%>

<%-- Begin UPV/EHU --%>
<c:if test="<%= permChgThemeConcretSettings %>">
<%-- End UPV/EHU --%>
<c:if test="<%= !colorSchemes.isEmpty() %>">
	<h2 class="h4"><liferay-ui:message key="color-schemes" /></h2>

	<div class="clearfix" id="<portlet:namespace />colorSchemesContainer">
		<clay:row>

			<%
			String selColorSchemeId = selColorScheme.getColorSchemeId();

			for (ColorScheme curColorScheme : colorSchemes) {
			%>

				<clay:col
					md="3"
					size="6"
					sm="4"
				>
					<div class="card card-interactive card-interactive-secondary card-type-asset color-scheme-selector image-card <%= selColorSchemeId.equals(curColorScheme.getColorSchemeId()) ? "selected" : StringPool.BLANK %>" data-color-scheme-id="<%= curColorScheme.getColorSchemeId() %>" tabindex="0">
						<div class="aspect-ratio aspect-ratio-16-to-9">
							<img alt="" class="aspect-ratio-item-flush" src="<%= themeDisplay.getCDNBaseURL() %><%= HtmlUtil.escapeAttribute(selTheme.getStaticResourcePath()) %><%= HtmlUtil.escapeAttribute(curColorScheme.getColorSchemeThumbnailPath()) %>/thumbnail.png" />
						</div>

						<div class="card-body p-2">
							<div class="card-row">
								<div class="card-title text-truncate">
									<%= HtmlUtil.escapeAttribute(curColorScheme.getName()) %>
								</div>
							</div>
						</div>
					</div>
				</clay:col>

			<%
			}
			%>

		</clay:row>
	</div>
</c:if>

<%-- Begin UPV/EHU --%>
</c:if>
<%-- End UPV/EHU --%>

<%
Map<String, ThemeSetting> configurableSettings = selTheme.getConfigurableSettings();
%>

<c:if test="<%= !configurableSettings.isEmpty() %>">
	<h2 class="h4"><liferay-ui:message key="settings" /></h2>

	<%
	ServletContext servletContext = ServletContextPool.get(selTheme.getServletContextName());

	ResourceBundle selThemeResourceBundle = ResourceBundleUtil.getBundle("content.Language", servletContext.getClassLoader());

	ResourceBundle aggregateResourceBundle = new AggregateResourceBundle(resourceBundle, selThemeResourceBundle);

	for (Map.Entry<String, ThemeSetting> entry : configurableSettings.entrySet()) {
		String name = LanguageUtil.get(aggregateResourceBundle, entry.getKey());

		ThemeSetting themeSetting = entry.getValue();

		String type = GetterUtil.getString(themeSetting.getType(), "text");

		String value = StringPool.BLANK;

		if (useDefaultThemeSettings) {
			value = selTheme.getSetting(entry.getKey());
		}
		else {
			if (selLayout != null) {
				value = selLayout.getThemeSetting(entry.getKey(), "regular");
			}
			else {
				value = selLayoutSet.getThemeSetting(entry.getKey(), "regular");
			}
		}

		String propertyName = HtmlUtil.escapeAttribute("regularThemeSettingsProperties--" + entry.getKey() + StringPool.DOUBLE_DASH);
	%>

		<c:choose>
			<c:when test='<%= type.equals("checkbox") %>'>
				<aui:input inlineLabel="right" label="<%= HtmlUtil.escape(name) %>" labelCssClass="simple-toggle-switch" name="<%= propertyName %>" type="toggle-switch" value="<%= value %>" />
			</c:when>
			<c:when test='<%= type.equals("text") || type.equals("textarea") %>'>
				<aui:input label="<%= HtmlUtil.escape(name) %>" name="<%= propertyName %>" type="<%= type %>" value="<%= value %>" />
			</c:when>
			<c:when test='<%= type.equals("select") %>'>
				<aui:select label="<%= HtmlUtil.escape(name) %>" name="<%= propertyName %>">

					<%
					for (String option : themeSetting.getOptions()) {
					%>

						<aui:option label="<%= HtmlUtil.escape(option) %>" selected="<%= option.equals(value) %>" />

					<%
					}
					%>

				</aui:select>
			</c:when>
		</c:choose>

		<c:if test="<%= Validator.isNotNull(themeSetting.getScript()) %>">
			<aui:script position="inline">
				<%= StringUtil.replace(themeSetting.getScript(), "[@NAMESPACE@]", liferayPortletResponse.getNamespace()) %>;
			</aui:script>
		</c:if>

	<%
	}
	%>

</c:if>

<%-- Begin UPV/EHU --%>
<c:if test="<%= permChgThemeConcretSettings %>">
<%-- End UPV/EHU --%>

<c:if test="<%= !colorSchemes.isEmpty() %>">
	<liferay-frontend:component
		context='<%=
			HashMapBuilder.<String, Object>put(
				"buttonCssClass", ".color-scheme-selector"
			).put(
				"containerId", liferayPortletResponse.getNamespace() + "colorSchemesContainer"
			).put(
				"regularColorSchemeInputId", liferayPortletResponse.getNamespace() + "regularColorSchemeId"
			).build()
		%>'
		module="js/LookAndFeelThemeDetails"
	/>
</c:if>

<%-- Begin  UPV/EHU  --%>
</c:if>
<%-- End  UPV/EHU  --%>