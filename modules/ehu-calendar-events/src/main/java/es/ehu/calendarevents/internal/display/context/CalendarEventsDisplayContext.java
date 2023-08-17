package es.ehu.calendarevents.internal.display.context;

import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.module.configuration.ConfigurationException;
import com.liferay.portal.kernel.theme.PortletDisplay;
import com.liferay.portal.kernel.theme.ThemeDisplay;
import com.liferay.portal.kernel.util.WebKeys;

import javax.servlet.http.HttpServletRequest;

import es.ehu.calendarevents.configuration.CalendarEventsConfiguration;
import es.ehu.calendarevents.configuration.CalendarEventsPortletInstanceConfiguration;


/**
 * 
 * @author UPV/EHU
 *
 */
public class CalendarEventsDisplayContext {

	
	
	/**
	 * 
	 * @param httpServletRequest
	 * @param xslContentConfiguration
	 * @throws ConfigurationException
	 */
	public CalendarEventsDisplayContext(CalendarEventsConfiguration calendarEventsConfiguration, HttpServletRequest httpServletRequest) throws ConfigurationException {
		_calendarEventsConfiguration = calendarEventsConfiguration;
		_themeDisplay = (ThemeDisplay)httpServletRequest.getAttribute(WebKeys.THEME_DISPLAY);
		final PortletDisplay portletDisplay = _themeDisplay.getPortletDisplay();
		_calendarEventsPortletInstanceConfiguration = portletDisplay.getPortletInstanceConfiguration(CalendarEventsPortletInstanceConfiguration.class);
		_log.debug("EhuCalendarEventsDisplayContext");
	}
	
	/**
	 * 
	 * @return
	 */
	public CalendarEventsPortletInstanceConfiguration getCalendarEventsPortletInstanceConfiguration() {
		return _calendarEventsPortletInstanceConfiguration;
	}
	
	/**
	 * 
	 * @return
	 */
	public CalendarEventsConfiguration getCalendarEventsConfiguration() {
		return _calendarEventsConfiguration;
	}
	
	private static final Log _log = LogFactoryUtil.getLog(CalendarEventsDisplayContext.class);
	
	private final ThemeDisplay _themeDisplay;
	private final CalendarEventsPortletInstanceConfiguration _calendarEventsPortletInstanceConfiguration;
	private final CalendarEventsConfiguration _calendarEventsConfiguration;

}
