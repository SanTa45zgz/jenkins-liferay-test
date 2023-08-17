<?xml version="1.0"?>

	<xsl:stylesheet 
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
		xmlns:ehu="http://www.ehu.eus"
		xmlns:xalan="http://xml.apache.org/xalan"
		xmlns:languageUtil="xalan://com.liferay.portal.kernel.language.LanguageUtil"
		exclude-result-prefixes="xalan"
		extension-element-prefixes="languageUtil xalan">
		
	<xsl:output method="html" omit-xml-declaration="yes" />
	
	<xsl:include href="http://localhost:8080/o/ehu-xsl-content-web/common/common.xsl"/>
	
	<xsl:template match="/">
	
		<!-- Parametros propios de las listas de personal -->
		<xsl:variable name="p_tipo" select="ehu:app/ehu:parameters/ehu:parameter[@name='p_tipo']"/>
		<xsl:variable name="p_cod" select="ehu:app/ehu:parameters/ehu:parameter[@name='p_cod']"/>
		<xsl:variable name="p_ordenacion" select="ehu:app/ehu:parameters/ehu:parameter[@name='p_ordenacion']"/>
		
		<xsl:variable name="title" select="ehu:app/ehu:contenido/ehu:titulo"/>
		<xsl:variable name="nav" select="ehu:app/ehu:contenido/ehu:nav"/>
		<xsl:variable name="list" select="ehu:app/ehu:contenido/ehu:listado"/>
		
		<div>
			<xsl:attribute name="class">xsl-content ldap</xsl:attribute>
			
			<xsl:if test="$title != $void">
				<h1>
					<xsl:value-of select="$title"/>		
				</h1>
			</xsl:if>
			
			<div>
				<xsl:attribute name="id">listTab</xsl:attribute>
				<ul>
					<xsl:attribute name="id">list</xsl:attribute>
					<xsl:attribute name="class">nav nav-pills</xsl:attribute>
					<li>
						<xsl:if test="$p_ordenacion = 'alfabetica'">
							<xsl:attribute name="class">active</xsl:attribute>							
						</xsl:if>
						<a>
							<xsl:attribute name="href">?p_cod_idioma=<xsl:value-of select="$p_cod_idioma"/>&amp;p_cod_proceso=<xsl:value-of select="$p_cod_proceso"/>&amp;p_tipo=<xsl:value-of select="$p_tipo"/>&amp;p_cod=<xsl:value-of select="$p_cod"/>&amp;p_ordenacion=alfabetica</xsl:attribute>
							<xsl:value-of select="languageUtil:get($locale,'ehu.order-by.alphabetic')"/>
						</a>
					</li>
					<li>
						<xsl:if test="$p_ordenacion = 'campus'">
							<xsl:attribute name="class">active</xsl:attribute>							
						</xsl:if>
						<a>
							<xsl:attribute name="href">?p_cod_idioma=<xsl:value-of select="$p_cod_idioma"/>&amp;p_cod_proceso=<xsl:value-of select="$p_cod_proceso"/>&amp;p_tipo=<xsl:value-of select="$p_tipo"/>&amp;p_cod=<xsl:value-of select="$p_cod"/>&amp;p_ordenacion=campus</xsl:attribute>
							<xsl:value-of select="languageUtil:get($locale,'ehu.order-by.campuses')"/>
						</a>
					</li>
					<!-- Solo existe ordenacion por departamento en los centros -->
					<xsl:if test="$p_tipo = 'centro'">
						<li>
							<xsl:if test="$p_ordenacion = 'departamento'">
								<xsl:attribute name="class">active</xsl:attribute>							
							</xsl:if>
							<a>
								<xsl:attribute name="href">?p_cod_idioma=<xsl:value-of select="$p_cod_idioma"/>&amp;p_cod_proceso=<xsl:value-of select="$p_cod_proceso"/>&amp;p_tipo=<xsl:value-of select="$p_tipo"/>&amp;p_cod=<xsl:value-of select="$p_cod"/>&amp;p_ordenacion=departamento</xsl:attribute>
								<xsl:value-of select="languageUtil:get($locale,'ehu.order-by.departments')"/>
							</a>
						</li>			  		
					</xsl:if>
					<!-- Solo existe ordenacion por centros en los departamentos -->
					<xsl:if test="$p_tipo = 'dpto'">
						<li>
							<xsl:if test="$p_ordenacion = 'centro'">
								<xsl:attribute name="class">active</xsl:attribute>							
							</xsl:if>
							<a>
								<xsl:attribute name="href">?p_cod_idioma=<xsl:value-of select="$p_cod_idioma"/>&amp;p_cod_proceso=<xsl:value-of select="$p_cod_proceso"/>&amp;p_tipo=<xsl:value-of select="$p_tipo"/>&amp;p_cod=<xsl:value-of select="$p_cod"/>&amp;p_ordenacion=centro</xsl:attribute>
								<xsl:value-of select="languageUtil:get($locale,'ehu.order-by.faculty')"/>
							</a>
						</li>			  		
					</xsl:if>
					<li>
						<xsl:if test="$p_ordenacion = 'tipo'">
							<xsl:attribute name="class">active</xsl:attribute>							
						</xsl:if>
						<a>
							<xsl:attribute name="href">?p_cod_idioma=<xsl:value-of select="$p_cod_idioma"/>&amp;p_cod_proceso=<xsl:value-of select="$p_cod_proceso"/>&amp;p_tipo=<xsl:value-of select="$p_tipo"/>&amp;p_cod=<xsl:value-of select="$p_cod"/>&amp;p_ordenacion=tipo</xsl:attribute>
							<xsl:value-of select="languageUtil:get($locale,'ehu.order-by.staff')"/>
						</a>
					</li>
					<li>
						<xsl:if test="$p_ordenacion = 'cargo'">
							<xsl:attribute name="class">active</xsl:attribute>							
						</xsl:if>
						<a>
							<xsl:attribute name="href">?p_cod_idioma=<xsl:value-of select="$p_cod_idioma"/>&amp;p_cod_proceso=<xsl:value-of select="$p_cod_proceso"/>&amp;p_tipo=<xsl:value-of select="$p_tipo"/>&amp;p_cod=<xsl:value-of select="$p_cod"/>&amp;p_ordenacion=cargo</xsl:attribute>
							<xsl:value-of select="languageUtil:get($locale,'ehu.order-by.positions')"/>
						</a>
					</li>
				</ul>
			</div>
			
			<xsl:if test="($p_tipo != $void) and ($p_cod != $void)">
				<div>
					<xsl:attribute name="id">tabContent</xsl:attribute>
						<xsl:if test="$p_ordenacion = 'alfabetica'">
							<h2 class="hide-accessible"><xsl:value-of select="languageUtil:get($locale,'ehu.order-by.alphabetic')"/></h2>				
						</xsl:if>
						<xsl:if test="$p_ordenacion = 'campus'">
							<h2 class="hide-accessible"><xsl:value-of select="languageUtil:get($locale,'ehu.order-by.campuses')"/></h2>					
						</xsl:if>
						<xsl:if test="$p_ordenacion = 'departamento'">
							<h2 class="hide-accessible"><xsl:value-of select="languageUtil:get($locale,'ehu.order-by.departments')"/></h2>						
						</xsl:if>
						<xsl:if test="$p_ordenacion = 'centro'">
							<h2 class="hide-accessible"><xsl:value-of select="languageUtil:get($locale,'ehu.order-by.faculty')"/></h2>						
						</xsl:if>
						<xsl:if test="$p_ordenacion = 'tipo'">
							<h2 class="hide-accessible"><xsl:value-of select="languageUtil:get($locale,'ehu.order-by.staff')"/></h2>			
						</xsl:if>
						<xsl:if test="$p_ordenacion = 'cargo'">
							<h2 class="hide-accessible"><xsl:value-of select="languageUtil:get($locale,'ehu.order-by.positions')"/></h2>				
						</xsl:if>
						
					
					<div>
			   			<xsl:attribute name="id">tab</xsl:attribute>
			   			<xsl:call-template name="navigation">
							<xsl:with-param name="nav" select="$nav"/>
						</xsl:call-template>
						
						<xsl:call-template name="ldap-list">
							<xsl:with-param name="list" select="$list"/>	
							<xsl:with-param name="nav" select="$nav"/>								
						</xsl:call-template>										
					</div>
				</div>		
			</xsl:if>
		</div>	
	</xsl:template>
	
	<!-- Persona LDAP -->
	<xsl:template name="ldap-person">
		<xsl:if test="(ehu:nombre != $void) and (ehu:enlace != $void)">
			<xsl:variable name="href_title" select="ehu:enlace/@label"/>
			<span>
				<xsl:attribute name="class">person</xsl:attribute>
				<a>
					<xsl:attribute name="href"><xsl:value-of select="ehu:enlace"/></xsl:attribute>
					<xsl:attribute name="target">_blank</xsl:attribute>
					<xsl:attribute name="title"><xsl:value-of select="$href_title"/></xsl:attribute>
					<xsl:value-of select="ehu:nombre"/>
					<xsl:if test="ehu:tipo != $void">
						<xsl:variable name="abbr_title" select="ehu:tipo/@label"/>
						<xsl:value-of select="$white_space"/>
						(<abbr>
							<xsl:attribute name="title"><xsl:value-of select="$abbr_title"/></xsl:attribute>
							<xsl:value-of select="ehu:tipo"/>
						</abbr>)
					</xsl:if>	
				</a>						
			</span>
		</xsl:if>
	</xsl:template>	
		
	<!-- Lista LDAP -->
	<xsl:template name="ldap-list">
		<xsl:param name="list"/>
		<xsl:param name="nav"/>
		<xsl:if test="$list != $void">
						
			<xsl:for-each select="$list/ehu:persona">
				<xsl:variable name="anchor" select="@val"/>
				                
				<xsl:variable name="previous_anchor" select="preceding-sibling::*[1]/@val" />
							
				<xsl:if test="$anchor != $void"> <!-- Si viene el nombre del centro -->
												
						<xsl:variable name="init" select="position()"/>						
						
						<xsl:for-each select="$nav/ehu:navitem">
																				
							<xsl:variable name="anchor_nav" select="@val" />
							<xsl:variable name="next_anchor_nav" select="following-sibling::*[1]/@val" />
							<xsl:variable name="last" select="last()"/>
							<xsl:variable name="last_anchor_nav" select="$nav/ehu:navitem[$last]/@val" />
							<xsl:for-each select="$list/ehu:persona">
								<xsl:variable name="sub_anchor" select="@val"/>
								<xsl:variable name="lastPerson" select="last()"/>
											
								<xsl:choose>
									<xsl:when test="$next_anchor_nav != $void">									
									
									<xsl:if test="($sub_anchor = $next_anchor_nav) and ($anchor_nav = $anchor)">
																		
											<xsl:variable name="end" select="position()"/>
											
											<!-- Edorta: El nombre de Ikerbasque viene como EHUTALDEA001 en el xml. Metemos esta ñapa para mostrar "Ikerbasque" a la espera de rehacer todo el sistema de listas de personal -->
											<xsl:choose>
												<xsl:when test="$anchor='EHUTALDEA001'">
													<h3>
														Ikerbasque
													</h3>
												</xsl:when>
												<xsl:otherwise>
													<h3>
														<xsl:attribute name="id"><xsl:value-of select="$anchor"/></xsl:attribute>
														<!-- Pasamos a mayúsculas los campus -->
														<xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'" />
														<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
														<xsl:value-of select="translate($anchor, $smallcase, $uppercase)" />
													</h3>
												</xsl:otherwise>
											</xsl:choose>
																						
											
											<xsl:call-template name="ldap-sub-list">
													<xsl:with-param name="init" select="$init"/> 
													<xsl:with-param name="list" select="$list"/> 
													<xsl:with-param name="end" select="$end"/> 
											</xsl:call-template>
											<xsl:if test="not(init=1)" >
												<a>  
													<xsl:attribute name="href">#pagination</xsl:attribute>
													<xsl:attribute name="class">pull-right</xsl:attribute>
													<span>
														<xsl:value-of select="languageUtil:get($locale, 'up')"/>
														<xsl:value-of select="$white_space"/>
														<span>
															<xsl:attribute name="class">icon-chevron-up</xsl:attribute>
														</span>
													</span>
												</a>
											</xsl:if>	
										</xsl:if>
									
									</xsl:when>
									
									<xsl:otherwise>	
										
										<xsl:if test="($sub_anchor = $last_anchor_nav) and ($anchor_nav = $anchor)">
											<xsl:variable name="end" select="$lastPerson + 1"/>
											
												<!-- Edorta: El nombre de Ikerbasque viene como EHUTALDEA001 en el xml. Metemos esta ñapa para mostrar "Ikerbasque" a la espera de rehacer todo el sistema de listas de personal -->
												<xsl:choose>
													<xsl:when test="$anchor='EHUTALDEA001'">
														<h3>
															Ikerbasque
														</h3>
													</xsl:when>
													<xsl:otherwise>
														<h3>
															<xsl:attribute name="id"><xsl:value-of select="$anchor"/></xsl:attribute>
															
															<!-- Pasamos a mayúsculas los campus -->
															<xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'" />
															<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
															<xsl:value-of select="translate($anchor, $smallcase, $uppercase)" />
															
														</h3>
													</xsl:otherwise>
												</xsl:choose>
												
												<xsl:call-template name="ldap-sub-list">
													<xsl:with-param name="init" select="$init"/> 
													<xsl:with-param name="list" select="$list"/> 
													<xsl:with-param name="end" select="$end"/> 
												</xsl:call-template>
												<a>  
													<xsl:attribute name="href">#pagination</xsl:attribute>
													<xsl:attribute name="class">pull-right</xsl:attribute>
													<span>
														<xsl:value-of select="languageUtil:get($locale, 'up')"/>
														<xsl:value-of select="$white_space"/>
														<span>
															<xsl:attribute name="class">icon-chevron-up</xsl:attribute>
														</span>
													</span>
												</a>
										</xsl:if>
									
									</xsl:otherwise>								
								
								</xsl:choose>
								
							
								
							</xsl:for-each>
							
						</xsl:for-each>
						
				</xsl:if>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>
	
	
	<!-- Lista LDAP -->
	<xsl:template name="ldap-sub-list">
		  	<xsl:param name="end"/>
		  	<xsl:param name="init"/>
		  	<xsl:param name="list"/>
		  	<ul>
			<xsl:for-each select="$list/ehu:persona">
				<xsl:if test="($init &lt;= position()) and (position() &lt; $end )">
					<li><xsl:call-template name="ldap-person"/></li>
				</xsl:if>
			</xsl:for-each>
			</ul>
	</xsl:template>
</xsl:stylesheet>
