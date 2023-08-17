package es.ehu.confirmation.formfield.servicewrapper.util;

import java.util.Properties;

import com.liferay.portal.kernel.configuration.Configuration;
import com.liferay.portal.kernel.configuration.ConfigurationFactoryUtil;
import com.liferay.portal.kernel.configuration.Filter;


public class PortletProps {

	public static void addProperties(Properties properties) {
		_portletProps._configuration.addProperties(properties);
	}

	public static boolean contains(String key) {
		return _portletProps._configuration.contains(key);
	}

	public static String get(String key) {
		return _portletProps._configuration.get(key);
	}

	public static String get(String key, Filter filter) {
		return _portletProps._configuration.get(key, filter);
	}

	public static String[] getArray(String key) {
		return _portletProps._configuration.getArray(key);
	}

	public static String[] getArray(String key, Filter filter) {
		return _portletProps._configuration.getArray(key, filter);
	}

	public static Properties getProperties() {
		return _portletProps._configuration.getProperties();
	}

	public static void removeProperties(Properties properties) {
		_portletProps._configuration.removeProperties(properties);
	}

	public static void set(String key, String value) {
		_portletProps._configuration.set(key, value);
	}

	private PortletProps() {
		_configuration = ConfigurationFactoryUtil.getConfiguration(
			this.getClass().getClassLoader(), "portlet");
	}

	private static final PortletProps _portletProps = new PortletProps();

	private final Configuration _configuration;

}