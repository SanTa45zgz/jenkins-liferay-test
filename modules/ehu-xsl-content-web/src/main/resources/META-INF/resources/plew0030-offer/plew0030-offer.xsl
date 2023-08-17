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
			<!-- Parametros propios del listado de masteres y titulos propios -->
			<xsl:variable name="titulo" select="languageUtil:get($locale,'ehu.xsl-content.title.plew0030-offer')" />
			<div class="ehu-oferta-masteres-titulos-propios">
				<xsl:attribute name="class">xsl-content phds</xsl:attribute>

				<xsl:call-template name="header">
					<xsl:with-param name="title" select="$titulo"/>
				</xsl:call-template>
				
				<div class="ehu-oferta-masteres-titulos-propios__filtros">
					<xsl:attribute name="id">listTab</xsl:attribute>
					<!-- html  codigo buscador -->
					<form name="form-search" action="javascript:processHtmlMaster()">
						<div class="form-group">
						    <div class="ehu-oferta-masteres-titulos-propios__filtros__search">
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
						    	<input type="search" class="form-control search" name="search" id="search">
                                    <xsl:attribute name="placeholder"><xsl:value-of select="languageUtil:get($locale,'ehu.search.masteres.titulos.propios.oferta.place-holder')"/></xsl:attribute>
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
									<xsl:if test="$navegacion = 'M'">
										<xsl:attribute name="class">active</xsl:attribute>							
									</xsl:if>							
									<a>
										<xsl:attribute name="href">?idioma=<xsl:value-of select="$idioma"/>&amp;proceso=<xsl:value-of select="$proceso"/>&amp;navegacion=M</xsl:attribute>
										<xsl:value-of select="languageUtil:get($locale,'ehu.order-by.oferta.masters')"/>
									</a>
								</li>
								<li>
									<xsl:if test="$navegacion = 'T'">
										<xsl:attribute name="class">active</xsl:attribute>							
									</xsl:if>							
									<a>
										<xsl:attribute name="href">?idioma=<xsl:value-of select="$idioma"/>&amp;proceso=<xsl:value-of select="$proceso"/>&amp;navegacion=T</xsl:attribute>
										<xsl:value-of select="languageUtil:get($locale,'ehu.order-by.oferta.own-titles')"/>
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
									<xsl:if test="$navegacion = 'O'">
										<xsl:attribute name="class">active</xsl:attribute>							
									</xsl:if>							
									<a>
										<xsl:attribute name="href">?idioma=<xsl:value-of select="$idioma"/>&amp;proceso=<xsl:value-of select="$proceso"/>&amp;navegacion=O</xsl:attribute>
										<xsl:value-of select="languageUtil:get($locale,'ehu.order-by.oferta.others')"/>
									</a>
								</li>																												
							</xsl:when>
							<xsl:otherwise>
								<li>
									<!-- Ponemos la pestaña de alfabético como activa por defecto -->
									<xsl:attribute name="class">active</xsl:attribute>
									<a>
										<xsl:attribute name="href">?idioma=<xsl:value-of select="$idioma"/>&amp;proceso=<xsl:value-of select="$proceso"/>&amp;navegacion=A</xsl:attribute>
										<xsl:value-of select="languageUtil:get($locale,'ehu.order-by.oferta.alphabetic')"/>
									</a>
								</li>														
								<li>
									<a>
										<xsl:attribute name="href">?idioma=<xsl:value-of select="$idioma"/>&amp;proceso=<xsl:value-of select="$proceso"/>&amp;navegacion=M</xsl:attribute>
										<xsl:value-of select="languageUtil:get($locale,'ehu.order-by.oferta.masters')"/>
									</a>
								</li>	
								<li>
									<a>
										<xsl:attribute name="href">?idioma=<xsl:value-of select="$idioma"/>&amp;proceso=<xsl:value-of select="$proceso"/>&amp;navegacion=T</xsl:attribute>
										<xsl:value-of select="languageUtil:get($locale,'ehu.order-by.oferta.own-titles')"/>
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
										<xsl:attribute name="href">?idioma=<xsl:value-of select="$idioma"/>&amp;proceso=<xsl:value-of select="$proceso"/>&amp;navegacion=O</xsl:attribute>
										<xsl:value-of select="languageUtil:get($locale,'ehu.order-by.oferta.others')"/>
									</a>
								</li>												
							</xsl:otherwise>
						</xsl:choose>					
					</ul>		
				</div>
				<div class="ehu-oferta-masteres-titulos-propios__lists">
					<xsl:choose>
						<xsl:when test="$navegacion = 'A'">
							<h2><xsl:attribute name="class">hide-accessible</xsl:attribute><xsl:value-of select="languageUtil:get($locale,'ehu.order-by.oferta.alphabetic')"/></h2>							
						</xsl:when>	
						<xsl:when test="$navegacion = 'M'">
							 	<h2><xsl:attribute name="class">hide-accessible</xsl:attribute><xsl:value-of select="languageUtil:get($locale,'ehu.order-by.oferta.masters')"/></h2>
						</xsl:when>
						<xsl:when test="$navegacion = 'T'">
							 	<h2><xsl:attribute name="class">hide-accessible</xsl:attribute><xsl:value-of select="languageUtil:get($locale,'ehu.order-by.oferta.own-titles')"/></h2>
						</xsl:when>		
						<xsl:when test="$navegacion = 'R'">
							 	<h2><xsl:attribute name="class">hide-accessible</xsl:attribute><xsl:value-of select="languageUtil:get($locale,'ehu.order-by.oferta.branches')"/></h2>
						</xsl:when>							
						<xsl:otherwise>						
							<h2><xsl:attribute name="class">hide-accessible</xsl:attribute><xsl:value-of select="languageUtil:get($locale,'ehu.order-by.oferta.others')"/></h2>
						</xsl:otherwise>															
					</xsl:choose>
					
					
					
					
					<xsl:choose>	
						<xsl:when test="$navegacion = 'M'">
														
							<!-- Masteres ordenados alfabeticamente -->
							<xsl:if test="ehu:app/ehu:titulos/ehu:titulo[ehu:tipoEnsenanza='master' and ehu:listaOfertaWeb='1']">				
								<xsl:variable name="masters_sorted_copy">
									<xsl:for-each select="ehu:app/ehu:titulos/ehu:titulo[ehu:tipoEnsenanza='master' and ehu:listaOfertaWeb='1']">
								        <xsl:sort select="ehu:denMaster"/>
								        <xsl:copy-of select="current()"/>							        	
								    </xsl:for-each>
							    </xsl:variable>
							   <xsl:variable name="masters_sorted_node_set" select="exsl:node-set($masters_sorted_copy)/*" />
							   						  
							  <ul class="elements__list">   							    							    	
									<xsl:for-each select="$masters_sorted_node_set">																		
										<xsl:variable name="program_url" select="ehu:urlInicio"/>				
										<xsl:if test="($program_url!='')">		
											<li>																 			
												<xsl:variable name="master_denMaster" select="ehu:denMaster"/>
													<xsl:choose>
															<xsl:when test="$program_url != $void">
																<a tabindex="-1">
																		<xsl:attribute name="href"><xsl:value-of select="$program_url"/></xsl:attribute>
																	 		<xsl:value-of select="$master_denMaster" />							  								  		
																</a>
															</xsl:when>
															<xsl:otherwise>
																<xsl:value-of select="$master_denMaster" />
															</xsl:otherwise>							
														</xsl:choose>																																	
											</li>
										</xsl:if>																										
									</xsl:for-each>
								</ul>								
								<!-- Párrafo para "Arriba" -->
								<a href="#listTab" class="pull-right back-to-top"><span><xsl:value-of select="languageUtil:get($locale,'up')"/> <span class="icon-chevron-up"></span></span></a>
							</xsl:if>
						</xsl:when>
						
						
						<xsl:when test="$navegacion = 'T'">
								<!-- Titulos propios ordenados alfabeticamente -->
								<xsl:if test="ehu:app/ehu:titulos/ehu:titulo[ehu:tipoEnsenanza='TPR' and ehu:listaOfertaWeb='1']">	
						
						
						<!-- descTipoTitulo -->
						
						
									<xsl:variable name="tipoTitulo_sorted_copy">
										<xsl:for-each select="ehu:app/ehu:titulos/ehu:titulo[ehu:tipoEnsenanza='TPR' and ehu:listaOfertaWeb='1' and ehu:tipoTitulo='PMAST']">
									        
									        <xsl:copy-of select="current()"/>							        	
									    </xsl:for-each>
										<xsl:for-each select="ehu:app/ehu:titulos/ehu:titulo[ehu:tipoEnsenanza='TPR' and ehu:listaOfertaWeb='1' and ehu:tipoTitulo='PESPE']">
									        
									        <xsl:copy-of select="current()"/>							        	
									    </xsl:for-each>
										<xsl:for-each select="ehu:app/ehu:titulos/ehu:titulo[ehu:tipoEnsenanza='TPR' and ehu:listaOfertaWeb='1' and ehu:tipoTitulo='PEXPE']">
									        
									        <xsl:copy-of select="current()"/>							        	
									    </xsl:for-each>
										<xsl:for-each select="ehu:app/ehu:titulos/ehu:titulo[ehu:tipoEnsenanza='TPR' and ehu:listaOfertaWeb='1' and ehu:tipoTitulo='PREDI']">
									        
									        <xsl:copy-of select="current()"/>							        	
									    </xsl:for-each>
										<xsl:for-each select="ehu:app/ehu:titulos/ehu:titulo[ehu:tipoEnsenanza='TPR' and ehu:listaOfertaWeb='1' and ehu:tipoTitulo='PREGX']">
									        
									        <xsl:copy-of select="current()"/>							        	
									    </xsl:for-each>
								    </xsl:variable>
								   <xsl:variable name="tipoTitulo_sorted_node_set" select="exsl:node-set($tipoTitulo_sorted_copy)/*" />
								   						  						   
									
									<div class="elements__list">   
									    <xsl:for-each select="$tipoTitulo_sorted_node_set">
									    	<xsl:variable name="tipoTitulo_id" select="ehu:tipoTitulo"/>
									    	<xsl:variable name="tipoTitulo" select="ehu:descTipoTitulo"/>
											<xsl:variable name="previous_tipoTitulo" select="preceding-sibling::*[1]/ehu:descTipoTitulo" />																							  
										    	<xsl:if test="not($previous_tipoTitulo = $tipoTitulo) and ($tipoTitulo != '')">								    										    			
											      		<div class="panel">
												      		<h3 class="panel-title">
												      			<a role="button"  class="own-accordion" tabindex="0" onclick="handleCommandClick(this,event)" onKeyDown="handleCommand(this,event)">
																	<xsl:value-of select="$tipoTitulo"/>
																</a>
															</h3>
															<div class="panel-collapse">
																<div class="panel-body">					
																	<ul>
																		<xsl:variable name="sorted_copy">
																				<xsl:for-each select="$tipoTitulo_sorted_node_set">
																			        <xsl:sort select="ehu:denMaster"/>
																			        <xsl:copy-of select="current()"/>							        	
																			    </xsl:for-each>
																		    </xsl:variable>
																   		 <xsl:variable name="sorted_node_set" select="exsl:node-set($sorted_copy)/*" />
																	
																		 <xsl:for-each select="$sorted_node_set">
																		 	<xsl:variable name="tipoTitulo_sub" select="ehu:descTipoTitulo"/>
																		 	<xsl:variable name="next_tipoTitulo" select="following-sibling::*[1]/ehu:descTipoTitulo" />
																		 	
																		 	<!--  XSL no permite generar HTML dinámico, por lo que si creamos un elemento li dentro de un if falla. Para poder crear listas 
																		 	y sublistas bien definidas con ul li ul li debemos volver a recorrer la lista y coger los que sean iguales o utilizar tags como for-each-group-->
																		 	<xsl:if test="$tipoTitulo_sub = $tipoTitulo">																	 		
																		 		<xsl:variable name="program_url" select="ehu:urlInicio"/>					
																		 		<xsl:if test="($program_url!='')">		
																			 	  <li>	
																			 	  <xsl:variable name="titulo_denMaster" select="ehu:denMaster"/>					 		
																						<xsl:choose>
																							<xsl:when test="$program_url != $void">
																								<a tabindex="-1">
																									<xsl:attribute name="href"><xsl:value-of select="$program_url"/></xsl:attribute>
																							 		<xsl:value-of select="$titulo_denMaster" />
																							 		<!-- 
																							 		<xsl:value-of select="$customDenMaster" />
																							 		 -->																						 																							 																		 								  								  	
																								</a>
																							</xsl:when>
																							<xsl:otherwise>
																								<xsl:value-of select="$titulo_denMaster" />
																								<!--
																								<xsl:value-of select="$customDenMaster" />
																								-->	
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
							</xsl:if>							    
						</xsl:when>
						
						<!-- Ramas -->
						<xsl:when test="$navegacion = 'R'">						
							<xsl:variable name="branches_sorted_copy">
								<xsl:for-each select="ehu:app/ehu:titulos/ehu:titulo[ehu:listaOfertaWeb='1']">
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
																												   
								    	<xsl:if test="not($previous_branch = $branch) and ($branch != '')">
								      		<div class="panel">
									      		<h3 class="panel-title">
									      			<a role="button"  class="own-accordion" tabindex="0" onclick="handleCommandClick(this,event)" onKeyDown="handleCommand(this,event)">
														<xsl:value-of select="$branch"/>
													</a>
												</h3>
												<div class="panel-collapse">
													<div class="panel-body">					
														<ul>
															<xsl:variable name="sorted_copy">
																	<xsl:for-each select="$branches_sorted_node_set">
																        <xsl:sort select="ehu:denMaster"/>
																        <xsl:copy-of select="current()"/>							        	
																    </xsl:for-each>
															    </xsl:variable>
													   		 <xsl:variable name="sorted_node_set" select="exsl:node-set($sorted_copy)/*" />
														
														
															 <xsl:for-each select="$sorted_node_set">
															 	<xsl:variable name="branch_sub" select="ehu:desRama"/>
															 	<xsl:variable name="next_branch" select="following-sibling::*[1]/ehu:desRama" />
															 	
															 	
															 	
															 	
															 	<!--  XSL no permite generar HTML dinámico, por lo que si creamos un elemento li dentro de un if falla. Para poder crear listas 
															 	y sublistas bien definidas con ul li ul li debemos volver a recorrer la lista y coger los que sean iguales o utilizar tags como for-each-group-->
															 	<xsl:if test="$branch_sub = $branch">															 		
															 		<xsl:variable name="program_url" select="ehu:urlInicio"/>			
															 		<xsl:if test="($program_url!='')">		
																 		<li>																 			
																 			<xsl:variable name="master_denMaster" select="ehu:denMaster"/>
																			<xsl:choose>
																				<xsl:when test="$program_url != $void">
																					<a tabindex="-1">
																						<xsl:attribute name="href"><xsl:value-of select="$program_url"/></xsl:attribute>
																				 		<xsl:value-of select="$master_denMaster" />							  								  		
																					</a>
																				</xsl:when>
																				<xsl:otherwise>
																					<xsl:value-of select="$master_denMaster" />
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
						<!--  Otros -->
						<xsl:when test="$navegacion = 'O'">

							<div class="elements__list">   							   
							    	<xsl:variable name="others_erasmus" select="languageUtil:get($locale,'ehu.search.masteres.titulos.propios.erasmus')"/>
							    	<xsl:variable name="others_internacional" select="languageUtil:get($locale,'ehu.search.masteres.titulos.propios.internacional')"/>
							    	<xsl:variable name="others_dual" select="languageUtil:get($locale,'ehu.search.masteres.titulos.propios.dual')"/>
							    	<xsl:variable name="others_interuniversitario" select="languageUtil:get($locale,'ehu.search.masteres.titulos.propios.interuniversitario')"/>
							    	<xsl:variable name="interuniversitario_international" select="languageUtil:get($locale,'ehu.search.masteres.titulos.propios.interuniversitario.internacional')"/>


									<!-- Erasmus -->	
											<xsl:if test="ehu:app/ehu:titulos/ehu:titulo[ehu:Erasmus='1']">			
												
												<xsl:variable name="others_erasmus_sorted_node_set">
																<xsl:for-each select="ehu:app/ehu:titulos/ehu:titulo[ehu:listaOfertaWeb='1' and ehu:Erasmus='1']">
															        <xsl:sort select="ehu:denMaster"/>
															        <xsl:copy-of select="current()"/>							        	
															    </xsl:for-each>
														    </xsl:variable>
												  		  <xsl:variable name="others_erasmus_node_set" select="exsl:node-set($others_erasmus_sorted_node_set)/*" />
																																			   								    	
									      		<div class="panel">
										      		<h3 class="panel-title">
										      			<a role="button"  class="own-accordion" tabindex="0" onclick="handleCommandClick(this,event)" onKeyDown="handleCommand(this,event)">
															<xsl:value-of select="$others_erasmus"/>
														</a>
													</h3>												
													<div class="panel-collapse">
														<div class="panel-body">																																		
												  		  <ul>														
																 <xsl:for-each select="$others_erasmus_node_set">															 															 	
																 		<xsl:variable name="program_url" select="ehu:urlInicio"/>			
																 		<xsl:if test="($program_url!='')">		
																	 		<li>																 			
																	 			<xsl:variable name="denMaster" select="ehu:denMaster"/>
																				<xsl:choose>
																					<xsl:when test="$program_url != $void">
																						<a tabindex="-1">
																							<xsl:attribute name="href"><xsl:value-of select="$program_url"/></xsl:attribute>
																					 		<xsl:value-of select="$denMaster" />								  								  		
																						</a>
																					</xsl:when>
																					<xsl:otherwise>
																						<xsl:value-of select="$denMaster" />
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

										<!-- Internacional: debera comprobarse que es  Interuniversitario=1 y tiene en el campo textoInteruniv el valor  Interuniversitario internacional-->										
										<xsl:if test="ehu:app/ehu:titulos/ehu:titulo[ehu:Interuniversitario='1' and ehu:textoInteruniv=$interuniversitario_international]">
												<xsl:variable name="others_internacional_sorted_node_set">
																	<xsl:for-each select="ehu:app/ehu:titulos/ehu:titulo[ehu:listaOfertaWeb='1' and ehu:Interuniversitario='1' and ehu:textoInteruniv=$interuniversitario_international]">
																        <xsl:sort select="ehu:denMaster"/>
																        <xsl:copy-of select="current()"/>							        	
																    </xsl:for-each>
															    </xsl:variable>
												<xsl:variable name="others_internacional_node_set" select="exsl:node-set($others_internacional_sorted_node_set)/*" />
													
												<div class="panel">
											      		<h3 class="panel-title">
											      			<a role="button"  class="own-accordion" tabindex="0" onclick="handleCommandClick(this,event)" onKeyDown="handleCommand(this,event)">
																<xsl:value-of select="$others_internacional"/>
															</a>
														</h3>												
														<div class="panel-collapse">
															<div class="panel-body">																																			
													  		  <ul>														
																	 <xsl:for-each select="$others_internacional_node_set">															 															 	
																	 		<xsl:variable name="program_url" select="ehu:urlInicio"/>			
 																	 		<xsl:if test="($program_url!='')">		
																		 		<li>																 			
																		 			<xsl:variable name="denMaster" select="ehu:denMaster"/>
																					<xsl:choose>
																						<xsl:when test="$program_url != $void">
																							<a tabindex="-1">
																								<xsl:attribute name="href"><xsl:value-of select="$program_url"/></xsl:attribute>
																						 		<xsl:value-of select="$denMaster" />																				 										  								  	
																							</a>
																						</xsl:when>
																						<xsl:otherwise>
																							<xsl:value-of select="$denMaster" />																					
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
											
											<!-- Interuniversitario -->
											<xsl:if test="ehu:app/ehu:titulos/ehu:titulo[ehu:Interuniversitario='1']">	
											
												<xsl:variable name="others_interuniversitario_sorted_node_set">
															<xsl:for-each select="ehu:app/ehu:titulos/ehu:titulo[ehu:listaOfertaWeb='1' and ehu:Interuniversitario='1']">
														        <xsl:sort select="ehu:denMaster"/>
														        <xsl:copy-of select="current()"/>							        	
														    </xsl:for-each>
													    </xsl:variable>
											  		  <xsl:variable name="others_interuniversitario_node_set" select="exsl:node-set($others_interuniversitario_sorted_node_set)/*" />
											
												<div class="panel">
									      		<h3 class="panel-title">
									      			<a role="button"  class="own-accordion" tabindex="0" onclick="handleCommandClick(this,event)" onKeyDown="handleCommand(this,event)">
														<xsl:value-of select="$others_interuniversitario"/>
													</a>
												</h3>												
												<div class="panel-collapse">
													<div class="panel-body">																																	
											  		  <ul>														
															 <xsl:for-each select="$others_interuniversitario_node_set">															 															 	
															 		<xsl:variable name="program_url" select="ehu:urlInicio"/>																		 		
 															 		<xsl:if test="($program_url!='')">	
																 		<li>																 			
																 			<xsl:variable name="denMaster" select="ehu:denMaster"/>
																			<xsl:choose>
																				<xsl:when test="$program_url != $void">
																					<a tabindex="-1">
																						<xsl:attribute name="href"><xsl:value-of select="$program_url"/></xsl:attribute>
																				 		<xsl:value-of select="$denMaster" />																				 										  								  	
																					</a>
																				</xsl:when>
																				<xsl:otherwise>
																					<xsl:value-of select="$denMaster" />																					
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
											
											<!-- Dual -->	
											<xsl:if test="ehu:app/ehu:titulos/ehu:titulo[ehu:dual='1']">																
											
												<xsl:variable name="others_dual_sorted_node_set">									      				
																<xsl:for-each select="ehu:app/ehu:titulos/ehu:titulo[ehu:listaOfertaWeb='1' and ehu:dual='1']">																	
															        <xsl:sort select="ehu:denMaster"/>
															        <xsl:copy-of select="current()"/>							        	
															    </xsl:for-each>
														 </xsl:variable>
									      		 		<xsl:variable name="others_dual_node_set" select="exsl:node-set($others_dual_sorted_node_set)/*" />
																						   								    	
									      		<div class="panel">								      												      													      		 		
										      		<h3 class="panel-title">
										      			<a role="button"  class="own-accordion" tabindex="0" onclick="handleCommandClick(this,event)" onKeyDown="handleCommand(this,event)">
															<xsl:value-of select="$others_dual"/>
														</a>
													</h3>												
													<div class="panel-collapse">
														<div class="panel-body">																																												  		 
												  		  <ul>														
																 <xsl:for-each select="$others_dual_node_set">															 															 	
																 		<xsl:variable name="program_url" select="ehu:urlInicio"/>																			 		
 																 		<xsl:if test="($program_url!='')">		 
																	 		<li>																 			
																	 			<xsl:variable name="denMaster" select="ehu:denMaster"/>
																				<xsl:choose>
																					<xsl:when test="$program_url != $void">
																						<a tabindex="-1">
																							<xsl:attribute name="href"><xsl:value-of select="$program_url"/></xsl:attribute>
																					 		<xsl:value-of select="$denMaster" />																				 						  								  	
																						</a>
																					</xsl:when>
																					<xsl:otherwise>
																						<xsl:value-of select="$denMaster" />
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
																	   
							  </div>					   						    
								<!-- Párrafo para "Arriba" -->
								<a href="#listTab" class="pull-right back-to-top"><span><xsl:value-of select="languageUtil:get($locale,'up')"/> <span class="icon-chevron-up"></span></span></a>						    
							</xsl:when>
						
						
						<xsl:otherwise>	
							<xsl:if test="ehu:app/ehu:titulos/ehu:titulo[ehu:listaOfertaWeb='1']">				
									<!-- masteres y titulos propios ordenados alfabeticamente -->
									<xsl:variable name="sorted_copy">
												<xsl:for-each select="ehu:app/ehu:titulos/ehu:titulo[ehu:listaOfertaWeb='1']">
											        <xsl:sort select="ehu:denMaster"/>
											        <xsl:copy-of select="current()"/>							        	
											    </xsl:for-each>
										    </xsl:variable>
								    <xsl:variable name="sorted_node_set" select="exsl:node-set($sorted_copy)/*" />						
											<!-- Masteres y titulos ordenados alfabéticamente -->
											<ul class="elements__list">
												<xsl:for-each select="$sorted_node_set">
													<xsl:variable name="program_url" select="ehu:urlInicio"/>
													<xsl:if test="($program_url!='')">	
													
														<li>
															<xsl:choose>
																<xsl:when test="$program_url != $void">
																<a>
																	<xsl:attribute name="href"><xsl:value-of select="$program_url"/></xsl:attribute>																																																																							
																	<xsl:value-of select="ehu:denMaster" />
																	<!-- 
																	<xsl:value-of select="$customDenMaster" />
															 		-->																																																																																																				  				
															  	</a>
															  	</xsl:when>
															  	<xsl:otherwise>
															  		<xsl:value-of select="ehu:denMaster" />
																	<!-- 
																	<xsl:value-of select="$customDenMaster" />
															 		-->	
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
								</xsl:if>
						</xsl:otherwise>
					</xsl:choose>							
						</div>
			
		
			
		</div>
		
		
			
	</xsl:template>
	
</xsl:stylesheet>