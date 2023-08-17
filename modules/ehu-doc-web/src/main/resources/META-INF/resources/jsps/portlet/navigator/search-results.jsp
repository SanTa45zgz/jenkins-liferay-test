<%@page import="es.ehu.doc.web.core.util.ConfigUtil"%>
<%@page import="es.ehu.doc.web.core.cmis.CmisModuleFactory"%>
<%@page import="es.ehu.doc.web.core.cmis.CmisModule"%>
<%@page import="es.ehu.doc.web.core.util.CustomDateFormatFactoryUtil"%>
<%@page import="es.ehu.doc.web.core.util.TextFormatterUtil"%>
<%@page import="com.liferay.portal.kernel.portlet.PortletURLFactoryUtil"%>
<%@page import="es.ehu.doc.web.navigator.portlet.NavigatorPortlet"%>
<%@page import="java.math.BigInteger"%>
<%@page import="com.liferay.document.library.kernel.util.DLUtil"%>
<%@page import="org.apache.chemistry.opencmis.commons.PropertyIds"%>
<%@page import="org.apache.chemistry.opencmis.client.api.QueryResult"%>
<%@page import="org.apache.chemistry.opencmis.client.api.Document"%>
<%@page import="org.apache.chemistry.opencmis.client.api.Folder"%>
<%@page import="java.util.Iterator"%>

<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet" %>


<%@ include file="/jsps/portlet/init.jsp" %>



<portlet:defineObjects />

<%
	String keywords = (String) renderRequest.getAttribute("keywords");
	String searchType = (String) renderRequest.getAttribute("searchType");
	List<QueryResult> queryResults = (List<QueryResult>) renderRequest.getAttribute("queryResults");
	int queryResultsCount = (Integer)renderRequest.getAttribute("queryResultsCount");
	Integer delta = (Integer) renderRequest.getAttribute("delta");
	String orderByCol = (String) renderRequest.getAttribute("orderByCol");
	String orderByType = (String) renderRequest.getAttribute("orderByType");
	
	Format dateFormatDateTime = CustomDateFormatFactoryUtil.getDateTime(locale, timeZone);
	PortletPreferences preferences = renderRequest.getPreferences();
	String repoType = ConfigUtil.getValue(ConfigUtil.KEY_REPO_TYPE, preferences);
	CmisModule cmisModule = CmisModuleFactory.getModule(repoType);
	
	boolean showTitle = Boolean.valueOf(ConfigUtil.getValue(ConfigUtil.KEY_SHOW_TITLE, preferences));
	boolean showDescription = Boolean.valueOf(ConfigUtil.getValue(ConfigUtil.KEY_SHOW_DESCRIPTION, preferences));
	String orderByTypeDefault = ConfigUtil.getValue(ConfigUtil.KEY_ORDER_BY_TYPE, preferences);
	
	String orderByColDefault;
	String fullNameLabel;
	if (showTitle) {
		orderByColDefault = "title";
		fullNameLabel = "ehu.doc.navigator.view.table.col.fullname";
	} else {
		orderByColDefault = "name";
		fullNameLabel = "name";
	}
%>


<div class="cmis-navigator">


<portlet:renderURL var="searchResultsURL">
	<portlet:param name="view" value="searchResults" />
</portlet:renderURL>

<aui:form action="<%= searchResultsURL %>" method="post">
        <aui:input name="keywords" id="keywords" size="50" type="text" label="" value="<%= keywords %>" />
        <aui:select name="searchType" label="">
			<aui:option value="<%= NavigatorPortlet.SEARCH_TYPE_DOCUMENTS %>" selected="<%= true %>">
				<liferay-ui:message key="ehu.doc.navigator.search.content.type.documents" />
			</aui:option>
			<aui:option value="<%= NavigatorPortlet.SEARCH_TYPE_FOLDERS %>">
				<liferay-ui:message key="ehu.doc.navigator.search.content.type.folders" />
			</aui:option>
		</aui:select>
		<aui:button type="submit" value="search" />
</aui:form>

<div class="separator"/></div>


<div class="cmis-navigator-breadcrumbs">
	<portlet:renderURL var="parentViewURL">
		<portlet:param name="view" value="folderView"/>
	</portlet:renderURL>
	<a href="<%= parentViewURL %>">
		<strong><liferay-ui:message key="ehu.doc.navigator.view.root_node.name" /></strong>
	</a>
	 / <strong><liferay-ui:message key="ehu.doc.navigator.search.title" /></strong>
</div>

<br/>


<%
	PortletURL paginationURL = renderResponse.createRenderURL();
	paginationURL.setParameter("view", "searchResults");
	paginationURL.setParameter("keywords", keywords);
	paginationURL.setParameter("searchType", searchType);
%>
<liferay-ui:search-container iteratorURL="<%= paginationURL %>" emptyResultsMessage="ehu.doc.general.search.empty" 
		delta="<%= delta %>" orderByType="<%= orderByType %>" orderByCol="<%= orderByCol %>" total="<%= queryResultsCount %>" >
        
	<liferay-ui:search-container-results results="<%= queryResults %>" />
	
	<liferay-ui:search-container-row
	        className="org.apache.chemistry.opencmis.client.api.QueryResult"
	        modelVar="queryResult">
