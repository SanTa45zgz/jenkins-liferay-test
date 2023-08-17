<%@page import="org.apache.chemistry.opencmis.commons.PropertyIds"%>
<%@page import="org.apache.chemistry.opencmis.client.api.QueryResult"%>

<%@ include file="/jsps/portlet/init.jsp" %>

<%
        ResultRow row = (ResultRow)request.getAttribute(WebKeys.SEARCH_CONTAINER_RESULT_ROW);
		QueryResult queryResult = (QueryResult)row.getObject();
		String documentId = queryResult.getPropertyValueById(PropertyIds.OBJECT_ID);
%>

<liferay-ui:icon-menu>

	<portlet:actionURL var="viewDocumentFolderViewURL" name="viewDocumentFolderView">
		<portlet:param name="documentId" value="<%= documentId %>" />
	</portlet:actionURL>

	<liferay-ui:icon image="folder"  message="ehu.doc.navigator.search.table.actions.go_to_folder" url="<%= viewDocumentFolderViewURL.toString() %>" />
	            
</liferay-ui:icon-menu>
 