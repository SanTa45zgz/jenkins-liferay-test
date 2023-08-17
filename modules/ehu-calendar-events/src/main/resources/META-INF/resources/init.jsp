<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet" %>

<%@ taglib uri="http://liferay.com/tld/aui" prefix="aui" %><%@
taglib uri="http://liferay.com/tld/portlet" prefix="liferay-portlet" %><%@
taglib uri="http://liferay.com/tld/theme" prefix="liferay-theme" %><%@
taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %><%@
taglib uri="http://liferay.com/tld/frontend" prefix="liferay-frontend" %>

<liferay-theme:defineObjects />

<portlet:defineObjects />

<%@page import="es.ehu.calendarevents.internal.constants.CalendarEventsPortletKeys"%>
<%@page import="es.ehu.calendarevents.configuration.CalendarEventsPortletInstanceConfiguration"%>
<%@page import="es.ehu.calendarevents.configuration.CalendarEventsConfiguration"%>
<%@page import="es.ehu.calendarevents.internal.display.context.CalendarEventsDisplayContext"%>


<%
	CalendarEventsConfiguration calendarEventsConfiguration = (CalendarEventsConfiguration)request.getAttribute(CalendarEventsConfiguration.class.getName());
	CalendarEventsDisplayContext ehuCalendarEventsDisplayContext = new CalendarEventsDisplayContext(calendarEventsConfiguration, request);
	CalendarEventsPortletInstanceConfiguration calendarEventsPortletInstanceConfiguration = ehuCalendarEventsDisplayContext.getCalendarEventsPortletInstanceConfiguration();
%>