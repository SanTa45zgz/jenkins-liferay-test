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
 * Mantis 2462
 *	- Referenciar los XSL localmente sin salir a los servidores web.
 *  - Si no hay ninguna aplicacion seleccionada, SOLO se muestra el mensaje de configuracion inicial al usuario con permisos
 */
--%>

<%@page import="com.liferay.portal.kernel.util.GetterUtil"%>
<%@ taglib uri="http://java.sun.com/portlet" prefix="portlet" %>

<%@page import="com.liferay.petra.string.StringPool"%>
<%@page import="com.liferay.portal.kernel.util.WebKeys"%>
<%@page import="com.liferay.portal.kernel.util.HtmlUtil"%>
<%@page import="com.liferay.portal.kernel.util.StringUtil"%>
<%@page import="com.liferay.portal.kernel.util.Validator"%>
<%@page import="com.liferay.portal.kernel.util.PortalUtil"%>
<%@page import="com.liferay.portal.kernel.util.PropsUtil"%>
<%@page import="com.liferay.portal.kernel.log.LogFactoryUtil"%>
<%@page import="com.liferay.portal.kernel.log.Log"%>

<%@ page import="java.util.regex.Pattern" %>

<%
// Entorno de ejecucion UPV/EHU
String host = PropsUtil.get("ehu.host");


String protocol = "https";
String execUrl = protocol + "://" + PropsUtil.get(host + ".url");

		 
// Url externa
String extUrl = StringPool.BLANK;

// Urls de las distintas fuentes de datos (gaur,app...)
String gaurUrl = protocol + "://" + PropsUtil.get("gaur." + host + ".url");
String appUrl = protocol + "://" + PropsUtil.get("app." + host + ".url");



String applicationId = xslContentPortletInstanceConfiguration.applicationId();

//fvcalderon001:Mientras se migran los ws a lo nuevo
if (applicationId.equals("plew0040-offer")){
	gaurUrl = protocol + "://" + PropsUtil.get("gaur.new." + host + ".url");
}
//fvcalderon001:Mientras se migran los ws a lo nuevo	
	
String[] configParamsPref = xslContentPortletInstanceConfiguration.configParams();
if (configParamsPref==null) configParamsPref = new String[0];
	
String configParamsPrefStr = StringUtil.merge(configParamsPref);
String configParamPref = StringPool.BLANK;

// Idioma de navegacion
String paramLanguage = themeDisplay.getLocale().toString().substring(0,2); 

%>


