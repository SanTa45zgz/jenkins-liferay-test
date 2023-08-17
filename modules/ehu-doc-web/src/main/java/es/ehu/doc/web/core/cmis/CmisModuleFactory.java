package es.ehu.doc.web.core.cmis;

import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;

import es.ehu.doc.web.core.cmis.alfresco.AlfrescoCmis10Module;
import es.ehu.doc.web.core.cmis.alfresco.AlfrescoCmis11Module;


/**
 * para la logica dependiente del proveedor de cmis
 *
 */
public class CmisModuleFactory {

	private static Log _log = LogFactoryUtil.getLog(CmisModuleFactory.class);

	// module Ids
	public static final String REPO_TYPE_OTHER = "other";
	public static final String REPO_TYPE_ALFRESCO_CMIS_10 = "alfresco-cmis-10";
	public static final String REPO_TYPE_ALFRESCO_CMIS_11 = "alfresco-cmis-11";
	
	
	
	public static CmisModule getModule(String moduleId) {
		
		if (moduleId != null && moduleId.equals(REPO_TYPE_ALFRESCO_CMIS_10)) {
			_log.debug("using " + AlfrescoCmis10Module.class.getName());
			return new AlfrescoCmis10Module(); 
		} else if (moduleId != null && moduleId.equals(REPO_TYPE_ALFRESCO_CMIS_11)) {
			_log.debug("using " + AlfrescoCmis11Module.class.getName());
			return new AlfrescoCmis11Module();
		} else {
			_log.debug("using " + DefaultCmisModule.class.getName());
			return new DefaultCmisModule();
		}
		
	}

}
