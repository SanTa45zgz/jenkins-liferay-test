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
	<!-- Variable ya definida en common.xsl 
	<xsl:variable name="p_cod_curso" select="ehu:app/ehu:p_cod_curso" />
	-->
	
	<xsl:template name="presentacion">
	
	
							
		<xsl:variable name="numCredito">
			<xsl:choose>
			 	<xsl:when test="$programa/ehu:modulos/ehu:modulo[ehu:codModulo = $p_cod_curso]">
					<xsl:value-of select="$programa/ehu:modulos/ehu:modulo[ehu:codModulo = $p_cod_curso]/ehu:numCredRealizar"/>
			 	</xsl:when>
			 	<xsl:otherwise>
			 		<xsl:value-of select="$programa/ehu:numCredRealizar"/>
			 	</xsl:otherwise>
		 	</xsl:choose>
		</xsl:variable>
		<xsl:variable name="precioCredito">
			<xsl:choose>
			 	<xsl:when test="$programa/ehu:modulos/ehu:modulo[ehu:codModulo = $p_cod_curso]">
 					<xsl:value-of select="$programa/ehu:modulos/ehu:modulo[ehu:codModulo = $p_cod_curso]/ehu:precioCredito"/>
			 	</xsl:when>
			 	<xsl:otherwise>
			 		<xsl:value-of select="$programa/ehu:precioCredito"/>
			 	</xsl:otherwise>
		 	</xsl:choose>
		</xsl:variable>
	
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
					<h3><xsl:value-of select="languageUtil:get($locale,'ehu.numCreditos')"/></h3>
					<xsl:element name="p">
						<xsl:value-of select="format-number($numCredito,'###')"/>					
						<xsl:value-of select="$white_space"/>
						<xsl:value-of select="languageUtil:get($locale, 'upv-ehu.master.own.ehu.creditosECTS')"/>
					</xsl:element>
				</xsl:element>
			</xsl:element>
		
			<xsl:element name="div">
				<xsl:attribute name="class">row</xsl:attribute>
				<xsl:element name="div">
					<xsl:attribute name="class">col-md-6</xsl:attribute>
					<h3><xsl:value-of select="languageUtil:get($locale,'upv-ehu.masters.home.guideprice')"/></h3>
					<xsl:variable name="precioMatricula" select="$numCredito * $precioCredito"/>
					<p><xsl:value-of select="format-number(round($precioMatricula div 100) * 100, '#.###,#', 'european')"/><xsl:value-of select="$white_space"/>€</p>
				</xsl:element>
				<xsl:element name="div">
					<xsl:attribute name="class">col-md-6</xsl:attribute>
					<h3><xsl:value-of select="languageUtil:get($locale,'ehu.lugarImparticion')"/></h3>
					<p><xsl:value-of select="$programa/ehu:lugarImparticion/ehu:centro"/></p>
				</xsl:element>
			</xsl:element>
			
			
			<xsl:element name="div">
				<xsl:attribute name="class">row</xsl:attribute>
				<xsl:element name="div">
					<xsl:attribute name="class">col-12</xsl:attribute>
					<h3><xsl:value-of select="languageUtil:get($locale,'ehu.responsible')"/></h3>
					<p class="m-b-0"><xsl:value-of select="$programa/ehu:centroResponsable"/></p>
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
		</xsl:element>
	</xsl:template>
	


	<xsl:variable name="aux" select="$programa/ehu:cursos"/>
	<xsl:variable name="aux2" select="$programa/ehu:trabajosFinMaster"/>
	<xsl:variable name="aux3" select="$programa/ehu:diasImparticion"/>
	<xsl:template name="programa">

		<xsl:if test="$aux != $void or $aux2 != $void">
			<xsl:element name="div">
				<xsl:attribute name="class">m-b-30</xsl:attribute>
				<xsl:element name="div">
					<xsl:attribute name="class">bg-white p-20</xsl:attribute>
					<xsl:element name="div">
						<xsl:attribute name="id">myToggler</xsl:attribute>
	
						<xsl:element name="header">
							<xsl:attribute name="style">padding-left: 20px;</xsl:attribute>
							<xsl:attribute name="class">info-section</xsl:attribute>
							<h2><xsl:value-of select="languageUtil:get($locale,'ehu.asignaturas')"/></h2>
						</xsl:element>
						
						<xsl:element name="div">
							<xsl:attribute name="class">content toggler-content caja-sin-padding</xsl:attribute>
						
							<xsl:if test="$aux != $void">
								<xsl:element name="h3">
									<xsl:attribute name="class">p-20</xsl:attribute>
									<xsl:value-of select="languageUtil:get($locale,'ehu.numCredOblig')"/>
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
												<th><xsl:element name="abbr"><xsl:attribute name="title"><xsl:value-of select="languageUtil:get($locale,'ehu.title.ects')"/></xsl:attribute> <xsl:value-of select="languageUtil:get($locale,'upv-ehu.master.own.ehu.creditosECTS')"/></xsl:element></th>
												<th><xsl:value-of select="languageUtil:get($locale,'ehu.type')"/></th>
												<th><xsl:value-of select="languageUtil:get($locale,'ehu.modalidad')"/></th>
											</tr>
										</thead>
										<tbody>
											<xsl:for-each select="$programa/ehu:cursos/ehu:curso">
												<tr>
													<xsl:element name="td">
														<xsl:attribute name="class">width-55</xsl:attribute>
														<xsl:element name="a">
															<xsl:attribute name="href"><xsl:value-of select="languageUtil:get($locale,'upv-ehu.masters.url.subject')"/>?p_cod_programa=<xsl:value-of select="$programa/ehu:codPrograma"/>&amp;p_nav=306&amp;p_cod_curso_mat=<xsl:value-of select="ehu:codCurso"/></xsl:attribute>
															<xsl:value-of select="ehu:descCurso"/>
														</xsl:element>
													</xsl:element>
													<td>
														<xsl:for-each select="ehu:idiomas/ehu:idioma">
															<xsl:value-of select="ehu:descIdiomaImpart"/>
															<xsl:if test="position() != last()">,<xsl:value-of select="$white_space" /></xsl:if>
														</xsl:for-each>
													</td>
													<td>
														<xsl:value-of select="format-number(ehu:numCreditos,'###.#')"/>
													</td>
											   		<td>
														<xsl:value-of select="ehu:descCaracter" />
													</td>
													<td>
														<xsl:value-of select="ehu:tipoDocencia" />			
													</td>
												</tr>
											</xsl:for-each>
										</tbody>
									</xsl:element>
								</xsl:element>
							</xsl:if>
							
							<!-- ***** Añadimos la tabla "Trabajo fin de estudios" o "Trabajo Fin de Máster" ***** -->
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
												<th><xsl:element name="abbr"><xsl:attribute name="title"><xsl:value-of select="languageUtil:get($locale,'ehu.title.ects')"/></xsl:attribute> <xsl:value-of select="languageUtil:get($locale,'upv-ehu.master.own.ehu.program.creditosECTS')"/></xsl:element></th>
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
							<!-- ***** FIN: Añadimos la tabla "Trabajo fin de estudios" o "Trabajo Fin de Máster" ***** -->
							</xsl:if>
							
	
						</xsl:element>
					</xsl:element>
				</xsl:element>
			</xsl:element>
		</xsl:if>
			
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
			
			<!-- No info -->
			<xsl:choose>
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
	
		<xsl:variable name="p_cod_modulo" select="ehu:app/ehu:parameters/ehu:parameter[@name='p_cod_modulo']"/>

		<xsl:variable name="numCredito">
			<xsl:choose>
			 	<xsl:when test="$programa/ehu:modulos/ehu:modulo[ehu:codModulo = $p_cod_modulo]">
					<xsl:value-of select="$programa/ehu:modulos/ehu:modulo[ehu:codModulo = $p_cod_modulo]/ehu:numCredRealizar"/>
			 	</xsl:when>
			 	<xsl:otherwise>
			 		<xsl:value-of select="$programa/ehu:numCredRealizar"/>
			 	</xsl:otherwise>
		 	</xsl:choose>
		</xsl:variable>
		<xsl:variable name="precioCredito">
			<xsl:choose>
			 	<xsl:when test="$programa/ehu:modulos/ehu:modulo[ehu:codModulo = $p_cod_modulo]">
 					<xsl:value-of select="$programa/ehu:modulos/ehu:modulo[ehu:codModulo = $p_cod_modulo]/ehu:precioCredito"/>
			 	</xsl:when>
			 	<xsl:otherwise>
			 		<xsl:value-of select="$programa/ehu:precioCredito"/>
			 	</xsl:otherwise>
		 	</xsl:choose>
		</xsl:variable>
	
	
	
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
						<xsl:variable name="precioMatricula" select="$numCredito * $precioCredito"/><xsl:value-of select="$white_space"/>
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

