<%@ include file="/jsps/portlet/init.jsp" %>


<liferay-ui:error key="ehu.doc.error.RepoConnectionException">
	<liferay-ui:message key="ehu.doc.error.RepoConnectionException" arguments="<%= ((Exception)errorException).getMessage() %>"/>
</liferay-ui:error>

<liferay-ui:error key="ehu.doc.error.RepoQueryException">
	<liferay-ui:message key="ehu.doc.error.RepoQueryException" arguments="<%= ((Exception)errorException).getMessage() %>"/>
</liferay-ui:error>

<liferay-ui:error key="ehu.doc.error.CmisBaseException">
	<liferay-ui:message key="ehu.doc.error.CmisBaseException" arguments="<%= ((Exception)errorException).getMessage() %>"/>
</liferay-ui:error>

<liferay-ui:error key="ehu.doc.error.GroovyRuntimeException">
	<liferay-ui:message key="ehu.doc.error.GroovyRuntimeException" arguments="<%= ((Exception)errorException).getMessage() %>"/>
</liferay-ui:error>
