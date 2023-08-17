<%@page import="es.ehu.doc.web.navigator.portlet.NavigatorPortlet"%>
<%@page import="es.ehu.doc.web.core.cmis.CmisModule"%>
<%@page import="es.ehu.doc.web.core.cmis.CmisModuleFactory"%>
<%@page import="es.ehu.doc.web.core.util.CustomDateFormatFactoryUtil"%>
<%@page import="es.ehu.doc.web.core.util.TextFormatterUtil"%>
<%@page import="com.liferay.portal.kernel.portlet.PortletURLFactoryUtil"%>
<%@page import="es.ehu.doc.web.core.util.ConfigUtil"%>
<%@page import="com.liferay.document.library.kernel.util.DLUtil"%>
<%@page import="org.apache.chemistry.opencmis.client.api.Document"%>
<%@page import="org.apache.chemistry.opencmis.client.api.Folder"%>
<%@page import="java.util.Iterator"%>
<%@page import="org.apache.chemistry.opencmis.client.api.CmisObject"%>

<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet" %>


<%@ include file="/jsps/portlet/init.jsp" %>


<portlet:defineObjects />

<%
	List<Folder> parents = (List<Folder>) renderRequest.getAttribute("parents");
	Folder folder = (Folder) renderRequest.getAttribute("folder");
	List<CmisObject> cmisObjects = (List<CmisObject>) renderRequest.getAttribute("cmisObjects");
	int cmisObjectsCount = (Integer)renderRequest.getAttribute("cmisObjectsCount");
	Boolean searchEnable = (Boolean) renderRequest.getAttribute("searchEnable");
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


<%
	if (searchEnable) {
%>
		<portlet:renderURL var="searchResultsURL">
			<portlet:param name="view" value="searchResults" />
		</portlet:renderURL>
		
		<aui:form action="<%= searchResultsURL %>" method="post">
		        <aui:input name="keywords" id="keywords" size="50" type="text" label="" value="" />
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
<%
	}
%>

<div class="cmis-navigator-breadcrumbs">
<%
	for (int i = 0; i < parents.size(); i++) {
		Folder parent = parents.get(i);
		String name;
		if (i == 0) { // si es la raiz
			name = LanguageUtil.get(request, "ehu.doc.navigator.view.root_node.name");
		} else {
			name = parent.getName();
		}
%>
		<portlet:renderURL var="parentViewURL">
			<portlet:param name="view" value="folderView"/>
			<portlet:param name="folderId" value="<%= String.valueOf(parent.getId()) %>" />
			<%
			if (!orderByCol.equals(orderByColDefault) || !orderByType.equals(orderByTypeDefault)) {
			%>
				<portlet:param name="orderByCol" value="<%= orderByCol %>"/>
				<portlet:param name="orderByType" value="<%= orderByType %>"/>
			<%
			}
			%>
		</portlet:renderURL>
<%
		if (i == parents.size() - 1) { // si es el ultimo no se pone enlace
%>		
			<strong><%= name %></strong>		
<%
		} else {
%>		
			<a href="<%= parentViewURL %>">
				<strong><%= name %></strong>
			</a>
			 / 
<%		
		}		
	}
%>
</div>

<br/>

<%
	PortletURL paginationURL = renderResponse.createRenderURL();
	paginationURL.setParameter("folderId", String.valueOf(folder.getId()));
	paginationURL.setParameter("view", "folderView");
%>
<liferay-ui:search-container iteratorURL="<%= paginationURL %>" emptyResultsMessage="there-are-no-documents-in-this-folder" 
		delta="<%= delta %>" orderByType="<%= orderByType %>" orderByCol="<%= orderByCol %>" total="<%= cmisObjectsCount %>">
        
	<liferay-ui:search-container-results results="<%= cmisObjects %>" />
	
	<liferay-ui:search-container-row
	        className="org.apache.chemistry.opencmis.client.api.CmisObject" keyProperty="id"
	        modelVar="cmisObject">
<%		
			if (cmisObject instanceof Folder) {
				
				Folder child = (Folder)cmisObject;
			
				String title = cmisModule.getFolderTitle(child);
				if (title == null || title.equals("")) {
					title = "-";
				}
				
				String fileName = cmisModule.getFolderFileName(child);
				if (fileName == null || fileName.equals("")) {
					fileName = "-";
				}
				
				String description = cmisModule.getFolderDescription(child);
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
				if (cmisObject.getLastModificationDate() != null) {
					modifDate = dateFormatDateTime.format(((Calendar)cmisObject.getLastModificationDate()).getTime());	
				}
%>				
				<portlet:renderURL var="childURL">
					<portlet:param name="view" value="folderView"/>
					<portlet:param name="folderId" value="<%= String.valueOf(cmisObject.getId()) %>" />
					<%
					if (!orderByCol.equals(orderByColDefault) || !orderByType.equals(orderByTypeDefault)) {
					%>
						<portlet:param name="orderByCol" value="<%= orderByCol %>"/>
						<portlet:param name="orderByType" value="<%= orderByType %>"/>
					<%
					}
					%>
				</portlet:renderURL>
				
				<liferay-ui:search-container-column-text name="<%= fullNameLabel %>" href="<%= childURL %>" align="left" orderable="true" orderableProperty="<%= orderByColDefault %>" >
				
					<a href="<%= childURL %>">
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
				
<%						
			} else if (cmisObject instanceof Document) {
				
				Document document = (Document)cmisObject;
				
				String title = cmisModule.getDocumentTitle(document);
				if (title == null || title.equals("")) {
					title = "-";
				}
				
				String fileName = cmisModule.getDocumentFileName(document);
				if (fileName == null || fileName.equals("")) {
					fileName = "-";
				}
				
				String description = cmisModule.getDocumentDescription(document);
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
				String size = TextFormatterUtil.formatKB(document.getContentStreamLength(), locale);
				
				String modifDate = "";
				if (cmisObject.getLastModificationDate() != null) {
					modifDate = dateFormatDateTime.format(((Calendar)cmisObject.getLastModificationDate()).getTime());
				}
				
				String portletId = PortalUtil.getPortletId(request);
				PortletURL downloadURL = PortletURLFactoryUtil.create(request, portletId, themeDisplay.getPlid(),
						PortletRequest.RESOURCE_PHASE);
				downloadURL.setParameter("documentId", String.valueOf(cmisObject.getId()));
				
%>
	        	<liferay-ui:search-container-column-text name="<%= fullNameLabel %>" href="<%= downloadURL %>" align="left" orderable="true" orderableProperty="<%= orderByColDefault %>" >
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
<%
			}
%>
	</liferay-ui:search-container-row>
	
    <liferay-ui:search-iterator paginate="true" />
	    
</liferay-ui:search-container>



</div>

