package es.ehu.doc.web.navigator.portlet.action;

import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.portlet.ConfigurationAction;
import com.liferay.portal.kernel.portlet.DefaultConfigurationAction;
import com.liferay.portal.kernel.portlet.PortletPreferencesFactoryUtil;
import com.liferay.portal.kernel.util.ParamUtil;

import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.PortletConfig;
import javax.portlet.PortletPreferences;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.chemistry.opencmis.client.api.Folder;
import org.apache.chemistry.opencmis.client.api.OperationContext;
import org.apache.chemistry.opencmis.client.api.Session;
import org.apache.chemistry.opencmis.commons.PropertyIds;
import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;

import es.ehu.doc.web.constants.DocWebConstants;
import es.ehu.doc.web.core.cmis.CmisModule;
import es.ehu.doc.web.core.cmis.CmisModuleFactory;
import es.ehu.doc.web.core.util.CmisUtil;
import es.ehu.doc.web.core.util.ConfigUtil;


@Component(
    immediate = true,
    property = {
        "javax.portlet.name="+DocWebConstants.DOC_NAVIGATOR_PORTLET
    },
    service = ConfigurationAction.class
)
public class NavigatorConfigurationAction extends DefaultConfigurationAction {

	private static Log _log = LogFactoryUtil.getLog(NavigatorConfigurationAction.class);			

	@Reference
	private CmisUtil cmisUtil;

	@Override
	public String getJspPath(HttpServletRequest httpServletRequest) {		
		return "/jsps/portlet/navigator/configuration.jsp";
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
		String rootNode = ParamUtil.getString(actionRequest, "rootNode");
		String paginationDelta = ParamUtil.getString(actionRequest, "paginationDelta");
		String orderByType = ParamUtil.getString(actionRequest, "orderByType");
		String showTitle = ParamUtil.getString(actionRequest, "showTitle");
		String showDescription = ParamUtil.getString(actionRequest, "showDescription");
		String searchEnable = ParamUtil.getString(actionRequest, "searchEnable");
		
		String portletResource = ParamUtil.getString(actionRequest, "portletResource");
		PortletPreferences preferences = PortletPreferencesFactoryUtil.getPortletSetup(actionRequest, portletResource);

		preferences.setValue(ConfigUtil.KEY_REPO_TYPE, repoType);
		preferences.setValue(ConfigUtil.KEY_AUTH_TYPE, authentication);
		preferences.setValue(ConfigUtil.KEY_AUTH_BINDING_TYPE, bindingType);
		preferences.setValue(ConfigUtil.KEY_AUTH_URL, url);
		preferences.setValue(ConfigUtil.KEY_AUTH_USER, authUser);
		preferences.setValue(ConfigUtil.KEY_AUTH_PASSWORD, password);
		preferences.setValue(ConfigUtil.KEY_PAGINATION_DELTA, paginationDelta);
		preferences.setValue(ConfigUtil.KEY_ROOT_NODE, rootNode);
		preferences.setValue(ConfigUtil.KEY_ORDER_BY_TYPE, orderByType);
		preferences.setValue(ConfigUtil.KEY_SHOW_TITLE, showTitle);
		preferences.setValue(ConfigUtil.KEY_SHOW_DESCRIPTION, showDescription);
		preferences.setValue(ConfigUtil.KEY_SEARCH_ENABLE, searchEnable);

		
		try {
			CmisModule cmisModule = CmisModuleFactory.getModule(repoType);
			Map<String, String> additionalSessionParameters = cmisModule.getAdditionalSessionParameters();
			CmisUtil cmisUtil = new CmisUtil();
			Session session = cmisUtil.getSession(bindingType, authentication, "", url, authUser, password, additionalSessionParameters);
			OperationContext operationContext = session.createOperationContext();
			Set<String> filter = new HashSet<String>();
			filter.add(PropertyIds.OBJECT_ID);
			filter.add(PropertyIds.PATH);
			operationContext.setFilter(filter);
			Folder folder = (Folder)session.getObjectByPath(rootNode, operationContext);
			preferences.setValue(ConfigUtil.KEY_ROOT_NODE_ID, folder.getId());
			preferences.setValue(ConfigUtil.KEY_ROOT_NODE_PATH_REPO, folder.getPath());
			
		} catch (Exception e) {
			_log.error(e);
			preferences.setValue(ConfigUtil.KEY_ROOT_NODE_ID, "");
			preferences.setValue(ConfigUtil.KEY_ROOT_NODE_PATH_REPO, "");
		}
		
		preferences.store();
		
		actionRequest.setAttribute("repoType", repoType);
		actionRequest.setAttribute("authentication", authentication);
		actionRequest.setAttribute("bindingType", bindingType);
		actionRequest.setAttribute("url", url);
		actionRequest.setAttribute("authUser", authUser);
		actionRequest.setAttribute("password", password);
		actionRequest.setAttribute("rootNode", rootNode);
		actionRequest.setAttribute("paginationDelta", paginationDelta);
		actionRequest.setAttribute("orderByType", orderByType);
		actionRequest.setAttribute("showTitle", showTitle);
		actionRequest.setAttribute("showDescription", showDescription);
		actionRequest.setAttribute("searchEnable", searchEnable);
	}

