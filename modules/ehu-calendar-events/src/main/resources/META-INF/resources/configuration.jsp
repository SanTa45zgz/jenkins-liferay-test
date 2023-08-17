<%@ include file="/init.jsp" %>

<%@page import="com.liferay.portal.kernel.util.Constants"%>

<liferay-portlet:actionURL portletConfiguration="<%= true %>" var="configurationActionURL" />

<liferay-portlet:renderURL portletConfiguration="<%= true %>" var="configurationRenderURL" />

<liferay-frontend:edit-form
	action="<%= configurationActionURL %>"
	method="post"
	name="fm"
>
	<liferay-frontend:edit-form-body>
		<aui:input name="<%= Constants.CMD %>" type="hidden" value="<%=Constants.UPDATE %>" />
		<aui:input name="redirect" type="hidden" value="<%= configurationRenderURL %>" />
		
							
			<aui:select name="preferences--tipoVista--" value="${calendarEventsPortletInstanceConfiguration.tipoVista()}" label="calendar.conf.tipo.vista">			
				<aui:option value="<%=CalendarEventsPortletKeys.cEventsViewTipo_Listado%>"><liferay-ui:message key="calendar.conf.tipo.listado"/></aui:option>
				<aui:option value="<%=CalendarEventsPortletKeys.cEventsViewTipo_Popup%>"><liferay-ui:message key="calendar.conf.tipo.popup"/></aui:option>														
			</aui:select>
						
			
	</liferay-frontend:edit-form-body>

	<liferay-frontend:edit-form-footer>
		<aui:button type="submit" />

		<aui:button type="cancel" />
	</liferay-frontend:edit-form-footer>
</liferay-frontend:edit-form>

