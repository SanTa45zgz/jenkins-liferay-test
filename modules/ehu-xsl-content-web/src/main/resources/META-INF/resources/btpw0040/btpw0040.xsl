<?xml version="1.0"?>

	<xsl:stylesheet 
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
		xmlns:ehu="http://www.ehu.eus"
		xmlns:xalan="http://xml.apache.org/xalan"
		xmlns:languageUtil="xalan://com.liferay.portal.kernel.language.LanguageUtil"
		exclude-result-prefixes="xalan"
		extension-element-prefixes="languageUtil xalan">
		
		<xsl:output method="html" omit-xml-declaration="yes" />
		
		<xsl:include href="http://localhost:8080/o/ehu-xsl-content-web/common/common-no-standar.xsl"/>
	
		<xsl:template match="/">
	
		<xsl:variable name="p_tipo" select="pagina/parametros/parametro[@nombre='p_tipo']"/>
		<xsl:variable name="p_anyo" select="pagina/parametros/parametro[@nombre='p_anyo']"/>
		<xsl:variable name="p_fec_convo" select="pagina/parametros/parametro[@nombre='p_fec_convo']"/>
		<xsl:variable name="p_regimen" select="pagina/parametros/parametro[@nombre='p_regimen']"/>
		<xsl:variable name="p_grupo" select="pagina/parametros/parametro[@nombre='p_grupo']"/>
		<xsl:variable name="p_acceso" select="pagina/parametros/parametro[@nombre='p_acceso']"/>
		<xsl:variable name="p_estado" select="pagina/parametros/parametro[@nombre='p_estado']"/>
		<xsl:variable name="p_id_proceso" select="pagina/parametros/parametro[@nombre='p_id_proceso']"/>
		<xsl:variable name="p_pestanya_param" select="pagina/parametros/parametro[@nombre='p_pestanya']"/>
		<div>
			<xsl:attribute name="class">xsl-content ope2018</xsl:attribute>
				<xsl:choose>
					<xsl:when test="pagina/error">
						<xsl:call-template name="xml_error"/>
					</xsl:when>
					<xsl:when test="pagina/criteriosFiltro">
						<h1>
							<xsl:value-of select="languageUtil:get($locale,'ehu.xsl-content.title.btpw0040')"/>
						</h1>
						<form>
							<xsl:attribute name="id">search_form</xsl:attribute>								
							<xsl:attribute name="action"></xsl:attribute>
							<xsl:attribute name="method">get</xsl:attribute>									
							<xsl:attribute name="name"><xsl:value-of select="languageUtil:get($locale,'ehu.search')"/></xsl:attribute>								
							<fieldset>
								<input>
									<xsl:attribute name="id">p_pestanya</xsl:attribute>								
									<xsl:attribute name="name">p_pestanya</xsl:attribute>
									<xsl:attribute name="type">hidden</xsl:attribute>
									<xsl:attribute name="value">0</xsl:attribute>
								</input>
							<xsl:for-each select="pagina/criteriosFiltro/lista">
								<xsl:variable name="search_criteria_field" select="@nombre" />										 
								<label>
									<xsl:attribute name="for">
										<xsl:value-of select="@nombre"/>
									</xsl:attribute>
									<xsl:choose>
										<xsl:when test="$search_criteria_field = 'p_tipo'"><xsl:value-of select="languageUtil:get($locale,'ehu.type')"/></xsl:when>
										<xsl:when test="$search_criteria_field = 'p_anyo'"><xsl:value-of select="languageUtil:get($locale,'ehu.year')"/></xsl:when>											
										<xsl:when test="$search_criteria_field = 'p_fec_convo'"><xsl:value-of select="languageUtil:get($locale,'ehu.convocation-date')"/></xsl:when>
										<xsl:when test="$search_criteria_field = 'p_regimen'"><xsl:value-of select="languageUtil:get($locale,'ehu.regimen')"/></xsl:when>
										<xsl:when test="$search_criteria_field = 'p_grupo'"><xsl:value-of select="languageUtil:get($locale,'ehu.group')"/></xsl:when>
										<xsl:when test="$search_criteria_field = 'p_acceso'"><xsl:value-of select="languageUtil:get($locale,'ehu.access-mode')"/></xsl:when>
										<xsl:when test="$search_criteria_field = 'p_estado'"><xsl:value-of select="languageUtil:get($locale,'ehu.state')"/></xsl:when>
										<xsl:otherwise><xsl:value-of select="languageUtil:get($locale,'ehu.another')"/></xsl:otherwise>												
									</xsl:choose>																						
								</label> 
								<select>
									<xsl:attribute name="id">
										<xsl:value-of select="@nombre"/>
									</xsl:attribute>
									<xsl:attribute name="name">
										<xsl:value-of select="@nombre"/>
									</xsl:attribute>											
									<xsl:if test="($search_criteria_field = 'p_tipo') or ($search_criteria_field = 'p_anyo') or ($search_criteria_field = 'p_regimen')">
										<xsl:attribute name="onChange">												
											<xsl:text>update_filter();</xsl:text>
										</xsl:attribute>
									</xsl:if>
									<xsl:for-each select="opcion">
										<xsl:element name="option">
											<xsl:attribute name="value">
												<xsl:value-of select="@value"/>
											</xsl:attribute>
											<xsl:if test="@seleccionada" >
												<xsl:attribute name="selected">
													<xsl:value-of select="true"/>
												</xsl:attribute>
											</xsl:if>
											<xsl:value-of select="."/>																					
										</xsl:element>	
									</xsl:for-each>													
								</select>							
							</xsl:for-each>
							<input>
								<xsl:attribute name="id">btn_buscar</xsl:attribute>  										 
								<xsl:attribute name="class">btn btn-primary</xsl:attribute>
		  						<xsl:attribute name="value"><xsl:value-of select="languageUtil:get($locale,'ehu.search')"/></xsl:attribute>
								<xsl:attribute name="type">submit</xsl:attribute>
							</input>									
							</fieldset>
						</form>							
					</xsl:when>					
					<xsl:when test="pagina/cabecera">
						<article>
							<div>
								<xsl:attribute name="class">taglib-header</xsl:attribute> 
								<span> 
									<xsl:attribute name="class">back-to</xsl:attribute>
									<a> 
										<xsl:attribute name="href">?p_cod_idioma=<xsl:value-of select="$p_cod_idioma"/>&amp;p_tipo=&amp;p_anyo=&amp;p_fec_convo=&amp;p_regimen=&amp;p_grupo=&amp;p_acceso=&amp;p_estado=&amp;p_id_proceso=&amp;p_pestanya=</xsl:attribute>
										<span>
							  				<xsl:attribute name="class">icon-chevron-left</xsl:attribute>
							  				<xsl:value-of select="$white"/>
							  			</span>
										<span><xsl:value-of select="languageUtil:get($locale,'ehu.back-to-search')"/></span> 
									</a>
									<xsl:value-of select="$white"/>
									<a> 
										<xsl:attribute name="href">?p_cod_idioma=<xsl:value-of select="$p_cod_idioma"/>&amp;p_tipo=<xsl:value-of select="$p_tipo"/>&amp;p_anyo=<xsl:value-of select="$p_anyo"/>&amp;p_fec_convo=<xsl:value-of select="$p_fec_convo"/>&amp;p_regimen=<xsl:value-of select="$p_regimen"/>&amp;p_grupo=<xsl:value-of select="$p_grupo"/>&amp;p_acceso=<xsl:value-of select="$p_acceso"/>&amp;p_estado=<xsl:value-of select="$p_estado"/>&amp;p_id_proceso=<xsl:value-of select="$p_id_proceso"/>&amp;p_pestanya=0</xsl:attribute>
										<span>
							  				<xsl:attribute name="class">icon-chevron-left</xsl:attribute>
							  				<xsl:value-of select="$white"/>
							  			</span>
										<span><xsl:value-of select="languageUtil:get($locale,'ehu.back-to-results')"/></span> 
									</a>
								</span>
							</div>
							<div>
								<xsl:attribute name="class">convocatory</xsl:attribute>
								<xsl:if test="pagina/cabecera/@titulo">
									<h1>
										<!-- <xsl:value-of select="cabecera/@titulo"/> -->
										<!-- El titulo de la convocatoria es el del Proceso selectivo -->
										<xsl:for-each select="pagina/cabecera/elemento">
											<xsl:if test="@nombre = 'Proceso selectivo' or @nombre= 'Hautaketa prozesua'">
												<xsl:value-of select="."/>												
											</xsl:if>
										</xsl:for-each>
									</h1>									
								</xsl:if>	
								<dl>
									<xsl:for-each select="pagina/cabecera/elemento">
										<!-- El titulo de la convocatoria se forma con los valores Proceso selectivo-->
										<xsl:if test="not(@nombre = 'Proceso selectivo') and not(@nombre = 'Hautaketa prozesua') ">
											<dt><xsl:value-of select="@nombre"/>:</dt>
											<dd><xsl:value-of select="."/></dd>
										</xsl:if>	
									</xsl:for-each>
								</dl>
							</div>
							<xsl:variable name="list" select="pagina/navegacion/pestanya"/>
							<section>
								<xsl:attribute name="id">tab</xsl:attribute>
								<xsl:attribute name="class">tabbable-content</xsl:attribute>
								<ul>
									<xsl:attribute name="class">nav nav-tabs</xsl:attribute>
									<xsl:attribute name="role">tablist</xsl:attribute>
									<xsl:for-each select="$list">
										<xsl:variable name="active-tab" select="@seleccionada"/>
										<xsl:variable name="p_pestanya" select="@valor"/>	
										<li>
											<xsl:attribute name="role">presentation</xsl:attribute>
											<xsl:attribute name="class">
												<xsl:choose>
													<xsl:when test="$active-tab = '1'">tab active tab-selected</xsl:when>	
													<xsl:otherwise>tab</xsl:otherwise>
												</xsl:choose>
											</xsl:attribute>									
											<a>
												<xsl:attribute name="href">?p_cod_idioma=<xsl:value-of select="$p_cod_idioma"/>&amp;p_tipo=<xsl:value-of select="$p_tipo"/>&amp;p_anyo=<xsl:value-of select="$p_anyo"/>&amp;p_fec_convo=<xsl:value-of select="$p_fec_convo"/>&amp;p_regimen=<xsl:value-of select="$p_regimen"/>&amp;p_grupo=<xsl:value-of select="$p_grupo"/>&amp;p_acceso=<xsl:value-of select="$p_acceso"/>&amp;p_estado=<xsl:value-of select="$p_estado"/>&amp;p_id_proceso=<xsl:value-of select="$p_id_proceso"/>&amp;p_pestanya=<xsl:value-of select="$p_pestanya"/></xsl:attribute>
												<xsl:attribute name="class">tab-label tab-content</xsl:attribute>
												<xsl:attribute name="role">tab</xsl:attribute>
													<xsl:value-of select="."/>
											</a>											
										</li>							
									</xsl:for-each>
								</ul>
								<div>	
									<xsl:attribute name="class">tab-content</xsl:attribute>
									<xsl:for-each select="pagina/apartado">
									
										<!--  el título no viene del xml así que cogemos el título de la pestaña como título de la sección -->
										
										<xsl:for-each select="$list">
											<xsl:variable name="p_pestanya" select="@valor"/>
											
											<xsl:if test="$p_pestanya = $p_pestanya_param">
												<h2>
													<xsl:value-of select="."/>
												</h2>
											</xsl:if>
												
										</xsl:for-each>
										
										<!-- al apuntar a producción se observa que existen elementos parrafo, enlace y enlaceDoc fuera de la etiqueta elemento -->
										<xsl:if test="parrafo">
											<xsl:for-each select="parrafo">
												<xsl:variable name="emphatized_paragraph" select="@enfatizar" />						
												<xsl:variable name="paragraph_title" select="@titulo" />
												<xsl:variable name="data" select="." />
												<p>
													<xsl:choose>
														<xsl:when test="($emphatized_paragraph = '1')">
															<xsl:attribute name="class">
																<xsl:text>alert alert-alert portlet-msg-alert</xsl:text>
															</xsl:attribute>
														</xsl:when>
														<xsl:when test="($emphatized_paragraph = '0')">
															<xsl:attribute name="class">
																<xsl:text>alert alert-info portlet-msg-info</xsl:text>
															</xsl:attribute>
														</xsl:when>
														<xsl:otherwise>									
														</xsl:otherwise>				
													</xsl:choose>
												 	<xsl:call-template name="xml_tranform_n_br">
														<xsl:with-param name="xml_plain_text" select="$data"/>
													</xsl:call-template>		 	
												</p>		
											</xsl:for-each>
										</xsl:if>
										<xsl:if test="enlaceDoc">
											<ul>
												<xsl:for-each select="enlaceDoc">
													<li>
													<span>
														<xsl:attribute name="class">icon-file</xsl:attribute>
														<xsl:value-of select="$white"/>
													</span>				
													<a target="_blank">
														
														<xsl:attribute name="href">
															<xsl:value-of select="url" />
														</xsl:attribute>
														
														
														<xsl:attribute name="title">
															<xsl:value-of select="languageUtil:get($locale,'opens-new-window')"/>
														</xsl:attribute>
													
												
														<xsl:value-of select="texto"/>
														
													
														<span>
															<xsl:attribute name="class">icon-external-link</xsl:attribute> 
															<xsl:value-of select="$white"/>
														</span>								 
													</a>
													</li>
												</xsl:for-each>
											</ul>
										</xsl:if>	
										<xsl:if test="enlace">
											<ul>
												<xsl:for-each select="enlace">
													<li>
														<xsl:variable name="newWindow" select="@nuevaVentana"/>
														<xsl:if test="texto/@prefijo !=''">
															<xsl:value-of select="texto/@prefijo"/>
															<xsl:value-of select="$white"/>
														</xsl:if>
														
														<span>
															<xsl:attribute name="class">icon-link</xsl:attribute>		
															<xsl:value-of select="$white"/>
														</span>
														<a>	
															<xsl:if test="$newWindow = 1">
																<xsl:attribute name="target">
																	<xsl:text>_blank</xsl:text>
												
																</xsl:attribute>
															</xsl:if>								
															
															<xsl:attribute name="href"><xsl:value-of select="url"/></xsl:attribute>
															
															<!-- Edorta    <xsl:attribute name="title"><xsl:value-of select="title"/></xsl:attribute> -->
															<xsl:attribute name="title">
																<xsl:value-of select="languageUtil:get($locale,'opens-new-window')"/>
															</xsl:attribute>
															
															<span>
																<xsl:attribute name="class">summary-title</xsl:attribute>
																<xsl:value-of select="texto"/> 
					
	       		 		
															</span>	
							
															<span>
																<xsl:attribute name="class">
																	<xsl:text>icon-external-link</xsl:text>
																</xsl:attribute>
															</span>
														</a>		
													</li>
												</xsl:for-each>
											</ul>
										</xsl:if>	
										<xsl:apply-templates/>
									</xsl:for-each>
								</div>
							</section>
						</article>
					</xsl:when>	
					<xsl:otherwise>
						<div>
							<xsl:attribute name="class">taglib-header</xsl:attribute> 
							<span> 
								<xsl:attribute name="class">back-to</xsl:attribute>
								<a> 
									<xsl:attribute name="href">?p_cod_idioma=<xsl:value-of select="$p_cod_idioma"/>&amp;p_tipo=&amp;p_anyo=&amp;p_fec_convo=&amp;p_regimen=&amp;p_grupo=&amp;p_acceso=&amp;p_estado=&amp;p_id_proceso=&amp;p_pestanya=</xsl:attribute>
									<span>
							  			<xsl:attribute name="class">icon-chevron-left</xsl:attribute>
							  			<xsl:value-of select="$white"/>
							  		</span>
									<span><xsl:value-of select="languageUtil:get($locale,'ehu.back-to-search')"/></span> 
								</a>
							</span>
						</div>
						<xsl:for-each select="pagina/apartado">
							<xsl:apply-templates/>
						</xsl:for-each>
					</xsl:otherwise>				
				</xsl:choose>	
			</div>
			
			<script>
				<xsl:text>
					function update_filter() {
						// Se mantiene el valor del campo p_pestanya a vacio para no mostrar la pagina de resultados 
						document.getElementById('p_pestanya').value = '';
						// Se recarga la pagina con la opcion seleccionada
						document.getElementById('search_form_pas').submit();						
					}
				</xsl:text>
			</script>
				
	</xsl:template>
	
</xsl:stylesheet>