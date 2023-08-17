package es.ehu.doc.web.core.util;

import com.liferay.petra.string.StringPool;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.util.Validator;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.chemistry.opencmis.client.api.CmisObject;
import org.apache.chemistry.opencmis.client.api.ItemIterable;
import org.apache.chemistry.opencmis.client.api.OperationContext;
import org.apache.chemistry.opencmis.client.api.QueryResult;
import org.apache.chemistry.opencmis.client.api.Session;
import org.apache.chemistry.opencmis.client.api.SessionFactory;
import org.apache.chemistry.opencmis.commons.PropertyIds;
import org.apache.chemistry.opencmis.commons.SessionParameter;
import org.apache.chemistry.opencmis.commons.enums.BindingType;
import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;

import es.ehu.doc.web.core.exceptions.RepoConnectionException;
import es.ehu.doc.web.core.exceptions.RepoQueryException;

@Component(
	service = CmisUtil.class
)
public class CmisUtil {

	private static final Log _log = LogFactoryUtil.getLog(CmisUtil.class);

	@Reference
	private SessionFactory sessionFactory;

	
	public Session getSession(String bindingType, String authentication, String ntlm, String url, String user,
			String password, Map<String, String> additionalParameters) throws RepoConnectionException {

		try {
		
			Session session = null;
			OperationContext oc;
	
			Map<String, String> parameters = new HashMap<String, String>();
	
			// Specify the connection settings
			if (bindingType != null && (BindingType.ATOMPUB.value()).equals(bindingType)) {
	
				parameters.put(SessionParameter.ATOMPUB_URL, url);
				parameters.put(SessionParameter.BINDING_TYPE, BindingType.ATOMPUB.value());
	
			} else if (bindingType != null && (BindingType.WEBSERVICES.value()).equals(bindingType)) {
	
				parameters.put(SessionParameter.WEBSERVICES_REPOSITORY_SERVICE, url);
				parameters.put(SessionParameter.WEBSERVICES_NAVIGATION_SERVICE, url);
				parameters.put(SessionParameter.WEBSERVICES_OBJECT_SERVICE, url);
				parameters.put(SessionParameter.WEBSERVICES_VERSIONING_SERVICE, url);
				parameters.put(SessionParameter.WEBSERVICES_DISCOVERY_SERVICE, url);
				parameters.put(SessionParameter.WEBSERVICES_MULTIFILING_SERVICE, url);
				parameters.put(SessionParameter.WEBSERVICES_RELATIONSHIP_SERVICE, url);
				parameters.put(SessionParameter.WEBSERVICES_ACL_SERVICE, url);
				parameters.put(SessionParameter.WEBSERVICES_POLICY_SERVICE, url);
	
			} else if (bindingType != null && (BindingType.BROWSER.value()).equals(bindingType)) {
	
				parameters.put(SessionParameter.BROWSER_URL, url);
				parameters.put(SessionParameter.BINDING_TYPE, BindingType.BROWSER.value());
			}
	
			// parameter.put(SessionParameter.COMPRESSION, Boolean.TRUE.toString());
			// parameter.put(SessionParameter.CLIENT_COMPRESSION, Boolean.FALSE.toString());
			// parameter.put(SessionParameter.COOKIES, Boolean.TRUE.toString());
	
			// Set the user credentials
			if (!(StringPool.BLANK).equals(authentication) && ("standard").equalsIgnoreCase(authentication)) {
				parameters.put(SessionParameter.USER, user);
				parameters.put(SessionParameter.PASSWORD, password);
			} else if (!(StringPool.BLANK).equals(authentication) && ("ntlm").equalsIgnoreCase(authentication)) {
				parameters.put(SessionParameter.USER, user);
				parameters.put(SessionParameter.PASSWORD, password);
				parameters.put(SessionParameter.AUTHENTICATION_PROVIDER_CLASS, ntlm);
			}
			
			for (String key : additionalParameters.keySet()) {
				parameters.put(key, additionalParameters.get(key));
			}
	
			// Create a session
			//SessionFactory factory = SessionFactoryImpl.newInstance();
			session = sessionFactory.getRepositories(parameters).get(0).createSession();
			oc = session.createOperationContext();
			oc.setIncludeAcls(true);
	
			return session;
		
		} catch (RuntimeException e) {
			throw new RepoConnectionException(e);
		}
	}
	
	public ItemIterable<QueryResult> query(Session session, String query, Long skipTo, Integer maxItemsPerPage) throws RepoQueryException {

		try {
			
			ItemIterable<QueryResult> results = null;
	
			if (maxItemsPerPage != null && maxItemsPerPage > 0) {
				
				OperationContext operationContext = session.createOperationContext();
				operationContext.setMaxItemsPerPage(maxItemsPerPage);
				
				results = session.query(query, false, operationContext).skipTo(skipTo).getPage();
				
			} else {
				results = session.query(query, false);
			}
			
			_log.debug(results.getPageNumItems() + " results from " + results.getTotalNumItems());
			
			return results;
			
		} catch (RuntimeException e) {
			throw new RepoQueryException(e);
		}
	}
	
	
	/**
	 * Hace una query por cada registro para obtener el objeto completo
	 * 
	 * @param session
	 * @param queryResults
	 * @return
	 */
	public List<CmisObject> convert(Session session, ItemIterable<QueryResult> queryResults) {
	
		List<CmisObject> cmisObjects = new ArrayList<CmisObject>();
		
		if (queryResults.getTotalNumItems() > 0) {
			
			for (QueryResult qResult : queryResults) {
				String objectId = qResult.getPropertyValueByQueryName(PropertyIds.OBJECT_ID).toString();
				
				if (objectId != null) {
					CmisObject object = session.getObject(objectId);
					cmisObjects.add(object);
				}
			}
		}
			
		return cmisObjects;
	}

}
