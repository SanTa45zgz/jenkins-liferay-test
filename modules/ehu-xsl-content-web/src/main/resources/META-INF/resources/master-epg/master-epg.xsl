<?xml version="1.0" encoding="UTF-8"?>
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
	<xsl:include href="http://localhost:8080/o/ehu-xsl-content-web/master-epg/master-epg-templates.xsl"/>
	
	<xsl:variable name="p_idp" select="ehu:app/ehu:parameters/ehu:parameter[@name='p_idp']"/>
	<xsl:variable name="p_cod_asignatura" select="ehu:app/ehu:parameters/ehu:parameter[@name='p_cod_asignatura']"/>
	<xsl:variable name="p_cod_materia" select="ehu:app/ehu:parameters/ehu:parameter[@name='p_cod_materia']"/>
	<xsl:variable name="p_cod_master" select="ehu:app/ehu:parameters/ehu:parameter[@name='p_cod_master']"/>
	<xsl:variable name="p_anyo_acad" select="ehu:app/ehu:parameters/ehu:parameter[@name='p_anyo_acad']"/>
	<xsl:variable name="error" select="ehu:app/ehu:error"/>
	
	<xsl:template match="/">
		<xsl:choose>
			<!-- Si hay error devuelto del servicio, lo muestra -->
			<xsl:when test="$error">
				<xsl:element name="p">
					<xsl:attribute name="class">portlet-msg-error</xsl:attribute>
					<xsl:value-of select="$error"/>
				</xsl:element>
			</xsl:when>
			
			<xsl:otherwise>
				<!-- Redirección a Fichero -->
				<xsl:if test="ehu:app/ehu:fichero">
					<script>window.location.href='<xsl:value-of select="ehu:app/ehu:fichero/ehu:ruta"/>';</script>
				</xsl:if>
				
				<!-- Selección de Plantilla en base a configuración y parámetros -->
				<xsl:choose>
					<xsl:when test="$p_nav = '1001'">
						<xsl:call-template name="presentacion"/>
					</xsl:when>
					<xsl:when test="$p_nav = '1002'">
						<xsl:call-template name="perfilAcceso"/>
					</xsl:when>
					<xsl:when test="$p_nav = '1003'">
			       		<xsl:call-template name="programaFormativo"/>
					</xsl:when>
					<xsl:when test="$p_nav = '1004'">
						<xsl:choose>
							<xsl:when test="$p_idp and $p_cod_master">
								<xsl:call-template name="vistaProfesorAjeno">
							    	<xsl:with-param name="urlBack">./<xsl:value-of select="languageUtil:get($locale,'upv-ehu.masters.url.training-syllabus')"/></xsl:with-param>
								</xsl:call-template>
							</xsl:when>
							<xsl:when test="$p_idp and $p_anyo_acad">
					       		<xsl:call-template name="vistaProfesor">
									<xsl:with-param name="urlBack">./<xsl:value-of select="languageUtil:get($locale,'upv-ehu.masters.url.training-syllabus')"/></xsl:with-param>
								</xsl:call-template>
					    	</xsl:when>
					    	<xsl:when test="$p_idp">
					    		<xsl:call-template name="fichaPDI">
									<xsl:with-param name="urlBack">./<xsl:value-of select="languageUtil:get($locale,'upv-ehu.masters.url.training-syllabus')"/></xsl:with-param>
								</xsl:call-template>
							</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="vistaAsignatura">
									<xsl:with-param name="urlBack">./<xsl:value-of select="languageUtil:get($locale,'upv-ehu.masters.url.training-syllabus')"/></xsl:with-param>
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="$p_nav = '1005'">
						<xsl:call-template name="metodologiaYevaluacion"/>
					</xsl:when>
					<xsl:when test="$p_nav = '1006'">
						<xsl:call-template name="descripcionTFM"/>
					</xsl:when>
					<xsl:when test="$p_nav = '1007'">
						<xsl:choose>
							<xsl:when test="$p_idp and $p_cod_master">
								<xsl:call-template name="vistaProfesorAjeno">
							    	<xsl:with-param name="urlBack">javascript:window.location.replace(location.pathname);</xsl:with-param>
								</xsl:call-template>
							</xsl:when>
							<xsl:when test="$p_idp and $p_anyo_acad">
					       		<xsl:call-template name="vistaProfesor">
							    	<xsl:with-param name="urlBack">javascript:window.location.replace(location.pathname);</xsl:with-param>
								</xsl:call-template>
					    	</xsl:when>
					    	<xsl:when test="$p_idp">
					       		<xsl:call-template name="fichaPDI">
							    	<xsl:with-param name="urlBack">javascript:window.location.replace(location.pathname);</xsl:with-param>
								</xsl:call-template>
					    	</xsl:when>
						    <xsl:otherwise>
						    	<xsl:call-template name="listaProfesorado"/>
					     	</xsl:otherwise>
				   		</xsl:choose>
					</xsl:when>
					<xsl:when test="$p_nav = '1008'">
						<xsl:choose>
							<xsl:when test="$p_idp and $p_cod_master">
								<xsl:call-template name="vistaProfesorAjeno">
							    	<xsl:with-param name="urlBack">javascript:window.location.replace(location.pathname);</xsl:with-param>
								</xsl:call-template>
							</xsl:when>
							<xsl:when test="$p_idp and $p_anyo_acad">
					       		<xsl:call-template name="vistaProfesor">
							    	<xsl:with-param name="urlBack">javascript:window.location.replace(location.pathname);</xsl:with-param>
								</xsl:call-template>
					    	</xsl:when>
					    	<xsl:when test="$p_idp">
					       		<xsl:call-template name="fichaPDI">
							    	<xsl:with-param name="urlBack">javascript:window.location.replace(location.pathname);</xsl:with-param>
								</xsl:call-template>
					    	</xsl:when>
						    <xsl:otherwise>
						    	<xsl:call-template name="listaProfesoradoTFM"/>
					     	</xsl:otherwise>
				   		</xsl:choose>
					</xsl:when>
					<xsl:when test="$p_nav = '1009'">
						<xsl:call-template name="entidadesColaboradoras"/>
					</xsl:when>
					<xsl:when test="$p_nav = '1010'">
						<xsl:call-template name="responsableMaster"/>
					</xsl:when>
					<xsl:when test="$p_nav = '1011'">
						<xsl:call-template name="calendarioDocumentos"/>
					</xsl:when>
					<xsl:when test="$p_nav = '1012'">
						<xsl:call-template name="recursosMaster"/>					
					</xsl:when>
					<xsl:when test="$p_nav = '1013'">
						<xsl:call-template name="piePagina"/>					
					</xsl:when>
					<xsl:when test="$p_nav = '1014'">
						<xsl:call-template name="competencias"/>					
					</xsl:when>
					<xsl:when test="$p_nav = '1015'">
						<xsl:call-template name="lineasDeInvestigacion"/>					
					</xsl:when>
					<xsl:when test="$p_nav = '1016'">
						<xsl:call-template name="presentacionMFPS"/>					
					</xsl:when>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>