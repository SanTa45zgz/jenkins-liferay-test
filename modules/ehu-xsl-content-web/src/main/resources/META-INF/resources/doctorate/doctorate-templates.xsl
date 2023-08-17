<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0" xmlns:ehu="http://www.ehu.eus"
	xmlns:exsl="http://exslt.org/common" 
	xmlns:xalan="http://xml.apache.org/xalan"
	xmlns:languageUtil="xalan://com.liferay.portal.kernel.language.LanguageUtil"
	xmlns:propsUtil="com.liferay.portal.kernel.util.PropsUtil"
	xmlns:StringPool="com.liferay.portal.kernel.util.StringPool"
	xmlns:stringUtil="xalan://com.liferay.portal.kernel.util.StringUtil"
	exclude-result-prefixes="xalan" 
	extension-element-prefixes="exsl languageUtil propsUtil StringPool stringUtil xalan">

	<xsl:output method="xml" omit-xml-declaration="yes" />
			
	<xsl:variable name="doctorado" select="ehu:app/ehu:doctorados/ehu:doctorado" />

	
	<xsl:template name="presentacion">
		<xsl:element name="div">
			<xsl:attribute name="class">grado-datos bg-grey p-20</xsl:attribute>
			<xsl:if test="$doctorado/ehu:plazas/ehu:parcialUPV != 0">
				<h2>
					<xsl:text>Ficha de Grado</xsl:text>
				</h2>
				<h3>
					<strong><xsl:value-of select="languageUtil:get($locale,'upv-ehu.doctorate.presentation.partial')"/></strong>
				</h3>
				<p>
					<xsl:value-of select="languageUtil:get($locale,'ehu.duration')"/>:<xsl:value-of select="$white_space" />
					<span><xsl:text>5 - 8 </xsl:text><xsl:value-of select="languageUtil:get($locale,'ehu.xsl-content.grado.cursos')"/></span>
				</p>
				<p>
					<xsl:value-of select="languageUtil:get($locale,'ehu.plazasOfertadas')"/>:<xsl:value-of select="$white_space" />
					<span><xsl:value-of select="$doctorado/ehu:plazas/ehu:parcialUPV"/></span>
				</p>
				<p>
					<xsl:value-of select="languageUtil:get($locale,'upv-ehu.masters.home.guideprice')"/>:<xsl:value-of select="$white_space" />
					<span><xsl:value-of select="format-number($doctorado/ehu:precioOrientativoParcial, '###')"/><xsl:value-of select="$white_space" /><xsl:value-of select="$euro"/>/<xsl:value-of select="translate(languageUtil:get($locale,'ehu.curso.by'), $upper, $lower)"/></span>
				</p>
			</xsl:if>
			<xsl:if test="$doctorado/ehu:plazas/ehu:completaUPV != 0">
				<h2>
					<xsl:text>Ficha de Grado</xsl:text>
				</h2>
				<h3>
					<strong><xsl:value-of select="languageUtil:get($locale,'upv-ehu.doctorate.presentation.complete')"/></strong>
				</h3>
				<p>
					<xsl:value-of select="languageUtil:get($locale,'ehu.duration')"/>:<xsl:value-of select="$white_space" />
					<span><xsl:text>3 - 5 </xsl:text><xsl:value-of select="languageUtil:get($locale,'ehu.xsl-content.grado.cursos')"/></span>
				</p>
				<p>
					<xsl:value-of select="languageUtil:get($locale,'ehu.plazasOfertadas')"/>:<xsl:value-of select="$white_space" />
					<span><xsl:value-of select="$doctorado/ehu:plazas/ehu:completaUPV"/></span>
				</p>
				<p>
					<xsl:value-of select="languageUtil:get($locale,'upv-ehu.masters.home.guideprice')"/>:<xsl:value-of select="$white_space" />
					<span><xsl:value-of select="format-number($doctorado/ehu:precioOrientativoCompleta, '###')"/><xsl:value-of select="$white_space" /><xsl:value-of select="$euro"/>/<xsl:value-of select="translate(languageUtil:get($locale,'ehu.curso.by'), $upper, $lower)"/></span>
				</p>
			</xsl:if>
			
		 	<xsl:variable name="totalPlazasOtras" select="number($doctorado/ehu:plazas/ehu:completaOtras) + number($doctorado/ehu:plazas/ehu:parcialOtras)"/>
			<xsl:if test="$doctorado/ehu:plazas/ehu:completaOtras != 0 or $doctorado/ehu:plazas/ehu:parcialOtras != 0">
				<h3>
					<strong><xsl:value-of select="languageUtil:get($locale,'upv-ehu.doctorate.presentation.others')"/></strong>
				</h3>

				<xsl:for-each select="$doctorado/ehu:universidades/ehu:otrasUniversidades/ehu:universidad">
					<p><xsl:value-of select="."/></p>
				</xsl:for-each>
				
				<p>
					<xsl:value-of select="languageUtil:get($locale,'ehu.plazasOfertadas')"/>:<xsl:value-of select="$white_space" />
					<span><xsl:value-of select="$totalPlazasOtras"/></span>
				</p>
			</xsl:if>
			
			<h3>
				<strong><xsl:value-of select="languageUtil:get($locale,'ehu.contacto')"/></strong>
			</h3>
			<xsl:if test="$doctorado/ehu:infAcademica/ehu:contacto/ehu:mail">
				<xsl:element name="p">
					<xsl:attribute name="class">m-b-20</xsl:attribute>
					<xsl:value-of select="languageUtil:get($locale,'upv-ehu.doctorate.presentation.consultasAc')"/>:<xsl:value-of select="$white_space" />
					<xsl:element name="a">
						<xsl:attribute name="href">mailto:<xsl:value-of
							select="$doctorado/ehu:infAcademica/ehu:contacto/ehu:mail" /></xsl:attribute>
						<xsl:value-of select="$doctorado/ehu:infAcademica/ehu:contacto/ehu:mail" />
					</xsl:element>
				</xsl:element>
			</xsl:if>
			<xsl:if test="$doctorado/ehu:infAdministrativa/ehu:contacto/ehu:mail">
				<xsl:element name="p">
					<xsl:attribute name="class">m-b-20</xsl:attribute>
					<xsl:value-of select="languageUtil:get($locale,'upv-ehu.doctorate.presentation.consultasAd')"/>:<xsl:value-of select="$white_space" />
					<xsl:element name="a">
						<xsl:attribute name="href">mailto:<xsl:value-of
							select="$doctorado/ehu:infAdministrativa/ehu:contacto/ehu:mail" /></xsl:attribute>
						<xsl:value-of select="$doctorado/ehu:infAdministrativa/ehu:contacto/ehu:mail" />
					</xsl:element>
				</xsl:element>

				<xsl:element name="a">
					<xsl:attribute name="href">mailto:<xsl:value-of select="$doctorado/ehu:infAdministrativa/ehu:contacto/ehu:mail"/></xsl:attribute>
					<xsl:element name="span">
						<xsl:attribute name="class">fa fa-envelope</xsl:attribute>
						<xsl:value-of select="$white_space"/>
					</xsl:element>
					<xsl:element name="span">
						<xsl:attribute name="class">m-l-10</xsl:attribute>
						<xsl:value-of select="languageUtil:get($locale,'upv-ehu.masters.home.suggestionbox')"/>
					</xsl:element>
				</xsl:element>
			</xsl:if>
		</xsl:element>
	</xsl:template>
	
	
	<xsl:template name="investigacion">		
		<xsl:element name="section">
			<xsl:attribute name="class">upv-ehu-image-description p-20</xsl:attribute>
			<h2><xsl:value-of select="languageUtil:get($locale,'upv-ehu.doctorate.investigation.title')"/></h2>
			<xsl:element name="div">
				<xsl:attribute name="class">upv-tabla table-responsive</xsl:attribute>
				<xsl:element name="table">
					<xsl:attribute name="id">tableSearchProfesorado</xsl:attribute>
					<xsl:attribute name="class">table table-hover</xsl:attribute>
					<caption><xsl:value-of select="languageUtil:get($locale,'upv-ehu.doctorate.investigation.title')"/></caption>
					<thead>
						<tr>
							<xsl:element name="th">
								<xsl:attribute name="class">ehu-sans t16</xsl:attribute>
								<xsl:value-of select="languageUtil:get($locale,'upv-ehu.doctorate.investigation.teams')"/>
							</xsl:element>
							<xsl:element name="th">
								<xsl:attribute name="class">ehu-sans t16</xsl:attribute>
								<xsl:value-of select="languageUtil:get($locale,'upv-ehu.doctorate.investigation.lines')"/>
							</xsl:element>
						</tr>
					</thead>
					<tbody>
						<xsl:for-each select="$doctorado/ehu:equiposInvestigacion/ehu:equipoInvestigacion">
							<tr>
								<td>  									
									<a>
										<!-- 
										<xsl:attribute name="href">javascript:redirectToProfesorado('<xsl:value-of select="languageUtil:get($locale,'upv-ehu.doctorate.profesorado.url')"/>?findByTeam=<xsl:value-of select="ehu:descripcion"/>');</xsl:attribute>
										<xsl:attribute name="data-path"><xsl:value-of select="ehu:descripcion"/></xsl:attribute>
										<xsl:attribute name="href">javascript:redirectToProfesorado('<xsl:value-of select="languageUtil:get($locale,'upv-ehu.doctorate.profesorado.url')"/>?findByTeam=', '<xsl:value-of select="ehu:descripcion"/>');</xsl:attribute>
										
										
										<xsl:attribute name="data-path"><xsl:value-of select="ehu:descripcion"/></xsl:attribute>
										<xsl:value-of select="ehu:descripcion"/>
										 -->										
										<xsl:variable name="descripcion" select="ehu:descripcion"/>
										<xsl:attribute name="href">javascript:redirectToProfesorado('<xsl:value-of select="languageUtil:get($locale,'upv-ehu.doctorate.profesorado.url')"/>?findByTeam=<xsl:value-of select="normalize-space($descripcion)"/>');</xsl:attribute>
										<xsl:attribute name="data-path"><xsl:value-of select="normalize-space($descripcion)"/></xsl:attribute>
										<xsl:attribute name="href">javascript:redirectToProfesorado('<xsl:value-of select="languageUtil:get($locale,'upv-ehu.doctorate.profesorado.url')"/>?findByTeam=', '<xsl:value-of select="normalize-space($descripcion)"/>');</xsl:attribute>
										<xsl:attribute name="data-path"><xsl:value-of select="normalize-space($descripcion)"/></xsl:attribute>
										<xsl:value-of select="normalize-space($descripcion)"/>
										
									</a>
									
																										
									
								</td>								
								<td>
									<ul class="unstyled">
										<xsl:for-each select="ehu:lineas/ehu:lineaInvestigacion">
											<xsl:element name="li">
												<xsl:attribute name="class">m-b-20</xsl:attribute>
												<xsl:value-of select="ehu:descripcion"/>
											</xsl:element>
										</xsl:for-each>
						            </ul>
								</td>
							</tr>
						</xsl:for-each>
					</tbody>
				</xsl:element>
			</xsl:element>
		</xsl:element>
				
		<xsl:text disable-output-escaping="yes"> 
			<![CDATA[    
				<script type="text/javascript"> 
					function redirectToProfesorado(text,escape) {
						
						/* Escapamos con encodeURIComponent en lugar de encodeURI ya que escapa más carácteres (incidencia con "+" en el nombre de departamento) */
						var url = encodeURIComponent(escape);
												
						var decodeurl = (new URL(document.location + text + url));
						
						window.location.href = decodeurl;
					}
				</script> 
			]]>
		</xsl:text>
						
				
	</xsl:template>
	
	
	<xsl:template name="programaOrganizacion">
		<article namespace="xmlns:ehu">
			<xsl:attribute name="class">information</xsl:attribute>
			<xsl:element name="section">
				<xsl:attribute name="class">upv-ehu-image-description</xsl:attribute>
				<xsl:element name="div">
					<xsl:attribute name="class">main</xsl:attribute>
					
					<xsl:element name="h2"><xsl:value-of select="languageUtil:get($locale,'ehu.organization')"/></xsl:element>
					
					<xsl:element name="h3">
						<xsl:attribute name="class">t16 subrayado-grey</xsl:attribute>
						<i class="fa fa-check grey m-r-20" ><xsl:value-of select="$white_space" /></i>
						<xsl:element name="strong">
							<xsl:attribute name="class">t19</xsl:attribute>
							<xsl:value-of select="languageUtil:get($locale,'upv-ehu.doctorate.coordiacion.doctorado')"/>
						</xsl:element>
					</xsl:element>
					<xsl:element name="div">
						<xsl:attribute name="class">t16 m-b-40 m-l-40 m-t-10</xsl:attribute>
						<xsl:element name="p"><xsl:value-of select="$doctorado/ehu:responsable/ehu:nombre"/></xsl:element>
					</xsl:element>
					
					<xsl:element name="h3">
						<xsl:attribute name="class">t16 subrayado-grey m-t-40</xsl:attribute>
						<i class="fa fa-check grey m-r-20"><xsl:value-of select="$white_space" /></i>
						<xsl:element name="strong">
							<xsl:attribute name="class">t19</xsl:attribute>
							<xsl:value-of select="languageUtil:get($locale,'ehu.comision')"/>
						</xsl:element>
					</xsl:element>
					<xsl:element name="div">
						<xsl:attribute name="class">t16 m-b-40 m-l-40 m-t-10</xsl:attribute>
						<xsl:element name="dl">
							<xsl:for-each select="$doctorado/ehu:comisiones/ehu:comision/ehu:miembros/ehu:miembro">
								<xsl:element name="dd"><xsl:value-of select="ehu:desCargo"/>: <xsl:value-of select="ehu:nombre"/></xsl:element>
							</xsl:for-each>
						</xsl:element>
					</xsl:element>
					
					<xsl:element name="h3">
						<xsl:attribute name="class">t16 subrayado-grey m-t-40</xsl:attribute>
						<i class="fa fa-check grey m-r-20"><xsl:value-of select="$white_space" /></i>
						<xsl:element name="strong">
							<xsl:attribute name="class">t19</xsl:attribute>
							<xsl:value-of select="languageUtil:get($locale,'ehu.xsl-content.doctorado.recursosMateriales')"/>
						</xsl:element>
					</xsl:element>
					
					<xsl:element name="div">
						<xsl:attribute name="class">new-upv-acordeon upv-acordeon accordion</xsl:attribute>
						
						<xsl:if test="$doctorado/ehu:recursosMateriales/ehu:aulas">
							<xsl:element name="div">
								<xsl:attribute name="class">accordion-group m-l-20</xsl:attribute>
								<xsl:element name="div">
									<xsl:attribute name="class">accordion-heading</xsl:attribute>
									<h4>
									<xsl:element name="a">
										<xsl:attribute name="class">accordion-toggle collapsed</xsl:attribute>
										<xsl:attribute name="data-toggle">collapse</xsl:attribute>
										<xsl:attribute name="href">#collapse1</xsl:attribute>
										<xsl:attribute name="aria-controls">collapse1</xsl:attribute>
										<xsl:attribute name="id">opcion1</xsl:attribute>
										<xsl:attribute name="aria-expanded">false</xsl:attribute>
										<xsl:value-of select="languageUtil:get($locale,'ehu.aulas')" />
									</xsl:element>
									</h4>
								</xsl:element>
								<xsl:element name="div">
									<xsl:attribute name="id">collapse1</xsl:attribute>
									<xsl:attribute name="role">region</xsl:attribute>
									<xsl:attribute name="aria-labelledby">opcion1</xsl:attribute>
									<xsl:attribute name="class">collapse</xsl:attribute>
			      					<xsl:element name="div">
										<xsl:attribute name="class">m-l-20 m-t-20 m-b-20</xsl:attribute>
										<xsl:call-template name="transform_text">
											<xsl:with-param name="text" select="$doctorado/ehu:recursosMateriales/ehu:aulas"/>
				      					</xsl:call-template>
			      					</xsl:element>
								</xsl:element>
							</xsl:element>
						</xsl:if>
						
						<xsl:if test="$doctorado/ehu:recursosMateriales/ehu:laboratorios">
							<xsl:element name="div">
								<xsl:attribute name="class">accordion-group m-l-20</xsl:attribute>
								<xsl:element name="div">
									<xsl:attribute name="class">accordion-heading</xsl:attribute>
									<h4>
									<xsl:element name="a">
										<xsl:attribute name="class">accordion-toggle collapsed</xsl:attribute>
										<xsl:attribute name="data-toggle">collapse</xsl:attribute>
										<xsl:attribute name="href">#collapse2</xsl:attribute>
										<xsl:attribute name="aria-controls">collapse2</xsl:attribute>
										<xsl:attribute name="id">opcion2</xsl:attribute>
										<xsl:attribute name="aria-expanded">false</xsl:attribute>
										<xsl:value-of select="languageUtil:get($locale,'ehu.laboratorios')" />
									</xsl:element>
									</h4>
								</xsl:element>
								<xsl:element name="div">
									<xsl:attribute name="id">collapse2</xsl:attribute>
									<xsl:attribute name="role">region</xsl:attribute>
									<xsl:attribute name="aria-labelledby">opcion2</xsl:attribute>
									<xsl:attribute name="class">collapse</xsl:attribute>
									<xsl:element name="div">
										<xsl:attribute name="class">m-l-20 m-t-20 m-b-20</xsl:attribute>
										<xsl:call-template name="transform_text">
											<xsl:with-param name="text" select="$doctorado/ehu:recursosMateriales/ehu:laboratorios"/>
				      					</xsl:call-template>
			      					</xsl:element>
								</xsl:element>
							</xsl:element>
						</xsl:if>
						
						<xsl:if test="$doctorado/ehu:recursosMateriales/ehu:biblioteca">
							<xsl:element name="div">
								<xsl:attribute name="class">accordion-group m-l-20</xsl:attribute>
								<xsl:element name="div">
									<xsl:attribute name="class">accordion-heading</xsl:attribute>
									<h4>
									<xsl:element name="a">
										<xsl:attribute name="class">accordion-toggle collapsed</xsl:attribute>
										<xsl:attribute name="data-toggle">collapse</xsl:attribute>
										<xsl:attribute name="href">#collapse3</xsl:attribute>
										<xsl:attribute name="aria-controls">collapse3</xsl:attribute>
										<xsl:attribute name="id">opcion3</xsl:attribute>
										<xsl:attribute name="aria-expanded">false</xsl:attribute>
										<xsl:value-of select="languageUtil:get($locale,'ehu.biblioteca')" />
									</xsl:element>
									</h4>
								</xsl:element>
								<xsl:element name="div">
									<xsl:attribute name="id">collapse3</xsl:attribute>
									<xsl:attribute name="role">region</xsl:attribute>
									<xsl:attribute name="aria-labelledby">opcion3</xsl:attribute>
									<xsl:attribute name="class">collapse</xsl:attribute>
			      					<xsl:element name="div">
										<xsl:attribute name="class">m-l-20 m-t-20 m-b-20</xsl:attribute>
										<xsl:call-template name="transform_text">
											<xsl:with-param name="text" select="$doctorado/ehu:recursosMateriales/ehu:biblioteca"/>
				      					</xsl:call-template>
			      					</xsl:element>
								</xsl:element>
							</xsl:element>
						</xsl:if>
						
					</xsl:element>
					
					<xsl:if test="$doctorado/ehu:entidadesColaboradoras">
						<xsl:element name="div">
							<xsl:attribute name="class">bg-dark m-b-30 m-t-40</xsl:attribute>
							<xsl:if test="$doctorado/ehu:entidadesColaboradoras/ehu:entidadColaboradora[ehu:indConConvenio=1]">
								<xsl:element name="div">
									<xsl:attribute name="class">p-20 entidades subrayado-grey</xsl:attribute>
									<xsl:element name="h3">
										<xsl:attribute name="class">subrayado-grey</xsl:attribute>
										<xsl:value-of select="languageUtil:get($locale,'ehu.entidadesColabora')"/>
									</xsl:element>
									<xsl:element name="ul">
										<xsl:attribute name="class">unstyled</xsl:attribute>
										<xsl:for-each select="$doctorado/ehu:entidadesColaboradoras/ehu:entidadColaboradora[ehu:indConConvenio=1]">
											<li><xsl:value-of select="ehu:descripcion"/></li>
										</xsl:for-each>
									</xsl:element>
								</xsl:element>
							</xsl:if>
							<xsl:if test="$doctorado/ehu:entidadesColaboradoras/ehu:entidadColaboradora[ehu:indConConvenio=0]">
								<xsl:element name="div">
									<xsl:attribute name="class">p-20 entidades subrayado-grey</xsl:attribute>
									<xsl:element name="h3">
										<xsl:attribute name="class">subrayado-grey</xsl:attribute>
										<xsl:value-of select="languageUtil:get($locale,'ehu.otrasEntidColab')"/>
									</xsl:element>
									<xsl:element name="ul">
										<xsl:attribute name="class">unstyled</xsl:attribute>
										<xsl:for-each select="$doctorado/ehu:entidadesColaboradoras/ehu:entidadColaboradora[ehu:indConConvenio=0]">
											<li><xsl:value-of select="ehu:descripcion"/></li>
										</xsl:for-each>
									</xsl:element>
								</xsl:element>
							</xsl:if>
						</xsl:element>
					</xsl:if>
					
				</xsl:element>
			</xsl:element>
		</article>
	</xsl:template>	  


	<xsl:template name="programaCompetencias">
		<article namespace="xmlns:ehu">
			<xsl:attribute name="class">information</xsl:attribute>
			<xsl:element name="section">
				<xsl:attribute name="class">upv-ehu-image-description</xsl:attribute>
				<xsl:element name="div">
					<xsl:attribute name="class">main</xsl:attribute>
					
					<xsl:element name="h2"><xsl:value-of select="languageUtil:get($locale,'ehu.competencias')"/></xsl:element>
					<xsl:element name="h3">
						<xsl:attribute name="class">subrayado-grey</xsl:attribute>
						<xsl:value-of select="languageUtil:get($locale,'ehu.xsl-content.doctorado.competenciasBasicas')"/>
					</xsl:element>
					<xsl:element name="ul">
						<xsl:for-each select="$doctorado/ehu:competencias/ehu:competencia">
								<xsl:element name="li"><xsl:value-of select="."/></xsl:element>
						</xsl:for-each>
					</xsl:element>
					<xsl:element name="p"><xsl:attribute name="class">m-b-60</xsl:attribute></xsl:element>
					<xsl:element name="h3">
						<xsl:attribute name="class">subrayado-grey</xsl:attribute>
						<xsl:value-of select="languageUtil:get($locale,'ehu.xsl-content.doctorado.capacidades')"/>
					</xsl:element>
					<xsl:element name="ul">
						<xsl:for-each select="$doctorado/ehu:capacidades/ehu:capacidad">
								<xsl:element name="li"><xsl:value-of select="."/></xsl:element>
						</xsl:for-each>
					</xsl:element>
				</xsl:element>
			</xsl:element>
		</article>
	</xsl:template>
		  
	
	
	<xsl:template name="programaActividades">
		<article namespace="xmlns:ehu">
			<xsl:attribute name="class">information</xsl:attribute>
			<xsl:element name="section">
				<xsl:attribute name="class">upv-ehu-image-description</xsl:attribute>
				<xsl:element name="div">
					<xsl:attribute name="class">main</xsl:attribute>
					<xsl:element name="h2"><xsl:value-of select="languageUtil:get($locale,'upv-ehu.doctorate.plan.actividades')"/></xsl:element>
					<xsl:element name="h3">
						<xsl:attribute name="class">subrayado-grey</xsl:attribute>
						<xsl:value-of select="languageUtil:get($locale,'upv-ehu.doctorate.plan.formativo')"/>
					</xsl:element>
					
					<xsl:element name="h4">
						<xsl:attribute name="class">t16 m-t-20 m-b-20 desmayusculas</xsl:attribute>
						<i class="fa fa-check m-r-20"><xsl:value-of select="$white_space" /></i>
						<xsl:element name="strong">
							<xsl:attribute name="class">t19</xsl:attribute>
							<xsl:value-of select="languageUtil:get($locale,'upv-ehu.doctorate.plan.mde')"/>
						</xsl:element>
					</xsl:element>
					
					<xsl:choose>
						<xsl:when test="$doctorado/ehu:actividadesFormativas/ehu:actividadFormativa/ehu:indEscuela = 1">
							<xsl:element name="div">
								<xsl:attribute name="class">new-upv-acordeon upv-acordeon accordion</xsl:attribute>
								<xsl:for-each select="$doctorado/ehu:actividadesFormativas/ehu:actividadFormativa[ehu:indEscuela='1']">
									<xsl:element name="div">
										<xsl:attribute name="class">accordion-group</xsl:attribute>
										<xsl:element name="div">
											<xsl:attribute name="class">accordion-heading</xsl:attribute>
											<h5>
											<xsl:element name="a">
												<xsl:attribute name="class">accordion-toggle collapsed</xsl:attribute>
												<xsl:attribute name="data-toggle">collapse</xsl:attribute>
												<xsl:attribute name="href">#collapse1<xsl:value-of select="position()"/></xsl:attribute>
												<xsl:attribute name="aria-controls">collapse1<xsl:value-of select="position()"/></xsl:attribute>
												<xsl:attribute name="id">opcion1<xsl:value-of select="position()"/></xsl:attribute>
												<xsl:attribute name="aria-expanded">false</xsl:attribute>
												<xsl:value-of select="ehu:titulo" />
											</xsl:element>
											</h5>
										</xsl:element>
										<xsl:element name="div">
											<xsl:attribute name="id">collapse1<xsl:value-of select="position()"/></xsl:attribute>
											<xsl:attribute name="role">region</xsl:attribute>
											<xsl:attribute name="aria-labelledby">opcion1<xsl:value-of select="position()"/></xsl:attribute>
											<xsl:attribute name="class">collapse</xsl:attribute>
											<xsl:element name="div">
												<xsl:attribute name="class">accordion-inner m-l-20 m-r-20</xsl:attribute>
												<xsl:element name="h6">
													<xsl:attribute name="class">m-b-0 tit-h6-accor</xsl:attribute>
													<strong><xsl:value-of select="languageUtil:get($locale,'ehu.xsl-content.doctorado.caracter')"/></strong>
												</xsl:element>
												<p><xsl:value-of select="ehu:desCaracter" /></p>
												<xsl:element name="h6">
													<xsl:attribute name="class">m-b-0 tit-h6-accor</xsl:attribute>
													<strong><xsl:value-of select="languageUtil:get($locale,'ehu.Horas')"/></strong>
												</xsl:element>
												<p><xsl:value-of select="ehu:horasDuracion" /></p>
												<xsl:element name="h6">
													<xsl:attribute name="class">m-b-0 tit-h6-accor</xsl:attribute>
													<strong><xsl:value-of select="languageUtil:get($locale,'ehu.description')"/></strong>
												</xsl:element>
												<p><xsl:value-of select="ehu:descripcion" /></p>
												<xsl:element name="h6">
													<xsl:attribute name="class">m-b-0 tit-h6-accor</xsl:attribute>
													<strong><xsl:value-of select="languageUtil:get($locale,'upv-ehu.doctorate.resultados')"/></strong>
												</xsl:element>
												<p><xsl:value-of select="ehu:resultados" /></p>
												<xsl:element name="h6">
													<xsl:attribute name="class">m-b-0 tit-h6-accor</xsl:attribute>
													<strong><xsl:value-of select="languageUtil:get($locale,'ehu.sistemasEvaluacion')"/></strong>
												</xsl:element>
												<p><xsl:value-of select="ehu:sistemasEvaluacion" /></p>
											</xsl:element>
										</xsl:element>
									</xsl:element>
								</xsl:for-each>
							</xsl:element>
						</xsl:when>
						<xsl:otherwise>
							<p><xsl:value-of select="languageUtil:get($locale,'upv-ehu.doctorate.plan.none')"/></p>
						</xsl:otherwise>
					</xsl:choose>	
					
					<xsl:element name="h4">
						<xsl:attribute name="class">t16 m-t-40 m-b-20 desmayusculas</xsl:attribute>
						<i class="fa fa-check m-r-20"><xsl:value-of select="$white_space" /></i>
						<xsl:element name="strong">
							<xsl:attribute name="class">t19</xsl:attribute>
							<xsl:value-of select="languageUtil:get($locale,'upv-ehu.doctorate.plan.programa')"/>
						</xsl:element>
					</xsl:element>
					
					<xsl:choose>
						<xsl:when test="$doctorado/ehu:actividadesFormativas/ehu:actividadFormativa/ehu:indEscuela = 0">
							<xsl:element name="div">
								<xsl:attribute name="class">new-upv-acordeon upv-acordeon accordion</xsl:attribute>
								<xsl:for-each select="$doctorado/ehu:actividadesFormativas/ehu:actividadFormativa[ehu:indEscuela='0']">
									<xsl:element name="div">
										<xsl:attribute name="class">accordion-group</xsl:attribute>
										<xsl:element name="div">
											<xsl:attribute name="class">accordion-heading</xsl:attribute>
											<h5>
											<xsl:element name="a">
												<xsl:attribute name="class">accordion-toggle collapsed</xsl:attribute>
												<xsl:attribute name="data-toggle">collapse</xsl:attribute>
												<xsl:attribute name="href">#collapse2<xsl:value-of select="position()"/></xsl:attribute>
												<xsl:attribute name="aria-controls">collapse2<xsl:value-of select="position()"/></xsl:attribute>
												<xsl:attribute name="id">opcion2<xsl:value-of select="position()"/></xsl:attribute>
												<xsl:attribute name="aria-expanded">false</xsl:attribute>
												<xsl:value-of select="ehu:titulo" />
											</xsl:element>
											</h5>
										</xsl:element>
										<xsl:element name="div">
											<xsl:attribute name="id">collapse2<xsl:value-of select="position()"/></xsl:attribute>
											<xsl:attribute name="role">region</xsl:attribute>
											<xsl:attribute name="aria-labelledby">opcion2<xsl:value-of select="position()"/></xsl:attribute>
											<xsl:attribute name="class">collapse</xsl:attribute>
											<xsl:element name="div">
												<xsl:attribute name="class">accordion-inner m-l-20 m-r-20</xsl:attribute>
												<xsl:element name="h6">
													<xsl:attribute name="class">m-b-0 tit-h6-accor</xsl:attribute>
													<strong><xsl:value-of select="languageUtil:get($locale,'ehu.xsl-content.doctorado.caracter')"/></strong>
												</xsl:element>
												<p><xsl:value-of select="ehu:desCaracter" /></p>
												<xsl:element name="h6">
													<xsl:attribute name="class">m-b-0 tit-h6-accor</xsl:attribute>
													<strong><xsl:value-of select="languageUtil:get($locale,'ehu.Horas')"/></strong>
												</xsl:element>
												<p><xsl:value-of select="ehu:horasDuracion" /></p>
												<xsl:element name="h6">
													<xsl:attribute name="class">m-b-0 tit-h6-accor</xsl:attribute>
													<strong><xsl:value-of select="languageUtil:get($locale,'ehu.description')"/></strong>
												</xsl:element>
												<p><xsl:value-of select="ehu:descripcion" /></p>
												<xsl:element name="h6">
													<xsl:attribute name="class">m-b-0 tit-h6-accor</xsl:attribute>
													<strong><xsl:value-of select="languageUtil:get($locale,'upv-ehu.doctorate.resultados')"/></strong>
												</xsl:element>
												<p><xsl:value-of select="ehu:resultados" /></p>
												<xsl:element name="h6">
													<xsl:attribute name="class">m-b-0 tit-h6-accor</xsl:attribute>
													<strong><xsl:value-of select="languageUtil:get($locale,'ehu.sistemasEvaluacion')"/></strong>
												</xsl:element>
												<p><xsl:value-of select="ehu:sistemasEvaluacion" /></p>
											</xsl:element>
										</xsl:element>
									</xsl:element>
								</xsl:for-each>
							</xsl:element>
						</xsl:when>
						<xsl:otherwise>
							<p><xsl:value-of select="languageUtil:get($locale,'upv-ehu.doctorate.plan.none')"/></p>
						</xsl:otherwise>
					</xsl:choose>
					
				</xsl:element>
			</xsl:element>
		</article>
	</xsl:template>	     

	   
	<xsl:template name="profesorado">
	
		<article namespace="xmlns:ehu">
			<xsl:attribute name="class">information caja-sin-fondo caja-sin-padding</xsl:attribute>
			<xsl:element name="section">
				<xsl:attribute name="class">upv-ehu-image-description</xsl:attribute>
				<xsl:element name="div">
					<xsl:attribute name="class">main</xsl:attribute>
					
					<xsl:element name="div">
						<xsl:attribute name="class">additional-buttons</xsl:attribute>
						<xsl:element name="ul">
							<xsl:attribute name="id">doctorate-order-buttons</xsl:attribute>
							<xsl:element name="li">
								<xsl:attribute name="class">additional-active</xsl:attribute>
								<xsl:element name="a">
									<xsl:attribute name="id">link-orderText</xsl:attribute>
									<xsl:attribute name="href">javascript:void(0);</xsl:attribute>
									<xsl:attribute name="onclick">sortProfesorado(0, 'A-Z')</xsl:attribute>
									A-Z
								</xsl:element>
							</xsl:element>
							<xsl:element name="li">
								<xsl:element name="a">
									<xsl:attribute name="href">javascript:void(0);</xsl:attribute>
									<xsl:attribute name="onclick">sortProfesorado(1, '<xsl:value-of select="languageUtil:get($locale,'upv-ehu.doctorate.orden.equipo')"/>')</xsl:attribute>
									<xsl:value-of select="languageUtil:get($locale,'upv-ehu.doctorate.orden.equipo')"/>
								</xsl:element>
							</xsl:element>		
						</xsl:element>
					</xsl:element>	
					
					<xsl:element name="div">
						<xsl:attribute name="class">f-13 menu-orden-doctorado ehu-sans pointer-studydark</xsl:attribute>
						
						<xsl:for-each select="$doctorado/ehu:equiposInvestigacion/ehu:equipoInvestigacion">
							<xsl:element name="a">
								<!-- Normalizamos la descripción para eliminar los espacios vacíos por delante y por detrás. Por si acaso está mal metido en Gaur -->
								<xsl:variable name="descripcionNormalize" select="ehu:descripcion"/>
								<xsl:attribute name="id"><xsl:value-of select="normalize-space($descripcionNormalize)"/></xsl:attribute>
								<xsl:attribute name="onclick">filterProfesorado(this, 1,'<xsl:value-of select="normalize-space($descripcionNormalize)"/>')</xsl:attribute>
								<xsl:attribute name="aria-controls"><xsl:value-of select="normalize-space($descripcionNormalize)"/></xsl:attribute>
								<xsl:attribute name="aria-expanded">false</xsl:attribute>
								<xsl:value-of select="normalize-space($descripcionNormalize)"/>
								
								
							</xsl:element>
							<xsl:if test="position() != last()"><xsl:value-of select="$white_space" />|<xsl:value-of select="$white_space" /></xsl:if>
						</xsl:for-each>
						
					</xsl:element>					
				
				</xsl:element>
			</xsl:element>
		</article>
	
		<xsl:element name="article"  namespace="xmlns:ehu">
			<xsl:attribute name="class">information</xsl:attribute>
			<xsl:element name="section">
				<xsl:attribute name="class">upv-ehu-image-description</xsl:attribute>
				<xsl:element name="div">
					<xsl:attribute name="class">main</xsl:attribute>
					
					<xsl:element name="h2">
						<xsl:attribute name="id">h2-profesorado-doc</xsl:attribute>
						A-Z
					</xsl:element>
					
					<xsl:element name="table">
						<xsl:attribute name="class">profesorado-doc</xsl:attribute>
						<xsl:element name="tbody">
							<xsl:for-each select="$doctorado/ehu:equiposInvestigacion/ehu:equipoInvestigacion">
								<xsl:variable name="departamento" select="ehu:descripcion"/>
								<xsl:for-each select="ehu:profesorado/ehu:profesor[ehu:indUpv='1']">
									<xsl:sort select="ehu:nombre" data-type="text" order="descending" />
									<xsl:element name="tr">
										<xsl:element name="td">
											<xsl:element name="a">
												<xsl:attribute name="href">?p_redirect=fichaPDI&amp;p_idp=<xsl:value-of select="ehu:idp"/></xsl:attribute>
											 	<xsl:call-template name="CamelCase">
													<xsl:with-param name="text"><xsl:value-of select="ehu:nombre" /></xsl:with-param>
												</xsl:call-template>
											</xsl:element>
										</xsl:element>
										<!-- Normalizamos la descripción para eliminar los espacios vacíos por delante y por detrás. Por si acaso está mal metido en Gaur -->
										 <xsl:element name="td"><xsl:value-of select="normalize-space($departamento)"/></xsl:element>
									</xsl:element>
								</xsl:for-each>
							</xsl:for-each>
						</xsl:element>
					</xsl:element>
										
					<xsl:element name="h3">
						<xsl:attribute name="id">profesorado-subt-doc</xsl:attribute>						
						<xsl:attribute name="class">profesorado-subt-doc</xsl:attribute>						
						<xsl:value-of select="stringUtil:toUpperCase(languageUtil:get($locale,'ehu.profesoradoAjeno'))"/>
					</xsl:element>
					
					<xsl:element name="table">
						<xsl:attribute name="class">profesorado-doc</xsl:attribute>
						<xsl:element name="tbody">							
							<xsl:for-each select="$doctorado/ehu:equiposInvestigacion/ehu:equipoInvestigacion">
								<xsl:variable name="departamento" select="ehu:descripcion"/>
								<xsl:for-each select="ehu:profesorado/ehu:profesor[ehu:indUpv='0']">
									<xsl:sort select="ehu:nombre" data-type="text" order="descending" />
									<xsl:element name="tr">
										<xsl:attribute name="class">tr-profesorado-subt-doc</xsl:attribute>
										<xsl:element name="td">
											<xsl:element name="a">
											
												<xsl:attribute name="href">?p_cod_idioma=es&amp;p_cod_proceso=doctorate&amp;p_nav=605&amp;p_cod_propuesta=1972&amp;p_redirect=dameProfesorAjeno&amp;p_idp=<xsl:value-of select="ehu:idp"/>&amp;p_dpa=<xsl:value-of select="ehu:idp"/></xsl:attribute>
												
											 	<xsl:call-template name="CamelCase">
													<xsl:with-param name="text"><xsl:value-of select="ehu:nombre" /></xsl:with-param>
												</xsl:call-template>
											</xsl:element>
										</xsl:element>
										<!-- Normalizamos la descripción para eliminar los espacios vacíos por delante y por detrás. Por si acaso está mal metido en Gaur -->
										<xsl:element name="td"><xsl:value-of select="normalize-space($departamento)"/></xsl:element>
										
									</xsl:element>
								</xsl:for-each>
							</xsl:for-each>
							
						</xsl:element>
					</xsl:element>
					
				</xsl:element>
			</xsl:element>
		</xsl:element>
		
		
		<xsl:text disable-output-escaping="yes"> 
			<![CDATA[    
				<script type="text/javascript"> 
				
					function sortProfesorado (columnPos, text) {
						var menuOrdenDoctorados = document.querySelectorAll(".menu-orden-doctorado a");
						for (i = 0; i < menuOrdenDoctorados.length; i++) {
							menuOrdenDoctorados[i].removeAttribute('aria-disabled');
							menuOrdenDoctorados[i].setAttribute("aria-expanded","false");
							menuOrdenDoctorados[i].className = "";
						}
						
						document.getElementById("h2-profesorado-doc").textContent=text;
					
						var elems = document.querySelectorAll('#doctorate-order-buttons li');
						Array.prototype.forEach.call(elems, function(el) {
						    el.classList.remove("additional-active");
						});
						elems[columnPos].classList.add("additional-active");
						
						Array.prototype.forEach.call(document.getElementsByClassName("profesorado-doc"), function(table) {
							 var tbl = table.tBodies[0];
							 var store = [];
							 for(var i=0, len=tbl.rows.length; i<len; i++){
								var row = tbl.rows[i];
								var sortnr = row.cells[columnPos].textContent || row.cells[columnPos].innerText;
								row.style.display = "";
								store.push([sortnr, row]);
							}
							store.sort(function(a,b){
								return (a[0]).localeCompare(b[0]);
							});
							for(var i=0, len=store.length; i<len; i++){
								tbl.appendChild(store[i][1]);
							}
							store = null;
						});
						hideSubtitle();
					}
					sortProfesorado(0,document.getElementById("link-orderText").textContent);
					
					function filterProfesorado (element, columnPos, text) {
					
						var elems = document.querySelectorAll('#doctorate-order-buttons li');
						Array.prototype.forEach.call(elems, function(el) {
						    el.classList.remove("additional-active");
						});
					
						if (!element.hasAttribute('aria-disabled')){
							var menuOrdenDoctorados = document.querySelectorAll(".menu-orden-doctorado a");
							for (i = 0; i < menuOrdenDoctorados.length; i++) {
								menuOrdenDoctorados[i].removeAttribute('aria-disabled');
								menuOrdenDoctorados[i].setAttribute("aria-expanded","false");
								menuOrdenDoctorados[i].className = "";
							}
							
							element.setAttribute("aria-disabled","true");
							element.setAttribute("aria-expanded","true");
							
							element.className = "font-red";
							
							document.getElementById("h2-profesorado-doc").textContent=text;
						}
					
						Array.prototype.forEach.call(document.getElementsByClassName("profesorado-doc"), function(table) {
							 var tbl = table.tBodies[0];
							 var store = [];
							 for(var i=0, len=tbl.rows.length; i<len; i++){
								var row = tbl.rows[i];
								var sortnr = row.cells[columnPos].textContent || row.cells[columnPos].innerText;
								row.style.display = "";
								if (sortnr.toLowerCase().trim()!=text.toLowerCase().trim()) {
									row.style.display = "none";
								}
								store.push([sortnr, row]);
							}
							for(var i=0, len=store.length; i<len; i++){
								tbl.appendChild(store[i][1]);
							}
							store = null;
						});
						
						hideSubtitle();
					}

					function hideSubtitle () {
						var hideSub = true;
						Array.prototype.forEach.call(document.getElementsByClassName("tr-profesorado-subt-doc"), function(elem) {
							 
							 if (elem.style.display != "none") {
							 	hideSub = false;
							 }
						});
						
						if (hideSub) {
							document.getElementById("profesorado-subt-doc").style.display = "none";
						} else {
							document.getElementById("profesorado-subt-doc").style.display = "block";
						}
					}
							
					window.onload = function(){
						hideSubtitle();
						var params = (new URL(document.location)).searchParams;
						var filterByTeam = params.get("findByTeam");
						if (filterByTeam) {
							var element = document.getElementById(filterByTeam);	
							
							var filterByTeamTrim = filterByTeam.trim();
							var elementTrim = element.textContent.trim();
								
							if (filterByTeamTrim != null && elementTrim != null && filterByTeamTrim == elementTrim) {
								filterProfesorado(element, 1, filterByTeam);
							}
						}
					}
					
				</script> 
			]]>
		</xsl:text>
		
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
		
		<xsl:element name="div">
			<xsl:attribute name="class">m-b-30</xsl:attribute>
			<xsl:element name="div">
				<xsl:attribute name="class">bg-white p-20 profesorado</xsl:attribute>
				<h2><xsl:value-of select="$doctorado/ehu:profesorado/ehu:profesor/ehu:nombre"/></h2>
				<xsl:element name="div">
					<dl>
						<xsl:if test="$doctorado/ehu:profesorado/ehu:profesor/ehu:desOrganismo">
							<dt><xsl:value-of select="languageUtil:get($locale,'ehu.organismo')"/></dt>
							<dd><xsl:value-of select="$doctorado/ehu:profesorado/ehu:profesor/ehu:desOrganismo"/></dd>									
						</xsl:if>
						
						<xsl:if test="$doctorado/ehu:profesorado/ehu:profesor/ehu:email">
							<dt><xsl:value-of select="languageUtil:get($locale,'ehu.email')"/></dt>
							<dd>
								<xsl:element name="a">
									<xsl:attribute name="href">mailto:<xsl:value-of select="$doctorado/ehu:profesorado/ehu:profesor/ehu:email"/></xsl:attribute>
									<xsl:attribute name="class">email-icon-doc</xsl:attribute>
									<xsl:value-of select="$doctorado/ehu:profesorado/ehu:profesor/ehu:email"/>
								</xsl:element>
							</dd>									
						</xsl:if>

					</dl>
				</xsl:element>
								
			</xsl:element>
		</xsl:element>
	
	</xsl:template>
	
    <xsl:template name="matriculaPerfilAcceso">
    	
    	<xsl:element name="div">
			<xsl:attribute name="class">new-upv-acordeon upv-acordeon accordion bg-white</xsl:attribute>
			<xsl:attribute name="style">margin-top: -5px</xsl:attribute>
			<xsl:if test="$doctorado/ehu:complementosFormativos">
				<xsl:element name="div">
					<xsl:attribute name="class">accordion-group</xsl:attribute>
					<xsl:element name="div">
						<xsl:attribute name="class">accordion-heading</xsl:attribute>
						<h5>
						<xsl:element name="a">
							<xsl:attribute name="class">accordion-toggle collapsed</xsl:attribute>
							<xsl:attribute name="data-toggle">collapse</xsl:attribute>
							<xsl:attribute name="href">#collapse1</xsl:attribute>
							<xsl:attribute name="aria-controls">collapse1</xsl:attribute>
							<xsl:attribute name="id">opcion1</xsl:attribute>
							<xsl:attribute name="aria-expanded">false</xsl:attribute>
							<xsl:value-of select="languageUtil:get($locale,'ehu.xsl-content.doctorado.complementos')" />
						</xsl:element>
						</h5>
					</xsl:element>
					<xsl:element name="div">
						<xsl:attribute name="id">collapse1</xsl:attribute>
						<xsl:attribute name="role">region</xsl:attribute>
						<xsl:attribute name="aria-labelledby">opcion1</xsl:attribute>
						<xsl:attribute name="class">collapse</xsl:attribute>
      					<xsl:element name="div">
							<xsl:attribute name="class">m-l-20 m-t-20 m-b-20</xsl:attribute>
							<xsl:call-template name="transform_text">
								<xsl:with-param name="text" select="$doctorado/ehu:complementosFormativos"/>
	      					</xsl:call-template>
      					</xsl:element>
					</xsl:element>
				</xsl:element>
			</xsl:if>
			
			<xsl:if test="$doctorado/ehu:criteriosAdmision">
				<xsl:element name="div">
					<xsl:attribute name="class">accordion-group</xsl:attribute>
					<xsl:element name="div">
						<xsl:attribute name="class">accordion-heading</xsl:attribute>
						<h5>
						<xsl:element name="a">
							<xsl:attribute name="class">accordion-toggle collapsed</xsl:attribute>
							<xsl:attribute name="data-toggle">collapse</xsl:attribute>
							<xsl:attribute name="href">#collapse2</xsl:attribute>
							<xsl:attribute name="aria-controls">collapse2</xsl:attribute>
							<xsl:attribute name="id">opcion2</xsl:attribute>
							<xsl:attribute name="aria-expanded">false</xsl:attribute>
							<xsl:value-of select="languageUtil:get($locale,'ehu.xsl-content.doctorado.criterios')" />
						</xsl:element>
						</h5>
					</xsl:element>
					<xsl:element name="div">
						<xsl:attribute name="id">collapse2</xsl:attribute>
						<xsl:attribute name="role">region</xsl:attribute>
						<xsl:attribute name="aria-labelledby">opcion2</xsl:attribute>
						<xsl:attribute name="class">collapse</xsl:attribute>
      					<xsl:element name="div">
							<xsl:attribute name="class">m-l-20 m-t-20 m-b-20</xsl:attribute>
							<xsl:call-template name="transform_text">
								<xsl:with-param name="text" select="$doctorado/ehu:criteriosAdmision"/>
	      					</xsl:call-template>
      					</xsl:element>
					</xsl:element>
				</xsl:element>
			</xsl:if>
			
			<xsl:if test="$doctorado/ehu:complementosFormativos">
				<xsl:element name="div">
					<xsl:attribute name="class">accordion-group</xsl:attribute>
					<xsl:element name="div">
						<xsl:attribute name="class">accordion-heading</xsl:attribute>
						<h5>
						<xsl:element name="a">
							<xsl:attribute name="class">accordion-toggle collapsed</xsl:attribute>
							<xsl:attribute name="data-toggle">collapse</xsl:attribute>
							<xsl:attribute name="href">#collapse3</xsl:attribute>
							<xsl:attribute name="aria-controls">collapse3</xsl:attribute>
							<xsl:attribute name="id">opcion3</xsl:attribute>
							<xsl:attribute name="aria-expanded">false</xsl:attribute>
							<xsl:value-of select="languageUtil:get($locale,'ehu.xsl-content.doctorado.idiomas')" />
						</xsl:element>
						</h5>
					</xsl:element>
					<xsl:element name="div">
						<xsl:attribute name="id">collapse3</xsl:attribute>
						<xsl:attribute name="role">region</xsl:attribute>
						<xsl:attribute name="aria-labelledby">opcion3</xsl:attribute>
						<xsl:attribute name="class">collapse</xsl:attribute>
      					<xsl:element name="div">
							<xsl:attribute name="class">m-l-20 m-t-20 m-b-20</xsl:attribute>
							<xsl:for-each select="$doctorado/ehu:idiomas/ehu:idioma">
								<p><xsl:value-of select="."/></p>
							</xsl:for-each>
      					</xsl:element>
					</xsl:element>
				</xsl:element>
			</xsl:if>
		</xsl:element>
		
	</xsl:template>
		                 
		                                                  
	<xsl:template name="matriculaProcedimiento">
		<article namespace="xmlns:ehu">
			<xsl:attribute name="class">information</xsl:attribute>
			<xsl:element name="section">
				<xsl:attribute name="class">upv-ehu-image-description</xsl:attribute>
				<xsl:element name="div">
					<xsl:attribute name="class">main</xsl:attribute>
					<xsl:if test="$doctorado/ehu:complementosFormativos and $doctorado/ehu:complementosFormativos != ''">
						<xsl:element name="h2"><xsl:value-of select="languageUtil:get($locale,'upv-ehu.doctorate.especificaciones.programa')"/></xsl:element>
						<xsl:element name="p">
							<xsl:attribute name="class">m-b-30</xsl:attribute>
							<xsl:value-of select="$doctorado/ehu:complementosFormativos"/>
						</xsl:element>
					</xsl:if>
				</xsl:element>
			</xsl:element>
		</article>
	</xsl:template>	
	
	
	<xsl:template name="tesisDefendida">

		<article namespace="xmlns:ehu">
			<xsl:attribute name="class">information</xsl:attribute>
			<xsl:element name="section">
				<xsl:attribute name="class">upv-ehu-image-description</xsl:attribute>
				<xsl:element name="div">
				
					<xsl:attribute name="class">main pagination-head</xsl:attribute>
					<xsl:element name="h2"><xsl:value-of select="languageUtil:get($locale,'upv-ehu.doctorate.listado.tesis.programa')"/> </xsl:element>
					
					<xsl:for-each select="$doctorado/ehu:listaTesis/ehu:tesis">
						<xsl:element name="div">
							<xsl:attribute name="class">customPaginator</xsl:attribute>
							<xsl:if test="ehu:tituloDefendido  != ''">
								<xsl:element name="h3">
									<xsl:attribute name="class">t16 subrayado-grey</xsl:attribute>
									<i class="fa fa-check grey" ><xsl:value-of select="$white_space" /></i>
									<xsl:element name="strong">
										<xsl:attribute name="class">t19</xsl:attribute>
										<xsl:value-of select="ehu:tituloDefendido"/>
									</xsl:element>
								</xsl:element>
							</xsl:if>
							
							<xsl:if test="$doctorado/ehu:comisiones/ehu:comision/ehu:miembros">
								<xsl:element name="div">
									<xsl:attribute name="class">t16 m-l-40 m-t-10</xsl:attribute>
									<xsl:element name="dl">
										<xsl:for-each select="$doctorado/ehu:comisiones/ehu:comision/ehu:miembros/ehu:miembro">
											<xsl:element name="dd"><xsl:value-of select="ehu:desCargo"/>: <xsl:value-of select="ehu:nombre"/></xsl:element>
										</xsl:for-each>
									</xsl:element>
								</xsl:element>
							</xsl:if>
							
							<xsl:element name="div">
								<xsl:attribute name="class">t16 m-b-40 m-l-40 m-t-10</xsl:attribute>
								<xsl:element name="dl">
									
									<!-- Nombre Completo -->
									<p>
										<xsl:attribute name="class">m-b-5</xsl:attribute>
										<strong><xsl:value-of select="ehu:nombreCompleto"/></strong>
									</p>
									
									<!-- Dirección -->
									<xsl:if test="ehu:directores/ehu:director  != ''">
										<xsl:element name="dt">
											<xsl:attribute name="class">m-b-5</xsl:attribute>
											<strong><xsl:value-of select="languageUtil:get($locale,'upv-ehu.doctorate.director')"/>: </strong>
										</xsl:element>
										<xsl:for-each select="ehu:directores/ehu:director">
											<xsl:element name="dd">
												<xsl:value-of select="ehu:nombreCompleto"/><xsl:if test="position() != last()">;<xsl:value-of select="$white_space" /></xsl:if>
											</xsl:element>
										</xsl:for-each>
									</xsl:if>
									
									<!-- Menciones -->
									<xsl:if test="ehu:menciones != ''">
										<xsl:element name="dt">
											<xsl:attribute name="class">m-b-5</xsl:attribute>
											<!-- <strong><xsl:value-of select="languageUtil:get($locale,'ehu.menciones')"/>: </strong><xsl:value-of select="ehu:nombreCompleto"/> -->
											<strong><xsl:value-of select="languageUtil:get($locale,'ehu.menciones')"/>: </strong>
										</xsl:element>
										<xsl:for-each select="ehu:menciones/ehu:mencion">
											<xsl:element name="dd"><xsl:value-of select="ehu:descripcion"/></xsl:element>
										</xsl:for-each>
									</xsl:if>
									
									<!-- Calificación -->
									<xsl:if test="ehu:calificacion  != ''">
											<xsl:element name="dt">
												<xsl:attribute name="class">m-b-5</xsl:attribute><strong><xsl:value-of select="languageUtil:get($locale,'ehu.calification')"/>: </strong> </xsl:element> 
											<xsl:element name="dd">
												<xsl:value-of select="ehu:calificacion"/>
											</xsl:element>
									</xsl:if>
									
									<!-- Año -->									
									<xsl:if test="ehu:anioDefensa  != ''">
										<xsl:element name="dt">
											<xsl:attribute name="class">m-b-5</xsl:attribute>
											<strong><xsl:value-of select="languageUtil:get($locale,'ehu.year')"/>: </strong>
										</xsl:element> 
										<xsl:element name="dd"><xsl:value-of select="ehu:anioDefensa"/></xsl:element>
									</xsl:if>
									
									<!-- Resumen -->
									<xsl:if test="ehu:resumen != ''">
										<xsl:element name="dt">
											<xsl:attribute name="class">m-b-5</xsl:attribute>
											<strong><xsl:value-of select="languageUtil:get($locale,'upv-ehu.doctorate.summary')"/>: </strong>
										</xsl:element>
										<xsl:element name="dd">
											<xsl:element name="p">
												<xsl:attribute name="class">showMoreContent</xsl:attribute>
												<xsl:attribute name="id">showMoreContent<xsl:value-of select="position()"/></xsl:attribute>
												<xsl:value-of select="ehu:resumen"/>
											</xsl:element>
											<xsl:element name="a">
												<xsl:attribute name="href">javascript:void(0)</xsl:attribute>
												<xsl:attribute name="more-expand"></xsl:attribute>
												<xsl:attribute name="data-hidetext"><xsl:value-of select="languageUtil:get($locale,'see-less')"/></xsl:attribute>
												<xsl:attribute name="data-showtext"><xsl:value-of select="languageUtil:get($locale,'see-more')"/></xsl:attribute>
												<xsl:attribute name="data-target">showMoreContent<xsl:value-of select="position()"/></xsl:attribute>
												<xsl:value-of select="languageUtil:get($locale,'see-more')"/>
											</xsl:element>
										</xsl:element>
									</xsl:if>
																	
								</xsl:element>
							</xsl:element>
						</xsl:element>
					</xsl:for-each>
					
					<xsl:text disable-output-escaping="yes"> 
			     		<![CDATA[    
				            <script type="text/javascript"> 
                         		var moreExpands = document.querySelectorAll('[more-expand]');

								[].forEach.call(moreExpands, function(moreexpand) {
									moreexpand.addEventListener("click", function() {
										   
									    var showContent = document.getElementById(this.dataset.target);
							
									    if (showContent.classList.contains("active")) {
									    	this.innerHTML=this.dataset.showtext;
									    	showContent.style.maxHeight="";
									    } else {
									    	this.innerHTML=this.dataset.hidetext;
									    	showContent.style.maxHeight=showContent.scrollHeight+"px";
									    }
							
									    showContent.classList.toggle('active');
									});  
								});
		                	</script> 
	          			]]>
					</xsl:text>
					
					<xsl:element name="ul">
						<xsl:attribute name="class">list-icons inline m-b-0</xsl:attribute>
						<xsl:element name="li">
							<xsl:attribute name="class">link m-t-40</xsl:attribute>
							<xsl:element name="a">
								<xsl:attribute name="class">bullet bullet-url</xsl:attribute>
								<xsl:attribute name="target">_blank</xsl:attribute>
								<xsl:attribute name="href">https://addi.ehu.es/handle/10810/12140?locale-attribute=<xsl:value-of select="$p_cod_idioma"/></xsl:attribute>
								<xsl:value-of select="$white_space"/>
								<xsl:value-of select="languageUtil:get($locale,'upv-ehu.doctorate.tesis.addi-url')" />
								<xsl:value-of select="$white_space"/>
								
								<xsl:element name="span">
									<xsl:attribute name="class">hide-accessible</xsl:attribute>
									<xsl:value-of select="languageUtil:get($locale,'opens-new-window')"/>
								</xsl:element>
								<xsl:element name="span">
									<xsl:attribute name="class">icon-external-link</xsl:attribute>
								</xsl:element>
							</xsl:element>
						</xsl:element>	
					</xsl:element>
					
				</xsl:element>
			</xsl:element>
		</article>
		
        <xsl:element name="div">
   			<xsl:attribute name="class">doctorate upv-pagination-buttons</xsl:attribute>
        	<xsl:element name="ul">
        	</xsl:element>
        </xsl:element>
        
	</xsl:template>	


	<xsl:template name="calidad">
		<xsl:element name="div">
			<xsl:attribute name="class">journal-content-article</xsl:attribute>
			<article namespace="xmlns:ehu">
				<xsl:attribute name="class">information</xsl:attribute>
				<xsl:element name="section">
					<xsl:attribute name="class">upv-ehu-image-description</xsl:attribute>
					<xsl:element name="div">
						<xsl:attribute name="class">main</xsl:attribute>
						
						<xsl:element name="h2">
							<xsl:value-of select="languageUtil:get($locale,'ehu.verificacionSeguimientoAcreditacion')"/>
						</xsl:element>
												
						<xsl:element name="ul">
							<xsl:attribute name="class">list-icons</xsl:attribute>
							<xsl:for-each select="$doctorado/ehu:documentos/ehu:documento">
								<xsl:variable name="extension" select="ehu:extension"/>
								<xsl:variable name="size" select="ehu:peso"/>
								<xsl:element name="li">
									<xsl:attribute name="class"><xsl:value-of select="$extension" /></xsl:attribute>
									<a>
								  		<xsl:attribute name="href">?p_redirect=descargaFichero&amp;p_tipo=<xsl:value-of select="ehu:tipo"/>&amp;p_anyo_inf=<xsl:value-of select="ehu:anyoInf"/>
								  		</xsl:attribute>
										<xsl:attribute name="target">_blank</xsl:attribute>
								  		<xsl:value-of select="$white_space"/>
										<xsl:choose>
											<xsl:when test="ehu:titulo != $void">
												<xsl:value-of select="ehu:titulo"/>											
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="ehu:nombre"/>
											</xsl:otherwise>
										</xsl:choose>
										<xsl:if test="($size != $void) and ($extension != $void)"> 
											<xsl:text> (</xsl:text>
											<xsl:element name="abbr">
												<xsl:variable name="literal-extension" select="concat('ehu.ext.', $extension)"/>
												<xsl:attribute name="title"><xsl:value-of select="languageUtil:get($locale, $literal-extension)"/></xsl:attribute>
												<xsl:value-of select="$extension"/>
												<xsl:value-of select="$white_space"/>
											</xsl:element>
											<span><xsl:value-of select="substring-before($size,  $white_space)"/></span>
											<xsl:element name="abbr">
												<xsl:choose>
													<xsl:when test="contains($size, Kb)">
														<xsl:attribute name="title">
															<xsl:value-of select="languageUtil:get($locale, 'ehu.ext.Kb')"/>
														</xsl:attribute>
														<xsl:value-of select="substring-after($size,  $white_space)"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:attribute name="title">
															<xsl:value-of select="languageUtil:get($locale, 'ehu.ext.Mb')"/>
														</xsl:attribute>
														<xsl:value-of select="substring-after($size,  $white_space)"/>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:element>
											<xsl:text>)</xsl:text>
										</xsl:if>
										<xsl:value-of select="$white_space"/>
										<span>
											<xsl:attribute name="class">hide-accessible</xsl:attribute>
											<xsl:value-of select="languageUtil:get($locale,'opens-new-window')"/>
										</span>
										<span><xsl:attribute name="class">icon-external-link</xsl:attribute></span>
									</a>
								</xsl:element>
							</xsl:for-each>
						</xsl:element>
						
					</xsl:element>
				</xsl:element>
			</article>
		</xsl:element>
	</xsl:template>
	
	
	<xsl:template name="url-encode">
	  <xsl:param name="str"/> 
	<xsl:variable name="ascii"> !"#$%&amp;'()*+,-./0123456789:;&lt;=&gt;?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~</xsl:variable>
  <xsl:variable name="latin1">&#160;&#161;&#162;&#163;&#164;&#165;&#166;&#167;&#168;&#169;&#170;&#171;&#172;&#173;&#174;&#175;&#176;&#177;&#178;&#179;&#180;&#181;&#182;&#183;&#184;&#185;&#186;&#187;&#188;&#189;&#190;&#191;&#192;&#193;&#194;&#195;&#196;&#197;&#198;&#199;&#200;&#201;&#202;&#203;&#204;&#205;&#206;&#207;&#208;&#209;&#210;&#211;&#212;&#213;&#214;&#215;&#216;&#217;&#218;&#219;&#220;&#221;&#222;&#223;&#224;&#225;&#226;&#227;&#228;&#229;&#230;&#231;&#232;&#233;&#234;&#235;&#236;&#237;&#238;&#239;&#240;&#241;&#242;&#243;&#244;&#245;&#246;&#247;&#248;&#249;&#250;&#251;&#252;&#253;&#254;&#255;</xsl:variable>

  <!-- Characters that usually don't need to be escaped -->
  <xsl:variable name="safe">!'()*-.0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz~</xsl:variable>

  <xsl:variable name="hex" >0123456789ABCDEF</xsl:variable>
	
	
  
  <xsl:if test="$str">
   <xsl:variable name="first-char" select="substring($str,1,1)"/>
   <xsl:choose>
    <xsl:when test="contains($safe,$first-char)">
     <xsl:value-of select="$first-char"/>
    </xsl:when>
    <xsl:otherwise>
     <xsl:variable name="codepoint">
      <xsl:choose>
       <xsl:when test="contains($ascii,$first-char)">
        <xsl:value-of select="string-length(substring-before($ascii,$first-char)) + 32"/>
       </xsl:when>
       <xsl:when test="contains($latin1,$first-char)">
        <xsl:value-of select="string-length(substring-before($latin1,$first-char)) + 160"/>
       </xsl:when>
       <xsl:otherwise>
        <xsl:message terminate="no">Warning: string contains a character that is out of range! Substituting "?".</xsl:message>
        <xsl:text>63</xsl:text>
       </xsl:otherwise>
      </xsl:choose>
     </xsl:variable>
     <xsl:variable name="hex-digit1" select="substring($hex,floor($codepoint div 16) + 1,1)"/>
     <xsl:variable name="hex-digit2" select="substring($hex,$codepoint mod 16 + 1,1)"/>
     <xsl:value-of select="concat('%',$hex-digit1,$hex-digit2)"/>
    </xsl:otherwise>
   </xsl:choose>
   <xsl:if test="string-length($str) &gt; 1">
    <xsl:call-template name="url-encode">
     <xsl:with-param name="str" select="substring($str,2)"/>
    </xsl:call-template>
   </xsl:if>
  </xsl:if>
 </xsl:template>

</xsl:stylesheet>

