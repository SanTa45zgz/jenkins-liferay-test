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

package es.ehu.xsl.content.web.internal.display.context;

import com.liferay.petra.string.StringPool;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.module.configuration.ConfigurationException;
import com.liferay.portal.kernel.theme.PortletDisplay;
import com.liferay.portal.kernel.theme.ThemeDisplay;
import com.liferay.portal.kernel.util.GetterUtil;
import com.liferay.portal.kernel.util.HtmlUtil;
import com.liferay.portal.kernel.util.PortalUtil;
import com.liferay.portal.kernel.util.PropsUtil;
import com.liferay.portal.kernel.util.StringUtil;
import com.liferay.portal.kernel.util.Validator;
import com.liferay.portal.kernel.util.WebKeys;

import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URL;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import java.util.regex.Pattern;
import java.util.zip.GZIPInputStream;
import java.util.zip.GZIPOutputStream;

import javax.servlet.ServletRequest;
import javax.servlet.http.HttpServletRequest;

import es.ehu.xsl.content.web.configuration.XSLContentConfiguration;
import es.ehu.xsl.content.web.configuration.XSLContentPortletInstanceConfiguration;
import es.ehu.xsl.content.web.internal.util.XSLContentUtil;
import redis.clients.jedis.Jedis;

/**
 * @author UPV/EHU
 */
public class XSLContentDisplayContext {
	
	private static final Log _log = LogFactoryUtil.getLog(XSLContentDisplayContext.class);
	private static int threads = 0;
	private final ThemeDisplay _themeDisplay;
	private final XSLContentConfiguration _xslContentConfiguration;
	private final XSLContentPortletInstanceConfiguration _xslContentPortletInstanceConfiguration;
	private String _content;
	private String _xmlUrl;
	

	//aplicación asíncrona de reglas XSLT
	private ExecutorService executor = Executors.newSingleThreadExecutor();
	public Future<String> transform(String xmlUrl, String xslUrl) { return executor.submit(() -> {
			return  XSLContentUtil.transform(_xslContentConfiguration, new URL(xmlUrl), new URL(xslUrl));
	 });
		//fin aplicación asíncrona de reglas XSLT
	}
	/**
	 * 
	 * @param httpServletRequest
	 * @param xslContentConfiguration
	 * @throws ConfigurationException
	 */
	public XSLContentDisplayContext(HttpServletRequest httpServletRequest, XSLContentConfiguration xslContentConfiguration) throws ConfigurationException {
		_xslContentConfiguration = xslContentConfiguration;
		_themeDisplay = (ThemeDisplay)httpServletRequest.getAttribute(WebKeys.THEME_DISPLAY);
		final PortletDisplay portletDisplay = _themeDisplay.getPortletDisplay();
		_xslContentPortletInstanceConfiguration = portletDisplay.getPortletInstanceConfiguration(XSLContentPortletInstanceConfiguration.class);
	}

	
	/**
	 * 
	 * @param servletRequest
	 * @return
	 * @throws Exception
	 */
	public String getContent(ServletRequest servletRequest) throws Exception {
		if (_content != null) {
			return _content;
		}

		HttpServletRequest httpServletRequest = (HttpServletRequest)servletRequest;

		String contextPath = httpServletRequest.getContextPath();

		_xmlUrl = XSLContentUtil.replaceUrlTokens(_themeDisplay, contextPath, getXmlUrl(httpServletRequest));

		String xslUrl = XSLContentUtil.replaceUrlTokens(_themeDisplay, contextPath, getXslUrl(httpServletRequest));
				
		if (_log.isDebugEnabled()) {
			_log.debug("xmlUrl final: " + _xmlUrl);
			_log.debug("xslUrl final: " + xslUrl);
		}
		
		try {
			_content = getRedisContent(_xmlUrl, xslUrl);
		} catch (Exception e) {
			_log.error(e.getMessage() + _xmlUrl);
			throw new Exception (_themeDisplay.getURLCurrent() + " --- " + getXmlUrl(httpServletRequest));
			
			
		}

		if (_log.isDebugEnabled()) {
			_log.debug("_content: " + _content);
		}
		
		return _content;
	}

	
	
	/**
	 * 
	 * @return
	 */
	public XSLContentPortletInstanceConfiguration getXSLContentPortletInstanceConfiguration() {
		return _xslContentPortletInstanceConfiguration;
	}

	/*------------- Redis -----------------*/
	// Entorno de ejecucion UPV/EHU
	private static final String host = PropsUtil.get("ehu.host");
	
	private static final String redisServer = PropsUtil.get("redis." + host + ".server");
	private static final int redisDefaultTimeout = Integer.parseInt(PropsUtil.get("redis." + host + ".defaultTimeout"));
	private static final int redisShortTimeout = Integer.parseInt(PropsUtil.get("redis." + host + ".shortTimeout"));
	private static final int redisMaxTime = Integer.parseInt(PropsUtil.get("redis." + host + ".maxTime"));
	private static final String redisNoCached = PropsUtil.get("redis." + host + ".noCached");
	private static final String redisforceCached = "(.*)xx(.*)";//PropsUtil.get("redis." + host + ".forceCached");
	private static final String redisShortCache = PropsUtil.get("redis." + host + ".shortCache");
	private static final boolean useGzip = PropsUtil.get("redis." + host + ".useGzip").equals("1");
	private static final int redisTimeout = Integer.parseInt(PropsUtil.get("redis." + host + ".redisTimeout"));
	private static final int transformTimeout = Integer.parseInt(PropsUtil.get("redis." + host + ".transformTimeout"));
	
	

