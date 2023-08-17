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

	<xsl:include href="http://localhost:8080/o/ehu-xsl-content-web/commons-newstyle/common.xsl" />
	

	<!-- Grado -->
	<xsl:variable name="grado" select="ehu:app/ehu:grados/ehu:grado" />
	<xsl:variable name="desPlan" select="ehu:app/ehu:grados/ehu:grado/ehu:desPlan" />
	<xsl:variable name="desAnyoAcad" select="ehu:app/ehu:grados/ehu:grado/ehu:desAnyoAcad" />
	
	<!--  se comenta por estar ya definido en el common.xsl 
	<xsl:decimal-format name="european" decimal-separator=',' grouping-separator='.' />-->
	
	<xsl:variable name="nombreGrado">
		<xsl:value-of select="$desPlan" />
		<xsl:value-of select="$white_space" />
		-
		<xsl:value-of select="$white_space" />
		<xsl:value-of select="$desAnyoAcad" />
	</xsl:variable>


	<!-- Menciones -->
	<xsl:variable name="lineasCurriculares"
		select="ehu:app/ehu:grados/ehu:grado/ehu:lineasCurriculares" />
		
	<!-- Competencias -->
	<xsl:variable name="competencias"
		select="ehu:app/ehu:grados/ehu:grado/ehu:competencias" />
	
	<!-- Cursos -->
	<xsl:variable name="cursos" select="ehu:app/ehu:grados/ehu:grado/ehu:cursos"/>
	
	<!-- Asignatura -->
	<xsl:variable name="desAsignatura"	select="ehu:app/ehu:asignatura/ehu:desAsignatura" />
	<xsl:variable name="p_cod_asignatura" select="ehu:app/ehu:parameters/ehu:parameter[@name='p_cod_asignatura']"/>
	<xsl:variable name="p_anyo_acad" select="ehu:app/ehu:parameters/ehu:parameter[@name='p_anyo_acad']"/>
	<xsl:variable name="p_cod_centro" select="ehu:app/ehu:parameters/ehu:parameter[@name='p_cod_centro']"/>
	<xsl:variable name="p_cod_plan" select="ehu:app/ehu:parameters/ehu:parameter[@name='p_cod_plan']"/>

	<xsl:variable name="desCentroAsignatura" select="ehu:app/ehu:asignatura/ehu:desCentro"/>
	<xsl:variable name="desPlanAsignatura" select="ehu:app/ehu:asignatura/ehu:desPlan"/>
	<xsl:variable name="desAnyoAcadAsignatura" select="ehu:app/ehu:asignatura/ehu:desAnyoAcad"/>
	<xsl:variable name="cursoAsignatura" select="ehu:app/ehu:asignatura/ehu:curso"/>
	<xsl:variable name="numCreditosAsignatura" select="ehu:app/ehu:asignatura/ehu:numCreditos"/>
	<xsl:variable name="idiomasAsignatura" select="ehu:app/ehu:asignatura/ehu:idiomas"/>
	<xsl:variable name="codigoAsignatura" select="ehu:app/ehu:asignatura/ehu:codAsignatura"/>
	<xsl:variable name="restriccionesAsignatura" select="ehu:app/ehu:asignatura/ehu:restricciones"/>
	<xsl:variable name="docenciasAsignatura" select="ehu:app/ehu:asignatura/ehu:docencias"/>
	<xsl:variable name="desContextAsignatura" select="ehu:app/ehu:asignatura/ehu:desContext"/>
	<xsl:variable name="gruposAsignatura" select="ehu:app/ehu:asignatura/ehu:grupos"/>
	<xsl:variable name="miembrosTribunalAsignatura" select="ehu:app/ehu:asignatura/ehu:miembrosTribunal"/>
	<xsl:variable name="materialObligAsignatura" select="ehu:app/ehu:asignatura/ehu:materialOblig"/>
	<xsl:variable name="objetivosAsignatura" select="ehu:app/ehu:asignatura/ehu:objetivos"/>
	<xsl:variable name="temarioAsignatura" select="ehu:app/ehu:asignatura/ehu:temario"/>
	<xsl:variable name="metodologiaAsignatura" select="ehu:app/ehu:asignatura/ehu:metodologia"/>
	<xsl:variable name="infoEvaluaAsignatura" select="ehu:app/ehu:asignatura/ehu:infoEvalua"/>
	<xsl:variable name="infoEvaluaExtra" select="ehu:app/ehu:asignatura/ehu:convExtra"/>
	<xsl:variable name="biblioBasicAsignatura" select="ehu:app/ehu:asignatura/ehu:biblioBasic"/>
	<xsl:variable name="biblioProfunAsignatura" select="ehu:app/ehu:asignatura/ehu:biblioProfun"/>
	<xsl:variable name="revistasAsignatura" select="ehu:app/ehu:asignatura/ehu:revistas"/>
	<xsl:variable name="urlsAsignatura" select="ehu:app/ehu:asignatura/ehu:direccionesInternet"/>
	<xsl:variable name="fechaUltModifAsignatura" select="ehu:app/ehu:asignatura/ehu:fechaUltModif"/>
	<xsl:variable name="hayPrerrequisitos" select="ehu:app/ehu:asignatura/ehu:hayPrerrequisitos"/>
	
	<!--  Porcentajes de evaluación -->
	<xsl:variable name="indEvalCon" select="ehu:app/ehu:asignatura/ehu:indEvalCon"/>
	<xsl:variable name="indEvalMix" select="ehu:app/ehu:asignatura/ehu:indEvalMix"/>
	<xsl:variable name="indEvalFin" select="ehu:app/ehu:asignatura/ehu:indEvalFin"/>	
	<xsl:variable name="porcEvalEed" select="ehu:app/ehu:asignatura/ehu:porcEvalEed"/>
	<xsl:variable name="porcEvalEet" select="ehu:app/ehu:asignatura/ehu:porcEvalEet"/>
	<xsl:variable name="porcEvalEo" select="ehu:app/ehu:asignatura/ehu:porcEvalEo"/>
	<xsl:variable name="porcEvalRp" select="ehu:app/ehu:asignatura/ehu:porcEvalRp"/>
	<xsl:variable name="porcEvalTi" select="ehu:app/ehu:asignatura/ehu:porcEvalTi"/>
	<xsl:variable name="porcEvalTg" select="ehu:app/ehu:asignatura/ehu:porcEvalTg"/>	
	<xsl:variable name="porcEvalEt" select="ehu:app/ehu:asignatura/ehu:porcEvalEt"/>	
	<xsl:variable name="porcEvalOtros" select="ehu:app/ehu:asignatura/ehu:porcEvalOtros"/>	
	<xsl:variable name="porcEvalLibre" select="ehu:app/ehu:asignatura/ehu:porcEvalLibre"/>	
	<xsl:variable name="evalLibre" select="ehu:app/ehu:asignatura/ehu:evalLibre"/>	
	<!-- Creditos -->	
	<xsl:variable name="creditos" select="ehu:app/ehu:grados/ehu:grado/ehu:creditos"/>

	<!-- Profesor -->
	<xsl:variable name="p_idp" select="ehu:app/ehu:parameters/ehu:parameter[@name='p_idp']"/>
	
	<xsl:variable name="profesorado" select="ehu:app/ehu:grados/ehu:grado/ehu:profesorado"/>
	
	
	<xsl:variable name="doctorProfesor" select="ehu:app/ehu:profesor/ehu:doctor"/>
	<xsl:variable name="categoriaProfesor" select="ehu:app/ehu:profesor/ehu:categoria"/>
	<xsl:variable name="perfilDocente" select="ehu:app/ehu:profesor/ehu:perfilDocente"/>
	<xsl:variable name="nombreProfesor" select="ehu:app/ehu:profesor/ehu:nombre"/>
	<xsl:variable name="desDptoProfesor" select="ehu:app/ehu:profesor/ehu:desDpto"/>
	<xsl:variable name="desAreaProfesor" select="ehu:app/ehu:profesor/ehu:desArea"/>
	<xsl:variable name="emailProfesor" select="ehu:app/ehu:profesor/ehu:email"/>
	<xsl:variable name="tutoriasProfesor" select="ehu:app/ehu:profesor/ehu:tutorias"/>
	<xsl:variable name="p_anyo_acadProfesor" select="ehu:app/ehu:parameters/ehu:parameter[@name='p_anyo_acad']" />
	<xsl:variable name="withNameProfesor" select="'withName'" />
	
	<!-- Departamento -->
	<xsl:variable name="nombreDpto"
		select="ehu:app/ehu:departamento/ehu:descripcion" />

	<xsl:variable name="documentos" select="ehu:app/ehu:grados/ehu:grado/ehu:documentos" />
	<xsl:variable name="hayVerificacion" select="ehu:app/ehu:grados/ehu:grado/ehu:hayVerificacion"/>
	<xsl:variable name="anyoAcad" select="ehu:app/ehu:grados/ehu:grado/ehu:anyoAcad"/>
	<xsl:variable name="degree_enlaceRutc" select="ehu:app/ehu:grados/ehu:grado/ehu:enlaceRutc"/>
	<xsl:variable name="documento2"/>
	
	<xsl:template match="/">

		<div>
			<xsl:attribute name="class">xsl-content graduate</xsl:attribute>
			<xsl:choose>
				<!-- Asignatura -->
				<xsl:when test="ehu:app/ehu:asignatura">
					<div class="text-right">
						<a class="btn btn-upv btn-primary">
						<xsl:attribute name="href">?p_redirect=consultaGrado</xsl:attribute>
						<xsl:call-template name="elemento_span_atras"/>
						<xsl:value-of select="languageUtil:get($locale,'back')"/>
						</a>
						<xsl:value-of select="$white_space"/>
						
						<a class="btn btn-upv btn-primary">
						<xsl:attribute name="href">#</xsl:attribute>
						<xsl:attribute name="onclick">window.print();return false;</xsl:attribute>
						<xsl:value-of select="languageUtil:get($locale,'ehu.print')"/>
						<xsl:call-template name="elemento_span_imprimir"/>
						</a>
					</div>
						
							
					<xsl:call-template name="header_main_imptext">
						<xsl:with-param name="title">
							<xsl:value-of select="$desAsignatura"></xsl:value-of>
						</xsl:with-param>	
						<xsl:with-param name="titleOculto">
							<xsl:value-of select="$p_cod_asignatura"></xsl:value-of>
						</xsl:with-param>		
					</xsl:call-template>
				</xsl:when>
				<!-- Profesor -->
				<xsl:when test="ehu:app/ehu:profesor">
					<div class="text-right">
						<a class="btn btn-upv btn-primary">
						<xsl:attribute name="href">?p_redirect=consultaGrado</xsl:attribute>
						<xsl:call-template name="elemento_span_atras"/>
						<xsl:value-of select="languageUtil:get($locale,'back')"/>
						</a>
					</div>
					
					<xsl:call-template name="header">
						<xsl:with-param name="title" select="$nombreProfesor" />
					</xsl:call-template>
									
					
				</xsl:when>
				<!-- Departamento -->
				<xsl:when test="ehu:app/ehu:departamento">

					<div>
						<xsl:attribute name="class">taglib-header</xsl:attribute>
						<span>
							<xsl:attribute name="class">back-to</xsl:attribute>
							<a>
								<xsl:attribute name="href">?p_redirect=consultaGrado</xsl:attribute>
								<span>
									<xsl:attribute name="class">icon-chevron-left</xsl:attribute>
									<xsl:value-of select="$white_space" />
								</span>
								<span>
									<xsl:value-of select="languageUtil:get($locale,'back')" />
								</span>
							</a>
						</span>
					</div>
					<xsl:call-template name="header">
						<xsl:with-param name="title" select="$nombreDpto" />
					</xsl:call-template>
				</xsl:when>
				<!-- Fichero -->
				<xsl:when test="ehu:app/ehu:fichero">
					<script>window.location.href='<xsl:value-of select="ehu:app/ehu:fichero/ehu:ruta"/>';</script>
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="$p_nav != '10' and $p_nav != '20' and  $p_nav != '30' and  $p_nav != '40' and  $p_nav != '50' and  $p_nav != '60'  and  $p_nav != '70' and  $p_nav != '80' ">
						<xsl:call-template name="header">
							<xsl:with-param name="title" select="$nombreGrado" />
						</xsl:call-template>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>

			<xsl:choose>
				<!-- Resumen -->
				<xsl:when test="$p_nav = '10'">
					<xsl:call-template name="summary-graduate">
						<xsl:with-param name="graduate" select="$grado" />
					</xsl:call-template>
				</xsl:when>
				<!-- Precios -->
				<xsl:when test="$p_nav = '20'">
					<xsl:call-template name="precios-graduate">
						<xsl:with-param name="graduate" select="$grado" />
					</xsl:call-template>
				</xsl:when>	
				<!-- Menciones -->
				<xsl:when test="$p_nav = '30'">
					<xsl:call-template name="menciones-itinerarios">
						<xsl:with-param name="lineasCurriculares" select="$lineasCurriculares" />
					</xsl:call-template>				
				</xsl:when>
				<!-- Asignatura -->
				<xsl:when test="$p_nav = '40'">
					<xsl:choose>
						<xsl:when test="not($p_cod_asignatura) and not($p_idp)">
							<xsl:call-template name="creditos">
								<xsl:with-param name="graduate" select="$grado" />
							</xsl:call-template>
						</xsl:when>
					
						<xsl:when test="($p_cod_asignatura) and not($p_idp)">
							<xsl:if test="ehu:app/ehu:asignatura">
								
								<!-- Tipo de docencia -->
								<div>
									<xsl:attribute name="class">m-b-30</xsl:attribute>
									<div>
										<xsl:attribute name="class">bg-white asignaturacontenido p-20</xsl:attribute>
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
											<xsl:if test="$idiomasAsignatura != $void">
												<dt><xsl:value-of select="languageUtil:get($locale,'ehu.idiomas')"/></dt>
												<xsl:for-each select="$idiomasAsignatura/ehu:idioma">
													<dd><xsl:value-of select="ehu:descIdiomaImpart"/><xsl:value-of select="$white_space"/></dd>
												</xsl:for-each>
											</xsl:if>
											<xsl:if test="$codigoAsignatura">
												<dt><xsl:value-of select="languageUtil:get($locale,'ehu.code')"/></dt>
												<dd><xsl:value-of select="$codigoAsignatura"/></dd>
											</xsl:if>
											<xsl:if test="$hayPrerrequisitos = 1">
												<dt><xsl:value-of select="languageUtil:get($locale,'ehu.restricciones')"/></dt>
												<xsl:for-each select="$restriccionesAsignatura/ehu:restriccion">
													<dd><xsl:value-of select="ehu:descripcion"/></dd>
												</xsl:for-each>
											</xsl:if>
										</dl>
									</div>
								</div>
								<div>
									<xsl:attribute name="class">m-b-30</xsl:attribute>	
       								<div>
										<xsl:attribute name="class">bg-white asignaturacontenido</xsl:attribute>
											<div>
												<xsl:attribute name="id">toggler</xsl:attribute>
												<!--  tipo de docencia -->
												<xsl:if test="$docenciasAsignatura != $void">
													<h2>
														<xsl:attribute name="class">header toggler-header-expanded toggler-header</xsl:attribute>
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
														<xsl:attribute name="class">content toggler-content-expanded</xsl:attribute>
														<xsl:call-template name="tipoDocencia">												
															<xsl:with-param name="docencias" select="$docenciasAsignatura"/>
														</xsl:call-template>
													</div>
												</xsl:if>
												<!-- Guia docente -->
												<h2>
													<xsl:attribute name="class">header toggler-header-collapsed toggler-header</xsl:attribute>
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
														<xsl:if test="$desContextAsignatura != $void">
															<h3>
																<xsl:attribute name="class">header2 toggler-header-collapsed toggler-header</xsl:attribute>
																<xsl:value-of select="languageUtil:get($locale,'ehu.xsl-content.grado.contextualizacion')"/>
															
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
																<xsl:call-template name="label-value-without-title">
																	<xsl:with-param name="value" select="$desContextAsignatura"/>
																</xsl:call-template>													
															</div>
														</xsl:if>
														<xsl:if test="$objetivosAsignatura != $void">
															<h3>
																<xsl:attribute name="class">header2 toggler-header-collapsed toggler-header</xsl:attribute>
																<xsl:value-of select="languageUtil:get($locale,'ehu.xsl-content.grado.resultadosAprendizaje')"/>
															
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
																<xsl:call-template name="label-value-without-title">
																	<xsl:with-param name="value" select="$objetivosAsignatura"/>
																</xsl:call-template>													
															</div>
														</xsl:if>
													
														<xsl:if test="$temarioAsignatura != $void">
																<h3>
																	<xsl:attribute name="class">header2 toggler-header-collapsed toggler-header</xsl:attribute>
																	<xsl:value-of select="languageUtil:get($locale,'ehu.asigContenidos')"/>
																
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
																	<xsl:call-template name="label-value-without-title">
																		<xsl:with-param name="value" select="$temarioAsignatura"/>
																	</xsl:call-template>														
																</div>
															
														</xsl:if>
														
														
														<xsl:if test="$metodologiaAsignatura != $void">
															<h3>
																<xsl:attribute name="class">header2 toggler-header-collapsed toggler-header</xsl:attribute>
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
																<xsl:call-template name="label-value-without-title">
																	<xsl:with-param name="value" select="$metodologiaAsignatura"/>
																</xsl:call-template>													
															</div>
															
														</xsl:if>
														
														<xsl:if test="($indEvalCon != $void and $indEvalCon != 0) or ($indEvalFin != $void and $indEvalFin != 0) or ($indEvalMix != $void and $indEvalMix != 0)">
															<h3>
																<xsl:attribute name="class">header2 toggler-header-collapsed toggler-header</xsl:attribute>
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
																<ul>
																	<xsl:if test="($indEvalCon != $void and $indEvalCon != 0)">
																		<li><xsl:value-of select="languageUtil:get($locale,'ehu.xsl-content.grado.sistema.continua')"/></li>
																	</xsl:if>
																	<xsl:if test="($indEvalFin != $void and $indEvalFin != 0)">
																		<li><xsl:value-of select="languageUtil:get($locale,'ehu.xsl-content.grado.sistema.final')"/></li>
																	</xsl:if>
																	<xsl:if test="($indEvalMix != $void and $indEvalMix != 0)">
																		<li><xsl:value-of select="languageUtil:get($locale,'ehu.xsl-content.grado.sistema.mixta')"/></li>
																	</xsl:if>
																	<xsl:if test="$porcEvalEed or $porcEvalEet or $porcEvalEo or $porcEvalRp or $porcEvalTi or $porcEvalTg or $porcEvalEt or $porcEvalOtros or $porcEvalLibre">
																		<li><xsl:value-of select="languageUtil:get($locale,'ehu.xsl-content.grado.sistema.herramientas')"/>
																			<ul>
																				<xsl:if test="$porcEvalEed"><li><xsl:value-of select="languageUtil:get($locale,'ehu.xsl-content.grado.sistema.prueba.escrita')"/> (%): <xsl:value-of select="$porcEvalEed" /></li></xsl:if>
																				<xsl:if test="$porcEvalEet"><li><xsl:value-of select="languageUtil:get($locale,'ehu.xsl-content.grado.sistema.prueba.test')"/> (%): <xsl:value-of select="$porcEvalEet" /></li></xsl:if>
																				<xsl:if test="$porcEvalEo"><li><xsl:value-of select="languageUtil:get($locale,'ehu.xsl-content.grado.sistema.prueba.oral')"/> (%): <xsl:value-of select="$porcEvalEo" /></li></xsl:if>
																				<xsl:if test="$porcEvalRp"><li><xsl:value-of select="languageUtil:get($locale,'ehu.xsl-content.grado.sistema.prueba.practicas')"/> (%): <xsl:value-of select="$porcEvalRp" /></li></xsl:if>
																				<xsl:if test="$porcEvalTi"><li><xsl:value-of select="languageUtil:get($locale,'ehu.xsl-content.grado.sistema.prueba.individual')"/> (%): <xsl:value-of select="$porcEvalTi" /></li></xsl:if>
																				<xsl:if test="$porcEvalTg"><li><xsl:value-of select="languageUtil:get($locale,'ehu.xsl-content.grado.sistema.prueba.grupal')"/> (%): <xsl:value-of select="$porcEvalTg" /></li></xsl:if>	
																				<xsl:if test="$porcEvalEt"><li><xsl:value-of select="languageUtil:get($locale,'ehu.xsl-content.grado.sistema.prueba.exposicion')"/> (%): <xsl:value-of select="$porcEvalEt" /></li></xsl:if>	
																				<xsl:if test="$porcEvalOtros"><li><xsl:value-of select="languageUtil:get($locale,'ehu.xsl-content.grado.sistema.prueba.portfolio')"/> (%): <xsl:value-of select="$porcEvalOtros" /></li></xsl:if>	
																				<xsl:if test="$porcEvalLibre"><li><xsl:value-of select="$evalLibre"/> (%): <xsl:value-of select="$porcEvalLibre"/></li></xsl:if>
																			
																			</ul>
																		</li>
																	</xsl:if>
																</ul>
															</div>	
														</xsl:if>
														<xsl:if test="$infoEvaluaAsignatura != $void">
															<h3>
																<xsl:attribute name="class">header2 toggler-header-collapsed toggler-header</xsl:attribute>
																<xsl:value-of select="languageUtil:get($locale,'ehu.xsl-content.grado.sistema.ordinaria')"/>
															
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
																<xsl:call-template name="label-value-without-title">
																	<xsl:with-param name="value" select="$infoEvaluaAsignatura"/>
																</xsl:call-template>													
															</div>
															
														</xsl:if>
														
														
														
														<xsl:if test="$infoEvaluaExtra != $void">
															<h3>
																<xsl:attribute name="class">header2 toggler-header-collapsed toggler-header</xsl:attribute>
																<xsl:value-of select="languageUtil:get($locale,'ehu.xsl-content.grado.sistema.extraordina')"/>
															
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
																<xsl:call-template name="label-value-without-title">
																	<xsl:with-param name="value" select="$infoEvaluaExtra"/>
																</xsl:call-template>													
															</div>
															
														</xsl:if>
														
														<xsl:if test="$materialObligAsignatura != $void">
															<h3>
																<xsl:attribute name="class">header2 toggler-header-collapsed toggler-header</xsl:attribute>
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
																<xsl:call-template name="label-value-without-title">
																	<xsl:with-param name="value" select="$materialObligAsignatura"/>
																</xsl:call-template>
															</div>
															
															
														</xsl:if>
														
														<xsl:if test="$biblioBasicAsignatura != $void or $biblioProfunAsignatura != $void or $revistasAsignatura != $void or $urlsAsignatura != $void">
															<h3>
																<xsl:attribute name="class">header2 toggler-header-collapsed toggler-header</xsl:attribute>
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
																	<xsl:call-template name="label-value-without-title">
																		<xsl:with-param name="value" select="$biblioBasicAsignatura"/>
																	</xsl:call-template>
																</xsl:if>
																
																<xsl:if test="$biblioProfunAsignatura != $void">
																	<xsl:call-template name="header_third">
																		<xsl:with-param name="title" select="languageUtil:get($locale,'ehu.biblioProfun')"/>
																	</xsl:call-template>
																	<xsl:call-template name="label-value-without-title">
																		<xsl:with-param name="value" select="$biblioProfunAsignatura"/>
																	</xsl:call-template>														
																</xsl:if>
																
																<xsl:if test="$revistasAsignatura != $void">
																	<xsl:call-template name="header_third">
																		<xsl:with-param name="title" select="languageUtil:get($locale,'ehu.revistas')"/>
																	</xsl:call-template>
																	<xsl:call-template name="label-value-without-title">
																		<xsl:with-param name="value" select="$revistasAsignatura"/>
																	</xsl:call-template>														
																</xsl:if>
																
																<xsl:if test="$urlsAsignatura != $void">
																	<xsl:call-template name="header_third">
																		<xsl:with-param name="title" select="languageUtil:get($locale,'ehu.urls')"/>
																	</xsl:call-template>
																	<xsl:call-template name="label-value-without-title">
																		<xsl:with-param name="value" select="$urlsAsignatura"/>
																	</xsl:call-template>														
																</xsl:if>
															</div>
														</xsl:if>
													</div>
												</div>
										<!--  miembros del tribunal -->
										<xsl:if test="$miembrosTribunalAsignatura != $void">
										
											<h2>
												<xsl:attribute name="class">header toggler-header-collapsed toggler-header</xsl:attribute>
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
												<xsl:attribute name="class">header toggler-header-collapsed toggler-header</xsl:attribute>
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
								</div>
							</div>
							</xsl:if>	
						</xsl:when>
						
						<xsl:when test="not($p_cod_asignatura) and ($p_idp) and $p_anyo_acad">
							<xsl:if test="ehu:app/ehu:profesor">
								<div class="m-b-30">
     							<div class="bg-white p-20">
							
								<dl>
									<dt><xsl:value-of select="languageUtil:get($locale,'ehu.departamento')"/></dt>
									<dd><xsl:value-of select="$desDptoProfesor"/></dd>
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
 								<xsl:element name="ul">
									<xsl:attribute name="class">list-icons</xsl:attribute>
									<xsl:element name="li">
										<xsl:attribute name="class">linkplus</xsl:attribute>
										<xsl:element name="a">
											<xsl:attribute name="class">bullet bullet-url</xsl:attribute>
											<xsl:attribute name="href">?p_redirect=fichaPDI&amp;p_idp=<xsl:value-of select="$p_idp"/>
											</xsl:attribute>
											<xsl:value-of select="languageUtil:get($locale,'upv-ehu.masters.pdi')"/>
										</xsl:element>
									</xsl:element>
								</xsl:element>
								</div>
								</div>
							</xsl:if>		
							<xsl:call-template name="profesor-tutorias">												
								<xsl:with-param name="tutorias" select="$tutoriasProfesor"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<h1><xsl:value-of select="languageUtil:get($locale,'ehu.profesorado')"/></h1>
							<xsl:call-template name="fichaPDI">
						    	<xsl:with-param name="urlBack">javascript:window.location.replace(location.pathname);</xsl:with-param>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<!-- Profesorado -->
				<xsl:when test="$p_nav = '50'">
					<xsl:choose>
						<xsl:when test="not($p_idp)">
						<xsl:call-template name="graduate-profesorado">	
							<xsl:with-param name="profesorado" select="$profesorado"/>
								<xsl:with-param name="anyoAcad" select="$anyoAcad"/>								
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="$p_idp and $p_anyo_acad">
							<xsl:if test="ehu:app/ehu:profesor">
							<div class="m-b-30">
     							<div class="bg-white p-20">
							
								<dl>
									<dt><xsl:value-of select="languageUtil:get($locale,'ehu.departamento')"/></dt>
									<dd><xsl:value-of select="$desDptoProfesor"/></dd>
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
								<xsl:element name="ul">
									<xsl:attribute name="class">list-icons</xsl:attribute>
									<xsl:element name="li">
										<xsl:attribute name="class">linkplus</xsl:attribute>
										<xsl:element name="a">
											<xsl:attribute name="class">bullet bullet-url</xsl:attribute>
											<xsl:attribute name="href">?p_redirect=fichaPDI&amp;p_idp=<xsl:value-of select="$p_idp"/>
											</xsl:attribute>
											<xsl:value-of select="languageUtil:get($locale,'upv-ehu.masters.pdi')"/>
										</xsl:element>
									</xsl:element>
								</xsl:element>
								</div>
								</div>
							</xsl:if>		
							<xsl:call-template name="profesor-tutorias">												
								<xsl:with-param name="tutorias" select="$tutoriasProfesor"/>
							</xsl:call-template>	
						</xsl:when>
						<xsl:otherwise>
							<h1><xsl:value-of select="languageUtil:get($locale,'ehu.profesorado')"/></h1>
							<xsl:call-template name="fichaPDI">
						    	<xsl:with-param name="urlBack">javascript:window.location.replace(location.pathname);</xsl:with-param>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>	
				</xsl:when>
						
				<!-- Competencias  -->
				<xsl:when test="$p_nav = '60'">
					<xsl:call-template name="competencias">
						<xsl:with-param name="competencias" select="$competencias" />
					</xsl:call-template>			
				</xsl:when>
				<!-- Recursos -->
				<xsl:when test="$p_nav = '70'">
					<xsl:if test="$hayVerificacion='1'">
						 <xsl:call-template name="verificacion">
							<xsl:with-param name="documentos" select="$documentos"/>							
						</xsl:call-template>
						<xsl:call-template name="seguimiento">
							<xsl:with-param name="documentos" select="$documentos"/>
							<xsl:with-param name="anyoAcad" select="$anyoAcad"/>
						</xsl:call-template>	
						<xsl:call-template name="acreditacion">
							<xsl:with-param name="documentos" select="$documentos"/>
						</xsl:call-template>											
					</xsl:if>	
				</xsl:when>
				<xsl:when test="$p_nav = '80'">
					<xsl:call-template name="requisitosObtencion">
						<xsl:with-param name="graduate" select="$grado" />
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>						
					<xsl:call-template name="xml_error"/>						
				</xsl:otherwise>
			</xsl:choose>
		</div>

		<xsl:text disable-output-escaping="yes"> 
			<![CDATA[    
				  
				<script type="text/javascript"> 
					function enClick(idButton){if(document.getElementById(idButton.id).getAttribute('aria-expanded')=='true'){document.getElementById(idButton.attributes.getNamedItem("aria-describedby").value).style.visibility = 'visible';document.getElementById(idButton.id).setAttribute('aria-expanded', 'false');} else {document.getElementById(idButton.attributes.getNamedItem("aria-describedby").value).style.visibility = 'visible';document.getElementById(idButton.id).setAttribute('aria-expanded', 'true');};}
					function enMouseOverOFocus(idButton){document.getElementById(idButton.attributes.getNamedItem("aria-describedby").value).style.visibility = 'visible'; document.getElementById(idButton.id).setAttribute('aria-expanded', 'true');}
					function enMouseOutOBlur(idButton){document.getElementById(idButton.attributes.getNamedItem("aria-describedby").value).style.visibility = 'hidden'; document.getElementById(idButton.id).setAttribute('aria-expanded', 'false');}
					function enKeyDown(event , idButton){if(event.keyCode==27){document.getElementById(idButton.attributes.getNamedItem("aria-describedby").value).style.visibility = 'hidden'; document.getElementById(idButton.id).setAttribute('aria-expanded', 'false');}}
				</script> 
			]]>
		</xsl:text>
	</xsl:template>

	<!-- Resumen de grados -->
	<xsl:template name="summary-graduate">
		<xsl:param name="graduate" />
		<xsl:if test="($graduate)">
		
			<div>
				<xsl:attribute name="class">grado-datos bg-grey p-20</xsl:attribute>

				
				<xsl:call-template name="encabezadosPStrong" >
					<xsl:with-param name="textoValor" select="languageUtil:get($locale,'ehu.knowledge-rama')" />
				</xsl:call-template>	
				<xsl:element name="p">
					<xsl:value-of select="$graduate/ehu:desCampoCientifico" />
				</xsl:element>
				<xsl:call-template name="encabezadosPStrong" >
					<xsl:with-param name="textoValor" select="languageUtil:get($locale,'ehu.teaching-center')" />
				</xsl:call-template>
				<xsl:element name="p">
					<xsl:choose>
					     <xsl:when test="$graduate/ehu:lugarImparticion/ehu:contacto/ehu:web">
						     		<xsl:element name="a">
										<xsl:attribute name="href"><xsl:value-of select="$graduate/ehu:lugarImparticion/ehu:contacto/ehu:web" /></xsl:attribute>
											<xsl:value-of select="$graduate/ehu:desCentro" />
									</xsl:element>
					     </xsl:when>
					     <xsl:otherwise>
					   		 <xsl:value-of select="$graduate/ehu:desCentro" />
					     </xsl:otherwise>
					   </xsl:choose>
				</xsl:element>
						
				<!-- Campus -->						
				<xsl:call-template name="encabezadosPStrong" >
					<xsl:with-param name="textoValor" select="languageUtil:get($locale,'ehu.campus')" />
				</xsl:call-template>
				<xsl:if test="($graduate/ehu:desCampus or $graduate/ehu:desCampus=$void)">		
					<xsl:element name="p">
						<xsl:value-of select="$graduate/ehu:desCampus" />
					</xsl:element>
				</xsl:if>
				
				<!-- Contacto -->
				<xsl:call-template name="encabezadosPStrong" >
					<xsl:with-param name="textoValor" select="languageUtil:get($locale,'ehu.contacto')" />
				</xsl:call-template>
				<xsl:if test="($graduate/ehu:infAcademica/ehu:contacto/ehu:mail or $graduate/ehu:infAcademica/ehu:contacto/ehu:mail=$void)">
					<xsl:element name="p">
						<xsl:element name="a">
							<xsl:attribute name="href">mailto:<xsl:value-of
								select="$graduate/ehu:infAcademica/ehu:contacto/ehu:mail" /></xsl:attribute>
							<xsl:value-of select="$graduate/ehu:infAcademica/ehu:contacto/ehu:mail" />
						</xsl:element>
					</xsl:element>
				</xsl:if>
				
				<!-- Duracion -->
				<xsl:call-template name="encabezadosPStrong" >
					<xsl:with-param name="textoValor" select="languageUtil:get($locale,'ehu.duration')" />
				</xsl:call-template>
				<xsl:if test="($graduate/ehu:duracion)">	
					<xsl:element name="p">
						<xsl:value-of select="$graduate/ehu:duracion" />
						<xsl:value-of select="$white_space" />
						<xsl:value-of select="languageUtil:get($locale,'ehu.xsl-content.grado.cursos')" />
					</xsl:element>
				</xsl:if>
				
				<!--total creditos  -->				
				<xsl:call-template name="encabezadosPStrong" >
					<xsl:with-param name="textoValor" select="languageUtil:get($locale,'ehu.number-of-credits')" />
				</xsl:call-template>
				<xsl:if test="($graduate/ehu:creditos/ehu:lineaCreditos[contains(ehu:curso,'Total')]  or 
					  ($graduate/ehu:creditos/ehu:lineaCreditos[contains(ehu:curso,'Guztira')]))">		
					<xsl:for-each select="$graduate/ehu:creditos/ehu:lineaCreditos">
						<xsl:if test="contains(ehu:curso,'Guztira') or contains(ehu:curso,'Total')">
							<xsl:element name="p">
								<xsl:value-of select="format-number(ehu:credTotCurso,'###')"/>
								<xsl:value-of select="$white_space" />
								<!-- Pintamos el orden del título según el idioma -->
								<!-- Euskera & English -->
								<xsl:if test="(languageUtil:getLanguageId($locale) = 'eu_ES') or (languageUtil:getLanguageId($locale) = 'en_GB')">
									<xsl:call-template name="ects" />
									<xsl:value-of select="$white_space" />
									<xsl:value-of select="languageUtil:get($locale,'ehu.xsl-content.grado.credit')" />
								</xsl:if>
								<!-- Castellano & Francais -->
								<xsl:if test="(languageUtil:getLanguageId($locale) = 'es_ES') or (languageUtil:getLanguageId($locale) = 'fr_FR')">
									<xsl:value-of select="languageUtil:get($locale,'ehu.xsl-content.grado.credit')" />
									<xsl:value-of select="$white_space" />
									<xsl:call-template name="ects" />								
								</xsl:if>
								
							</xsl:element>
						</xsl:if>
					</xsl:for-each>				
				</xsl:if>
				
				<!--Idiomas-->
				<xsl:call-template name="encabezadosPStrong" >
					<xsl:with-param name="textoValor" select="languageUtil:get($locale,'ehu.idiomas')" />
				</xsl:call-template>					
				<xsl:if test="($graduate/ehu:idiomas/ehu:idioma or $graduate/ehu:idiomas/ehu:idioma=$void)">	
					<xsl:element name="p">
						<xsl:for-each select="$graduate/ehu:idiomas/ehu:idioma">
							<xsl:value-of select="ehu:descIdiomaImpart" /><xsl:if test="position() != last()">,<xsl:value-of select="$white_space" />
							</xsl:if>
						</xsl:for-each>
					</xsl:element>
				</xsl:if>
				
				<!--Tipo Ensenanza-->
				<xsl:call-template name="encabezadosPStrong" >
					<xsl:with-param name="textoValor" select="languageUtil:get($locale,'ehu.study-type')" />
				</xsl:call-template>
				<xsl:if test="($graduate/ehu:descTipoEnsenanza or $graduate/ehu:descTipoEnsenanza=$void)">	
					 <xsl:call-template name="CamelCase">
   									<xsl:with-param name="text"><xsl:value-of select="ehu:nombre" /></xsl:with-param>
					</xsl:call-template> 
					
					<xsl:element name="p">
						<xsl:call-template name="cap-first">
   							<xsl:with-param name="s"><xsl:value-of select="$graduate/ehu:descTipoEnsenanza" /></xsl:with-param>
						</xsl:call-template> 
					</xsl:element>
				</xsl:if>

				<!-- Precio-->
				<xsl:call-template name="encabezadosPStrong" >
					<xsl:with-param name="textoValor" select="languageUtil:get($locale,'ehu.precioPorCredito')" />
				</xsl:call-template>
				<xsl:if test="($graduate/ehu:precios/ehu:precio[contains(ehu:tipo,'ACAD')])">
					<xsl:for-each select="$graduate/ehu:precios/ehu:precio">
						<xsl:if test="contains(ehu:tipo,'ACAD') and contains(ehu:vecesMatricula,'1')">
						<!--   <xsl:variable name="preciosResumen" select="$graduate/ehu:precios/ehu:precio"/>-->
							
							 <xsl:variable name="preciosResumen" select="ehu:precio"/>
							<xsl:element name="p">
							 <xsl:value-of select="format-number($preciosResumen, '###.###,00','european')" /><xsl:value-of select="$white_space" /><xsl:value-of select="$euro" />
							 </xsl:element>
						</xsl:if>
					</xsl:for-each>
				</xsl:if>

				<!-- Nota corte-->
				<xsl:call-template name="encabezadosPStrong" >
					<xsl:with-param name="textoValor" select="languageUtil:get($locale,'ehu.notaCorte')" />
				</xsl:call-template>
				<xsl:if test="($graduate/ehu:notaCorte or $graduate/ehu:notaCorte=$void)">
					<xsl:element name="p">
						<xsl:value-of select="$graduate/ehu:notaCorte" /><xsl:value-of select="$white_space" />(<xsl:value-of select="$graduate/ehu:desAnyoAcad" />)
					</xsl:element>
				</xsl:if>

				<!-- Plazas-->
				<xsl:call-template name="encabezadosPStrong" >
					<xsl:with-param name="textoValor" select="languageUtil:get($locale,'ehu.plazasOfertadas')" />
				</xsl:call-template>
				<xsl:if test="($graduate/ehu:pzasOfertadas or $graduate/ehu:pzasOfertadas=$void)">
					<xsl:element name="p">
						<xsl:value-of select="$graduate/ehu:pzasOfertadas" />
					</xsl:element>
				</xsl:if>
			</div>
		</xsl:if>
	</xsl:template>
	
	
	<!-- Precios de grados -->
	<xsl:template name="precios-graduate">
		<xsl:param name="graduate" />
		<xsl:if test="($graduate)">
		<div>
			<xsl:element name="div">
			<xsl:attribute name="class">bg-white p-20</xsl:attribute>
				<xsl:call-template name="header_main">
					<xsl:with-param name="title" select="languageUtil:get($locale,'ehu.xsl-content.grado.precio.tituto')"/>
				</xsl:call-template>
				<xsl:element name="p">
					<xsl:call-template name="string-replace-all" >
							<xsl:with-param name="text" select="languageUtil:get($locale,'ehu.xsl-content.grado.precio.texto1')"/>
							<xsl:with-param name="replace" select="'{0}'" />
							<xsl:with-param name="by" select="$desPlan" />
					</xsl:call-template>
				</xsl:element>
			
				
				<xsl:element name="p">
					<xsl:element name="strong">
						<xsl:value-of select="languageUtil:get($locale,'ehu.xsl-content.grado.precio.credito.ects')" /><xsl:value-of select="$two_points"/><xsl:value-of select="$white_space" />
					</xsl:element>
					<xsl:if test="($graduate/ehu:precios/ehu:precio[contains(ehu:tipo,'ACAD')])">
						<xsl:for-each select="$graduate/ehu:precios/ehu:precio">
							<xsl:if test="contains(ehu:tipo,'ACAD') and contains(ehu:vecesMatricula,'1')">
								<xsl:variable name="precioPrimera" select="ehu:precio"/>
								 <xsl:value-of select="format-number($precioPrimera, '###.###,00','european')" /><xsl:value-of select="$white_space" /><xsl:value-of select="$euro" />
							</xsl:if>
						</xsl:for-each>

					</xsl:if> 
				</xsl:element>
				
				
				<p><xsl:value-of select="languageUtil:get($locale,'ehu.xsl-content.grado.precio.ects')" /></p>
				
				<p><strong><xsl:value-of select="languageUtil:get($locale,'ehu.xsl-content.grado.precio.abonar')" /><xsl:value-of select="$two_points"/></strong></p>
				<xsl:if test="($graduate/ehu:precios/ehu:precio[contains(ehu:tipo,'ADMIN')])">
					<ul>
						<xsl:for-each select="$graduate/ehu:precios/ehu:precio">
							<xsl:if test="contains(ehu:tipo,'ADMIN')">
							<xsl:variable name="precios" select="ehu:precio"/>
								<li><xsl:value-of select="ehu:concepto" />: <xsl:value-of select="format-number($precios, '###.###,00','european')" /><xsl:value-of select="$white_space" /><xsl:value-of select="$euro" /></li>
							</xsl:if>
						</xsl:for-each>
					</ul>
				</xsl:if>
				
				<xsl:if test="($graduate/ehu:formasPago/ehu:formaPago)">
					<p><strong><xsl:value-of select="languageUtil:get($locale,'ehu.xsl-content.grado.precio.modalidades')" /><xsl:value-of select="$two_points"/></strong></p>
					<ul>
							<xsl:for-each select="$graduate/ehu:formasPago/ehu:formaPago">
							<xsl:variable name="plazo">
								<xsl:value-of select="ehu:maximoPlazo"/>
												
							</xsl:variable>
							<li><xsl:value-of select="ehu:descripcion" /> (<xsl:call-template name="string-replace-all" >
							<xsl:with-param name="text" select="languageUtil:get($locale,'ehu.plazos')"/>
							<xsl:with-param name="replace" select="'{0}'" />
							<xsl:with-param name="by" select="$plazo" /></xsl:call-template>) </li>
							</xsl:for-each>
					</ul>
				</xsl:if>
			</xsl:element>
		</div>
		</xsl:if>
		
	</xsl:template>
	

