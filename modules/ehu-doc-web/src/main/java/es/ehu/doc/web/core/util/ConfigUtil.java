package es.ehu.doc.web.core.util;

import javax.portlet.PortletPreferences;

public class ConfigUtil {

	
	// GENERALES
	public static final String KEY_REPO_TYPE = "repoType"; // id del CmisModule
	
	public static final String KEY_AUTH_TYPE = "authType";
	public static final String KEY_AUTH_BINDING_TYPE = "authBindingType";
	public static final String KEY_AUTH_URL = "authUrl";
	public static final String KEY_AUTH_USER = "authUser";
	public static final String KEY_AUTH_PASSWORD = "authPassword";
	
	// el "root" path que introduce el usuario en la config.
	public static final String KEY_ROOT_NODE = "rootNode"; 
	// el "root" id del nodo anterior.
	public static final String KEY_ROOT_NODE_ID = "rootNodeId";
	// el "root" path que devuelve el repositorio (se obtiene a partir del "root" id). No tiene porque coincidir con el "root"
	// path que introduce el usuario, ya que nuxeo lo escapa. Asi que si hace falta el path es preferible utilizar esta propiedad.
	public static final String KEY_ROOT_NODE_PATH_REPO = "rootNodePathRepo";
	public static final String KEY_SHOW_TITLE = "showTitle";
	public static final String KEY_SHOW_DESCRIPTION = "showDescription";
	public static final String KEY_ORDER_BY_TYPE = "orderByType";
	public static final String KEY_PAGINATION_DELTA = "paginationDelta";
	public static final String KEY_SEARCH_ENABLE = "searchEnable";
	
	// navigator portlet

	// template portlet
	public static final String KEY_TEMPLATE_QUERY = "templateQuery";
	public static final String KEY_TEMPLATE_QUERY_LIMIT = "templateQueryLimit";
	public static final String KEY_TEMPLATE_SCRIPT = "templateScript";
	
	
	public static String getValue(String key, PortletPreferences preferences) {

		String value = preferences.getValue(key, "");

		if (value == null || value.equals("")) {

			value = getDefaultValue(key);
		}

		return value;
	}

	public static String getDefaultValue(String key) {

		String value = "";

		if (key != null && key.equals(KEY_PAGINATION_DELTA)) {
			value = "20";
		} else if (key != null && key.equals(KEY_SEARCH_ENABLE)) {
			value = "true";
		} else if (key != null && key.equals(KEY_TEMPLATE_QUERY_LIMIT)) {
			value = "10";
		} else if (key != null && key.equals(KEY_SHOW_TITLE)) {
			value = "true";
		} else if (key != null && key.equals(KEY_SHOW_DESCRIPTION)) {
			value = "false";
		} else if (key != null && key.equals(KEY_ORDER_BY_TYPE)) {
			value = "asc";
		}

		return value;
	}

}
