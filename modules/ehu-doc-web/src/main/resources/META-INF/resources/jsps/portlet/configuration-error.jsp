<%@ include file="/jsps/portlet/init.jsp" %>

<%
	String errors = (String) renderRequest.getAttribute("errors");
%>

<div class="portlet-msg-error"><%= errors %></div>

