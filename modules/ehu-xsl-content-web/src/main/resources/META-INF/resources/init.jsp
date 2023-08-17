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

<%@ taglib uri="http://liferay.com/tld/aui" prefix="aui" %><%@
taglib uri="http://liferay.com/tld/frontend" prefix="liferay-frontend" %><%@
taglib uri="http://liferay.com/tld/portlet" prefix="liferay-portlet" %><%@
taglib uri="http://liferay.com/tld/theme" prefix="liferay-theme" %><%@
taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>

<%@ page import="com.liferay.portal.kernel.log.Log" %><%@
page import="com.liferay.portal.kernel.log.LogFactoryUtil" %><%@
page import="com.liferay.portal.kernel.util.Constants" %><%@
page import="com.liferay.portal.kernel.util.Validator" %><%@
page import="es.ehu.xsl.content.web.configuration.XSLContentConfiguration" %><%@
page import="es.ehu.xsl.content.web.configuration.XSLContentPortletInstanceConfiguration" %><%@
page import="es.ehu.xsl.content.web.internal.display.context.XSLContentDisplayContext" %>

<liferay-theme:defineObjects />

<%
XSLContentConfiguration xslContentConfiguration = (XSLContentConfiguration)request.getAttribute(XSLContentConfiguration.class.getName());

XSLContentDisplayContext xslContentDisplayContext = new XSLContentDisplayContext(request, xslContentConfiguration);

XSLContentPortletInstanceConfiguration xslContentPortletInstanceConfiguration = xslContentDisplayContext.getXSLContentPortletInstanceConfiguration();
%>

<%@ include file="/init-ext.jsp" %>