	/**
	 * Comprobar disponibilidad de REDIS: redisIsReady	
	 * @param xmlUrl
	 * @param xslUrl
	 * @return
	 * @throws Exception
	 */
	protected String getRedisContent(String xmlUrl, String xslUrl) throws Exception {
		String content = null;
		long startTime = System.currentTimeMillis();
		String origen = ""; //variable para mostrar datos en el log
		Jedis jedis = null;
		boolean redisIsReady = false;
		boolean estaEnRedis = false;
		boolean bForcedCache = xmlUrl.matches(redisforceCached);
		if (bForcedCache) origen+="FORCE_CACHED>";
		
		try {
			jedis = new Jedis(redisServer, 6379, redisTimeout);
			estaEnRedis = jedis.exists(xmlUrl.getBytes());
			//origen += "MIRO_REDIS"; //si no lo modificamos el origen es REDIS
			redisIsReady = true;
		} catch (Exception e) {
			origen += "ERROR_REDIS";
		}

		boolean haCaducado = false; //calculo si el dato en REDIS ha superado el tiempo de caducidad
		int caducidad=0;
		
		if (estaEnRedis) { 
			origen += "ESTA_EN_REDIS";
			long edad = redisMaxTime - jedis.ttl(xmlUrl.getBytes()); //tiempo que lleva la entrada en redis
			caducidad = (xmlUrl.matches(redisShortCache))?redisShortTimeout:redisDefaultTimeout; //tiempo en el que caducará
			haCaducado = (edad>caducidad);
			String ttl =
				(caducidad-edad>3600*24)?(int)((caducidad-edad)/3600/14)+"d":
				(caducidad-edad>3600)?(int)((caducidad-edad)/3600)+"h":
				(caducidad-edad>60)?(int)((caducidad-edad)/60)+"m":
				(caducidad-edad)+"s";
			
		}else {
			if (redisIsReady) origen += "NO_EN_REDIS";
		}
		
		boolean errorAlLeerDeGaur = false;
		// SI el dato no cumple la expresión regular de forceCached 
		// Y
		//((no está en REDIS) o (ha caducado en REDIS) o (redis fuera de linea) o (la URL cumple la expresión regular para noCache)) 
		// el Origen es GAUR		
		if ((!bForcedCache) && (!estaEnRedis || haCaducado || !redisIsReady || xmlUrl.matches(redisNoCached))) {
			if (haCaducado) origen+=">REDIS_CADUCADO("+((caducidad>3600)?(int)((caducidad)/3600)+"h":(caducidad>60)?(int)((caducidad)/60)+"m":(caducidad)+"s")+")";
			
			boolean canceled = false;
			boolean threadLimit = false;
			try {
				//Lectura original:
				//content = XSLContentUtil.transform(_xslContentConfiguration, new URL(xmlUrl), new URL(xslUrl));

				threads++; //cuenta los threas simultáneos que esperan a GAUR.
				
				if ((threads>5) && estaEnRedis) { //si hay más de 5 threads activos esperando a GAUR y el dato está en REDIS, devuelvo lo que hay en REDIS
					origen+=">5_THREADS";
					threadLimit=true;
					_log.error("MAX_THREADS");
					throw new Exception(_themeDisplay.getURLCurrent() + " --- " + xmlUrl);
				}
				Future<String> future = this.transform(xmlUrl, xslUrl);
				
				int timeout=(estaEnRedis)?transformTimeout:transformTimeout*5; //el timeout es *5 si el dato NO está en redis
				
				while(!future.isDone()) {
					
				    if (System.currentTimeMillis()-startTime>timeout) { //si vence timeout cancelo transformación
				    	origen+=">TIMEOUT_GAUR";
				    	canceled = future.cancel(true);
				    	throw new Exception(_themeDisplay.getURLCurrent() + " --- " + xmlUrl);
				    }
				    Thread.sleep(40);
				}
				//ha ido bien la lectura desde GAUR
				origen += ">GAUR("+(System.currentTimeMillis()-startTime)+"ms)";

				content=future.get();
				if (content==null) {
					origen+=">XML_ERROR";
					throw new Exception(_themeDisplay.getURLCurrent() + " --- " + xmlUrl);					
				}
				
				// ¿Procesamos los saltos de línea que vienen de GAUR?
				Pattern endOfLine = Pattern.compile("\r\n");
				content = endOfLine.matcher(content).replaceAll("<br/>");
				
				if ((content.indexOf("xmlns:ehu")<0) && (content.indexOf("Please configure this application")<0)) {
					throw new Exception(_themeDisplay.getURLCurrent() + " --- " + xmlUrl);
				}
				
				if ((content!=null) && (redisIsReady)) {
					jedis.setex(xmlUrl.getBytes(), redisMaxTime, (useGzip?CachedTransform.compress(content):content.getBytes()));
				}
					
				
				
			} catch (Exception e) { //ha fallado la lectura desde GAUR
				errorAlLeerDeGaur = true;
				if ((!canceled) && (!threadLimit)) origen+=">ERROR_GAUR";
			}
			if (threads>0) threads--; //cuenta los threas simultáneos que acceden a GAUR
			// Si la ejecución se interrumpe antes de la línea anterior llevaremos mal la cuenta, posible solución de vez en cuando ir restando > if ((Math.random()<0,01) && (threads>0)) i--;
		}

		// Si ha habido error al leer de gaur (timeout, máximo de threads de lectura, o error en datos) o estando en redis no tenemos content
		if (estaEnRedis && ((content == null) || errorAlLeerDeGaur)) {	
			origen += ">REDIS";
			try {
				byte[] bContent = jedis.get(xmlUrl.getBytes());
				if (CachedTransform.isCompressed(bContent)) {
					content = CachedTransform.decompress(bContent); 
				} else {
					content = new String(bContent);
				}
			} catch (Exception e) {
				origen += ">NULL";
				content = null;
				_log.error(origen+" "+(System.currentTimeMillis()-startTime)+" "+threads+" "+_themeDisplay.getURLCurrent()+" "+xmlUrl);
				 throw new Exception (_themeDisplay.getURLCurrent() + " --- " + xmlUrl); //Finalmente, si no he sido capaz de solventarlo elevo la excepción > se muestra error en la web.
			}
		} 
		
		String log_message=origen+" "+(System.currentTimeMillis()-startTime)+" "+threads+" "+_themeDisplay.getURLCurrent()+" "+xmlUrl;
		if (content==null) {
			_log.error(log_message);  // No ha podido ser generado
			throw new Exception(_themeDisplay.getURLCurrent() + " --- " + xmlUrl);
		}else if (errorAlLeerDeGaur) {
			_log.warn(log_message); // Pese a error en GAUR había una copia en redis
		} else {
			_log.info(log_message); // se ha generado correctamente
		}
		return content;
	}
	
	
	