<!-- Creditos -->
	<xsl:template name="creditos">
		<xsl:param name="graduate" />
		<xsl:if test="($graduate)">
			<h1><xsl:value-of select="languageUtil:get($locale,'ehu.xsl-content.grado.planestudio')" /></h1>
			<xsl:element name="div">
			<xsl:attribute name="class">m-b-30</xsl:attribute>
					<xsl:element name="div">
					<xsl:attribute name="class">bg-white</xsl:attribute> 
							<xsl:element name="h2">
								<xsl:attribute name="class">p-20</xsl:attribute> 
    							<xsl:value-of select="languageUtil:get($locale,'ehu.xsl-content.grado.titulo.credito')" />
    						</xsl:element>
    							<xsl:element name="div">
	    							<xsl:attribute name="class">upv-tabla table-responsive m-b-60</xsl:attribute> 
	    							<xsl:element name="table">
	    								<xsl:attribute name="class">table</xsl:attribute> 
	    								<xsl:element name="caption">
									      <xsl:value-of select="languageUtil:get($locale,'ehu.xsl-content.grado.titulo.credito.asignaturasdelgrado')" /></xsl:element>
									    
											<xsl:element name="thead">
								    		<xsl:element name="tr">
								    		    	<xsl:element name="th">
								    		    		<xsl:element name="strong">
								    		    			<xsl:value-of select="languageUtil:get($locale,'ehu.year')" />
								    		    		</xsl:element>
								    		    	</xsl:element>
								    		    	
								    		    	<xsl:element name="th">
								    		    			<xsl:value-of select="languageUtil:get($locale,'ehu.obligatorias')" />
								    		    	</xsl:element>
								    		    	
								    		    	<xsl:element name="th">
								    		    			<xsl:value-of select="languageUtil:get($locale,'ehu.xsl-content.grado.titulo.credito.basicaRama')" />
								    		    	</xsl:element>
								    		    	
								    		    	<xsl:element name="th">
								    		    			<xsl:value-of select="languageUtil:get($locale,'ehu.xsl-content.grado.titulo.credito.basicaOtroRama')" />
								    		    	</xsl:element>
								    		    	
								    		    	<xsl:element name="th">
								    		    			<xsl:value-of select="languageUtil:get($locale,'ehu.xsl-content.grado.titulo.credito.optativas')" />
								    		    	</xsl:element>
								    		    	
								    		    	<xsl:element name="th">
								    		    		<xsl:value-of select="languageUtil:get($locale,'ehu.xsl-content.grado.titulo.credito.tfg')" />
								    		    	</xsl:element>
								    		    	
								    		    	<xsl:element name="th">
								    		    		<xsl:value-of select="languageUtil:get($locale,'ehu.total')" />
								    		    	</xsl:element>
								        		</xsl:element>
							      			</xsl:element>
							      			<xsl:element name="tbody">
							      				
							      				
												
												<xsl:value-of select="ehu:curso" />
													
												<xsl:if test="(not($p_cod_plan = $void) and $p_cod_plan ='GLETRA10' )  ">
													<xsl:for-each select="$cursos/ehu:curso[not(position() >4)]">													
													<!--xsl:for-each select="$cursos/ehu:curso"-->
														<!-- En la tabla resumen de créditos y asignatura no pintamos el curso X de asignaturas optativas -->
														<xsl:if test="(not(ehu:curso ='X') )">
															<xsl:element name="tr">
																<xsl:element name="th">
																	<xsl:value-of select="ehu:curso" />
																</xsl:element>
																<xsl:element name="td">
																	<xsl:call-template name="valor-guiones">
																			<xsl:with-param name="valor" select="ehu:credOblig" />
																	</xsl:call-template>
																</xsl:element>
																<xsl:element name="td">		
																	<xsl:call-template name="valor-guiones">
																			<xsl:with-param name="valor" select="ehu:credRama" />
																	</xsl:call-template>													
																</xsl:element>
																<xsl:element name="td">		
																	<xsl:call-template name="valor-guiones">
																			<xsl:with-param name="valor" select="ehu:credOtraRama" />
																	</xsl:call-template>													
																</xsl:element>
																<xsl:element name="td">
																	<xsl:call-template name="valor-guiones">
																			<xsl:with-param name="valor" select="ehu:credOpta" />
																	</xsl:call-template>	
																</xsl:element>
																<xsl:element name="td">		
																	<xsl:call-template name="valor-guiones">
																			<xsl:with-param name="valor" select="ehu:credFinGrado" />
																	</xsl:call-template>														
																</xsl:element>
																<xsl:element name="td">
																	<xsl:call-template name="valor-guiones">
																		<xsl:with-param name="valor" select="ehu:credOblig+ ehu:credRama+ehu:credOtraRama+ehu:credOpta+ehu:credFinGrado" />
																	</xsl:call-template>
																</xsl:element>
															</xsl:element>
														</xsl:if>
													</xsl:for-each>
												</xsl:if>
												
												
												<xsl:if test="(not($p_cod_plan ='GLETRA10') )  ">
													<!-- <xsl:for-each select="$cursos/ehu:curso[not(position() >5)]"> -->
													<xsl:for-each select="$cursos/ehu:curso">
														<!-- En la tabla resumen de créditos y asignatura no pintamos el curso X de asignaturas optativas -->
														<xsl:if test="(not(ehu:curso ='X') )">
															<xsl:element name="tr">
																<xsl:element name="th">
																	<xsl:value-of select="ehu:curso" />
																</xsl:element>
																<xsl:element name="td">
																	<xsl:call-template name="valor-guiones">
																			<xsl:with-param name="valor" select="ehu:credOblig" />
																	</xsl:call-template>
																</xsl:element>
																<xsl:element name="td">		
																	<xsl:call-template name="valor-guiones">
																			<xsl:with-param name="valor" select="ehu:credRama" />
																	</xsl:call-template>													
																</xsl:element>
																<xsl:element name="td">		
																	<xsl:call-template name="valor-guiones">
																			<xsl:with-param name="valor" select="ehu:credOtraRama" />
																	</xsl:call-template>													
																</xsl:element>
																<xsl:element name="td">
																	<xsl:call-template name="valor-guiones">
																			<xsl:with-param name="valor" select="ehu:credOpta" />
																	</xsl:call-template>	
																</xsl:element>
																<xsl:element name="td">		
																	<xsl:call-template name="valor-guiones">
																			<xsl:with-param name="valor" select="ehu:credFinGrado" />
																	</xsl:call-template>														
																</xsl:element>
																<xsl:element name="td">
																	<xsl:call-template name="valor-guiones">
																		<xsl:with-param name="valor" select="ehu:credOblig+ ehu:credRama+ehu:credOtraRama+ehu:credOpta+ehu:credFinGrado" />
																	</xsl:call-template>
																</xsl:element>
															</xsl:element>
														</xsl:if>
													</xsl:for-each>
												</xsl:if>	
													
								      		
												<!-- Línea de totales -->
												<tr class="destacada">
													<th>
														<xsl:value-of select="languageUtil:get($locale,'total')" />
													</th>
													<xsl:if test="(not($p_cod_plan = $void) and $p_cod_plan ='GLETRA10' )  ">
														<td>
															<xsl:call-template name="valor-guiones">
																<xsl:with-param name="valor" select="sum($cursos/ehu:curso[not(position() >4)]/ehu:credOblig)" /> 
																<!-- xsl:with-param name="valor" select="sum($cursos/ehu:curso/ehu:credOblig)" / -->
															</xsl:call-template>
														</td>
														<td>
															<xsl:call-template name="valor-guiones">
																<xsl:with-param name="valor" select="sum($cursos/ehu:curso[not(position() >4)]/ehu:credRama)" /> 
																<!--  xsl:with-param name="valor" select="sum($cursos/ehu:curso/ehu:credRama)" / -->
															</xsl:call-template>
														</td>
														<td>
															<xsl:call-template name="valor-guiones">
																<xsl:with-param name="valor" select="sum($cursos/ehu:curso[not(position() >4)]/ehu:credOtraRama)" /> 
																<!-- xsl:with-param name="valor" select="sum($cursos/ehu:curso/ehu:credOtraRama)" / -->
															</xsl:call-template>
														</td>
														<td>
															<xsl:call-template name="valor-guiones">
																<xsl:with-param name="valor" select="sum($cursos/ehu:curso[not(position() >4)]/ehu:credOpta)" /> 
																<!-- xsl:with-param name="valor" select="sum($cursos/ehu:curso/ehu:credOpta)" / -->
															</xsl:call-template>
														</td>
														<td>
															<xsl:call-template name="valor-guiones">
																<xsl:with-param name="valor" select="sum($cursos/ehu:curso[not(position() >4)]/ehu:credFinGrado)" /> 
																<!--xsl:with-param name="valor" select="sum($cursos/ehu:curso/ehu:credFinGrado)" / -->
															</xsl:call-template>
														</td>
														<td>
															<xsl:call-template name="valor-guiones">
																<xsl:with-param name="valor" select="sum($cursos/ehu:curso[not(position() >4)]/ehu:credOblig) +sum($cursos/ehu:curso[not(position() >4)]/ehu:credRama)+ sum($cursos/ehu:curso[not(position() >4)]/ehu:credOtraRama) + sum($cursos/ehu:curso[not(position() >4)]/ehu:credOpta)+ sum($cursos/ehu:curso[not(position() >4)]/ehu:credFinGrado)" /> 
																<!--xsl:with-param name="valor" select="sum($cursos/ehu:curso/ehu:credOblig) +sum($cursos/ehu:curso/ehu:credRama)+ sum($cursos/ehu:curso/ehu:credOtraRama) + sum($cursos/ehu:curso/ehu:credOpta)+ sum($cursos/ehu:curso/ehu:credFinGrado)" / -->
															</xsl:call-template>
														</td>
													</xsl:if>
												<xsl:if test="(not($p_cod_plan ='GLETRA10') )  ">
														<td>
															<xsl:call-template name="valor-guiones">
																<xsl:with-param name="valor" select="sum($cursos/ehu:curso/ehu:credOblig)" />
															</xsl:call-template>
														</td>
														<td>
															<xsl:call-template name="valor-guiones">
																<xsl:with-param name="valor" select="sum($cursos/ehu:curso/ehu:credRama)" />
															</xsl:call-template>
														</td>
														<td>
															<xsl:call-template name="valor-guiones">
																<xsl:with-param name="valor" select="sum($cursos/ehu:curso/ehu:credOtraRama)" />
															</xsl:call-template>
														</td>
														<td>
															<xsl:call-template name="valor-guiones">
																<xsl:with-param name="valor" select="sum($cursos/ehu:curso/ehu:credOpta)" />
															</xsl:call-template>
														</td>
														<td>
															<xsl:call-template name="valor-guiones">
																<xsl:with-param name="valor" select="sum($cursos/ehu:curso/ehu:credFinGrado)" />
															</xsl:call-template>															
														</td>
														<td>
															<xsl:call-template name="valor-guiones">
																<xsl:with-param name="valor" select="sum($cursos/ehu:curso/ehu:credOblig) +sum($cursos/ehu:curso/ehu:credRama)+ sum($cursos/ehu:curso/ehu:credOtraRama) + sum($cursos/ehu:curso/ehu:credOpta)+ sum($cursos/ehu:curso/ehu:credFinGrado)" />
															</xsl:call-template>
														</td>
													</xsl:if>
												</tr>
									     </xsl:element>
						    		</xsl:element>	
								</xsl:element>
    				</xsl:element>
				</xsl:element>
				
				<div>
    				<div class="bg-white">
    	<!-- ACCORDION si se cambia selector por el id del acordeón (accordion1) se plegaría desplegaría al pinchar en unos y otros -->
    					<div class="upv-acordeon accordion" id="accordion2">
    						<xsl:for-each select="$cursos/ehu:curso">
    							<xsl:variable name="numeroAcordeon" select="position()" />
    							<xsl:variable name="cursoNumCurso" select="ehu:curso" />
    							<xsl:variable name="previous_curso" select="preceding-sibling::*[1]/ehu:curso" />
    							<div class="accordion-group">
    								<xsl:element name="div">
										<xsl:attribute name="class">accordion-heading</xsl:attribute>
										<a data-toggle="collapse" data-parent="#selector">
											<xsl:attribute name="class">accordion-toggle</xsl:attribute> 
											<xsl:if test="($previous_curso != $void)  ">
												<xsl:attribute name="class">accordion-toggle collapsed</xsl:attribute> 
											</xsl:if>
											
											<xsl:attribute name="href">#collapse<xsl:value-of select="$numeroAcordeon" /></xsl:attribute> 
											<span><xsl:value-of select="ehu:curso" /></span> <h2><xsl:value-of select="ehu:desCurso" /></h2></a>
									</xsl:element>
									<div>
										<xsl:if test="($previous_curso = $void)  ">
											<xsl:attribute name="class"> accordion-body collapse in</xsl:attribute> 
										</xsl:if>
										
										<xsl:if test="($previous_curso != $void)  ">
											<xsl:attribute name="class"> accordion-body collapse </xsl:attribute> 
										</xsl:if>
										
										<xsl:attribute name="id">collapse<xsl:value-of select="$numeroAcordeon" /></xsl:attribute> 
										<div class="accordion-inner">
											<div class="upv-tabla table-responsive">
				    							<xsl:variable name="cuatri_asigna_sorted_copy">
													<xsl:for-each select="ehu:asignaturas/ehu:asignatura">
														<xsl:sort select="ehu:duracion" />
															<xsl:copy-of select="current()"/>							        	
													</xsl:for-each>
												</xsl:variable>
												
												<xsl:variable name="cuatrimestre_sorted_node_set" select="exsl:node-set($cuatri_asigna_sorted_copy)/*" />
												<xsl:variable name="asignaturas_sorted_node_set" select="exsl:node-set($cuatri_asigna_sorted_copy)/*" />
												
												<xsl:for-each select="$cuatrimestre_sorted_node_set">													
													<xsl:variable name="cuatrimestreCurso" select="ehu:curso" />
													<xsl:variable name="cuatrimestreAct" select="ehu:duracion" />
													<xsl:variable name="cuatrimestreDesc" select="ehu:desDuracion" />
													
													<xsl:variable name="previous_cuatrimestre" select="preceding-sibling::*[1]/ehu:duracion" />
													<xsl:if test="$cursoNumCurso = $cuatrimestreCurso ">
														
														<xsl:if test="not($previous_cuatrimestre = $cuatrimestreAct)  ">
															
															<table class="table table-hover">
															<caption><xsl:value-of select="languageUtil:get($locale,'ehu.asignaturas')" /><xsl:value-of select="$white_space" /><xsl:value-of select="ehu:desDuracion"/></caption>
															<thead>
																<tr>
														          <th><strong><xsl:value-of select="$cuatrimestreDesc" /></strong></th>
														          <th class="text-center"><xsl:value-of select="languageUtil:get($locale,'ehu.credits')" /></th>
														          <th>
														          	<div class="upv-tooltip-container">
															          	<xsl:element name="button">
																          	<xsl:attribute name="id">button-mytooltip<xsl:value-of select="ehu:curso" />_<xsl:value-of select="$cuatrimestreAct" /></xsl:attribute>
																          	<xsl:attribute name="aria-label">Ayuda</xsl:attribute>
																          	<xsl:attribute name="aria-expanded">false</xsl:attribute>
																          	<xsl:attribute name="aria-describedby">mytooltip<xsl:value-of select="ehu:curso" />_<xsl:value-of select="$cuatrimestreAct" /></xsl:attribute>
																          	<xsl:attribute name="onclick">enClick(this);</xsl:attribute>
																          	<xsl:attribute name="onmouseover">enMouseOverOFocus(this);</xsl:attribute>
																          	<xsl:attribute name="onmouseout">enMouseOutOBlur(this);</xsl:attribute>
																          	<xsl:attribute name="onfocus">enMouseOverOFocus(this);</xsl:attribute>
																          	<xsl:attribute name="onblur">enMouseOutOBlur(this);</xsl:attribute>
																          	<xsl:attribute name="onkeydown">enKeyDown(event, this);</xsl:attribute>
																          	<xsl:attribute name="class">upv-tooltip-trigger</xsl:attribute>
																          	
																         	<xsl:value-of select="languageUtil:get($locale,'ehu.type')" />
														
																         	<xsl:call-template name="elemento_i"/>
														
															          	</xsl:element>
															          	
															          	<div role="tooltip" class="upv-tooltip bottom" style="visibility: hidden;">
															          	 	<xsl:attribute name="id">mytooltip<xsl:value-of select="ehu:curso" />_<xsl:value-of select="$cuatrimestreAct" /></xsl:attribute>
															          		<div class="upv-tooltip-inner">
															          		<p><strong><xsl:value-of select="languageUtil:get($locale,'ehu.basicaderama.literal')" /><xsl:value-of select="$two_points" /></strong> 
															          			<xsl:value-of select="languageUtil:get($locale,'ehu.basicaderama.ayuda.literal')" /></p>
															          		<p><strong><xsl:value-of select="languageUtil:get($locale,'ehu.basicadeotrarama.literal')" /><xsl:value-of select="$two_points" /></strong> 
															          			<xsl:value-of select="languageUtil:get($locale,'ehu.basicadeotrarama.ayuda.literal')" /></p>	
															          		<p><strong><xsl:value-of select="languageUtil:get($locale,'ehu.optativa.literal')" /><xsl:value-of select="$two_points" /></strong> 
															          			<xsl:value-of select="languageUtil:get($locale,'ehu.optativa.ayuda.literal')" /></p>
															          		<p><strong><xsl:value-of select="languageUtil:get($locale,'ehu.obligatoria.literal')" /><xsl:value-of select="$two_points" /></strong> 
															          			<xsl:value-of select="languageUtil:get($locale,'ehu.obligatoria.ayuda.literal')" /></p>
															          		</div>
															          	</div>
															        </div><!-- FIN tooltip container -->
														          </th>
														          <th><xsl:value-of select="languageUtil:get($locale,'ehu.idioma')" /></th>
														          <th><xsl:value-of select="languageUtil:get($locale,'ehu.prerrequisitos')" /></th>
									        					</tr>
									      					</thead>
														      <tbody>
														      	<xsl:for-each select="$asignaturas_sorted_node_set">
														      		<xsl:variable name="cursoNumAsig" select="ehu:curso" />
															      	<xsl:variable name="cursoAsigCuatri" select="ehu:duracion" />
															      	
															       	<xsl:variable name="anyoAcad" select="ehu:anyoAcad"/>
															      	<xsl:variable name="codCentro" select="ehu:codCentro"/>
																	<xsl:variable name="codPlan" select="ehu:codPlan"/>
																	<xsl:variable name="ciclo" select="ehu:ciclo"/>
																	<xsl:variable name="curso" select="ehu:curso"/>
																	<xsl:variable name="hayPrerrequisitos" select="ehu:hayPrerrequisitos"/>
																	<xsl:variable name="codAsignatura" select="ehu:codAsignatura"/>
																	
																	
															      	<xsl:if test="$cursoAsigCuatri= $cuatrimestreAct">
															      	<tr>
															      		<!-- Columna asignatura -->
															      		<th>
																          	<a>
																          		<xsl:attribute name="href">?p_redirect=consultaAsignatura&amp;p_cod_proceso=egr&amp;p_anyo_acad=<xsl:value-of select="$anyoAcad"/>&amp;p_ciclo=<xsl:value-of select="$ciclo"/>&amp;p_curso=<xsl:value-of select="$curso"/>&amp;p_cod_asignatura=<xsl:value-of select="$codAsignatura"/></xsl:attribute>
																          		<xsl:value-of select="ehu:desAsignatura"/>
																          		<xsl:if test="ehu:hayExtinguidas = '1'">
																          			<xsl:value-of select="$white_space"/>
																					<div class="upv-tooltip-container">
																						<xsl:element name="button">
																							<xsl:attribute name="id">button-mytooltip<xsl:value-of select="$numeroAcordeon" />_<xsl:value-of select="ehu:curso" />_<xsl:value-of select="$cuatrimestreAct" />_<xsl:value-of select="$codAsignatura" /></xsl:attribute>
																							<xsl:attribute name="aria-label"><xsl:value-of select="languageUtil:get($locale,'help')" /></xsl:attribute>
																							<xsl:attribute name="aria-expanded">false</xsl:attribute>
																							<xsl:attribute name="aria-describedby">mytooltip<xsl:value-of select="$numeroAcordeon" />_<xsl:value-of select="ehu:curso" />_<xsl:value-of select="$cuatrimestreAct" />_<xsl:value-of select="$codAsignatura"/></xsl:attribute>
																							<xsl:attribute name="onclick">enClick(this);</xsl:attribute>
																							<xsl:attribute name="onmouseover">enMouseOverOFocus(this);</xsl:attribute>
																							<xsl:attribute name="onmouseout">enMouseOutOBlur(this);</xsl:attribute>
																							<xsl:attribute name="onfocus">enMouseOverOFocus(this);</xsl:attribute>
																							<xsl:attribute name="onblur">enMouseOutOBlur(this);</xsl:attribute>
																							<xsl:attribute name="onkeydown">enKeyDown(event, this);</xsl:attribute>
																							<xsl:attribute name="class">upv-tooltip-trigger</xsl:attribute> 	
																							**
																						</xsl:element>
																						<div role="tooltip" class="upv-tooltip bottom" style="visibility: hidden;">
																							<xsl:attribute name="id">mytooltip<xsl:value-of select="$numeroAcordeon" />_<xsl:value-of select="ehu:curso" />_<xsl:value-of select="$cuatrimestreAct" />_<xsl:value-of select="$codAsignatura"/></xsl:attribute>
																							<div class="upv-tooltip-inner">
																								<p><xsl:value-of select="languageUtil:get($locale,'ehu.xsl-content.grado.no.impartir')" /></p>
																							</div>
																						</div>
																					</div><!-- FIN tooltip container -->
																          		</xsl:if>
																          	</a>
																     	</th>
																     	<!-- Columna creditos -->
																     	<td class="text-center"><xsl:call-template name="valor-guiones"><xsl:with-param name="valor" select="ehu:numCreditos" /></xsl:call-template></td>
																     	<!-- Columna tipo -->
															      	 	<td><xsl:value-of select="ehu:desClase"/></td>
															      	 	<!-- Columna idioma -->
																        <td>
																         	<xsl:for-each select="ehu:idiomas/ehu:idioma">
																				<xsl:value-of select="ehu:descIdiomaImpart" /><xsl:if test="position() != last()">,<xsl:value-of select="$white_space" /></xsl:if>
																			</xsl:for-each>
																        </td>
																        <!-- Columna Prerequisitos -->
															      		<td>
																           <xsl:if test="$hayPrerrequisitos = '1'">
																          	<div class="upv-tooltip-container">
																          		<xsl:value-of select="languageUtil:get($locale,'ehu.conprerequisitos.literal')" />
																          		<!-- <button id="button-mytooltip2" aria-label="Ayuda" aria-expanded="false" aria-describedby="mytooltip2" onclick="enClick(this)" onmouseover="enMouseOverOFocus(this);" onmouseout="enMouseOutOBlur(this);" onfocus="enMouseOverOFocus(this);" onblur="enMouseOutOBlur(this);" onkeydown="enKeyDown(event, this);" class="upv-tooltip-trigger">Con prerrequisitos <i class="fa fa-info-circle color-secondary" aria-hidden="true"></i></button>
																          		<div id="mytooltip2" role="tooltip" class="upv-tooltip left" style="visibility: hidden;">
																	          		<div class="upv-tooltip-inner">
																	          			<p><strong>Detalle de prerrequisito:</strong> 
																	          			Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor sit amet, consectetur adipiscing elit consectetur adipiscing.</p>
																	          		</div>
																          		</div> -->
																          	</div><!-- FIN tooltip container -->
																          	</xsl:if>
																          	 <xsl:if test="$hayPrerrequisitos = '0'">
																         		<xsl:value-of select="$white_space" />
																          	</xsl:if>
																          </td>
															      	</tr>
															      	</xsl:if>
														      	</xsl:for-each>
														      </tbody>
								   						 </table>
														</xsl:if>
													</xsl:if>
												</xsl:for-each>
											</div>
										</div>
									</div>
								</div>
    						</xsl:for-each>
    					</div>
    				</div>
				</div>
		</xsl:if>
	</xsl:template>
