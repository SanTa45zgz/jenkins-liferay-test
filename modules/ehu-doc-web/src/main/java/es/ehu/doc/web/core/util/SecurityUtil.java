package es.ehu.doc.web.core.util;

import java.util.List;

import org.apache.chemistry.opencmis.client.api.Document;
import org.apache.chemistry.opencmis.client.api.Folder;

import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
//import com.liferay.portal.security.auth.PrincipalException;
import com.liferay.portal.kernel.security.auth.PrincipalException;


public class SecurityUtil {

	private static Log _log = LogFactoryUtil.getLog(SecurityUtil.class);

	
	public static void check(Folder folder, String rootPath) throws PrincipalException {
		
		if (rootPath != null && rootPath.endsWith("/")) {
			rootPath = rootPath.substring(0, rootPath.length() - 1);
		}
		
		String path =  folder.getPath();
		if (path != null && path.startsWith(rootPath)) {
			return;
		}
		
		throw new PrincipalException();
	}

	public static void check(Document document, String rootPath) throws PrincipalException {
		
		if (rootPath != null && rootPath.endsWith("/")) {
			rootPath = rootPath.substring(0, rootPath.length() - 1);
		}
		
		List<String> paths =  document.getPaths();
		for (String path : paths) {
			if (path != null && path.startsWith(rootPath)) {
				return;
			}
		}
		
		throw new PrincipalException();
	}

}
