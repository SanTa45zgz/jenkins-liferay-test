<?xml version="1.0"?>
	
	<xsl:stylesheet 
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
		xmlns:exsl="http://exslt.org/common"
		xmlns:ehu="http://www.ehu.eus"
		xmlns:xalan="http://xml.apache.org/xalan"
		xmlns:languageUtil="xalan://com.liferay.portal.kernel.language.LanguageUtil"
		xmlns:localeUtil="xalan://com.liferay.portal.kernel.util.LocaleUtil"
		xmlns:stringUtil="xalan://com.liferay.portal.kernel.util.StringUtil"
		exclude-result-prefixes="xalan"
		extension-element-prefixes="exsl languageUtil localeUtil xalan stringUtil">
		
	<xsl:output method="xml" omit-xml-declaration="yes" />	
	
	<!-- Variables genericas -->
	<xsl:variable name="void" select="''"/>
	<xsl:variable name="white" select="' '"/>
	
	
	<!-- Generacion de variable locale utilizada en las traducciones a partir del parametro de idioma -->
	<xsl:variable name="p_cod_idioma" select="pagina/parametros/parametro[@nombre='p_cod_idioma']"/>											
	<xsl:variable name="localeStr"> 	
		<xsl:choose>
			<xsl:when test="$p_cod_idioma = 'EUS'">
				<xsl:value-of select="localeUtil:fromLanguageId('eu_ES')" />
			</xsl:when>
			<xsl:when test="$p_cod_idioma = 'CAS'">
				<xsl:value-of select="localeUtil:fromLanguageId('es_ES')" />					
			</xsl:when>
			<xsl:when test="$p_cod_idioma = 'ING'">
				<xsl:value-of select="localeUtil:fromLanguageId('en_GB')" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="localeUtil:fromLanguageId('fr_FR')" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="locale" select="localeUtil:fromLanguageId($localeStr)"/>
	
	<xsl:template name="xml_error">
		<div>
			<xsl:attribute name="class">alert alert-error</xsl:attribute>
			<p>
				<xsl:value-of select="languageUtil:get($locale, 'an-error-occurred-while-processing-your-xml-and-xsl')"/>
			</p>										
		</div>
	</xsl:template>
	
	<xsl:template match="sinInfo">
		<p class="alert alert-info portlet-msg-info">
			<xsl:value-of select="."/>
		</p>
	</xsl:template>
	
	<!-- 
	<xsl:template match="parrafo">
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
	</xsl:template> -->
	
	<!--  los enlaces y enlacesDoc fuera de elemento se gestionan en el nivel superior por lo tanto aquí debemos evitar pintarlos -->
	<!--  los enlaces y enlacesDoc dentro de elemento sí se gestionan en este nivel -->
	<xsl:template match="enlace">
	</xsl:template>
	
	<xsl:template match="enlaceDoc">
	</xsl:template>
	
	<!--  los parrafos que vienen fuera de elemento se gestionan igual que enlace y enlaceDoc, en otro nivel -->
	<xsl:template match="parrafo">
	</xsl:template>
	
	
	<xsl:template name="docLink">

		<xsl:variable name="extension" select="extension"/>
		<xsl:variable name="size" select="tamanyo"/>
		<span>
			<xsl:attribute name="class">icon-file</xsl:attribute>
			<xsl:value-of select="$white"/>
		</span>				
		<a target="_blank">
			<!--<xsl:attribute name="class">
				<xsl:choose> 
					<xsl:when test="extension">bullet bullet-<xsl:value-of select="extension"/></xsl:when>
					<xsl:otherwise>bullet</xsl:otherwise>
				</xsl:choose>	
			</xsl:attribute>		-->
			<xsl:attribute name="href">
				<xsl:value-of select="url" />
			</xsl:attribute>
			<!-- <xsl:if test="title != '' ">
				<xsl:attribute name="title">
					<xsl:value-of select="title"/>
				</xsl:attribute>
			</xsl:if> -->
		<!--	<span>
				<xsl:attribute name="class">hide-accessible</xsl:attribute>
				<xsl:value-of select="languageUtil:get($locale,'opens-new-window')"/>
			</span>	 -->
			
			<xsl:attribute name="title">
				<xsl:value-of select="languageUtil:get($locale,'opens-new-window')"/>
			</xsl:attribute>
		
	
			<xsl:value-of select="texto"/>
			
			<xsl:if test="($size != $void) and ($extension != $void)">
				<xsl:value-of select="$white"/>(<span><xsl:attribute name="class">document_extension</xsl:attribute><xsl:value-of select="extension"/></span>,<xsl:value-of select="$white"/><span><xsl:attribute name="class">document_size</xsl:attribute><xsl:value-of select="tamanyo"/></span>)				
				
			</xsl:if>

			<span>
				<xsl:attribute name="class">icon-external-link</xsl:attribute> 
				<xsl:value-of select="$white"/>
			</span>								 
		</a>
	</xsl:template>
	
	<xsl:template name="link">
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
				<!-- PRUEBAS EDORTA PARA MOSTRAR UN TEXTO CONCRETO EN LOS LINKS EN LUGAR DE LA URL -->
				
				<!-- Edorta:
				 Si el enlace es al Portal de empleo, metemos nosotros el texto del enlace ya que en el xml está la URL como texto
				 <xsl:variable name="textoAcceso" select="@texto/nombre" /> 
				<xsl:variable name="textoAcceso" select="'Acceso al portal de empleo'" />
				<xsl:if test="stringUtil:equalsIgnoreCase('Acceso',texto/@nombre)">
				
				</xsl:if>
				-->		 	
			 			 	
			 	<!-- Edorta:
				 Si el enlace es al Portal de empleo, metemos nosotros el texto del enlace ya que en el xml está la URL como texto -->
			 	<!-- 
			 	<xsl:variable name="nombre" select="@nombre" />
			 	<xsl:choose>
			 		<xsl:when test="stringUtil:equalsIgnoreCase('Acceso',nombre)">
           				<xsl:value-of select="'Acceso al portal de empleo'"/>
           				<xsltext>Acceso al portal de empleo 1</xsltext>
         			</xsl:when>
         			<xsl:otherwise>
          				<xsl:value-of select="texto"/>
          				<xsltext>Acceso al portal de empleo 2</xsltext>
          				<xsltext>@nombre: </xsltext> <xsl:value-of select="elemento/nombre"/>
          				<xsltext>@nombre: </xsltext> <xsl:value-of select="elemento/@nombre"/>
          				<xsltext>@nombre: </xsltext> <xsl:value-of select="nombre"/>
          				<xsltext>@nombre: </xsltext> <xsl:value-of select="@nombre"/>
          				<xsltext>@nombre: </xsltext> <xsl:value-of select="$nombre"/>
          				<xsltext>"pagina/apartado/elemento/@nombre": </xsltext> <xsl:value-of select="pagina/apartado/elemento/@nombre"/>    
          				      				
          			</xsl:otherwise>
       			</xsl:choose>
       		 	-->
       		 	<!-- 			FIN PRUEBAS EDORTA 			--> 
       		 		
			</span>	

			<span>
			<xsl:attribute name="class">
				<xsl:text>icon-external-link</xsl:text>
			</xsl:attribute>
		</span>
		</a>		
	</xsl:template>
	
	<xsl:template name="emailLink">
		<xsl:if test="texto/@prefijo !=''">
			<xsl:value-of select="texto/@prefijo"/>
			<xsl:value-of select="$white"/>
		</xsl:if>
		<a>
			<xsl:attribute name="class">bullet-email</xsl:attribute>	
			<xsl:attribute name="href">mailto:<xsl:value-of select="mail"/></xsl:attribute>
			<xsl:attribute name="title"><xsl:value-of select="title"/></xsl:attribute>
			<span>
				<xsl:attribute name="class">summary-title</xsl:attribute>
			 	<xsl:value-of select="texto"/>
			</span>		
		</a>		
	</xsl:template>  
	
	<xsl:template name="telLink">
		<xsl:if test="texto/@prefijo !=''">
			<xsl:value-of select="texto/@prefijo"/>
			<xsl:value-of select="$white"/>
		</xsl:if>
		<a>
			<xsl:attribute name="class">bullet-tel</xsl:attribute>	
			<xsl:attribute name="href">tel:<xsl:value-of select="numero"/></xsl:attribute>
			<xsl:attribute name="title"><xsl:value-of select="title"/></xsl:attribute>
			<span>
				<xsl:attribute name="class">summary-title</xsl:attribute>
			 	<xsl:value-of select="texto"/>
			</span>		
		</a>		
	</xsl:template>
	
	<xsl:template name="faxLink">
		<xsl:if test="texto/@prefijo !=''">
			<xsl:value-of select="texto/@prefijo"/>
			<xsl:value-of select="$white"/>
		</xsl:if>
		<a>
			<xsl:attribute name="class">bullet-fax</xsl:attribute>	
			<xsl:attribute name="href">fax:<xsl:value-of select="numero"/></xsl:attribute>
			<xsl:attribute name="title"><xsl:value-of select="title"/></xsl:attribute>
			<span>
				<xsl:attribute name="class">summary-title</xsl:attribute>
			 	<xsl:value-of select="texto"/>
			</span>		
		</a>		
	</xsl:template>
										
	<xsl:template match="contacto">
		<xsl:if test="persona">
			<span>
				<xsl:attribute name="class">person</xsl:attribute>		
			 	<xsl:value-of select="persona"/>
			 </span>
			 <br></br>
		</xsl:if>
		<xsl:if test="centro">
			<span>
				<xsl:attribute name="class">faculty</xsl:attribute>
				<strong><xsl:value-of select="centro"/></strong>
			</span>
			<br></br>
		</xsl:if>
		<xsl:if test="lugar">
			<xsl:if test="lugar/@prefijo !=''">
				<xsl:value-of select="lugar/@prefijo"/>
				<xsl:value-of select="$white"/>
			</xsl:if>
			<span>
				<xsl:attribute name="class">room</xsl:attribute>
				<xsl:value-of select="lugar"/>
			</span>
		</xsl:if>
		<xsl:if test="departamento">
			<xsl:if test="departamento/@prefijo !=''">
				<xsl:value-of select="departamento/@prefijo"/>
				<xsl:value-of select="$white"/>
			</xsl:if>
			<span>
				<xsl:attribute name="class">department</xsl:attribute>
				<xsl:value-of select="departamento"/>
			</span>
		</xsl:if>
		<xsl:if test="direccion">
			<p>
				<span>
					<xsl:attribute name="class">address</xsl:attribute>
					<xsl:value-of select="direccion"/>
				</span>
				<xsl:if test="cp">
					<br></br>
					<span>
						<xsl:attribute name="class">cp</xsl:attribute>
						<abbr>
							<xsl:attribute name="title"><xsl:value-of select="languageUtil:get($locale,'ehu.postal-code')"/></xsl:attribute>
							<xsl:value-of select="languageUtil:get($locale,'ehu.abbr.pc')"/>
						</abbr>
						<xsl:value-of select="cp"/>
					</span>
				</xsl:if>
				<xsl:if test="poblacion">
					<xsl:value-of select="$white"/><span><xsl:attribute name="class">city</xsl:attribute><xsl:value-of select="poblacion"/></span>
				</xsl:if>	
				<xsl:if test="provincia">
					<xsl:value-of select="$white"/>
						<span><xsl:attribute name="class">province</xsl:attribute>(<xsl:value-of select="provincia"/>
						<xsl:if test="pais">
							<span><xsl:attribute name="class">country</xsl:attribute><xsl:value-of select="$white"/>-<xsl:value-of select="$white"/><xsl:value-of select="pais"/></span>
						</xsl:if>)
						</span>
				</xsl:if>
			</p>											
		</xsl:if>
		<xsl:if test="enlaceTel">
			<xsl:for-each select="enlaceTel">
				<br></br><xsl:call-template name="telLink"/>
			</xsl:for-each>	
		</xsl:if>
		<xsl:if test="enlaceFax">
			<xsl:for-each select="enlaceFax">
				<br></br><xsl:call-template name="faxLink"/>
			</xsl:for-each>	
		</xsl:if>
		<xsl:if test="enlaceMail">
			<xsl:for-each select="enlaceMail">
				<br></br><xsl:call-template name="emailLink"/>
			</xsl:for-each>					
		</xsl:if>
		<xsl:if test="enlace">
			<xsl:for-each select="enlace">
				<br></br><xsl:call-template name="link"/>
			</xsl:for-each>											
		</xsl:if>	
	</xsl:template>
			
	<xsl:template match="listaNoSel">
			<xsl:if test="@titulo != ''">
				<xsl:choose>
					<xsl:when test="count(ancestor::*) = 2">
						<h3>
							<xsl:value-of select="@titulo"/>
						</h3>
					</xsl:when>
					<xsl:when test="count(ancestor::*) = 3">
						<h4>
							<xsl:value-of select="@titulo"/>
						</h4>
					</xsl:when>
					<xsl:when test="count(ancestor::*) = 4">
						<h5>
							<xsl:value-of select="@titulo"/>
						</h5>
					</xsl:when>
				</xsl:choose>
			</xsl:if>
			<ul>
				<xsl:for-each select="opcion">
					<xsl:variable name="data" select="."/>
					<li>
						<xsl:choose>
							<xsl:when test="@enlace != ''">
								<a>
									<xsl:attribute name="href">
										<xsl:value-of select="@enlace"/>
									</xsl:attribute>
									<xsl:if test="@nuevaVentana = 1">
										<xsl:attribute name="target">
											<xsl:value-of select="_blank"/>
										</xsl:attribute>
									</xsl:if>	
									<xsl:if test="@titulo != ''">
										<xsl:attribute name="title">
											<xsl:value-of select="@titulo"/>
										</xsl:attribute>
									</xsl:if>
									<span>
										<xsl:attribute name="class">summary-title</xsl:attribute>
										<!-- <xsl:value-of select="."/> -->
										<xsl:call-template name="xml_tranform_n_nbsp">
											<xsl:with-param name="xml_plain_text" select="$data"/>
										</xsl:call-template>
									</span>	
								</a>
							</xsl:when>
							<xsl:when test="enlace">
								<xsl:for-each select="enlace">
									<xsl:call-template name="link"/>
								</xsl:for-each>											
							</xsl:when>
							<xsl:when test="enlaceMail">
								<xsl:for-each select="enlaceMail">
									<xsl:call-template name="emailLink"/>
								</xsl:for-each>	
							</xsl:when>							
							<xsl:when test="enlaceTel">
								<xsl:for-each select="enlaceTel">
									<xsl:call-template name="telLink"/>
								</xsl:for-each>	
							</xsl:when>
							<xsl:when test="enlaceFax">
								<xsl:for-each select="enlaceFax">
									<xsl:call-template name="faxLink"/>
								</xsl:for-each>	
							</xsl:when>
							<xsl:otherwise>
								<span>
									<xsl:attribute name="class">summary-title</xsl:attribute>
									<xsl:call-template name="xml_tranform_n_nbsp">
										<xsl:with-param name="xml_plain_text" select="$data"/>
									</xsl:call-template>
								</span>
							</xsl:otherwise> 
						</xsl:choose>
					</li>																					
				</xsl:for-each>
			</ul>	
	</xsl:template>
				
	<xsl:template match="tabla">
		<!-- Edorta: sacamos el título de la tabla para quitarle el caption y hacerlo H3 y seguir la jerarquía -->
		<!-- Edorta: la template "tabla se utiliza en btpw0020, btpw0030"-->
		<!-- Edorta: 2017-09-18 vuelvo a dejar el título como caption
		<xsl:if test="@titulo !=''">
			<h3><xsl:value-of select="@titulo"/></h3>
		</xsl:if>
		-->
		<table>		
		<xsl:if test="@titulo !=''">
			<caption><xsl:value-of select="@titulo"/></caption>
		</xsl:if>	
				<xsl:if test="columnas">
				<thead>
					<xsl:for-each select="columnas">
						<tr>
							<xsl:for-each select="columna">
								<xsl:choose>
									<xsl:when test="@rowspan">
										<th>
											<xsl:attribute name="rowspan">
												<xsl:value-of select="@rowspan"/>
											</xsl:attribute>	 
											<xsl:value-of select="."/>
										</th>		
									</xsl:when>
									<xsl:when test="@colspan">
										<th>
											<xsl:attribute name="colspan">
												<xsl:value-of select="@colspan"/>
											</xsl:attribute>	 
											<xsl:value-of select="."/>
										</th>		
									</xsl:when>
									<xsl:otherwise>
										<th colspan="1" rowspan="1"><xsl:value-of select="."/></th>
									</xsl:otherwise>
								</xsl:choose> 
							</xsl:for-each>
						</tr>		
					</xsl:for-each>
				</thead>
				</xsl:if>
				<xsl:if test="pie/filaPie">
				<tfoot>	
					<xsl:for-each select="pie/filaPie">
						<tr>
							<xsl:choose>
								<xsl:when test="@colspan">
									<td>
										<xsl:attribute name="colspan">
											<xsl:value-of select="@colspan"/>
										</xsl:attribute>	 
										<xsl:value-of select="."/>													
									</td>		
								</xsl:when>
								<xsl:otherwise>
									<td colspan="1" rowspan="1">
										<xsl:value-of select="."/>													
									</td>
								</xsl:otherwise>
							</xsl:choose>
						</tr>
					</xsl:for-each>
				</tfoot>
				</xsl:if>
				<xsl:if test="fila">
				<tbody>
				<xsl:for-each select="fila">
					<xsl:variable name="row_link" select="@enlace" />
					<xsl:variable name="title_link" select="@titulo" />
					<tr>
						<xsl:variable name="cell_copy">
							<xsl:for-each select="celda">
								<xsl:text> </xsl:text>
								<xsl:copy-of select="current()"/>							        	
							</xsl:for-each>
						</xsl:variable>
						<xsl:for-each select="celda">
							<xsl:variable name="cell_link" select="@enlace" />
							<xsl:variable name="data" select="." />
							<xsl:variable name="emphatized_cell" select="@enfatizar" />
							<xsl:variable name="cell_text" select="exsl:node-set($cell_copy)" />
							<xsl:choose>
								<xsl:when test="@rowspan">
									<td>
										<xsl:attribute name="rowspan">
											<xsl:value-of select="@rowspan"/>
										</xsl:attribute>
										<xsl:attribute name="style">
											<xsl:if test="$emphatized_cell = 1">background-color:#EEE</xsl:if>
										</xsl:attribute>
										<xsl:choose>
											<xsl:when test="$cell_link != ''">
												<a>
													<xsl:attribute name="href">
														<xsl:value-of select="$cell_link"/>
													</xsl:attribute>		 
													<xsl:call-template name="xml_tranform_n_nbsp">
														<xsl:with-param name="xml_plain_text" select="$data"/>
													</xsl:call-template>
												</a>	
											</xsl:when>
											<xsl:otherwise>		 
												<xsl:call-template name="xml_tranform_n_nbsp">
													<xsl:with-param name="xml_plain_text" select="$data"/>
												</xsl:call-template>
											</xsl:otherwise>											
										</xsl:choose>		
									</td>		
								</xsl:when>
								<xsl:when test="@colspan">
									<td>
										<xsl:attribute name="colspan">
											<xsl:value-of select="@colspan"/>
										</xsl:attribute>
										<xsl:attribute name="style">
											<xsl:if test="$emphatized_cell = 1">background-color:#EEE</xsl:if>
										</xsl:attribute>
										<xsl:choose>	 
											<xsl:when test="$cell_link != ''">
												<a>
													<xsl:attribute name="href">
														<xsl:value-of select="$cell_link"/>
													</xsl:attribute>		 
													<xsl:call-template name="xml_tranform_n_nbsp">
														<xsl:with-param name="xml_plain_text" select="$data"/>
													</xsl:call-template>
												</a>	
											</xsl:when>
											<xsl:otherwise>		 
												<xsl:call-template name="xml_tranform_n_nbsp">
													<xsl:with-param name="xml_plain_text" select="$data"/>
												</xsl:call-template>
											</xsl:otherwise>
										</xsl:choose>
									</td>		
								</xsl:when>
								<xsl:otherwise>
									<xsl:choose>
										<xsl:when test="$row_link != ''">
											<td>
												<xsl:attribute name="colspan">1</xsl:attribute>
												<xsl:attribute name="rowspan">1</xsl:attribute>
												<!-- Solo se enlaza la ultima columna de cada fila, con un titulo de enlace unico por fila compuesto por todos los datos de las celdas -->
												<xsl:choose>
													<xsl:when test="position() = last()">
													<a>
														<xsl:attribute name="href">
															<xsl:value-of select="$row_link"/>
														</xsl:attribute>
														<xsl:if test="$title_link != ''">																	
															<xsl:attribute name="title">
																<xsl:value-of select="concat($title_link,' ',$cell_text)" />																
															</xsl:attribute>
														</xsl:if>
														<xsl:call-template name="xml_tranform_n_nbsp">
															<xsl:with-param name="xml_plain_text" select="$data"/>
														</xsl:call-template>																	
													</a>
													</xsl:when>
													<xsl:otherwise>
														<xsl:call-template name="xml_tranform_n_nbsp">
															<xsl:with-param name="xml_plain_text" select="$data"/>
														</xsl:call-template>
													</xsl:otherwise>
												</xsl:choose>
											</td>
										</xsl:when>
										<xsl:when test="$cell_link != ''">
											<td>
												<xsl:attribute name="colspan">1</xsl:attribute>
												<xsl:attribute name="rowspan">1</xsl:attribute>
												<a>
													<xsl:attribute name="href">
														<xsl:value-of select="$cell_link"/>
													</xsl:attribute>		 
													<xsl:call-template name="xml_tranform_n_nbsp">
														<xsl:with-param name="xml_plain_text" select="$data"/>
													</xsl:call-template>
												</a>
											</td>		
										</xsl:when>
										<xsl:otherwise>
											<td>
												<xsl:attribute name="colspan">1</xsl:attribute>
												<xsl:attribute name="rowspan">1</xsl:attribute>
												<xsl:call-template name="xml_tranform_n_nbsp">
													<xsl:with-param name="xml_plain_text" select="$data"/>
												</xsl:call-template>																								
											</td>
										</xsl:otherwise>
									</xsl:choose>		
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
					</tr>
				</xsl:for-each>
				</tbody>
				</xsl:if>								
			</table>
	</xsl:template>
	
	<xsl:template match="elemento">
		<xsl:if test="@nombre != ''">
			<xsl:choose>
				<xsl:when test="count(ancestor::*) = 2">
					<p><strong>
						<xsl:value-of select="@nombre"/>
						<xsl:variable name="valor" select="." />
						<xsl:variable name="nombre" select="@nombre" />
						<!-- Hay tres casos en los que pintamos el valor. Debería utilizarse una key en el Language hook pero el xml solo viene en euskera y castellano -->
						<!-- <xsl:variable name="fechaConstitucion" select="languageUtil:get($locale, 'ehu.xsl-content.fechaConstitucion')"/> -->					
						
						<xsl:if test="(stringUtil:equalsIgnoreCase('Fecha de constitución',$nombre)) or (stringUtil:equalsIgnoreCase('Fecha publicación',$nombre)) or (stringUtil:equalsIgnoreCase('Calificación mínima aprobación',$nombre)
										or stringUtil:equalsIgnoreCase('Eratze-data',$nombre) or stringUtil:equalsIgnoreCase('Argitaratze-data',$nombre) or stringUtil:equalsIgnoreCase('Gainditzeko gutxieneko nota',$nombre))"> 
							<xsl:text>: </xsl:text>
							<xsl:value-of select="$valor"/>
						</xsl:if>	
						<!-- 	Pruebas para mostrar un texto en lugar de la url cuando sea un link
						<xsl:if test="(stringUtil:equalsIgnoreCase('Acceso',$nombre))">	
							<xsl:value-of select="'Acceso al portal de empleo'"/>
						</xsl:if>
						 -->								
					</strong></p>
				</xsl:when>
				<xsl:when test="count(ancestor::*) = 3">
					<h4>
						<xsl:value-of select="@nombre"/>
						<xsl:variable name="valor" select="." />
						<xsl:variable name="nombre" select="@nombre" />
						<!-- Hay tres casos en los que pintamos el valor. Debería utilizarse una key en el Language hook pero el xml solo viene en euskera y castellano -->
						<xsl:if test="(stringUtil:equalsIgnoreCase('Fecha de constitución',$nombre)) or (stringUtil:equalsIgnoreCase('Fecha publicación',$nombre)) or (stringUtil:equalsIgnoreCase('Calificación mínima aprobación',$nombre)
										or stringUtil:equalsIgnoreCase('Eratze-data',$nombre) or stringUtil:equalsIgnoreCase('Argitaratze-data',$nombre) or stringUtil:equalsIgnoreCase('Gainditzeko gutxieneko nota',$nombre)
										or stringUtil:equalsIgnoreCase('Fecha de constitucion',$nombre))">  
							<xsl:text>: </xsl:text>
							<xsl:value-of select="$valor"/>
						</xsl:if>			
					</h4>
				</xsl:when>
				<xsl:when test="count(ancestor::*) = 4">
					<h5>
						<xsl:value-of select="@nombre"/>
						<xsl:variable name="valor" select="." />
						<xsl:variable name="nombre" select="@nombre" />
						<!-- Hay tres casos en los que pintamos el valor. Debería utilizarse una key en el Language hook pero el xml solo viene en euskera y castellano -->
						<xsl:if test="(stringUtil:equalsIgnoreCase('Fecha de constitución',$nombre)) or (stringUtil:equalsIgnoreCase('Fecha publicación',$nombre)) or (stringUtil:equalsIgnoreCase('Calificación mínima aprobación',$nombre)
										or stringUtil:equalsIgnoreCase('Eratze-data',$nombre) or stringUtil:equalsIgnoreCase('Argitaratze-data',$nombre) or stringUtil:equalsIgnoreCase('Gainditzeko gutxieneko nota',$nombre))">  
							<xsl:text>: </xsl:text>
							<xsl:value-of select="$valor"/>
						</xsl:if>				
					</h5>
				</xsl:when>
			</xsl:choose>			
		</xsl:if>
		<xsl:if test="parrafo">	
			<xsl:for-each select="parrafo">
					<xsl:if test="@titulo != ''">
						<xsl:choose>
							<xsl:when test="count(ancestor::*) = 3">
								<h3>
									<xsl:value-of select="@titulo"/>
								</h3>
							</xsl:when>
							<xsl:when test="count(ancestor::*) = 4">
								<h4>
									<xsl:value-of select="@titulo"/>
								</h4>
							</xsl:when>
							<xsl:when test="count(ancestor::*) = 5">
								<h5>
									<xsl:value-of select="@titulo"/>
								</h5>
							</xsl:when>						
						</xsl:choose>
					</xsl:if>
					<p>
						<xsl:call-template name="xml_tranform_n_br">
							<xsl:with-param name="xml_plain_text" select="."/>
						</xsl:call-template>
					</p>
			</xsl:for-each>		
		</xsl:if>
		<xsl:if test="enlaceDoc">
			<ul>
			<xsl:for-each select="enlaceDoc">
				<li>
					<xsl:call-template name="docLink"/>
				</li>
			</xsl:for-each>
			</ul>
		</xsl:if>
		<xsl:if test="enlace">
			<ul>
			<xsl:for-each select="enlace">
				<li>
					<xsl:call-template name="link"/>
				</li>
			</xsl:for-each>
			</ul>
		</xsl:if>				
	</xsl:template>
	
	<xsl:template match="subApartado">
		<xsl:variable name="data" select="."/>
		<xsl:variable name="id" select="@identificador"/>
		<xsl:if test="@titulo != ''">
			<xsl:variable name="title" select="@titulo"/>	
			<xsl:choose>
				<xsl:when test="count(ancestor::*) = 2">
					<h3>
						<xsl:if test="$id != ''">
							<xsl:attribute name="id"><xsl:value-of select="$id"/></xsl:attribute>
						</xsl:if>
						<xsl:call-template name="xml_tranform_n_nbsp">
							<xsl:with-param name="xml_plain_text" select="$title"/>
						</xsl:call-template>
					</h3>					
				</xsl:when>
				<xsl:when test="count(ancestor::*) = 3">
					<h4>
						<xsl:if test="$id != ''">
							<xsl:attribute name="id"><xsl:value-of select="$id"/></xsl:attribute>
						</xsl:if>
						<xsl:call-template name="xml_tranform_n_nbsp">
							<xsl:with-param name="xml_plain_text" select="$title"/>
						</xsl:call-template>
					</h4>
				</xsl:when>
			</xsl:choose>
		</xsl:if>
		<xsl:choose>	
			<xsl:when test="count(child::*) = 0">
				 <xsl:if test="($data) and ($data != $void) and ($data != $white)">
					<p><xsl:value-of select="$data" disable-output-escaping="yes" /></p>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
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
			</xsl:otherwise>	
		</xsl:choose>
	</xsl:template>
	
	<!-- Reeemplaza ocurrencias \n en el texto plano recibido del XML generando tag HTML <br/> -->
	<xsl:template name="xml_tranform_n_br">
	  <xsl:param name="xml_plain_text"/>
	  <xsl:variable name="return">\n</xsl:variable>
	  <xsl:choose>
	    <xsl:when test="contains($xml_plain_text, $return)">
	      <xsl:value-of select="substring-before($xml_plain_text, $return)"/>
	      <br/>
	      <xsl:call-template name="xml_tranform_n_br">
	        <xsl:with-param name="xml_plain_text" select="substring-after($xml_plain_text, $return)"/>
	      </xsl:call-template>
	    </xsl:when>
	    <xsl:otherwise>
	      <xsl:value-of select="$xml_plain_text"/>
	    </xsl:otherwise>
	  </xsl:choose>
	</xsl:template>
	
	<!-- Limpia ocurrencias \n en el texto plano recibido del XML -->
	<xsl:template name="xml_tranform_n_nbsp">
	  <xsl:param name="xml_plain_text"/>
	  <xsl:variable name="return">\n</xsl:variable>
	  <xsl:choose>
	    <xsl:when test="contains($xml_plain_text, $return)">
	      <xsl:value-of select="substring-before($xml_plain_text, $return)"/>
	      <xsl:call-template name="xml_tranform_n_nbsp">
	        <xsl:with-param name="xml_plain_text" select="substring-after($xml_plain_text, $return)"/>
	      </xsl:call-template>
	    </xsl:when>
	    <xsl:otherwise>
	      <xsl:value-of select="$xml_plain_text"/>
	    </xsl:otherwise>
	  </xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>