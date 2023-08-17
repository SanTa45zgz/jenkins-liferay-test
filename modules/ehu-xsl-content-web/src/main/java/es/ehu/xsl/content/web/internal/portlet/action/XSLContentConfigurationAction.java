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

package es.ehu.xsl.content.web.internal.portlet.action;

import java.util.Map;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.PortletConfig;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.osgi.service.component.annotations.Activate;
import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Modified;
import org.osgi.service.component.annotations.Reference;

import com.liferay.portal.configuration.metatype.bnd.util.ConfigurableUtil;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.portlet.ConfigurationAction;
import com.liferay.portal.kernel.portlet.DefaultConfigurationAction;
import com.liferay.portal.kernel.servlet.SessionErrors;
import com.liferay.portal.kernel.theme.ThemeDisplay;
import com.liferay.portal.kernel.util.StringUtil;
import com.liferay.portal.kernel.util.Validator;
import com.liferay.portal.kernel.util.WebKeys;

import es.ehu.xsl.content.web.configuration.XSLContentConfiguration;
import es.ehu.xsl.content.web.internal.constants.XSLContentPortletKeys;
import es.ehu.xsl.content.web.internal.util.XSLContentUtil;

/**
 * @author UPV/EHU
 */
@Component(
	configurationPid = "es.ehu.xsl.content.web.configuration.XSLContentConfiguration",
	immediate = true,
	property = {
		"javax.portlet.name=" + XSLContentPortletKeys.XSL_CONTENT,
		"valid.url.prefixes=@portlet_context_url@"
	},
	service = ConfigurationAction.class
)
public class XSLContentConfigurationAction extends DefaultConfigurationAction {
	
	


	@Override
	public String getJspPath(HttpServletRequest httpServletRequest) {
		return "/configuration.jsp";
	}

	@Override
	public void include(PortletConfig portletConfig, HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse) throws Exception {

		httpServletRequest.setAttribute(XSLContentConfiguration.class.getName(), _xslContentConfiguration);

		super.include(portletConfig, httpServletRequest, httpServletResponse);
	}

	@Override
	public void processAction(PortletConfig portletConfig, ActionRequest actionRequest, ActionResponse actionResponse) throws Exception {

		validateUrls(actionRequest);
		
		/* upv-ehu - */
		// Codigo de aplicacion integrada 
		String applicationId = getParameter(actionRequest, "application-id");
		super.setPreference(actionRequest, "application-id", applicationId);
		
		// Parametros de configuracion asociados a la aplicacion integrada
		String[] configParams = StringUtil.split(getParameter(actionRequest, "configParams"));
		super.setPreference(actionRequest, "configParams", configParams);
		/* upv-ehu - upv-ehu */

		super.processAction(portletConfig, actionRequest, actionResponse);
	}

	@Override
	@Reference(
		target = "(osgi.web.symbolicname=es.ehu.xsl.content.web)",
		unbind = "-"
	)
	public void setServletContext(ServletContext servletContext) {
		super.setServletContext(servletContext);
	}

	@Activate
	@Modified
	protected void activate(Map<String, Object> properties) {
		_xslContentConfiguration = ConfigurableUtil.createConfigurable(XSLContentConfiguration.class, properties);
	}

	protected String[] getValidUrlPrefixes(ThemeDisplay themeDisplay, String contextPath) {
		String validUrlPrefixes = XSLContentUtil.replaceUrlTokens(themeDisplay, contextPath, _xslContentConfiguration.validUrlPrefixes());
		_log.error(validUrlPrefixes);
		return StringUtil.split(validUrlPrefixes);
	}

	/**
	 * 
	 * @param validUrlPrefixes
	 * @param url
	 * @return
	 */
	protected boolean hasValidUrlPrefix(String[] validUrlPrefixes, String url) {
		if (validUrlPrefixes.length == 0) {
			return true;
		}

		for (String validUrlPrefix : validUrlPrefixes) {
			if (StringUtil.startsWith(url, validUrlPrefix)) {
				return true;
			}
		}

		return false;
	}

	/**
	 * 
	 * @param actionRequest
	 */
	protected void validateUrls(ActionRequest actionRequest) {
		ThemeDisplay themeDisplay = (ThemeDisplay)actionRequest.getAttribute(WebKeys.THEME_DISPLAY);

		String[] validUrlPrefixes = getValidUrlPrefixes(
			themeDisplay, actionRequest.getContextPath());

		String xmlUrl = getParameter(actionRequest, "xmlUrl");
		
		if (!Validator.isBlank(xmlUrl)) {
			xmlUrl = XSLContentUtil.replaceUrlTokens(
				themeDisplay, actionRequest.getContextPath(), xmlUrl);
	
			if (!hasValidUrlPrefix(validUrlPrefixes, xmlUrl)) {
				SessionErrors.add(actionRequest, "xmlUrl");
			}
		}
		
		
		String xslUrl = getParameter(actionRequest, "xslUrl");

		if (!Validator.isBlank(xslUrl)) {
			xslUrl = XSLContentUtil.replaceUrlTokens(
				themeDisplay, actionRequest.getContextPath(), xslUrl);
	
			if (!hasValidUrlPrefix(validUrlPrefixes, xslUrl)) {
				SessionErrors.add(actionRequest, "xslUrl");
			}
		}
	}

	private volatile XSLContentConfiguration _xslContentConfiguration;
	
	private static final Log _log = LogFactoryUtil.getLog(XSLContentConfigurationAction.class);

}