<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0" xmlns:ehu="http://www.ehu.eus"
	xmlns:exsl="http://exslt.org/common" 
	xmlns:xalan="http://xml.apache.org/xalan"
	xmlns:languageUtil="xalan://com.liferay.portal.kernel.language.LanguageUtil"
	xmlns:propsUtil="com.liferay.portal.kernel.util.PropsUtil"
	xmlns:StringPool="com.liferay.portal.kernel.util.StringPool"
	exclude-result-prefixes="xalan" 
	extension-element-prefixes="exsl languageUtil propsUtil StringPool xalan">

	<xsl:output method="xml" omit-xml-declaration="yes" />
		
	<xsl:variable name="programa" select="ehu:app/ehu:programas/ehu:programa" />
	<xsl:variable name="p_cod_programa" select="ehu:app/ehu:parameters/ehu:parameter[@name='p_cod_programa']"/>
	
	<xsl:template name="presentacion">
		<xsl:element name="div">
			<xsl:attribute name="class">bg-white p-20 ehu-sans</xsl:attribute>
			<xsl:element name="div">
				<xsl:attribute name="class">row</xsl:attribute>
				<xsl:element name="div">
					<xsl:attribute name="class">col-md-6</xsl:attribute>
					<h3><xsl:value-of select="languageUtil:get($locale,'ehu.plazasOfertadas')"/></h3>
					<p>
						<xsl:value-of select="$programa/ehu:maxAlumAdmitidos"/>
					</p>
				</xsl:element>
				<xsl:element name="div">
					<xsl:attribute name="class">col-md-6</xsl:attribute>
					<h3><xsl:value-of select="languageUtil:get($locale,'ehu.modalidad')"/></h3>
					<p>
					<xsl:choose>
						<xsl:when test="format-number($programa/ehu:modalidad/ehu:mixta,'###') != 0 or (format-number($programa/ehu:modalidad/ehu:onLine,'###') != 0 and format-number($programa/ehu:modalidad/ehu:presencial,'###') != 0)">
							<xsl:value-of select="languageUtil:get($locale,'upv-ehu.masters.semipresential')"/>
						</xsl:when>
						<xsl:when test="format-number($programa/ehu:modalidad/ehu:onLine,'###') != 0">
							<xsl:value-of select="languageUtil:get($locale,'upv-ehu.masters.online')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="languageUtil:get($locale,'upv-ehu.masters.presential')"/>
						</xsl:otherwise>
					</xsl:choose>
					</p>
				</xsl:element>
			</xsl:element>
			
			<xsl:element name="div">
				<xsl:attribute name="class">row</xsl:attribute>
				<xsl:element name="div">
					<xsl:attribute name="class">col-md-6</xsl:attribute>
					<h3><xsl:value-of select="languageUtil:get($locale,'ehu.idioma')"/></h3>
					<xsl:element name="p">
						<xsl:value-of select="$programa/ehu:idioma"/>
					</xsl:element>
				</xsl:element>
				<xsl:element name="div">
					<xsl:attribute name="class">col-md-6</xsl:attribute>
					<h3><xsl:value-of select="languageUtil:get($locale,'upv-ehu.calendar')"/></h3>
					<xsl:element name="span">
						<xsl:call-template name="formatFechaWName">
							<xsl:with-param name="date_wz" select="$programa/ehu:fecIniImparticion" />
						</xsl:call-template>
					</xsl:element>
					<xsl:element name="p">
						<xsl:call-template name="formatFechaWName">
							<xsl:with-param name="date_wz" select="$programa/ehu:fecFinImparticion" />
						</xsl:call-template>
					</xsl:element>
				</xsl:element>
			</xsl:element>
		
			<xsl:element name="div">
				<xsl:value-of select="$white_space"/>
			</xsl:element>
			
			<xsl:element name="div">
				<xsl:attribute name="class">row</xsl:attribute>
				<xsl:element name="div">
					<xsl:attribute name="class">col-md-6</xsl:attribute>
					<h3><xsl:value-of select="languageUtil:get($locale,'ehu.numCreditos')"/></h3>
					<xsl:element name="p">
						
						<xsl:value-of select="format-number($programa/ehu:numCreditos,'###')"/>
						<xsl:value-of select="$white_space"/>
						<!-- 
						<xsl:value-of select="languageUtil:get($locale, 'upv-ehu.master.own.ehu.creditosECTS')"/>
						 -->
						
						<!-- Pintamos el orden del título según el idioma -->
						<!-- Euskera & English -->
						<xsl:if test="(languageUtil:getLanguageId($locale) = 'eu_ES') or (languageUtil:getLanguageId($locale) = 'en_GB')">
							<xsl:element name="abbr"><xsl:attribute name="title"><xsl:value-of select="languageUtil:get($locale,'ehu.title.ects')"/></xsl:attribute>ECTS</xsl:element>&#160;<xsl:value-of select="languageUtil:get($locale,'ehu.es-eu-en-fr-credits')"/>
						</xsl:if>
						<!-- Castellano & Francais -->
						<xsl:if test="(languageUtil:getLanguageId($locale) = 'es_ES') or (languageUtil:getLanguageId($locale) = 'fr_FR')">
							<xsl:value-of select="languageUtil:get($locale,'ehu.es-eu-en-fr-credits')"/>&#160;<xsl:element name="abbr"><xsl:attribute name="title"><xsl:value-of select="languageUtil:get($locale,'ehu.title.ects')"/></xsl:attribute>ECTS</xsl:element>
						</xsl:if>
						
					</xsl:element>
				</xsl:element>
				
				<xsl:element name="div">
					<xsl:attribute name="class">col-md-6</xsl:attribute>
					<h3><xsl:value-of select="languageUtil:get($locale,'upv-ehu.masters.home.guideprice')"/></h3>
					<xsl:variable name="precioMatricula" select="$programa/ehu:numCreditos * $programa/ehu:precioCredito"/>
					<p><xsl:value-of select="format-number(round($precioMatricula div 100) * 100, '#.###,#', 'european')"/><xsl:value-of select="$white_space"/>€</p>
				</xsl:element>
			</xsl:element>
			
			<xsl:element name="div">
				<xsl:attribute name="class">row</xsl:attribute>
				<xsl:element name="div">
					<xsl:attribute name="class">col-md-6</xsl:attribute>
					<h3><xsl:value-of select="languageUtil:get($locale,'ehu.lugarImparticion')"/></h3>
					<p><xsl:value-of select="$programa/ehu:lugarImparticion/ehu:centro"/></p>
				</xsl:element>	
				
				<xsl:if test="$programa/ehu:centroResponsable">
					<xsl:element name="div">
						<xsl:attribute name="class">col-md-6</xsl:attribute>
						<h3><xsl:value-of select="languageUtil:get($locale,'ehu.responsible')"/></h3>
						<p class="m-b-0"><xsl:value-of select="$programa/ehu:centroResponsable"/></p>
					</xsl:element>
				</xsl:if>
			</xsl:element>
			
			<xsl:element name="div">
				<xsl:attribute name="class">row</xsl:attribute>
				<xsl:element name="div">
					<xsl:attribute name="class">col-12</xsl:attribute>
					<h3><xsl:value-of select="languageUtil:get($locale,'ehu.contacto')"/></h3>
					<xsl:if test="$programa/ehu:oficinaInf/ehu:contacto/ehu:mail">
						<xsl:element name="a">
							<xsl:attribute name="href">mailto:<xsl:value-of select="$programa/ehu:oficinaInf/ehu:contacto/ehu:mail"/></xsl:attribute>
							<xsl:attribute name="class">email-icon</xsl:attribute>
							<xsl:value-of select="$programa/ehu:oficinaInf/ehu:contacto/ehu:mail"/>
						</xsl:element>
					</xsl:if>
					<xsl:if test="$programa/ehu:oficinaInf/ehu:contacto/ehu:tfno and $programa/ehu:oficinaInf/ehu:contacto/ehu:tfno != '-'">
						<br/><xsl:element name="a">
							<xsl:attribute name="href">tel:<xsl:value-of select="$programa/ehu:oficinaInf/ehu:contacto/ehu:tfno"/></xsl:attribute>
							<xsl:value-of select="$programa/ehu:oficinaInf/ehu:contacto/ehu:tfno"/>
						</xsl:element>
					</xsl:if>
				</xsl:element>
			</xsl:element>
			
			<xsl:if test="$programa[ehu:tipoPagina='1']">
				<xsl:element name="div">
					<xsl:attribute name="class">row m-t-20 m-b-30</xsl:attribute>
					<xsl:element name="div">
						<xsl:attribute name="class">col-12</xsl:attribute>
							<a>
								<xsl:attribute name="class">p-10 btn btn-upv btn-primary</xsl:attribute>
								<xsl:attribute name="id">linkMasterOwn</xsl:attribute>
								<xsl:attribute name="data-path"><xsl:value-of select="languageUtil:get($locale,'upv-ehu.master.own.modular-structure.url')"/></xsl:attribute>
								<xsl:value-of select="languageUtil:get($locale,'upv-ehu.master.own.presentation.link')"/>
							</a>
					</xsl:element>
				</xsl:element>
				
				<script type="text/javascript">
					window.onload = function(){
						var link = document.getElementById("linkMasterOwn");
					    link.href = location.pathname + link.getAttribute('data-path');
					}
				</script>
			</xsl:if>
						
		</xsl:element>
	</xsl:template>
	
	
	<xsl:template name="listaProfesorado">
		<xsl:element name="div">
			<xsl:attribute name="class">m-b-30</xsl:attribute>
			<xsl:element name="div">
				<xsl:attribute name="class">bg-white p-20</xsl:attribute>
				<xsl:element name="ul">
					<xsl:attribute name="class">list-links</xsl:attribute>
					
					<xsl:for-each select="$programa/ehu:profesores/ehu:profesor[ehu:indUpv='1']">
						<xsl:sort select="ehu:nomProfesor"/>
						<li><a>
							<xsl:attribute name="href">?p_redirect=fichaPDI&amp;p_idp=<xsl:value-of select="ehu:idpProfesor"/></xsl:attribute>
						 	<xsl:call-template name="CamelCase">
								<xsl:with-param name="text"><xsl:value-of select="ehu:nomProfesor" /></xsl:with-param>
							</xsl:call-template>
						</a></li>
					</xsl:for-each>
					
				</xsl:element>
			</xsl:element>
		</xsl:element>
		
		<xsl:if test="$programa/ehu:profesores/ehu:profesor[ehu:indUpv='0']">
			<h2><xsl:value-of select="languageUtil:get($locale,'ehu.profesoradoAjeno')"/></h2>
			<xsl:element name="div">
				<xsl:attribute name="class">m-b-30</xsl:attribute>
				<xsl:element name="div">
					<xsl:attribute name="class">bg-white p-20</xsl:attribute>
					<xsl:element name="ul">
						<xsl:attribute name="class">list-links</xsl:attribute>
						<xsl:for-each select="$programa/ehu:profesores/ehu:profesor[ehu:indUpv='0']">
							<xsl:sort select="ehu:nomProfesor"/>
							<li><a>
								<xsl:attribute name="href">?p_redirect=dameProfesorAjeno&amp;p_cod_proceso=master-own&amp;p_cod_idioma=<xsl:value-of select="$p_cod_idioma"/>&amp;p_cod_programa=<xsl:value-of select="$programa/ehu:codPrograma"/>&amp;p_idp=<xsl:value-of select="ehu:idpProfesor"/>&amp;p_nav=303</xsl:attribute>
							 	<xsl:call-template name="CamelCase">
									<xsl:with-param name="text"><xsl:value-of select="ehu:nomProfesor" /></xsl:with-param>
								</xsl:call-template>
							</a></li>
						</xsl:for-each>
					</xsl:element>
				</xsl:element>
			</xsl:element>
		</xsl:if>
		
	</xsl:template>

		<xsl:template name="vistaProfesorAjeno">
		<xsl:param name="urlBack" />
		
		<xsl:element name="div">
			<xsl:attribute name="class">text-right m-b-30</xsl:attribute>
			<xsl:element name="a">
				<xsl:attribute name="class">btn btn-upv btn-primary</xsl:attribute>
				<xsl:attribute name="href"><xsl:value-of select="$urlBack"/></xsl:attribute>
				<xsl:call-template name="elemento_span_atras"/>
				<xsl:value-of select="languageUtil:get($locale,'back')"/>
			</xsl:element>
		</xsl:element>
		
		
		<xsl:choose>
			<xsl:when test="not($programa/ehu:profesores/ehu:profesor/ehu:nomProfesor) or $programa/ehu:profesores/ehu:profesor/ehu:nomProfesor=''">
				<xsl:element name="div">
					<xsl:attribute name="class">m-b-30</xsl:attribute>
					<xsl:element name="div">
						<xsl:attribute name="class">bg-white p-20</xsl:attribute>
						<p><xsl:value-of select="languageUtil:get($locale,'ehu.there-is-no-information-for-this-section')"/></p>
					</xsl:element>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="div">
					<xsl:attribute name="class">m-b-30</xsl:attribute>
					<xsl:element name="div">
						<xsl:attribute name="class">bg-white p-20 profesorado</xsl:attribute>
						<h2><xsl:value-of select="$programa/ehu:profesores/ehu:profesor/ehu:nomProfesor"/></h2>
						<xsl:element name="div">
							<dl>
								<xsl:if test="$programa/ehu:profesores/ehu:profesor/ehu:desOrganismo">
									<dt><xsl:value-of select="languageUtil:get($locale,'ehu.organismo')"/></dt>
									<dd><xsl:value-of select="$programa/ehu:profesores/ehu:profesor/ehu:desOrganismo"/></dd>									
								</xsl:if>
								
								<xsl:if test="$programa/ehu:profesores/ehu:profesor/ehu:email">
									<dt><xsl:value-of select="languageUtil:get($locale,'ehu.email')"/></dt>
									<dd>
										<xsl:element name="a">
											<xsl:attribute name="href">mailto:<xsl:value-of select="programa/ehu:profesores/ehu:profesor/ehu:email"/></xsl:attribute>
											<xsl:attribute name="class">email-icon-doc</xsl:attribute>
											<xsl:value-of select="programa/ehu:profesores/ehu:profesor/ehu:email"/>
										</xsl:element>
									</dd>									
								</xsl:if>
		
							</dl>
						</xsl:element>
										
					</xsl:element>
				</xsl:element>
			</xsl:otherwise>
		
		</xsl:choose>

	</xsl:template>


	<xsl:variable name="aux" select="$programa/ehu:cursos"/>
	<xsl:variable name="aux2" select="$programa/ehu:trabajosFinMaster"/>
	<xsl:variable name="aux3" select="$programa/ehu:diasImparticion"/>
	<xsl:template name="programa">

		<xsl:if test="$aux != $void or $aux2 != $void">
		
				<xsl:element name="div">
					<xsl:attribute name="class">m-b-30</xsl:attribute>
					<xsl:element name="div">
						<xsl:attribute name="class">bg-white</xsl:attribute>
						<xsl:element name="div">
							<xsl:attribute name="id">myToggler</xsl:attribute>
							<xsl:element name="h2">
								<xsl:attribute name="class">header toggler-header toggler-header-expanded</xsl:attribute>
								<xsl:attribute name="aria-controls">sect01Carga</xsl:attribute>
								<xsl:attribute name="id">accordion01Carga</xsl:attribute> 
								<xsl:attribute name="aria-disabled">true</xsl:attribute>
								<xsl:value-of select="languageUtil:get($locale,'upv-ehu.masters.registration.teaching-load')"/>
								<xsl:element name="span">
									<xsl:attribute name="tabindex">0</xsl:attribute>
									<xsl:element name="span"><xsl:attribute name="class">hide-accessible</xsl:attribute>toggle-navigation</xsl:element>
								</xsl:element>
							</xsl:element>
							
							<xsl:element name="div">
								<xsl:attribute name="class">content toggler-content toggler-content-expanded caja-sin-padding</xsl:attribute> 
								<xsl:element name="div">
									<xsl:attribute name="class">upv-tabla table-responsive</xsl:attribute> 
									<xsl:attribute name="role">region</xsl:attribute>
									<xsl:attribute name="id">sect01Carga</xsl:attribute> 
									<xsl:attribute name="aria-labelledby">accordion01Carga</xsl:attribute> 
									<xsl:element name="table">
		   								<xsl:attribute name="class">table table-hover</xsl:attribute> 
										<caption><xsl:value-of select="languageUtil:get($locale,'upv-ehu.masters.registration.teaching-load')"/></caption>
										<thead>
											<tr>
												<th><xsl:value-of select="languageUtil:get($locale,'ehu.numCredOblig')"/></th>
												<th><xsl:value-of select="languageUtil:get($locale,'ehu.numCredOpta')"/></th>
												<th><xsl:value-of select="languageUtil:get($locale,'ehu.numCredPracEmp')"/></th>
												<xsl:if test="$programa[ehu:tipoPagina='0']">
													<th><xsl:value-of select="languageUtil:get($locale,'upv-ehu.master.own.program.title.final-project')" /></th>
												</xsl:if>
												<xsl:if test="$programa[ehu:tipoPagina='1']">
													<th><xsl:value-of select="languageUtil:get($locale,'upv-ehu.masters.practices.tfm')" /></th>
												</xsl:if>
												<th><xsl:value-of select="languageUtil:get($locale,'ehu.total')"/></th>
											</tr>
										</thead>
										<tbody>
											<!-- Pintamos el orden del título según el idioma -->
											<!-- Euskera & English -->
											<xsl:if test="(languageUtil:getLanguageId($locale) = 'eu_ES') or (languageUtil:getLanguageId($locale) = 'en_GB')">
												<tr>
													<td><xsl:value-of select="format-number($programa/ehu:cargaLectiva/ehu:obligatorios,'###.#')"/>&#160;<xsl:element name="abbr"><xsl:attribute name="title"><xsl:value-of select="languageUtil:get($locale,'ehu.title.ects')"/></xsl:attribute>ECTS</xsl:element>&#160;<xsl:value-of select="languageUtil:get($locale,'ehu.es-eu-en-fr-credits')"/></td>
													<td><xsl:value-of select="format-number($programa/ehu:cargaLectiva/ehu:optativos,'###.#')"/>&#160;<xsl:element name="abbr"><xsl:attribute name="title"><xsl:value-of select="languageUtil:get($locale,'ehu.title.ects')"/></xsl:attribute>ECTS</xsl:element>&#160;<xsl:value-of select="languageUtil:get($locale,'ehu.es-eu-en-fr-credits')"/></td>
													<td><xsl:value-of select="format-number($programa/ehu:cargaLectiva/ehu:practicas,'###.#')"/>&#160;<xsl:element name="abbr"><xsl:attribute name="title"><xsl:value-of select="languageUtil:get($locale,'ehu.title.ects')"/></xsl:attribute>ECTS</xsl:element>&#160;<xsl:value-of select="languageUtil:get($locale,'ehu.es-eu-en-fr-credits')"/></td>
													<td><xsl:value-of select="format-number($programa/ehu:cargaLectiva/ehu:finMaster,'###.#')"/>&#160;<xsl:element name="abbr"><xsl:attribute name="title"><xsl:value-of select="languageUtil:get($locale,'ehu.title.ects')"/></xsl:attribute>ECTS</xsl:element>&#160;<xsl:value-of select="languageUtil:get($locale,'ehu.es-eu-en-fr-credits')"/></td>
													<xsl:variable name="creditoTotal" select="$programa/ehu:cargaLectiva/ehu:obligatorios + $programa/ehu:cargaLectiva/ehu:optativos + $programa/ehu:cargaLectiva/ehu:practicas + $programa/ehu:cargaLectiva/ehu:finMaster"/>
													<td><xsl:value-of select="format-number($creditoTotal,'###.#')"/>&#160;<xsl:element name="abbr"><xsl:attribute name="title"><xsl:value-of select="languageUtil:get($locale,'ehu.title.ects')"/></xsl:attribute>ECTS</xsl:element>&#160;<xsl:value-of select="languageUtil:get($locale,'ehu.es-eu-en-fr-credits')"/></td>
												</tr>
											</xsl:if>
											<!-- Castellano & Francais -->
											<xsl:if test="(languageUtil:getLanguageId($locale) = 'es_ES') or (languageUtil:getLanguageId($locale) = 'fr_FR')">
												<tr>
													<td><xsl:value-of select="format-number($programa/ehu:cargaLectiva/ehu:obligatorios,'###.#')"/>&#160;<xsl:value-of select="languageUtil:get($locale,'ehu.es-eu-en-fr-credits')"/>&#160;<xsl:element name="abbr"><xsl:attribute name="title"><xsl:value-of select="languageUtil:get($locale,'ehu.title.ects')"/></xsl:attribute>ECTS</xsl:element></td>
													<td><xsl:value-of select="format-number($programa/ehu:cargaLectiva/ehu:optativos,'###.#')"/>&#160;<xsl:value-of select="languageUtil:get($locale,'ehu.es-eu-en-fr-credits')"/>&#160;<xsl:element name="abbr"><xsl:attribute name="title"><xsl:value-of select="languageUtil:get($locale,'ehu.title.ects')"/></xsl:attribute>ECTS</xsl:element></td>
													<td><xsl:value-of select="format-number($programa/ehu:cargaLectiva/ehu:practicas,'###.#')"/>&#160;<xsl:value-of select="languageUtil:get($locale,'ehu.es-eu-en-fr-credits')"/>&#160;<xsl:element name="abbr"><xsl:attribute name="title"><xsl:value-of select="languageUtil:get($locale,'ehu.title.ects')"/></xsl:attribute>ECTS</xsl:element></td>
													<td><xsl:value-of select="format-number($programa/ehu:cargaLectiva/ehu:finMaster,'###.#')"/>&#160;<xsl:value-of select="languageUtil:get($locale,'ehu.es-eu-en-fr-credits')"/>&#160;<xsl:element name="abbr"><xsl:attribute name="title"><xsl:value-of select="languageUtil:get($locale,'ehu.title.ects')"/></xsl:attribute>ECTS</xsl:element></td>
													<xsl:variable name="creditoTotal" select="$programa/ehu:cargaLectiva/ehu:obligatorios + $programa/ehu:cargaLectiva/ehu:optativos + $programa/ehu:cargaLectiva/ehu:practicas + $programa/ehu:cargaLectiva/ehu:finMaster"/>
													<td><xsl:value-of select="format-number($creditoTotal,'###.#')"/>&#160;<xsl:value-of select="languageUtil:get($locale,'ehu.es-eu-en-fr-credits')"/>&#160;<xsl:element name="abbr"><xsl:attribute name="title"><xsl:value-of select="languageUtil:get($locale,'ehu.title.ects')"/></xsl:attribute>ECTS</xsl:element></td>
												</tr>
											</xsl:if>
										</tbody>
									</xsl:element>
								</xsl:element>
							</xsl:element>
							
							<xsl:element name="h2">
								<xsl:attribute name="class">header toggler-header toggler-header-collapsed</xsl:attribute>
							<xsl:attribute name="aria-controls">sect02Especialidad</xsl:attribute>
							<xsl:attribute name="id">accordion02Especialidad</xsl:attribute>
								<xsl:value-of select="languageUtil:get($locale,'upv-ehu.master.own.evaluation.procedure')"/>
								<xsl:element name="span">
									<xsl:attribute name="tabindex">0</xsl:attribute>
									<xsl:element name="span"><xsl:attribute name="class">hide-accessible</xsl:attribute>toggle-navigation</xsl:element>
								</xsl:element>
							</xsl:element>
							
							<xsl:element name="div">
								<xsl:attribute name="class">content toggler-content toggler-content-collapsed</xsl:attribute>
								<xsl:attribute name="role">region</xsl:attribute>
								<xsl:attribute name="id">sect02Especialidad</xsl:attribute> 
								<xsl:attribute name="aria-labelledby">accordion02Especialidad</xsl:attribute> 
								<xsl:element name="ul">
									<xsl:attribute name="class">list-check</xsl:attribute> 
									<xsl:for-each select="$programa/ehu:evaluaciones/ehu:evaluacion">
										<li><strong><xsl:value-of select="ehu:tipo" />:</strong><xsl:value-of select="$white_space"/><xsl:value-of select="ehu:criterio"/> 
										(<xsl:value-of select="format-number(ehu:porcentaje, '##')" />%)</li>
									</xsl:for-each>
								</xsl:element>
							</xsl:element>
							
							<xsl:element name="h2">
								<xsl:attribute name="class">header toggler-header toggler-header-collapsed</xsl:attribute>
								<xsl:attribute name="aria-controls">sect03Programa</xsl:attribute>
								<xsl:attribute name="id">accordion03Programa</xsl:attribute>
								<xsl:value-of select="languageUtil:get($locale,'ehu.program')"/>
								<xsl:element name="span">
									<xsl:attribute name="tabindex">0</xsl:attribute>
									<xsl:element name="span"><xsl:attribute name="class">hide-accessible</xsl:attribute>toggle-navigation</xsl:element>
								</xsl:element>
							</xsl:element>
							
							<xsl:element name="div">
								<xsl:attribute name="class">content toggler-content toggler-content-collapsed caja-sin-padding</xsl:attribute>
								<xsl:attribute name="role">region</xsl:attribute>
								<xsl:attribute name="id">sect03Programa</xsl:attribute> 
								<xsl:attribute name="aria-labelledby">accordion03Programa</xsl:attribute> 
								
								<xsl:if test="$aux != $void">
										<xsl:variable name="anyo_sorted_copy">
											<xsl:for-each select="$programa/ehu:cursos/ehu:curso">
												<xsl:sort select="ehu:anyoImpart" />
												<xsl:copy-of select="current()"/>							        	
											</xsl:for-each>
										</xsl:variable>
										<xsl:variable name="anyo_sorted_node_set" select="exsl:node-set($anyo_sorted_copy)/*" />
				
										<xsl:variable name="anyo_sorted_node_set_2" select="exsl:node-set($anyo_sorted_copy)/*" />
										<xsl:for-each select="$anyo_sorted_node_set">
											<xsl:variable name="previous_anyo" select="preceding-sibling::*[1]/ehu:anyoImpart" />
											<xsl:variable name="anyo" select="ehu:anyoImpart"/>
											<xsl:if test="not($previous_anyo = $anyo)">
												<xsl:element name="h3">
													<xsl:attribute name="class">p-20</xsl:attribute>
													
													<xsl:value-of
														select="ehu:descAnyoImpart" />
												</xsl:element>
										
												<xsl:element name="div">
													<xsl:attribute name="class">upv-tabla table-responsive</xsl:attribute>
													<xsl:element name="table">
														<xsl:attribute name="class">table table-hover</xsl:attribute>
														<caption>
															<xsl:value-of
																select="languageUtil:get($locale,'ehu.numCredOblig')" />
															<xsl:value-of select="$white_space" />
															<xsl:value-of
																select="ehu:descAnyoImpart" />
														</caption>
														<thead>
															<tr>
																<th>
																	<xsl:value-of
																		select="languageUtil:get($locale,'ehu.materia')" />
																</th>
																<th>
																	<xsl:value-of
																		select="languageUtil:get($locale,'ehu.idiomas')" />
																</th>
																
																<!-- Pintamos el orden del título según el idioma -->
																<!-- Euskera & English -->
																<xsl:if
																	test="(languageUtil:getLanguageId($locale) = 'eu_ES') or (languageUtil:getLanguageId($locale) = 'en_GB')">
																	<th>
																		<xsl:element name="abbr">
																			<xsl:attribute name="title">
																				<xsl:value-of
																					select="languageUtil:get($locale,'ehu.title.ects')" />
																			</xsl:attribute>
																			ECTS
																		</xsl:element>
																		&#160;
																		<xsl:value-of
																			select="languageUtil:get($locale,'ehu.credits')" />
																	</th>
																</xsl:if>
																<!-- Castellano & Francais -->
																<xsl:if
																	test="(languageUtil:getLanguageId($locale) = 'es_ES') or (languageUtil:getLanguageId($locale) = 'fr_FR')">
																	<th>
																		<xsl:value-of
																			select="languageUtil:get($locale,'ehu.credits')" />
																		&#160;
																		<xsl:element name="abbr">
																			<xsl:attribute name="title">
																				<xsl:value-of
																					select="languageUtil:get($locale,'ehu.title.ects')" />
																			</xsl:attribute>
																			ECTS
																		</xsl:element>
																	</th>
																</xsl:if>
																<th>
																	<xsl:value-of
																		select="languageUtil:get($locale,'ehu.type')" />
																</th>
																
																<th>
																	<xsl:value-of
																		select="languageUtil:get($locale,'ehu.modalidad')" />
																</th>
															</tr>
														</thead>
														<tbody>
															<xsl:for-each select="$anyo_sorted_node_set_2">
																<xsl:variable name="currentAnyo" select="ehu:anyoImpart"/>
																
															 	<xsl:if test="$currentAnyo = $anyo">
																	<tr>
																		<xsl:element name="td">
																			<xsl:attribute name="class">width-55</xsl:attribute>
																			<xsl:element name="a">
																				<xsl:attribute name="href">
																					<xsl:value-of select="languageUtil:get($locale,'upv-ehu.masters.url.subject')" />?p_cod_proceso=master-own&amp;p_cod_idioma=es&amp;p_cod_programa=<xsl:value-of select="$programa/ehu:codPrograma" />&amp;p_nav=306&amp;p_cod_curso=<xsl:value-of select="ehu:codCurso" />
																				</xsl:attribute>
																				<xsl:value-of select="ehu:descCurso" />
																			</xsl:element>
																		</xsl:element>
																		<td>
																			<xsl:for-each select="ehu:idiomas/ehu:idioma">
																				<xsl:value-of select="ehu:descIdiomaImpart" />
																				<xsl:if test="position() != last()">
																					,
																					<xsl:value-of select="$white_space" />
																				</xsl:if>
																			</xsl:for-each>
																		</td>
																		<td>
																			<xsl:value-of
																				select="format-number(ehu:numCreditos,'###.#')" />
																		</td>
																		<td>
																			<xsl:value-of select="ehu:descCaracter" />
																		</td>
																		
																		<td>
																			<xsl:value-of select="ehu:tipoDocencia" />
																		</td>
																	</tr>
																</xsl:if>
															</xsl:for-each>
														</tbody>
													</xsl:element>
												</xsl:element>
											</xsl:if>
										</xsl:for-each>
									
								</xsl:if> <!-- si no hay asignaturas -->
								
								<xsl:if test="$aux2 != $void">
									<xsl:element name="h3">
										<xsl:attribute name="class">p-20</xsl:attribute>
										<xsl:if test="$programa[ehu:tipoPagina='0']">
											<xsl:value-of select="languageUtil:get($locale,'upv-ehu.master.own.program.title.final-project')" />
										</xsl:if>
										<xsl:if test="$programa[ehu:tipoPagina='1']">
											<xsl:value-of select="languageUtil:get($locale,'upv-ehu.masters.practices.tfm')" />
										</xsl:if>
									</xsl:element>
									
									<xsl:element name="div">
										<xsl:attribute name="class">upv-tabla table-responsive</xsl:attribute>
										<xsl:element name="table">
											<xsl:attribute name="class">table table-hover</xsl:attribute>
											<caption><xsl:value-of select="languageUtil:get($locale,'ehu.numCredOblig')"/></caption>
											<thead>
												<tr>
													<th><xsl:value-of select="languageUtil:get($locale,'ehu.materia')"/></th>
													<th><xsl:value-of select="languageUtil:get($locale,'ehu.idiomas')"/></th>
													<!-- <th><xsl:element name="abbr"><xsl:attribute name="title"><xsl:value-of select="languageUtil:get($locale,'ehu.title.ects')"/></xsl:attribute> <xsl:value-of select="languageUtil:get($locale,'upv-ehu.master.own.ehu.program.creditosECTS')"/></xsl:element></th> -->
													<!-- Pintamos el orden del título según el idioma -->
													<!-- Euskera & English -->
													<xsl:if test="(languageUtil:getLanguageId($locale) = 'eu_ES') or (languageUtil:getLanguageId($locale) = 'en_GB')">
														<th><xsl:element name="abbr"><xsl:attribute name="title"><xsl:value-of select="languageUtil:get($locale,'ehu.title.ects')"/></xsl:attribute>ECTS</xsl:element>&#160;<xsl:value-of select="languageUtil:get($locale,'ehu.credits')"/></th>
													</xsl:if>
													<!-- Castellano & Francais -->
													<xsl:if test="(languageUtil:getLanguageId($locale) = 'es_ES') or (languageUtil:getLanguageId($locale) = 'fr_FR')">
														<th><xsl:value-of select="languageUtil:get($locale,'ehu.credits')"/>&#160;<xsl:element name="abbr"><xsl:attribute name="title"><xsl:value-of select="languageUtil:get($locale,'ehu.title.ects')"/></xsl:attribute>ECTS</xsl:element></th>
													</xsl:if>
													<th><xsl:value-of select="languageUtil:get($locale,'ehu.type')"/></th>
													<th><xsl:value-of select="languageUtil:get($locale,'ehu.modalidad')"/></th>
												</tr>
											</thead>
											<tbody>
												<xsl:for-each select="$programa/ehu:trabajosFinMaster/ehu:trabajo">
													<tr>
														<xsl:element name="td">
															<xsl:attribute name="class">width-55</xsl:attribute>
															<xsl:element name="a">
																<xsl:attribute name="href"><xsl:value-of select="languageUtil:get($locale,'upv-ehu.masters.url.subject')"/>?p_cod_proceso=master-own&amp;p_cod_idioma=es&amp;p_cod_programa=<xsl:value-of select="$programa/ehu:codPrograma"/>&amp;p_nav=306&amp;p_cod_curso=<xsl:value-of select="ehu:codCurso"/></xsl:attribute>
																<xsl:value-of select="ehu:descCurso"/>
															</xsl:element>
														</xsl:element>
														<td>
															<xsl:choose>
															 	<xsl:when test="ehu:idiomas/ehu:idioma">
															 		<xsl:for-each select="ehu:idiomas/ehu:idioma">
																		<xsl:value-of select="ehu:descIdiomaImpart"/>
																		<xsl:if test="position() != last()">,<xsl:value-of select="$white_space" /></xsl:if>
																	</xsl:for-each> 
														 		</xsl:when>
																<xsl:otherwise> - </xsl:otherwise>
															</xsl:choose> 
														</td>
														<td>
															<xsl:value-of select="format-number(ehu:numCreditos,'###.#')"/>
														</td>
												   		<td>
															<xsl:value-of select="ehu:descCaracter" />
														</td>
														<td>
															<xsl:choose>
															 	<xsl:when test="ehu:tipoDocencia">
																	<xsl:value-of select="ehu:tipoDocencia"/>
														 		</xsl:when>
																<xsl:otherwise> - </xsl:otherwise>
															</xsl:choose>
														</td>
													</tr>
												</xsl:for-each>
											</tbody>
										</xsl:element>
									</xsl:element>							
								</xsl:if> <!--  si hay proyecto fin  -->
							</xsl:element>
						</xsl:element>
					</xsl:element>
				</xsl:element>
		</xsl:if> <!--  if general -->
		
		
				<xsl:if test="$aux3">
					<xsl:element name="div">
						<xsl:attribute name="class">journal-content-article</xsl:attribute>
						<xsl:element name="section">
							<xsl:element name="div">
								<xsl:attribute name="class">bg-white p-20</xsl:attribute>
								<xsl:element name="h2">
									<xsl:attribute name="class">p-20</xsl:attribute>
									<xsl:value-of select="languageUtil:get($locale,'ehu.horario')"/>
								</xsl:element>
								<xsl:element name="div">
									<xsl:attribute name="class">upv-tabla table-responsive</xsl:attribute>
									<xsl:element name="table">
										<xsl:attribute name="class">table table-hover</xsl:attribute>
										
										<xsl:element name="caption">
											<xsl:value-of select="languageUtil:get($locale,'ehu.horario')"/>
										</xsl:element>
										<xsl:element name="thead">
											<xsl:element name="tr">
												<xsl:element name="th">
													<xsl:value-of select="languageUtil:get($locale,'ehu.horario.dia.semana')"/>
												</xsl:element>
												<xsl:element name="th">
													<xsl:value-of select="languageUtil:get($locale,'ehu.horario.hora.inicio')"/>
												</xsl:element>
												<xsl:element name="th">
													<xsl:value-of select="languageUtil:get($locale,'ehu.horario.hora.fin')"/>
												</xsl:element>
											</xsl:element>
										</xsl:element>
										
										<xsl:element name="tbody">
											<xsl:for-each select="$programa/ehu:diasImparticion/ehu:diaImparticion">
												<xsl:element name="tr">
													<xsl:element name="td">
														<xsl:attribute name="class">p-t-b-20</xsl:attribute>
														<xsl:value-of select="ehu:desDia"/>
													</xsl:element>
													<xsl:element name="td">
														<xsl:attribute name="class">p-t-b-20</xsl:attribute>
														<xsl:value-of select="substring(ehu:horaInicio,12,5)" />h
													</xsl:element>
													<xsl:element name="td">
														<xsl:attribute name="class">p-t-b-20</xsl:attribute>
														<xsl:value-of select="substring(ehu:horaFin,12,5)" />h
													</xsl:element>
												</xsl:element>
											</xsl:for-each> 
										</xsl:element>
										
									</xsl:element>
								</xsl:element>  <!--  Div tabla horario -->
								
							</xsl:element>
						</xsl:element>
					</xsl:element>							
				</xsl:if> <!--  Horario -->	
	
	</xsl:template>
	
	<xsl:template name="vistaAsignatura">
		
			<xsl:param name="urlBack" />
			<xsl:variable name="asignatura" select="$programa/ehu:cursos/ehu:curso" />
						
			<xsl:element name="div">
				<xsl:attribute name="class">text-right m-b-30</xsl:attribute>
				<xsl:element name="a">
					<xsl:attribute name="class">btn btn-upv btn-primary</xsl:attribute>
					<xsl:attribute name="href"><xsl:value-of select="$urlBack"/></xsl:attribute>
					<xsl:call-template name="elemento_span_atras"/>
					<xsl:value-of select="languageUtil:get($locale,'back')"/>
				</xsl:element>
			</xsl:element>
			
			<xsl:choose>
				<!-- No info -->
				<xsl:when test="not($p_cod_curso) or $p_cod_curso='' or not($asignatura) or $asignatura=''">
					<xsl:element name="div">
						<xsl:attribute name="class">m-b-30</xsl:attribute>
						<xsl:element name="div">
							<xsl:attribute name="class">bg-white p-20</xsl:attribute>
							<p><xsl:value-of select="languageUtil:get($locale,'ehu.there-is-no-information-for-this-section')"/></p>
						</xsl:element>
					</xsl:element>
				</xsl:when>
				<xsl:otherwise>
				
					<!-- Título -->
					<xsl:if test="$asignatura">
						<h2><xsl:value-of select="$asignatura/ehu:descCurso"/></h2>
					</xsl:if>
				
					<!-- Datos generales de la materia -->
					<xsl:if test="$asignatura/ehu:tipoDocencia or $asignatura/ehu:idiomas">
						<xsl:element name="div">
							<xsl:attribute name="class">m-b-30</xsl:attribute>
							<xsl:element name="div">
								<xsl:attribute name="class">bg-white asignaturacontenido p-20</xsl:attribute>
								<h2><xsl:value-of select="languageUtil:get($locale,'ehu.datosGeneralMater')"/></h2>
								<dl>
									<xsl:if test="$asignatura/ehu:tipoDocencia">
										<dt><xsl:value-of select="languageUtil:get($locale,'ehu.modalidad')"/></dt>
										<dd><xsl:value-of select="$asignatura/ehu:tipoDocencia" /><xsl:value-of select="$white_space"/></dd>						
									</xsl:if>
									<xsl:if test="$asignatura/ehu:idiomas">
										<dt><xsl:value-of select="languageUtil:get($locale,'ehu.idioma')"/></dt>
										<xsl:for-each select="$asignatura/ehu:idiomas/ehu:idioma">
											<dd><xsl:value-of select="ehu:descIdiomaImpart"/></dd>
										</xsl:for-each>
									</xsl:if>
								</dl>
							</xsl:element>
						</xsl:element>
					</xsl:if>
				
					<!-- Profesorado -->
					<xsl:if test="$asignatura/ehu:profesorado/ehu:profesor">
						<xsl:element name="div">
							<xsl:attribute name="class">m-b-30</xsl:attribute>
							<xsl:element name="div">
								<xsl:attribute name="class">bg-white p-20</xsl:attribute>
								<h2><xsl:value-of select="languageUtil:get($locale,'ehu.profesorado')"/></h2>
								
								<xsl:element name="div">
									<xsl:attribute name="class">upv-tabla table-responsive</xsl:attribute>
									<xsl:element name="table">
										<xsl:attribute name="class">table table-hover</xsl:attribute>
										<thead>
											<tr>
												<th>
													<xsl:attribute name="scope">col</xsl:attribute>
													<xsl:value-of select="languageUtil:get($locale,'ehu.nombre')" />
												</th>
												<th>
													<xsl:attribute name="scope">col</xsl:attribute>
													<xsl:value-of select="languageUtil:get($locale,'ehu.institucion')" />
												</th>									
											</tr>
										</thead>
			
										<tbody>
											<xsl:for-each select="$asignatura/ehu:profesorado/ehu:profesor">
												<tr>
													<td>
														<a>
															<xsl:if test="ehu:indUpv='1'">
																<xsl:attribute name="href">?p_redirect=materiaFichaPDI&amp;p_idp=<xsl:value-of select="ehu:idpProfesor"/></xsl:attribute>
															</xsl:if>
															<xsl:if test="ehu:indUpv='0'">
																<xsl:attribute name="href">?p_redirect=materiaProfesorAjeno&amp;p_idp=<xsl:value-of select="ehu:idpProfesor"/>&amp;p_cod_programa=<xsl:value-of select="$p_cod_programa"/></xsl:attribute>
															</xsl:if>
															<xsl:value-of select="ehu:nomProfesor" />
														</a>
													</td>
													<td>
														<xsl:value-of select="ehu:descUniMec" />
													</td>	
												</tr>														
											</xsl:for-each>
										</tbody>
									</xsl:element>
								</xsl:element>
							</xsl:element>
						</xsl:element>
					</xsl:if>
					
							<!-- Competencias -->
					<xsl:if test="$asignatura/ehu:compEspec">
						<xsl:element name="div">
							<xsl:attribute name="class">m-b-30</xsl:attribute>
							<xsl:element name="div">
								<xsl:attribute name="class">bg-white p-20</xsl:attribute>
								<h2><xsl:value-of select="languageUtil:get($locale,'ehu.competencias')"/></h2>
								<xsl:call-template name="transform_text">
									<xsl:with-param name="text" select="$asignatura/ehu:compEspec"/>
								</xsl:call-template>
							</xsl:element>
						</xsl:element>
					</xsl:if>
			
					<!-- Bibliografía -->	
					<xsl:if test="$asignatura/ehu:temario/ehu:tema">
						<xsl:element name="article">
							<xsl:attribute name="class">m-b-30</xsl:attribute>
							<xsl:element name="section">
								<xsl:attribute name="class">upv-ehu-image-description</xsl:attribute>
								<xsl:element name="div">
									<xsl:attribute name="class">main</xsl:attribute>
									<h2><xsl:value-of select="languageUtil:get($locale,'ehu.temary.bibliography')"/></h2>
									
									<xsl:element name="ul">
										<xsl:for-each select="$asignatura/ehu:temario/ehu:tema">
											<li><xsl:value-of select="ehu:descTema"/></li>
											<xsl:element name="div">
												<xsl:attribute name="class">p-20</xsl:attribute>
												<strong><xsl:value-of select="languageUtil:get($locale,'ehu.bibliography')"/>:</strong>
												<xsl:variable name="publicacion" select="ehu:bibliografia/ehu:publicacion" />
												
												<xsl:call-template name="transform_text">
													<xsl:with-param name="text" select="$publicacion/ehu:descBiblio"/>
												</xsl:call-template>
											</xsl:element>
											
										</xsl:for-each>						
									</xsl:element>
								</xsl:element>
							</xsl:element>
						</xsl:element>
					</xsl:if>	
					
				</xsl:otherwise>
			</xsl:choose>
	</xsl:template>
	
	<xsl:template name="matricula">
		<xsl:element name="div">
			<xsl:element name="article">
				<xsl:attribute name="class">information</xsl:attribute>
				<xsl:element name="section">
					<xsl:attribute name="class">upv-ehu-image-description</xsl:attribute>
					<xsl:element name="header">
						<xsl:attribute name="class">info-section</xsl:attribute>
						<h2><xsl:value-of select="languageUtil:get($locale,'upv-ehu.master.own.registration.price')"/></h2>
					</xsl:element>
					<xsl:element name="div">
						<xsl:attribute name="class">main</xsl:attribute>
						<strong><xsl:value-of select="languageUtil:get($locale,'upv-ehu.masters.home.guideprice')"/>:</strong>
						<xsl:variable name="precioMatricula" select="$programa/ehu:numCreditos * $programa/ehu:precioCredito"/><xsl:value-of select="$white_space"/>
						<xsl:value-of select="format-number(round($precioMatricula div 100) * 100, '#.###,#', 'european')"/><xsl:value-of select="$white_space"/>€
					</xsl:element>
				</xsl:element>
				<xsl:element name="section">
					<xsl:attribute name="class">upv-ehu-image-description</xsl:attribute>
					<xsl:element name="header">
						<xsl:attribute name="class">info-section</xsl:attribute>
						<h2><xsl:value-of select="languageUtil:get($locale,'upv-ehu.masters.registration.title')"/></h2>
					</xsl:element>
					<xsl:element name="div">
						<xsl:attribute name="class">main</xsl:attribute>
						<h3><xsl:value-of select="languageUtil:get($locale,'upv-ehu.masters.registration.access-titles')"/></h3>
						<p>
							<xsl:call-template name="transform_text">
	        					<xsl:with-param name="text" select="$programa/ehu:perfilAcceso"/>
	      					</xsl:call-template>
						</p>
						<h3><xsl:value-of select="languageUtil:get($locale,'upv-ehu.master.own.registration.criteria')"/></h3>
						<xsl:element name="ul">
							<xsl:for-each select="$programa/ehu:criterios/ehu:criterio">
								<xsl:choose>
								 	<xsl:when test="languageUtil:getLanguageId($locale) = 'eu_ES'">
								 		<li><xsl:value-of select="ehu:descripcion"/>: % <xsl:value-of select="ehu:porcentaje"/></li>
							 		</xsl:when>
									<xsl:otherwise><li><xsl:value-of select="ehu:descripcion"/>: <xsl:value-of select="ehu:porcentaje"/> %</li></xsl:otherwise>
								</xsl:choose> 								
							</xsl:for-each>
						</xsl:element>
					</xsl:element>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>	
	
	
	<xsl:template name="piePagina">		
		<xsl:if test="$programa/ehu:oficinaInf/ehu:contacto/ehu:mail">
			<xsl:element name="a">
				<xsl:attribute name="id">contactoPiePagina</xsl:attribute>
				<xsl:attribute name="href">mailto:<xsl:value-of select="$programa/ehu:oficinaInf/ehu:contacto/ehu:mail"/></xsl:attribute>
				<xsl:element name="span">
					<xsl:attribute name="class">fa fa-envelope fa-2x</xsl:attribute>
					<xsl:value-of select="$white_space"/>
				</xsl:element>
				<xsl:element name="span">
					<xsl:attribute name="id">suggestionBoxFooter</xsl:attribute>
					<xsl:value-of select="languageUtil:get($locale,'upv-ehu.masters.home.suggestionbox')"/>
				</xsl:element>
			</xsl:element>
		
			<xsl:text disable-output-escaping="yes">
				<![CDATA[    
					<!-- xmlns:ehu -->
					<script type="text/javascript"> 
						document.addEventListener('DOMContentLoaded', function(){ 
							if(document.getElementById('footerContact')) {
								document.getElementById('footerContact').appendChild(document.getElementById('contactoPiePagina'));
							}
						});
					</script> 
				]]>
			</xsl:text>
		</xsl:if>
	</xsl:template>
	
	
	<xsl:template name="formatFechaWName">
		<xsl:param name="date_wz"/>
		<xsl:choose>
			<xsl:when test="languageUtil:getLanguageId($locale) = 'en_GB'">
				<xsl:variable name="yearInit" select="substring($date_wz,1,4)" />
				<xsl:variable name="monthInit" select="substring($date_wz,6,2)" />
				<!-- Pintamos la fecha en formato EN-->
				<xsl:value-of select="$yearInit"/>				
				<xsl:value-of select="$white_space"/>
				<xsl:value-of select="languageUtil:get($locale,concat('month-', $monthInit))"/>	
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="monthInit" select="substring($date_wz,6,2)" />
				<xsl:variable name="yearInit" select="substring($date_wz,1,4)" />
				<!-- Pintamos la fecha en formato EU / ES -->
				<xsl:value-of select="languageUtil:get($locale,concat('month-', $monthInit))"/>
				<xsl:value-of select="$white_space"/>
				<xsl:value-of select="$yearInit"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
					
	
</xsl:stylesheet>

