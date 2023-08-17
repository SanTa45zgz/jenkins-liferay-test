<%--
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
--%>

<%@ include file="/init.jsp" %>

<liferay-portlet:actionURL portletConfiguration="<%= true %>" var="configurationActionURL" />

<liferay-portlet:renderURL portletConfiguration="<%= true %>" var="configurationRenderURL" />

<liferay-frontend:edit-form
	action="<%= configurationActionURL %>"
	method="post"
	name="fm"
>
	<aui:input name="<%= Constants.CMD %>" type="hidden" value="<%= Constants.UPDATE %>" />
	<aui:input name="redirect" type="hidden" value="<%= configurationRenderURL %>" />

	<liferay-frontend:edit-form-body>
		<liferay-ui:error key="xmlUrl" message="please-enter-a-valid-xml-url" />
		<liferay-ui:error key="xslUrl" message="please-enter-a-valid-xsl-url" />
		<liferay-ui:error key="transformation" message="an-error-occurred-while-processing-your-xml-and-xsl" />

		<%
		String validUrlPrefixes = xslContentConfiguration.validUrlPrefixes();
		%>
		
		<c:if test="<%= Validator.isNotNull(validUrlPrefixes) %>">
			<div class="alert alert-info">
				<liferay-ui:message arguments="<%= validUrlPrefixes %>" key="urls-must-begin-with-one-of-the-following" />
			</div>
		</c:if>

	
		<aui:input cssClass="lfr-input-text-container" name="preferences--xmlUrl--" type="hidden" value="<%= xslContentPortletInstanceConfiguration.xmlUrl() %>" />
	
		<aui:input cssClass="lfr-input-text-container" name="preferences--xslUrl--" type="hidden" value="<%= xslContentPortletInstanceConfiguration.xslUrl() %>" />
					
					
					
		<%-- upv/ehu - --%>
	
		   
		<%-- Preferencia de aplicacion seleccionada (Selector de aplicaciones) --%>
		<aui:select label="ehu.available-apps" name="preferences--applicationId--">
			<aui:option label="ehu.select-an-app" value="" selected='<%= StringPool.BLANK.equals(applicationId) %>' /> 
				<% 
					String optionLabel = StringPool.BLANK;
					String optionCss;
					boolean optionConfigurable = false;
					String[] apps = PropsUtil.getArray("applications");
							
					for (int i = 0; i < apps.length; i++){						
						optionLabel = "ehu.xsl-content.title." + apps[i]; 
						optionConfigurable	= GetterUtil.getBoolean(PropsUtil.get(apps[i] + ".config"));
						// Si una aplicacion es configurable se incluye el codigo de aplicacion como clase CSS 
						if (optionConfigurable){
							optionCss = apps[i];	
						} else {
							optionCss =  StringPool.BLANK;
						}
					%>
						<aui:option label='<%=optionLabel%>' value='<%=apps[i]%>' cssClass='<%=optionCss%>' selected='<%= apps[i].equals(applicationId)%>' />            	
					<%	} 
					%>
		</aui:select>
					
		<%-- Campos de configuracion  --%>
		<%-- Maximo de campos de configuracion necesarios para alguna de las aplicaciones integrables --%>
		<aui:select name="config-1" label="" cssClass='<%= StringPool.BLANK.equals(applicationId) ? "hide" : StringPool.BLANK %>'></aui:select>
		<aui:select name="config-2" label="" cssClass='<%= StringPool.BLANK.equals(applicationId) ? "hide" : StringPool.BLANK %>'></aui:select>	
		<aui:select name="config-3" label="" cssClass='<%= StringPool.BLANK.equals(applicationId) ? "hide" : StringPool.BLANK %>'></aui:select>
		<aui:select name="config-4" label="" cssClass='<%= StringPool.BLANK.equals(applicationId) ? "hide" : StringPool.BLANK %>'></aui:select>
					
		<%-- Preferencia de configuraciones almacenadas. --%>
	    <aui:input cssClass="lfr-input-text-container" type="hidden" name="preferences--configParams--"  value="<%=configParamsPrefStr%>"/>
	            
	    <%-- upv/ehu - upv/ehu --%>


	</liferay-frontend:edit-form-body>

	<liferay-frontend:edit-form-footer>
		<aui:button type="submit" />

		<aui:button type="cancel" />
	</liferay-frontend:edit-form-footer>
</liferay-frontend:edit-form>