<%
			if (queryResult.getPropertyValueById(PropertyIds.BASE_TYPE_ID).equals("cmis:folder")) {
				
				String title = cmisModule.getFolderTitle(queryResult);
				if (title == null || title.equals("")) {
					title = "-";
				}
				
				String fileName = cmisModule.getFolderFileName(queryResult);
				if (fileName == null || fileName.equals("")) {
					fileName = "-";
				}
				
				String description = cmisModule.getFolderDescription(queryResult);
				if (description == null || description.equals("")) {
					description = "";
				}
				
				String fullName;
				if (showTitle) {
					fullName = title + " (" + fileName + ")";	
				} else {
					fullName = fileName;
				}
				
				String modifDate = "";
				if (queryResult.getPropertyValueById(PropertyIds.LAST_MODIFICATION_DATE) != null) {
					modifDate = dateFormatDateTime.format(((Calendar)queryResult.getPropertyValueById(PropertyIds.LAST_MODIFICATION_DATE)).getTime());	
				}
				String folderId = (String)queryResult.getPropertyValueById(PropertyIds.OBJECT_ID);
%>			
				<portlet:renderURL var="viewFolderURL">
					<portlet:param name="folderId" value="<%= folderId %>" />
					<portlet:param name="view" value="folderView"/>
				</portlet:renderURL>

				<liferay-ui:search-container-column-text name="<%= fullNameLabel %>" align="left" orderable="true" orderableProperty="<%= orderByColDefault %>" >
				
					<a href="<%= viewFolderURL %>">
						<img align="left" border="0" src="<%= themeDisplay.getPathThemeImages() %>/common/folder.png" />
						<strong><%= fullName %></strong>
					</a>
					<%
					if (showDescription && description != null && !description.equals("")) {
					%>
						<br/><%= description %>
					<%
					}
					%>
					
				</liferay-ui:search-container-column-text>
				
				<liferay-ui:search-container-column-text name="modified-date" value="<%= modifDate %>" align="left" orderable="true" />
				
				<liferay-ui:search-container-column-text name="size" value="" align="left" />
				
				<liferay-ui:search-container-column-text name="" value="" align="right" />
			
<%
			} else if (queryResult.getPropertyValueById(PropertyIds.BASE_TYPE_ID).equals("cmis:document")) {
				
				String title = cmisModule.getDocumentTitle(queryResult);
				if (title == null || title.equals("")) {
					title = "-";
				}
				
				String fileName = cmisModule.getDocumentFileName(queryResult);
				if (fileName == null || fileName.equals("")) {
					fileName = "-";
				}
				
				String description = cmisModule.getDocumentDescription(queryResult);
				if (description == null || description.equals("")) {
					description = "";
				}
				
				String fullName;
				if (showTitle) {
					fullName = title + " (" + fileName + ")";	
				} else {
					fullName = fileName;
				}
				
				String extension = FileUtil.getExtension(fileName);
				
				String size = "";
				BigInteger streamLenght = (BigInteger)queryResult.getPropertyValueById(PropertyIds.CONTENT_STREAM_LENGTH);
				if (streamLenght != null) {
					size = TextFormatterUtil.formatKB(streamLenght.intValue(), locale);
				}
				
				String modifDate = "";
				if (queryResult.getPropertyValueById(PropertyIds.LAST_MODIFICATION_DATE) != null) {
					modifDate = dateFormatDateTime.format(((Calendar)queryResult.getPropertyValueById(PropertyIds.LAST_MODIFICATION_DATE)).getTime());
				}
				
				String portletId = PortalUtil.getPortletId(request);
				PortletURL downloadURL = PortletURLFactoryUtil.create(request, portletId, themeDisplay.getPlid(),
						PortletRequest.RESOURCE_PHASE);
				String documentId = (String)queryResult.getPropertyValueById(PropertyIds.OBJECT_ID);
				downloadURL.setParameter("documentId", documentId);
%>
				<liferay-ui:search-container-column-text name="<%= fullNameLabel %>" align="left" orderable="true" orderableProperty="<%= orderByColDefault %>">
	        		<a href="<%= downloadURL %>" target="_blank">
	        			<liferay-ui:icon
							image='<%= "../file_system/small/" + DLUtil.getFileIcon(extension) %>'
							label="<%= true %>"
							message="<%= fullName %>"
						/>
					</a>
					<%
					if (showDescription && description != null && !description.equals("")) {
					%>
						<br/><%= description %>
					<%
					}
					%>
				</liferay-ui:search-container-column-text>
				
				<liferay-ui:search-container-column-text name="modified-date" value="<%= modifDate %>" align="left" orderable="true" />
				
				<liferay-ui:search-container-column-text name="size" value="<%= size %>" align="left" />
				
				<liferay-ui:search-container-column-jsp name="" path="/jsps/portlet/navigator/search-document-actions.jsp" align="right" />
<%			
			}
%>	
 
	</liferay-ui:search-container-row>
	
	<liferay-ui:search-iterator paginate="true" />
        
</liferay-ui:search-container>


</div>

