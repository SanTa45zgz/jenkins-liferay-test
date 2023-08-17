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
		
		<xsl:variable name="p_fec_convo" select="pagina/parametros/parametro[@nombre='p_fec_convo']"/>	
		<xsl:variable name="p_estado" select="pagina/parametros/parametro[@nombre='p_estado']"/>
		<xsl:variable name="p_tipo_convo" select="pagina/parametros/parametro[@nombre='p_tipo_convo']"/>
		<xsl:variable name="p_anyo" select="pagina/parametros/parametro[@nombre='p_anyo']"/>
		<xsl:variable name="p_fecha" select="pagina/parametros/parametro[@nombre='p_fecha']"/>
		<xsl:variable name="p_ordinal" select="pagina/parametros/parametro[@nombre='p_ordinal']"/>
		<xsl:variable name="p_ord_amplic" select="pagina/parametros/parametro[@nombre='p_ord_amplic']"/>		
		<xsl:variable name="p_tipo_bolsa" select="pagina/parametros/parametro[@nombre='p_tipo_bolsa']"/>
		<div>
			<xsl:attribute name="class">xsl-content pdi</xsl:attribute>
			<xsl:choose>
				<xsl:when test="pagina/error">
					<xsl:call-template name="xml_error"/>
				</xsl:when>
				<xsl:when test="pagina/criteriosFiltro">
					<h1>
						<xsl:value-of select="languageUtil:get($locale,'ehu.xsl-content.title.btpw0020')"/>
					</h1>
					<form>
						<xsl:attribute name="id">search_form_pdi</xsl:attribute>								
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
							<xsl:variable name="search_criteria_field" select="@nombre"/>										 
							<label>
								<xsl:attribute name="for">
									<xsl:value-of select="@nombre"/>
								</xsl:attribute>
								<xsl:value-of select="@descripcion"/>																					
							</label> 
							<select>
								<xsl:attribute name="id">
									<xsl:value-of select="@nombre"/>
								</xsl:attribute>
								<xsl:attribute name="name">
									<xsl:value-of select="@nombre"/>
								</xsl:attribute>
								<option>
									<xsl:attribute name="value"></xsl:attribute>
								</option> 
								<xsl:variable name="selected_option" select="'true'" />
								<xsl:for-each select="opcion">
									<xsl:variable name="select_option" select="@seleccionada" />
									<xsl:choose>
										<xsl:when test="$select_option = $selected_option" >						
										<option>
											<xsl:attribute name="value">
												<xsl:value-of select="@value"/>
											</xsl:attribute>
											<xsl:attribute name="selected">
												<xsl:value-of select="true"/>
											</xsl:attribute>
											<xsl:value-of select="."/>
										</option>						
										</xsl:when>
										<xsl:otherwise>	
											<option>
												<xsl:attribute name="value">
													<xsl:value-of select="@value"/>
												</xsl:attribute>
												<xsl:value-of select="."/>									
											</option>									
										</xsl:otherwise>	
									</xsl:choose>	
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
									<xsl:attribute name="href">?p_cod_idioma=<xsl:value-of select="$p_cod_idioma"/>&amp;p_fec_convo=&amp;p_estado=&amp;p_tipo_convo=&amp;p_pestanya=&amp;p_tipo_bolsa=</xsl:attribute>
									<span>
						  				<xsl:attribute name="class">icon-chevron-left</xsl:attribute>
						  				<xsl:value-of select="$white"/>
						  			</span> 
									<span><xsl:value-of select="languageUtil:get($locale,'ehu.back-to-search')"/></span> 
								</a>
								<xsl:value-of select="$white"/>
								<a> 
									<xsl:attribute name="href">?p_cod_idioma=<xsl:value-of select="$p_cod_idioma"/>&amp;p_fec_convo=<xsl:value-of select="$p_fec_convo"/>&amp;p_estado=<xsl:value-of select="$p_estado"/>&amp;p_tipo_bolsa=<xsl:value-of select="$p_tipo_bolsa"/>&amp;p_tipo_convo=<xsl:value-of select="$p_tipo_convo"/>&amp;p_pestanya=0</xsl:attribute>
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
									<xsl:for-each select="pagina/cabecera/elemento">
										<xsl:if test="(@nombre = 'Area de conocimiento') or (@nombre = 'Jakintza-arloa')">
											<xsl:value-of select="."/>												
										</xsl:if>
									</xsl:for-each>
								</h1>									
							</xsl:if>	
							<dl>
								<xsl:for-each select="pagina/cabecera/elemento">
									<xsl:variable name="ul" select="ul" />
									<xsl:variable name="nombre" select="@nombre" />
									<xsl:variable name="valor" select="." />
									<xsl:if test="$valor != $void">
										<dt><xsl:value-of select="$nombre"/>:</dt>
	
										<dd>
											<xsl:choose>
												<xsl:when test="$ul != $void">
													<ul>
														<xsl:for-each select="ul/li">
															<li><xsl:value-of select="."/></li>
														</xsl:for-each>
													</ul>
												</xsl:when>
												<xsl:otherwise>									
													<xsl:value-of select="$valor"/>			
												</xsl:otherwise>				
											</xsl:choose>		
										</dd>				
									</xsl:if>				
								</xsl:for-each>
							</dl>
						</div>	
						
						<section>
							<xsl:attribute name="id">tab</xsl:attribute>
							<xsl:attribute name="class">tabbable-content</xsl:attribute>
							<ul>
								<xsl:attribute name="class">nav nav-tabs</xsl:attribute>
								<xsl:attribute name="role">tablist</xsl:attribute>
								<xsl:for-each select="pagina/navegacion/pestanya">
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
											<xsl:attribute name="href">?p_cod_idioma=<xsl:value-of select="$p_cod_idioma"/>&amp;p_fec_convo=<xsl:value-of select="$p_fec_convo"/>&amp;p_estado=<xsl:value-of select="$p_estado"/>&amp;p_tipo_convo=<xsl:value-of select="$p_tipo_convo"/>&amp;p_tipo_bolsa=<xsl:value-of select="$p_tipo_bolsa"/>&amp;p_anyo=<xsl:value-of select="$p_anyo"/>&amp;p_fecha=<xsl:value-of select="$p_fecha"/>&amp;p_ordinal=<xsl:value-of select="$p_ordinal"/>&amp;p_ord_amplic=<xsl:value-of select="$p_ord_amplic"/>&amp;p_pestanya=<xsl:value-of select="$p_pestanya"/></xsl:attribute>
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
									<xsl:if test="@titulo">
										<h2>
											<xsl:value-of select="@titulo"/>
										</h2>
									</xsl:if>	
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
								<xsl:attribute name="href">?p_cod_idioma=<xsl:value-of select="$p_cod_idioma"/>&amp;p_fec_convo=&amp;p_estado=&amp;p_tipo_convo=&amp;p_tipo_bolsa=&amp;p_pestanya=</xsl:attribute>
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
			function update_p_pestanya(value) {
				document.getElementById('p_pestanya').value = value;				
			}
			</xsl:text>
		</script>
		
	</xsl:template>
		
</xsl:stylesheet>
