<?xml version="1.0"?>

	<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		version="1.0" xmlns:ehu="http://www.ehu.eus"
		xmlns:exsl="http://exslt.org/common" 
		xmlns:xalan="http://xml.apache.org/xalan"
		xmlns:languageUtil="xalan://com.liferay.portal.kernel.language.LanguageUtil"
		xmlns:propsUtil="com.liferay.portal.kernel.util.PropsUtil"
		xmlns:StringPool="com.liferay.portal.kernel.util.StringPool"
		exclude-result-prefixes="xalan" 
		extension-element-prefixes="exsl languageUtil propsUtil StringPool xalan">
		
	<xsl:output method="html" omit-xml-declaration="yes" />
		
	<xsl:include href="http://localhost:8080/o/ehu-xsl-content-web/common/common.xsl"/>
	
	<xsl:variable name="anyoAcad" select="ehu:app/ehu:departamento/ehu:asignaturas/@anyoImparticion"/>
	<xsl:variable name="department_title">
		<xsl:value-of select="ehu:app/ehu:departamento/ehu:descripcion"/>
		<xsl:value-of select="$white_space"/>		
	</xsl:variable>
	
	<!-- Asignatura -->
	<!-- Codigo de asignatura a mostrar -->
	<xsl:variable name="p_cod_asignatura" select="ehu:app/ehu:parameters/ehu:parameter[@name='p_cod_asignatura']"/>
	<xsl:variable name="p_anyo_acad" select="ehu:app/ehu:parameters/ehu:parameter[@name='p_anyo_acad']"/>
	<xsl:variable name="desAsignatura" select="ehu:app/ehu:asignatura/ehu:desAsignatura"/>
	<xsl:variable name="desCentroAsignatura" select="ehu:app/ehu:asignatura/ehu:desCentro"/>
	<xsl:variable name="desPlanAsignatura" select="ehu:app/ehu:asignatura/ehu:desPlan"/>
	<xsl:variable name="desAnyoAcadAsignatura" select="ehu:app/ehu:asignatura/ehu:desAnyoAcad"/>
	<xsl:variable name="cursoAsignatura" select="ehu:app/ehu:asignatura/ehu:curso"/>
	<xsl:variable name="numCreditosAsignatura" select="ehu:app/ehu:asignatura/ehu:numCreditos"/>
	<xsl:variable name="idiomasAsignatura" select="ehu:app/ehu:asignatura/ehu:idiomas"/>
	<xsl:variable name="docenciasAsignatura" select="ehu:app/ehu:asignatura/ehu:docencias"/>
	<xsl:variable name="gruposAsignatura" select="ehu:app/ehu:asignatura/ehu:grupos"/>
	<xsl:variable name="miembrosTribunalAsignatura" select="ehu:app/ehu:asignatura/ehu:miembrosTribunal"/>
	<xsl:variable name="materialObligAsignatura" select="ehu:app/ehu:asignatura/ehu:materialOblig"/>
	<xsl:variable name="objetivosAsignatura" select="ehu:app/ehu:asignatura/ehu:objetivos"/>
	<xsl:variable name="temarioAsignatura" select="ehu:app/ehu:asignatura/ehu:temario"/>
	<xsl:variable name="metodologiaAsignatura" select="ehu:app/ehu:asignatura/ehu:metodologia"/>
	<xsl:variable name="infoEvaluaAsignatura" select="ehu:app/ehu:asignatura/ehu:infoEvalua"/>
	<xsl:variable name="biblioBasicAsignatura" select="ehu:app/ehu:asignatura/ehu:biblioBasic"/>
	<xsl:variable name="biblioProfunAsignatura" select="ehu:app/ehu:asignatura/ehu:biblioProfun"/>
	<xsl:variable name="revistasAsignatura" select="ehu:app/ehu:asignatura/ehu:revistas"/>
	<xsl:variable name="urlsAsignatura" select="ehu:app/ehu:asignatura/ehu:urls"/>
	<xsl:variable name="fechaUltModifAsignatura" select="ehu:app/ehu:asignatura/ehu:fechaUltModif"/>
	<xsl:variable name="modalidadesImparticion" select="ehu:app/ehu:asignatura/ehu:modalidadesImparticion"/>
	<xsl:variable name="profesorado" select="ehu:app/ehu:asignatura/ehu:profesorado"/>
	<xsl:variable name="anyoOfd" select="ehu:app/ehu:asignatura/ehu:anyoOfd"/>
	<xsl:variable name="competenciasAsignatura" select="ehu:app/ehu:asignatura/ehu:competencias"/>
	<xsl:variable name="tiposDocencia" select="ehu:app/ehu:asignatura/ehu:tiposDocencia"/>
	<xsl:variable name="actividadesFormativasAsignatura" select="ehu:app/ehu:asignatura/ehu:actividadesFormativas"/>
	<xsl:variable name="sistemasEvaluacionAsignatura" select="ehu:app/ehu:asignatura/ehu:sistemasEvaluacionFormativas"/>
	
	
	<!-- Profesorado -->
	<!-- Codigo de profesor/a -->
	<xsl:variable name="p_idp" select="ehu:app/ehu:parameters/ehu:parameter[@name='p_idp']"/>
	<xsl:variable name="doctorProfesor" select="ehu:app/ehu:profesor/ehu:doctor"/>
	<xsl:variable name="categoriaProfesor" select="ehu:app/ehu:profesor/ehu:categoria"/>
	<xsl:variable name="nombreProfesor" select="ehu:app/ehu:profesor/ehu:nombre"/>
	<xsl:variable name="desDptoProfesor" select="ehu:app/ehu:profesor/ehu:desDpto"/>
	<xsl:variable name="desAreaProfesor" select="ehu:app/ehu:profesor/ehu:desArea"/>
	<xsl:variable name="emailProfesor" select="ehu:app/ehu:profesor/ehu:email"/>
	<xsl:variable name="tutoriasProfesor" select="ehu:app/ehu:profesor/ehu:tutorias"/>
	<xsl:variable name="p_anyo_acadProfesor" select="ehu:app/ehu:parameters/ehu:parameter[@name='p_anyo_acad']" />
	<xsl:variable name="withNameProfesor" select="'withName'" />
	
	<xsl:template match="/">
		<div>
			<xsl:attribute name="class">xsl-content department</xsl:attribute>
			
			<xsl:choose>
				<!-- Asignatura -->
				<xsl:when test="ehu:app/ehu:asignatura">
					<div>
						<xsl:attribute name="class">taglib-header</xsl:attribute> 
						<span> 
							<xsl:attribute name="class">back-to</xsl:attribute>
							<a> 
								<xsl:choose>
									<!-- Grado -->
									<xsl:when test="$p_cod_proceso = 'plew0040'">
										<xsl:attribute name="href">?p_redirect=consultaGrado</xsl:attribute>
									</xsl:when>	
									<!-- Master -->
									<xsl:when test="$p_cod_proceso = 'plew0050'">
										<xsl:attribute name="href">?p_redirect=consultaMaster</xsl:attribute>
									</xsl:when>
								</xsl:choose>	
								<span>
					  				<xsl:attribute name="class">icon-chevron-left</xsl:attribute>
					  				<xsl:value-of select="$white_space"/>
					  			</span> 
								<span><xsl:value-of select="languageUtil:get($locale,'back')"/></span> 
							</a>
						</span>
					</div>
					<xsl:call-template name="header">
						<xsl:with-param name="title" select="$desAsignatura"/>			
					</xsl:call-template>
				</xsl:when>		
				<!-- Profesor -->
				<xsl:when test="ehu:app/ehu:profesor">
					<div>
						<xsl:attribute name="class">taglib-header</xsl:attribute> 
						<span> 
							<xsl:attribute name="class">back-to</xsl:attribute>
							<a> 
								<xsl:choose>
									<!-- Grado -->
									<xsl:when test="$p_cod_proceso = 'plew0040'">
										<xsl:attribute name="href">?p_redirect=consultaGrado</xsl:attribute>
									</xsl:when>	
									<!-- Master -->
									<xsl:when test="$p_cod_proceso = 'plew0050'">
										<xsl:attribute name="href">?p_redirect=consultaMaster</xsl:attribute>
									</xsl:when>
								</xsl:choose>
								<span>
					  				<xsl:attribute name="class">icon-chevron-left</xsl:attribute>
					  				<xsl:value-of select="$white_space"/>
					  			</span> 
								<span><xsl:value-of select="languageUtil:get($locale,'back')"/></span>
							</a>
						</span>
					</div>
					<xsl:call-template name="header">
						<xsl:with-param name="title" select="$nombreProfesor"/>			
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="header">
						<xsl:with-param name="title" select="$department_title"/>			
					</xsl:call-template>					
				</xsl:otherwise>
			</xsl:choose>
			
			<xsl:choose>
				<!-- Todas las asignaturas -->
				<xsl:when test="not($p_cod_asignatura) and not($p_idp)">
					<xsl:choose>
						<!-- Grado -->
						<xsl:when test="$p_cod_proceso = 'plew0040'">
							<xsl:call-template name="header_main">
								<xsl:with-param name="title" select="languageUtil:get($locale,'ehu.graduate-studies')"/>
							</xsl:call-template>
						</xsl:when>	
						<!-- Master -->
						<xsl:when test="$p_cod_proceso = 'plew0050'">
							<xsl:call-template name="header_main">
								<xsl:with-param name="title" select="languageUtil:get($locale,'ehu.master-studies')"/>
							</xsl:call-template>
						</xsl:when>
					</xsl:choose>	
						
					<xsl:call-template name="header_secondary">
						<xsl:with-param name="title" select="ehu:app/ehu:departamento/ehu:asignaturas/@desAnyoImparticion"/>
					</xsl:call-template>
					
					<!-- Asignaturas ordenadas por grado -->
					<xsl:variable name="asignaturas_sorted_copy">
					<xsl:for-each select="ehu:app/ehu:departamento/ehu:asignaturas/ehu:asignatura">
					<!-- 2021-04-29 bczgalee: lagun 608530 trello 455
						Cambiamos el sort de codPlan a desPlan porque si no salían grados repetidos -->					
						<xsl:sort select="ehu:desPlan" />
							<xsl:copy-of select="current()"/>							        	
						</xsl:for-each>
					</xsl:variable>
					<xsl:variable name="asignaturas_sorted_node_set" select="exsl:node-set($asignaturas_sorted_copy)/*" />
								
					
					<xsl:variable name="asignaturas_sorted_copy_2">
					<xsl:for-each select="ehu:app/ehu:departamento/ehu:asignaturas/ehu:asignatura">
						<xsl:sort select="ehu:curso"/>
							<xsl:copy-of select="current()"/>							        	
						</xsl:for-each>
					</xsl:variable>
					<xsl:variable name="asignaturas_sorted_node_set_2" select="exsl:node-set($asignaturas_sorted_copy_2)/*" />
					
					<div>
						<xsl:attribute name="id">listTab</xsl:attribute>
						<ul>
							<xsl:attribute name="id">list</xsl:attribute>
							<xsl:attribute name="class">nav nav-pills</xsl:attribute>
							<xsl:for-each select="$asignaturas_sorted_node_set">
								<xsl:if test="(ehu:codAsignatura) and (ehu:desAsignatura)">
									<xsl:variable name="anchor" select="ehu:codPlan"/>
									<xsl:variable name="plan" select="ehu:desPlan"/>
									<xsl:variable name="previous_plan" select="preceding-sibling::*[1]/ehu:desPlan" />
									<xsl:if test="not($previous_plan = $plan)">
										<li>
											<a>
												<xsl:attribute name="href">#<xsl:value-of select="$anchor"/></xsl:attribute>
												<xsl:value-of select="$plan"/>
											</a>
										</li>
									</xsl:if>
								</xsl:if>		
							</xsl:for-each>
						</ul>
					</div>
					
					<xsl:for-each select="$asignaturas_sorted_node_set">
						<xsl:variable name="anchor" select="ehu:codPlan"/>
						<xsl:variable name="plan" select="ehu:desPlan"/>
						<xsl:variable name="asignatura" select="ehu:desAsignatura"/>
						<xsl:variable name="previous_plan" select="preceding-sibling::*[1]/ehu:desPlan" />
						<xsl:variable name="following_plan" select="following-sibling::*[1]/ehu:desPlan" />
						
						<xsl:variable name="urlEstudio" select="ehu:urlInicio"/>
						
						<xsl:if test="not($previous_plan = $plan)">
							<table>
								<xsl:attribute name="id"><xsl:value-of select="$anchor"/></xsl:attribute>
								<caption>
								<xsl:choose>
									<!-- 2021-03-22 - Edorta - Trello 418 -->
									<!-- Comprobamos que el link tenga http para saber que es una URL completa a la que se le epuede meter el <a> -->
									<xsl:when test="$urlEstudio != $void and contains($urlEstudio, 'https://')">
										<a>
											<xsl:attribute name="href"><xsl:value-of select="$urlEstudio"/></xsl:attribute>											
											<xsl:attribute name="title">
												<xsl:choose>
													<!-- Grado -->
													<xsl:when test="$p_cod_proceso = 'plew0040'">
														<xsl:value-of select="languageUtil:get($locale,'ehu.go-to-graduate')"/>
													</xsl:when>	
													<!-- Master -->
													<xsl:when test="$p_cod_proceso = 'plew0050'">
														<xsl:value-of select="languageUtil:get($locale,'ehu.go-to-master')"/>
													</xsl:when>												
												</xsl:choose>	
											</xsl:attribute>
											<xsl:value-of select="$plan"/>											
										</a>
									</xsl:when>
									<xsl:otherwise>	
										<xsl:value-of select="$plan"/>
									</xsl:otherwise>	
								</xsl:choose>
								</caption>
								<thead>
									<tr>
										<th>
											<xsl:attribute name="scope">col</xsl:attribute>
											<xsl:value-of select="languageUtil:get($locale,'ehu.asignaturas')" />
										</th>
										<th>
											<xsl:attribute name="scope">col</xsl:attribute>
											<xsl:value-of select="languageUtil:get($locale,'ehu.curso')" />
										</th>
										<th>
											<xsl:attribute name="scope">col</xsl:attribute>
											<xsl:value-of select="languageUtil:get($locale,'ehu.credits')" />
											</th>
										<th>
											<xsl:attribute name="scope">col</xsl:attribute>
											<xsl:value-of select="languageUtil:get($locale,'ehu.teaching-center')" />
										</th>
										<th>
											<xsl:attribute name="scope">col</xsl:attribute>
											<xsl:value-of select="languageUtil:get($locale,'ehu.campus')" />
										</th>						
									</tr>
								</thead>
								<tbody>
									<xsl:for-each select="$asignaturas_sorted_node_set_2">
										<xsl:variable name="plan_2" select="ehu:desPlan"/>
										<xsl:variable name="asignatura_2" select="ehu:desAsignatura"/>
										<xsl:if test="$plan = $plan_2">
											<tr>
												<td>
													<a>
														<xsl:choose>
															<!-- Grado -->
															<xsl:when test="$p_cod_proceso = 'plew0040'">
																<xsl:attribute name="href">?p_redirect=consultaAsignatura&amp;p_anyo_acad=<xsl:value-of select="$anyoAcad"/>&amp;p_ciclo=<xsl:value-of select="ehu:ciclo"/>&amp;p_curso=<xsl:value-of select="ehu:curso"/>&amp;p_cod_asignatura=<xsl:value-of select="ehu:codAsignatura"/>&amp;p_cod_plan=<xsl:value-of select="ehu:codPlan"/>&amp;p_cod_centro=<xsl:value-of select="ehu:codCentro"/></xsl:attribute>
															</xsl:when>	
															<!-- Master -->
															<xsl:when test="$p_cod_proceso = 'plew0050'">
																<xsl:attribute name="href">?p_redirect=consultaAsignatura&amp;p_anyo_ofd=&amp;p_anyo_pop=&amp;p_cod_centro=<xsl:value-of select="ehu:codCentro"/>&amp;p_cod_master=&amp;p_cod_materia=&amp;p_cod_asignatura=<xsl:value-of select="ehu:codAsignatura"/>&amp;p_tipo_asignatura=</xsl:attribute>
															</xsl:when>
														</xsl:choose>
														<xsl:value-of select="$asignatura_2" />
													</a>
												</td>
												<td>
													<xsl:value-of select="ehu:curso" />
												</td>
												<td>
													<xsl:value-of select="ehu:numCreditos" />
												</td>
												<td>
													<xsl:value-of select="ehu:desCentro" />
												</td>
												<td>
													<xsl:value-of select="ehu:desCampus" />
												</td>						
											</tr>	
										</xsl:if>								
									</xsl:for-each>	
								</tbody>
							</table>					
						</xsl:if>	
						<xsl:if test="not($following_plan = $plan)">
							<a>  
								<xsl:attribute name="href">#list</xsl:attribute>
								<xsl:attribute name="class">pull-right</xsl:attribute>
								<span>
									<xsl:value-of select="languageUtil:get($locale,'top')"/>
									<xsl:value-of select="$white_space"/>
									<span>
										<xsl:attribute name="class">icon-chevron-up</xsl:attribute>
									</span>
								</span>
							</a>
						</xsl:if>
					</xsl:for-each>	
				</xsl:when>
				<!-- Una asignatura -->
				<xsl:when test="($p_cod_asignatura) and not($p_idp)">
					<xsl:if test="ehu:app/ehu:asignatura">
						<dl>
							<dt><xsl:value-of select="languageUtil:get($locale,'ehu.teaching-center')"/></dt>
							<dd><xsl:value-of select="$desCentroAsignatura"/></dd>									
							<dt><xsl:value-of select="languageUtil:get($locale,'ehu.titulacion')"/></dt>
							<dd><xsl:value-of select="$desPlanAsignatura"/></dd>
							<dt><xsl:value-of select="languageUtil:get($locale,'ehu.academic-year')"/></dt>
							<dd><xsl:value-of select="$desAnyoAcadAsignatura"/></dd>
							<dt><xsl:value-of select="languageUtil:get($locale,'ehu.curso')"/></dt>
							<dd><xsl:value-of select="$cursoAsignatura"/></dd>
							<dt><xsl:value-of select="languageUtil:get($locale,'ehu.numCreditos')"/></dt>
							<dd><xsl:value-of select="format-number($numCreditosAsignatura,'###.#')"/></dd>
							<dt><xsl:value-of select="languageUtil:get($locale,'ehu.idiomas')"/></dt>
							<xsl:for-each select="$idiomasAsignatura/ehu:idioma">
								<dd><xsl:value-of select="ehu:descIdiomaImpart"/><xsl:value-of select="$white_space"/></dd>
							</xsl:for-each>										
						</dl>
						<div>
							<xsl:attribute name="id">toggler</xsl:attribute>
							<!--  tipo de docencia -->
							<xsl:if test="$docenciasAsignatura != $void">
								<h2>
									<xsl:attribute name="class">header toggler-header-collapsed</xsl:attribute>
									<xsl:value-of select="languageUtil:get($locale,'ehu.docencia')"/>
									<span>
										<xsl:attribute name="tabindex">0</xsl:attribute>
										<span>
											<xsl:attribute name="class">hide-accessible</xsl:attribute>
											<xsl:value-of select="languageUtil:get($locale,'toggle-navigation')"/>
										</span>
									</span>		
								</h2>
								
								<div>
									<xsl:attribute name="class">content toggler-content-collapsed</xsl:attribute>
									<xsl:call-template name="tipoDocencia">												
										<xsl:with-param name="docencias" select="$docenciasAsignatura"/>
									</xsl:call-template>
								</div>
							</xsl:if>
							<!-- Guia docente -->
							<h2>
								<xsl:attribute name="class">header toggler-header-collapsed</xsl:attribute>
								<xsl:value-of select="languageUtil:get($locale,'ehu.guiaDocente')"/>
								<span>
								<xsl:attribute name="tabindex">0</xsl:attribute>
								<span>
									<xsl:attribute name="class">hide-accessible</xsl:attribute>
									<xsl:value-of select="languageUtil:get($locale,'toggle-navigation')"/>
								</span>
							</span>		
							</h2>
							
							<div>
								<xsl:attribute name="class">content toggler-content-collapsed</xsl:attribute>
								<div>
									<xsl:attribute name="id">toggler2</xsl:attribute>
									<xsl:if test="$objetivosAsignatura != $void">
										<h3>
											<xsl:attribute name="class">header2 toggler-header-collapsed</xsl:attribute>
											<xsl:value-of select="languageUtil:get($locale,'ehu.objetivos')"/>
											<span>
												<xsl:attribute name="tabindex">0</xsl:attribute>
												<span>
													<xsl:attribute name="class">hide-accessible</xsl:attribute>
													<xsl:value-of select="languageUtil:get($locale,'toggle-navigation')"/>
												</span>
											</span>		
										</h3>
										
										<div>
											<xsl:attribute name="class">content2 toggler-content-collapsed</xsl:attribute>
											<p><xsl:value-of select="$objetivosAsignatura" disable-output-escaping="yes" /></p>
										</div>
									</xsl:if>
										
									<xsl:if test="$temarioAsignatura != $void">
										<h3>
											<xsl:attribute name="class">header2 toggler-header-collapsed</xsl:attribute>
											<xsl:value-of select="languageUtil:get($locale,'ehu.temary')"/>
											<span>
												<xsl:attribute name="tabindex">0</xsl:attribute>
												<span>
													<xsl:attribute name="class">hide-accessible</xsl:attribute>
													<xsl:value-of select="languageUtil:get($locale,'toggle-navigation')"/>
												</span>
											</span>		
										</h3>
										
										<div>
											<xsl:attribute name="class">content2 toggler-content-collapsed</xsl:attribute>
											<p><xsl:value-of select="$temarioAsignatura" disable-output-escaping="yes" /></p>
										</div>
									</xsl:if>
											
									<xsl:if test="$metodologiaAsignatura != $void">
										<h3>
											<xsl:attribute name="class">header2 toggler-header-collapsed</xsl:attribute>
											<xsl:value-of select="languageUtil:get($locale,'ehu.metodologia')"/>
											<span>
												<xsl:attribute name="tabindex">0</xsl:attribute>
												<span>
													<xsl:attribute name="class">hide-accessible</xsl:attribute>
													<xsl:value-of select="languageUtil:get($locale,'toggle-navigation')"/>
												</span>
											</span>		
										</h3>
										
										<div>
											<xsl:attribute name="class">content2 toggler-content-collapsed</xsl:attribute>
											<p><xsl:value-of select="$metodologiaAsignatura" disable-output-escaping="yes" /></p>
										</div>
									</xsl:if>
											
									<xsl:if test="$infoEvaluaAsignatura != $void">
										<h3>
											<xsl:attribute name="class">header2 toggler-header-collapsed</xsl:attribute>
											<xsl:value-of select="languageUtil:get($locale,'ehu.sistemasEvaluacion')"/>
											<span>
												<xsl:attribute name="tabindex">0</xsl:attribute>
												<span>
													<xsl:attribute name="class">hide-accessible</xsl:attribute>
													<xsl:value-of select="languageUtil:get($locale,'toggle-navigation')"/>
												</span>
											</span>		
										</h3>
										
										<div>
											<xsl:attribute name="class">content2 toggler-content-collapsed</xsl:attribute>
											<p><xsl:value-of select="$infoEvaluaAsignatura" disable-output-escaping="yes" /></p>
										</div>
									</xsl:if>
											
									<xsl:if test="$materialObligAsignatura != $void">
										<h3>
											<xsl:attribute name="class">header2 toggler-header-collapsed</xsl:attribute>
											<xsl:value-of select="languageUtil:get($locale,'ehu.asigMateriales')"/>
											<span>
												<xsl:attribute name="tabindex">0</xsl:attribute>
												<span>
													<xsl:attribute name="class">hide-accessible</xsl:attribute>
													<xsl:value-of select="languageUtil:get($locale,'toggle-navigation')"/>
												</span>
											</span>		
										</h3>
										
										<div>
											<xsl:attribute name="class">content2 toggler-content-collapsed</xsl:attribute>
											<p><xsl:value-of select="$materialObligAsignatura" disable-output-escaping="yes" /></p>
										</div>
									</xsl:if>
											
									<xsl:if test="$biblioBasicAsignatura != $void or $biblioProfunAsignatura != $void or $revistasAsignatura != $void or $urlsAsignatura != $void">
										<h3>
											<xsl:attribute name="class">header2 toggler-header-collapsed</xsl:attribute>
											<xsl:value-of select="languageUtil:get($locale,'ehu.bibliography')"/>
											<span>
												<xsl:attribute name="tabindex">0</xsl:attribute>
												<span>
													<xsl:attribute name="class">hide-accessible</xsl:attribute>
													<xsl:value-of select="languageUtil:get($locale,'toggle-navigation')"/>
												</span>
											</span>		
										</h3>
										
										<div>
											<xsl:attribute name="class">content2 toggler-content-collapsed</xsl:attribute>
											<xsl:if test="$biblioBasicAsignatura != $void">
												<xsl:call-template name="header_third">
													<xsl:with-param name="title" select="languageUtil:get($locale,'ehu.bibliografiaBasica')"/>
												</xsl:call-template>
												<p><xsl:value-of select="$biblioBasicAsignatura" disable-output-escaping="yes" /></p>
											</xsl:if>
													
											<xsl:if test="$biblioProfunAsignatura != $void">
												<xsl:call-template name="header_third">
													<xsl:with-param name="title" select="languageUtil:get($locale,'ehu.biblioProfun')"/>
												</xsl:call-template>
												<p><xsl:value-of select="$biblioProfunAsignatura" disable-output-escaping="yes" /></p>
											</xsl:if>
													
											<xsl:if test="$revistasAsignatura != $void">
												<xsl:call-template name="header_third">
													<xsl:with-param name="title" select="languageUtil:get($locale,'ehu.revistas')"/>
												</xsl:call-template>
												<p><xsl:value-of select="$revistasAsignatura" disable-output-escaping="yes" /></p>
											</xsl:if>
													
											<xsl:if test="$urlsAsignatura != $void">
												<xsl:call-template name="header_third">
													<xsl:with-param name="title" select="languageUtil:get($locale,'ehu.urls')"/>
												</xsl:call-template>
												<p><xsl:value-of select="$urlsAsignatura" disable-output-escaping="yes" /></p>
											</xsl:if>
										</div>
									</xsl:if>
								</div>
							</div>
							
							<!--  miembros del tribunal -->
							<xsl:if test="$miembrosTribunalAsignatura != $void">
								<h2>
									<xsl:attribute name="class">header toggler-header-collapsed</xsl:attribute>
									<xsl:value-of select="languageUtil:get($locale,'ehu.miembrosTribunal')"/>
									<span>
										<xsl:attribute name="tabindex">0</xsl:attribute>
										<span>
											<xsl:attribute name="class">hide-accessible</xsl:attribute>
											<xsl:value-of select="languageUtil:get($locale,'toggle-navigation')"/>
										</span>
									</span>		
								</h2>
								
								<div>
									<xsl:attribute name="class">content toggler-content-collapsed</xsl:attribute>
									<xsl:call-template name="miembrosTribunal">												
										<xsl:with-param name="miembrosTribunal" select="$miembrosTribunalAsignatura"/>
									</xsl:call-template>	
								</div>
							</xsl:if>
									
							<!-- grupos-->
							<xsl:if test="$gruposAsignatura != $void">
								<h2>
									<xsl:attribute name="class">header toggler-header-collapsed</xsl:attribute>
									<xsl:value-of select="languageUtil:get($locale,'ehu.groups')"/>
									<span>
										<xsl:attribute name="tabindex">0</xsl:attribute>
										<span>
											<xsl:attribute name="class">hide-accessible</xsl:attribute>
											<xsl:value-of select="languageUtil:get($locale,'toggle-navigation')"/>
										</span>
									</span>		
								</h2>
								
								<div>
									<xsl:attribute name="class">content toggler-content-collapsed</xsl:attribute>
									<xsl:call-template name="graduate-groups">												
										<xsl:with-param name="grupos" select="$gruposAsignatura"/>
										<xsl:with-param name="anyoAcad" select="$p_anyo_acad" />
									</xsl:call-template>
								</div>
							</xsl:if>
						</div>
						
						<xsl:if test="$fechaUltModifAsignatura != $void">
							<div>
								<xsl:attribute name="class">content-footer</xsl:attribute>
								<p>
									<xsl:attribute name="class">modification_date</xsl:attribute>	
						          	<strong>
						          		<xsl:attribute name="class">text</xsl:attribute>
						          		<xsl:value-of select="languageUtil:get($locale,'ehu.last-modification-date')"/>:<xsl:value-of select="$white_space"/>
						          	</strong>
						          	<span>
						          		<xsl:attribute name="class">date</xsl:attribute>
						           		<xsl:value-of select="substring-before($fechaUltModifAsignatura, 'Z')" />
						           	</span>	
						        </p>
							</div>					
						</xsl:if>
					</xsl:if>									
				</xsl:when>
				<!-- un profesor -->
				<xsl:when test="not($p_cod_asignatura) and ($p_idp)">
					<xsl:if test="ehu:app/ehu:profesor">
						<dl>
							<dt>
								<xsl:value-of select="languageUtil:get($locale,'ehu.categoria')"/>
							</dt>
							<dd>
								<xsl:value-of select="$categoriaProfesor"/>
								<xsl:if test="$doctorProfesor">
									<xsl:value-of select="$white_space" />(<xsl:value-of select="$doctorProfesor" />)
								</xsl:if>
							</dd>
							<dt><xsl:value-of select="languageUtil:get($locale,'ehu.departamento')"/></dt>
							<dd><xsl:value-of select="$desDptoProfesor"/></dd>									
							<dt><xsl:value-of select="languageUtil:get($locale,'ehu.area')"/></dt>
							<dd><xsl:value-of select="$desAreaProfesor"/></dd>
							<dt><xsl:value-of select="languageUtil:get($locale,'email')"/></dt>
							<dd>
								<span>
									<xsl:attribute name="class">icon-envelope</xsl:attribute>
									<xsl:value-of select="$white_space"/>
								</span>
								<a>
									<xsl:attribute name="href">mailto:<xsl:value-of select="$emailProfesor"/></xsl:attribute>
									<xsl:value-of select="$emailProfesor"/>
								</a>
							</dd>	
						</dl>
					</xsl:if>		
					<xsl:call-template name="profesor-tutorias">												
						<xsl:with-param name="tutorias" select="$tutoriasProfesor"/>
					</xsl:call-template>
				</xsl:when>
			</xsl:choose>	
			
		</div>	
	</xsl:template>	
		
</xsl:stylesheet>