	@Override
	public void include(PortletConfig portletConfig, HttpServletRequest httpServletRequest,
			HttpServletResponse httpServletResponse) throws Exception {
	
		String portletResource = ParamUtil.getString(httpServletRequest, "portletResource");
		PortletPreferences preferences = PortletPreferencesFactoryUtil.getPortletSetup(httpServletRequest, portletResource);
		
		String repoType = ParamUtil.getString(httpServletRequest, "repoType", ConfigUtil.getValue(ConfigUtil.KEY_REPO_TYPE, preferences));
		String authentication = ParamUtil.getString(httpServletRequest, "authentication", ConfigUtil.getValue(ConfigUtil.KEY_AUTH_TYPE, preferences));
		String bindingType = ParamUtil.getString(httpServletRequest, "bindingType", ConfigUtil.getValue(ConfigUtil.KEY_AUTH_BINDING_TYPE, preferences));
		String url = ParamUtil.getString(httpServletRequest, "url", ConfigUtil.getValue(ConfigUtil.KEY_AUTH_URL, preferences));
		String authUser = ParamUtil.getString(httpServletRequest, "authUser", ConfigUtil.getValue(ConfigUtil.KEY_AUTH_USER, preferences));
		String password = ParamUtil.getString(httpServletRequest, "password", ConfigUtil.getValue(ConfigUtil.KEY_AUTH_PASSWORD, preferences));
		String paginationDelta = ParamUtil.getString(httpServletRequest, "paginationDelta", ConfigUtil.getValue(ConfigUtil.KEY_PAGINATION_DELTA, preferences));
		String rootNode = ParamUtil.getString(httpServletRequest, "rootNode", ConfigUtil.getValue(ConfigUtil.KEY_ROOT_NODE, preferences));
		String orderByType = ParamUtil.getString(httpServletRequest, "orderByType", ConfigUtil.getValue(ConfigUtil.KEY_ORDER_BY_TYPE, preferences));
		String showTitle = ParamUtil.getString(httpServletRequest, "showTitle", ConfigUtil.getValue(ConfigUtil.KEY_SHOW_TITLE, preferences));
		String showDescription = ParamUtil.getString(httpServletRequest, "showDescription", ConfigUtil.getValue(ConfigUtil.KEY_SHOW_DESCRIPTION, preferences));
		String searchEnable = ParamUtil.getString(httpServletRequest, "searchEnable", ConfigUtil.getValue(ConfigUtil.KEY_SEARCH_ENABLE, preferences));
		
		httpServletRequest.setAttribute("repoType", repoType);
		httpServletRequest.setAttribute("authentication", authentication);
		httpServletRequest.setAttribute("bindingType", bindingType);
		httpServletRequest.setAttribute("url", url);
		httpServletRequest.setAttribute("authUser", authUser);
		httpServletRequest.setAttribute("password", password);
		httpServletRequest.setAttribute("paginationDelta", paginationDelta);
		httpServletRequest.setAttribute("rootNode", rootNode);
		httpServletRequest.setAttribute("orderByType", orderByType);
		httpServletRequest.setAttribute("showTitle", showTitle);
		httpServletRequest.setAttribute("showDescription", showDescription);
		httpServletRequest.setAttribute("searchEnable", searchEnable);
	

		
        super.include(portletConfig, httpServletRequest, httpServletResponse);		
	}


}
