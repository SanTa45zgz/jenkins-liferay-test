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
 * Ocultar Colecciones
 */
--%>

<%@ include file="/init.jsp" %>

<aui:fieldset markupView="lexicon">
	<%-- UPV/EHU --%>
	<%--  <aui:input checked="<%= assetPublisherDisplayContext.isSelectionStyleAssetList() %>" id="selectionStyleAssetList" label="collection" name="preferences--selectionStyle--" onChange='<%= liferayPortletResponse.getNamespace() + "chooseSelectionStyle();" %>' type="radio" value="<%= AssetPublisherSelectionStyleConstants.TYPE_ASSET_LIST %>" /> -->
	<%-- UPV/EHU --%>
	<aui:input checked="<%= assetPublisherDisplayContext.isSelectionStyleDynamic() %>" id="selectionStyleDynamic" label="dynamic" name="preferences--selectionStyle--" onChange='<%= liferayPortletResponse.getNamespace() + "chooseSelectionStyle();" %>' type="radio" value="<%= AssetPublisherSelectionStyleConstants.TYPE_DYNAMIC %>" />
	<aui:input checked="<%= assetPublisherDisplayContext.isSelectionStyleManual() %>" id="selectionStyleManual" label="manual" name="preferences--selectionStyle--" onChange='<%= liferayPortletResponse.getNamespace() + "chooseSelectionStyle();" %>' type="radio" value="<%= AssetPublisherSelectionStyleConstants.TYPE_MANUAL %>" />
</aui:fieldset>
<script>
	function <portlet:namespace />chooseSelectionStyle() {
		Liferay.Util.postForm(document.<portlet:namespace />fm, {
			data: {
				cmd: 'selection-style',
			},
		});
	}
</script>