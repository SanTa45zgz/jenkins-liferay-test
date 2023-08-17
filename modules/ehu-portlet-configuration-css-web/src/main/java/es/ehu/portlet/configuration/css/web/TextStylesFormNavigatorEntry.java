package es.ehu.portlet.configuration.css.web;

import com.liferay.frontend.taglib.form.navigator.FormNavigatorEntry;
import com.liferay.portal.kernel.model.Layout;
import com.liferay.portal.kernel.model.User;

import javax.servlet.ServletContext;

import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;

import es.ehu.portlet.configuration.css.web.constants.PortletConfigurationCSSConstants;


/**
 * 
 * @author UPV/EHU
 *
 */
@Component(
	property = "form.navigator.entry.order:Integer=100",
	service = FormNavigatorEntry.class
)
public class TextStylesFormNavigatorEntry extends BaseFormNavigatorEntry {

	@Override
	public String getCategoryKey() {
		return PortletConfigurationCSSConstants.CATEGORY_KEY_TEXT_STYLES;
	}

	@Override
	public String getKey() {
		return "text-styles";
	}

	@Override
	public ServletContext getServletContext() {
		return _servletContext;
	}

	@Override
	protected String getJspPath() {
		return "/text_styles.jsp";
	}

	@Override
	public boolean isVisible(User user, Layout formModelBean) {
		boolean isVisible =  super.isVisible(user, formModelBean);
		System.out.println("TextStylesFormNavigatorEntry isVisible:" + isVisible);
		return isVisible;
	}
	
	@Reference(
		target = "(osgi.web.symbolicname=com.liferay.portlet.configuration.css.web)"
	)
	private ServletContext _servletContext;

}