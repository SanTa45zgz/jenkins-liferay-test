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
	String query = (String) renderRequest.getAttribute("query");
	String limit = (String) renderRequest.getAttribute("limit");
	String script = (String) renderRequest.getAttribute("script");
	
	String pre = "import org.apache.chemistry.opencmis.commons.*;\n"
		+ "import org.apache.chemistry.opencmis.commons.data.*;\n"
		+ "import org.apache.chemistry.opencmis.commons.enums.*;\n"
		+ "import org.apache.chemistry.opencmis.client.api.*;\n"
		+ "import com.liferay.portal.theme.ThemeDisplay;\n"
		+ "StringBuffer html = new StringBuffer();\n"
		+ "List<org.apache.chemistry.opencmis.client.api.CmisObject> listaObjetos = objects;\n"
		+ "com.liferay.portal.theme.ThemeDisplay themeDisplay = td;\n";
		
	String returnText = "return html";
%>

<%-- Esta hardcode el path del portlet porque en la configuracion en request.getContextPath() devuelve el contexto de ROOT (/) --%>
	<link rel="stylesheet" href="css/codemirror.css">
	<link rel="stylesheet" href="css/groovycolors.css">
    <script src="js/codemirror.js" type="text/javascript"></script>
    <script src="js/matchbrackets.js" type="text/javascript"></script>
    <script src="js/groovy.js" type="text/javascript"></script>
    <script src="js/jquery-1.6.4.js" type="text/javascript"></script>

	<style>
	.CodeMirror {
		border: 2px inset #dee;
		font-size: 14px;
	}
	</style>

	<liferay-portlet:actionURL portletConfiguration="true"
		var="configurationURL" />
	<aui:form action="<%=configurationURL%>" method="post" id="configurationForm"
		name="configurationForm">
	
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
	
			<aui:select name="bindingType" label="ehu.doc.configuration.label.binding.type">
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
<%-- 					<aui:option value="ntlm" --%>
<%-- 						selected='<%=(("ntlm").equals(authentication)) ? true : false%>'>NTLM</aui:option> --%>
			</aui:select>
	
			<aui:input name="url" id="url" label="ehu.doc.configuration.label.url" helpMessage="ehu.doc.configuration.label.url.tooltip" type="text" value="<%=url%>"
				style="width:500px;" />
	
			<aui:input name="authUser" id="authUser" label="ehu.doc.configuration.label.user" type="text" value="<%= authUser %>" />
	
			<aui:input name="password" id="password" label="ehu.doc.configuration.label.password" type="password"
				value="<%=password%>" />
	
		</aui:fieldset>
	
		<br/><br/>
	
		<aui:fieldset label="ehu.doc.configuration.query.header">
		
			<br/>
	
			<aui:input name="query" id="query" type="text" value="<%=query%>"
				label="ehu.doc.configuration.label.query" style="width:500px;" />
	
			<br />
			<div class="terms email-user-add definition-of-terms">
				<p style="font-weight: bold;"><liferay-ui:message key="ehu.doc.configuration.label.terms.definition" /></p>
				<dl>
					<dt>[$COMPANYID$]</dt>
					<dd><%=themeDisplay.getCompanyId()%></dd>
					<dt>[$GROUPID$]</dt>
					<dd><%=themeDisplay.getScopeGroupId()%></dd>
					<dt>[$USERID$]</dt>
					<dd><%=themeDisplay.getUserId()%></dd>
					<dt>[$SCREENNAME$]</dt>
					<dd><%=themeDisplay.getUser().getScreenName()%></dd>
					<dt>[$LOCALE$]</dt>
					<dd><%=themeDisplay.getLocale()%></dd>
					<dt>[$COUNTRY$]</dt>
					<dd><%=themeDisplay.getLocale().getCountry()%></dd>
					<dt>[$LANGUAGE$]</dt>
					<dd><%=themeDisplay.getLocale().getLanguage()%></dd>
				</dl>
			</div>
	
			<aui:input name="limit" id="limit" type="text" value="<%=limit%>"
				label="ehu.doc.configuration.label.query.limit" />
		</aui:fieldset>
		
		<br/><br/>
		
		<aui:fieldset label="ehu.doc.configuration.script.header">
			<br/>
			<!-- Para obtener el id del textarea <portlet:namespace />script_cp -->
			<div id="textarea-container" class="border">
				<aui:input type="textarea" name="imports" id="imports" label="" rows="15"
  						style="display: none;" value="<%=pre%>" />
 				<aui:input type="textarea" label="ehu.doc.configuration.label.script" name="script" id="script" rows="30"
 						style="display: none;" value="<%=script%>" />
 				<aui:input type="textarea" name="return" id="return" label="" rows="4"
 						style="display: none;" value="<%=returnText%>" />
	        </div>
		</aui:fieldset>

		<br/><br/>

		<aui:button id="testButton" name="testButton" value="ehu.doc.general.button.test" />

		<aui:button id="submit" name="submit" type="submit" value="save" />
		
	</aui:form>
	
	<script>
	  var width = "780px";
	
      var imports = CodeMirror.fromTextArea(document.getElementById("<portlet:namespace />imports"), {
        lineNumbers: true,
        matchBrackets: true,
        readOnly: true,
        mode: "text/x-groovy"
      });
      imports.setSize(width, 120);
      var script = CodeMirror.fromTextArea(document.getElementById("<portlet:namespace />script"), {
        lineNumbers: true,
        matchBrackets: true,
        mode: "text/x-groovy"
      });
      script.setSize(width, null);
      var ret = CodeMirror.fromTextArea(document.getElementById("<portlet:namespace />return"), {
        lineNumbers: true,
        matchBrackets: true,
        readOnly: true,
        mode: "text/x-groovy"
      });
      ret.setSize(width, 30);
    </script>
   
	<aui:script use="aui-dialog">
	
		//window popup test
		jQuery("#<portlet:namespace />testButton").click(function() {
				
				// Para pasar lo que esta en el editor al textarea 'script'
				script.save();
				
				var dialog = new A.Dialog(
					{
						centered: true,
						destroyOnClose: true,
						modal: true,
						title: '<liferay-ui:message key="ehu.doc.configuration.preview.title" />',
						width: 800,
						height: 600
					}
				).render();
				
				dialog.plug(
					A.Plugin.IO,
					{
						data: {
							repoType: jQuery("#<portlet:namespace />repoType :selected").val(),
							bindingType: jQuery("#<portlet:namespace />bindingType :selected").val(),
							authentication: jQuery("#<portlet:namespace />authentication :selected").val(),
							url: jQuery("#<portlet:namespace />url").val(),
							authUser: jQuery("#<portlet:namespace />authUser").val(),
							password: jQuery("#<portlet:namespace />password").val(),
							query: jQuery("#<portlet:namespace />query").val(),
							limit: jQuery("#<portlet:namespace />limit").val(),
							script: jQuery("#<portlet:namespace />script").val()
						},
						uri: "<liferay-portlet:renderURL windowState='<%= LiferayWindowState.EXCLUSIVE.toString() %>' portletConfiguration="true"><portlet:param name='view' value='groovyTest' /></liferay-portlet:renderURL>"
					}
				);
				event.preventDefault();
			});
			
	</aui:script>

