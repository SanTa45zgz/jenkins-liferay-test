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
--%>

<%--
/**
 * UPV/EHU
 *
 * Se restaura la posibilidad de acceder a la pestaña Ambito para todo el mundo 
 * Solo OMNIADMIN puede acceder en modo configuracion a las pestañas Permisos, Comunicacion, Compartir y Ambito 
 *
 */
--%>

<%@ include file="/init.jsp" %>

<%
String tabs1 = ParamUtil.getString(request, "tabs1");

String redirect = ParamUtil.getString(request, "redirect");
String returnToFullPageURL = ParamUtil.getString(request, "returnToFullPageURL");

PortalUtil.addPortletBreadcrumbEntry(request, PortalUtil.getPortletTitle(renderResponse), null);
PortalUtil.addPortletBreadcrumbEntry(request, LanguageUtil.get(request, "configuration"), null);
PortalUtil.addPortletBreadcrumbEntry(request, LanguageUtil.get(request, tabs1), currentURL);
//Begin UPV/EHU
boolean isadmin = permissionChecker.isOmniadmin();
//End UPV/EHU
%>

<clay:navigation-bar
	navigationItems='<%=
		new JSPNavigationItemList(pageContext) {
			{
				if (selPortlet.getConfigurationActionInstance() != null) {
					add(
						navigationItem -> {
							navigationItem.setActive(tabs1.equals("setup"));
							navigationItem.setHref(renderResponse.createRenderURL(), "mvcPath", "/edit_configuration.jsp", "redirect", redirect, "returnToFullPageURL", returnToFullPageURL, "portletConfiguration", Boolean.TRUE.toString(), "portletResource", portletResource);
							navigationItem.setLabel(LanguageUtil.get(httpServletRequest, "setup"));
						});
				}

				// Begin UPV/EHU
				if (isadmin) {
				// End UPV/EHU
				if (selPortlet.hasMultipleMimeTypes()) {
					add(
						navigationItem -> {
							navigationItem.setActive(tabs1.equals("supported-clients"));
							navigationItem.setHref(renderResponse.createRenderURL(), "mvcPath", "/edit_supported_clients.jsp", "redirect", redirect, "returnToFullPageURL", returnToFullPageURL, "portletConfiguration", Boolean.TRUE.toString(), "portletResource", portletResource);
							navigationItem.setLabel(LanguageUtil.get(httpServletRequest, "supported-clients"));
						});
				}

				Set<PublicRenderParameter> publicRenderParameters = selPortlet.getPublicRenderParameters();

				if (!publicRenderParameters.isEmpty()) {
					add(
						navigationItem -> {
							navigationItem.setActive(tabs1.equals("communication"));
							navigationItem.setHref(renderResponse.createRenderURL(), "mvcPath", "/edit_public_render_parameters.jsp", "redirect", redirect, "returnToFullPageURL", returnToFullPageURL, "portletConfiguration", Boolean.TRUE.toString(), "portletResource", portletResource);
							navigationItem.setLabel(LanguageUtil.get(httpServletRequest, "communication"));
						});
				}

				add(
					navigationItem -> {
						navigationItem.setActive(tabs1.equals("sharing"));
						navigationItem.setHref(renderResponse.createRenderURL(), "mvcPath", "/edit_sharing.jsp", "redirect", redirect, "returnToFullPageURL", returnToFullPageURL, "portletConfiguration", Boolean.TRUE.toString(), "portletResource", portletResource);
						navigationItem.setLabel(LanguageUtil.get(httpServletRequest, "sharing"));
					});
				// Begin UPV/EHU
				}
				// End UPV/EHU
				if (selPortlet.isScopeable()) {
					add(
						navigationItem -> {
							navigationItem.setActive(tabs1.equals("scope"));
							navigationItem.setHref(renderResponse.createRenderURL(), "mvcPath", "/edit_scope.jsp", "redirect", redirect, "returnToFullPageURL", returnToFullPageURL, "portletConfiguration", Boolean.TRUE.toString(), "portletResource", portletResource);
							navigationItem.setLabel(LanguageUtil.get(httpServletRequest, "scope"));
						});
				}
			}
		}
	%>'
/>