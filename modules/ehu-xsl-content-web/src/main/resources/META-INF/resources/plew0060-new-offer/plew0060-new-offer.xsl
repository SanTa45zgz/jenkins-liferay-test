<?xml version="1.0"?>
	<xsl:stylesheet
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
		xmlns:xalan="http://xml.apache.org/xalan"
		xmlns:languageUtil="xalan://com.liferay.portal.kernel.language.LanguageUtil"
		xmlns:localeUtil="xalan://com.liferay.portal.kernel.util.LocaleUtil"
		xmlns:ehu="http://www.ehu.eus"
		xmlns:exsl="http://exslt.org/common"
		exclude-result-prefixes="xalan"
		extension-element-prefixes="languageUtil localeUtil xalan exsl">
		
		<xsl:output method="html" omit-xml-declaration="yes" />
		
		<!-- xsl:include href="http://localhost:8080/o/ehu-xsl-content-web/common/common-lang.xsl"/> -->
		<!-- ya incluye al commons-lang.xsl -->
		<xsl:include href="http://localhost:8080/o/ehu-xsl-content-web/common/common.xsl"/>
	
		
		<xsl:template match="/">
		
			<!-- Parametros propios del listado de doctorados -->
			<xsl:variable name="titulo" select="languageUtil:get($locale,'ehu.xsl-content.title.plew0060-offer')" />
			<div class="ehu-oferta-doctorados">
				<xsl:attribute name="class">xsl-content phds</xsl:attribute>

				<xsl:call-template name="header">
					<xsl:with-param name="title" select="$titulo"/>
				</xsl:call-template>
				
				<div class="ehu-oferta-doctorados__filtros">
					<xsl:attribute name="id">listTab</xsl:attribute>
					<!-- html  codigo buscador -->
					<form name="form-search" action="javascript:processHtml()">
						<div class="form-group">
						    <div class="ehu-oferta-grados__filtros__search">
						    	<button type="submit"> 
						    		<span class="sr-only"><xsl:value-of select="languageUtil:get($locale,'ehu.search')"/></span>
						    	</button>
						    	<input type="hidden" class="form-control" name="p_cod_idioma">
						    		<xsl:attribute name="value"><xsl:value-of select="$p_cod_idioma"/></xsl:attribute>
						    	</input>
						    	<input type="hidden" class="form-control" name="p_cod_proceso">
						    		<xsl:attribute name="value"><xsl:value-of select="$p_cod_proceso"/></xsl:attribute>
						    	</input>
						    	<input type="hidden" class="form-control nav" name="p_nav">
						    		<xsl:attribute name="value"><xsl:value-of select="$p_nav"/></xsl:attribute>
						    	</input>
								<label for="search" class="sr-only"><xsl:value-of select="languageUtil:get($locale,'ehu.search')"/>:</label>
						    	<input type="search" class="form-control search" name="p_search" id="search">
                                    <xsl:attribute name="placeholder"><xsl:value-of select="languageUtil:get($locale,'ehu.search.doctorados.oferta.place-holder')"/></xsl:attribute>
                                </input>
						    </div>
						</div>
					</form>	
					<!-- html  codigo buscador -->
					<ul>
						<xsl:attribute name="id">list</xsl:attribute>
						<xsl:attribute name="class">nav nav-pills</xsl:attribute>
						<xsl:choose>
							<xsl:when test="$p_nav != ''">
								<li>
									<xsl:if test="$p_nav = 'A'">
										<xsl:attribute name="class">active</xsl:attribute>							
									</xsl:if>							
									<a>
										<xsl:attribute name="href">?p_cod_idioma=<xsl:value-of select="$p_cod_idioma"/>&amp;p_cod_proceso=<xsl:value-of select="$p_cod_proceso"/>&amp;p_nav=A</xsl:attribute>
										<xsl:value-of select="languageUtil:get($locale,'ehu.order-by.oferta.alphabetic')"/>
									</a>
								</li>
								<li>
									<xsl:if test="$p_nav = 'R'">
										<xsl:attribute name="class">active</xsl:attribute>							
									</xsl:if>							
									<a>
										<xsl:attribute name="href">?p_cod_idioma=<xsl:value-of select="$p_cod_idioma"/>&amp;p_cod_proceso=<xsl:value-of select="$p_cod_proceso"/>&amp;p_nav=R</xsl:attribute>
										<xsl:value-of select="languageUtil:get($locale,'ehu.order-by.oferta.branches')"/>
									</a>
								</li>								
								<li>
									<xsl:if test="$p_nav = 'S'">
										<xsl:attribute name="class">active</xsl:attribute>							
									</xsl:if>							
									<a>
										<xsl:attribute name="href">?p_cod_idioma=<xsl:value-of select="$p_cod_idioma"/>&amp;p_cod_proceso=<xsl:value-of select="$p_cod_proceso"/>&amp;p_nav=S</xsl:attribute>
										<xsl:value-of select="languageUtil:get($locale,'ehu.order-by.oferta.knowledge-scopes')"/>
									</a>
								</li>							
							</xsl:when>
							<xsl:otherwise>
								<li>
									<!-- Ponemos la pestaña de alfabético como activa por defecto -->
									<xsl:attribute name="class">active</xsl:attribute>
									<a>
										<xsl:attribute name="href">?p_cod_idioma=<xsl:value-of select="$p_cod_idioma"/>&amp;p_cod_proceso=<xsl:value-of select="$p_cod_proceso"/>&amp;p_nav=A</xsl:attribute>
										<xsl:value-of select="languageUtil:get($locale,'ehu.order-by.oferta.alphabetic')"/>
									</a>
								</li>
								<li>
									<a>
										<xsl:attribute name="href">?p_cod_idioma=<xsl:value-of select="$p_cod_idioma"/>&amp;p_cod_proceso=<xsl:value-of select="$p_cod_proceso"/>&amp;p_nav=R</xsl:attribute>
										<xsl:value-of select="languageUtil:get($locale,'ehu.order-by.oferta.branches')"/>
									</a>
								</li>								
								<li>
									<a>
										<xsl:attribute name="href">?p_cod_idioma=<xsl:value-of select="$p_cod_idioma"/>&amp;p_cod_proceso=<xsl:value-of select="$p_cod_proceso"/>&amp;p_nav=S</xsl:attribute>
										<xsl:value-of select="languageUtil:get($locale,'ehu.order-by.oferta.knowledge-scopes')"/>
									</a>
								</li>							
							</xsl:otherwise>
						</xsl:choose>					
					</ul>		
				</div>
				<div class="ehu-oferta-doctorados__lists">
					<xsl:choose>
						<xsl:when test="$p_nav = 'A'">
							<h2><xsl:attribute name="class">hide-accessible</xsl:attribute><xsl:value-of select="languageUtil:get($locale,'ehu.order-by.oferta.alphabetic')"/></h2>							
						</xsl:when>
						<xsl:when test="$p_nav = 'S'">
							 <h2><xsl:attribute name="class">hide-accessible</xsl:attribute><xsl:value-of select="languageUtil:get($locale,'ehu.order-by.oferta.knowledge-scopes')"/></h2>
						</xsl:when>						
						<xsl:otherwise>
							<h2><xsl:attribute name="class">hide-accessible</xsl:attribute><xsl:value-of select="languageUtil:get($locale,'ehu.order-by.oferta.branches')"/></h2>
						</xsl:otherwise>
					</xsl:choose>
				<!-- ul-->
					<xsl:choose>
						<xsl:when test="$p_nav = 'R'">
							<!-- Doctorados ordenados por ramas -->
							<xsl:variable name="branches_sorted_copy">
								<xsl:for-each select="ehu:app/ehu:doctorados/ehu:doctorado">
							        <xsl:sort select="ehu:desRama"/>
							        <xsl:copy-of select="current()"/>							        	
							    </xsl:for-each>
						    </xsl:variable>
						    <xsl:variable name="branches_sorted_node_set" select="exsl:node-set($branches_sorted_copy)/*" />
							
							<div class="elements__list">   
							    <xsl:for-each select="$branches_sorted_node_set">
							    	<xsl:variable name="branch_id" select="ehu:rama"/>
							    	<xsl:variable name="branch" select="ehu:desRama"/>
									<xsl:variable name="previous_branch" select="preceding-sibling::*[1]/ehu:desRama" />
							    	
							    	<xsl:if test="not($previous_branch = $branch) and ($branch !='')">
							      		<div class="panel">
								      		<h3 class="panel-title">
								      			<a role="button"  class="own-accordion" tabindex="0" onclick="handleCommandClick(this,event)" onKeyDown="handleCommand(this,event)">
													<xsl:value-of select="$branch"/>
												</a>
											</h3>
											<div class="panel-collapse">
												<div class="panel-body">					
													<ul>
														 <xsl:for-each select="$branches_sorted_node_set">
														 	<xsl:variable name="branch_sub" select="ehu:desRama"/>
														 	<xsl:variable name="next_branch" select="following-sibling::*[1]/ehu:desRama" />
														 	
														 	<!--  XSL no permite generar HTML dinámico, por lo que si creamos un elemento li dentro de un if falla. Para poder crear listas 
														 	y sublistas bien definidas con ul li ul li debemos volver a recorrer la lista y coger los que sean iguales o utilizar tags como for-each-group-->
														 	<xsl:if test="$branch_sub = $branch">
														 		<xsl:variable name="program_url" select="ehu:urlInicio"/>
														 		<xsl:if test="($program_url!='')">	
																 		<li>
																 			<xsl:variable name="program_url" select="ehu:urlInicio"/>
																			<xsl:choose>
																				<xsl:when test="$program_url != $void">
																					<a tabindex="-1">
																						<xsl:attribute name="href"><xsl:value-of select="$program_url"/></xsl:attribute>
																				 		<xsl:value-of select="ehu:denPropuesta" />							  								  		
																					</a>
																				</xsl:when>
																				<xsl:otherwise>
																					<xsl:value-of select="ehu:denPropuesta" />
																				</xsl:otherwise>							
																			</xsl:choose>																																	
																 		</li>			
																  	</xsl:if>														
														 	</xsl:if>
														 </xsl:for-each>
													</ul>
												</div>
											</div>
										</div>
							      	</xsl:if>
							    </xsl:for-each>
						    </div>
							<!-- Párrafo para "Arriba" -->
							<a href="#listTab" class="pull-right back-to-top"><span><xsl:value-of select="languageUtil:get($locale,'up')"/> <span class="icon-chevron-up"></span></span></a>						    
						</xsl:when>
						
						<xsl:when test="$p_nav = 'S'">
								
								<!-- Doctorados ordenados por ambito -->
								<xsl:variable name="scopes_sorted_copy">
									<xsl:for-each select="ehu:app/ehu:doctorados/ehu:doctorado">
								        <xsl:sort select="ehu:desAmbito"/>
								        <xsl:copy-of select="current()"/>							        	
								    </xsl:for-each>
							    </xsl:variable>
							    <xsl:variable name="scopes_sorted_node_set" select="exsl:node-set($scopes_sorted_copy)/*" />

								<div class="elements__list">	
								    <xsl:for-each select="$scopes_sorted_node_set">
								    	<xsl:variable name="scope_id" select="ehu:ambito"/>
								    	<xsl:variable name="scope" select="ehu:desAmbito"/>
										<xsl:variable name="previous_scope" select="preceding-sibling::*[1]/ehu:desAmbito" />
								    
								    	
								    	<xsl:if test="not($previous_scope = $scope) and  ($scope!= '')">
								      		<div class="panel">
									      		<h3 class="panel-title">
									      			<a role="button" class="own-accordion" tabindex="0" onclick="handleCommandClick(this,event)" onKeyDown="handleCommand(this,event)">
														<xsl:value-of select="$scope"/>
													</a>
												</h3>
												<div class="panel-collapse">
													<div class="panel-body">				
														<ul>
															 <xsl:for-each select="$scopes_sorted_node_set">
															 	<xsl:variable name="scope_sub" select="ehu:desAmbito"/>
															 	<xsl:variable name="next_scope" select="following-sibling::*[1]/ehu:desAmbito" />
															 	
															 	<!--  XSL no permite generar HTML dinámico, por lo que si creamos un elemento li dentro de un if falla. Para poder crear listas 
															 	y sublistas bien definidas con ul li ul li debemos volver a recorrer la lista y coger los que sean iguales o utilizar tags como for-each-group-->
															 	<xsl:if test="$scope_sub = $scope">
															 		<xsl:variable name="program_url" select="ehu:urlInicio"/>
															 		<xsl:if test="($program_url!='')">	
																 		<li>
																 			
																			<xsl:choose>
																				<xsl:when test="$program_url != $void">
																					<a tabindex="-1">
																							<xsl:attribute name="href"><xsl:value-of select="$program_url"/></xsl:attribute>
																					 		<xsl:value-of select="ehu:denPropuesta" />							  								  		
																					</a>
																				</xsl:when>
																				<xsl:otherwise>
																					<xsl:value-of select="ehu:denPropuesta" />
																				</xsl:otherwise>							
																			</xsl:choose>	
																																		
																 		</li>									
																	</xsl:if>
															 	</xsl:if>
															 </xsl:for-each>
														</ul>
													</div>
												</div>
											</div>
							      	</xsl:if>
							    </xsl:for-each>
							</div>
							<!-- Párrafo para "Arriba" -->
							<a href="#listTab" class="pull-right back-to-top"><span><xsl:value-of select="languageUtil:get($locale,'up')"/> <span class="icon-chevron-up"></span></span></a>
						</xsl:when>
						<xsl:otherwise>
							<!-- Doctorados ordenados por alfabéticamente -->
							<ul class="elements__list">
								<xsl:for-each select="ehu:app/ehu:doctorados/ehu:doctorado">
									<xsl:variable name="program_url" select="ehu:urlInicio"/>
									<xsl:if test="($program_url!='')">	
										<li>
											<xsl:choose>
												<xsl:when test="$program_url != $void">
												<a>
													<xsl:attribute name="href"><xsl:value-of select="$program_url"/></xsl:attribute>
											 		<xsl:value-of select="ehu:denPropuesta" />							  								  		
											  	</a>
											  	</xsl:when>
											  	<xsl:otherwise>
											  		<xsl:value-of select="ehu:denPropuesta" />
											  	</xsl:otherwise>							
											</xsl:choose>						
										</li>				
									</xsl:if>	
								</xsl:for-each>
							</ul>  
							<!-- Párrafo para "Arriba" -->
							<p>
								<a>  
									<xsl:attribute name="href">#listTab</xsl:attribute>
									<xsl:attribute name="class">pull-right back-to-top</xsl:attribute>
										<span>
											<xsl:value-of select="languageUtil:get($locale, 'up')"/>
											<xsl:value-of select="$white_space"/>
											<span>
												<xsl:attribute name="class">icon-chevron-up</xsl:attribute>
											</span>
										</span>
								</a>
							</p>								
						</xsl:otherwise>
						</xsl:choose>	
					<!-- /ul -->							
				</div>
			
		
			
		</div>
		
		
			
	</xsl:template>
	
</xsl:stylesheet>