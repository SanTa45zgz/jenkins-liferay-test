package es.ehu.doc.web.navigator.portlet;

import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.portlet.PortletURLFactoryUtil;
import com.liferay.portal.kernel.portlet.bridges.mvc.MVCPortlet;
//import com.liferay.portal.security.auth.PrincipalException;
//import com.liferay.portal.theme.ThemeDisplay;
//import com.liferay.portal.util.PortalUtil;
//import com.liferay.portlet.PortletURLFactoryUtil;
//import com.liferay.util.bridges.mvc.MVCPortlet;
import com.liferay.portal.kernel.security.auth.PrincipalException;
import com.liferay.portal.kernel.servlet.HttpHeaders;
import com.liferay.portal.kernel.servlet.SessionErrors;
import com.liferay.portal.kernel.theme.ThemeDisplay;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.PortalUtil;
import com.liferay.portal.kernel.util.WebKeys;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.Portlet;
import javax.portlet.PortletException;
import javax.portlet.PortletPreferences;
import javax.portlet.PortletRequest;
import javax.portlet.PortletURL;
import javax.portlet.ProcessAction;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;
import javax.portlet.ResourceRequest;
import javax.portlet.ResourceResponse;

import org.apache.chemistry.opencmis.client.api.CmisObject;
import org.apache.chemistry.opencmis.client.api.Document;
import org.apache.chemistry.opencmis.client.api.Folder;
import org.apache.chemistry.opencmis.client.api.ItemIterable;
import org.apache.chemistry.opencmis.client.api.OperationContext;
import org.apache.chemistry.opencmis.client.api.QueryResult;
import org.apache.chemistry.opencmis.client.api.Session;
import org.apache.chemistry.opencmis.commons.PropertyIds;
import org.apache.chemistry.opencmis.commons.data.ContentStream;
import org.apache.chemistry.opencmis.commons.exceptions.CmisBaseException;
import org.apache.commons.collections4.IteratorUtils;
import org.apache.commons.io.IOUtils;
import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;

import es.ehu.doc.web.constants.DocWebConstants;
import es.ehu.doc.web.core.cmis.CmisModule;
import es.ehu.doc.web.core.cmis.CmisModuleFactory;
import es.ehu.doc.web.core.exceptions.RepoConnectionException;
import es.ehu.doc.web.core.exceptions.RepoQueryException;
import es.ehu.doc.web.core.util.CmisUtil;
import es.ehu.doc.web.core.util.ConfigUtil;
import es.ehu.doc.web.core.util.SecurityUtil;

