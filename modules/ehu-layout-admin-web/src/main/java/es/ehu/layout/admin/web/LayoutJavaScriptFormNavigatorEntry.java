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
import com.liferay.portal.kernel.model.Layout;
import com.liferay.portal.kernel.model.User;
import com.liferay.portal.kernel.util.HashMapDictionaryBuilder;
import com.liferay.portal.kernel.util.PortalUtil;

import javax.servlet.ServletContext;

import com.liferay.portal.util.PropsValues;

import org.osgi.framework.BundleContext;
import org.osgi.framework.ServiceRegistration;
import org.osgi.service.component.annotations.Activate;
import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Deactivate;
import org.osgi.service.component.annotations.Reference;

/**
 * @author UPV/EHU
 * Sólo onmiadmin puede ver la sección javascript
 * Se deshabilita el componente "LayoutJavaScriptFormNavigatorEntry"
 * en el fichero com.liferay.portal.component.blacklist.internal.ComponentBlacklistConfiguration.config
 * se implementa el equivalente con la comprobación para que solo onmiadmin pueda verlo
 */
@Component(service = {})
public class LayoutJavaScriptFormNavigatorEntry
	extends BaseLayoutFormNavigatorEntry {

	@Override
	public String getCategoryKey() {
		return FormNavigatorConstants.CATEGORY_KEY_LAYOUT_ADVANCED;
	}

	@Override
	public String getKey() {
		return "javascript";
	}

	@Override
	public ServletContext getServletContext() {
		return _servletContext;
	}

	@Activate
	protected void activate(BundleContext bundleContext) {
		boolean enableJavaScript =
			PropsValues.
				FIELD_ENABLE_COM_LIFERAY_PORTAL_KERNEL_MODEL_LAYOUT_JAVASCRIPT;

		if (!enableJavaScript) {
			return;
		}

		_serviceRegistration = bundleContext.registerService(
			(Class<FormNavigatorEntry<?>>)(Class<?>)FormNavigatorEntry.class,
			this,
			HashMapDictionaryBuilder.<String, Object>put(
				"form.navigator.entry.order", 90
			).build());
	}

	@Deactivate
	protected void deactivate() {
		if (_serviceRegistration != null) {
			_serviceRegistration.unregister();
		}
	}

	@Override
	protected String getJspPath() {
		return "/layout/javascript.jsp";
	}
	
	/** Comprobamos los permisos **/
	@Override
	public boolean isVisible(User user, Layout layout) {
		if (PortalUtil.isOmniadmin(user)) {
			return super.isVisible(user, layout);
		} else {
			return false;
		}
	}
	/** Comprobamos los permisos **/

	private ServiceRegistration<FormNavigatorEntry<?>> _serviceRegistration;

	@Reference(target = "(osgi.web.symbolicname=com.liferay.layout.admin.web)")
	private ServletContext _servletContext;

}