package es.ehu.doc.web.cmistemplate.portlet;

import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.model.Release;
import com.liferay.portal.kernel.portlet.bridges.mvc.MVCPortlet;
import com.liferay.portal.kernel.servlet.HttpHeaders;
import com.liferay.portal.kernel.servlet.SessionErrors;

import com.liferay.portal.kernel.theme.ThemeDisplay;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.WebKeys;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.portlet.Portlet;
import javax.portlet.PortletException;
import javax.portlet.PortletPreferences;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;
import javax.portlet.ResourceRequest;
import javax.portlet.ResourceResponse;

import org.apache.chemistry.opencmis.client.api.CmisObject;
import org.apache.chemistry.opencmis.client.api.Document;
import org.apache.chemistry.opencmis.client.api.ItemIterable;
import org.apache.chemistry.opencmis.client.api.QueryResult;
import org.apache.chemistry.opencmis.client.api.Session;
import org.apache.chemistry.opencmis.commons.data.ContentStream;
import org.apache.chemistry.opencmis.commons.exceptions.CmisBaseException;
import org.apache.commons.io.IOUtils;
import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;

import es.ehu.doc.web.core.cmis.CmisModule;
import es.ehu.doc.web.core.cmis.CmisModuleFactory;
import es.ehu.doc.web.core.exceptions.RepoConnectionException;
import es.ehu.doc.web.core.exceptions.RepoQueryException;
import es.ehu.doc.web.core.util.CmisUtil;
import es.ehu.doc.web.core.util.ConfigUtil;
import es.ehu.doc.web.core.util.GroovyUtil;
import es.ehu.doc.web.core.util.QueryParserUtil;
import es.ehu.doc.web.constants.DocWebConstants;
import groovy.lang.GroovyRuntimeException;

@Component(
	immediate = true,
	property = {
		"com.liferay.portlet.instanceable=true",
		"com.liferay.portlet.display-category=category.cms",
		"javax.portlet.name=" + DocWebConstants.DOC_CMISTEMPLATE_PORTLET,
		"javax.portlet.resource-bundle=content.Language",
		"javax.portlet.security-role-ref=administrator,guest,power-user,user",					
	},
	service = Portlet.class
)
public class CmisTemplatePortlet extends MVCPortlet {
private static Log _log = LogFactoryUtil.getLog(CmisTemplatePortlet.class);
	
	private static final String viewJsp = "/jsps/portlet/cmis-template/view.jsp";
	private static final String errorJsp = "/jsps/portlet/error.jsp";
	private static final String portletNotSetupJsp = "/jsps/portlet/portlet_not_setup.jsp";
	
	@Reference
	private CmisUtil cmisUtil;
	
	public void doView(RenderRequest renderRequest, RenderResponse renderResponse) throws IOException, PortletException {

		PortletPreferences preferences = renderRequest.getPreferences();
		String authUrl = ConfigUtil.getValue(ConfigUtil.KEY_AUTH_URL, preferences);
		
		if (authUrl != null && !authUrl.equals("")) {
			doViewExecute(renderRequest, renderResponse);
		} else {
			doViewPortletNotSetup(renderRequest, renderResponse);	
		}
	}
	
	public void doViewPortletNotSetup(RenderRequest renderRequest, RenderResponse renderResponse) throws IOException, PortletException {
		include(portletNotSetupJsp, renderRequest, renderResponse);
	}
	
