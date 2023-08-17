package es.ehu.doc.web.core.cmis.alfresco;

import java.util.HashMap;
import java.util.Map;

import org.apache.chemistry.opencmis.commons.SessionParameter;

import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;


public class AlfrescoCmis10Module extends AlfrescoCmisModule {

	private static Log _log = LogFactoryUtil.getLog(AlfrescoCmis10Module.class);
	
	
	public Map<String, String> getAdditionalSessionParameters() {

		Map<String, String> parameters = new HashMap<String, String>();
		// Set the alfresco object factory
		parameters.put(SessionParameter.OBJECT_FACTORY_CLASS, "org.alfresco.cmis.client.impl.AlfrescoObjectFactoryImpl");
		
		return parameters;
	}

}

