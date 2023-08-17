package es.ehu.doc.web.cmistemplate.portlet.action;

import com.liferay.petra.string.StringPool;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.portlet.ConfigurationAction;
import com.liferay.portal.kernel.portlet.DefaultConfigurationAction;
import com.liferay.portal.kernel.portlet.PortletPreferencesFactoryUtil;
//import com.liferay.portal.theme.ThemeDisplay;
//import com.liferay.portlet.PortletPreferencesFactoryUtil;
import com.liferay.portal.kernel.theme.ThemeDisplay;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.WebKeys;

import java.text.MessageFormat;
import java.util.List;
import java.util.Map;
import java.util.ResourceBundle;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.PortletConfig;
import javax.portlet.PortletPreferences;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.chemistry.opencmis.client.api.CmisObject;
import org.apache.chemistry.opencmis.client.api.ItemIterable;
import org.apache.chemistry.opencmis.client.api.QueryResult;
import org.apache.chemistry.opencmis.client.api.Session;
import org.apache.chemistry.opencmis.commons.exceptions.CmisBaseException;
import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;

import es.ehu.doc.web.constants.DocWebConstants;
import es.ehu.doc.web.core.cmis.CmisModule;
import es.ehu.doc.web.core.cmis.CmisModuleFactory;
import es.ehu.doc.web.core.exceptions.RepoConnectionException;
import es.ehu.doc.web.core.exceptions.RepoQueryException;
import es.ehu.doc.web.core.util.CmisUtil;
import es.ehu.doc.web.core.util.ConfigUtil;
import es.ehu.doc.web.core.util.GroovyUtil;
import es.ehu.doc.web.core.util.QueryParserUtil;
import es.ehu.doc.web.core.util.UTF8Control;
import groovy.lang.GroovyRuntimeException;

@Component(
    immediate = true,
    property = {
        "javax.portlet.name="+DocWebConstants.DOC_CMISTEMPLATE_PORTLET
    },
    service = ConfigurationAction.class
)
public class CmisTemplateConfigurationAction extends DefaultConfigurationAction {

	private static Log _log = LogFactoryUtil.getLog(CmisTemplateConfigurationAction.class);
	
	private static final String configurationJsp = "/jsps/portlet/cmis-template/configuration.jsp";
	private static final String configurationTestJsp = "/jsps/portlet/cmis-template/configuration-test.jsp";
	private static final String configurationErrorJsp = "/jsps/portlet/configuration-error.jsp";
	
	private String configJsp = StringPool.BLANK;
	
	@Reference
	private CmisUtil cmisUtil;
	
	@Override
	public String getJspPath(HttpServletRequest httpServletRequest) {
		return configJsp;
	}

	
	@Override
	public void include(PortletConfig portletConfig, HttpServletRequest httpServletRequest,
			HttpServletResponse httpServletResponse) throws Exception {

		String view = httpServletRequest.getParameter("view");

		if (view != null && ("groovyTest").equals(view)) {
			configJsp =  configTest(portletConfig, httpServletRequest, httpServletResponse);
		} else {
			configJsp = config(portletConfig, httpServletRequest, httpServletResponse);
		}
	

		super.include(portletConfig, httpServletRequest, httpServletResponse);
	}
	
	
	@Override
	public void processAction(PortletConfig portletConfig, ActionRequest actionRequest, ActionResponse actionResponse)
			throws Exception {

		String repoType = ParamUtil.getString(actionRequest, "repoType");
		String authentication = ParamUtil.getString(actionRequest, "authentication");
		String bindingType = ParamUtil.getString(actionRequest, "bindingType");
		String url = ParamUtil.getString(actionRequest, "url");
		String authUser = ParamUtil.getString(actionRequest, "authUser");
		String password = ParamUtil.getString(actionRequest, "password");
		String query = ParamUtil.getString(actionRequest, "query");
		Integer limit = ParamUtil.getInteger(actionRequest, "limit");
		String script = ParamUtil.getString(actionRequest, "script");

		String portletResource = ParamUtil.getString(actionRequest, "portletResource");
		PortletPreferences preferences = PortletPreferencesFactoryUtil.getPortletSetup(actionRequest, portletResource);

		preferences.setValue(ConfigUtil.KEY_REPO_TYPE, repoType);
		preferences.setValue(ConfigUtil.KEY_AUTH_TYPE, authentication);
		preferences.setValue(ConfigUtil.KEY_AUTH_BINDING_TYPE, bindingType);
		preferences.setValue(ConfigUtil.KEY_AUTH_URL, url);
		preferences.setValue(ConfigUtil.KEY_AUTH_USER, authUser);
		preferences.setValue(ConfigUtil.KEY_AUTH_PASSWORD, password);
		preferences.setValue(ConfigUtil.KEY_TEMPLATE_QUERY, query);
		preferences.setValue(ConfigUtil.KEY_TEMPLATE_QUERY_LIMIT, String.valueOf(limit));
		preferences.setValue(ConfigUtil.KEY_TEMPLATE_SCRIPT, script);

		preferences.store();

		actionRequest.setAttribute("repoType", repoType);
		actionRequest.setAttribute("authentication", authentication);
		actionRequest.setAttribute("bindingType", bindingType);
		actionRequest.setAttribute("url", url);
		actionRequest.setAttribute("authUser", authUser);
		actionRequest.setAttribute("password", password);
		actionRequest.setAttribute("query", query);
		actionRequest.setAttribute("limit", limit);
		actionRequest.setAttribute("script", script);
	}	
	
	

