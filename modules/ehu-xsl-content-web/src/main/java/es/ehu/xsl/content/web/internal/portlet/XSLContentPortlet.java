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

package es.ehu.xsl.content.web.internal.portlet;

import java.io.IOException;
import java.util.Map;

import javax.portlet.Portlet;
import javax.portlet.PortletException;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;

import org.osgi.service.component.annotations.Activate;
import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Modified;
import org.osgi.service.component.annotations.Reference;

import com.liferay.portal.configuration.metatype.bnd.util.ConfigurableUtil;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.model.Release;
import com.liferay.portal.kernel.module.configuration.ConfigurationException;
import com.liferay.portal.kernel.module.configuration.ConfigurationProvider;
import com.liferay.portal.kernel.portlet.bridges.mvc.MVCPortlet;
import com.liferay.portal.kernel.theme.PortletDisplay;
import com.liferay.portal.kernel.theme.ThemeDisplay;
import com.liferay.portal.kernel.util.WebKeys;

import com.liferay.portal.kernel.util.Portal;


import es.ehu.xsl.content.web.configuration.XSLContentConfiguration;
import es.ehu.xsl.content.web.configuration.XSLContentPortletInstanceConfiguration;
import es.ehu.xsl.content.web.internal.constants.XSLContentPortletKeys;

/**
 * @author UPV/EHU
 */
@Component(
	configurationPid = "es.ehu.xsl.content.web.configuration.XSLContentPortletInstanceConfiguration",
	immediate = true,
	property = {
		"com.liferay.portlet.css-class-wrapper=portlet-xsl-content",
		"com.liferay.portlet.display-category=category.cms",
		"com.liferay.portlet.instanceable=true",
		"com.liferay.portlet.layout-cacheable=false",
		"com.liferay.portlet.preferences-owned-by-group=true",
		"com.liferay.portlet.private-request-attributes=false",
		"com.liferay.portlet.private-session-attributes=false",
		"com.liferay.portlet.render-weight=50",
		"com.liferay.portlet.header-portlet-javascript=/js/js.js",
		"javax.portlet.display-name=XSL Content",
		"javax.portlet.expiration-cache=0",
		"javax.portlet.init-param.template-path=/META-INF/resources/",
		"javax.portlet.init-param.view-template=/view.jsp",
		"javax.portlet.name=" + XSLContentPortletKeys.XSL_CONTENT,
		"javax.portlet.resource-bundle=content.Language",
		"javax.portlet.security-role-ref=administrator",
		"javax.portlet.supported-public-render-parameter=tags",
		"xml.doctype.declaration.allowed=false",
		"xml.external.general.entities.allowed=false",
		"xml.external.parameter.entities.allowed=false",
		"xsl.secure.processing.enabled=false"
	},
	service = Portlet.class
)
public class XSLContentPortlet extends MVCPortlet {
	
	@Override
	public void render(RenderRequest renderRequest, RenderResponse renderResponse)
			throws IOException, PortletException {
		
		
		try {
			renderRequest.setAttribute(
					XSLContentConfiguration.class.getName(),
					_configurationProvider.getCompanyConfiguration(XSLContentConfiguration.class,_portal.getCompanyId(renderRequest)));
			
			renderRequest.setAttribute(
					XSLContentPortletInstanceConfiguration.class.getName(),
					_getXSLContentPortletInstanceConfiguration(renderRequest));
		}
		catch (ConfigurationException configurationException) {
			throw new PortletException(configurationException);
		}
		log.error("XSLContentPortlet - render");
		super.render(renderRequest, renderResponse);
		
	}
	
	
	@Override
	public void doView(RenderRequest renderRequest, RenderResponse renderResponse)
			throws IOException, PortletException {

			try {
				renderRequest.setAttribute(
						XSLContentConfiguration.class.getName(),
						_configurationProvider.getCompanyConfiguration(XSLContentConfiguration.class,_portal.getCompanyId(renderRequest)));
				
				renderRequest.setAttribute(
						XSLContentPortletInstanceConfiguration.class.getName(),
						_getXSLContentPortletInstanceConfiguration(renderRequest));
			}
			catch (ConfigurationException configurationException) {
				throw new PortletException(configurationException);
			}
			log.error("XSLContentPortlet - doView");
			super.doView(renderRequest, renderResponse);
		
	}
	
	/**
	 * 
	 * @param renderRequest
	 * @return
	 * @throws PortletException
	 */
	private XSLContentPortletInstanceConfiguration
	_getXSLContentPortletInstanceConfiguration(RenderRequest renderRequest)
		throws PortletException {
		
		ThemeDisplay themeDisplay = (ThemeDisplay)renderRequest.getAttribute(
			WebKeys.THEME_DISPLAY);
		
		PortletDisplay portletDisplay = themeDisplay.getPortletDisplay();
		
		try {
			return portletDisplay.getPortletInstanceConfiguration(
					XSLContentPortletInstanceConfiguration.class);
		}
		catch (ConfigurationException configurationException) {
			throw new PortletException(configurationException);
		}
	}
	
	
	
	@Reference(
		target = "(&(release.bundle.symbolic.name=es.ehu.xsl.content.web)(&(release.schema.version>=1.0.0)(!(release.schema.version>=1.1.0))))",
		unbind = "-"
	)
	protected void setRelease(Release release) {
	}

	@Reference
	private ConfigurationProvider _configurationProvider;
	

	@Reference
	private Portal _portal;
	
	final Log log = LogFactoryUtil.getLog(XSLContentPortlet.class);



}