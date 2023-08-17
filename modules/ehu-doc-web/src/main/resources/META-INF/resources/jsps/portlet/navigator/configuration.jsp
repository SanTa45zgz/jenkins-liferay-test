<%@page import="es.ehu.doc.web.core.cmis.CmisModuleFactory"%>
<%@page import="org.apache.chemistry.opencmis.commons.enums.BindingType"%>

<%@ include file="/jsps/portlet/init.jsp" %>

<%
	String repoType = (String) renderRequest.getAttribute("repoType");
	String authentication = (String) renderRequest.getAttribute("authentication");
	String bindingType = (String) renderRequest.getAttribute("bindingType");
	String url = (String) renderRequest.getAttribute("url");
	String authUser = (String) renderRequest.getAttribute("authUser");
	String password = (String) renderRequest.getAttribute("password");
	String rootNode = (String) renderRequest.getAttribute("rootNode");
	String paginationDelta = (String) renderRequest.getAttribute("paginationDelta");
	String orderByType = (String) renderRequest.getAttribute("orderByType");
	String showTitle = (String) renderRequest.getAttribute("showTitle");
	String showDescription = (String) renderRequest.getAttribute("showDescription");
	String searchEnable = (String) renderRequest.getAttribute("searchEnable");
	String errors = (String) renderRequest.getAttribute("errors");	
%>
    
<%
	if (errors != null && !errors.equals("")) {
		%>
		<div class="portlet-msg-error"><%= errors %></div>
		<%
	}
%>

<liferay-portlet:actionURL portletConfiguration="true" var="configurationURL" />
	
<aui:form action="<%=configurationURL%>" method="post" id="configurationForm" name="configurationForm">

	<aui:fieldset label="ehu.doc.configuration.auth.header">
		<br/>
		<aui:select name="repoType" label="ehu.doc.configuration.label.repo.type" >
			<aui:option value="<%= CmisModuleFactory.REPO_TYPE_ALFRESCO_CMIS_11 %>"
					selected="<%= (repoType == null || (StringPool.BLANK).equals(repoType) || CmisModuleFactory.REPO_TYPE_ALFRESCO_CMIS_11.equals(repoType)) ? true : false%>">
				Alfresco - CMIS 1.1
			</aui:option>
			<aui:option value="<%= CmisModuleFactory.REPO_TYPE_ALFRESCO_CMIS_10 %>"
					selected="<%= (CmisModuleFactory.REPO_TYPE_ALFRESCO_CMIS_10.equals(repoType)) ? true : false%>">
				Alfresco - CMIS 1.0
			</aui:option>
			<aui:option value="<%= CmisModuleFactory.REPO_TYPE_OTHER %>"
					selected="<%= (CmisModuleFactory.REPO_TYPE_OTHER.equals(repoType)) ? true : false %>">
				<liferay-ui:message key="ehu.doc.configuration.label.repo.type.other" />
			</aui:option>
		</aui:select>
	
		<aui:select name="bindingType" label="ehu.doc.configuration.label.binding.type" >
			<aui:option value="<%=BindingType.ATOMPUB.value()%>"
				selected="<%=(bindingType == null || (StringPool.BLANK).equals(bindingType) || BindingType.ATOMPUB.value().equals(bindingType)) ? true : false%>">AtomPub</aui:option>
			<aui:option disabled="true" value="<%=BindingType.WEBSERVICES.value()%>"
				selected="<%=(BindingType.WEBSERVICES.value().equals(bindingType)) ? true : false%>">Webservices</aui:option>
			<aui:option disabled="true" value="<%=BindingType.BROWSER.value()%>"
				selected="<%=(BindingType.BROWSER.value().equals(bindingType)) ? true : false%>">Browser</aui:option>
		</aui:select>

		<aui:select name="authentication" label="ehu.doc.configuration.label.authentication">
			<aui:option value="standard"
				selected='<%=(authentication == null || (StringPool.BLANK).equals(authentication) || ("standard").equals(authentication)) ? true : false%>'>Standard</aui:option>
			<aui:option value="none" disabled="true" 
				selected='<%=(("none").equals(authentication)) ? true : false%>'>None</aui:option>
<%-- 			<aui:option value="ntlm" --%>
<%-- 				selected='<%=(("ntlm").equals(authentication)) ? true : false%>'>NTLM</aui:option> --%>
		</aui:select>

		<aui:input name="url" id="url" label="ehu.doc.configuration.label.url" helpMessage="ehu.doc.configuration.label.url.tooltip" type="text" value="<%=url%>" style="width:500px;" />

		<aui:input name="authUser" id="authUser" label="ehu.doc.configuration.label.user" type="text" value="<%= authUser %>" />

		<aui:input name="password" id="password" label="ehu.doc.configuration.label.password" type="password" value="<%=password%>" />

	</aui:fieldset>

	<br/><br/>

	<aui:fieldset label="ehu.doc.configuration.general.header">
		<br/>
		
		<aui:input name="rootNode" type="text" value="<%= rootNode %>" label="ehu.doc.configuration.label.rootNode" style="width:500px" />
		
		<aui:select name="paginationDelta" label="ehu.doc.configuration.label.pagination.delta" >
			<aui:option label="5" selected='<%= paginationDelta.equals("5") ? true : false %>' />
			<aui:option label="10" selected='<%= paginationDelta.equals("10") ? true : false %>' />
			<aui:option label="20" selected='<%= paginationDelta.equals("20") ? true : false %>' />
			<aui:option label="30" selected='<%= paginationDelta.equals("30") ? true : false %>' />
			<aui:option label="50" selected='<%= paginationDelta.equals("50") ? true : false %>' />
			<aui:option label="75" selected='<%= paginationDelta.equals("75") ? true : false %>' />
		</aui:select>
		
		<aui:select name="orderByType" label="ehu.doc.configuration.label.order.type" >
			<aui:option value="asc"
				selected='<%= orderByType.equals("asc") ? true : false  %>'><liferay-ui:message key="ehu.doc.general.order.asc" /></aui:option>
			<aui:option value="desc"
				selected='<%= orderByType.equals("desc") ? true : false %>'><liferay-ui:message key="ehu.doc.general.order.desc" /></aui:option>
		</aui:select>
		
		
		<aui:input name="showTitle" type="checkbox" value="<%= showTitle %>" label="ehu.doc.configuration.label.show.title"/>
		
		<aui:input name="showDescription" type="checkbox" value="<%= showDescription %>" label="ehu.doc.configuration.label.show.description"/>
		
		<aui:input name="searchEnable" type="checkbox" value="<%= searchEnable %>" label="ehu.doc.configuration.label.search.enable"/>
		
	</aui:fieldset>

	<br/><br/>

	<aui:button id="submit" name="submit" type="submit" value="save" />
	
</aui:form>


