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
import com.liferay.portal.kernel.model.Group;
import com.liferay.portal.kernel.model.Layout;
import com.liferay.portal.kernel.model.User;
import com.liferay.portal.kernel.util.PortalUtil;

import javax.servlet.ServletContext;

import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;

/**
 * @author UPV/EHU
 * Se deshabilita el componente "LayoutCustomizationSettingsFormNavigatorEntry"
 * en el fichero com.liferay.portal.component.blacklist.internal.ComponentBlacklistConfiguration.config
 * se implementa el equivalente con la comprobación para que solo onmiadmin puede ver parámetros personalizados
 */
@Component(
	property = "form.navigator.entry.order:Integer=60",
	service = FormNavigatorEntry.class
)
public class LayoutCustomizationSettingsFormNavigatorEntry
	extends BaseLayoutFormNavigatorEntry {

	@Override
	public String getCategoryKey() {
		return FormNavigatorConstants.CATEGORY_KEY_LAYOUT_ADVANCED;
	}

	@Override
	public String getKey() {
		return "customization-settings";
	}

	@Override
	public ServletContext getServletContext() {
		return _servletContext;
	}

	@Override
	public boolean isVisible(User user, Layout layout) {
		/** Comprobamos los permisos **/
		if (PortalUtil.isOmniadmin(user)) {
		/** Comprobamos los permisos **/
			Group group = layout.getGroup();
	
			if (group == null) {
				_log.error("Unable to display form for customization settings");
			}
	
			if (layout.isTypeAssetDisplay() || layout.isTypeContent()) {
				return false;
			}
	
			if (!group.isUser() && layout.isTypePortlet()) {
				return true;
			}
		/** Comprobamos los permisos **/
		}
		/** Comprobamos los permisos **/
		return false;
	}

	@Override
	protected String getJspPath() {
		return "/layout/customization_settings.jsp";
	}

	private static final Log _log = LogFactoryUtil.getLog(
		LayoutCustomizationSettingsFormNavigatorEntry.class);

	@Reference(target = "(osgi.web.symbolicname=com.liferay.layout.admin.web)")
	private ServletContext _servletContext;

}