package es.ehu.doc.web.core.util;

import java.util.List;

import org.apache.chemistry.opencmis.client.api.CmisObject;

import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
//import com.liferay.portal.theme.ThemeDisplay;
import com.liferay.portal.kernel.theme.ThemeDisplay;

import groovy.lang.Binding;
import groovy.lang.GroovyShell;

public class GroovyUtil {

	
	private static Log _log = LogFactoryUtil.getLog(GroovyUtil.class);


	public static String process(List<CmisObject> objects, String script, ThemeDisplay themeDisplay) {
		
		// Case Sensitive
		String html = "";
	
		String aux = "import org.apache.chemistry.opencmis.commons.*;"
				+ "import org.apache.chemistry.opencmis.commons.data.*;"
				+ "import org.apache.chemistry.opencmis.commons.enums.*;"
				+ "import org.apache.chemistry.opencmis.client.api.*;"
				+ "import com.liferay.portal.kernel.theme.ThemeDisplay;" 
				+ "StringBuffer html = new StringBuffer();"
				+ "List<org.apache.chemistry.opencmis.client.api.CmisObject> listaObjetos = objects;"
				+ "com.liferay.portal.kernel.theme.ThemeDisplay themeDisplay = td;";

		aux = aux + script;

		aux = aux + "\nreturn html"; //mejor añadir un retorno de carro en el return para que no se pegue con las lineas anteriores editadas por el usuario

		Binding binding = new Binding();
		binding.setVariable("objects", objects);
		binding.setVariable("td", themeDisplay);
		GroovyShell shell = new GroovyShell(binding);
		Object value = shell.evaluate(aux);
		
		html = ((StringBuffer) value).toString();
		
		return html;
	}

}