<!-- requisitosObtencion-->
<xsl:template name="requisitosObtencion">
		<xsl:param name="graduate" />
		<xsl:if test="($graduate)">
		
			<h1><xsl:value-of select="languageUtil:get($locale,'ehu.xsl-content.grado.planestudio')" /></h1>
			<xsl:element name="div">
			<xsl:attribute name="class">m-b-30</xsl:attribute>
					<xsl:element name="div">
					<xsl:attribute name="class">bg-white p-20</xsl:attribute> 
							<xsl:element name="h2">
								<xsl:attribute name="class">p-20</xsl:attribute> 
    							<xsl:value-of select="languageUtil:get($locale,'ehu.xsl-content.grado.otrosRequi.titulo')" />
    						</xsl:element>
    						<xsl:if test="($graduate/ehu:requisitosObtencion/ehu:restriccion[contains(ehu:tipo,'ESP')]) ">
    							
    								<xsl:element name="ul">
    									<xsl:for-each select="$graduate/ehu:requisitosObtencion/ehu:restriccion">
											<xsl:if test="contains(ehu:tipo,'ESP')">
													<xsl:element name="li">
														<xsl:value-of select="ehu:descripcion" disable-output-escaping="yes" />
													</xsl:element>
										</xsl:if>
									</xsl:for-each>
								</xsl:element>
					  			</xsl:if>
					</xsl:element>
					
					
			</xsl:element>
		</xsl:if>
