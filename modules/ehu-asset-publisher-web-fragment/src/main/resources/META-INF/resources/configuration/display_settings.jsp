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
 * Excepto para onmiadmin:
 * - NO mostrar el titulo (nombre interno) del contenido
 * - Mostrar enlace al contexto original del contenido (chequeado)
 * - El comportamiento del enlace al contenido, siempre se ve en contexto 
 */
--%>
<%@ include file="/init.jsp" %>

<%
PortletURL configurationRenderURL = (PortletURL)request.getAttribute("configuration.jsp-configurationRenderURL");
%>

<div class="display-template">
	<liferay-template:template-selector
		className="<%= AssetEntry.class.getName() %>"
		defaultDisplayStyle="<%= assetPublisherDisplayContext.getDefaultDisplayStyle() %>"
		displayStyle="<%= assetPublisherDisplayContext.getDisplayStyle() %>"
		displayStyleGroupId="<%= assetPublisherDisplayContext.getDisplayStyleGroupId() %>"
		displayStyles="<%= Arrays.asList(assetPublisherDisplayContext.getDisplayStyles()) %>"
		label="display-template"
		refreshURL="<%= configurationRenderURL.toString() %>"
	/>
</div>

<aui:select cssClass="abstract-length hidden-field" helpMessage="abstract-length-key-help" name="preferences--abstractLength--" value="<%= assetPublisherDisplayContext.getAbstractLength() %>">
	<aui:option label="100" />
	<aui:option label="200" />
	<aui:option label="300" />
	<aui:option label="400" />
	<aui:option label="500" />
</aui:select>
<%-- UPV/EHU--%>
<%	Boolean _showAssetTitle = GetterUtil.getBoolean(portletPreferences.getValue("showAssetTitle", null), true);
	if( permissionChecker.isOmniadmin() ) {  %>
<%-- <aui:input cssClass="hidden-field show-asset-title" inlineLabel="right" labelCssClass="simple-toggle-switch" name="preferences--showAssetTitle--" type="toggle-switch" value="<%= assetPublisherDisplayContext.isShowAssetTitle() %>" /> --%>	
	<aui:input cssClass="hidden-field show-asset-title" inlineLabel="right" labelCssClass="simple-toggle-switch" name="preferences--showAssetTitle--" type="toggle-switch" value="<%= _showAssetTitle %>" />
	
	<aui:input cssClass="hidden-field show-context-link" inlineLabel="right" label="show-new-page-link" labelCssClass="simple-toggle-switch" name="preferences--showContextLink--" type="toggle-switch" value="<%= assetPublisherDisplayContext.isShowContextLink() %>" />
<%} %>
<%-- UPV/EHU--%>
<aui:input cssClass="hidden-field show-extra-info" inlineLabel="right" labelCssClass="simple-toggle-switch" name="preferences--showExtraInfo--" type="toggle-switch" value="<%= assetPublisherDisplayContext.isShowExtraInfo() %>" />

<%-- UPV/EHU--%>
<%	if( permissionChecker.isOmniadmin() ) {  %>
<aui:select cssClass="asset-link-behavior" name="preferences--assetLinkBehavior--">
	<aui:option label="show-full-content" selected="<%= assetPublisherDisplayContext.isAssetLinkBehaviorShowFullContent() %>" value="showFullContent" />
	<aui:option label="view-on-new-page" selected="<%= assetPublisherDisplayContext.isAssetLinkBehaviorViewInPortlet() %>" value="viewInPortlet" />
</aui:select>
<%} %>
<%-- UPV/EHU--%>

<aui:input helpMessage='<%= LanguageUtil.format(request, "number-of-items-to-display-help", new Object[] {SearchContainer.MAX_DELTA}, false) %>' label="number-of-items-to-display" name="preferences--delta--" type="text" value="<%= assetPublisherDisplayContext.getDelta() %>">
	<aui:validator name="digits" />
</aui:input>

<aui:select name="preferences--paginationType--">

	<%
	for (String paginationType : assetPublisherDisplayContext.PAGINATION_TYPES) {
	%>

		<aui:option label="<%= paginationType %>" selected="<%= assetPublisherDisplayContext.isPaginationTypeSelected(paginationType) %>" />

	<%
	}
	%>

</aui:select>

<c:if test="<%= !assetPublisherDisplayContext.isSearchWithIndex() && assetPublisherDisplayContext.isSelectionStyleDynamic() %>">
	<aui:input inlineLabel="right" label="exclude-assets-with-0-views" labelCssClass="simple-toggle-switch" name="preferences--excludeZeroViewCount--" type="toggle-switch" value="<%= assetPublisherDisplayContext.isExcludeZeroViewCount() %>" />
</c:if>

<liferay-frontend:component
	module="js/DisplaySettings"
/>