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

package es.ehu.calendarevents.internal.portlet.action;

import com.liferay.portal.configuration.metatype.bnd.util.ConfigurableUtil;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.portlet.ConfigurationAction;
import com.liferay.portal.kernel.portlet.DefaultConfigurationAction;

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

import es.ehu.calendarevents.configuration.CalendarEventsConfiguration;
import es.ehu.calendarevents.internal.constants.CalendarEventsPortletKeys;

/**
 * @author UPV/EHU
 */
@Component(
	immediate = true,
	property = {
		"javax.portlet.name=" + CalendarEventsPortletKeys.EHUCALENDAREVENTS,
	},
	service = ConfigurationAction.class
)

public class CalendarEventsConfigurationAction extends DefaultConfigurationAction {
	
	private static final Log _log = LogFactoryUtil.getLog(CalendarEventsConfigurationAction.class);


	@Override
	public String getJspPath(HttpServletRequest httpServletRequest) {
		_log.debug("Entro getJspPath");
		return "/configuration.jsp";
	}

	@Override
	public void include(PortletConfig portletConfig, HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse) throws Exception {

		httpServletRequest.setAttribute(CalendarEventsConfiguration.class.getName(), _calendarEventsConfiguration);
		_log.debug("CalendarEventsConfigurationAction - include - _calendarEventsConfiguration: " + _calendarEventsConfiguration.toString());
		super.include(portletConfig, httpServletRequest, httpServletResponse);
	}

	@Override
	public void processAction(PortletConfig portletConfig, ActionRequest actionRequest, ActionResponse actionResponse) throws Exception {
		String tipoVista = getParameter(actionRequest, "tipoVista");
		_log.debug("CalendarEventsConfigurationAction - processAction - tipoVista: " + tipoVista);
		super.setPreference(actionRequest, "tipoVista", tipoVista);
		super.processAction(portletConfig, actionRequest, actionResponse);
	}

	@Override
	@Reference(
		target = "(osgi.web.symbolicname=es.ehu.calendarevents)",
		unbind = "-"
	)
	public void setServletContext(ServletContext servletContext) {
		super.setServletContext(servletContext);
	}

	@Activate
	@Modified
	protected void activate(Map<String, Object> properties) {
		_log.debug("CalendarEventsConfigurationAction - activate");
		_calendarEventsConfiguration = ConfigurableUtil.createConfigurable(CalendarEventsConfiguration.class, properties);
	}


	private volatile CalendarEventsConfiguration _calendarEventsConfiguration;

}