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
	<xsl:include href="http://localhost:8080/o/ehu-xsl-content-web/master-own-module/master-own-module-templates.xsl"/>
	
	<xsl:variable name="p_cod_master" select="ehu:app/ehu:parameters/ehu:parameter[@name='p_cod_programa']"/>
	<xsl:variable name="p_cod_curso" select="ehu:app/ehu:parameters/ehu:parameter[@name='p_cod_curso']"/>
	<xsl:variable name="p_cod_programa" select="ehu:app/ehu:parameters/ehu:parameter[@name='p_cod_programa']"/>
	<!-- Definido en el common.xsl 
	<xsl:variable name="p_cod_proceso" select="ehu:app/ehu:parameters/ehu:parameter[@name='p_cod_proceso']"/>
	-->
	<xsl:variable name="p_idp" select="ehu:app/ehu:parameters/ehu:parameter[@name='p_idp']"/>

	<xsl:variable name="error" select="ehu:app/ehu:error"/>
	
	<xsl:template match="/">
		<article namespace="xmlns:ehu">
			<xsl:choose>
				<!-- Si hay error devuelto del servicio, lo muestra -->
				<xsl:when test="$error">
					<xsl:element name="p">
						<xsl:attribute name="class">portlet-msg-error</xsl:attribute>
						<xsl:value-of select="$error"/>
					</xsl:element>
				</xsl:when>
				
				<xsl:otherwise>
					<!-- Selección de Plantilla en base a configuración y parámetros -->
					<xsl:choose>
						<xsl:when test="$p_nav = '301'">
							<xsl:call-template name="presentacion"/>
						</xsl:when>
						<xsl:when test="$p_nav = '302'">
							<xsl:choose>
								<xsl:when test="$p_cod_curso != ''">
									<xsl:call-template name="vistaAsignatura">
								    	<xsl:with-param name="urlBack">javascript:window.location.replace(location.pathname);</xsl:with-param>
									</xsl:call-template>
								</xsl:when>
								<xsl:otherwise>
						    		<xsl:call-template name="programa"/>
						    	</xsl:otherwise>
					    	</xsl:choose>
						</xsl:when>
						<xsl:when test="$p_nav = '304'">
							<xsl:call-template name="matricula"/>
						</xsl:when>
						<xsl:when test="$p_nav = '305'">
							<xsl:call-template name="piePagina"/>
						</xsl:when>
						<xsl:when test="$p_nav = '306'">
							<xsl:choose>
								<xsl:when test="$p_idp and $p_cod_proceso">
						       		<xsl:call-template name="vistaProfesorAjeno">
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
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</article>
	</xsl:template>
</xsl:stylesheet>