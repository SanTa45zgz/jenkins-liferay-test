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
	<xsl:include href="http://localhost:8080/o/ehu-xsl-content-web/doctorate/doctorate-templates.xsl"/>
	
	<xsl:variable name="p_cod_propuesta" select="ehu:app/ehu:parameters/ehu:parameter[@name='p_cod_propuesta']"/>
	<xsl:variable name="p_idp" select="ehu:app/ehu:parameters/ehu:parameter[@name='p_idp']"/>
	<!-- Definida en el common.xsl 
	<xsl:variable name="p_cod_proceso" select="ehu:app/ehu:parameters/ehu:parameter[@name='p_cod_proceso']"/>-->
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
					<xsl:when test="$p_nav = '600'">
						<xsl:call-template name="presentacion"/>
					</xsl:when>
					<xsl:when test="$p_nav = '601'">
						<xsl:call-template name="investigacion"/>
					</xsl:when>
					<xsl:when test="$p_nav = '602'">
						<xsl:call-template name="programaOrganizacion"/>
					</xsl:when>
					<xsl:when test="$p_nav = '603'">
						<xsl:call-template name="programaCompetencias"/>
					</xsl:when>
					<xsl:when test="$p_nav = '604'">
						<xsl:call-template name="programaActividades"/>
					</xsl:when>
					<xsl:when test="$p_nav = '605'">
						<xsl:choose>
							<xsl:when test="$p_idp and $p_cod_proceso">
								<xsl:call-template name="vistaProfesorAjeno">
							    	<xsl:with-param name="urlBack">javascript:window.location.replace(location.pathname);</xsl:with-param>
								</xsl:call-template>
							</xsl:when>
							<xsl:when test="$p_idp">
					       		<xsl:call-template name="fichaPDI">
							    	<xsl:with-param name="urlBack">javascript:window.location.replace(location.pathname);</xsl:with-param>
								</xsl:call-template>
					    	</xsl:when>
					    	<xsl:otherwise>
					    		<xsl:call-template name="profesorado"/>
					    	</xsl:otherwise>
				    	</xsl:choose>
					</xsl:when>
					<xsl:when test="$p_nav = '606'">
						<xsl:call-template name="matriculaPerfilAcceso"/>
					</xsl:when>
					<xsl:when test="$p_nav = '607'">
						<xsl:call-template name="matriculaProcedimiento"/>
					</xsl:when>
					<xsl:when test="$p_nav = '608'">
						<xsl:call-template name="tesisDefendida"/>
					</xsl:when>
					<xsl:when test="$p_nav = '609'">
						<xsl:call-template name="calidad"/>
					</xsl:when>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>