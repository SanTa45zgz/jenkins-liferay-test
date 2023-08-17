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

package es.ehu.xsl.content.web.internal.util;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.net.URL;
import java.util.Date;
import java.util.concurrent.TimeUnit;

import javax.xml.XMLConstants;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.w3c.dom.Document;
import org.xml.sax.SAXParseException;

import com.liferay.portal.kernel.io.unsync.UnsyncByteArrayOutputStream;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.theme.ThemeDisplay;
import com.liferay.portal.kernel.util.Http;
import com.liferay.portal.kernel.util.HttpUtil;
import com.liferay.portal.kernel.util.StringUtil;

import es.ehu.xsl.content.web.configuration.XSLContentConfiguration;

/**
 * @author UPV/EHU
 */
public class XSLContentUtil {
	
	private static final Log _log = LogFactoryUtil.getLog(XSLContentUtil.class);
	
	public static final String DEFAULT_XML_URL = "/example.xml";

	public static final String DEFAULT_XSL_URL = "/example.xsl";

	public static String replaceUrlTokens(
		ThemeDisplay themeDisplay, String contextPath, String url) {

		return StringUtil.replace(
			url, new String[] {"@portal_url@", "@portlet_context_url@"},
			new String[] {
				themeDisplay.getPortalURL(),
				themeDisplay.getPortalURL() + contextPath
			});
	}

	
	/**
	 * 
	 * @param xslContentConfiguration
	 * @param xmlUrl
	 * @param xslUrl
	 * @return
	 * @throws Exception
	 */
	public static String transform(XSLContentConfiguration xslContentConfiguration, URL xmlUrl, URL xslUrl)
		throws Exception {
		TransformerFactory transformerFactory = getTransformerFactory(xslContentConfiguration);

		DocumentBuilder documentBuilder = getDocumentBuilder(xslContentConfiguration);

		Transformer transformer = transformerFactory.newTransformer(getXslSource(documentBuilder, xslUrl));

		UnsyncByteArrayOutputStream unsyncByteArrayOutputStream = new UnsyncByteArrayOutputStream();

		transformer.transform(getXmlSource(documentBuilder, xmlUrl), new StreamResult(unsyncByteArrayOutputStream));
		
		return unsyncByteArrayOutputStream.toString();
	}

	
	/**
	 * 
	 * @param xslContentConfiguration
	 * @return
	 * @throws Exception
	 */
	protected static DocumentBuilder getDocumentBuilder(XSLContentConfiguration xslContentConfiguration) throws Exception {

		DocumentBuilderFactory documentBuilderFactory = DocumentBuilderFactory.newInstance();

		documentBuilderFactory.setFeature("http://apache.org/xml/features/disallow-doctype-decl", !xslContentConfiguration.xmlDoctypeDeclarationAllowed());
		documentBuilderFactory.setFeature("http://xml.org/sax/features/external-general-entities", xslContentConfiguration.xmlExternalGeneralEntitiesAllowed());
		documentBuilderFactory.setFeature( "http://xml.org/sax/features/external-parameter-entities", xslContentConfiguration.xmlExternalParameterEntitiesAllowed());

		documentBuilderFactory.setNamespaceAware(true);

		return documentBuilderFactory.newDocumentBuilder();
	}

	
	/**
	 * 
	 * @param xslContentConfiguration
	 * @return
	 * @throws Exception
	 */
	protected static TransformerFactory getTransformerFactory(
			XSLContentConfiguration xslContentConfiguration)
		throws Exception {

		TransformerFactory transformerFactory =
			TransformerFactory.newInstance();

		transformerFactory.setFeature(
			XMLConstants.FEATURE_SECURE_PROCESSING,
			xslContentConfiguration.xslSecureProcessingEnabled());
		
		
		return transformerFactory;
	}

	
	/**
	 * 
	 * @param documentBuilder
	 * @param xmlUrl
	 * @return
	 * @throws Exception
	 */
	protected static Source getXmlSource(DocumentBuilder documentBuilder, URL xmlUrl) throws Exception {

	
		try {
			String xml = HttpUtil.URLtoString(xmlUrl);

			
			if (_log.isDebugEnabled()) {
				_log.debug("xml:" + xml);
			}
			// Cuando Gaur está en mantenimiento forzamos que devuelva null para que falle Gaur y así tire de Redis y no actualice el valor en Redis
			if (xml.indexOf("Mantentze lanak - Mantenimiento - Maintenance")>-1) {
				_log.error("GAUR_MANTENIMIENTO " + xmlUrl);
				throw new Exception("GAUR_MANTENIMIENTO");
				//return null;
			}
			
			if (xml.indexOf("<error val=\"")>-1) {
				String message = xml.substring(xml.indexOf("<error val=\""));
				message=message.substring(0,message.indexOf("</error>"));
				_log.error("ERROR_GAUR " +message+ " " + xmlUrl);
				throw new Exception("ERROR_XML_GAUR");
				//return null;
			}
			
					
					
			Document xmlDocument = documentBuilder.parse(new ByteArrayInputStream(xml.getBytes()));
	
			return new DOMSource(xmlDocument);
		}catch(Exception e) {
			_log.error(e.getMessage() +" "+xmlUrl);
			throw e;
			//return null;			
		}
	}

	/**
	 * 
	 * @param documentBuilder
	 * @param xslUrl
	 * @return
	 * @throws Exception
	 */
	protected static Source getXslSource(DocumentBuilder documentBuilder, URL xslUrl) throws Exception {

		String xsl = HttpUtil.URLtoString(xslUrl);

		if (_log.isDebugEnabled()) {
			_log.debug("xsl:" + xsl);
		}
		
		Document xslDocument = documentBuilder.parse(new ByteArrayInputStream(xsl.getBytes()));
		
		return new DOMSource(xslDocument);
	}

}