	private String config(PortletConfig portletConfig, HttpServletRequest httpServletRequest,
			HttpServletResponse httpServletResponse)
			throws Exception {
		
		String portletResource = ParamUtil.getString(httpServletRequest, "portletResource");
		PortletPreferences preferences = PortletPreferencesFactoryUtil.getPortletSetup(httpServletRequest, portletResource);
		
		String repoType = ParamUtil.getString(httpServletRequest, "repoType", ConfigUtil.getValue(ConfigUtil.KEY_REPO_TYPE, preferences));
		String authentication = ParamUtil.getString(httpServletRequest, "authentication", ConfigUtil.getValue(ConfigUtil.KEY_AUTH_TYPE, preferences));
		String bindingType = ParamUtil.getString(httpServletRequest, "bindingType", ConfigUtil.getValue(ConfigUtil.KEY_AUTH_BINDING_TYPE, preferences));
		String url = ParamUtil.getString(httpServletRequest, "url", ConfigUtil.getValue(ConfigUtil.KEY_AUTH_URL, preferences));
		String authUser = ParamUtil.getString(httpServletRequest, "authUser", ConfigUtil.getValue(ConfigUtil.KEY_AUTH_USER, preferences));
		String password = ParamUtil.getString(httpServletRequest, "password", ConfigUtil.getValue(ConfigUtil.KEY_AUTH_PASSWORD, preferences));
		String query = ParamUtil.getString(httpServletRequest, "query", ConfigUtil.getValue(ConfigUtil.KEY_TEMPLATE_QUERY, preferences));
		String limit = ParamUtil.getString(httpServletRequest, "limit", ConfigUtil.getValue(ConfigUtil.KEY_TEMPLATE_QUERY_LIMIT, preferences));
		String script = ParamUtil.getString(httpServletRequest, "script", ConfigUtil.getValue(ConfigUtil.KEY_TEMPLATE_SCRIPT, preferences));
		
		httpServletRequest.setAttribute("repoType", repoType);
		httpServletRequest.setAttribute("authentication", authentication);
		httpServletRequest.setAttribute("bindingType", bindingType);
		httpServletRequest.setAttribute("url", url);
		httpServletRequest.setAttribute("authUser", authUser);
		httpServletRequest.setAttribute("password", password);
		httpServletRequest.setAttribute("query", query);
		httpServletRequest.setAttribute("limit", limit);
		httpServletRequest.setAttribute("script", script);

		return configurationJsp;
	}

	private String configTest(PortletConfig portletConfig, HttpServletRequest httpServletRequest,
			HttpServletResponse httpServletResponse)
			throws Exception {
				
		ThemeDisplay themeDisplay = (ThemeDisplay) httpServletRequest.getAttribute(WebKeys.THEME_DISPLAY);

		String repoType = ParamUtil.getString(httpServletRequest, "repoType");
		String authentication = ParamUtil.getString(httpServletRequest, "authentication");
		String bindingType = ParamUtil.getString(httpServletRequest, "bindingType");
		String url = ParamUtil.getString(httpServletRequest, "url");
		String authUser = ParamUtil.getString(httpServletRequest, "authUser");
		String password = ParamUtil.getString(httpServletRequest, "password");
		String query = ParamUtil.getString(httpServletRequest, "query");
		Integer limit = ParamUtil.getInteger(httpServletRequest, "limit");
		String script = ParamUtil.getString(httpServletRequest, "script");

		ResourceBundle rb = ResourceBundle.getBundle("es.ehu.doc.portlet.cmistemplate.resources.language", httpServletRequest.getLocale(), new UTF8Control());

		try {
			CmisModule cmisModule = CmisModuleFactory.getModule(repoType);
			Map<String, String> additionalSessionParameters = cmisModule.getAdditionalSessionParameters();
			CmisUtil cmisUtil = new CmisUtil();
			Session session = cmisUtil.getSession(bindingType, authentication, "", url, authUser, password, additionalSessionParameters);
			query = QueryParserUtil.parse(query, themeDisplay);
			ItemIterable<QueryResult> queryResults = cmisUtil.query(session, query, 0L, limit);
			List<CmisObject> cmisObjects = cmisUtil.convert(session, queryResults);
			String html = GroovyUtil.process(cmisObjects, script, themeDisplay);
			httpServletRequest.setAttribute("html", html);

			return configurationTestJsp;
			
		} catch (RepoConnectionException e) {
			_log.error(e);
			String errors = MessageFormat.format(rb.getString("ehu.doc.error.RepoConnectionException"), e.getMessage());
			httpServletRequest.setAttribute("errors", errors);
			return configurationErrorJsp;
			
		} catch (RepoQueryException e) {
			_log.error(e);
			String errors = MessageFormat.format(rb.getString("ehu.doc.error.RepoQueryException"), e.getMessage());
			httpServletRequest.setAttribute("errors", errors);
			return configurationErrorJsp;
			
		} catch (CmisBaseException e) {
			_log.error(e);
			String errors = MessageFormat.format(rb.getString("ehu.doc.error.CmisBaseException"), e.getMessage());
			httpServletRequest.setAttribute("errors", errors);
			return configurationErrorJsp;
			
		} catch (GroovyRuntimeException e) {
			_log.error(e);
			String errors = MessageFormat.format(rb.getString("ehu.doc.error.GroovyRuntimeException"), e.getMessage());
			httpServletRequest.setAttribute("errors", errors);
			return configurationErrorJsp;
		}			
	}



}
