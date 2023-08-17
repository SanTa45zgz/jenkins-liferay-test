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
		
		<xsl:include href="http://localhost:8080/o/ehu-xsl-content-web/common-newws/common.xsl"/>
			
		<xsl:template match="/">
		
			<!-- Parametros propios del listado de doctorados -->
			<xsl:variable name="titulo" select="languageUtil:get($locale,'ehu.xsl-content.title.plew0040-offer')"/>
			<div class="ehu-oferta-grados">
				<xsl:attribute name="class">xsl-content graduates</xsl:attribute>

				<xsl:call-template name="header">
					<xsl:with-param name="title" select="$titulo"/>
				</xsl:call-template>
				
				<div class="ehu-oferta-grados__filtros">
					<xsl:attribute name="id">listTab</xsl:attribute>
					<!-- html  codigo buscador -->
					<form name="form-search" action="javascript:processHtmlGrades()">
						<div class="form-group">
						    <div class="ehu-oferta-grados__filtros__search">
						    	<button type="submit"> 
						    		<span class="sr-only"><xsl:value-of select="languageUtil:get($locale,'ehu.search')"/></span>
						    	</button>
						    	<input type="hidden" class="form-control" name="idioma">
						    		<xsl:attribute name="value"><xsl:value-of select="$idioma"/></xsl:attribute>
						    	</input>
						    	<input type="hidden" class="form-control" name="proceso">
						    		<xsl:attribute name="value"><xsl:value-of select="$proceso"/></xsl:attribute>
						    	</input>
						    	<input type="hidden" class="form-control nav" name="navegacion">
						    		<xsl:attribute name="value"><xsl:value-of select="$navegacion"/></xsl:attribute>
						    	</input>
								<label for="search" class="sr-only"><xsl:value-of select="languageUtil:get($locale,'ehu.search')"/>:</label>
						    	<input type="search" class="form-control search" name="p_search" id="search">
                                    <xsl:attribute name="placeholder"><xsl:value-of select="languageUtil:get($locale,'ehu.search.grados.oferta.place-holder')"/></xsl:attribute>
                                </input>
						    </div>
						</div>
					</form>	
					<!-- html  codigo buscador -->
					<ul>
						<xsl:attribute name="id">list</xsl:attribute>
						<xsl:attribute name="class">nav nav-pills</xsl:attribute>
						<xsl:choose>
							<xsl:when test="$navegacion != ''">
								<li>
									<xsl:if test="$navegacion = 'A'">
										<xsl:attribute name="class">active</xsl:attribute>							
									</xsl:if>							
									<a>
										<xsl:attribute name="href">?idioma=<xsl:value-of select="$idioma"/>&amp;proceso=<xsl:value-of select="$proceso"/>&amp;navegacion=A</xsl:attribute>
										<xsl:value-of select="languageUtil:get($locale,'ehu.order-by.oferta.alphabetic')"/>
									</a>
								</li>
								<li>
									<xsl:if test="$navegacion = 'R'">
										<xsl:attribute name="class">active</xsl:attribute>							
									</xsl:if>							
									<a>
										<xsl:attribute name="href">?idioma=<xsl:value-of select="$idioma"/>&amp;proceso=<xsl:value-of select="$proceso"/>&amp;navegacion=R</xsl:attribute>
										<xsl:value-of select="languageUtil:get($locale,'ehu.order-by.oferta.branches')"/>
									</a>
								</li>
								<li>
									<xsl:if test="$navegacion = 'B'">
										<xsl:attribute name="class">active</xsl:attribute>							
									</xsl:if>							
									<a>
										<xsl:attribute name="href">?idioma=<xsl:value-of select="$idioma"/>&amp;proceso=<xsl:value-of select="$proceso"/>&amp;navegacion=B</xsl:attribute>
										<xsl:value-of select="languageUtil:get($locale,'ehu.xsl-content-grado.doble')"/>
									</a>
								</li>
								<li>
									<xsl:if test="$navegacion = 'D'">
										<xsl:attribute name="class">active</xsl:attribute>							
									</xsl:if>							
									<a>
										<xsl:attribute name="href">?idioma=<xsl:value-of select="$idioma"/>&amp;proceso=<xsl:value-of select="$proceso"/>&amp;navegacion=D</xsl:attribute>
										<xsl:value-of select="languageUtil:get($locale,'ehu.search.masteres.titulos.propios.dual')"/>
									</a>
								</li>
								<li>
									<xsl:if test="$navegacion = 'I'">
										<xsl:attribute name="class">active</xsl:attribute>							
									</xsl:if>							
									<a>
										<xsl:attribute name="href">?idioma=<xsl:value-of select="$idioma"/>&amp;proceso=<xsl:value-of select="$proceso"/>&amp;navegacion=I</xsl:attribute>
										<xsl:value-of select="languageUtil:get($locale,'ehu.search.masteres.titulos.propios.internacional')"/>
									</a>
								</li>
								<li>
									<xsl:if test="$navegacion = 'C'">
										<xsl:attribute name="class">active</xsl:attribute>							
									</xsl:if>							
									<a>
										<xsl:attribute name="href">?idioma=<xsl:value-of select="$idioma"/>&amp;proceso=<xsl:value-of select="$proceso"/>&amp;navegacion=C</xsl:attribute>
										<xsl:value-of select="languageUtil:get($locale,'ehu.order-by.oferta.campuses')"/>
									</a>
								</li>
														
							</xsl:when>
							<xsl:otherwise>
								<li>					
									<xsl:attribute name="class">active</xsl:attribute>
									<a>
										<xsl:attribute name="href">?idioma=<xsl:value-of select="$idioma"/>&amp;proceso=<xsl:value-of select="$proceso"/>&amp;navegacion=A</xsl:attribute>
										<xsl:value-of select="languageUtil:get($locale,'ehu.order-by.oferta.alphabetic')"/>
									</a>
								</li>
								<li>
									
									<a>
										<xsl:attribute name="href">?idioma=<xsl:value-of select="$idioma"/>&amp;proceso=<xsl:value-of select="$proceso"/>&amp;navegacion=R</xsl:attribute>
										<xsl:value-of select="languageUtil:get($locale,'ehu.order-by.oferta.branches')"/>
									</a>
								</li>
								<li>
									<a>
										<xsl:attribute name="href">?idioma=<xsl:value-of select="$idioma"/>&amp;proceso=<xsl:value-of select="$proceso"/>&amp;navegacion=B</xsl:attribute>
										<xsl:value-of select="languageUtil:get($locale,'ehu.xsl-content-grado.doble')"/>
									</a>
								</li>
								<li>
									<a>
										<xsl:attribute name="href">?idioma=<xsl:value-of select="$idioma"/>&amp;proceso=<xsl:value-of select="$proceso"/>&amp;navegacion=D</xsl:attribute>
										<xsl:value-of select="languageUtil:get($locale,'ehu.search.masteres.titulos.propios.dual')"/>
									</a>
								</li>
								<li>
									<a>
										<xsl:attribute name="href">?idioma=<xsl:value-of select="$idioma"/>&amp;proceso=<xsl:value-of select="$proceso"/>&amp;navegacion=I</xsl:attribute>
										<xsl:value-of select="languageUtil:get($locale,'ehu.search.masteres.titulos.propios.internacional')"/>
									</a>
								</li>
										
								
								<li>
									<a>
										<xsl:attribute name="href">?idioma=<xsl:value-of select="$idioma"/>&amp;proceso=<xsl:value-of select="$proceso"/>&amp;navegacion=C</xsl:attribute>
										<xsl:value-of select="languageUtil:get($locale,'ehu.order-by.oferta.campuses')"/>
									</a>
								</li>
								
							</xsl:otherwise>
						</xsl:choose>					
					</ul>		
				</div>
				<div class="ehu-oferta-grados__lists">
					<xsl:choose>
						<xsl:when test="$navegacion = 'R'">
						<h2><xsl:attribute name="class">hide-accessible</xsl:attribute><xsl:value-of select="languageUtil:get($locale,'ehu.order-by.alphabetic')"/></h2>
						</xsl:when>
						<xsl:when test="$navegacion = 'B'">
							<h2><xsl:attribute name="class">hide-accessible</xsl:attribute><xsl:value-of select="languageUtil:get($locale,'ehu.xsl-content-grado.doble')"/></h2>
						</xsl:when>
						<xsl:when test="$navegacion = 'D'">
							<h2><xsl:attribute name="class">hide-accessible</xsl:attribute><xsl:value-of select="languageUtil:get($locale,'ehu.search.masteres.titulos.propios.dual')"/></h2>
						</xsl:when>
						<xsl:when test="$navegacion = 'I'">
							<h2><xsl:attribute name="class">hide-accessible</xsl:attribute><xsl:value-of select="languageUtil:get($locale,'ehu.search.masteres.titulos.propios.internacional')"/></h2>
						</xsl:when>
						<xsl:when test="$navegacion = 'C'">
							<h2><xsl:attribute name="class">hide-accessible</xsl:attribute><xsl:value-of select="languageUtil:get($locale,'ehu.order-by.campuses')"/></h2>
						</xsl:when>
						
						<xsl:otherwise>
							<h2><xsl:attribute name="class">hide-accessible</xsl:attribute><xsl:value-of select="languageUtil:get($locale,'ehu.order-by.alphabetic')"/></h2>
						</xsl:otherwise>
					</xsl:choose>
				<!-- ul-->
					<xsl:choose>
						<xsl:when test="$navegacion = 'C'">

							<!-- Grados ordenados por campus -->
							<xsl:variable name="campus_sorted_copy">
								<xsl:for-each select="ehu:app/ehu:grados/ehu:grado">
							       <xsl:sort select="ehu:desCampus"/>
							       <xsl:copy-of select="current()"/>							        	
							    </xsl:for-each>
							</xsl:variable>
							<xsl:variable name="campus_sorted_node_set" select="exsl:node-set($campus_sorted_copy)/*" />
							
							<div class="elements__list">   
							    <xsl:for-each select="$campus_sorted_node_set">
							    	<xsl:variable name="campus_id" select="ehu:codCampus"/>
								    <xsl:variable name="campus" select="ehu:desCampus"/>
									<xsl:variable name="previous_campus" select="preceding-sibling::*[1]/ehu:desCampus" />
							    	
							    	<xsl:if test="not($previous_campus = $campus) and ($campus!='')">
							      		<div class="panel">
								      		<h3 class="panel-title">
								      			<a role="button"  class="own-accordion" tabindex="0" onclick="handleCommandClick(this,event)" onKeyDown="handleCommand(this,event)">
													<xsl:value-of select="$campus"/>
												</a>
											</h3>
											<div class="panel-collapse">
												<div class="panel-body">					
													<ul>
														 <xsl:for-each select="$campus_sorted_node_set">
														 	<xsl:variable name="campus_sub" select="ehu:desCampus"/>
														 	<xsl:variable name="next_campus" select="following-sibling::*[1]/ehu:desCampus" />
														 	
														 	<!--  XSL no permite generar HTML dinámico, por lo que si creamos un elemento li dentro de un if falla. Para poder crear listas 
														 	y sublistas bien definidas con ul li ul li debemos volver a recorrer la lista y coger los que sean iguales o utilizar tags como for-each-group-->
														 	<xsl:if test="$campus_sub = $campus">
														 		<li>
														 			<xsl:variable name="program_url" select="ehu:urlInicio"/>
																	<xsl:choose>
																		<xsl:when test="$program_url != $void">
																			<a tabindex="-1">
																				<xsl:attribute name="href"><xsl:value-of select="$program_url"/></xsl:attribute>
																		 		<xsl:value-of select="ehu:desPlan" />
																		 		<small>
																			 		<xsl:value-of select="$white_space" />(<xsl:value-of select="ehu:desCampus" />)
												  									<xsl:value-of select="$white_space" />(<xsl:value-of select="ehu:desCentro" />)
											  									</small>
																				<span class="d-none"><xsl:value-of select="ehu:desCampoCientifico" /></span>
																			</a>
																		</xsl:when>
																		<xsl:otherwise>
																			<xsl:value-of select="ehu:desPlan" />
																			<small>
																				<xsl:value-of select="$white_space" />(<xsl:value-of select="ehu:desCampus" />)
																				<xsl:value-of select="$white_space" />(<xsl:value-of select="ehu:desCentro" />)
																			</small>
																			<span class="d-none"><xsl:value-of select="ehu:desCampoCientifico" /></span>
																		</xsl:otherwise>
																	</xsl:choose>
														 		</li>
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
						
						
						
						<xsl:when test="$navegacion = 'D'">
								
								<!-- Grados ordenados por dual -->
								<xsl:variable name="dual_sorted_copy">
									<xsl:for-each select="ehu:app/ehu:grados/ehu:grado">
								        <xsl:sort select="ehu:desPlan"/>
								        <xsl:variable name="aux" select="ehu:dual"/>
								        <xsl:if test="$aux != $void">
								        	<xsl:copy-of select="current()"/>
								        </xsl:if>							        	
								    </xsl:for-each>
							    </xsl:variable>
							    <xsl:variable name="dual_sorted_node_set" select="exsl:node-set($dual_sorted_copy)/*" />

								<div class="elements__list">	
									<div class="panel">
										
								    	<xsl:for-each select="$dual_sorted_node_set">	
								    	<ul>	
								    		<li>
												<xsl:variable name="program_url" select="ehu:urlInicio"/>
												<xsl:choose>
													<xsl:when test="$program_url != $void">
														<a tabindex="-1">
															<xsl:attribute name="href"><xsl:value-of select="$program_url"/></xsl:attribute>
															<xsl:value-of select="ehu:desPlan" />
															<small>
																<xsl:value-of select="$white_space" />(<xsl:value-of select="ehu:desCampus" />)
																<xsl:value-of select="$white_space" />(<xsl:value-of select="ehu:desCentro" />)
															</small>
															<span class="d-none"><xsl:value-of select="ehu:desCampoCientifico" /></span>
														</a>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="ehu:desPlan" />
														<small>
															<xsl:value-of select="$white_space" />(<xsl:value-of select="ehu:desCampus" />)
															<xsl:value-of select="$white_space" />(<xsl:value-of select="ehu:desCentro" />)
														</small>
														<span class="d-none"><xsl:value-of select="ehu:desCampoCientifico" /></span>
													</xsl:otherwise>
												</xsl:choose>
											</li>
										</ul>
										</xsl:for-each>
								</div>
							</div>
							<!-- Párrafo para "Arriba" -->
							<a href="#listTab" class="pull-right back-to-top"><span><xsl:value-of select="languageUtil:get($locale,'up')"/> <span class="icon-chevron-up"></span></span></a>
						</xsl:when>
						
						<xsl:when test="$navegacion = 'I'">
								
								<!-- Grados ordenados por dual -->
								<xsl:variable name="internacional_sorted_copy">
									<xsl:for-each select="ehu:app/ehu:grados/ehu:grado">
								        <xsl:sort select="ehu:internacional"/>
								        <xsl:variable name="aux" select="ehu:internacional"/>
								        <xsl:if test="$aux != $void">
								        	<xsl:copy-of select="current()"/>
								        </xsl:if>							        	
								    </xsl:for-each>
							    </xsl:variable>
							    <xsl:variable name="internacional_sorted_node_set" select="exsl:node-set($internacional_sorted_copy)/*" />

								<div class="elements__list">	
								    <xsl:for-each select="$internacional_sorted_node_set">
								    	<xsl:variable name="internacional" select="ehu:internacional"/>
										<xsl:variable name="previous_internacional" select="preceding-sibling::*[1]/ehu:internacional" />
								    	
								    
								    	
								    	<xsl:if test="not($previous_internacional = $internacional) and ($internacional!='')">
								      		<div class="panel">
									      		<h3 class="panel-title">
									      			<a role="button" class="own-accordion" tabindex="0" onclick="handleCommandClick(this,event)" onKeyDown="handleCommand(this,event)">
														<xsl:value-of select="$internacional"/>
													</a>
												</h3>
												<div class="panel-collapse">
													<div class="panel-body">				
														<ul>
															 <xsl:for-each select="$internacional_sorted_node_set">
															 	<xsl:variable name="internacional_sub" select="ehu:internacional"/>
													 			<xsl:variable name="next_internacional" select="following-sibling::*[1]/ehu:internacional" />
															 	
															 	<!--  XSL no permite generar HTML dinámico, por lo que si creamos un elemento li dentro de un if falla. Para poder crear listas 
															 	y sublistas bien definidas con ul li ul li debemos volver a recorrer la lista y coger los que sean iguales o utilizar tags como for-each-group-->
															 	<xsl:if test="$internacional_sub = $internacional">
															 		<li>
															 			<xsl:variable name="program_url" select="ehu:urlInicio"/>
																		<xsl:choose>
																			<xsl:when test="$program_url != $void">
																				<a tabindex="-1">
																					<xsl:attribute name="href"><xsl:value-of select="$program_url"/></xsl:attribute>
																			 		<xsl:value-of select="ehu:desPlan" />
																			 		<small>
																						<xsl:value-of select="$white_space" />(<xsl:value-of select="ehu:desCampus" />)
																						<xsl:value-of select="$white_space" />(<xsl:value-of select="ehu:desCentro" />)
																					</small>
																					<span class="d-none"><xsl:value-of select="ehu:desCampoCientifico" /></span>
																				</a>
																			</xsl:when>
																			<xsl:otherwise>
																				<xsl:value-of select="ehu:desPlan" />
																				<small>
																					<xsl:value-of select="$white_space" />(<xsl:value-of select="ehu:desCampus" />)
																					<xsl:value-of select="$white_space" />(<xsl:value-of select="ehu:desCentro" />)
																				</small>
																				<span class="d-none"><xsl:value-of select="ehu:desCampoCientifico" /></span>
																			</xsl:otherwise>
																		</xsl:choose>
															 		</li>
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
						
						<xsl:when test="$navegacion = 'B'">
								
							<!-- Dobles grados-->
							<xsl:variable name="doble_sorted_copy">
								<xsl:for-each select="ehu:app/ehu:grados/ehu:grado">
								    <xsl:sort select="ehu:indDobleGrado"/>
								    <xsl:variable name="aux" select="ehu:indDobleGrado"/>
								     <xsl:if test="$aux = '1'">
								       	<xsl:copy-of select="current()"/>
								     </xsl:if>							        	
								 </xsl:for-each>
							 </xsl:variable>
							 <xsl:variable name="doble_sorted_node_set" select="exsl:node-set($doble_sorted_copy)/*" />

							<div class="elements__list">
								<div class="panel">
									<ul>
							
										<xsl:for-each select="$doble_sorted_node_set">
										 	<xsl:variable name="program_url" select="ehu:urlInicio"/>
													<li>
														<xsl:choose>
															<xsl:when test="$program_url != $void">
															<a tabindex="-1">
																<xsl:attribute name="href"><xsl:value-of select="$program_url"/></xsl:attribute>
														 		<xsl:value-of select="ehu:desPlan" />
														 		<small>
																	<xsl:value-of select="$white_space" />(<xsl:value-of select="ehu:desCampus" />)
																	<xsl:value-of select="$white_space" />(<xsl:value-of select="ehu:desCentro" />)
																</small>
																<span class="d-none"><xsl:value-of select="ehu:desCampoCientifico" /></span>
														  	</a>
														  	</xsl:when>
														  	<xsl:otherwise>
														  		<xsl:value-of select="ehu:desPlan" />
														  		<small>
																	<xsl:value-of select="$white_space" />(<xsl:value-of select="ehu:desCampus" />)
																	<xsl:value-of select="$white_space" />(<xsl:value-of select="ehu:desCentro" />)
																</small>
																<span class="d-none"><xsl:value-of select="ehu:desCampoCientifico" /></span>
														  	</xsl:otherwise>
														</xsl:choose>
													</li>
									    </xsl:for-each>
									  </ul>
									</div>
							</div>
							<!-- Párrafo para "Arriba" -->
							<a href="#listTab" class="pull-right back-to-top"><span><xsl:value-of select="languageUtil:get($locale,'up')"/> <span class="icon-chevron-up"></span></span></a>
						</xsl:when>
						
						
						<xsl:when test="$navegacion = 'R'">
							<!-- Grados ordenados por rama -->
							<xsl:variable name="branch_sorted_copy">
								<xsl:for-each select="ehu:app/ehu:grados/ehu:grado">
									<xsl:sort select="ehu:campoCientifico"/>
								    <xsl:copy-of select="current()"/>							        	
								</xsl:for-each>
							</xsl:variable>
							<xsl:variable name="branch_sorted_node_set" select="exsl:node-set($branch_sorted_copy)/*" />

							<div class="elements__list">	
								<xsl:for-each select="$branch_sorted_node_set">
								  	<xsl:variable name="anchor" select="ehu:campoCientifico"/>
									<xsl:variable name="branch" select="ehu:desCampoCientifico"/>
									<xsl:variable name="previous_branch" select="preceding-sibling::*[1]/ehu:desCampoCientifico" />
								    	
								    
									<xsl:if test="not($previous_branch = $branch) and ($branch!='')">
								      	<div class="panel">
									      	<h3 class="panel-title">
									      		<a role="button" class="own-accordion" tabindex="0" onclick="handleCommandClick(this,event)" onKeyDown="handleCommand(this,event)">
													<xsl:value-of select="$branch"/>
												</a>
											</h3>
											<div class="panel-collapse">
												<div class="panel-body">				
													<ul>
														<xsl:for-each select="$branch_sorted_node_set">
															<xsl:variable name="branch_sub" select="ehu:desCampoCientifico"/>
													 		<xsl:variable name="next_branch" select="following-sibling::*[1]/ehu:desCampoCientifico" />
															 	
															 	<!--  XSL no permite generar HTML dinámico, por lo que si creamos un elemento li dentro de un if falla. Para poder crear listas 
															 	y sublistas bien definidas con ul li ul li debemos volver a recorrer la lista y coger los que sean iguales o utilizar tags como for-each-group-->
															 	<xsl:if test="$branch_sub = $branch">
															 		<li>
															 			<xsl:variable name="program_url" select="ehu:urlInicio"/>
																		<xsl:choose>
																			<xsl:when test="$program_url != $void">
																				<a>
																					<xsl:attribute name="href"><xsl:value-of select="$program_url"/></xsl:attribute>
																		 			<xsl:value-of select="ehu:desPlan" />
																		 			<small>
																						<xsl:value-of select="$white_space" />(<xsl:value-of select="ehu:desCampus" />)
																						<xsl:value-of select="$white_space" />(<xsl:value-of select="ehu:desCentro" />)
																					</small>
																					<span class="d-none"><xsl:value-of select="ehu:desCampoCientifico" /></span>
																				</a>
																			</xsl:when>
																			<xsl:otherwise>
																				<xsl:value-of select="ehu:desPlan" />
																				<small>
																					<xsl:value-of select="$white_space" />(<xsl:value-of select="ehu:desCampus" />)
																					<xsl:value-of select="$white_space" />(<xsl:value-of select="ehu:desCentro" />)
																				</small>
																				<span class="d-none"><xsl:value-of select="ehu:desCampoCientifico" /></span>
																			</xsl:otherwise>
																		</xsl:choose>
															 		</li>
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
							<!-- Grados ordenados alfabéticamente -->
								
							<div class="elements__list">
								<div class="panel">
									<ul>	
										<xsl:for-each select="ehu:app/ehu:grados/ehu:grado">
											<xsl:variable name="program_url" select="ehu:urlInicio"/>
												<li>
													<xsl:choose>
														<xsl:when test="$program_url != $void">
														<a tabindex="-1">
															<xsl:attribute name="href"><xsl:value-of select="$program_url"/></xsl:attribute>
															<xsl:value-of select="ehu:desPlan" />
															<small>
																<xsl:value-of select="$white_space" />(<xsl:value-of select="ehu:desCampus" />)
																<xsl:value-of select="$white_space" />(<xsl:value-of select="ehu:desCentro" />)
															</small>
															<span class="d-none"><xsl:value-of select="ehu:desCampoCientifico" /></span>
														</a>
														</xsl:when>
														<xsl:otherwise>
															<xsl:value-of select="ehu:desPlan" />
															<small>
																<xsl:value-of select="$white_space" />(<xsl:value-of select="ehu:desCampus" />)
																<xsl:value-of select="$white_space" />(<xsl:value-of select="ehu:desCentro" />)
															</small>
															<span class="d-none"><xsl:value-of select="ehu:desCampoCientifico" /></span>
														</xsl:otherwise>
													</xsl:choose>
												</li>
											</xsl:for-each>
									</ul>
								</div>
							</div>  
							<!-- Párrafo para "Arriba" -->
							<a href="#listTab" class="pull-right back-to-top"><span><xsl:value-of select="languageUtil:get($locale,'up')"/> <span class="icon-chevron-up"></span></span></a>	
		
						</xsl:otherwise>
						</xsl:choose>	
					<!-- /ul -->							
				</div>
			
		
			
		</div>
		
		
			
	</xsl:template>
	
</xsl:stylesheet>