@Component(
		immediate = true,
		property = {			
			"com.liferay.portlet.instanceable=true",
			"com.liferay.portlet.display-category=category.upv-ehu",
			"javax.portlet.name=" + DocWebConstants.DOC_NAVIGATOR_PORTLET,
			"javax.portlet.resource-bundle=content.Language",
			"javax.portlet.security-role-ref=administrator,guest,power-user,user",
			"javax.portlet.init-param.add-process-action-success-action=false",
		},
		service = Portlet.class
	)
	public class NavigatorPortlet extends MVCPortlet {

		private static Log _log = LogFactoryUtil.getLog(NavigatorPortlet.class);

		
		
		private static final String homeListJsp = "/jsps/portlet/navigator/view.jsp";
		private static final String searchResultsJsp = "/jsps/portlet/navigator/search-results.jsp";
		private static final String errorJsp = "/jsps/portlet/error.jsp";
		private static final String portletNotSetupJsp = "/jsps/portlet/portlet_not_setup.jsp";
		

		public static final String SEARCH_TYPE_FOLDERS = "folders";
		public static final String SEARCH_TYPE_DOCUMENTS = "documents";
		
		@Reference
		private CmisUtil cmisUtil;
		

		public void doView(RenderRequest renderRequest, RenderResponse renderResponse) throws IOException, PortletException {

			String view = ParamUtil.getString(renderRequest, "view");
			renderRequest.setAttribute("view", view); // se utiliza en el navigation.jsp
			
			PortletPreferences preferences = renderRequest.getPreferences();
			String authUrl = ConfigUtil.getValue(ConfigUtil.KEY_AUTH_URL, preferences);
			if (authUrl != null && !authUrl.equals("")) {
			
				if (view == null || view.equals("folderView")) {
					doViewFolderView(renderRequest, renderResponse);
				} else if (view == null || view.equals("searchResults")) {
					doViewSearchResults(renderRequest, renderResponse);
				} else {
					doViewFolderView(renderRequest, renderResponse);
				}
			} else {
				doViewPortletNotSetup(renderRequest, renderResponse);	
			}
		}
		
		public void doViewPortletNotSetup(RenderRequest renderRequest, RenderResponse renderResponse) throws IOException, PortletException {
			include(portletNotSetupJsp, renderRequest, renderResponse);
		}
		
		/**
		 * Este metodo se invoca desde el view folder de la busqueda. Como en ese punto no se dispone del folderId se genera una
		 * action url (en vez de un render) con el documentId para poder hacer un sendRedirect al view folder. De esta forma la pagina
		 * de view Folder es idempotente.
		 */
		
		@SuppressWarnings("deprecation")
		@ProcessAction(name = "viewDocumentFolderView")
		public void viewDocumentFolderView(ActionRequest actionRequest, ActionResponse actionResponse) throws IOException, PortletException {
			
			try {
				ThemeDisplay themeDisplay = (ThemeDisplay) actionRequest.getAttribute(WebKeys.THEME_DISPLAY);
				
				String documentId = ParamUtil.getString(actionRequest, "documentId", "");
		
				PortletPreferences preferences = actionRequest.getPreferences();
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
				List<Folder> parents = document.getParents();
				Folder parent = parents.get(0);
				
				String portletId = PortalUtil.getPortletId(actionRequest);
				PortletURL portletUrl = PortletURLFactoryUtil.create(actionRequest, portletId, themeDisplay.getPlid(),
						PortletRequest.RENDER_PHASE);

				// Mientras Liferay no convierta sus portlets a 3.0, mejor usar el API anterior ya que no se podrían usar AssetRenderer (y quizás otras funcionalidades no detectadas)
				portletUrl.setParameter("view", "folderView");
				portletUrl.setParameter("folderId", parent.getId());
				
				actionResponse.sendRedirect(portletUrl.toString());
				
			} catch (RepoConnectionException e) {
				// el tratamiento de la exception aqui es distinto (no se muestra el detalle en pantalla)
				_log.error(e);
				throw new PortletException(e);
			}
		}
		
		public void doViewFolderView(RenderRequest renderRequest, RenderResponse renderResponse) throws IOException, PortletException {

			try {
			
				long start = System.currentTimeMillis();
				
				PortletPreferences preferences = renderRequest.getPreferences();
				
				String rootNodeId = ConfigUtil.getValue(ConfigUtil.KEY_ROOT_NODE_ID, preferences);
				String orderByTypeDefault = ConfigUtil.getValue(ConfigUtil.KEY_ORDER_BY_TYPE, preferences);
				String repoType = ConfigUtil.getValue(ConfigUtil.KEY_REPO_TYPE, preferences);
				String authentication = ConfigUtil.getValue(ConfigUtil.KEY_AUTH_TYPE, preferences);
				String bindingType = ConfigUtil.getValue(ConfigUtil.KEY_AUTH_BINDING_TYPE, preferences);
				String url = ConfigUtil.getValue(ConfigUtil.KEY_AUTH_URL, preferences);
				String user = ConfigUtil.getValue(ConfigUtil.KEY_AUTH_USER, preferences);
				String password = ConfigUtil.getValue(ConfigUtil.KEY_AUTH_PASSWORD, preferences);
				String rootNodePathRepo = ConfigUtil.getValue(ConfigUtil.KEY_ROOT_NODE_PATH_REPO, preferences);
				int paginationDelta = Integer.valueOf(ConfigUtil.getValue(ConfigUtil.KEY_PAGINATION_DELTA, preferences));
				boolean showTitle = Boolean.valueOf(ConfigUtil.getValue(ConfigUtil.KEY_SHOW_TITLE, preferences));
				
				String orderByColDefault;
				if (showTitle) {
					orderByColDefault = "title";	
				} else {
					orderByColDefault = "name";
				}
				
				String folderId = ParamUtil.getString(renderRequest, "folderId", rootNodeId);
				String orderByCol = ParamUtil.getString(renderRequest, "orderByCol", orderByColDefault);
				String orderByType = ParamUtil.getString(renderRequest, "orderByType", orderByTypeDefault);
				Integer cur = ParamUtil.getInteger(renderRequest, "cur", 1);
				Integer delta = ParamUtil.getInteger(renderRequest, "delta", paginationDelta);
				
				CmisModule cmisModule = CmisModuleFactory.getModule(repoType);
				Map<String, String> additionalSessionParameters = cmisModule.getAdditionalSessionParameters();
				Session session = cmisUtil.getSession(bindingType, authentication, "", url, user, password, additionalSessionParameters);
				
				OperationContext operationContext = session.createOperationContext();
				Set<String> filter = new HashSet<String>();
				filter.add(PropertyIds.OBJECT_ID);
				filter.add(PropertyIds.NAME);
				filter.add(PropertyIds.PATH);
				operationContext.setFilter(filter);
				
				Folder folder = (Folder)session.getObject(folderId, operationContext);
				
				SecurityUtil.check(folder, rootNodePathRepo);
				
				int maxItemsPerPage = delta;
				long skipCount = cmisModule.getNavigationSkipTo(cur, delta);
				
				operationContext = session.createOperationContext();
				operationContext.setMaxItemsPerPage(maxItemsPerPage);
				
				filter = cmisModule.getNavigationFilter();
				operationContext.setFilter(filter);
				
				// Aunque esta propiedad sea de cmis 1.1, no afecta en cmis 1.0
				operationContext.setLoadSecondaryTypeProperties(true);

				String order = cmisModule.getNavigationOrder(orderByCol, orderByType);
				
				operationContext.setOrderBy(order);
				
				ItemIterable<CmisObject> children = folder.getChildren(operationContext);
		
				ItemIterable<CmisObject> page = children.skipTo(skipCount).getPage();
				
				List<CmisObject> cmisObjects = IteratorUtils.toList(page.iterator());
				
				// No parece que haya una manera de obtener todos los parents a la vez (para el camino de migas), asi que esta
				// operacion consume cierto tiempo (dependiendo de la profundidad de la carpeta). Lo unico probar con getParent y
				// operationContext a ver si tarda algo menos, aunque no creo que se gane mucho tiempo.
				long start2 = System.currentTimeMillis();
				List<Folder> parents = new ArrayList<Folder>();
				Folder f = folder;
				while (f != null) {
					parents.add(f);
					if (f.getId().equals(rootNodeId)) {
						break;
					}
					f = f.getFolderParent();
				}
				Collections.reverse(parents);
				long end2 = System.currentTimeMillis();
				_log.debug("search time getParents(ms): " + (end2 - start2));
				
				Boolean searchEnable = Boolean.valueOf(ConfigUtil.getValue(ConfigUtil.KEY_SEARCH_ENABLE, preferences));
				
				renderRequest.setAttribute("cmisObjects", cmisObjects);
				renderRequest.setAttribute("cmisObjectsCount", ((Long)page.getTotalNumItems()).intValue());
				renderRequest.setAttribute("parents", parents);
				renderRequest.setAttribute("folder", folder);
				renderRequest.setAttribute("searchEnable", searchEnable);
				renderRequest.setAttribute("delta", delta);
				renderRequest.setAttribute("orderByCol", orderByCol);
				renderRequest.setAttribute("orderByType", orderByType);
				
				long end = System.currentTimeMillis();
				_log.debug("search time total (ms): " + (end - start));
				
				include(homeListJsp, renderRequest, renderResponse);
				
			} catch (RepoConnectionException e) {
				_log.error(e);
				SessionErrors.add(renderRequest, "ehu.doc.error.RepoConnectionException", e);
				include(errorJsp, renderRequest, renderResponse);
				
			} catch (CmisBaseException e) {
				_log.error(e);
				SessionErrors.add(renderRequest, "ehu.doc.error.CmisBaseException", e);
				include(errorJsp, renderRequest, renderResponse);
				
			} catch (PrincipalException e) {
				throw new PortletException(e);
			}
		}
		
		public void doViewSearchResults(RenderRequest renderRequest, RenderResponse renderResponse) throws IOException, PortletException {

			try {
			
				long start = System.currentTimeMillis();
				
				PortletPreferences preferences = renderRequest.getPreferences();
				
				String repoType = ConfigUtil.getValue(ConfigUtil.KEY_REPO_TYPE, preferences);
				String authentication = ConfigUtil.getValue(ConfigUtil.KEY_AUTH_TYPE, preferences);
				String bindingType = ConfigUtil.getValue(ConfigUtil.KEY_AUTH_BINDING_TYPE, preferences);
				String url = ConfigUtil.getValue(ConfigUtil.KEY_AUTH_URL, preferences);
				String user = ConfigUtil.getValue(ConfigUtil.KEY_AUTH_USER, preferences);
				String password = ConfigUtil.getValue(ConfigUtil.KEY_AUTH_PASSWORD, preferences);
				String rootNodeId = ConfigUtil.getValue(ConfigUtil.KEY_ROOT_NODE_ID, preferences);

				String orderByCol = ParamUtil.getString(renderRequest, "orderByCol", "score");
				String orderByType = ParamUtil.getString(renderRequest, "orderByType", "desc");
				int paginationDelta = Integer.valueOf(ConfigUtil.getValue(ConfigUtil.KEY_PAGINATION_DELTA, preferences));
				Integer delta = ParamUtil.getInteger(renderRequest, "delta", paginationDelta);
				Integer cur = ParamUtil.getInteger(renderRequest, "cur", 1);
				String keywords = ParamUtil.getString(renderRequest, "keywords", "");
				String searchType = ParamUtil.getString(renderRequest, "searchType", SEARCH_TYPE_DOCUMENTS);
				
				CmisModule cmisModule = CmisModuleFactory.getModule(repoType);
				Map<String, String> additionalSessionParameters = cmisModule.getAdditionalSessionParameters();
				Session session = cmisUtil.getSession(bindingType, authentication, "", url, user, password, additionalSessionParameters);
				
				String query;
				if (searchType.equals(SEARCH_TYPE_FOLDERS)) {
					query = cmisModule.getQueryFoldersByKeyword(repoType, keywords, rootNodeId, orderByCol, orderByType);
				} else { // documents
					query = cmisModule.getQueryDocumentsByKeyword(repoType, keywords, rootNodeId, orderByCol, orderByType);
				}
		
				_log.debug(query);
				
				int maxItemsPerPage = delta;
				long skipTo = (cur - 1) * delta;
				
				List<QueryResult> queryResults = new ArrayList<QueryResult>();
				int queryResultsCount = 0;
				
				try {
					ItemIterable<QueryResult> results = cmisUtil.query(session, query, skipTo, maxItemsPerPage);
					queryResults = IteratorUtils.toList(results.iterator());
					queryResultsCount = ((Long)results.getTotalNumItems()).intValue();
				} catch (RepoQueryException e) {
					// si hay un error en la busqueda el comportamiento de cara al usuario es como si no se hubiesen encontrado
					// resultados.
					_log.error("error al realizar la busqueda de usuario", e);
				}
			
				renderRequest.setAttribute("keywords", keywords);
				renderRequest.setAttribute("searchType", searchType);
				renderRequest.setAttribute("queryResults", queryResults);
				renderRequest.setAttribute("queryResultsCount", queryResultsCount);
				renderRequest.setAttribute("delta", delta);
				renderRequest.setAttribute("orderByCol", orderByCol);
				renderRequest.setAttribute("orderByType", orderByType);
				
				long end = System.currentTimeMillis();
				_log.debug("search time (ms): " + (end - start));
				
				include(searchResultsJsp, renderRequest, renderResponse);
				
			} catch (RepoConnectionException e) {
				_log.error(e);
				SessionErrors.add(renderRequest, "ehu.doc.error.RepoConnectionException", e);
				include(errorJsp, renderRequest, renderResponse);
			
			} catch (CmisBaseException e) {
				_log.error(e);
				SessionErrors.add(renderRequest, "ehu.doc.error.CmisBaseException", e);
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
				
				String rootNodePathRepo = ConfigUtil.getValue(ConfigUtil.KEY_ROOT_NODE_PATH_REPO, preferences);
				SecurityUtil.check(document, rootNodePathRepo);
				
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
			} catch (PrincipalException e) {
				throw new PortletException(e);
			}
		}

	}

