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
<%-- UPV
 /**
 * Ocultar Colecciones
 */
 --%>
<%@ include file="/init.jsp" %>

<%
String portletResource = ParamUtil.getString(request, "portletResource");
%>
<%-- UPV --%>
<!-- 
<div class="mb-2">
	<aui:a cssClass="create-collection-link" href="javascript:void(0);">
		<liferay-ui:message key="create-a-collection-from-this-configuration" />
	</aui:a>
</div> -->
<%-- UPV --%>

<aui:script require="frontend-js-web/index as frontendJsWeb">
	var {delegate, openSimpleInputModal} = frontendJsWeb;

	function handleCreateAssetListLinkClick(event) {
		event.preventDefault();

		openSimpleInputModal({
			dialogTitle: '<liferay-ui:message key="collection-title" />',
			formSubmitURL:
				'<liferay-portlet:actionURL name="/asset_publisher/add_asset_list" portletName="<%= portletResource %>"><portlet:param name="portletResource" value="<%= portletResource %>" /><portlet:param name="redirect" value="<%= currentURL %>" /></liferay-portlet:actionURL>',
			mainFieldLabel: '<liferay-ui:message key="title" />',
			mainFieldName: 'title',
			mainFieldPlaceholder: '<liferay-ui:message key="title" />',
			namespace:
				'<%= PortalUtil.getPortletNamespace(HtmlUtil.escape(portletResource)) %>',
			spritemap: '<%= themeDisplay.getPathThemeSpritemap() %>',
		});
	}

	var createAssetListLinkClickHandler = delegate(
		document.body,
		'click',
		'a.create-collection-link',
		handleCreateAssetListLinkClick
	);

	function handleDestroyPortlet() {
		createAssetListLinkClickHandler.dispose();

		Liferay.detach('destroyPortlet', handleDestroyPortlet);
	}

	Liferay.on('destroyPortlet', handleDestroyPortlet);
</aui:script>