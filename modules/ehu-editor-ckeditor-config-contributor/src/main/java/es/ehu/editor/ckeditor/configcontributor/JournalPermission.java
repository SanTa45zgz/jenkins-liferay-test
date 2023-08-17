package es.ehu.editor.ckeditor.configcontributor;

import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;

import com.liferay.journal.constants.JournalConstants;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.model.Group;
import com.liferay.portal.kernel.security.permission.PermissionChecker;
import com.liferay.portal.kernel.security.permission.resource.PortletResourcePermission;

@Component(immediate = true, service = {})
public class JournalPermission {

	public static void check(PermissionChecker permissionChecker, Group group, String actionId) throws PortalException {
		_portletResourcePermission.check(permissionChecker, group, actionId);
	}

	public static boolean contains(PermissionChecker permissionChecker, Group group, String actionId) {
		return _portletResourcePermission.contains(permissionChecker, group, actionId);
	}

	public static boolean contains(PermissionChecker permissionChecker, long groupId, String actionId) {
		return _portletResourcePermission.contains(permissionChecker, groupId, actionId);
	}

	@Reference(
		target = "(resource.name=" + JournalConstants.RESOURCE_NAME + ")",
		unbind = "-"
	)
	protected void setPortletResourcePermission(PortletResourcePermission portletResourcePermission) {
		_portletResourcePermission = portletResourcePermission;
	}

	private static PortletResourcePermission _portletResourcePermission;

}