	/**
	 * 
	 * @param request
	 * @return
	 */
	protected String getXslUrl(final HttpServletRequest request) {
		/*------------- URLs ----------*/		 
				 
		// Lectura de XSLs local (sin llegar a los servidores web)
		String baseUrl = "http://localhost:8080/o/ehu-xsl-content-web/";



		/*------------- Preferencias  ----------*/
		String xslUrl = _xslContentPortletInstanceConfiguration.xslUrl();
		
		
		if (Validator.isNotNull(xslUrl)) {
			xslUrl = xslUrl.replaceFirst("://localhost:8080/html/portlet/xsl_content/", "://localhost:8080/o/ehu-xsl-content-web/");
		}

		// Identificativo de la aplicacion seleccionada (propia de la customizacion UPV/EHU)  
		String applicationId = _xslContentPortletInstanceConfiguration.applicationId();
		

		/*------------- Aplicacion seleccionada  ----------*/
		if((Validator.isNotNull(applicationId)) || (!applicationId.equals(StringPool.BLANK)) ) {
			//XSL propia de cada aplicacion
			xslUrl = baseUrl + applicationId + "/" + applicationId + ".xsl";
			
			// alumni tiene un tratamiento especial. Hay que standarizarlo, pero mientras tanto...
		  	if( applicationId.equals( "alumni" ) ) {
		  		// Idioma de navegacion
				String paramLanguage = _themeDisplay.getLocale().toString().substring(0,2);
		  		
		  		xslUrl = StringUtil.replace( xslUrl, "/" + applicationId + ".xsl", "/" + applicationId + StringPool.UNDERLINE + paramLanguage + ".xsl" );		  	
		  	}
		} 
		/*------------- Aplicacion NO seleccionada  ----------*/
		// SOLO se muestra el mensaje de configuracion inicial al usuario con permisos
		else {
			request.setAttribute(WebKeys.PORTLET_CONFIGURATOR_VISIBILITY, Boolean.TRUE);	
		}

		return xslUrl;


	}
	
	
	/**
	 * 
	 * @param request
	 * @return
	 */
	protected String getXmlUrl(final HttpServletRequest request) {
		 
		// Entorno de ejecucion UPV/EHU
		String host = PropsUtil.get("ehu.host");

		/*------------- URLs ----------*/		 
				 
		// Url asociada al entorno de ejecucion
		//String protocol = _themeDisplay.getProtocol();
		String protocol = "https";
//		String execUrl = protocol + "://" + PropsUtil.get(host + ".url");
				 
		// Url externa
		String extUrl = StringPool.BLANK;

		// Urls de las distintas fuentes de datos (gaur,app...)
		String gaurUrl = protocol + "://" + PropsUtil.get("gaur." + host + ".url");
		
		String appUrl = protocol + "://" + PropsUtil.get("app." + host + ".url");

		// Lectura de XSLs local (sin llegar a los servidores web)
		//String baseUrl = "http://localhost:8080/html/portlet/xsl_content/";
		String baseUrl = "http://localhost:8080/o/ehu-xsl-content-web/";

		/*------------- Redis -----------------*/
//		String redisServer = PropsUtil.get("redis." + host + ".server");
//		int redisDefaultTimeout = Integer.parseInt(PropsUtil.get("redis." + host + ".defaultTimeout"));
//		int redisShortTimeout = Integer.parseInt(PropsUtil.get("redis." + host + ".shortTimeout"));
//		int redisMaxTime = Integer.parseInt(PropsUtil.get("redis." + host + ".maxTime"));
//		String redisNoCached = PropsUtil.get("redis." + host + ".noCached");
//		String redisShortCache = PropsUtil.get("redis." + host + ".shortCache");
//		boolean useGzip = PropsUtil.get("redis." + host + ".useGzip").equals("1");



		/*------------- Aplicaciones ----------*/	

		// Lista de aplicaciones integrables 
//		String[] apps = PropsUtil.getArray("applications");

		/*------------- Parametros  ----------*/	

		// Idioma de navegacion
		String paramLanguage = _themeDisplay.getLocale().toString().substring(0,2); 

		// Parametro/s de busqueda recuperados del properties
		String searchParam = StringPool.BLANK;
		String[] searchParams = null;

		//Parametro/s de configuracion recuperados del properties
		String configParam = StringPool.BLANK;
		String[] configParams = null;

		// Parametro/s de busqueda recibido por GET
		String searchParamGet = StringPool.BLANK;
		HttpServletRequest httpReq = PortalUtil.getOriginalServletRequest(request);

		/*------------- Preferencias  ----------*/
		String xmlUrl = _xslContentPortletInstanceConfiguration.xmlUrl();
		String xslUrl = _xslContentPortletInstanceConfiguration.xslUrl();

		// Identificativo de la aplicacion seleccionada (propia de la customizacion UPV/EHU)  
		String applicationId = _xslContentPortletInstanceConfiguration.applicationId();
		
		
		//fvcalderon001:Mientras se migran los ws a lo nuevo
		if (applicationId.equals("plew0040-offer") || applicationId.equals("plew0030-offer")){
			gaurUrl = protocol + "://" + PropsUtil.get("gaur.new." + host + ".url");
		}
		//fvcalderon001:Mientras se migran los ws a lo nuevo
		
		if (_log.isDebugEnabled()) {
			_log.debug("applicationId: " + applicationId);
		}
		
		// Parametros de configuracion almacenados al configurar aplicacion (propia de la customizacion UPV/EHU)
		String[] configParamsPref = _xslContentPortletInstanceConfiguration.configParams();
		if (configParamsPref==null) configParamsPref = new String[0];
			
		String configParamsPrefStr = StringUtil.merge(configParamsPref);
		String configParamPref = StringPool.BLANK;

		/*------------- Aplicacion seleccionada  ----------*/

		if((Validator.isNotNull(applicationId)) || (!applicationId.equals(StringPool.BLANK)) ) {

			/*------------- Urls  ----------*/
			
			if ( PropsUtil.get(applicationId + ".src").equals("gaur") ) {
				extUrl = gaurUrl;
			} else if ( PropsUtil.get(applicationId + ".src").equals("app") ) {
				extUrl = appUrl;
			}	
			
			//XSL propia de cada aplicacion
			xslUrl = baseUrl + applicationId + "/" + applicationId + ".xsl";
			
			
			
			// Url Base de XMLs (URL de la fuente de datos + Proceso que genera el XML)
			xmlUrl = extUrl + PropsUtil.get(applicationId + ".xml");
			
			
			// ----------
		  	// Nuevo grado 
		  	// ----------
		  	if (applicationId.equals("egr")) {
		  		
		  		// Resumen
		  		if ( (configParamsPrefStr.contains("10,act")) || (configParamsPrefStr.contains("10,fut")) ){
		 			xmlUrl += "/damePresentacion";
		 		}
		  		// Precios
		  		else if ( (configParamsPrefStr.contains("20,act")) || (configParamsPrefStr.contains("20,fut")) ){
		 			xmlUrl += "/damePrecios";
		 		}
		  		// Menciones
		  	 	else if ( (configParamsPrefStr.contains("30,act")) || (configParamsPrefStr.contains("30,fut")) ){
		  	 		xmlUrl += "/dameMenciones";
		  		}
		  		// Cursos
		  		else if ( (configParamsPrefStr.contains("40,act")) || (configParamsPrefStr.contains("40,fut")) ){
		 			xmlUrl += "/dameCursos";
				}
		  		// Profesorado
		 		else if ( (configParamsPrefStr.contains("50,act")) || (configParamsPrefStr.contains("50,fut")) ){
		 			xmlUrl += "/dameProfesorado";
				}
		  		// Competencias 
		  	 	else if ( (configParamsPrefStr.contains("60,act")) || (configParamsPrefStr.contains("60,fut")) ){
		  	 		xmlUrl += "/dameCompetencias";
		  		}
		  		// Recursos 
		  	 	else if ( (configParamsPrefStr.contains("70,act")) || (configParamsPrefStr.contains("70,fut")) ){
		  	 		xmlUrl += "/dameRecursos";
		  		}
		  		// Requisitos 
		  	 	else if ( (configParamsPrefStr.contains("80,act")) || (configParamsPrefStr.contains("80,fut")) ){
		  	 		xmlUrl += "/dameRequisitosObtencion";
		  		}
		  	}

		 	// ----------
		   	// Nuevo master 
		   	// ----------
		   	if (applicationId.equals("master-epg")) {
		   		if ( configParamsPrefStr.startsWith("1001,") || configParamsPrefStr.startsWith("1010,") || configParamsPrefStr.startsWith("1013,") || configParamsPrefStr.startsWith("1016,")){
		  			xmlUrl += "/damePresentacion";
		  		}
		   		else if ( configParamsPrefStr.startsWith("1002,") ){
		  			xmlUrl += "/damePerfilAcceso";
		  		}
		   		else if ( configParamsPrefStr.startsWith("1003,") || configParamsPrefStr.startsWith("1006,") ){
		  			xmlUrl += "/damePrograma";
		 		}
		   		else if ( configParamsPrefStr.startsWith("1004,") ){
		  			xmlUrl += "/dameAsignatura";
		 		}
		   		else if ( configParamsPrefStr.startsWith("1005,") ){
		  			xmlUrl += "/dameMetodologia";
		 		}
		  		else if ( configParamsPrefStr.startsWith("1007,") || configParamsPrefStr.startsWith("1008,") ){
		  			xmlUrl += "/dameProfesorado";
		 		}
		   	 	else if ( configParamsPrefStr.startsWith("1009,") ){
		   	 		xmlUrl += "/dameOrganizacion";
		   		}
		   	 	else if ( (configParamsPrefStr.startsWith("1011,")) || (configParamsPrefStr.startsWith("1012,")) ){
		   	 		xmlUrl += "/dameRecursos";
		   		}
		   	 	else if ( configParamsPrefStr.startsWith("1014,") ){
			 		xmlUrl += "/dameCompetencias";
				}
		   		else if ( configParamsPrefStr.startsWith("1015,") ){
			 		xmlUrl += "/dameLineasInvestigacion";
				}
		   	}
			
		 	// ----------
		   	// Nuevo master propio
		   	// ----------
		   	if (applicationId.equals("master-own")) {
		   		if ( configParamsPrefStr.startsWith("301,") || configParamsPrefStr.startsWith("305,") ){
		  			xmlUrl += "/damePresentacion";
		   		} else if ( configParamsPrefStr.startsWith("302,") ){
		  			xmlUrl += "/damePrograma";
		   		} else if ( configParamsPrefStr.startsWith("303,") ){
		  			xmlUrl += "/dameProfesores";
				} else if ( configParamsPrefStr.startsWith("304,") ){
		  			xmlUrl += "/dameMatricula";
				} else if ( configParamsPrefStr.startsWith("306,") ){
		  			xmlUrl += "/consultaTituloPropio";
				}
		   	}

			// ----------
		   	// Titulo propio modulo
		   	// ----------
		   	if (applicationId.equals("master-own-module")) {
		   		if ( configParamsPrefStr.startsWith("301,") || configParamsPrefStr.startsWith("306,") ){
		  			xmlUrl += "/consultaTituloPropio";
		   		} else if ( configParamsPrefStr.startsWith("305,") ){
		  			xmlUrl += "/damePresentacion";
		   		} else if ( configParamsPrefStr.startsWith("302,") ){
		  			xmlUrl += "/damePrograma";
		   		} else if ( configParamsPrefStr.startsWith("304,") ){
		  			xmlUrl += "/dameMatricula";
				}
		   	}

		 	// ----------
		   	// Doctorados
		   	// ----------
		   	if (applicationId.equals("doctorate")) {
		   		if (configParamsPrefStr.startsWith("600,") || configParamsPrefStr.startsWith("601,")){
		  			xmlUrl += "/damePresentacion";
		   		}else if ( configParamsPrefStr.startsWith("602,") ){
		  			xmlUrl += "/dameOrganizacion";
		   		}else if ( configParamsPrefStr.startsWith("603,") ){
		  			xmlUrl += "/dameCompetencias";
		   		}else if ( configParamsPrefStr.startsWith("604,") ){
		  			xmlUrl += "/dameActividadesFormativas";
		   		}else if ( configParamsPrefStr.startsWith("605,") ){
		  			xmlUrl += "/dameProfesorado";
		   		}else if ( configParamsPrefStr.startsWith("606,") ){
		  			xmlUrl += "/dameMatricula";
		   		}else if (configParamsPrefStr.startsWith("607,")){
		  			xmlUrl += "/dameMatricula";
		   		}else if (configParamsPrefStr.startsWith("608,")){
		  			xmlUrl += "/dameTesisDefendidas";
		   		}else if (configParamsPrefStr.startsWith("609,")){
		  			xmlUrl += "/dameCalidad";
		   		}
		   	}		   			    
		 	
		    /*------------- Aplicacion estandar?  ----------*/
		    
			boolean isAppStandar = GetterUtil.getBoolean(PropsUtil.get(applicationId + ".standar"),false);
		    
		    // Parametros de aplicaciones ESTANDAR: idioma de navegacion estandar (p_cod_idioma / idioma) & codigo de proceso (p_cod_proceso / proceso)
		    if (isAppStandar) {
				
		    	// Servicios web nuevos
				if (applicationId.equals("plew0040-offer") || applicationId.equals("plew0030-offer")){
		    		xmlUrl += "?idioma=" + paramLanguage + "&proceso=" + applicationId;
		    		
				}else {
					xmlUrl += "?p_cod_idioma=" + paramLanguage + "&p_cod_proceso=" + applicationId;
				}
		   	// Parametro de aplicaciones NO ESTANDAR: idioma de navegacion NO estandar (p_cod_idioma)
		    } else {
				if (paramLanguage.equals("en")) {
					xmlUrl += "?p_cod_idioma=ING";
				} else if (paramLanguage.equals("eu")) {
					xmlUrl += "?p_cod_idioma=EUS";
				} else {
					xmlUrl += "?p_cod_idioma=CAS"; 
				}
			}		    		    
		    

		    /*------------- Aplicacion configurable?  ----------*/
		 	
//		    boolean isAppConfigurable = GetterUtil.getBoolean(PropsUtil.get(applicationId + ".config"),false);

		    /*------------- Parametros de configuracion (Si tiene almacenado algun valor) ----------*/
		    if((Validator.isNotNull(configParamsPrefStr)) || (!configParamsPrefStr.equals(StringPool.BLANK)) ) {
		    	configParams = PropsUtil.getArray(applicationId + ".configParams");

		      	for (int i=0; i < configParams.length; i++){

		      		configParam = "&" + configParams[i]; 

		      		// Valores almacenados en la preferencia
		      		if(Validator.isNotNull(configParamsPref) && configParamsPref.length>i) {
			        	configParamPref = configParamsPref[i];
	
			        	if ((Validator.isNotNull(configParamPref)) && (!configParamPref.equals(StringPool.BLANK)) ){                      
			    			xmlUrl += configParam + "=" + configParamPref ;
			            } else {
			            	xmlUrl += configParam;
			        	}
		      		}
		    	}
		    }

		  	/*------------- Parametros de busqueda  ----------*/
		    searchParams = PropsUtil.getArray(applicationId + ".searchParams");

		  	for (int i=0; i < searchParams.length; i++){
		  		// Parametros de busqueda FIJOS (definidos en properties con =) se incluyen directamente en la URL 
		        if (searchParams[i].contains("=")){
		        	searchParam = "&" + searchParams[i];
		        }else{
		        	searchParam  = "&" + searchParams[i] + "=";        		
		        }       
		        

		        
		    	// Parametros recibidos por GET
		    	searchParamGet = httpReq.getParameter(searchParams[i]);
		 
		    	// Si se recibe por GET un valor se asocia al campo de busqueda correspondiente	
		        if ((Validator.isNotNull(searchParamGet)) && (!searchParamGet.equals(StringPool.BLANK)) ){                      
					xmlUrl += searchParam + HtmlUtil.escapeURL(searchParamGet);
		        }
		    	// Si no se recibe ningun valor por GET 
		        else {
		        	// Oferta de doctorados (plew0060-offer) --> por defecto el orden es alfabetico  
		        	if ( (applicationId.equals("plew0060-offer")) && (searchParams[i].equals("p_orden")) ) {
		        		xmlUrl += searchParam + "A";
		        	} else if ( (applicationId.equals("plew0040-offer")) && (searchParams[i].equals("navegacion")) 
		        			|| (applicationId.equals("plew0030-offer")) && (searchParams[i].equals("navegacion"))) {
		        		xmlUrl += searchParam + "A";
		        	} else {
		        		xmlUrl += searchParam;        		
		        	}
		    	}     	       
		    }
		 // ----------
		   	// Master y titulos propios nueva oferta
		   	/**
		    if (applicationId.equals("plew0030-offer")) {
		    	xmlUrl += "&p_cod_proceso=&p_anyo=act";
		    }*/
			
		  	
		  	// alumni tiene un tratamiento especial. Hay que standarizarlo, pero mientras tanto...
		  	if( applicationId.equals( "alumni" ) ) {
		  		// aunque el xml que devuelven es igual, al hacer la llamada con www.ehu.eus da el error siguiente:
		  		// The element type "img" must be terminated by the matching end-tag "</img>".
		  		//xmlUrl = StringUtil.replace( xmlUrl, "www.ehu.eus", "dev.ehu.eus" );
		  		
		  		xmlUrl = StringUtil.replace( xmlUrl, "::userName::", _themeDisplay.getUser().getScreenName() );
		  		
		  		//Replace para que funcione en dev e int y podamos probar
		  		xmlUrl = StringUtil.replace( xmlUrl, "dev.ehu.eus", "ehu.eus" );
		  		xmlUrl = StringUtil.replace( xmlUrl, "int.ehu.eus", "ehu.eus" );
		  		_log.debug("xmlUrl Abajo: " + xmlUrl);
		  	}
		 
			/*------------- Redirecciones  ----------*/
			/* En algunos casos al mostrar informacion de una aplicacion con su proceso asociado (portal.properties -> application-id.xml)
			 * es necesario utilizar otro proceso diferente al asociado a la aplicacion seleccionada.
			 * En esos casos se capturan las peticiones donde se requiere el cambio de proceso y se realiza la redireccion (mediante el parametro p_redirect).
			 * En los casos en los que sea necesaria la redireccion y debido a que los procesos requieren de diferentes parametros se aprovechan los parametros de busqueda para
			 * disponer de todos los parametros necesarios.
			 * En estos casos tambien en los XSLs se realizara el parseo de XML funcion de los parametros (p_nav, p_cod_asignatura, p_idp ...)   	  
			*/
			
				//NUEVOS MASTER
				if (xmlUrl.contains("p_cod_proceso=master-epg")) {
					if (xmlUrl.contains("p_redirect=descargaFichero")) {
						xmlUrl = StringUtil.replace(xmlUrl,"gaurpop/dameRecursos","gaurpop/descargaFichero");
			  		} else if (xmlUrl.contains("p_redirect=consultaTutorias")) {
			  			xmlUrl = StringUtil.replace(xmlUrl,"gaurpop/dameAsignatura","gaurutil/consultaTutorias");
		  				xmlUrl = StringUtil.replace(xmlUrl,"gaurpop/dameProfesorado","gaurutil/consultaTutorias");
			  		} else if (xmlUrl.contains("p_redirect=fichaPDI")) {
			  			xmlUrl = StringUtil.replace(xmlUrl,"gaurpop/dameAsignatura","pdi/ficha");
		  				xmlUrl = StringUtil.replace(xmlUrl,"gaurpop/dameProfesorado","pdi/ficha");
		  			} else if (xmlUrl.contains("p_redirect=dameProfesorAjeno")) {
		  				xmlUrl = StringUtil.replace(xmlUrl,"gaurpop/dameProfesorado","gaurpop/dameProfesorAjeno");
		  				xmlUrl = StringUtil.replace(xmlUrl,"gaurpop/dameAsignatura","gaurpop/dameProfesorAjeno");
		  			} else if (xmlUrl.contains("p_nav=1004")) {
		  				if ( xmlUrl.contains("p_idp=&")
		  						&& xmlUrl.contains("p_anyo_acad=&")
		  						&& xmlUrl.contains("p_cod_asignatura=&")) {
		  					xmlUrl = StringUtil.replace(xmlUrl,"dameAsignatura","damePresentacion");
		  				}
		  			}
				}

				// TITULOS PROPIOS 2-3
				if (xmlUrl.contains("p_cod_proceso=master-own-module")){
					if (xmlUrl.contains("p_redirect=consultaTituloPropio")) {
		  				xmlUrl = StringUtil.replace(xmlUrl,"gaurtpr/damePrograma","gaurtpr/consultaTituloPropio");
		  			} else if (xmlUrl.contains("p_nav=302")) {
		  				xmlUrl = StringUtil.replace(xmlUrl,"p_cod_curso=","p_cod_modulo=");
		  			} else if (xmlUrl.contains("p_redirect=materiaFichaPDI")) {
		  				xmlUrl = StringUtil.replace(xmlUrl,"gaurtpr/consultaTituloPropio","pdi/ficha");
		  			} else if (xmlUrl.contains("p_redirect=materiaProfesorAjeno")) {
		  				xmlUrl = StringUtil.replace(xmlUrl,"gaurtpr/consultaTituloPropio","gaurtpr/dameProfesorAjeno");
		  			} else if (xmlUrl.contains("p_nav=306")) {
		  				xmlUrl = StringUtil.replace(xmlUrl,"p_cod_curso=&","");
		  				xmlUrl = StringUtil.replace(xmlUrl,"p_cod_curso_mat","p_cod_curso");
		  			} else if (xmlUrl.contains("p_nav=304")) {
		  				xmlUrl = StringUtil.replace(xmlUrl,"p_cod_curso=","p_cod_modulo=");
		  			}
				// TITULOS PROPIOS
				} else if (xmlUrl.contains("p_cod_proceso=master-own")){
					if (xmlUrl.contains("p_redirect=fichaPDI")) {
		  				xmlUrl = StringUtil.replace(xmlUrl,"gaurtpr/dameProfesores","pdi/ficha");
		  			} else if (xmlUrl.contains("p_redirect=dameProfesorAjeno")) {
		  				xmlUrl = StringUtil.replace(xmlUrl,"gaurtpr/dameProfesores","gaurtpr/dameProfesorAjeno");
		  			} else if (xmlUrl.contains("p_redirect=materiaFichaPDI")) {
		  				xmlUrl = StringUtil.replace(xmlUrl,"gaurtpr/consultaTituloPropio","pdi/ficha");
		  			} else if (xmlUrl.contains("p_redirect=materiaProfesorAjeno")) {
		  				xmlUrl = StringUtil.replace(xmlUrl,"gaurtpr/consultaTituloPropio","gaurtpr/dameProfesorAjeno");
		  			} else {
		  				xmlUrl = StringUtil.replace(xmlUrl,"p_cod_curso=&","");
		  			}
				// Doctorados
				} else if (xmlUrl.contains("p_cod_proceso=doctorate")) {
					if (xmlUrl.contains("p_redirect=descargaFichero")) {
						xmlUrl = StringUtil.replace(xmlUrl,"gaurpdc/dameCalidad","gaurpdc/descargaFichero");
					} else if (xmlUrl.contains("p_redirect=fichaPDI")) {
		  				xmlUrl = StringUtil.replace(xmlUrl,"gaurpdc/dameProfesorado","pdi/ficha");
		  			} else if (xmlUrl.contains("p_redirect=dameProfesorAjeno")) {
		  				xmlUrl = StringUtil.replace(xmlUrl,"gaurpdc/dameProfesorado","gaurpdc/dameProfesorAjeno");
						xmlUrl = StringUtil.replace(xmlUrl,"gaurpdc/dameCalidad","gaurpdc/dameProfesorAjeno");
		  			}
				}
				
		
			 	// -------------
			 	// Departamento
			 	// --------------
			 	else if (xmlUrl.contains("p_cod_proceso=department")) {
			 		// Redireccion al proceso que corresponda (Master plew0050) en funcion de la configuracion seleccionada p_nav (Asignaturas, Grados o Masteres)
			 		
		 			// Grados
		 			if (xmlUrl.contains("p_nav=1")) {
		 				xmlUrl = StringUtil.replace(xmlUrl,"p_cod_proceso=department","p_cod_proceso=plew0040");
		 				// Redireccion a una asignatura
			  			if (xmlUrl.contains("p_redirect=consultaAsignatura")) {
			  			  	xmlUrl = StringUtil.replace(xmlUrl,"gaurutil/consultaDepartamento","gauregr/consultaAsignatura");
			  		  	} 
			  			// Redireccion a las tutorias de un profesor
			  			else if (xmlUrl.contains("p_redirect=consultaTutorias")) {
			  				xmlUrl = StringUtil.replace(xmlUrl,"gaurutil/consultaDepartamento","gaurutil/consultaTutorias");
			  			}
			  			// Vuelta desde una asignatura o desde las tutorias de un profesor al grado
			  			else {
			  		  		xmlUrl = StringUtil.replace(xmlUrl,"gauregr/consultaAsignatura","gaurutil/consultaDepartamento");	
			  		  		xmlUrl = StringUtil.replace(xmlUrl,"gaurutil/consultaTutorias","gaurutil/consultaDepartamento");
			  		  	}
		 			}
			 		// Masteres
		 			else if (xmlUrl.contains("p_nav=2")) {
		 				xmlUrl = StringUtil.replace(xmlUrl,"p_cod_proceso=department","p_cod_proceso=plew0050");
		 				// Redireccion a una asignatura
			  			if (xmlUrl.contains("p_redirect=consultaAsignatura")) {
			  			  	xmlUrl = StringUtil.replace(xmlUrl,"gaurutil/consultaDepartamento","gaurpop/consultaAsignatura");
			  		  	} 
			  			// Redireccion a las tutorias de un profesor
			  			else if (xmlUrl.contains("p_redirect=consultaTutorias")) {
			  				xmlUrl = StringUtil.replace(xmlUrl,"gaurutil/consultaDepartamento","gaurpop/consultaTutorias");
			  			}
			  			// Vuelta desde una asignatura o desde las tutorias de un profesor al grado
			  			else {
			  		  		xmlUrl = StringUtil.replace(xmlUrl,"gaurpop/consultaAsignatura","gaurutil/consultaDepartamento");	
			  		  		xmlUrl = StringUtil.replace(xmlUrl,"gaurutil/consultaTutorias","gaurutil/consultaDepartamento");
			  		  		
			  		  	}
		 			}
				}
			 	
			  	// ----------
			  	// Nuevo grado 
			  	// ----------
			  	
			  	if (xmlUrl.contains("p_cod_proceso=egr")) {
			  		if (xmlUrl.contains("p_nav=40")) {
		 				// Redireccion a una asignatura
			  			if (xmlUrl.contains("p_redirect=consultaAsignatura")) {
			  			 	xmlUrl = StringUtil.replace(xmlUrl,"gauregr/dameCursos","gauregr/dameAsignatura");
			  		  	}
		 				//
		 				else if (xmlUrl.contains("p_redirect=consultaTutorias")) {
		 					xmlUrl = StringUtil.replace(xmlUrl,"gauregr/dameCursos","gaurutil/consultaTutorias");
				  		} else if (xmlUrl.contains("p_redirect=fichaPDI")) {
				  			xmlUrl = StringUtil.replace(xmlUrl,"gauregr/dameCursos","pdi/ficha");
			  				xmlUrl = StringUtil.replace(xmlUrl,"gauregr/dameProfesorado","pdi/ficha");
				  		} else {
			  		  		xmlUrl = StringUtil.replace(xmlUrl,"gauregr/dameAsignatura","gauregr/dameCursos");	
			  		  		xmlUrl = StringUtil.replace(xmlUrl,"gaurutil/consultaTutorias","gauregr/v");
			  		  	}
		 			} else
		 				 if (xmlUrl.contains("p_nav=50")) {
		  		  			// Redireccion a las tutorias de un profesor
		  		  			if (xmlUrl.contains("p_redirect=consultaTutorias")) {
		  		  			  	xmlUrl = StringUtil.replace(xmlUrl,"gauregr/dameProfesorado","gaurutil/consultaTutorias");
			  		  		} else if (xmlUrl.contains("p_redirect=fichaPDI")) {
			  		  			xmlUrl = StringUtil.replace(xmlUrl,"gauregr/dameCursos","pdi/ficha");
			  	  				xmlUrl = StringUtil.replace(xmlUrl,"gauregr/dameProfesorado","pdi/ficha");
		  		  		  	} else {
		  		  		  		xmlUrl = StringUtil.replace(xmlUrl,"gaurutil/consultaTutorias","gauregr/dameProfesorado");	
		  		  		  	}
		  		  			// Vuelta las tutorias de un profeso al grado
		  		  			
		  		  		} else 
			  		// Calendario, horarios, tutorias y fechas de examenes
			 		if (xmlUrl.contains("p_nav=110")) {
			 			// Redireccion a la descarga de un fichero
			 			if (xmlUrl.contains("p_redirect=descargaFichero")) {
			 			//	_logIE.info("descargaFichero doctorados");
			 				xmlUrl = StringUtil.replace(xmlUrl,"gaurpdc/consultaDoctorado","gaurpdc/descargaFichero");
			 			}
			 		}else{	  	
			  		// Verificacion, seguimiento y acreditacion  
			 		
			 			// Redireccion a la descarga de un fichero
			 			
			 			if (xmlUrl.contains("p_redirect=descargaFichero")) {
			 				//	_logIE.info("descargaFichero doctorados");
			 				xmlUrl = StringUtil.replace(xmlUrl,"gauregr/dameRecursos","gauregr/descargaFichero");
			 				
			 			}
			 		}
			  	}
			 	
			
		} 
		/*------------- Aplicacion NO seleccionada  ----------*/
		// SOLO se muestra el mensaje de configuracion inicial al usuario con permisos
		else {
			request.setAttribute(WebKeys.PORTLET_CONFIGURATOR_VISIBILITY, Boolean.TRUE);	
		}
		return xmlUrl;
	}
	
	
	
	
	
