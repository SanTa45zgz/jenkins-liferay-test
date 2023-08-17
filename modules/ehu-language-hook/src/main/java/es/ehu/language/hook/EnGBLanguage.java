package es.ehu.language.hook;

import java.util.Enumeration;
import java.util.ResourceBundle;

import org.osgi.service.component.annotations.Component;

import com.liferay.portal.kernel.language.UTF8Control;

/**
 * @author UPV/EHU
 */
@Component(
	property = { "language.id=en_GB" },
	service = ResourceBundle.class
)
public class EnGBLanguage extends ResourceBundle {
	ResourceBundle bundle = ResourceBundle.getBundle("content.Language_en_GB", UTF8Control.INSTANCE);

	@Override
	protected Object handleGetObject(String key) {
		return bundle.getObject(key);
	}

	@Override
	public Enumeration<String> getKeys() {
		return bundle.getKeys();
	}
}