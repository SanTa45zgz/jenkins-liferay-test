<%@ include file="/jsps/portlet/init.jsp" %>

<%
renderRequest.setAttribute(WebKeys.PORTLET_CONFIGURATOR_VISIBILITY, Boolean.TRUE);
%>

<div class="portlet-configuration portlet-msg-info">
	<a href="<%= portletDisplay.getURLConfiguration() %>">
		<liferay-ui:message key="please-configure-this-portlet-to-make-it-visible-to-all-users" />
	</a>
</div>