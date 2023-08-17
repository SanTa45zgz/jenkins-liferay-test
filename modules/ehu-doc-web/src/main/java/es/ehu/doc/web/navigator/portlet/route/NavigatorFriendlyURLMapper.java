package es.ehu.doc.web.navigator.portlet.route;

import com.liferay.portal.kernel.portlet.DefaultFriendlyURLMapper;
import com.liferay.portal.kernel.portlet.FriendlyURLMapper;

import java.util.Map;

import org.osgi.service.component.annotations.Component;

import es.ehu.doc.web.constants.DocWebConstants;

@Component(
     property = {
         "com.liferay.portlet.friendly-url-routes=META-INF/friendly-url-routes/routes-doc-navigator.xml",
         "javax.portlet.name=" + DocWebConstants.DOC_NAVIGATOR_PORTLET
     },
     service = FriendlyURLMapper.class
 )
public class NavigatorFriendlyURLMapper extends DefaultFriendlyURLMapper{
	
	
	 /*
	 * En el caso de Alfresco los ids comienzan por:
	 * 
	 * workspace://SpacesStore/...
	 * 
	 * Y el DefaultFriendlyURLMapper se come una "/" al parsear la url. Es decir, el valor del parametro que llega al portlet tiene el formato:
	 * 
	 * workspace:/SpacesStore/...
	 * 
	 * Asi que si se cumple ese patron se la volvemos a añadir.
	 * 
	 */
	protected void populateParams(Map<String, String[]> parameterMap, String namespace, Map<String, String> routeParameters) {

		String prefix = "workspace:/";
		String newPrefix = "workspace://";

		for (String key : routeParameters.keySet()) {
			if (key.equals("folderId") || key.equals("documentId")) {
				String value = routeParameters.get(key);
				if (value.startsWith(prefix)) {
					value = newPrefix + value.substring(prefix.length(), value.length());
					routeParameters.put(key, value);
				}
			}
		}

		super.populateParams(parameterMap, namespace, routeParameters);
	}
	

	@Override
    public String getMapping() {
        return _MAPPING;
    }

    private static final String _MAPPING = DocWebConstants.NAVIGATOR_FRIENDLY_URL_MAPPING;

}
