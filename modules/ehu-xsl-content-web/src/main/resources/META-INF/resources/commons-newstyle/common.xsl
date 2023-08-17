<?xml version="1.0"?>
	
	<xsl:stylesheet 
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
		xmlns:ehu="http://www.ehu.eus"
		xmlns:xalan="http://xml.apache.org/xalan"
		xmlns:languageUtil="xalan://com.liferay.portal.kernel.language.LanguageUtil"
		xmlns:propsUtil="com.liferay.portal.kernel.util.PropsUtil"
		xmlns:StringPool="com.liferay.portal.kernel.util.StringPool"
		xmlns:stringUtil="xalan://com.liferay.portal.kernel.util.StringUtil"
		xmlns:htmlUtil="xalan://com.liferay.portal.kernel.util.HtmlUtil"
		exclude-result-prefixes="xalan"
		extension-element-prefixes="stringUtil languageUtil propsUtil StringPool xalan htmlUtil">
	
		<xsl:output method="xml" omit-xml-declaration="yes" />	
		
		<xsl:include href="http://localhost:8080/o/ehu-xsl-content-web/commons-newstyle/common-lang.xsl"/>
	
		<!-- Variables genericas -->
		<xsl:variable name="void" select="''"/>
		<xsl:variable name="white_space" select="' '"/>
		<xsl:variable name="two_points" select="':'" />
		<xsl:variable name="guide" select="'-'" />
		<xsl:variable name="comma" select="','" />
		<xsl:variable name="euro" select="'€'" />
		<xsl:decimal-format name="european" decimal-separator=',' grouping-separator='.' />
		
		<xsl:variable name="http" select="'http://'" />
		
		<xsl:variable name="upper" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
    	<xsl:variable name="lower" select="'abcdefghijklmnopqrstuvwxyz'"/>
	
		<!-- Codigo de aplicacion -->
		<xsl:variable name="p_cod_proceso" select="ehu:app/ehu:parameters/ehu:parameter[@name='p_cod_proceso']"/>
		
		<!-- Codigo de información a mostrar -->
		<xsl:variable name="p_nav" select="ehu:app/ehu:parameters/ehu:parameter[@name='p_nav']"/>
		
		<xsl:variable name="p_texto_error" select="ehu:app/ehu:error/ehu:error[@val='SINDATOS']"/>
		
		<!-- Entorno de ejecucion -->
		<xsl:variable name="host" select="propsUtil:get('ehu.host')"/>
		
		<!-- Origen de datos -->
		<xsl:variable name="xml_src_id"><xsl:value-of select="$p_cod_proceso"/>.src</xsl:variable>
		<xsl:variable name="xml_src" select="propsUtil:get($xml_src_id)"/>
				
		<!-- Proceso que genera el XML -->
		<xsl:variable name="xml_proccess_id"><xsl:value-of select="$p_cod_proceso"/>.xml</xsl:variable>
		<xsl:variable name="xml_proccess" select="propsUtil:get($xml_proccess_id)"/>
		
		<!-- Dominio donde se genera el XML -->
		<xsl:variable name="xml_domain_id"><xsl:value-of select="$xml_src"/>.<xsl:value-of select="$host"/>.url</xsl:variable>
		<xsl:variable name="xml_domain" select="propsUtil:get($xml_domain_id)"/>
		
		<!-- URL xml --> 
		<xsl:variable name="xml_url"><xsl:value-of select="$xml_domain"/><xsl:value-of select="$xml_proccess"/></xsl:variable>
		
		<xsl:variable name="fichaPDI" select="ehu:app/ehu:fichaPDI"/>
		
		<!-- Error al recuperar XML -->
		<xsl:template name="xml_error">
			<div>
				<xsl:attribute name="class">alert alert-error</xsl:attribute>
				<p>
					<xsl:value-of select="languageUtil:get($locale, 'an-error-occurred-while-processing-your-xml-and-xsl')"/>
				</p>										
			</div>
		</xsl:template>
		
		<!-- Información destacada -->
		<xsl:template name="info">
			<xsl:param name="advice"/>
			<div>
				<xsl:attribute name="class">alert alert-info</xsl:attribute>
				<p>
					<xsl:value-of select="$advice"/>
				</p>										
			</div>
		</xsl:template>
		
		<!-- Cabecera con encabezado h1 -->
		<xsl:template name="header">
		  <xsl:param name="title"/>
		  <xsl:if test="$title != $void">
		  <h1>
			<xsl:value-of select="$title"/>								
		  </h1>
		  </xsl:if>
		</xsl:template>
		
		<!-- Cabecera con encabezado h2 -->
		<xsl:template name="header_main">
		  <xsl:param name="title"/>
		  <xsl:if test="$title != $void">
		  <h2>
			<xsl:value-of select="$title"/>								
		  </h2>
		  </xsl:if>
		</xsl:template>
		
		<!-- Cabecera con encabezado h2 con otro texto oculto para impresion-->
		<xsl:template name="header_main_imptext">
		  <xsl:param name="title"/>
		  <xsl:param name="titleOculto"/>
		  <xsl:if test="$title != $void">
		  <h2>
			<xsl:value-of select="$title"/>		
			<span class="visible-print"><xsl:value-of select="$titleOculto"/></span>						
		  </h2>
		  </xsl:if>
		</xsl:template>
		
		<!-- Cabecera con encabezado h3 -->
		<xsl:template name="header_secondary">
		  <xsl:param name="icon"/>
		  <xsl:param name="title"/>
		  <xsl:if test="$title != $void">
		  <h3>
		  	<xsl:if test="$icon != $void">
		  		<span>
		  			<xsl:attribute name="class"><xsl:value-of select="$icon"/></xsl:attribute>
		  			<xsl:value-of select="$white_space"/>
		  		</span>
		  	</xsl:if>
		  	<xsl:value-of select="$title"/>												
		  </h3>
		  </xsl:if>
		</xsl:template>
		
		<!-- Cabecera con encabezado h4 -->
		<xsl:template name="header_third">
		  <xsl:param name="icon"/>
		  <xsl:param name="title"/>
		  <xsl:if test="$title != $void">
		  <h4>
		  	<xsl:if test="$icon != $void">
		  		<span>
		  			<xsl:attribute name="class"><xsl:value-of select="$icon"/></xsl:attribute>
		  			<xsl:value-of select="$white_space"/>
		  		</span>
		  	</xsl:if>
		  	<xsl:value-of select="$title"/>												
		  </h4>
		  </xsl:if>
		</xsl:template>
		
		<!-- Cabecera sin encabezado -->
		<xsl:template name="header_normal">
		  <xsl:param name="icon"/>
		  <xsl:param name="title"/>
		  <xsl:if test="$title != $void">
		  	<xsl:if test="$icon != $void">
		  		<span>
		  			<xsl:attribute name="class"><xsl:value-of select="$icon"/></xsl:attribute>
		  			<xsl:value-of select="$white_space"/>
		  		</span>
		  	</xsl:if>
		  	<p>
		  		<xsl:attribute name="class">title</xsl:attribute>
				<xsl:value-of select="$title"/>
			</p>									
		  </xsl:if>
		</xsl:template>
		
		
		<!-- Elemento i -->
		<xsl:template name="elemento_i">
			<xsl:text disable-output-escaping="yes"> 
			<![CDATA[    
				<i class="fa fa-info-circle color-secondary " aria-hidden="true" style="display: inline-block"></i>
			]]>
			</xsl:text>
		</xsl:template>
		
		<!-- elemento_span_atras -->
		<xsl:template name="elemento_span_atras">
			<xsl:text disable-output-escaping="yes"> 
			<![CDATA[    
				<span class="icon-chevron-left"></span>
			]]>
			</xsl:text>
		</xsl:template>
		
		<xsl:template name="elemento_span_imprimir">
			<xsl:text disable-output-escaping="yes"> 
			<![CDATA[    
				<span class="icon-print"></span>
			]]>
			</xsl:text>
		</xsl:template>
		
		<xsl:template name="string-replace-all">
			<xsl:param name="text" />
    		<xsl:param name="replace" />
    		<xsl:param name="by" />
    		
		    <xsl:choose>
		      <xsl:when test="contains($text, $replace)">
		        <xsl:value-of select="substring-before($text,$replace)" />
		        <xsl:value-of select="$by" />
		        <xsl:call-template name="string-replace-all">
		          <xsl:with-param name="text"  select="substring-after($text,$replace)" />
		          <xsl:with-param name="replace" select="$replace" />
		          <xsl:with-param name="by" select="$by" />
		        </xsl:call-template>
		      </xsl:when>
		      <xsl:otherwise>
		        <xsl:value-of select="$text" />
		      </xsl:otherwise>
		    </xsl:choose>
		</xsl:template>
		
		<!-- Vueta al inicio con el texto recibido por parametro -->
		<xsl:template name="back_to">
			<xsl:param name="to"/>
			<div>
				<xsl:attribute name="class">taglib-header</xsl:attribute> 
				<span> 
					<xsl:attribute name="class">back-to</xsl:attribute>
					<a>
						<xsl:attribute name="href">?p_cod_idioma=<xsl:value-of select="$p_cod_idioma"/>&amp;p_cod_proceso=<xsl:value-of select="$p_cod_proceso"/></xsl:attribute>
						<span>
			  				<xsl:attribute name="class">icon-chevron-left</xsl:attribute>
			  				<xsl:value-of select="$white_space"/>
			  			</span> 
						<span><xsl:value-of select="$to"/></span> 
					</a>
				</span>
			</div>	
		</xsl:template>
		
		<!-- Vueta al inicio con el texto generico Atras -->
		<xsl:template name="back">
			<div>
				<xsl:attribute name="class">taglib-header</xsl:attribute> 
				<span> 
					<xsl:attribute name="class">back-to</xsl:attribute>
					<a>
						<xsl:attribute name="href">?p_cod_idioma=<xsl:value-of select="$p_cod_idioma"/>&amp;p_cod_proceso=<xsl:value-of select="$p_cod_proceso"/></xsl:attribute>
						<span>
			  				<xsl:attribute name="class">icon-chevron-left</xsl:attribute>
			  				<xsl:value-of select="$white_space"/>
			  			</span> 
						<span><xsl:value-of select="languageUtil:get($locale,'back')"/></span> 
					</a>
				</span>
			</div>	
		</xsl:template>
		
		<!-- Navegacion -->
		<xsl:template name="navigation">
			<xsl:param name="nav"/>
			<nav>
				<xsl:attribute name="id">pagination</xsl:attribute>
				<xsl:attribute name="class">pagination pagination-centered</xsl:attribute>			
				<ul>
					<xsl:attribute name="class">pagination-content</xsl:attribute>
					<xsl:for-each select="$nav/ehu:navitem">
						<xsl:variable name="anchor" select="@val"/>
						<xsl:variable name="label" select="@label"/>
						<li>
							<a>
								<xsl:attribute name="href">#<xsl:value-of select="$anchor"/></xsl:attribute>
								<xsl:attribute name="title"><xsl:value-of select="$label"/></xsl:attribute>
								<xsl:value-of select="$anchor"/>
							</a>
						</li>
					</xsl:for-each>
				</ul>
			</nav>
		</xsl:template>
		
		<!-- Resumen de titulos propios -->
		<xsl:template name="summary">
			<xsl:param name="type"/>
			<xsl:param name="credits"/>
			<xsl:param name="price"/>			
				<xsl:if test="($type != $void) or ($credits != $void) or ($price != $void and $credits != $void)">
				<div>
					<xsl:attribute name="class">summary</xsl:attribute>
					<dl>
						<xsl:if test="$type != $void">
							<dt><xsl:value-of select="languageUtil:get($locale,'ehu.degree-type')"/></dt>
							<dd>
								<xsl:value-of select="$type"/>
							</dd>
						</xsl:if>
						<xsl:if test="$credits != $void">
							<dt><xsl:value-of select="languageUtil:get($locale,'ehu.number-of-credits')"/></dt><dd><xsl:value-of select="$credits"/></dd>
						</xsl:if>						
						<xsl:if test="$price != $void and $credits != $void">
							<dt><xsl:value-of select="languageUtil:get($locale,'ehu.price')"/></dt>
							<dd>
								<xsl:variable name="totalPrize" select="$price * $credits"/>
								<xsl:variable name="totalPrizeFormat" select='format-number($totalPrize, "###,###.00")' />
								
								<xsl:variable name="coma" select="','"/>
								<xsl:variable name="punto" select="'.'"/>		
								<xsl:choose>
									<xsl:when test="contains($totalPrizeFormat,$coma)">
										<xsl:choose>
											<!--  si contiene coma y punto -->
											<xsl:when test="contains($totalPrizeFormat,$punto)">
												<xsl:value-of select="substring-before($totalPrizeFormat,$coma)"/><xsl:value-of select="$white_space"/><xsl:value-of select="substring-before(substring-after($totalPrizeFormat,$coma),$punto)"/><xsl:value-of select="$coma"/><xsl:value-of select="substring-after($totalPrizeFormat,$punto)"/><xsl:value-of select="$white_space"/><xsl:value-of select="languageUtil:get($locale,'ehu.euros')"/>
											</xsl:when>
											<!--  si contiene coma sólo -->
											<xsl:otherwise>
												<xsl:value-of select="substring-before($totalPrizeFormat,$coma)"/><xsl:value-of select="$white_space"/><xsl:value-of select="substring-after($totalPrizeFormat,$coma)"/><xsl:value-of select="$white_space"/><xsl:value-of select="languageUtil:get($locale,'ehu.euros')"/>
											</xsl:otherwise>
										</xsl:choose>	
									</xsl:when>
									<xsl:otherwise>
										<!--  si contiene punto sólo -->
										<xsl:if test="contains($totalPrizeFormat,$punto)">
												<xsl:value-of select="substring-before($totalPrizeFormat,$punto)"/><xsl:value-of select="$coma"/><xsl:value-of select="substring-after($totalPrizeFormat,$punto)"/><xsl:value-of select="$white_space"/><xsl:value-of select="languageUtil:get($locale,'ehu.euros')"/>
										</xsl:if>
											
									</xsl:otherwise>
								</xsl:choose>	
								
							</dd>			
						</xsl:if>
								
												
					</dl>					
				</div>
				</xsl:if>
		</xsl:template>	
		
		<!-- Localizacion -->
		<xsl:template name="address">
			<xsl:param name="title"/>
			<xsl:param name="subtitle"/>
			<xsl:param name="floor"/>
			<xsl:param name="building"/>
			<xsl:param name="street"/>
			<xsl:param name="postal_code"/>
			<xsl:param name="city"/>
			<xsl:param name="region"/>
			<xsl:param name="country"/>
				
				<xsl:if test="$title != $void">
					<p><strong>
						<xsl:value-of select="$title" />													
					</strong></p>
				</xsl:if>	
				<xsl:if test="$subtitle != $void">
					<xsl:call-template name="header_normal">
						<xsl:with-param name="icon" select="$void"/>
						<xsl:with-param name="title" select="$subtitle"/>														
					</xsl:call-template>
				</xsl:if>
					
				<xsl:if test="$building != $void or $street != $void or $postal_code != $void  or $city != $void or $region != $void">
					<p>
						<xsl:if test="$building != $void">
							<span>
								<xsl:attribute name="class">building</xsl:attribute>
							 	<xsl:value-of select="$building"/></span>
							 	<xsl:if test="floor != $void">
								<span>
									<xsl:attribute name="class">floor</xsl:attribute>
								 	<xsl:value-of select="$floor"/></span>
							</xsl:if>
						</xsl:if>
						<xsl:if test="$street != $void">
							<span>
								<xsl:attribute name="class">street</xsl:attribute>
							 	<xsl:value-of select="$street"/>
							 	<xsl:value-of select="$white_space"/>
							 </span>						 
						</xsl:if>
						<xsl:if test="$postal_code != $void">
							<span>
								<xsl:attribute name="class">cp</xsl:attribute>
								<abbr>
									<xsl:attribute name="title">
										<xsl:value-of select="languageUtil:get($locale,'ehu.postal-code')"/>
									</xsl:attribute>
								</abbr>
								<xsl:value-of select="languageUtil:get($locale,'ehu.abbr.pc')"/>
								<xsl:value-of select="$postal_code"/>
								<xsl:value-of select="$white_space"/>
							</span>
						</xsl:if>	
						<xsl:if test="$city != $void">
							<span>
								 <xsl:attribute name="class">city</xsl:attribute>
								 <xsl:value-of select="$city"/>
								 <xsl:value-of select="$white_space"/>
							</span>
						</xsl:if>	
						<xsl:if test="$region != $void">
							<span>
								 <xsl:attribute name="class">region</xsl:attribute>
								(<xsl:value-of select="$region"/>
								<xsl:if test="$country != $void">
									<xsl:value-of select="$white_space"/>
									<span>
										<xsl:attribute name="class">country</xsl:attribute>
										<xsl:value-of select="$country"/>
									</span>
								</xsl:if>)
							</span>
						</xsl:if>
					</p>											
				</xsl:if>
		</xsl:template>
		
		<!-- Enlace -->
		<xsl:template name="link">
			<xsl:param name="icon"/>
			<xsl:param name="link"/>
			<xsl:param name="action"/>
			<xsl:param name="target"/>
			<xsl:param name="title"/>
			<xsl:param name="name"/>
			<xsl:param name="extension"/>
		  	<xsl:param name="size"/>
		  	<dt>
			  	<xsl:if test="($icon != $void) and ($name != $void)">
			  			<xsl:if test="$icon != $void">
							<span>
								<xsl:choose>
									<xsl:when test="$icon = 'file'">
										<xsl:attribute name="class">icon-file</xsl:attribute>
									</xsl:when>
									<xsl:when test="$icon = 'laptop'">
										<xsl:attribute name="class">icon-laptop</xsl:attribute>
									</xsl:when>
									<xsl:when test="$icon = 'envelope'">
										<xsl:attribute name="class">icon-envelope</xsl:attribute>
									</xsl:when>
									<xsl:when test="$icon = 'phone'">
										<xsl:attribute name="class">icon-phone</xsl:attribute>
									</xsl:when>
									<xsl:when test="$icon = 'video'">
										<xsl:attribute name="class">icon-play</xsl:attribute>
									</xsl:when>
									<xsl:otherwise>
										<xsl:attribute name="class">icon-link</xsl:attribute>								
									</xsl:otherwise>						
								</xsl:choose>
								<xsl:value-of select="$white_space"/>
							</span>										
						</xsl:if>
						<xsl:if test="($name = 'phone') or ($name = 'email') or ($name = 'fax') or ($name = 'web') ">
							<strong>
								<xsl:choose>
									<xsl:when test="$name = 'phone'">
										<xsl:value-of select="languageUtil:get($locale,'ehu.phone')"/>
									</xsl:when>
									<xsl:when test="$name = 'email'">
										<xsl:value-of select="languageUtil:get($locale,'ehu.email')"/>
									</xsl:when>
									<xsl:when test="$name = 'fax'">
										<xsl:value-of select="languageUtil:get($locale,'ehu.fax')"/>
									</xsl:when>
									<xsl:when test="$name = 'web'">
										<xsl:value-of select="languageUtil:get($locale,'ehu.web-address')"/>
									</xsl:when>		
									<xsl:otherwise>
										<xsl:if test="$name != $void">
											<xsl:value-of select="$name"/>
										</xsl:if>
									</xsl:otherwise>										
								</xsl:choose>					
							</strong>		
							<xsl:value-of select="$white_space"/>							
						</xsl:if>
			  	</xsl:if>
			 </dt>
			 <dd>
			  	<!-- Enlace al documento
			  			si existe la ruta al fichero, se informa y se muestra
			  			si no existe la ruta o no se ha podido obtener, se quita -->
			  			
			  	<a>
			  		<!--  si tenemos extension ponemos el icono asociado a la extension tb --> 
			  		<xsl:choose>
			  			<xsl:when test="$extension != $void">
			  				<xsl:attribute name="class">bullet bullet-<xsl:value-of select="$extension" /></xsl:attribute>
			  			</xsl:when>
			  			<xsl:otherwise>
			  				<xsl:attribute name="class">document_link</xsl:attribute>
			  			</xsl:otherwise>
			  		</xsl:choose>
					
					<xsl:attribute name="href">
						<xsl:choose>
							<xsl:when test="$action = 'call_phone'">tel:<xsl:value-of select="$link" /></xsl:when>
							<xsl:when test="$action = 'send_email'">mailto:<xsl:value-of select="$link" /></xsl:when>
							<xsl:when test="$action = 'send_fax'">fax:<xsl:value-of select="$link" /></xsl:when>
							<xsl:otherwise><xsl:value-of select="$link" /></xsl:otherwise>
						</xsl:choose>	
					</xsl:attribute>
					<xsl:if test="$target != $void">
						<xsl:attribute name="target">
							<xsl:value-of select="$target"/>
						</xsl:attribute>
					</xsl:if>		
					<xsl:if test="$title != $void">
						<xsl:attribute name="title">
						 	<xsl:value-of select="$title"/>
						</xsl:attribute>						
					</xsl:if>
					<span>
						<xsl:choose>
							<xsl:when test="$action = 'withName'">
								<xsl:value-of select="$name" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$link" />
							</xsl:otherwise>
						</xsl:choose>
					</span>
					<xsl:if test="($size != $void) and ($extension != $void)">
						<xsl:value-of select="$white_space"/>(<span><xsl:attribute name="class">document_extension</xsl:attribute><xsl:value-of select="$extension"/></span>,<xsl:value-of select="$white_space"/><span><xsl:attribute name="class">document_size</xsl:attribute><xsl:value-of select="$size"/></span>)</xsl:if>
				</a>
				<!-- Descripcion SIN enlace del documento
						si existe la ruta al fichero, se quita
						si no existe la ruta o no se ha podido obtener, se muestra -->
				<xsl:if test="($size != $void) and ($extension != $void)">
					<span>
						<xsl:attribute name="class">document_name</xsl:attribute>
						<xsl:value-of select="$name" />						
					</span>
				</xsl:if>			
			</dd>	
		</xsl:template>
		
		<!-- Edorta eta Virginia 26-07-2017 -->
		<!--  se añade un template especial para el vídeo de la cabecera de la página principal -->
		<!-- Enlace Vídeo cabecera-->
		<xsl:template name="link-video">
			<xsl:param name="icon"/>
			<xsl:param name="link"/>
			<xsl:param name="action"/>
			<xsl:param name="target"/>
			<xsl:param name="title"/>
			<xsl:param name="name"/>
			<xsl:param name="extension"/>
		  	<xsl:param name="size"/>
		  	<p>
				<xsl:if test="($icon != $void) and ($name != $void)">
					<xsl:if test="$icon != $void">
						<xsl:attribute name="class">video-link btn btn-info</xsl:attribute>
							<span><xsl:attribute name="class">icon-play</xsl:attribute><xsl:value-of select="$white_space"/></span>
						
						<xsl:value-of select="$white_space"/>
					</xsl:if>	
				 </xsl:if>
				 <!-- Enlace al documento
				  	si existe la ruta al fichero, se informa y se muestra
				  	si no existe la ruta o no se ha podido obtener, se quita --> 
				 <a>
					<xsl:attribute name="class">document_link</xsl:attribute>
					<xsl:attribute name="href">
						<xsl:value-of select="$link" />
					</xsl:attribute>
					<xsl:if test="$target != $void">
						<xsl:attribute name="target">
							<xsl:value-of select="$target"/>
						</xsl:attribute>
					</xsl:if>		
					<xsl:if test="$title != $void">
						<xsl:attribute name="title">
							 <xsl:value-of select="$title"/>
						</xsl:attribute>						
					</xsl:if>
					<span>
						<xsl:choose>
							<xsl:when test="$action = 'withName'">
								<xsl:value-of select="$name" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$link" />
							</xsl:otherwise>
						</xsl:choose>
					</span>
					<xsl:if test="($size != $void) and ($extension != $void)">
						(<abbr>
						<xsl:variable name="literal-extension" select="concat('ehu.ext.', $extension)"></xsl:variable>
						<xsl:attribute name="title"><xsl:value-of select="languageUtil:get($locale, $literal-extension)"/></xsl:attribute>
						<xsl:value-of select="$extension"/>
						<xsl:value-of select="$white_space"/>
						</abbr>
						<abbr>
								<xsl:choose>
				  					<xsl:when test="contains($size, Kb)">
				  						<xsl:attribute name="title"><xsl:value-of select="languageUtil:get($locale, 'ehu.ext.Kb')"/></xsl:attribute>
									</xsl:when>
									<xsl:otherwise>
										<xsl:attribute name="title"><xsl:value-of select="languageUtil:get($locale, 'ehu.ext.Mb')"/></xsl:attribute>
									</xsl:otherwise>
								</xsl:choose>
							<xsl:value-of select="$size"/>
						</abbr>)
						<span><xsl:attribute name="class">icon-external-link</xsl:attribute></span>
					
					</xsl:if>
					</a>
					<!-- Descripcion SIN enlace del documento
							si existe la ruta al fichero, se quita
							si no existe la ruta o no se ha podido obtener, se muestra -->
					<xsl:if test="($size != $void) and ($extension != $void)">
						<span>
							<xsl:attribute name="class">document_name</xsl:attribute>
							<xsl:value-of select="$name" />						
						</span>
					</xsl:if>
			</p>				
		</xsl:template>
		
		<!-- Documento de Grados -->
		<xsl:template name="link_document_graduate">
			<xsl:param name="document_type"/>
			<xsl:param name="document_cod_title"/>
			<xsl:param name="document_title"/>
			<xsl:param name="document_anyo"/>
			<xsl:param name="file_name"/>
			<xsl:param name="extension"/>
		  	<xsl:param name="size"/>
		  	
		  	
		  	
		  	<xsl:element name="a">
				<xsl:attribute name="href">?p_redirect=descargaFichero&amp;p_cod_proceso=egr&amp;p_tipo=<xsl:value-of select="$document_type"/>&amp;p_cod_titulo=<xsl:value-of select="$document_cod_title"/>&amp;p_anyo_acad=<xsl:value-of select="$document_anyo"/></xsl:attribute>
				<xsl:attribute name="target">_blank</xsl:attribute>
				<xsl:element name="span">
					<xsl:attribute name="class">hide-accessible</xsl:attribute>		
					<xsl:value-of select="languageUtil:get($locale,'opens-new-window')"/>
				</xsl:element>
				<xsl:choose>
					<xsl:when test="$document_title != $void">
						<xsl:value-of select="$document_title"/>											
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$file_name"/>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:if test="($size != $void) and ($extension != $void)"> (<xsl:element name="abbr"><xsl:variable name="literal-extension" select="concat('ehu.ext.', $extension)"></xsl:variable><xsl:attribute name="title"><xsl:value-of select="languageUtil:get($locale, $literal-extension)"/></xsl:attribute><xsl:value-of select="$extension"/><xsl:value-of select="$white_space"/></xsl:element><xsl:value-of select="substring-before($size,  $white_space)"/><xsl:element name="abbr"><xsl:choose><xsl:when test="contains($size, Kb)"><xsl:attribute name="title"><xsl:value-of select="languageUtil:get($locale, 'ehu.ext.Kb')"/></xsl:attribute><xsl:value-of select="substring-after($size,  $white_space)"/></xsl:when><xsl:otherwise><xsl:attribute name="title"><xsl:value-of select="languageUtil:get($locale, 'ehu.ext.Mb')"/></xsl:attribute><xsl:value-of select="substring-after($size,  $white_space)"/></xsl:otherwise></xsl:choose></xsl:element>)</xsl:if>
			</xsl:element>
		</xsl:template>
		
		<!-- Documento de Master -->
		<xsl:template name="link_document_master">
			<xsl:param name="document_type"/>
			<xsl:param name="document_anyo_pop"/>
			<xsl:param name="document_cod_master"/>
			<xsl:param name="document_cod_materia"/>
			<xsl:param name="document_fase"/>
			<xsl:param name="document_anyo_inf"/>
			<xsl:param name="document_title"/>
			<xsl:param name="document_anyo"/>
			<xsl:param name="file_name"/>
			<xsl:param name="extension"/>
		  	<xsl:param name="size"/>
		  	
		  	<a>
		  		<xsl:attribute name="href">?p_redirect=descargaFichero&amp;p_tipo=<xsl:value-of select="$document_type"/>&amp;p_anyo_pop=<xsl:value-of select="$document_anyo_pop"/>&amp;p_cod_master=<xsl:value-of select="$document_cod_master"/>&amp;p_cod_materia=<xsl:value-of select="$document_cod_materia"/>&amp;p_fase=<xsl:value-of select="$document_fase"/>&amp;p_anyo_inf=<xsl:value-of select="$document_anyo_inf"/></xsl:attribute>
				<xsl:attribute name="target">_blank</xsl:attribute>
		  		<span>
			  	<xsl:choose>
			  		<xsl:when test="$extension != $void">
			  			<xsl:attribute name="class">bullet bullet-<xsl:value-of select="$extension" /></xsl:attribute>
			 	 	</xsl:when>
			  		<xsl:otherwise>
			  			<xsl:attribute name="class">icon-file</xsl:attribute>
			  		</xsl:otherwise>
			  	</xsl:choose>
			  	</span>
		  		<xsl:value-of select="$white_space"/>
				<span>
					<xsl:attribute name="class">hide-accessible</xsl:attribute>
					<xsl:value-of select="languageUtil:get($locale,'opens-new-window')"/>
				</span>
				<!-- Si el documento no tiene titulo se muestra el nombre del fichero -->
				<xsl:choose>
					<xsl:when test="$document_title != $void">
						<xsl:value-of select="$document_title"/>											
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$file_name"/>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:if test="($size != $void) and ($extension != $void)">
					(<abbr>
						<xsl:variable name="literal-extension" select="concat('ehu.ext.', $extension)"></xsl:variable>
						<xsl:attribute name="title"><xsl:value-of select="languageUtil:get($locale, $literal-extension)"/></xsl:attribute>
						<xsl:value-of select="$extension"/>
						<xsl:value-of select="$white_space"/>
						</abbr>
						<abbr>
								<xsl:choose>
				  					<xsl:when test="contains($size, Kb)">
				  						<xsl:attribute name="title"><xsl:value-of select="languageUtil:get($locale, 'ehu.ext.Kb')"/></xsl:attribute>
									</xsl:when>
									<xsl:otherwise>
										<xsl:attribute name="title"><xsl:value-of select="languageUtil:get($locale, 'ehu.ext.Mb')"/></xsl:attribute>
									</xsl:otherwise>
								</xsl:choose>
							<xsl:value-of select="$size"/>
						</abbr>)
						
				</xsl:if>
				<span><xsl:attribute name="class">icon-external-link</xsl:attribute></span>
			</a>
		</xsl:template>

		<!-- Documento de Doctorados -->
		<xsl:template name="link_document_doctor">
			<xsl:param name="document_type"/>
			<xsl:param name="document_cod_propuesta"/>
			<xsl:param name="document_title"/>
			<xsl:param name="document_anyo"/>
			<xsl:param name="file_name"/>
			<xsl:param name="extension"/>
		  	<xsl:param name="size"/>
		  	
		  	<a>
		  		<!--  si tenemos extension ponemos el icono asociado a la extension tb --> 
			  	<xsl:choose>
			  		<xsl:when test="$extension != $void">
			  			<xsl:attribute name="class">bullet bullet-<xsl:value-of select="$extension" /></xsl:attribute>
			 	 	</xsl:when>
			  		<xsl:otherwise>
			  			<xsl:attribute name="class">icon-file</xsl:attribute>
			  		</xsl:otherwise>
			  	</xsl:choose>
				<xsl:attribute name="href">?p_redirect=descargaFichero&amp;p_cod_proceso=plew0060&amp;p_tipo=<xsl:value-of select="$document_type"/>&amp;p_cod_propuesta=<xsl:value-of select="$document_cod_propuesta"/></xsl:attribute>
				<xsl:attribute name="target">_blank</xsl:attribute>
				<span class="hide-accessible">
					<xsl:attribute name="class">hide-accessible</xsl:attribute>
					<xsl:value-of select="languageUtil:get($locale,'opens-new-window')"/>
				</span>
				
				<!-- Si el documento no tiene titulo se muestra el nombre del fichero -->
				<xsl:choose>
					<xsl:when test="$document_title != $void">
						<xsl:value-of select="$document_title"/>											
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$file_name"/>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:if test="($size != $void) and ($extension != $void)">
					(<abbr>
						<xsl:variable name="literal-extension" select="concat('ehu.ext.', $extension)"></xsl:variable>
						<xsl:attribute name="title"><xsl:value-of select="languageUtil:get($locale, $literal-extension)"/></xsl:attribute>
						<xsl:value-of select="$extension"/>
						<xsl:value-of select="$white_space"/>
					</abbr>
					<abbr>
							<xsl:choose>
			  					<xsl:when test="contains($size, Kb)">
			  						<xsl:attribute name="title"><xsl:value-of select="languageUtil:get($locale, 'ehu.ext.Kb')"/></xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="title"><xsl:value-of select="languageUtil:get($locale, 'ehu.ext.Mb')"/></xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>
						<xsl:value-of select="$size"/>
					</abbr>)
					<span><xsl:attribute name="class">icon-external-link</xsl:attribute></span>
				</xsl:if>
			</a>
		</xsl:template>

		<!-- Correo electronico -->
		<xsl:template name="link_email">
			<xsl:param name="link"/>
			<xsl:call-template name="link">
		  		<xsl:with-param name="icon">envelope</xsl:with-param>
		  		<xsl:with-param name="action">send_email</xsl:with-param>
				<xsl:with-param name="link" select="$link"/>
				<xsl:with-param name="target"><xsl:value-of select="$void"/></xsl:with-param>
				<xsl:with-param name="title"><xsl:value-of select="languageUtil:get($locale,'ehu.send-email')"/></xsl:with-param>
				<xsl:with-param name="name">email</xsl:with-param>
				<xsl:with-param name="extension"><xsl:value-of select="$void"/></xsl:with-param>
				<xsl:with-param name="size"><xsl:value-of select="$void"/></xsl:with-param>				
			</xsl:call-template>
		</xsl:template>
		
				
		<!-- Fax -->
		<xsl:template name="link_fax">
			<xsl:param name="link"/>
			<xsl:call-template name="link">
		  		<xsl:with-param name="icon">laptop</xsl:with-param>
		  		<xsl:with-param name="action">send_fax</xsl:with-param>
				<xsl:with-param name="link" select="$link"/>
				<xsl:with-param name="target"><xsl:value-of select="$void"/></xsl:with-param>
				<xsl:with-param name="title"><xsl:value-of select="languageUtil:get($locale,'ehu.send-fax')"/></xsl:with-param>
				<xsl:with-param name="name">fax</xsl:with-param>
				<xsl:with-param name="extension"><xsl:value-of select="$void"/></xsl:with-param>
				<xsl:with-param name="size"><xsl:value-of select="$void"/></xsl:with-param>				
			</xsl:call-template>
		</xsl:template>
		
		<!-- Telefono -->
		<xsl:template name="link_phone">
			<xsl:param name="link"/>
			<xsl:call-template name="link">
		  		<xsl:with-param name="icon">phone</xsl:with-param>
		  		<xsl:with-param name="action">call_phone</xsl:with-param>
				<xsl:with-param name="link" select="$link"/>
				<xsl:with-param name="target"><xsl:value-of select="$void"/></xsl:with-param>
				<xsl:with-param name="title"><xsl:value-of select="languageUtil:get($locale,'ehu.call-to-phone')"/></xsl:with-param>
				<xsl:with-param name="name">phone</xsl:with-param>
				<xsl:with-param name="extension"><xsl:value-of select="$void"/></xsl:with-param>
				<xsl:with-param name="size"><xsl:value-of select="$void"/></xsl:with-param>				
			</xsl:call-template>
		</xsl:template>		
		
		<!-- Enlace a web -->
		<xsl:template name="link_web">
			<xsl:param name="link"/>
			<xsl:call-template name="link">
		  		<xsl:with-param name="icon">link</xsl:with-param>
		  		<xsl:with-param name="action"><xsl:value-of select="$void"/></xsl:with-param>
				<xsl:with-param name="link" select="$link"/>
				<xsl:with-param name="target">_blank</xsl:with-param>
				<xsl:with-param name="title"><xsl:value-of select="languageUtil:get($locale,'opens-new-window')"/></xsl:with-param>
				<xsl:with-param name="name">web</xsl:with-param>
				<xsl:with-param name="extension"><xsl:value-of select="$void"/></xsl:with-param>
				<xsl:with-param name="size"><xsl:value-of select="$void"/></xsl:with-param>				
			</xsl:call-template>
		</xsl:template>
		
		<!-- Enlace a web con titulo-->
		<xsl:template name="link_web_titulo">
			<xsl:param name="link"/>
			<xsl:param name="title"/>
			<li>
				<span>
					<xsl:attribute name="class">icon-link</xsl:attribute>		
					<xsl:value-of select="$white_space"/>
				</span>		
				
				<xsl:value-of select="$white_space"/>	
			
				<a>
					<xsl:attribute name="href"><xsl:value-of select="$link" /></xsl:attribute>
					<xsl:attribute name="target">_blank"</xsl:attribute>
					<xsl:attribute name="title"><xsl:value-of select="languageUtil:get($locale,'opens-new-window')" /></xsl:attribute>
					<span>
						<xsl:attribute name="class">summary-title</xsl:attribute>
						<xsl:value-of select="$title"/>
					</span>
					<xsl:value-of select="$white_space"/>
					<span class="icon-external-link"> </span>
							
				</a>
			</li>	
		</xsl:template>
		
		<!-- Contacto -->
		<xsl:template name="contact">
			<xsl:param name="contact"/>
				<div>
					<xsl:attribute name="class">contact</xsl:attribute>
					<dl>
					<xsl:for-each select="$contact">
						<xsl:if test="ehu:tfno">
							<xsl:for-each select="$contact/ehu:tfno">
								
								<xsl:call-template name="link_phone">
									<xsl:with-param name="link" select="."/>																
								</xsl:call-template>
								
							</xsl:for-each>	
						</xsl:if>
						<xsl:if test="ehu:fax">
							<xsl:for-each select="$contact/ehu:fax">
								
								<xsl:call-template name="link_fax">
									<xsl:with-param name="link" select="."/>								
								</xsl:call-template>
								
							</xsl:for-each>	
						</xsl:if>
						<xsl:if test="ehu:mail">
							<xsl:for-each select="$contact/ehu:mail">
								
								<xsl:call-template name="link_email">
									<xsl:with-param name="link" select="."/>								
								</xsl:call-template>
								
							</xsl:for-each>	
						</xsl:if>
						<xsl:if test="ehu:web">
							<xsl:for-each select="$contact/ehu:web">
								
								<xsl:call-template name="link_web">
									<xsl:with-param name="link" select="."/>								
								</xsl:call-template>
								
							</xsl:for-each>	
						</xsl:if>						
					</xsl:for-each>
					</dl>
				</div>								
		</xsl:template>
		
		
		<!-- Contacto Doctorado-->
		<xsl:template name="contact-doctorado">
			<xsl:param name="contact"/>
			<xsl:param name="nombre"/>
			<xsl:param name="localizacion"/>
				<div>
					<xsl:attribute name="class">contact</xsl:attribute>
					<dl>
					<dt><xsl:value-of select="languageUtil:get($locale,'name')"/></dt>
					<dd><xsl:value-of select="$nombre"/></dd>
					<xsl:if test="$localizacion != $void">
						<dt><xsl:value-of select="languageUtil:get($locale,'address')"/></dt>
						<dd><xsl:value-of select="$localizacion"/></dd>
					</xsl:if>
					
					<xsl:for-each select="$contact">
						<xsl:if test="ehu:tfno">
							<xsl:for-each select="$contact/ehu:tfno">
								
								<xsl:call-template name="link_phone">
									<xsl:with-param name="link" select="."/>																
								</xsl:call-template>
								
							</xsl:for-each>	
						</xsl:if>
						<xsl:if test="ehu:fax">
							<xsl:for-each select="$contact/ehu:fax">
								
								<xsl:call-template name="link_fax">
									<xsl:with-param name="link" select="."/>								
								</xsl:call-template>
								
							</xsl:for-each>	
						</xsl:if>
						<xsl:if test="ehu:mail">
							<xsl:for-each select="$contact/ehu:mail">
								
								<xsl:call-template name="link_email">
									<xsl:with-param name="link" select="."/>								
								</xsl:call-template>
								
							</xsl:for-each>	
						</xsl:if>
						<xsl:if test="ehu:web">
							<xsl:for-each select="$contact/ehu:web">
								
								<xsl:call-template name="link_web">
									<xsl:with-param name="link" select="."/>								
								</xsl:call-template>
								
							</xsl:for-each>	
						</xsl:if>						
					</xsl:for-each>
					</dl>
				</div>								
		</xsl:template>
		
		<!-- Organizacion -->
		<xsl:template name="organization">
			<xsl:param name="organizations"/>
			<xsl:param name="responsibles"/>
			<xsl:if test="($organizations != $void) or ($responsibles != $void)">
			<div>
				<xsl:attribute name="class">organization</xsl:attribute>
				<xsl:for-each select="$organizations/ehu:proponente">
					<xsl:call-template name="header_normal">
						<xsl:with-param name="icon" select="$void"/>
						<xsl:with-param name="title" select="ehu:descProponente"/>														
					</xsl:call-template>					
				</xsl:for-each>	
				<xsl:if test="$responsibles != $void">
					<xsl:call-template name="header_normal">
						<xsl:with-param name="icon" select="$void"/>
						<xsl:with-param name="title" select="languageUtil:get($locale,'ehu.responsibles')"/>														
					</xsl:call-template>
					<ul>
					<xsl:for-each select="$responsibles/ehu:responsable">
						<li>
							<xsl:value-of select="ehu:nomResponsable"/>
						</li>				
					</xsl:for-each>
					</ul>
				</xsl:if>	
			</div>	
			</xsl:if>
		</xsl:template>
		
		<!-- Requisitos -->
		<xsl:template name="requirements">
		  <xsl:param name="requirements"/>
		  	<xsl:if test="$requirements != $void">
		  	<div>
				<xsl:attribute name="class">requirements</xsl:attribute>
				<xsl:call-template name="header_normal">
					<xsl:with-param name="icon" select="$void"/>
					<xsl:with-param name="title" select="languageUtil:get($locale,'ehu.degree-requirement')"/>														
				</xsl:call-template>
			  	<ul>
			  		<xsl:for-each select="$requirements/ehu:requisito">
					<li>
						<xsl:value-of select="ehu:descReq"/>
					</li>
					</xsl:for-each>			  										
			  	</ul>
			</div>  	
		  	</xsl:if>
		</xsl:template>
		
		<!-- Acceso -->
		<xsl:template name="access">
			<xsl:param name="capacity_min"/>
			<xsl:param name="capacity_max"/>
			<xsl:param name="requirements"/>
				<xsl:if test="($capacity_min != $void and $capacity_max != $void) or ($requirements)">
					<div>
						<xsl:attribute name="class">access</xsl:attribute>
						<xsl:if test="$capacity_min != $void and $capacity_max != $void">
							<dl>
								<dt><xsl:value-of select="languageUtil:get($locale,'ehu.number-of-places')"/></dt>
								<dd>
									<xsl:value-of select="$capacity_min"/><xsl:value-of select="$white_space"/><xsl:value-of select="languageUtil:get($locale,'ehu.minimum')"/> - 
									<xsl:value-of select="$capacity_max"/><xsl:value-of select="$white_space"/><xsl:value-of select="languageUtil:get($locale,'ehu.maximum')"/>
								</dd>
							</dl>
						</xsl:if>
						<xsl:if test="$requirements != $void">
							<xsl:call-template name="requirements">
								<xsl:with-param name="requirements" select="$requirements"/>
							</xsl:call-template>
						</xsl:if>	
					</div>	
				</xsl:if>	
		</xsl:template>
		
		<!-- Lugares -->
		<xsl:template name="place">
			<xsl:param name="location"/>
			<xsl:if test="$location != $void">
				<div>
					<xsl:attribute name="class">location</xsl:attribute>
					<xsl:for-each select="$location">
						<xsl:call-template name="address">
							<xsl:with-param name="title" select="ehu:centro"/>
							<xsl:with-param name="subtitle" select="ehu:dpto"/>
							<xsl:with-param name="floor" select="$void"/>
							<xsl:with-param name="building" select="$void"/>
							<xsl:with-param name="street" select="ehu:localizacion/ehu:direccion"/>
							<xsl:with-param name="postal_code" select="ehu:localizacion/ehu:cp"/>
							<xsl:with-param name="city" select="ehu:localizacion/ehu:localidad"/>
							<xsl:with-param name="region" select="ehu:localizacion/ehu:provincia"/>
							<xsl:with-param name="country" select="$void"/>					
						</xsl:call-template>
					</xsl:for-each>	
				</div>
			</xsl:if>
		</xsl:template>		
		
		<!-- Fechas -->
		<xsl:template name="dates">
			<xsl:param name="init_date"/>
			<xsl:param name="end_date"/>
			<xsl:variable name="xml_fmtFechas" select="'yyyy-MM-dd'"/>
			<xsl:if test="$init_date != $void or $end_date != $void">
			
				<xsl:if test="languageUtil:getLanguageId($locale) != 'eu_ES'">
					<xsl:variable name="init_date_wz" select="substring-before($init_date,'Z')" />
					<xsl:variable name="end_date_wz" select="substring-before($end_date,'Z')" />
					<xsl:variable name="yearInit" select="substring($init_date_wz,1,4)" />
					<xsl:variable name="monthInit" select="substring($init_date_wz,6,2)" />
					<xsl:variable name="dayInit" select="substring($init_date_wz,9,2)" />
					<xsl:variable name="yearEnd" select="substring($end_date_wz,1,4)" />
					<xsl:variable name="monthEnd" select="substring($end_date_wz,6,2)" />
					<xsl:variable name="dayEnd" select="substring($end_date_wz,9,2)" />
					
					<div>
						<xsl:attribute name="class">dates</xsl:attribute>
						<dl>
							<xsl:if test="$init_date != $void">
								<dt><xsl:value-of select="languageUtil:get($locale,'ehu.init-date')"/></dt>
								<dd><xsl:value-of select="$dayInit"/>-<xsl:value-of select="$monthInit"/>-<xsl:value-of select="$yearInit"/></dd>
							</xsl:if>	
							<xsl:if test="$end_date != $void">
								<dt><xsl:value-of select="languageUtil:get($locale,'ehu.end-date')"/></dt>
								<dd><xsl:value-of select="$dayEnd"/>-<xsl:value-of select="$monthEnd"/>-<xsl:value-of select="$yearEnd"/></dd>
							</xsl:if>											
						</dl>					
					</div>
				</xsl:if>
				
				<xsl:if test="languageUtil:getLanguageId($locale) = 'eu_ES'">
					<div>
						<xsl:attribute name="class">dates</xsl:attribute>
						<dl>
							<xsl:if test="$init_date != $void">
								<dt><xsl:value-of select="languageUtil:get($locale,'ehu.init-date')"/></dt>
								<dd><xsl:value-of select="substring-before($init_date,'Z')" /></dd>
							</xsl:if>	
							<xsl:if test="$end_date != $void">
								<dt><xsl:value-of select="languageUtil:get($locale,'ehu.end-date')"/></dt>
								<dd><xsl:value-of select="substring-before($end_date, 'Z')" /></dd>
							</xsl:if>											
						</dl>					
					</div>
				</xsl:if>
			</xsl:if>
		</xsl:template>
		
		
			<!-- Fecha -->
		<xsl:template name="fecha">
			<xsl:param name="init_date"/>
			<xsl:variable name="xml_fmtFechas" select="'yyyy-MM-dd'"/>
			<xsl:if test="$init_date != $void">
			
				<xsl:if test="languageUtil:getLanguageId($locale) != 'eu_ES'">
					<xsl:variable name="init_date_wz" select="substring-before($init_date,'Z')" />
					
					<xsl:variable name="yearInit" select="substring($init_date_wz,1,4)" />
					<xsl:variable name="monthInit" select="substring($init_date_wz,6,2)" />
					<xsl:variable name="dayInit" select="substring($init_date_wz,9,2)" />
					
					
					<xsl:if test="$init_date != $void">
								
								<xsl:value-of select="$dayInit"/>/<xsl:value-of select="$monthInit"/>/<xsl:value-of select="$yearInit"/>
					</xsl:if>	
					
				</xsl:if>
				
				<xsl:if test="languageUtil:getLanguageId($locale) = 'eu_ES'">
					<xsl:variable name="init_date_wz" select="substring-before($init_date,'Z')" />
					<xsl:variable name="yearInit" select="substring($init_date_wz,1,4)" />
					<xsl:variable name="monthInit" select="substring($init_date_wz,6,2)" />
					<xsl:variable name="dayInit" select="substring($init_date_wz,9,2)" />
					<xsl:if test="$init_date != $void">
					<xsl:value-of select="$yearInit"/>/<xsl:value-of select="$monthInit"/>/<xsl:value-of select="$dayInit"/>
					</xsl:if>	
				</xsl:if>	
				
			</xsl:if>
		</xsl:template>
		
		<!-- Bibliografia -->
		<xsl:template name="bibliography">
			<xsl:param name="bibliography"/>
			<xsl:if test="$bibliography">
				<div>
					<xsl:attribute name="class">bibliography</xsl:attribute>
					<xsl:call-template name="header_normal">
						<xsl:with-param name="icon" select="$void"/>
						<xsl:with-param name="title" select="languageUtil:get($locale,'ehu.bibliography')"/>																				
					</xsl:call-template>
					<ul>
						<xsl:for-each select="$bibliography/ehu:publicacion">
							<li>
								<span>
									<xsl:attribute name="class">icon-book</xsl:attribute>
									<xsl:value-of select="$white_space"/>								
								</span>		
								<span>
									<xsl:value-of select="ehu:descBiblio"/>
								</span>	
							</li>
						</xsl:for-each>
					</ul>
				</div>	
			</xsl:if>
		</xsl:template>
		
		<!-- Profesorado -->
		<xsl:template name="teachers">
			<xsl:param name="teachers"/>
			<xsl:if test="$teachers">
				<ul>
				<xsl:for-each select="$teachers/ehu:profesor">
					<li>
						<xsl:if test="ehu:nomProfesor">
						<span>
							<xsl:attribute name="class">teacher</xsl:attribute>
							<xsl:value-of select="ehu:nomProfesor"/>
						</span>
						</xsl:if>
						<xsl:if test="ehu:descUniMec">
						<xsl:value-of select="$white_space" />
						<span>
							<xsl:attribute name="class">university</xsl:attribute>
							<xsl:value-of select="ehu:descUniMec"/>
						</span>						
						</xsl:if>
					</li>
				</xsl:for-each>
				</ul>
			</xsl:if>
		</xsl:template>
		
		<!-- Temario -->
		<xsl:template name="temary">
			<xsl:param name="temary"/>
			<xsl:if test="$temary">
				<ul>
				<xsl:for-each select="$temary/ehu:tema">
					<li>
						<span>
							<xsl:value-of select="ehu:descTema"/>
						</span>
						<xsl:call-template name="bibliography">
							<xsl:with-param name="bibliography" select="ehu:bibliografia"/>
						</xsl:call-template>
					</li>
				</xsl:for-each>
				</ul>
			</xsl:if>
		</xsl:template>
		
		<!-- Asignatura -->
		<xsl:template name="asignature">
			<xsl:param name="asignature"/>
			<xsl:if test="$asignature">			
			<h2>
				<xsl:attribute name="class">header toggler-header-collapsed</xsl:attribute>
				<xsl:value-of select="ehu:descCurso"/>
				<span>
					<xsl:attribute name="tabindex">0</xsl:attribute>
					<span>
						<xsl:attribute name="class">hide-accessible</xsl:attribute>
						<xsl:value-of select="languageUtil:get($locale,'ehu.toggle-navigation')"/>
					</span>
				</span>								
			</h2>
			<div>
				<xsl:attribute name="class">content toggler-content-collapsed</xsl:attribute>
				<dl>
					<!-- 
					<dt><xsl:value-of select="languageUtil:get($locale,'ehu.code')"/></dt>
					<dd><xsl:value-of select="ehu:codCurso"/></dd> 
					-->
					<dt><xsl:value-of select="languageUtil:get($locale,'ehu.number-of-credits')"/></dt>
					<dd><xsl:value-of select="ehu:numCreditos"/></dd>
					<dt><xsl:value-of select="languageUtil:get($locale,'ehu.study-type')"/></dt>
					<dd><xsl:value-of select="ehu:tipoDocencia"/></dd>
					<dt><xsl:value-of select="languageUtil:get($locale,'ehu.character-mode-')"/></dt>
					<dd><xsl:value-of select="ehu:descCaracter"/></dd>
					<dt><xsl:value-of select="languageUtil:get($locale,'ehu.teaching-language')"/></dt>
					<dd><xsl:value-of select="$asignature/ehu:idiomas/ehu:idioma/ehu:descIdiomaImpart"/></dd>					
				</dl>
				<xsl:if test="ehu:profesorado">
					<h3>
						<xsl:value-of select="languageUtil:get($locale,'ehu.teachers')"/>																		
					</h3>
					<xsl:call-template name="teachers">
						<xsl:with-param name="teachers" select="ehu:profesorado"/>
					</xsl:call-template>
				</xsl:if>
				<xsl:if test="ehu:temario">
					<h3>
						<xsl:value-of select="languageUtil:get($locale,'ehu.temary')"/>																		
					</h3>
					<xsl:call-template name="temary">
						<xsl:with-param name="temary" select="ehu:temario"/>
					</xsl:call-template>												
				</xsl:if>	
			</div>
			</xsl:if>
		</xsl:template>
		
		<!-- Plan de estudios -->
		<xsl:template name="study-plan">
			<xsl:param name="academic-year"/>
			<xsl:param name="study-plan"/>
			<xsl:if test="$study-plan">
			<div>
				<xsl:attribute name="id">toggler</xsl:attribute>
				<xsl:call-template name="header_normal">
					<xsl:with-param name="icon"><xsl:value-of select="$void"/></xsl:with-param>
					<xsl:with-param name="title">
						<xsl:value-of select="$academic-year"/>
					</xsl:with-param>														
				</xsl:call-template>
				<xsl:for-each select="$study-plan/ehu:curso">
					<xsl:call-template name="asignature">
						<xsl:with-param name="asignature" select="$study-plan/ehu:curso"/>
					</xsl:call-template>
				</xsl:for-each>								
			</div>	
			
			</xsl:if>
		</xsl:template>
		
	<!-- Etiqueta-Value -->
	<xsl:template name="label-value">
		<xsl:param name="label" />
		<xsl:param name="value" />
		<xsl:if test="$value != $void">
			<h2>
				<xsl:value-of select="$label" />
			</h2>
			<p>
				<xsl:value-of select="$value" disable-output-escaping="yes"/>
			</p>
		</xsl:if>
	</xsl:template>
	
	<!-- Etiqueta-Value -->
	<xsl:template name="label-value-without-title">
		
		<xsl:param name="value" />
		<xsl:if test="$value != $void">
			
			<p>
				<xsl:value-of select="$value" disable-output-escaping="yes"/>
			</p>
		</xsl:if>
	</xsl:template>
	
	<!--          -->
	<!-- Profesor -->
	<!--          -->
	
	<!-- Tutorias -->
	<xsl:template name="profesor-tutorias">
		<xsl:param name="tutorias" />
		<xsl:if test="$tutorias">
		<div>
		<xsl:attribute name="class">m-b-30</xsl:attribute>
	
			<div>
			<xsl:attribute name="class">bg-white</xsl:attribute>
				<h2>
				<xsl:attribute name="class">p-20</xsl:attribute>
				<xsl:value-of select="languageUtil:get($locale,'ehu.tutorias')" />
				</h2>
			<div class="table-responsive upv-tabla">
			<xsl:attribute name="class">table-responsive upv-tabla</xsl:attribute>
				<table>
				<xsl:attribute name="class">table</xsl:attribute>
				 	<caption><xsl:value-of select="languageUtil:get($locale,'upv-ehu.calendar')" /></caption>
					<thead>
						<tr>
							<th>
								<xsl:attribute name="scope">col</xsl:attribute>
							 	<xsl:value-of select="languageUtil:get($locale,'ehu.weeks')" />
							</th>
							<th>
								<xsl:attribute name="scope">col</xsl:attribute>
								<xsl:value-of select="languageUtil:get($locale,'ehu.monday')" />
							</th>
							<th>
								<xsl:attribute name="scope">col</xsl:attribute>
								<xsl:value-of select="languageUtil:get($locale,'ehu.tuesday')" />
							</th>
							<th>
								<xsl:attribute name="scope">col</xsl:attribute>
								<xsl:value-of select="languageUtil:get($locale,'ehu.wednesday')" />
							</th>
							<th>
								<xsl:attribute name="scope">col</xsl:attribute>
								<xsl:value-of select="languageUtil:get($locale,'ehu.thursday')" />
							</th>
							<th>
								<xsl:attribute name="scope">col</xsl:attribute>
								<xsl:value-of select="languageUtil:get($locale,'ehu.friday')" />
							</th>
						</tr>
					</thead>		
					<xsl:if test="$tutorias/ehu:tutoria ">
						<tbody>
						<xsl:for-each select="$tutorias/ehu:tutoria ">
							 <xsl:variable name="positionAnterior" select="position()-1" />
								<xsl:if test="(position()=1) or (ehu:semana/text() !=($tutorias/ehu:tutoria/ehu:semana)[$positionAnterior]/text())">
									<tr>
										<xsl:variable name="desSemana" select="ehu:desSemana" />
										<xsl:variable name="semana" select="ehu:semana" />
										<xsl:variable name="denMes" select="ehu:denMes" />
										<xsl:variable name="horaIni" select="ehu:horaIni" />
										<xsl:variable name="horaFin" select="ehu:horaFin" />
										<td>
											<xsl:value-of select="ehu:denMes" />
											<xsl:value-of select="$white_space" />
											<br />
											<strong>
												<xsl:value-of select="ehu:desSemana" />
											</strong>
										</td>
										<!--  la primera vez, se comprueba la semana, en la segunda vuelta se comprueba además las horas y los días -->
										<td>
										<xsl:for-each select="$tutorias/ehu:tutoria">
												<xsl:if test="ehu:diaSemana=1 and ehu:semana/text() = $semana/text()">
													<p>
														<strong>
															<xsl:value-of select="substring(ehu:horaIni,12,5)" />
															<xsl:value-of select="$white_space" />
															<xsl:value-of select="$guide" />
															<xsl:value-of select="$white_space" />
															<xsl:value-of select="substring(ehu:horaFin,12,5)" />
														</strong>			
														<br />
														<xsl:value-of select="ehu:desEdif" />
														<xsl:value-of select="$white_space" />
														<xsl:value-of select="ehu:desAula" />
														<br />
													</p>	
												</xsl:if>
										</xsl:for-each>
										</td>
										<td>
										<xsl:for-each select="$tutorias/ehu:tutoria">
												<xsl:if test="ehu:diaSemana=2 and ehu:semana/text() = $semana/text()">
													<p>
														<strong>
															<xsl:value-of select="substring(ehu:horaIni,12,5)" />
															<xsl:value-of select="$white_space" />
															<xsl:value-of select="$guide" />
															<xsl:value-of select="$white_space" />
															<xsl:value-of select="substring(ehu:horaFin,12,5)" />
														</strong>			
														<br />
														<xsl:value-of select="ehu:desEdif" />
														<xsl:value-of select="$white_space" />
														<xsl:value-of select="ehu:desAula" />
														<br />
													</p>	
												</xsl:if>
										</xsl:for-each>
										</td>
										<td>
										<xsl:for-each select="$tutorias/ehu:tutoria">
												<xsl:if test="ehu:diaSemana=3 and ehu:semana/text() = $semana/text()">
													<p>
														<strong>
															<xsl:value-of select="substring(ehu:horaIni,12,5)" />
															<xsl:value-of select="$white_space" />
															<xsl:value-of select="$guide" />
															<xsl:value-of select="$white_space" />
															<xsl:value-of select="substring(ehu:horaFin,12,5)" />
														</strong>			
														<br />
														<xsl:value-of select="ehu:desEdif" />
														<xsl:value-of select="$white_space" />
														<xsl:value-of select="ehu:desAula" />
														<br />
													</p>	
												</xsl:if>
										</xsl:for-each>
										</td>
										<td>
										<xsl:for-each select="$tutorias/ehu:tutoria">
												<xsl:if test="ehu:diaSemana=4 and ehu:semana/text() = $semana/text()">
													<p>
														<strong>
															<xsl:value-of select="substring(ehu:horaIni,12,5)" />
															<xsl:value-of select="$white_space" />
															<xsl:value-of select="$guide" />
															<xsl:value-of select="$white_space" />
															<xsl:value-of select="substring(ehu:horaFin,12,5)" />
														</strong>			
														<br />
														<xsl:value-of select="ehu:desEdif" />
														<xsl:value-of select="$white_space" />
														<xsl:value-of select="ehu:desAula" />
														<br />
													</p>	
												</xsl:if>
										</xsl:for-each>
										</td>
										<td>
										<xsl:for-each select="$tutorias/ehu:tutoria">
												<xsl:if test="ehu:diaSemana=5 and ehu:semana/text() = $semana/text()">
													<p>
														<strong>
															<xsl:value-of select="substring(ehu:horaIni,12,5)" />
															<xsl:value-of select="$white_space" />
															<xsl:value-of select="$guide" />
															<xsl:value-of select="$white_space" />
															<xsl:value-of select="substring(ehu:horaFin,12,5)" />
														</strong>			
														<br />
														<xsl:value-of select="ehu:desEdif" />
														<xsl:value-of select="$white_space" />
														<xsl:value-of select="ehu:desAula" />
														<br />
													</p>	
												</xsl:if>
										</xsl:for-each>
										</td>	
									</tr>
								</xsl:if>
						</xsl:for-each>
					</tbody>
					</xsl:if>	
				</table>
				</div>
				</div>
				</div>
		</xsl:if>
	</xsl:template>
	
	<!-- 																		 -->
	<!-- Templates compartidas por Grados (egr) y Departamentos (deparment) -->
	<!-- 																		 -->
	
	<!--                -->
	<!--  Asignatura 	-->
	<!--                -->
	
	<!-- Distribucion de horas por tipo de docencia -->
	<xsl:template name="tipoDocencia">
		<xsl:param name="docencias" />
		<xsl:if test="$docencias">
			<!--  xsl:call-template name="header_main">
				<xsl:with-param name="title" select="languageUtil:get($locale,'ehu.docencia')"/>
			</xsl:call-template-->
			<table class="table">
				<caption><xsl:value-of select="languageUtil:get($locale,'ehu.distribuccionHorasTipo')" /></caption>
				<thead>
					<tr>
						<th>
							<xsl:attribute name="scope">col</xsl:attribute>
							<xsl:value-of select="languageUtil:get($locale,'ehu.study-type')" />
						</th>
						<th>
							<xsl:attribute name="scope">col</xsl:attribute>
							<xsl:value-of select="languageUtil:get($locale,'ehu.horasDocente')" />
						</th>
						<th>
							<xsl:attribute name="scope">col</xsl:attribute>
							<xsl:value-of select="languageUtil:get($locale,'ehu.horasAlumno')" />
						</th>
					</tr>
				</thead>
				<xsl:if test="$docencias/ehu:docencia">
					<tbody>	
					<xsl:for-each select="$docencias/ehu:docencia">
							<tr>
								<th>
									<xsl:value-of select="ehu:descripcion" />
								</th>
								<td style="text-align:center">
									<xsl:value-of select="format-number(floor(ehu:duracionDocente*100) div 100, '#0.##')" />
									
								</td>
								<td style="text-align:center">
								
									<xsl:value-of select="format-number(floor(ehu:duracionAlumno*100) div 100, '#0.##')" />
								</td>
							</tr>
					</xsl:for-each>
					</tbody>
				</xsl:if>
			</table>
		</xsl:if>	
	</xsl:template>
	
	<!-- Miembros Tribunal -->
	<xsl:template name="miembrosTribunal">
		<xsl:param name="miembrosTribunal" />
		<xsl:if test="$miembrosTribunal">
			<!-- xsl:call-template name="header_main">
				<xsl:with-param name="title" select="languageUtil:get($locale,'ehu.miembrosTribunal')"/>
			</xsl:call-template -->
			<ul>
				<xsl:for-each select="$miembrosTribunal/ehu:miembro">
					<li>
						<xsl:value-of select="ehu:nombre" />
					</li>
				</xsl:for-each>
			</ul>
		</xsl:if>
	</xsl:template>
	
	<!-- Horarios por grupo -->
	<xsl:template name="graduate-groups">
		<xsl:param name="grupos" />
		<xsl:param name="anyoAcad" />
		<xsl:if test="$grupos">
			<div>
				<xsl:attribute name="id">toggler</xsl:attribute>
				
				<xsl:for-each select="$grupos/ehu:grupo">
					<h3>
						<xsl:attribute name="class">header toggler-header-collapsed toggler-header</xsl:attribute>
						<xsl:value-of select="ehu:denGrupo" />
					
						<span>
							<xsl:attribute name="tabindex">0</xsl:attribute>
							<span>
								<xsl:attribute name="class">hide-accessible</xsl:attribute>
								<xsl:value-of select="languageUtil:get($locale,'ehu.toggle-navigation')"/>
							</span>
						</span>
					</h3>		
					<div>
						<xsl:attribute name="class">content toggler-content-collapsed</xsl:attribute>
						<xsl:call-template name="horario-group">
							<xsl:with-param name="idGrupo" select="ehu:idGrupo" />
							<xsl:with-param name="denGrupo" select="ehu:denGrupo" />
							<xsl:with-param name="horarios" select="ehu:horarios" />
						</xsl:call-template>
						<xsl:call-template name="profesorado-group">
							<xsl:with-param name="profesorado" select="ehu:profesorado" />
							<xsl:with-param name="anyoAcad" select="$anyoAcad" />
						</xsl:call-template>
						<xsl:call-template name="examenes-group">
							<xsl:with-param name="examenes" select="ehu:examenes" />
						</xsl:call-template>
						<xsl:call-template name="aulas-group">
							<xsl:with-param name="aulas" select="ehu:aulas" />
						</xsl:call-template>
					</div>
				</xsl:for-each>
			</div>
		</xsl:if>
	</xsl:template>
	
	<!-- horario de grupo -->
	<xsl:template name="horario-group">
		<xsl:param name="idGrupo" />
		<xsl:param name="denGrupo" />
		<xsl:param name="horarios" />
		<xsl:if test="$denGrupo">
		<div>
			<xsl:attribute name="class">upv-tabla table-responsive</xsl:attribute>
			<table>
				<xsl:attribute name="id">tablaGrupo_<xsl:value-of select="$idGrupo" /></xsl:attribute>
				<xsl:attribute name="class">table table-bordered</xsl:attribute>
				<caption><xsl:value-of select="languageUtil:get($locale,'upv-ehu.calendar')"/><xsl:value-of select="$white_space"/></caption>
				<thead>
					<tr>
						<th>
							<xsl:attribute name="scope">col</xsl:attribute>
							<xsl:value-of select="languageUtil:get($locale,'ehu.weeks')" />
						</th>
						<th>
							<xsl:attribute name="scope">col</xsl:attribute>
							<xsl:value-of select="languageUtil:get($locale,'ehu.monday')" />
						</th>
						<th>
							<xsl:attribute name="scope">col</xsl:attribute>
							<xsl:value-of select="languageUtil:get($locale,'ehu.tuesday')" />
						</th>
						<th>
							<xsl:attribute name="scope">col</xsl:attribute>
							<xsl:value-of select="languageUtil:get($locale,'ehu.wednesday')" />
						</th>
						<th>
							<xsl:attribute name="scope">col</xsl:attribute>
							<xsl:value-of select="languageUtil:get($locale,'ehu.thursday')" />
						</th>
						<th>
							<xsl:attribute name="scope">col</xsl:attribute>
							<xsl:value-of select="languageUtil:get($locale,'ehu.friday')" />
						</th>
					</tr>
				</thead>
				<xsl:if test="$horarios/ehu:horario ">
														
					<tbody>
						<xsl:for-each select="$horarios/ehu:horario">
						
							<xsl:variable name="positionAnterior" select="position()-1" />
							 <xsl:if test="(position()=1) or 
							 	(ehu:semanaIni/text() !=($horarios/ehu:horario/ehu:semanaIni)[$positionAnterior]/text()) or (ehu:semanaFin/text() !=($horarios/ehu:horario/ehu:semanaFin)[$positionAnterior]/text())">
							 	<xsl:variable name="semanaIni" select="ehu:semanaIni" />
								<xsl:variable name="semanaFin" select="ehu:semanaFin" />
								<xsl:variable name="horaInicio" select="ehu:horaInicio" />
								<xsl:variable name="horaFin" select="ehu:horaFin" />
							 	<tr>
									<td>
										<xsl:value-of select="ehu:semanaIni" />
										<xsl:value-of select="$guide"/>
										<xsl:value-of select="ehu:semanaFin" />
									</td>
									<!--  la primera pasada pondremos los que sean de bloques semanales diferentes, la segunda pasada pondremos aquellos que comparten
											bloque semanal pero No día semana -->
									<td>
																											
									<xsl:for-each select="$horarios/ehu:horario">
										<!-- Variable i para relacionar horario con aula -->
										<xsl:variable name="i" select="position()" />
											<xsl:if test="ehu:diaSemana=1 and ehu:semanaIni/text() = $semanaIni/text() and ehu:semanaFin/text() = $semanaFin/text()">
												<p>
													<xsl:value-of select="substring(ehu:horaInicio,12,5)" />
													<xsl:value-of select="$guide"/>
													<xsl:value-of select="substring(ehu:horaFin,12,5)" />
													<xsl:value-of select="concat(' (', $i,')')"/>
													<br />
												</p>	
											</xsl:if>
									</xsl:for-each>
									</td>
									<td>
									<xsl:for-each select="$horarios/ehu:horario">
										<!-- Variable i para relacionar horario con aula -->
										<xsl:variable name="i" select="position()" />
											<xsl:if test="ehu:diaSemana=2 and ehu:semanaIni/text() = $semanaIni/text() and ehu:semanaFin/text() = $semanaFin/text()">
												<p>
													<xsl:value-of select="substring(ehu:horaInicio,12,5)" />
													<xsl:value-of select="$guide"/>
													<xsl:value-of select="substring(ehu:horaFin,12,5)" />
													<xsl:value-of select="concat(' (', $i,')')"/>
													<br />
												</p>	
											</xsl:if>
									</xsl:for-each>
									</td>
									<td>
									<xsl:for-each select="$horarios/ehu:horario">
										<!-- Variable i para relacionar horario con aula -->
										<xsl:variable name="i" select="position()" />
											<xsl:if test="ehu:diaSemana=3 and ehu:semanaIni/text() = $semanaIni/text() and ehu:semanaFin/text() = $semanaFin/text()">
												<p>
													<xsl:value-of select="substring(ehu:horaInicio,12,5)" />
													<xsl:value-of select="$guide"/>
													<xsl:value-of select="substring(ehu:horaFin,12,5)" />
													<xsl:value-of select="concat(' (', $i,')')"/>
													<br />
												</p>	
											</xsl:if>
									</xsl:for-each>
									</td>
									<td>
									<xsl:for-each select="$horarios/ehu:horario">
										<!-- Variable i para relacionar horario con aula -->
										<xsl:variable name="i" select="position()" />
											<xsl:if test="ehu:diaSemana=4 and ehu:semanaIni/text() = $semanaIni/text() and ehu:semanaFin/text() = $semanaFin/text()">
												<p>
													<xsl:value-of select="substring(ehu:horaInicio,12,5)" />
													<xsl:value-of select="$guide"/>
													<xsl:value-of select="substring(ehu:horaFin,12,5)" />
													<xsl:value-of select="concat(' (', $i,')')"/>
													<br />
												</p>	
											</xsl:if>
									</xsl:for-each>
									</td>
									<td>
									<xsl:for-each select="$horarios/ehu:horario">
										<!-- Variable i para relacionar horario con aula -->
										<xsl:variable name="i" select="position()" />
											<xsl:if test="ehu:diaSemana=5 and ehu:semanaIni/text() = $semanaIni/text() and ehu:semanaFin/text() = $semanaFin/text()">
												<p>
													<xsl:value-of select="substring(ehu:horaInicio,12,5)" />
													<xsl:value-of select="$guide"/>
													<xsl:value-of select="substring(ehu:horaFin,12,5)" />
													<xsl:value-of select="concat(' (', $i,')')"/>
													<br />
												</p>	
											</xsl:if>
									</xsl:for-each>
									</td>
								</tr>
							</xsl:if>
						</xsl:for-each>
					</tbody>
				</xsl:if>		
			</table>	
			</div>		
		</xsl:if>
	</xsl:template>
	
	<!-- Profesorado de grupo -->
	<xsl:template name="profesorado-group">
		<xsl:param name="profesorado" />
		<xsl:param name="anyoAcad" />
		<xsl:if test="$profesorado">
			<xsl:call-template name="header_third">
				<xsl:with-param name="title" select="languageUtil:get($locale,'ehu.profesorado')"/>				
			</xsl:call-template>
			<ul>
				<xsl:for-each select="$profesorado/ehu:profesor">
					<li>
						<a>
							 <xsl:attribute name="href">?p_redirect=consultaTutorias&amp;p_anyo_acad=<xsl:value-of select="$anyoAcad" />&amp;p_idp=<xsl:value-of select="ehu:idp" /></xsl:attribute> 
							<xsl:value-of select="ehu:nombre" />
						</a>
					</li>
				</xsl:for-each>
			</ul>			
		</xsl:if>
	</xsl:template>
	
		<!-- Exámenes de grupo -->
	<xsl:template name="examenes-group">
		<xsl:param name="examenes" />
		<xsl:if test="$examenes">
			<xsl:call-template name="header_third">
				<xsl:with-param name="title" select="languageUtil:get($locale,'ehu.exam')"/>				
			</xsl:call-template>
			<ul>
			<xsl:for-each select="$examenes/ehu:examen">
				<li>
				<!-- Fecha -->
				<xsl:variable name="fechaHora" select="ehu:fechaHora"/>
				<xsl:variable name="xml_fmtFechas" select="'yyyy-MM-dd'"/>
				<xsl:value-of select="ehu:mes" /> :	<xsl:if test="$fechaHora != $void">	<xsl:variable name="init_date_wz" select="substring-before($fechaHora,'Z')" /><xsl:variable name="yearInit" select="substring($init_date_wz,1,4)" /><xsl:variable name="monthInit" select="substring($init_date_wz,6,2)" /><xsl:variable name="dayInit" select="substring($init_date_wz,9,2)" /><xsl:variable name="hourInit" select="substring($init_date_wz,12,2)" /><xsl:variable name="minInit" select="substring($init_date_wz,15,2)" /><xsl:if test="languageUtil:getLanguageId($locale) != 'eu_ES'"><xsl:if test="$fechaHora != $void"><xsl:value-of select="$dayInit"/>-<xsl:value-of select="$monthInit"/>-<xsl:value-of select="$yearInit"/><xsl:value-of select="$white_space"/><xsl:value-of select="$hourInit"/>:<xsl:value-of select="$minInit"/></xsl:if></xsl:if><xsl:if test="languageUtil:getLanguageId($locale) = 'eu_ES'"><xsl:if test="$fechaHora != $void"><xsl:value-of select="$yearInit"/>-<xsl:value-of select="$monthInit"/>-<xsl:value-of select="$dayInit"/><xsl:value-of select="$white_space"/><xsl:value-of select="$hourInit"/>:<xsl:value-of select="$minInit"/></xsl:if></xsl:if></xsl:if></li>
			</xsl:for-each>
			</ul>
		</xsl:if>
	</xsl:template>
	
	<!-- Aulas de grupo -->
	<xsl:template name="aulas-group">
		<xsl:param name="aulas" />
		<xsl:if test="$aulas">
			<xsl:call-template name="header_third">
				<xsl:with-param name="title" select="languageUtil:get($locale,'ehu.aulasImparticion')"/>				
			</xsl:call-template>
			<ul>
			<xsl:for-each select="$aulas/ehu:aula">
				<li>
					<!-- variable i para pintar cuántas aulas hay -->
					<xsl:variable name="i" select="position()" />
					<xsl:value-of select="ehu:denominacion" />
					<xsl:value-of select="concat(' (', $i,')')"/>
				</li>
			</xsl:for-each>
			</ul>
		</xsl:if>
	</xsl:template>
	
	<!-- Etiqueta-Value-juntos-espacio Edorta-->
     <!-- Añade un espacio tras los dos puntos -->
     <xsl:template name="label-value-juntos-espacio">
         <xsl:param name="label" />
         <xsl:param name="value" />
         <xsl:if test="$value != $void">
             <div>
                 <dl>
                     <dt>
                         <strong><xsl:value-of select="$label" /></strong>
                         <xsl:value-of select="$two_points" />
                         <xsl:value-of select="$white_space"/>
                     </dt>
                     <dd>
                         <xsl:value-of select="$value" />
                     </dd>
                 </dl>
             </div>
         </xsl:if>
     </xsl:template>

	<!-- FICHA PDI MASTERS/GRADOS -->
	<xsl:template name="fichaPDI">
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
				<h2><xsl:value-of select="$fichaPDI/ehu:nombre"/><xsl:value-of select="$white_space"/><xsl:value-of select="$fichaPDI/ehu:apellido1"/><xsl:value-of select="$white_space"/><xsl:value-of select="$fichaPDI/ehu:apellido2"/></h2>
				<xsl:element name="div">
					<xsl:attribute name="class">row</xsl:attribute>
					<dl class="col-lg-8">
						<xsl:choose>
							<xsl:when test="count($fichaPDI/ehu:contratos/ehu:contrato) = 1">
								<dt><xsl:value-of select="languageUtil:get($locale,'ehu.knowledge-area')"/></dt>
								<dd><xsl:value-of select="$fichaPDI/ehu:contratos/ehu:contrato/ehu:desArea"/></dd>
								<dt><xsl:value-of select="languageUtil:get($locale,'ehu.departamento')"/></dt>
								<dd><xsl:value-of select="$fichaPDI/ehu:contratos/ehu:contrato/ehu:desDpto"/></dd>
								<dt><xsl:value-of select="languageUtil:get($locale,'ehu.teaching-center')"/></dt>
								<dd><xsl:value-of select="$fichaPDI/ehu:contratos/ehu:contrato/ehu:desCentro"/></dd>										
							</xsl:when>
							<xsl:otherwise>
								<xsl:for-each select="$fichaPDI/ehu:contratos/ehu:contrato">
									<dt><xsl:value-of select="languageUtil:get($locale,'ehu.area')"/><xsl:value-of select="$white_space" /><xsl:value-of select="position()" /></dt>
									<dd><xsl:value-of select="ehu:desArea"/></dd>
									<dt><xsl:value-of select="languageUtil:get($locale,'ehu.departamento')"/><xsl:value-of select="$white_space" /><xsl:value-of select="position()" /></dt>
									<dd><xsl:value-of select="ehu:desDpto"/></dd>
									<dt><xsl:value-of select="languageUtil:get($locale,'ehu.teaching-center')"/><xsl:value-of select="$white_space" /><xsl:value-of select="position()" /></dt>
									<dd><xsl:value-of select="ehu:desCentro"/></dd>
								</xsl:for-each>
							</xsl:otherwise>
						</xsl:choose>
						
						<dt><xsl:value-of select="languageUtil:get($locale,'ehu.email')"/></dt>
						<dd>
							<xsl:element name="a">
								<xsl:attribute name="href">mailto:<xsl:value-of select="$fichaPDI/ehu:email"/></xsl:attribute>
								<xsl:value-of select="$fichaPDI/ehu:email"/>
							</xsl:element>
						</dd>
						<xsl:if test="$fichaPDI/ehu:telefono">
							<dt><xsl:value-of select="languageUtil:get($locale,'ehu.phone')"/></dt>
							<dd>
								<xsl:element name="a">
									<xsl:attribute name="href">tel:<xsl:value-of select="$fichaPDI/ehu:telefono"/></xsl:attribute>
									<xsl:value-of select="$fichaPDI/ehu:telefono"/>
								</xsl:element>
							</dd>
						</xsl:if>
					</dl>
					<xsl:if test="$fichaPDI/ehu:foto">
						<xsl:element name="div">
							<xsl:attribute name="class">row col-lg-4 foto-profesor</xsl:attribute>
							<xsl:element name="img">
								<xsl:attribute name="src"><xsl:value-of select="$fichaPDI/ehu:foto"/></xsl:attribute>
							</xsl:element>
						</xsl:element>
					</xsl:if>
				</xsl:element>
				<!-- Metemos el texto del curriculum en un <p>. Trello 409) Crear links en cv de ficha-pdi -->
				<xsl:if test="$fichaPDI/ehu:curriculum/ehu:resumen">
					<p>
						<xsl:call-template name="transform_text">
							<xsl:with-param name="text" select="$fichaPDI/ehu:curriculum/ehu:resumen"/>
						</xsl:call-template>
					</p>
				</xsl:if>
				<xsl:if test="$fichaPDI/ehu:curriculum/ehu:documento">
					<xsl:element name="ul">
						<xsl:attribute name="class">list-icons</xsl:attribute>
						<xsl:element name="li">
							<xsl:attribute name="class">pdf</xsl:attribute>
							<xsl:element name="a">
								<xsl:attribute name="href"><xsl:value-of select="$fichaPDI/ehu:curriculum/ehu:documento/ehu:enlace"/></xsl:attribute>
								<xsl:value-of select="languageUtil:get($locale,'upv-ehu.masters.pdi.cv')"/>
							</xsl:element>
						</xsl:element>
		            </xsl:element>
				</xsl:if>
				
			</xsl:element>
		</xsl:element>
	</xsl:template>
	
	
	<!-- ECTS -->
	<xsl:template name="ects">
		<abbr>
			<xsl:attribute name="title">
				<xsl:value-of select="languageUtil:get($locale,'ehu.title.ects')"/>
			</xsl:attribute>
			<xsl:value-of select="languageUtil:get($locale,'ehu.abbr.ects')" />
		</abbr>
	</xsl:template>
	
	
	
	<!-- Valor o dos guinoes -->
	<xsl:template name="valor-guiones">
		<xsl:param name="valor" />
		
		<xsl:if test="$valor=0 ">
			<xsl:value-of select="$guide" /><xsl:value-of select="$guide" />
		</xsl:if>
		<xsl:if test="not($valor=0) ">
			<xsl:value-of select="format-number($valor, '###.###,#','european')" />
		</xsl:if>
	</xsl:template>
	
	
	<!-- Encabezados p string -->
	<xsl:template name="encabezadosPStrong">
		<xsl:param name="textoValor" />
		<xsl:element name="p">
			<xsl:element name="strong">
				<xsl:value-of select="$textoValor" />
			</xsl:element>
		</xsl:element>
	</xsl:template>
	
	
	<xsl:template name="capitalize">
        <!-- Capitalize all the letters in a string -->
        <xsl:param name="s"/>
        <xsl:value-of select="translate($s, $lower, $upper)"/>
    </xsl:template>

    <xsl:template name="cap-first">
        <!-- Capitalize the first letter in a string -->
        <xsl:param name="s"/>
        
	      <xsl:call-template name="CamelCaseWord">
	        <xsl:with-param name="text" select="$s"/>
	      </xsl:call-template>
	 
    </xsl:template>
	
	
	
	<xsl:template name="CamelCase">
	  <xsl:param name="text"/>
	  
	  <xsl:choose>
	    <xsl:when test="contains($text,' ')">
	    	<xsl:call-template name="CamelCaseSplitter">
	        	<xsl:with-param name="text" select="$text"/>
	        	<xsl:with-param name="delimiter" select="' '" />
	      	</xsl:call-template>
	    </xsl:when>
	    
	    <xsl:when test="contains($text,'-')">
	    	<xsl:call-template name="CamelCaseSplitter">
	        	<xsl:with-param name="text" select="$text"/>
	        	<xsl:with-param name="delimiter" select="'-'" />
	      	</xsl:call-template>
	    </xsl:when>

	    <xsl:when test="contains($text,',')">
	    	<xsl:call-template name="CamelCaseSplitter">
	        	<xsl:with-param name="text" select="$text"/>
	        	<xsl:with-param name="delimiter" select="','" />
	      	</xsl:call-template>
	    </xsl:when>
	    
	    <xsl:otherwise>
	      <xsl:call-template name="CamelCaseWord">
	        <xsl:with-param name="text" select="$text"/>
	      </xsl:call-template>
	    </xsl:otherwise>
	  </xsl:choose>
	</xsl:template>
		
	<xsl:template name="CamelCaseWord">
	  <xsl:param name="text"/>
	  <xsl:value-of select="translate(substring($text,1,1),'abcdefghijklmnñopqrstuvwxyz','ABCDEFGHIJKLMNÑOPQRSTUVWXYZ')" /><xsl:value-of select="translate(substring($text,2,string-length($text)-1),'ABCDEFGHIJKLMNÑOPQRSTUVWXYZ','abcdefghijklmnñopqrstuvwxyz')" />
	</xsl:template>
	
	<xsl:template name="CamelCaseSplitter">
		<xsl:param name="text"/>
		<xsl:param name="delimiter"/>
		
	    <xsl:call-template name="CamelCase">
        	<xsl:with-param name="text" select="substring-before($text, $delimiter)"/>
      	</xsl:call-template>
      	<xsl:value-of select="$delimiter" />
      	<xsl:call-template name="CamelCase">
        	<xsl:with-param name="text" select="substring-after($text, $delimiter)"/>
      	</xsl:call-template>
	</xsl:template>

	<xsl:template name="transform_text">
	  <xsl:param name="text"/>
	  <xsl:variable name="carriage_return"><xsl:text>&#xd;</xsl:text></xsl:variable>
	  <xsl:variable name="end_of_line"><xsl:text>&#xa;</xsl:text></xsl:variable>
	  	    
	  <xsl:choose>
	  	<!-- 2021-03-18 - Edorta - Lagun 595369 - Trello 391 y 409 -->
	    <!-- Detectar y convertir enlaces en hrefs -->	   
	    
	    <!-- HTTPS -->
	    <xsl:when test="contains($text, 'https://')">
	    	
	    	<xsl:variable name="substringLink" select="substring-after($text, 'https://')" />
   			<xsl:variable name="link" select="substring-before($substringLink, ' ')" />
   			<xsl:variable name="fullLink" select="concat('https://', $link)" />
   			<xsl:variable name="fullLink2" select="concat('https://', $substringLink)" />
   			 
   			
   			<xsl:choose>
   				
   				<!-- Caso especial terminación en ').' -->
   				<xsl:when test="substring($fullLink, string-length($fullLink) - 1, 2) = ').'" >     					
   					<xsl:value-of select="substring-before($text, $fullLink)" disable-output-escaping="yes" />
   					<a>
					   	<xsl:attribute name="href">
					   		<!-- Eliminamos ese último carácter -->
				      		<xsl:value-of select="substring($fullLink, 1, string-length($fullLink) - 2)"/>	
				      				        
					   	</xsl:attribute>
					   	<!-- Eliminamos ese último carácter -->
					   	<xsl:value-of select="substring($fullLink, 1, string-length($fullLink) - 2)"/>

					</a>). <!-- concatenamos los carácteres antes "eliminados" -->				

					<xsl:call-template name="transform_text">
       					<!-- Le volvemos a añadir el carácter especial eliminado para pintarlo fuera del link -->
       					<xsl:with-param name="text" select="substring-after($text, $fullLink)"/>   
     					</xsl:call-template>
   				</xsl:when>
   				
   				<!-- Si hay un carácter especial pegado al link ( '.' ',' ';' ':' ')' ) -->
   				 
   				<xsl:when test="substring($fullLink, string-length($fullLink), 1) = '.'" >   
   					<xsl:value-of select="substring-before($text, $fullLink)" disable-output-escaping="yes" />
   					<a>
					   	<xsl:attribute name="href">
					   		<!-- Eliminamos ese último carácter -->
				      		<xsl:value-of select="substring($fullLink, 1, string-length($fullLink) - 1)"/>	
				      				        
					   	</xsl:attribute>
					   	<!-- Eliminamos ese último carácter -->
					   	<xsl:value-of select="substring($fullLink, 1, string-length($fullLink) - 1)"/>
					</a> 
					<xsl:call-template name="transform_text">
       					<!-- Le volvemos a añadir el carácter especial eliminado para pintarlo fuera del link -->
       					<xsl:with-param name="text" select="concat('.', substring-after($text, $fullLink) )"/>   
     					</xsl:call-template>
   				</xsl:when> 
   				
   				<xsl:when test="substring($fullLink, string-length($fullLink), 1) = ','" >   				
   					<xsl:value-of select="substring-before($text, $fullLink)" disable-output-escaping="yes" />
   					<a>
					   	<xsl:attribute name="href">
					   		<!-- Eliminamos ese último carácter -->
				      		<xsl:value-of select="substring($fullLink, 1, string-length($fullLink) - 1)"/>	
				      				        
					   	</xsl:attribute>
					   	<!-- Eliminamos ese último carácter -->
					   	<xsl:value-of select="substring($fullLink, 1, string-length($fullLink) - 1)"/>
					</a> 
					<xsl:call-template name="transform_text">
						<!-- Le volvemos a añadir el carácter especial eliminado para pintarlo fuera del link -->
       					<xsl:with-param name="text" select="concat(',', substring-after($text, $fullLink) )"/>       					
     					</xsl:call-template>
   				</xsl:when> 
   				
   				<xsl:when test="substring($fullLink, string-length($fullLink), 1) = ';'" >   				
   					<xsl:value-of select="substring-before($text, $fullLink)" disable-output-escaping="yes" />
   					<a>
					   	<xsl:attribute name="href">
					   		<!-- Eliminamos ese último carácter -->
				      		<xsl:value-of select="substring($fullLink, 1, string-length($fullLink) - 1)"/>	
				      				        
					   	</xsl:attribute>
					   	<!-- Eliminamos ese último carácter -->
					   	<xsl:value-of select="substring($fullLink, 1, string-length($fullLink) - 1)"/>
					</a> 
					<xsl:call-template name="transform_text">
       					<!-- Le volvemos a añadir el carácter especial eliminado para pintarlo fuera del link -->
       					<xsl:with-param name="text" select="concat(';', substring-after($text, $fullLink) )"/>   
     					</xsl:call-template>
   				</xsl:when> 
   				
   				<xsl:when test="substring($fullLink, string-length($fullLink), 1) = ':'" >   				
   					<xsl:value-of select="substring-before($text, $fullLink)" disable-output-escaping="yes" />
   					<a>
					   	<xsl:attribute name="href">
					   		<!-- Eliminamos ese último carácter -->
				      		<xsl:value-of select="substring($fullLink, 1, string-length($fullLink) - 1)"/>	
				      				        
					   	</xsl:attribute>
					   	<!-- Eliminamos ese último carácter -->
					   	<xsl:value-of select="substring($fullLink, 1, string-length($fullLink) - 1)"/>
					</a> 
					<xsl:call-template name="transform_text">
       					<!-- Le volvemos a añadir el carácter especial eliminado para pintarlo fuera del link -->
       					<xsl:with-param name="text" select="concat(':', substring-after($text, $fullLink) )"/>   
     					</xsl:call-template>
   				</xsl:when> 
   				
   				<xsl:when test="substring($fullLink, string-length($fullLink), 1) = ')'" >   				
   					<xsl:value-of select="substring-before($text, $fullLink)" disable-output-escaping="yes" />
   					<a>
					   	<xsl:attribute name="href">
					   		<!-- Eliminamos ese último carácter -->
				      		<xsl:value-of select="substring($fullLink, 1, string-length($fullLink) - 1)"/>	
				      				        
					   	</xsl:attribute>
					   	<!-- Eliminamos ese último carácter -->
					   	<xsl:value-of select="substring($fullLink, 1, string-length($fullLink) - 1)"/>
					</a> 
					<xsl:call-template name="transform_text">
       					<!-- Le volvemos a añadir el carácter especial eliminado para pintarlo fuera del link -->
       					<xsl:with-param name="text" select="concat(')', substring-after($text, $fullLink) )"/>   
     					</xsl:call-template>
   				</xsl:when> 
   				
   						
   				<!-- Si viene pegado un <br /> por detrás del link -->
   				<xsl:when test="contains($fullLink, '&lt;br')" >
   					<xsl:value-of select="substring-before($text, $fullLink)" disable-output-escaping="yes" />
   					<a>
						<xsl:attribute name="href">
					    <!-- Hacemos el -3 porque los BRs llegan con espacio en blanco "<br />" -->
					    	<xsl:value-of select="substring($fullLink, 1, string-length($fullLink) - 3)"/>	
					    			      
					    </xsl:attribute>
					    <xsl:value-of select="substring($fullLink, 1, string-length($fullLink) - 3)"/>
					</a>	
					<!-- Pintamos lo que hay después del link, incluyendo los 3 últimos caracteres del link "<br" -->
					<xsl:call-template name="transform_text">
	        			<xsl:with-param name="text" select="substring-after($text, substring($fullLink, 1, string-length($fullLink) - 3))"/>
	      			</xsl:call-template>
   				</xsl:when>
   				
   				
   				<!-- Fin del texto -->
   				<xsl:when test="$fullLink = 'https://'">
   					<!-- Fin de text -->
 						<xsl:value-of select="substring-before($text, $fullLink)" disable-output-escaping="yes" />   					
	   					 <a>
						    <xsl:attribute name="href">
						    	<xsl:value-of select="$fullLink2"/>			        
						    </xsl:attribute>
						    <xsl:value-of select="$fullLink2"/>
						</a>    
   				</xsl:when>
   				
   				<!-- Si hay un espacio en blanco detrás del link -->
   				<xsl:when test="contains($text, concat(' ', $fullLink))" >  
   					<xsl:value-of select="substring-before($text, $fullLink)" disable-output-escaping="yes" />
   					<a>
					   	<xsl:attribute name="href">
				      		<xsl:value-of select="$fullLink"/>			        
					   	</xsl:attribute>
					   	<xsl:value-of select="$fullLink"/>
					</a> 
					<xsl:call-template name="transform_text">
       					<xsl:with-param name="text" select="substring-after($text, $fullLink)"/>
     					</xsl:call-template>
   				</xsl:when>  
   					
   				<xsl:otherwise>
   					<xsl:value-of select="substring-before($text, $fullLink)" disable-output-escaping="yes" />   					
   					<a>
						<xsl:attribute name="href">
					   		<xsl:value-of select="$fullLink2"/>			        
					    </xsl:attribute>
					    <xsl:value-of select="$fullLink2"/>
					</a>    						   								 
   				</xsl:otherwise>
   				
   			</xsl:choose>   
   						
	    </xsl:when> <!-- Fin HTTPS -->
	    
	    <!-- HTTP -->
	    <xsl:when test="contains($text, 'http://')">
	    	
	    	<xsl:variable name="substringLink" select="substring-after($text, 'http://')" />
   			<xsl:variable name="link" select="substring-before($substringLink, ' ')" />
   			<xsl:variable name="fullLink" select="concat('http://', $link)" />
   			<xsl:variable name="fullLink2" select="concat('http://', $substringLink)" />
   			
   			<xsl:choose>
   				
   				<!-- Caso especial terminación en ').' -->
   				<xsl:when test="substring($fullLink, string-length($fullLink) - 1, 2) = ').'" >  
   					<xsl:value-of select="substring-before($text, $fullLink)" disable-output-escaping="yes" />
   					<a>
					   	<xsl:attribute name="href">
					   		<!-- Eliminamos los últimos dos carácteres -->
				      		<xsl:value-of select="substring($fullLink, 1, string-length($fullLink) - 2)"/>	
				      				        
					   	</xsl:attribute>
					   	<!-- Eliminamos los últimos dos carácteres -->
					   	<xsl:value-of select="substring($fullLink, 1, string-length($fullLink) - 2)"/>
					</a>). <!-- concatenamos los carácteres antes "eliminados" -->
					
					<xsl:call-template name="transform_text">
       					 <xsl:with-param name="text" select="substring-after($text, $fullLink)"/>
     				</xsl:call-template>
   				</xsl:when>
   				
   				<!-- Si hay un carácter especial pegado al link ( '.' ',' ';' ':' ')' ) -->
   				 
   				<xsl:when test="substring($fullLink, string-length($fullLink), 1) = '.'" > 
   					<xsl:value-of select="substring-before($text, $fullLink)" disable-output-escaping="yes" />
   					<a>
					   	<xsl:attribute name="href">
					   		<!-- Eliminamos ese último carácter -->
				      		<xsl:value-of select="substring($fullLink, 1, string-length($fullLink) - 1)"/>	
				      				        
					   	</xsl:attribute>
					   	<!-- Eliminamos ese último carácter -->
					   	<xsl:value-of select="substring($fullLink, 1, string-length($fullLink) - 1)"/>
					</a> 
					<xsl:call-template name="transform_text">
       					<!-- Le volvemos a añadir el carácter especial eliminado para pintarlo fuera del link -->
       					<xsl:with-param name="text" select="concat('.', substring-after($text, $fullLink) )"/>   
     					</xsl:call-template>
   				</xsl:when> 
   				
   				<xsl:when test="substring($fullLink, string-length($fullLink), 1) = ','" >   
   					<xsl:value-of select="substring-before($text, $fullLink)" disable-output-escaping="yes" />
   					<a>
					   	<xsl:attribute name="href">
					   		<!-- Eliminamos ese último carácter -->
				      		<xsl:value-of select="substring($fullLink, 1, string-length($fullLink) - 1)"/>	
				      				        
					   	</xsl:attribute>
					   	<!-- Eliminamos ese último carácter -->
					   	<xsl:value-of select="substring($fullLink, 1, string-length($fullLink) - 1)"/>
					</a> 
					<xsl:call-template name="transform_text">
						<!-- Le volvemos a añadir el carácter especial eliminado para pintarlo fuera del link -->
       					<xsl:with-param name="text" select="concat(',', substring-after($text, $fullLink) )"/>       					
     					</xsl:call-template>
   				</xsl:when> 
   				
   				<xsl:when test="substring($fullLink, string-length($fullLink), 1) = ';'" >   				
   					<xsl:value-of select="substring-before($text, $fullLink)" disable-output-escaping="yes" />
   					<a>
					   	<xsl:attribute name="href">
					   		<!-- Eliminamos ese último carácter -->
				      		<xsl:value-of select="substring($fullLink, 1, string-length($fullLink) - 1)"/>	
				      				        
					   	</xsl:attribute>
					   	<!-- Eliminamos ese último carácter -->
					   	<xsl:value-of select="substring($fullLink, 1, string-length($fullLink) - 1)"/>
					</a> 
					<xsl:call-template name="transform_text">
       					<!-- Le volvemos a añadir el carácter especial eliminado para pintarlo fuera del link -->
       					<xsl:with-param name="text" select="concat(';', substring-after($text, $fullLink) )"/>   
     					</xsl:call-template>
   				</xsl:when> 
   				
   				<xsl:when test="substring($fullLink, string-length($fullLink), 1) = ':'" >   				
   					<xsl:value-of select="substring-before($text, $fullLink)" disable-output-escaping="yes" />
   					<a>
					   	<xsl:attribute name="href">
					   		<!-- Eliminamos ese último carácter -->
				      		<xsl:value-of select="substring($fullLink, 1, string-length($fullLink) - 1)"/>	
				      				        
					   	</xsl:attribute>
					   	<!-- Eliminamos ese último carácter -->
					   	<xsl:value-of select="substring($fullLink, 1, string-length($fullLink) - 1)"/>
					</a> 
					<xsl:call-template name="transform_text">
       					<!-- Le volvemos a añadir el carácter especial eliminado para pintarlo fuera del link -->
       					<xsl:with-param name="text" select="concat(':', substring-after($text, $fullLink) )"/>   
     					</xsl:call-template>
   				</xsl:when> 
   				
   				<xsl:when test="substring($fullLink, string-length($fullLink), 1) = ')'" >   
   					<xsl:value-of select="substring-before($text, $fullLink)" disable-output-escaping="yes" />
   					<a>
					   	<xsl:attribute name="href">
					   		<!-- Eliminamos ese último carácter -->
				      		<xsl:value-of select="substring($fullLink, 1, string-length($fullLink) - 1)"/>	
				      				        
					   	</xsl:attribute>
					   	<!-- Eliminamos ese último carácter -->
					   	<xsl:value-of select="substring($fullLink, 1, string-length($fullLink) - 1)"/>
					</a> 
					<xsl:call-template name="transform_text">
       					<!-- Le volvemos a añadir el carácter especial eliminado para pintarlo fuera del link -->
       					<xsl:with-param name="text" select="concat(')', substring-after($text, $fullLink) )"/>   
     					</xsl:call-template>
   				</xsl:when> 
   				
   						
   				<!-- Si viene pegado un <br /> por detrás del link -->
   				<xsl:when test="contains($fullLink, '&lt;br')" >
   					<xsl:value-of select="substring-before($text, $fullLink)" disable-output-escaping="yes" />
   					<a>
						<xsl:attribute name="href">
					    <!-- Hacemos el -3 porque los BRs llegan con espacio en blanco "<br />" -->
					    	<xsl:value-of select="substring($fullLink, 1, string-length($fullLink) - 3)"/>	
					    			      
					    </xsl:attribute>
					    <xsl:value-of select="substring($fullLink, 1, string-length($fullLink) - 3)"/>
					</a>	
					<!-- Pintamos lo que hay después del link, incluyendo los 3 últimos caracteres del link "<br" -->
					<xsl:call-template name="transform_text">
	        			<xsl:with-param name="text" select="substring-after($text, substring($fullLink, 1, string-length($fullLink) - 3))"/>
	      			</xsl:call-template>
   				</xsl:when>
   				
   				
   				<!-- Fin del texto -->
   				<xsl:when test="$fullLink = 'https://'">
   					<!-- Fin de text -->
 						<xsl:value-of select="substring-before($text, $fullLink)" disable-output-escaping="yes" />   					
	   					 <a>
						    <xsl:attribute name="href">
						    	<xsl:value-of select="$fullLink2"/>			        
						    </xsl:attribute>
						    <xsl:value-of select="$fullLink2"/>
						</a>    
   				</xsl:when>
   				
   				<!-- Si hay un espacio en blanco detrás del link -->
   				<xsl:when test="contains($text, concat(' ', $fullLink))" >  
   					<xsl:value-of select="substring-before($text, $fullLink)" disable-output-escaping="yes" />
   					<a>
					   	<xsl:attribute name="href">
				      		<xsl:value-of select="$fullLink"/>			        
					   	</xsl:attribute>
					   	<xsl:value-of select="$fullLink"/>
					</a> 
					<xsl:call-template name="transform_text">
       					<xsl:with-param name="text" select="substring-after($text, $fullLink)"/>
     					</xsl:call-template>
   				</xsl:when>  
   					
   				<xsl:otherwise>
   					<xsl:value-of select="substring-before($text, $fullLink)" disable-output-escaping="yes" />   					
   					<a>
						<xsl:attribute name="href">
					   		<xsl:value-of select="$fullLink2"/>			        
					    </xsl:attribute>
					    <xsl:value-of select="$fullLink2"/>
					</a>    						   								 
   				</xsl:otherwise>
   				
   			</xsl:choose>   
   						
	    </xsl:when> <!-- Fin HTTP -->
	      
	  		     
	    <xsl:when test="contains($text, $carriage_return)">	    	
	    	<!-- <p>  -->
    			<xsl:value-of select="substring-before($text, $carriage_return)" disable-output-escaping="yes" />
    		<!-- </p> -->	
	      	<xsl:call-template name="transform_text">
	        	<xsl:with-param name="text" select="substring-after($text, $carriage_return)"/>
	      	</xsl:call-template>
	    </xsl:when>
	    <xsl:when test="contains($text, $end_of_line)">
	    	<!-- <p>  -->
    			<xsl:value-of select="substring-before($text, $end_of_line)" disable-output-escaping="yes" />
    		<!-- </p> -->	
	      	<xsl:call-template name="transform_text">
	        	<xsl:with-param name="text" select="substring-after($text, $end_of_line)"/>
	      	</xsl:call-template>
	    </xsl:when>
	    
	    	    	    
	    
	    <xsl:otherwise>
	    	
	    	<xsl:if test="$text != $void">
		    	<xsl:value-of select="$text" disable-output-escaping="yes" />
	    	</xsl:if>
	    </xsl:otherwise>
	   
	  </xsl:choose>	 
	  
	</xsl:template>	
	
</xsl:stylesheet>