	public void doViewExecute(RenderRequest renderRequest, RenderResponse renderResponse) throws PortletException, IOException {
		
		try {
			long start = System.currentTimeMillis();
			
			ThemeDisplay themeDisplay = (ThemeDisplay) renderRequest.getAttribute(WebKeys.THEME_DISPLAY);

			PortletPreferences preferences = renderRequest.getPreferences();
			String repoType = ConfigUtil.getValue(ConfigUtil.KEY_REPO_TYPE, preferences);
			String authentication = ConfigUtil.getValue(ConfigUtil.KEY_AUTH_TYPE, preferences);
			String bindingType = ConfigUtil.getValue(ConfigUtil.KEY_AUTH_BINDING_TYPE, preferences);
			String url = ConfigUtil.getValue(ConfigUtil.KEY_AUTH_URL, preferences);
			String user = ConfigUtil.getValue(ConfigUtil.KEY_AUTH_USER, preferences);
			String password = ConfigUtil.getValue(ConfigUtil.KEY_AUTH_PASSWORD, preferences);
			String script = ConfigUtil.getValue(ConfigUtil.KEY_TEMPLATE_SCRIPT, preferences);
			String query = ConfigUtil.getValue(ConfigUtil.KEY_TEMPLATE_QUERY, preferences);
			Integer limit = Integer.parseInt(ConfigUtil.getValue(ConfigUtil.KEY_TEMPLATE_QUERY_LIMIT, preferences));
			
			CmisModule cmisModule = CmisModuleFactory.getModule(repoType);
			Map<String, String> additionalSessionParameters = cmisModule.getAdditionalSessionParameters();
			Session session = cmisUtil.getSession(bindingType, authentication, "", url, user, password, additionalSessionParameters);

			query = QueryParserUtil.parse(query, themeDisplay);
			ItemIterable<QueryResult> queryResults = cmisUtil.query(session, query, 0L, limit);
			List<CmisObject> cmisObjects = cmisUtil.convert(session, queryResults);
			String html = GroovyUtil.process(cmisObjects, script, themeDisplay);
			
			renderRequest.setAttribute("html", html);
			
			long end = System.currentTimeMillis();
			_log.debug("process time (ms): " + (end - start));
			
			include(viewJsp, renderRequest, renderResponse);
			
		} catch (RepoConnectionException e) {
			_log.error(e);
			SessionErrors.add(renderRequest, "ehu.doc.error.RepoConnectionException", e);
			include(errorJsp, renderRequest, renderResponse);

		} catch (RepoQueryException e) {
			_log.error(e);
			SessionErrors.add(renderRequest, "ehu.doc.error.RepoQueryException", e);
			include(errorJsp, renderRequest, renderResponse);

		} catch (CmisBaseException e) {
			_log.error(e);
			SessionErrors.add(renderRequest, "ehu.doc.error.CmisBaseException", e);
			include(errorJsp, renderRequest, renderResponse);

		} catch (GroovyRuntimeException e) {
			_log.error(e);
			SessionErrors.add(renderRequest, "ehu.doc.error.GroovyRuntimeException", e);
			include(errorJsp, renderRequest, renderResponse);
		}
		
	}
	
	
	@Override
	public void serveResource(ResourceRequest resourceRequest, ResourceResponse resourceResponse) throws IOException,
			PortletException {

		try {
			String documentId = ParamUtil.getString(resourceRequest, "documentId");
			
			PortletPreferences preferences = resourceRequest.getPreferences();
			String repoType = ConfigUtil.getValue(ConfigUtil.KEY_REPO_TYPE, preferences);
			String authentication = ConfigUtil.getValue(ConfigUtil.KEY_AUTH_TYPE, preferences);
			String bindingType = ConfigUtil.getValue(ConfigUtil.KEY_AUTH_BINDING_TYPE, preferences);
			String url = ConfigUtil.getValue(ConfigUtil.KEY_AUTH_URL, preferences);
			String user = ConfigUtil.getValue(ConfigUtil.KEY_AUTH_USER, preferences);
			String password = ConfigUtil.getValue(ConfigUtil.KEY_AUTH_PASSWORD, preferences);
			
			CmisModule cmisModule = CmisModuleFactory.getModule(repoType);
			Map<String, String> additionalSessionParameters = cmisModule.getAdditionalSessionParameters();
			Session session = cmisUtil.getSession(bindingType, authentication, "", url, user, password, additionalSessionParameters);
			
			Document document = (Document)session.getObject(documentId);
			ContentStream contentStream = document.getContentStream();
			
			String fileName = "document";
			if (document.getContentStreamFileName() != null && !document.getContentStreamFileName().equals("")) {
				fileName = document.getContentStreamFileName();
			}
			resourceResponse.addProperty(HttpHeaders.CONTENT_DISPOSITION, "filename=" + fileName);
				
	        if (document.getContentStreamMimeType() != null) {
	        	resourceResponse.setContentType(document.getContentStreamMimeType());
	        }
	        
			IOUtils.copy(contentStream.getStream(), resourceResponse.getPortletOutputStream());
			
		} catch (RepoConnectionException e) {
			throw new PortletException(e);
		}
	}

	
}