</xsl:template>
	<!-- Menciones itinerarios -->
	<xsl:template name="menciones-itinerarios">
		<xsl:param name="lineasCurriculares" />
		
		<xsl:variable name="lineaMencion" select="$lineasCurriculares/ehu:lineaCurricular[ehu:tipo='M']" />
		<xsl:variable name="lineaItinerario" select="$lineasCurriculares/ehu:lineaCurricular[ehu:tipo='I']" />
		
		<h1><xsl:value-of select="languageUtil:get($locale,'ehu.menciones')" />	<xsl:value-of select="$white_space"/><xsl:value-of select="languageUtil:get($locale,'upv-ehu.nexo.eand')" /><xsl:value-of select="$white_space"/> <xsl:value-of select="languageUtil:get($locale,'ehu.itinerarios')" /></h1>
		<div>
			<xsl:attribute name="class">m-b-30</xsl:attribute>
			<div>
				<xsl:attribute name="class">bg-white p-20</xsl:attribute>
				
				<xsl:if test="$lineaMencion">
					<xsl:element name="h2">
						<xsl:value-of select="languageUtil:get($locale,'ehu.menciones')" />
					</xsl:element>
					
					<xsl:if test="$lineasCurriculares/@textoMenciones">
						<xsl:element name="p">
							<xsl:value-of select="$lineasCurriculares/@textoMenciones" disable-output-escaping="yes" />
						</xsl:element>
					</xsl:if>
					
					<!-- lineas curriculares ordenadas por tipo mencion/itinerario -->
					<xsl:variable name="lineas_curriculares_sorted_copy">
						<xsl:for-each select="$lineaMencion">
							<xsl:copy-of select="current()" />
						</xsl:for-each>
					</xsl:variable>
					
					
					<xsl:for-each select="$lineaMencion">
						<xsl:element name="h3">
							<xsl:value-of select="ehu:descripcion" disable-output-escaping="yes" />
						</xsl:element>
						<xsl:element name="p">
							<xsl:value-of select="ehu:desTipoAsigs" disable-output-escaping="yes" /><xsl:value-of select="$two_points" />
						</xsl:element>
						<xsl:if test="ehu:asignaturas">
							<xsl:element name="ul">
								<xsl:for-each select="ehu:asignaturas/ehu:asignatura">
									<xsl:element name="li">
										<xsl:value-of select="ehu:desAsignatura" disable-output-escaping="yes" /> (<xsl:value-of select="ehu:numCreditos" disable-output-escaping="yes" /><xsl:value-of select="$white_space"/><xsl:value-of select="languageUtil:get($locale,'ehu.es-eu-en-fr-credits')" />)
									</xsl:element>
								</xsl:for-each>
							</xsl:element>
							
							<xsl:element name="p">
								<xsl:attribute name="class">m-b-30</xsl:attribute>
								<xsl:value-of select="languageUtil:get($locale,'ehu.xsl-content.grado.num.cre.apro')" /><xsl:value-of select="$two_points" /><xsl:value-of select="$white_space" /><xsl:value-of select="ehu:minCreditos" disable-output-escaping="yes" />
							</xsl:element>
						</xsl:if>
					</xsl:for-each>
				</xsl:if>
				
				<xsl:if test="$lineaItinerario">
					<xsl:element name="h2">
						<xsl:value-of select="languageUtil:get($locale,'ehu.itinerariosCurriculares')" />
					</xsl:element>
					
					<xsl:if test="$lineasCurriculares/@textoItinerarios">
						<xsl:element name="p">
							<xsl:value-of select="$lineasCurriculares/@textoItinerarios" disable-output-escaping="yes" />
						</xsl:element>
					</xsl:if>
					
					<!-- lineas curriculares ordenadas por tipo mencion/itinerario -->
					<xsl:variable name="lineas_curriculares_sorted_copy">
						<xsl:for-each select="$lineaItinerario">
							<xsl:copy-of select="current()" />
						</xsl:for-each>
					</xsl:variable>
					
					
					<xsl:for-each select="$lineaItinerario">
						<xsl:element name="h3">
							<xsl:value-of select="ehu:descripcion" disable-output-escaping="yes" />
						</xsl:element>
						<xsl:element name="p">
							<xsl:value-of select="ehu:desTipoAsigs" disable-output-escaping="yes" /><xsl:value-of select="$two_points" />
						</xsl:element>
						<xsl:if test="ehu:asignaturas">
							<xsl:element name="ul">
								<xsl:for-each select="ehu:asignaturas/ehu:asignatura">
									<xsl:element name="li">
										<xsl:value-of select="ehu:desAsignatura" disable-output-escaping="yes" /> (<xsl:value-of select="ehu:numCreditos" disable-output-escaping="yes" /><xsl:value-of select="$white_space"/><xsl:value-of select="languageUtil:get($locale,'ehu.es-eu-en-fr-credits')" />)
									</xsl:element>
								</xsl:for-each>
							</xsl:element>
							
							<xsl:element name="p">
								<xsl:attribute name="class">m-b-30</xsl:attribute>
								<xsl:value-of select="languageUtil:get($locale,'ehu.xsl-content.grado.num.cre.apro')" /><xsl:value-of select="$two_points" /><xsl:value-of select="$white_space" /><xsl:value-of select="ehu:minCreditos" disable-output-escaping="yes" />
							</xsl:element>
						</xsl:if>
					</xsl:for-each>
				</xsl:if>
			</div>
		</div>
		
	</xsl:template>
	
	
	
	<!--Competencias -->
	<xsl:template name="competencias">
		<xsl:param name="competencias" />

		<xsl:if test="($competencias)">
		<h1><xsl:value-of select="languageUtil:get($locale,'ehu.xsl-content.grado.planestudio')" /></h1>
			<xsl:element name="div">
				<xsl:attribute name="class">m-b-30</xsl:attribute>
		
				<xsl:element name="div">
					<xsl:attribute name="class">bg-white p-20</xsl:attribute>
					
					<xsl:call-template name="header_main">
						<xsl:with-param name="title" select="languageUtil:get($locale,'ehu.xsl-content.grado.competenciasAdquiri')"/>
					</xsl:call-template>
					
					<xsl:element name="p">
						<xsl:value-of select="languageUtil:get($locale,'ehu.xsl-content.grado.titulo.titu.capacita')" /><xsl:value-of select="$two_points" /></xsl:element>
	
					
					<xsl:if test="$competencias">
						<xsl:element name="ul">
							<xsl:for-each select="$competencias/ehu:competencia">
								<xsl:element name="li">
									<xsl:value-of select="ehu:descripcion" disable-output-escaping="yes" />
								</xsl:element>
								
							</xsl:for-each>
						</xsl:element>
					</xsl:if>
				</xsl:element>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	
	
	<!-- verificacion -->
	<xsl:template name="verificacion">
		<xsl:param name="documentos" />
		<h1><xsl:value-of select="languageUtil:get($locale,'ehu.verificacionSeguimientoAcreditacion')" /></h1>
		<xsl:if test="$documentos">
			
		
			<xsl:element name="div">
			<xsl:attribute name="class">m-b-30</xsl:attribute>
				<xsl:element name="div">
				<xsl:attribute name="class">bg-white p-20</xsl:attribute>
						<xsl:call-template name="header_main">
							<xsl:with-param name="title" select="languageUtil:get($locale,'ehu.verificacionModificacion')"/>
						</xsl:call-template>
						<xsl:choose>
							<xsl:when test="($documentos/ehu:documento/ehu:tipo = 'MEMORIA') or 
											($documentos/ehu:documento/ehu:tipo = 'UNIQUALFIN') or 
											($documentos/ehu:documento/ehu:tipo = 'CUFINAL')">
								
								<xsl:element name="ul">
								<xsl:attribute name="class">list-icons</xsl:attribute>
								<xsl:for-each select="$documentos/ehu:documento">
									<xsl:variable name="tipoDocu" select="ehu:extension" />
									<xsl:if test="(ehu:tipo = 'MEMORIA') or (ehu:tipo = 'UNIQUALFIN') or (ehu:tipo = 'CUFINAL')">
										<xsl:element name="li">
											<xsl:attribute name="class"><xsl:value-of select="$tipoDocu"/></xsl:attribute>
											<xsl:call-template name="link_document_graduate">
												<xsl:with-param name="document_type" select="ehu:tipo" />
												<xsl:with-param name="document_cod_title" select="ehu:codTitulo" />
												<xsl:with-param name="document_title" select="ehu:titulo" />
												<xsl:with-param name="document_anyo" select="ehu:anyoAcad" />
												<xsl:with-param name="file_name" select="ehu:nombre" />
												<xsl:with-param name="extension" select="ehu:extension" />
												<xsl:with-param name="size" select="ehu:peso" />
											</xsl:call-template>
										</xsl:element>
									</xsl:if>
								</xsl:for-each>
								<xsl:if test="$degree_enlaceRutc">
								<li>
									<span class="icon-link"><xsl:value-of select="$white_space"/></span>
									<a>
										<xsl:attribute name="class">bullet bullet-url</xsl:attribute>
										<xsl:attribute name="target">_blank</xsl:attribute>
										<xsl:attribute name="title"><xsl:value-of select="languageUtil:get($locale,'opens-new-window')"/></xsl:attribute>
										<xsl:attribute name="href"><xsl:value-of select="$degree_enlaceRutc"/></xsl:attribute>
									 	<xsl:value-of select="languageUtil:get($locale,'ehu.registroUniversidadesCentrosTitulos')" /> 
									 	<span>
									 		<xsl:attribute name="class">icon-external-link</xsl:attribute>
									 		<xsl:value-of select="$white_space"/>
									 	</span>
									</a>
								</li>
								</xsl:if>
								</xsl:element>
							</xsl:when>
							<xsl:otherwise>
								<p>
									<xsl:attribute name="class">alert alert-info</xsl:attribute>
									<xsl:value-of select="languageUtil:get($locale, 'ehu.there-is-no-information-for-this-section')"/>
								</p>
							</xsl:otherwise>
						</xsl:choose>
				</xsl:element>
				</xsl:element>
		</xsl:if>	
	</xsl:template>
	
	
	<!-- seguimiento -->
	<xsl:template name="seguimiento">
		<xsl:param name="documentos" />
		<xsl:param name="anyoAcad" />
		
		<xsl:if test="($documentos/ehu:documento[contains(ehu:tipo,'INFSEGUI')]) or 
					  ($documentos/ehu:documento[contains(ehu:tipo,'UNISEGUI')]) ">
			<xsl:element name="div">
			<xsl:attribute name="class">m-b-30</xsl:attribute>
				<xsl:element name="div">
				<xsl:attribute name="class">bg-white p-20</xsl:attribute>		  
					<xsl:call-template name="header_main">
						<xsl:with-param name="title" select="languageUtil:get($locale,'ehu.seguimiento')"/>
					</xsl:call-template>
					<div class="upv-tabla table-responsive">
						 <table class="table table-hover">
						 	 <caption><xsl:value-of select="languageUtil:get($locale, 'ehu.seguimiento')"/></caption>
                              <thead>
                                <tr>
                                  <th class="span3"><strong><xsl:value-of select="languageUtil:get($locale, 'ehu.academic-year')"/></strong></th>
                                  <th><xsl:value-of select="languageUtil:get($locale, 'ehu.xsl-content.grado.titulo.seguimiento')"/></th>
                                </tr>
                              </thead>
                               <tbody>
                                
								<xsl:for-each select="$documentos/ehu:documento[starts-with(ehu:tipo,'INFSEGUI') or starts-with(ehu:tipo,'UNISEGUI')]">
									<xsl:sort select="ehu:anyoAcad" order="descending"/>
									<xsl:variable name="curso_academico">
										<xsl:value-of select="substring(ehu:anyoAcad,1,4)"/>/<xsl:value-of select="substring(number(substring(ehu:anyoAcad,1,4))+1 ,3,4)"/>
									</xsl:variable>
									<xsl:variable name="titulo"><xsl:value-of select="ehu:titulo"/><xsl:value-of select="$white_space"/>(<xsl:value-of select="languageUtil:get($locale,'ehu.curso')"/>:<xsl:value-of select="$curso_academico"/>)</xsl:variable>
									  <tr>
									  	<th class="span3"><xsl:value-of select="$curso_academico"/></th>
									  	<td>
										<xsl:call-template name="link_document_graduate">
											<xsl:with-param name="document_type" select="ehu:tipo" />
											<xsl:with-param name="document_cod_title" select="ehu:codTitulo" />
											<xsl:with-param name="document_title" select="$titulo" />
											<xsl:with-param name="document_anyo" select="ehu:anyoAcad"/>
											<xsl:with-param name="file_name" select="ehu:nombre" />
											<xsl:with-param name="extension" select="ehu:extension" />
											<xsl:with-param name="size" select="ehu:peso" />
										</xsl:call-template>
										</td>
									 </tr>
								</xsl:for-each>
								</tbody>
						</table>
					</div>
				</xsl:element>
				</xsl:element>
		</xsl:if>	
	</xsl:template>
	
	<!-- acreditacion -->
	<xsl:template name="acreditacion">
		<xsl:param name="documentos" />
		<xsl:if test="($documentos/ehu:documento[contains(ehu:tipo,'INFACRED')]) or 
					  ($documentos/ehu:documento[contains(ehu:tipo,'UNIACRED')]) or 
					  ($documentos/ehu:documento[contains(ehu:tipo,'CUACRED')]) ">
			
			
			<xsl:element name="div">
			<xsl:attribute name="class">m-b-30</xsl:attribute>
				<xsl:element name="div">
				<xsl:attribute name="class">bg-white p-20</xsl:attribute>		  
					<xsl:call-template name="header_main">
						<xsl:with-param name="title" select="languageUtil:get($locale,'ehu.acreditacion')"/>
					</xsl:call-template>
					<p>
						<xsl:value-of select="languageUtil:get($locale,'ehu.xsl-content.grado.titulo.acredi.fechaAcredi')"/>
						<xsl:text>: </xsl:text>
						<xsl:call-template name="fecha">
							<xsl:with-param name="init_date" select="$documentos/ehu:documento[starts-with(ehu:tipo,'INFACRED') or starts-with(ehu:tipo,'UNIACRED') or starts-with(ehu:tipo,'CUACRED')]/ehu:fecha" />
						</xsl:call-template>
					</p>
					<xsl:element name="div">
					<xsl:attribute name="class">upv-tabla table-responsive</xsl:attribute>	
			 			 <table class="table table-hover">
                             <caption><xsl:value-of select="languageUtil:get($locale, 'ehu.seguimiento')"/></caption>
                             <thead>
                               <tr>
                                 <th><strong><xsl:value-of select="languageUtil:get($locale, 'ehu.xsl-content.grado.titulo.acredi.autoevaluacion')"/></strong></th>
                               </tr>
                             </thead>
                             <tbody>
                            
                            	<xsl:variable name="counter" select="0"/>
								<xsl:for-each select="$documentos/ehu:documento">
								 
									<xsl:if test="contains(ehu:tipo,'INFACRED')">
									<tr>
										<th >
											<xsl:call-template name="link_document_graduate">
												<xsl:with-param name="document_type" select="ehu:tipo" />
												<xsl:with-param name="document_cod_title" select="ehu:codTitulo" />
												<xsl:with-param name="document_title" select="ehu:titulo" />
												<xsl:with-param name="document_anyo" select="ehu:anyoAcad"/>
												<xsl:with-param name="file_name" select="ehu:nombre" />
												<xsl:with-param name="extension" select="ehu:extension" />
												<xsl:with-param name="size" select="ehu:peso" />
											</xsl:call-template>
										</th>
								  	</tr>	
									</xsl:if>
									<xsl:if test="contains(ehu:tipo,'UNIACRED')">
										<tr>
										   <th >
											<xsl:call-template name="link_document_graduate">
												<xsl:with-param name="document_type" select="ehu:tipo" />
												<xsl:with-param name="document_cod_title" select="ehu:codTitulo" />
												<xsl:with-param name="document_title" select="ehu:titulo" />
												<xsl:with-param name="document_anyo" select="ehu:anyoAcad"/>
												<xsl:with-param name="file_name" select="ehu:nombre" />
												<xsl:with-param name="extension" select="ehu:extension" />
												<xsl:with-param name="size" select="ehu:peso" />
											</xsl:call-template>
										</th>
					  					</tr>	
									</xsl:if>
									
									<xsl:if test="contains(ehu:tipo,'CUACRED')">
										<tr>
										<th >
											<xsl:call-template name="link_document_graduate">
												<xsl:with-param name="document_type" select="ehu:tipo" />
												<xsl:with-param name="document_cod_title" select="ehu:codTitulo" />
												<xsl:with-param name="document_title" select="ehu:titulo" />
												<xsl:with-param name="document_anyo" select="ehu:anyoAcad"/>
												<xsl:with-param name="file_name" select="ehu:nombre" />
												<xsl:with-param name="extension" select="ehu:extension" />
												<xsl:with-param name="size" select="ehu:peso" />
											</xsl:call-template>
										</th>
			  							</tr>	
									</xsl:if>
								</xsl:for-each>	
							</tbody>
						</table>
					</xsl:element>
				</xsl:element>
			</xsl:element>
		</xsl:if>	
	
	</xsl:template>
	
	<!-- Profesorado -->
	<xsl:template name="graduate-profesorado">
		<xsl:param name="profesorado" />
		<xsl:param name="anyoAcad"/>
		<h1><xsl:value-of select="languageUtil:get($locale,'ehu.profesorado')" /></h1>
		
		<xsl:if test="$profesorado">
			<xsl:element name="div">
			<xsl:attribute name="class">m-b-30</xsl:attribute>
				<xsl:element name="div">
				<xsl:attribute name="class">bg-white p-20</xsl:attribute>
					<xsl:if test="$profesorado/ehu:profesor">
						<xsl:element name="ul">
						<xsl:attribute name="class">list-links</xsl:attribute>
							<xsl:for-each select="$profesorado/ehu:profesor">
								<xsl:sort select="ehu:nombre"/>
								<xsl:variable name="idp" select="ehu:idp"/>
								<xsl:element name="li">
									 <a>
										<xsl:attribute name="href">?p_redirect=consultaTutorias&amp;p_anyo_acad=<xsl:value-of select="$anyoAcad"/>&amp;p_idp=<xsl:value-of select="$idp"/></xsl:attribute>
										 <xsl:call-template name="CamelCase">
   									<xsl:with-param name="text"><xsl:value-of select="ehu:nombre" /></xsl:with-param>
									</xsl:call-template> 
									</a>
								</xsl:element>
							</xsl:for-each>
						</xsl:element>
					</xsl:if>	
				</xsl:element>	
			</xsl:element>
		</xsl:if>
	</xsl:template>
	
</xsl:stylesheet>