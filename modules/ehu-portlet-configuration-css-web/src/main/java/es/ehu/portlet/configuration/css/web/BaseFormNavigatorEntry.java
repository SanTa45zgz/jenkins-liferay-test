package es.ehu.portlet.configuration.css.web;

import com.liferay.petra.string.StringPool;
import com.liferay.portal.kernel.language.LanguageUtil;
import com.liferay.portal.kernel.model.Layout;
import com.liferay.portal.kernel.model.User;
import com.liferay.portal.kernel.security.permission.PermissionThreadLocal;
import com.liferay.portal.kernel.service.ServiceContext;
import com.liferay.portal.kernel.service.ServiceContextThreadLocal;
import com.liferay.frontend.taglib.form.navigator.BaseJSPFormNavigatorEntry;

import com.liferay.portal.kernel.theme.ThemeDisplay;

import java.util.Locale;

import javax.servlet.ServletContext;

import es.ehu.portlet.configuration.css.web.constants.PortletConfigurationCSSConstants;

/**
 * 
 * @author UPV/EHU
 *
 */
public abstract class BaseFormNavigatorEntry extends BaseJSPFormNavigatorEntry<Layout> {
	
	@Override
	public String getCategoryKey() {
		return StringPool.BLANK;
	}

	@Override
	public String getFormNavigatorId() {
		return PortletConfigurationCSSConstants.FORM_NAVIGATOR_ID;
	}

	@Override
	public String getLabel(Locale locale) {
		return LanguageUtil.get(locale, getKey());
	}


	@Override
	public boolean isVisible(User user, Layout formModelBean) {

		ServiceContext serviceContext =
				ServiceContextThreadLocal.getServiceContext();
		
		ThemeDisplay themeDisplay = serviceContext.getThemeDisplay();
		boolean isVisible = false;
		long groupId = themeDisplay.getScopeGroupId();
		long userId = themeDisplay.getRealUserId();
		boolean isGroupAdmin = PermissionThreadLocal.getPermissionChecker().isGroupAdmin(groupId);
		boolean isOmniadmin = PermissionThreadLocal.getPermissionChecker().isOmniadmin();
		
		if (isGroupAdmin || isOmniadmin) {
			System.out.println("isGroupAdmin: " + isGroupAdmin  + " ,isOmniadmin: " + isOmniadmin + ", userId:" + userId + ", groupId:" + groupId);
			isVisible = true;
		}
		
		return isVisible;

	}

}