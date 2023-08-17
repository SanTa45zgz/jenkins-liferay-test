package es.ehu.doc.web.core.util;

import java.util.Map;

import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.portlet.DefaultFriendlyURLMapper;

public class CustomFriendlyURLMapper_DEPRECATED extends DefaultFriendlyURLMapper {

	private static Log _log = LogFactoryUtil.getLog(CustomFriendlyURLMapper_DEPRECATED.class);

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

}