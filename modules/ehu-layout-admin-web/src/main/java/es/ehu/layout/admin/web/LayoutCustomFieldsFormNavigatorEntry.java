/**
 * Copyright (c) 2000-present Liferay, Inc. All rights reserved.
 *
 * The contents of this file are subject to the terms of the Liferay Enterprise
 * Subscription License ("License"). You may not use this file except in
 * compliance with the License. You can obtain a copy of the License by
 * contacting Liferay, Inc. See the License for the specific language governing
 * permissions and limitations under the License, including but not limited to
 * distribution rights of the Software.
 *
 *
 *
 */
package es.ehu.layout.admin.web;

import com.liferay.frontend.taglib.form.navigator.FormNavigatorEntry;
import com.liferay.frontend.taglib.form.navigator.constants.FormNavigatorConstants;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.model.Layout;
import com.liferay.portal.kernel.model.User;
import com.liferay.portal.kernel.security.permission.ActionKeys;
import com.liferay.portal.kernel.service.ServiceContext;
import com.liferay.portal.kernel.service.ServiceContextThreadLocal;
import com.liferay.portal.kernel.service.permission.GroupPermissionUtil;
import com.liferay.portal.kernel.theme.ThemeDisplay;
import com.liferay.taglib.util.CustomAttributesUtil;

import javax.servlet.ServletContext;

import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;

/**
 * Se deshabilita el componente "LayoutCustomFieldsFormNavigatorEntry"
 * en el fichero com.liferay.portal.component.blacklist.internal.ComponentBlacklistConfiguration.config
 * se implementa el equivalente con la comprobación en la que se requiere el permiso MANAGE_LAYOUTS
 * para acceder a los campos personalizados de página
 * 
 * @author UPV/EHU
 */

@Component(
	property = "form.navigator.entry.order:Integer=50",
	service = FormNavigatorEntry.class
)
public class LayoutCustomFieldsFormNavigatorEntry extends  BaseLayoutFormNavigatorEntry{

	@Override
	public String getCategoryKey() {
		return FormNavigatorConstants.CATEGORY_KEY_LAYOUT_ADVANCED;
	}

	@Override
	public String getKey() {
		return "custom-fields";
	}

	@Override
	public ServletContext getServletContext() {
		return _servletContext;
	}

	@Override
	public boolean isVisible(User user, Layout layout) {
		boolean hasCustomAttributesAvailable = false;

		try {
			ServiceContext serviceContext =
				ServiceContextThreadLocal.getServiceContext();

			ThemeDisplay themeDisplay = serviceContext.getThemeDisplay();

			/** Comprobamos los permisos **/
			if (GroupPermissionUtil.contains(themeDisplay.getPermissionChecker(), layout.getGroup(), ActionKeys.MANAGE_LAYOUTS)) {
			/** Comprobamos los permisos **/
				long classPK = 0;
	
				if (layout != null) {
					classPK = layout.getPlid();
				}
	
				hasCustomAttributesAvailable =
					CustomAttributesUtil.hasCustomAttributes(
						themeDisplay.getCompanyId(), Layout.class.getName(),
						classPK, null);
			/** Comprobamos los permisos **/
			}
			/** Comprobamos los permisos **/
		}
		catch (Exception exception) {
			if (_log.isDebugEnabled()) {
				_log.debug(exception);
			}
		}

		return hasCustomAttributesAvailable;
	}

	@Override
	protected String getJspPath() {
		return "/layout/custom_fields.jsp";
	}

	private static final Log _log = LogFactoryUtil.getLog(
		LayoutCustomFieldsFormNavigatorEntry.class);

	@Reference(target = "(osgi.web.symbolicname=com.liferay.layout.admin.web)")
	private ServletContext _servletContext;

}