<%-- upv/ehu - --%>
<aui:script>
AUI().use(
	'aui-io-request',
	'aui-node',
	'aui-url',
	function(A){
	
		// ===========================
		// Al cargar la configuracion
		// ===========================
		
		// ----------- Aplicaciones ------------ //
		
		// Selector de aplicaciones
		var appSelector = A.one("#<portlet:namespace />applicationId");
		
		// Aplicacion seleccionada
		var appValue = appSelector.val();
		
		// Estilo asociado a la aplicacion seleccionada
		var appClass = "";
		
		// ----------- URLs ------------ //
		
		// Url externa de la fuente de datos
		var extUrl = "";
		
		// Urls del entorno de ejecucion
		var execUrl = "<%=execUrl%>";
		
		// Urls de las fuentes de datos (GAUR, aplicacion no corporativas & ficheros de configuracion JSON)
		var gaurUrl = "<%=gaurUrl%>";
		
		var appUrl = "<%=appUrl%>";
		
		// Campo y URL de configuracion 1
		var configField1 = A.one("#<portlet:namespace />config-1");
		var configUrl1 = "";
		
		// Campo y URL de configuracion 2
		var configField2 = A.one("#<portlet:namespace />config-2");
		var configUrl2 = "";
		
		// Campo y URL de configuracion 3
		var configField3 = A.one("#<portlet:namespace />config-3");
		var configUrl3 = "";
		
		// Campo y URL de configuracion 4
		var configField4 = A.one("#<portlet:namespace />config-4");
		var configUrl4 = "";
		
		// ----------- Preferencias ------------ //
		
		// Campo de Preferencia urlXML
		var prefUrlXml = A.one("#<portlet:namespace />xmlUrl");
		var defaultUrlXml = '';
			
		// Campo de Preferencia urlXSL
		var prefUrlXsl = A.one("#<portlet:namespace />xslUrl");
		// Valor por defecto de la preferencia urlXSL
		var defaultUrlXsl = '';
		
		// Campo de Preferencia de configuracion
		var prefConfigParams = A.one("#<portlet:namespace />configParams");
		var prefConfigParamsValue = prefConfigParams.val();
				
		// Array de valor/es de la preferencia de configuracion
		
		var prefConfigParamsArray = '';
		if (prefConfigParamsValue != ''){
			prefConfigParamsArray = prefConfigParamsValue.split("<%= StringPool.COMMA%>");
		}
		
		// ----------- Boton para Guardar datos ------------ //
		
		var btnSave = A.one(".btn-primary");
		
		//console.log("======" );
		//console.log("ONLOAD" );
		//console.log("======" );
		
		// ------------- Si se selecciona una aplicacion ---------- //
		
		if (appValue !== ''){
		
			//console.log("	Aplicacion configurada y seleccionada " + appValue);

			// ------------- Aplicacion seleccionada ---------- //
			appClass = appSelector.all('option[selected]').attr('class');
			
			// Aplicacion configurable   
	    	if (appClass !== '') {

				// Se vacian y ocultan anteriores configuraciones
	    		voidConfiguration(configField1,configField2,configField3,configField4);
	    		hideConfiguration(configField1,configField2,configField3,configField4);

	    		// -------------------------------------------------- //
		        // ----------- Listas de Personal (ldap) ------------ //
		        // -------------------------------------------------- //
			    if (appClass == 'ldap') {
			    	
			    	// Parametro de configuracion 1
			    	// ----------------------------
			    	// Local --> p_tipo [centro,dpto,otro]
					configUrl1 = execUrl + 'o/ehu-xsl-content-web/' + appClass + '/' + appClass + '.json';
					setValuesJson(A,configUrl1,prefConfigParamsValue,prefConfigParamsArray,0,configField1);
			    	
			    	// Parametro de configuracion 2
			    	// ----------------------------	
			    	// Si existen valores de configuracion almacenados y son de la aplicacion LDAP, se recuperan las opciones del segundo campo de configuracion en funcion del valor almacenado  
					if( (prefConfigParamsValue != '') && (appClass == 'ldap') ){			    	
			    		configUrl2 = appUrl + "ldap-xml.php?p_cod_proceso=" + appClass + "&p_cod_idioma=<%=paramLanguage%>&p_tipo=" + prefConfigParamsArray[0];
			    	}
			    	// Si NO existen valores de configuracion almacenados o NO son de la aplicacion LDAP, se recuperan las opciones del segundo campo de configuracion con el valor por defecto del primer campo de configuracion (centro)
					else {
					   	configUrl2 = appUrl + "ldap-xml.php?p_cod_proceso=" + appClass + "&p_cod_idioma=<%=paramLanguage%>&p_tipo=centro";					   	
					}
					setValuesXml(A,configUrl2,prefConfigParamsArray[0],'cod','',prefConfigParamsValue,prefConfigParamsArray,1,configField2);
			    	
				    // Si cambia el tipo se recarga la lista de centros, dptos ou otros correspondiente
					configField1.on(
						'change',
					    function() {
					       	configUrl2 = appUrl + "ldap-xml.php?p_cod_proceso=" + appClass + "&p_cod_idioma=<%=paramLanguage%>&p_tipo=" + configField1.val();			    		                
					    	setValuesXml(A,configUrl2,configField1.val(),'cod','',prefConfigParamsValue,prefConfigParamsArray,1,configField2);
					    }
			    	);
			    } 
			   
			    // ---------------------------------------------------- //
				// -------------- Departamento (department) ----------- //
				// ---------------- Nuevo Grado (egr) ----------------- //
				// ---------------- Nuevo Master (epg) ---------------- //				
				// ---------------------------------------------------- //
			    else if ((appClass == 'department') || (appClass == 'egr') || (appClass == 'master-epg') || (appClass == 'master-own')
		    	|| (appClass == 'master-own-module') || (appClass == 'doctorate')){
			    	
			    	// Parametro de configuracion 1
			    	// ----------------------------
			    	//	Oferta nueva de Grados (plew0040-new-offer): p_anyo (curso actual o futuro [act,fut]), se recupera localmente via fichero JSO
			    	// 	Nuevo Grado (egr): p_nav (vista de informacion a presentar), se recupera localmente via fichero JSONs
			    	// 	Nuevo Master (epg): p_nav (vista de informacion a presentar), se recupera localmente via fichero JSONs
			    	// 	Nuevo Master Propio (plew030): p_nav (vista de informacion a presentar), se recupera localmente via fichero JSONs			   			    	
			    	// Se muestra el primer campo de configuracion
			    	configField1.show();            		
					
			    	configUrl1 = execUrl + 'o/ehu-xsl-content-web/' + appClass + '/' + appValue + '.json';
				    setValuesJson(A,configUrl1,prefConfigParamsValue,prefConfigParamsArray,0,configField1);

				    //console.log("ONLOAD: " + configUrl1 );
				   
				    
				    // En la aplicacion de departamentos si cambia la informacion a mostrar (Asignaturas de grados o Masteres) se cambia la lista de departamentos
					if (appClass == 'department') {
						configField1.on(
						'change',
						    function() {
						    	// Asignaturas de masteres 
								if (configField1.val() == 2){
									configUrl2 = gaurUrl + "gaurutil/departamentos?p_cod_proceso=plew0050&p_cod_idioma=<%=paramLanguage%>";
								} 
								// Asignaturas de Grados   
								else {
									configUrl2 = gaurUrl + "gaurutil/departamentos?p_cod_proceso=plew0040&p_cod_idioma=<%=paramLanguage%>";
								}
								setValuesXml(A,configUrl2,'option','val','',prefConfigParamsValue,prefConfigParamsArray,1,configField2);									
							}
						);
					}	
				    	
			    	// ---------------------------------------------------- //
					// -------------- Departamento (department) ----------- //
				    // ---------------------------------------------------- // 
					else if (appClass == 'department') {
					    	
						// Parametro de configuracion 2
					    // ----------------------------  
						// p_anyo: siempre es el aï¿½o actual
						// p_nav: requerido aunque no se utiliza para nada
						// p_cod_dpto: (identificativo de departamento)
						
						// Asignaturas de masteres 
						if (configField1.val() == 2){
																						
							configUrl2 = gaurUrl + "gaurutil/departamentos?p_cod_proceso=plew0050&p_cod_idioma=<%=paramLanguage%>";
						}
						// Asignaturas de grados  
						else {
							
							configUrl2 = gaurUrl + "gaurutil/departamentos?p_cod_proceso=plew0040&p_cod_idioma=<%=paramLanguage%>";
						}												
						setValuesXml(A,configUrl2,'option','val','',prefConfigParamsValue,prefConfigParamsArray,1,configField2);
					}
					// -------------------------------------------------- //
			    	// -------------- Nuevo Grado (egr) ------------ //
			    	// -------------------------------------------------- //
			    	else if (appClass == 'egr') {
			    	
			    		// Parametro de configuracion 2
						// ----------------------------  
						// p_anyo: (identificativo de curso actual/futuro [act/fut]), se recupera localmente via fichero JSON de la aplicacion Oferta de Grados (plew0040-offer) 
						configUrl2 = execUrl + 'o/ehu-xsl-content-web/plew0040-offer/plew0040-offer.json';
						setValuesJson(A,configUrl2,prefConfigParamsValue,prefConfigParamsArray,1,configField2);

			    	  	//console.log("ONLOAD: " + configUrl2 );
			    	  	// Parametro de configuracion 3 
						// ---------------------------- 
						// p_cod_centro: (identificativo de centro), se recupera via XML
						
						// Parametro de configuracion 4
						// ----------------------------  
						// p_cod_plan: (identificativo de plan de estudios), se recupera via XML de la oferta de Grados
			    	  	
			    		// Si existen valores de configuracion almacenados y son de la aplicacion Nuevo Grado, se recuperan las opciones de los campos de configuracion en funcion del valor almacenado
						if( (prefConfigParamsValue != '') && (appValue == 'egr') ){
						  	configUrl3 = gaurUrl + "gaurutil/centros?p_cod_proceso=" + appClass + "&p_cod_idioma=<%=paramLanguage%>" + "&p_anyo_acad=" + prefConfigParamsArray[1];
						  	setValuesXml(A,configUrl3,'option','val','',prefConfigParamsValue,prefConfigParamsArray,2,configField3);
						  	configUrl4 = gaurUrl + "gaurutil/titulaciones?p_cod_proceso=" + appClass + "&p_cod_idioma=<%=paramLanguage%>" + "&p_anyo_acad=" + prefConfigParamsArray[1] + "&p_cod_centro=" + prefConfigParamsArray[2];						  						
						}
						// Si NO existen valores de configuracion almacenados de la aplicacion Nuevo Grado, se cargan los valores por defecto (Año actual y Escuela Técnica Superior de Arquitectura)								
						else {
						  	configUrl3 = gaurUrl + "gaurutil/centros?p_cod_proceso=" + appClass + "&p_cod_idioma=<%=paramLanguage%>" + "&p_anyo_acad=act";
						  	setValuesXml(A,configUrl3,'option','val','',prefConfigParamsValue,prefConfigParamsArray,2,configField3);
				    		configUrl4 = gaurUrl + "gaurutil/titulaciones?p_cod_proceso=" + appClass + "&p_cod_idioma=<%=paramLanguage%>" + "&p_anyo_acad=act&p_cod_centro=240";
						}	    
						setValuesXml(A,configUrl4,'option','val','',prefConfigParamsValue,prefConfigParamsArray,3,configField4);
								
						// Si cambia el centro se recargan las titulaciones
						configField3.on(
							'change',
						    function() {
						    	configUrl4 = gaurUrl + "gaurutil/titulaciones?p_cod_proceso=" + appClass + "&p_cod_idioma=<%=paramLanguage%>" + "&p_anyo_acad=" + configField2.val() + "&p_cod_centro=" + configField3.val();			    		                
						        setValuesXml(A,configUrl4,'option','val','',prefConfigParamsValue,prefConfigParamsArray,3,configField4);
							}
						);
					    	
			    	}
			    	// -------------------------------------------------- //
			    	// -------------- Nuevo Master (epg) (plew0050) ----------------- //
			    	// -------------------------------------------------- //
			    	else if  (appClass == 'master-epg') {
			    	
			    		// Parametro de configuracion 2
						// ----------------------------  
						// p_anyo: (identificativo de curso actual/futuro [act/fut]), se recupera localmente via fichero JSON de la aplicacion Oferta de Masteres (plew0050-offer) 
						configUrl2 = execUrl + 'o/ehu-xsl-content-web/common/year-offer.json';
						setValuesJson(A,configUrl2,prefConfigParamsValue,prefConfigParamsArray,1,configField2);
		
			    		//console.log("ONLOAD: " + configUrl2 );
			    		// Parametro de configuracion 3
						// ----------------------------
			    		// Si existen valores de configuracion almacenados y son de la aplicacion Master, se recuperan las opciones de los campos de configuracion en funcion del valor almacenado
						if( (prefConfigParamsValue != '') && (appValue == 'master-epg') ){
						    configUrl3 = gaurUrl + "gaurpop/ofertaMasteres?p_cod_proceso=" + appClass + "&p_cod_idioma=<%=paramLanguage%>" + "&p_nav=1&p_anyo=" + prefConfigParamsArray[1];
						}
						// Si NO existen valores de configuracion almacenados de la aplicacion Master, se carga el valor por defecto (Aï¿½o actual) 
						else {
						    configUrl3 = gaurUrl + "gaurpop/ofertaMasteres?p_cod_proceso=" + appClass + "&p_cod_idioma=<%=paramLanguage%>" + "&p_nav=1&p_anyo=act";
						}
						setValuesXml(A,configUrl3,'master','codMaster','denMaster',prefConfigParamsValue,prefConfigParamsArray,2,configField3);
			    	  	
			    	}
			    	
			    	// -------------------------------------------------- //
			    	// -------------- Nuevo Master Propio (plew0030) ----------------- //
			    	// -------------------------------------------------- //
			    	else if  (appClass == 'master-own') {
					    	  	
			    		// Parametro de configuracion 2
			    		// ----------------------------  
			    		configUrl2 = gaurUrl + "gaurtpr/ofertaTitulosPropios?p_cod_proceso=" + appClass + "&p_cod_idioma=<%=paramLanguage%>" + "&p_nav=";
			    		setValuesXml(A,configUrl2,'programa','codPrograma','descPrograma',prefConfigParamsValue,prefConfigParamsArray,1,configField2);
			    	}
			    	
			    	// -------------------------------------------------- //
			    	// -------------- Titulo Propio Module  ------------- //
			    	// -------------------------------------------------- //
			    	else if  (appClass == 'master-own-module') {
			    		
			    		// Parametro de configuracion 2
			    		// ----------------------------  
						if( (prefConfigParamsValue != '') && (appValue == 'master-own-module') ){
			    		
				    		configUrl2 = gaurUrl + "gaurtpr/ofertaTitulosPropios?p_cod_proceso=" + appClass + "&p_cod_idioma=<%=paramLanguage%>" + "&p_nav=1" + "&p_cod_programa=" + prefConfigParamsArray[1];
				    		setValuesXml2(A,configUrl2,'programa','codPrograma','descPrograma',prefConfigParamsValue,prefConfigParamsArray,1,configField2);
						  	
						  	if (prefConfigParamsArray[0] == '301' || prefConfigParamsArray[0] == '302' || prefConfigParamsArray[0] == '304') {
							  	configUrl3 = gaurUrl + "gaurtpr/consultaTituloPropio?p_cod_proceso=" + appClass + "&p_cod_idioma=<%=paramLanguage%>"+ "&p_nav=1" + "&p_cod_programa=" + prefConfigParamsArray[1]
							  		+ "&p_cod_curso=" + prefConfigParamsArray[2];
						  		setValuesXml2(A,configUrl3,'modulo','codModulo','denModulo',prefConfigParamsValue,prefConfigParamsArray,2,configField3);
						  	} else {
						  		var fieldInitial = document.getElementById("<portlet:namespace />config-3");
						  		hideSpecificConfiguration(fieldInitial);
			    				updateEmptyValueConfiguration(configField3);
						  	}
						  	
			    		}
						// Si NO existen valores de configuracion almacenados de la aplicacion Grado, se cargan los valores por defecto (Aï¿½o actual y Escuela Tï¿½cnica Superior de Arquitectura)								
						else {
						  	configUrl2 = gaurUrl + "gaurtpr/ofertaTitulosPropios?p_cod_proceso=" + appClass + "&p_cod_idioma=<%=paramLanguage%>" + "&p_nav=1";
				    		setValuesXml2(A,configUrl2,'programa','codPrograma','descPrograma',prefConfigParamsValue,prefConfigParamsArray,1,configField2);
						  	configUrl3 = gaurUrl +  "gaurtpr/consultaTituloPropio?p_cod_proceso=" + appClass + "&p_cod_idioma=<%=paramLanguage%>" + "&p_nav=1" + "&p_cod_programa=" + configField2.val() + "&p_cod_curso=";			    		                
					        setValuesXml2(A,configUrl3,'modulo','codModulo','denModulo',prefConfigParamsValue,prefConfigParamsArray,2,configField3);
						}
						
			    		configField2.on(
							'change',
						    function() {						    
						    	updateEmptyValueConfiguration(configField3);
						    	if (configField1.val() == 301 || configField1.val() == 302 || configField1.val() == 304) {
							    	configUrl3 = gaurUrl +  "gaurtpr/consultaTituloPropio?p_cod_proceso=" + appClass + "&p_cod_idioma=<%=paramLanguage%>" + "&p_nav=1" + "&p_cod_programa=" + configField2.val() + "&p_cod_curso=";			    		                
							        setValuesXml2(A,configUrl3,'modulo','codModulo','denModulo',prefConfigParamsValue,prefConfigParamsArray,2,configField3);
						        } else {
									configField3.hide();
									configField3.empty();
									updateEmptyValueConfiguration(configField3);
						        }
							}
						);
						configField1.on(
							'change',
						    function() {
						    	if (configField1.val() != 301 && configField1.val() != 302 && configField1.val() != 304) {
									configField3.hide();
									configField3.empty();
									updateEmptyValueConfiguration(configField3);
								} else {
									configUrl3 = gaurUrl +  "gaurtpr/consultaTituloPropio?p_cod_proceso=" + appClass + "&p_cod_idioma=<%=paramLanguage%>" + "&p_nav=1" + "&p_cod_programa=" + configField2.val() + "&p_cod_curso=";			    		                
							        setValuesXml2(A,configUrl3,'modulo','codModulo','denModulo',prefConfigParamsValue,prefConfigParamsArray,2,configField3);
								}
							}
						);									    		
			    	}
			    	
			    	// -------------------------------------------------- //
			    	// -------------- Doctorados  ----------------------- //
			    	// -------------------------------------------------- //
			    	else if  (appClass == 'doctorate') {
					    	  	
			    		// Parametro de configuracion 2
			    		// ----------------------------  
			    		configUrl2 = gaurUrl + "gaurpdc/ofertaDoctorados?p_cod_proceso=" + appClass + "&p_cod_idioma=<%=paramLanguage%>" + "&p_nav=";
			    		setValuesXml(A,configUrl2,'doctorado','codPropuesta','desPropuesta',prefConfigParamsValue,prefConfigParamsArray,1,configField2);
			    	}
			    				    	
			    } 
			} // Aplicacion configurable
	    	// Si la aplicacion seleccionada NO es configurable
			else {
				voidConfiguration(configField1,configField2,configField3,configField4);
		        hideConfiguration(configField1,configField2,configField3,configField4);		        
			}
        } // Alguna aplicacion seleccionada
        // Si NO esta seleccionada ninguna aplicacion 
        else {
        	// Se vacia el campo de preferencias de configuracion
			prefConfigParams.setAttribute('value','');
			
			// Se asignan los valores por defecto a las URLs para la recuperaciï¿½n de datos y su renderizado
			prefUrlXml.setAttribute('value',defaultUrlXml);
			prefUrlXsl.setAttribute('value',defaultUrlXsl);	 
        }	
		
		// =====================================
		// Al cambiar la aplicacion seleccionada
		// =====================================
		
		appSelector.on(
    		'change',
      		function(){

				//console.log("===================" );
				//console.log("ONCHANGE APLICATION" );
				//console.log("===================" );
				//console.log("	Aplicacion configurada " + appValue);
				      		
      			// ------------- Si se selecciona una aplicacion ---------- //
				
				if (appSelector.val() != ''){
				
					//console.log("	Aplicacion seleccionada " + appSelector.val());	  				
					
					// ------------- Aplicacion seleccionada ---------- //
					appClass = appSelector.all(':selected').attr('class');
					
					// Se muestra su configuracion si es configurable   
	    			if (appClass !== '') {

	    	    		voidConfiguration(configField1,configField2,configField3,configField4);
	    	    		hideConfiguration(configField1,configField2,configField3,configField4);
	            		
	            		// -------------------------------------------------- //
				        // ----------- Listas de Personal (ldap) ------------ //
				        // -------------------------------------------------- //
					    if (appClass == 'ldap') {
					    		
					    	// Parametro de configuracion 1
			    			// ----------------------------
			    			// Local --> p_tipo [centro,dpto,otro]
							configUrl1 = execUrl + 'o/ehu-xsl-content-web/' + appClass + '/' + appClass + '.json';
							setValuesJson(A,configUrl1,prefConfigParamsValue,prefConfigParamsArray,0,configField1);
							//console.log("ONLOAD: " + configUrl1 );

							// Parametro de configuracion 2
			    			// ----------------------------
							// Si existen valores de configuracion almacenados y son de la aplicacion LDAP, se recuperan las opciones del segundo campo de configuracion en funcion del valor almacenado
							if( (prefConfigParamsValue != '') && (appValue == 'ldap') ){									  
					    		configUrl2 = appUrl + "ldap-xml.php?p_cod_proceso=" + appValue + "&p_cod_idioma=<%=paramLanguage%>&p_tipo=" + prefConfigParamsArray[0];
					    	}
					    	// Si NO existen valores de configuracion almacenados de la aplicacion LDAP, se recuperan las opciones por defecto (centro)
					    	else{
					    		configUrl2 = appUrl + "ldap-xml.php?p_cod_proceso=" + appClass + "&p_cod_idioma=<%=paramLanguage%>&p_tipo=centro";
					    	}
					    	setValuesXml(A,configUrl2,prefConfigParamsArray[0],'cod','',prefConfigParamsValue,prefConfigParamsArray,1,configField2);
							
					    	// Si cambia el tipo se recarga la lista de centros, dptos ou otros correspondiente 
							configField1.on(
								'change',
							    function() {
							    	configUrl2 = appUrl + "ldap-xml.php?p_cod_proceso=" + appClass + "&p_cod_idioma=<%=paramLanguage%>&p_tipo=" + configField1.val();			    		                
							        setValuesXml(A,configUrl2,configField1.val(),'cod','',prefConfigParamsValue,prefConfigParamsArray,1,configField2);
								}
					    	);
					    }
					    
					    // ---------------------------------------------------- //
				        // -------------- Departamento (department) ----------- //
				        // -------------- Nuevo Grado (egr) -------------- //
				        // -------------- Nuevo Master (master-epg) -------------- //				    
					    else if ((appClass == 'department')  || (appClass == 'egr') || (appClass == 'master-epg') || (appClass == 'master-own')
					    || (appClass == 'master-own-module') || (appClass == 'doctorate')){
					    	
					    	// Parametro de configuracion 1
					    	// ----------------------------
					    	//	Oferta de Grados (plew0040-offer): p_anyo (curso actual o futuro [act,fut]), se recupera localmente via fichero JSON
					    	// 	Departamento (department): p_nav (vista de informacion a presentar), se recupera localmente via fichero JSON
					    	// 	Nuevo Grado (egr): p_nav (vista de informacion a presentar), se recupera localmente via fichero JSON
					    	// 	Nuevo Master (master-epg): p_nav (vista de informacion a presentar), se recupera localmente via fichero JSON
					    	// 	Nuevo Master Propio (plew030): p_nav (vista de informacion a presentar), se recupera localmente via fichero JSONs
					    	
					    	
					    	configUrl1 = execUrl + 'o/ehu-xsl-content-web/' + appClass + '/' + appClass + '.json';
						    setValuesJson(A,configUrl1,prefConfigParamsValue,prefConfigParamsArray,0,configField1);
						   	//console.log("ONLOAD: " + configUrl1 );
						 
						    
						    // En la aplicacion de departamentos si cambia la informacion a mostrar (Asignaturas de grados o Masteres) se cambia la lista de departamentos
						    if (appClass == 'department'){
								configField1.on(
									'change',
								    function() {
								    	// Asignaturas de masteres 
										if (configField1.val() == 2){
											//configUrl2 = gaurUrl + "gaurutil/ofertaDepartamentos?p_cod_proceso=plew0050&p_cod_idioma=<%=paramLanguage%>&p_anyo=act&p_nav=1";
											configUrl2 = gaurUrl + "gaurutil/departamentos?p_cod_proceso=plew0050&p_cod_idioma=<%=paramLanguage%>";
										} 
										//Asignaturas de grados  
										else{
											//configUrl2 = gaurUrl + "gaurutil/ofertaDepartamentos?p_cod_proceso=plew0040&p_cod_idioma=<%=paramLanguage%>&p_anyo=act&p_nav=1";
											configUrl2 = gaurUrl + "gaurutil/departamentos?p_cod_proceso=plew0040&p_cod_idioma=<%=paramLanguage%>";
										}
										setValuesXml(A,configUrl2,'option','val','',prefConfigParamsValue,prefConfigParamsArray,1,configField2);	
									}
								);
							}	
						    	
					    	
					    	// ---------------------------------------------------- //
					    	// -------------- Departamento (department) ----------- //
				        	// ---------------------------------------------------- // 
					    	else if (appClass == 'department') {
					    		
					    		// Parametro de configuracion 2
					    		// ----------------------------  
						    	// p_anyo: siempre es el aï¿½o actual
						    	// p_nav: requerido aunque no se utiliza para nada
						    	// p_cod_dpto: (identificativo de departamento)
					    		
			    				// Asignaturas de masteres 
								if (configField1.val() == 2){
									configUrl2 = gaurUrl + "gaurutil/departamentos?p_cod_proceso=plew0050&p_cod_idioma=<%=paramLanguage%>";
								} 
								// Asignaturas de grados   
								else {
									//configUrl2 = gaurUrl + "gaurutil/ofertaDepartamentos?p_cod_proceso=plew0040&p_cod_idioma=<%=paramLanguage%>&p_anyo=act&p_nav=1";
									configUrl2 = gaurUrl + "gaurutil/departamentos?p_cod_proceso=plew0040&p_cod_idioma=<%=paramLanguage%>";
								}
								setValuesXml(A,configUrl2,'option','val','',prefConfigParamsValue,prefConfigParamsArray,1,configField2);
					    	}
					    	// -------------------------------------------------- //
					    	// -------------- Nuevo Grado (egr) ------------ //
					    	// -------------------------------------------------- //
					    	else if (appClass == 'egr') {
					    	
								// Parametro de configuracion 2
						    	// ----------------------------  
						    	// p_anyo: (identificativo de curso actual/futuro [act/fut]), se recupera localmente via fichero JSON de la aplicacion Oferta de Grados (plew0040-offer)
						    	 
						    	configUrl2 = execUrl + 'o/ehu-xsl-content-web/plew0040-offer/plew0040-offer.json';
								setValuesJson(A,configUrl2,prefConfigParamsValue,prefConfigParamsArray,1,configField2);
		
								
								// Parametro de configuracion 3 
								// ----------------------------
								// p_cod_centro: (identificativo de centro), se recupera via XML
								
								// Parametro de configuracion 4
						    	// ----------------------------
						    	// p_cod_plan: (identificativo de plan de estudios), se recupera via XML de la oferta de Grados
								
								// Si existen valores de configuracion almacenados y son de la aplicacion Nuevo Grado, se recuperan las opciones de los campos de configuracion en funcion del valor almacenado
								if( (prefConfigParamsValue != '') && (appValue == 'egr') ){
									configUrl3 = gaurUrl + "gaurutil/centros?p_cod_proceso=" + appClass + "&p_cod_idioma=<%=paramLanguage%>" + "&p_anyo_acad=" + configField2.val();
									setValuesXml(A,configUrl3,'option','val','',prefConfigParamsValue,prefConfigParamsArray,2,configField3);
				    	  			configUrl4 = gaurUrl + "gaurutil/titulaciones?p_cod_proceso=" + appClass + "&p_cod_idioma=<%=paramLanguage%>" + "&p_anyo_acad=" + configField2.val() + "&p_cod_centro=" + configField3.val();
								}
								// Si NO existen valores de configuracion almacenados de la aplicacion Nuevo Grado, se cargan los valores por defecto (Año actual y Escuela Técnica Superior de Arquitectura)								
								else {
								  	configUrl3 = gaurUrl + "gaurutil/centros?p_cod_proceso=" + appClass + "&p_cod_idioma=<%=paramLanguage%>" + "&p_anyo_acad=act";
								  	setValuesXml(A,configUrl3,'option','val','',prefConfigParamsValue,prefConfigParamsArray,2,configField3);
						    		configUrl4 = gaurUrl + "gaurutil/titulaciones?p_cod_proceso=" + appClass + "&p_cod_idioma=<%=paramLanguage%>" + "&p_anyo_acad=act&p_cod_centro=240";
								}	
								
								setValuesXml(A,configUrl4,'option','val','',prefConfigParamsValue,prefConfigParamsArray,3,configField4);    
								
								// Si cambia el centro se recargan las titulaciones
								configField3.on(
									'change',
								    function() {
								    	configUrl4 = gaurUrl + "gaurutil/titulaciones?p_cod_proceso=" + appClass + "&p_cod_idioma=<%=paramLanguage%>" + "&p_anyo_acad=" + configField2.val() + "&p_cod_centro=" + configField3.val();			    		                
								        setValuesXml(A,configUrl4,'option','val','',prefConfigParamsValue,prefConfigParamsArray,3,configField4);
									}
							    );
							    	
					    	} 
					    	// -------------------------------------------------- //
					    	// -------------- Nuevo Master (epg) (plew0050) ----------------- //
					    	// -------------------------------------------------- //
					    	else if  (appClass == 'master-epg') {
					    	
					    		// Parametro de configuracion 2
								// ----------------------------  
								// p_anyo: (identificativo de curso actual/futuro [act/fut]), se recupera localmente via fichero JSON de la aplicacion Oferta de Masteres (plew0050-offer) 
					
								configUrl2 = execUrl + 'o/ehu-xsl-content-web/common/year-offer.json';
								setValuesJson(A,configUrl2,prefConfigParamsValue,prefConfigParamsArray,1,configField2);
					
					    		
					    		// Parametro de configuracion 3
								// ----------------------------
					    		// Si existen valores de configuracion almacenados y son de la aplicacion Master, se recuperan las opciones de los campos de configuracion en funcion del valor almacenado
								if( (prefConfigParamsValue != '') && (appValue == 'master-epg') ){
								    configUrl3 = gaurUrl + "gaurpop/ofertaMasteres?p_cod_proceso=" + appClass + "&p_cod_idioma=<%=paramLanguage%>" + "&p_nav=1&p_anyo=" + prefConfigParamsArray[1];
								}
								// Si NO existen valores de configuracion almacenados de la aplicacion Master, se carga el valor por defecto (Aï¿½o actual) 
								else {
								    configUrl3 = gaurUrl + "gaurpop/ofertaMasteres?p_cod_proceso=" + appClass + "&p_cod_idioma=<%=paramLanguage%>" + "&p_nav=1&p_anyo=act";
								}
								setValuesXml(A,configUrl3,'master','codMaster','denMaster',prefConfigParamsValue,prefConfigParamsArray,2,configField3);
					    	  	
					    	}
					    	
					    	// -------------------------------------------------- //
					    	// -------------- Nuevo Master Propio (plew0030) ----------------- //
					    	// -------------------------------------------------- //
					    	else if  (appClass == 'master-own') {
					    	  	
					    		// Parametro de configuracion 2
					    		// ----------------------------  
					    		configUrl2 = gaurUrl + "gaurtpr/ofertaTitulosPropios?p_cod_proceso=" + appClass + "&p_cod_idioma=<%=paramLanguage%>" + "&p_nav=";
					    		setValuesXml(A,configUrl2,'programa','codPrograma','descPrograma',prefConfigParamsValue,prefConfigParamsArray,1,configField2);
					    	}
					    	
					    	// -------------------------------------------------- //
					    	// -------------- Titulo Propio Modulo -------------- //
					    	// -------------------------------------------------- //
					    	else if  (appClass == 'master-own-module') {
			    			
					    			
					    		// Parametro de configuracion 2
					    		// ----------------------------  
								if( (prefConfigParamsValue != '') && (appValue == 'master-own-module') ){
					    		
						    		configUrl2 = gaurUrl + "gaurtpr/ofertaTitulosPropios?p_cod_proceso=" + appClass + "&p_cod_idioma=<%=paramLanguage%>" + "&p_nav=1" + "&p_cod_programa=" + prefConfigParamsArray[1];
						    		setValuesXml2(A,configUrl2,'programa','codPrograma','descPrograma',prefConfigParamsValue,prefConfigParamsArray,1,configField2);
								  	
								  	if (prefConfigParamsArray[0] == '301' || prefConfigParamsArray[0] == '302' || prefConfigParamsArray[0] == '304') {
									  	configUrl3 = gaurUrl + "gaurtpr/consultaTituloPropio?p_cod_proceso=" + appClass + "&p_cod_idioma=<%=paramLanguage%>"+ "&p_nav=1" + "&p_cod_programa=" + prefConfigParamsArray[1]
									  		+ "&p_cod_curso=" + prefConfigParamsArray[2];
								  		setValuesXml2(A,configUrl3,'modulo','codModulo','denModulo',prefConfigParamsValue,prefConfigParamsArray,2,configField3);
								  	} else {
								  		var fieldInitial = document.getElementById("<portlet:namespace />config-3");
								  		hideSpecificConfiguration(fieldInitial);
					    				updateEmptyValueConfiguration(configField3);
								  	}
								  	
					    		}
								// Si NO existen valores de configuracion almacenados de la aplicacion Grado, se cargan los valores por defecto (Aï¿½o actual y Escuela Tï¿½cnica Superior de Arquitectura)								
								else {
								  	configUrl2 = gaurUrl + "gaurtpr/ofertaTitulosPropios?p_cod_proceso=" + appClass + "&p_cod_idioma=<%=paramLanguage%>" + "&p_nav=1";
						    		setValuesXml2(A,configUrl2,'programa','codPrograma','descPrograma',prefConfigParamsValue,prefConfigParamsArray,1,configField2);
						  	configUrl3 = gaurUrl +  "gaurtpr/consultaTituloPropio?p_cod_proceso=" + appClass + "&p_cod_idioma=<%=paramLanguage%>" + "&p_nav=1" + "&p_cod_programa=" + configField2.val() + "&p_cod_curso=";			    		                
					        setValuesXml2(A,configUrl3,'modulo','codModulo','denModulo',prefConfigParamsValue,prefConfigParamsArray,2,configField3);
								}
								
					    		configField2.on(
									'change',
								    function() {						    
								    	updateEmptyValueConfiguration(configField3);
								    	if (configField1.val() == 301 || configField1.val() == 302 || configField1.val() == 304) {
									    	configUrl3 = gaurUrl +  "gaurtpr/consultaTituloPropio?p_cod_proceso=" + appClass + "&p_cod_idioma=<%=paramLanguage%>" + "&p_nav=1" + "&p_cod_programa=" + configField2.val() + "&p_cod_curso=";			    		                
									        setValuesXml2(A,configUrl3,'modulo','codModulo','denModulo',prefConfigParamsValue,prefConfigParamsArray,2,configField3);
								        } else {
											configField3.hide();
											configField3.empty();
											updateEmptyValueConfiguration(configField3);
								        }
									}
								);
								configField1.on(
									'change',
								    function() {
								    	if (configField1.val() != 301 && configField1.val() != 302 && configField1.val() != 304) {
											configField3.hide();
											configField3.empty();
											updateEmptyValueConfiguration(configField3);
										} else {
											configUrl3 = gaurUrl +  "gaurtpr/consultaTituloPropio?p_cod_proceso=" + appClass + "&p_cod_idioma=<%=paramLanguage%>" + "&p_nav=1" + "&p_cod_programa=" + configField2.val() + "&p_cod_curso=";			    		                
									        setValuesXml2(A,configUrl3,'modulo','codModulo','denModulo',prefConfigParamsValue,prefConfigParamsArray,2,configField3);
										}
									}
								);									    		
					    	}
					    	
					    	// -------------------------------------------------- //
					    	// -------------- Doctorados  ----------------------- //
					    	// -------------------------------------------------- //
					    	else if  (appClass == 'doctorate') {
							    	  	
					    		// Parametro de configuracion 2
					    		// ----------------------------  					    		
			    				configUrl2 = gaurUrl + "gaurpdc/ofertaDoctorados?p_cod_proceso=" + appClass + "&p_cod_idioma=<%=paramLanguage%>" + "&p_nav=";
			    				setValuesXml(A,configUrl2,'doctorado','codPropuesta','desPropuesta',prefConfigParamsValue,prefConfigParamsArray,1,configField2);
			    
					    	}
					    	
				    	} // Aplicaciones configurables GAUR
	        		} // Aplicacion configurable
	    			// Si la aplicacion seleccionada NO es configurable
		            else {
		            	voidConfiguration(configField1,configField2,configField3,configField4);
		            	hideConfiguration(configField1,configField2,configField3,configField4);
		            }          			               	 
	            } // Alguna aplicacion seleccionada
        		// Si se seleccionada la opcion vacia  
		        else {
		        	// Se vacia el campo de preferencias de configuracion
					prefConfigParams.set('value','');
					
					// Se asignan los valores por defecto a las URLs para la recuperaciï¿½n de datos y su renderizado
					prefUrlXml.setAttribute('value',defaultUrlXml);
					prefUrlXsl.setAttribute('value',defaultUrlXsl); 
					hideConfiguration(configField1,configField2,configField3,configField4);
		        }				
           }
        );
        
    	// ----------- Guardar ------------ //
    	// Al guardar los cambios se asignan los valores de configuracion al campo de preferencias de configuracion cuando tengan valor seleccionado, sino a vacio
		btnSave.on(
    		'click', 
    		function(){
    			// end doctorado solo se utiliza un parametro para las opciones de configuracion --> p_nav por lo tanto, el valor del primer y segundo
				//combo se envia conjuntamente en p_nav
    			if(appClass == 'plew0060'){
    				prefConfigParamsValue = '';
					if (configField1.val()!='') {prefConfigParamsValue += configField1.val();}
					if (configField2.val()!='') {prefConfigParamsValue += configField2.val();}
			    	if (configField3.val()!='') {prefConfigParamsValue += ',' + configField3.val();}
			    	if (configField4.val()!='') {prefConfigParamsValue += ',' + configField4.val();}
			    	if ( (configField1.val() == '') && (configField2.val() =='') && (configField3.val() == '') && (configField4.val() =='') ){
			    		prefConfigParams.set('value','');
					} else {
						prefConfigParams.set('value',prefConfigParamsValue);
					}
    			}else{
    				prefConfigParamsValue = '';
					if (configField1.val()!='') {prefConfigParamsValue += configField1.val();}
					if (configField2.val()!='') {prefConfigParamsValue += ',' + configField2.val();}
			    	if (configField3.val()!='') {prefConfigParamsValue += ',' + configField3.val();}
			    	if (configField4.val()!='') {prefConfigParamsValue += ',' + configField4.val();}
			    	if ( (configField1.val() == '') && (configField2.val() =='') && (configField3.val() == '') && (configField4.val() =='') ){
			    		prefConfigParams.set('value','');
					} else {
						prefConfigParams.set('value',prefConfigParamsValue);
					}
    			}
				
			}
		);    
    
 	}
 );	
 
 /**
  *
  * Llamada Ajax para cargar el campo de configuracion (configField) con el contenido del fichero JSON existente en la URL.
  *	Si el existe una configuracion guardada (prefConfigParamsValue) se marca la opcion seleccionada con el valor que corresponda (Indice del array de configuraciones guardadas)  
  *
  * @param {String} functionName
  * @param {String} url: URL del JSON a partir del cual se cargan los posibles valores de configuracion
  * @param {String} prefConfigParamsValue: Valor de la configuracion almacenada
  * @param {Array} prefConfigParamsArray: Array de configuraciones almacenadas
  * @param {int} prefConfigParamIndex: Indice del array de configuraciones almacenadas 
  * @param {String} configField: Nombre del campo de configuracion
  *
  */
	function setValuesJson (functionName,url,prefConfigParamsValue,prefConfigParamsArray,prefConfigParamIndex,configField) {
		functionName.io.request(
			url,
				{
					//headers:{'X-Requested-With': 'XMLHttpRequest'},
					method: 'GET',
					dataType: 'json',
				    on: {
				    	success: function() {
				        	var data = this.get('responseData');
							config = data.config;
							var configValue;
							for (i = 0; i < config.length; i++) {
								configValue = config[i].val;
								if( (prefConfigParamsValue != '') && (configValue == prefConfigParamsArray[prefConfigParamIndex]) ) {
									configField.append('<option selected="selected" value="' + config[i].val + '">' + config[i].label.<%=paramLanguage%> + '</option>');
									configField.val(config[i].val);
								}else{
									configField.append('<option value="' + config[i].val + '">' + config[i].label.<%=paramLanguage%> + '</option>');
								}							            	
							}			                			  
				        }
				    }
				}
		);
		configField.show();
   }
 
 /**
  *
  * Llamada Ajax para cargar el campo de configuracion (configField) en un combo de seleccion con el contenido del fichero XML existente en la URL.
  * Las opciones del combo de seleccion se cargan con cada node (tagName) teniendo cada una de ellas el valor (attributeName)    
  *	Si el existe una configuracion guardada (prefConfigParamsValue) se marca la opcion que corresponda a partir del array de configuraciones guardadas
  *
  * @param {String} functionName
  * @param {String} url: URL del XML a partir del cual se cargan los posibles valores de configuracion
  * @param {String} tagName: Nombre del tag equiparable a una opcion del combo de seleccion
  * @param {String} attribute: Valor de una opcion del combo de seleccion. Puede ser un atributo del tagName o un tag hijo del tagName
  * @param {String} text: Texto de una opcion del combo de seleccion. 
  * @param {String} prefConfigParamsValue: Valor de la configuracion almacenada
  * @param {Array} prefConfigParamsArray: Array de configuraciones almacenadas
  * @param {int} prefConfigParamIndex: Indice del array de configuraciones almacenadas 
  * @param {String} configField: Campo de configuracion
  *
  */
	function setValuesXml(functionName,url,tagName,attribute,text,prefConfigParamsValue,prefConfigParamsArray,prefConfigParamIndex,configField) {
	
		functionName.io.request(
			url,
				{
					// Edorta: se añade 'Content-Type': 'application/xml' a petición de MW ya que salta un warning en el log si no se mete esta cabecera
					headers:{'X-Requested-With': 'XMLHttpRequest',
							'Content-Type': 'application/xml'},
					method: 'GET',
					dataType: 'xml',
				    on: {
				    	success: function() {
				        	// Se vacia el campo de configuracion
							configField.empty();          		
							var nodeValue;
							var nodeText;
					        functionName.one(this.get('responseData')).all(tagName).each(
					        
						    	function (node) {
						    		// Si el tag "tagName" tiene el atributo "attribute" 
						    		if (node.hasAttribute(attribute)){
										nodeValue = node.getAttribute(attribute);
										nodeText = node.text();										
									}	
									// Si el tag "tagName" NO tiene el atributo "attribute", se entiende que "attribute" es el nombre del tag hijo del "tagName" 
									else {
										nodeValue = node.getElementsByTagName(attribute).text();
										if((nodeValue != '632') && (nodeValue != '633') && (nodeValue != '634') && (nodeValue != '635') && (nodeValue != '637') 
																				&& (nodeValue != '638') && (nodeValue != '639') && (nodeValue != '640')){
											nodeText = node.getElementsByTagName(text).text();
										}else{
											nodeText = '(' + nodeValue + ') ' + node.getElementsByTagName(text).text();
										}
									}
								//	alert(prefConfigParamsValue);
								//	alert(nodeValue);
								//	alert(prefConfigParamsArray[prefConfigParamIndex]);
									 
									if( (prefConfigParamsValue != '') && (nodeValue == prefConfigParamsArray[prefConfigParamIndex]) ) {
										configField.append('<option selected="selected" value="' + nodeValue + '">' + nodeText + '</option>');
										configField.val(nodeValue);
									}else if (nodeValue != '') {
										configField.append('<option value="' + nodeValue + '">' + nodeText + '</option>')
									}
								}	
					        );  		
					     //  alert(this.get('responseData'));	                			  
				        }
				    }
				}
		);
		configField.show();	    
   }
   
   /**
  *
  * Llamada Ajax para cargar el campo de configuracion (configField) en un combo de seleccion con el contenido del fichero XML existente en la URL.
  * Las opciones del combo de seleccion se cargan con cada node (tagName) teniendo cada una de ellas el valor (attributeName)    
  *	Si el existe una configuracion guardada (prefConfigParamsValue) se marca la opcion que corresponda a partir del array de configuraciones guardadas
  *
  * @param {String} functionName
  * @param {String} url: URL del XML a partir del cual se cargan los posibles valores de configuracion
  * @param {String} tagName: Nombre del tag equiparable a una opcion del combo de seleccion
  * @param {String} attribute: Valor de una opcion del combo de seleccion. Puede ser un atributo del tagName o un tag hijo del tagName
  * @param {String} text: Texto de una opcion del combo de seleccion. 
  * @param {String} prefConfigParamsValue: Valor de la configuracion almacenada
  * @param {Array} prefConfigParamsArray: Array de configuraciones almacenadas
  * @param {int} prefConfigParamIndex: Indice del array de configuraciones almacenadas 
  * @param {String} configField: Campo de configuracion
  *
  */
	function setValuesXml2(functionName,url,tagName,attribute,text,prefConfigParamsValue,prefConfigParamsArray,prefConfigParamIndex,configField) {
		functionName.io.request(
			url,
				{
					// Edorta: se aï¿½ade 'Content-Type': 'application/xml' a peticiï¿½n de MW ya que salta un warning en el log si no se mete esta cabecera
					headers:{'X-Requested-With': 'XMLHttpRequest',
							'Content-Type': 'application/xml'},
					method: 'GET',
					dataType: 'xml',
				    on: {
				    	success: function() {
				        	// Se vacia el campo de configuracion
							configField.empty();          		
							var nodeValue;
							var nodeText;
					        functionName.one(this.get('responseData')).all(tagName).each(
					        
						    	function (node) {
						    		// Si el tag "tagName" tiene el atributo "attribute" 
						    		if (node.hasAttribute(attribute)){
										nodeValue = node.getAttribute(attribute);
										nodeText = node.text();										
									}	
									// Si el tag "tagName" NO tiene el atributo "attribute", se entiende que "attribute" es el nombre del tag hijo del "tagName" 
									else {
										nodeValue = node.getElementsByTagName(attribute).text();
										if((nodeValue != '632') && (nodeValue != '633') && (nodeValue != '634') && (nodeValue != '635') && (nodeValue != '637') 
																				&& (nodeValue != '638') && (nodeValue != '639') && (nodeValue != '640')){
											nodeText = node.getElementsByTagName(text).text();
										}else{
											nodeText = '(' + nodeValue + ') ' + node.getElementsByTagName(text).text();
										}
									}
								//	alert(prefConfigParamsValue);
								//	alert(nodeValue);
								//	alert(prefConfigParamsArray[prefConfigParamIndex]);
									 
									if( (prefConfigParamsValue != '') && (nodeValue == prefConfigParamsArray[prefConfigParamIndex]) ) {
										configField.append('<option selected="selected" value="' + nodeValue + '">' + nodeText + '</option>');
										configField.val(nodeValue);
									}else if (nodeValue != '') {
										configField.append('<option value="' + nodeValue + '">' + nodeText + '</option>');
									}
								}	
					        );  		
					    	updateEmptyValueConfiguration(configField);                			  
				        }
				    }
				}
		);

		configField.show();	    
   }
   
 
  /**
  *
  * Comprueba si el campo fieldName esta vacío y lo setea con una opción a null
  *
  */
	function updateEmptyValueConfiguration(fieldName) {
		if(fieldName.val() == '') {
			fieldName.append('<option selected="selected" value="&"></option>');
			fieldName.val('&');
		}	  
   }
   
  /**
  *
  * Oculta el campo fieldName
  *
  */
	function hideSpecificConfiguration(fieldName) {
		fieldName.style.display = "none";  
   }
   
    /**
  *
  * Muestra el campo fieldName
  *
  */
	function showSpecificConfiguration(fieldName) {
		fieldName.style.display = "block";    
   }
 
 /**
  *
  * Ocultar los campos de configuracion fieldName1,fieldName2,fieldName3,fieldName4
  *
  */
	function hideConfiguration(fieldName1,fieldName2,fieldName3,fieldName4) {
		fieldName1.hide();            		
		fieldName2.hide();
		fieldName3.hide();		            	            		
		fieldName4.hide();
   }
   
  /**
  *
  * Vaciar los campos de configuracion fieldName1,fieldName2,fieldName3,fieldName4 
  *
  * @param {String} fieldName1
  * @param {String} fieldName2
  * @param {String} fieldName3
  * @param {String} fieldName4
  */
   function voidConfiguration(fieldName1,fieldName2,fieldName3,fieldName4) {
		fieldName1.empty();
		fieldName2.empty();
		fieldName3.empty();
		fieldName4.empty();		
   } 
 
  </aui:script>
<%-- upv/ehu - upv/ehu --%>