	/**
	 * 
	 * @author UPV/EHU
	 *
	 */
	public static class CachedTransform {
		  public static byte[] compress(final String str) throws IOException {
		    if ((str == null) || (str.length() == 0)) {
		      return null;
		    }
		    ByteArrayOutputStream obj = new ByteArrayOutputStream();
		    GZIPOutputStream gzip = new GZIPOutputStream(obj);
		    gzip.write(str.getBytes("UTF-8"));
		    gzip.flush();
		    gzip.close();
		    return obj.toByteArray();
		  }

		  public static String decompress(final byte[] compressed) throws IOException {
		    final StringBuilder outStr = new StringBuilder();
		    if ((compressed == null) || (compressed.length == 0)) {
		      return "";
		    }
		    if (isCompressed(compressed)) {
		      final GZIPInputStream gis = new GZIPInputStream(new ByteArrayInputStream(compressed));
		      final BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(gis, "UTF-8"));

		      String line;
		      while ((line = bufferedReader.readLine()) != null) {
		        outStr.append(line);
		      }
		    } else {
		      outStr.append(compressed);
		    }
		    return outStr.toString();
		  }

		  public static boolean isCompressed(final byte[] compressed) {
		    return (compressed[0] == (byte) (GZIPInputStream.GZIP_MAGIC)) && (compressed[1] == (byte) (GZIPInputStream.GZIP_MAGIC >> 8));
		  }
	} //end GZIPCompression
	
	
	/**
	 * 
	 * @return
	 */
	public String getGeneratedXmlUrl() {		
		return _xmlUrl;
	}

}