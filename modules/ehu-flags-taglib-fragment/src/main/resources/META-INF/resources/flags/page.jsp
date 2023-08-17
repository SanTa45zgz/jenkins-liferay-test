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
 * UPV/EHU:  Se utiliza un mensaje y un enlace personalizado para denunciar una entrada de blog 
 */
--%>

<%@ include file="/flags/init.jsp" %>

<%
String elementClasses = (String)request.getAttribute("liferay-flags:flags:elementClasses");
%>

<%-- Inicio UPV/EHU --%>

<%@ page import="com.liferay.portal.util.PropsUtil" %>
<%@ page import="com.liferay.portal.kernel.util.Validator" %>
<%
Map<String, Object> data = (Map<String, Object>)request.getAttribute("liferay-flags:flags:data");
Map<String, Object> dataProps = (Map<String, Object>)data.get("props");
String pathTermsOfUseOriginal = GetterUtil.getString(dataProps.get("pathTermsOfUse"));

String termsOfUse = "ehu.terms.of.use.page.flag-inappropiate";
String pathTermsOfUse = PropsUtil.get(termsOfUse);
if (Validator.isNull(pathTermsOfUse) || Validator.equals("", pathTermsOfUse)){
	pathTermsOfUse = pathTermsOfUseOriginal;
}

dataProps.put("pathTermsOfUse", pathTermsOfUse);
%>
<%-- Fin UPV/EHU --%>

<div class="d-inline-block taglib-flags <%= Validator.isNotNull(elementClasses) ? elementClasses : "" %>" id="<%= StringUtil.randomId() %>_id">
	<c:choose>
		<c:when test='<%= GetterUtil.getBoolean(request.getAttribute("liferay-flags:flags:onlyIcon")) %>'>
			<clay:button
				borderless="<%= true %>"
				cssClass="lfr-portal-tooltip"
				disabled="<%= true %>"
				displayType="secondary"
				icon="flag-empty"
				small="<%= true %>"
				title='<%= (String)request.getAttribute("liferay-flags:flags:message") %>'
			/>
		</c:when>
		<c:otherwise>
			<clay:button
				borderless="<%= true %>"
				disabled="<%= true %>"
				displayType="secondary"
				icon="flag-empty"
				label="message"
				small="<%= true %>"
			/>
		</c:otherwise>
	</c:choose>

	<react:component
		module="flags/js/index.es"
		props='<%= (Map<String, Object>)request.getAttribute("liferay-flags:flags:data") %>'
	/>
</div>