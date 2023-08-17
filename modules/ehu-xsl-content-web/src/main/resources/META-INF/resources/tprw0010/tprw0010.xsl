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
		
		<!-- Datos generales del titulo propio -->
		<xsl:variable name="degree_title" select="ehu:app/ehu:programas/ehu:programa/ehu:descPrograma"/>
		<xsl:variable name="degree_type" select="ehu:app/ehu:programas/ehu:programa/ehu:descTipoTitulo"/>
		<xsl:variable name="degree_capacity_min" select="ehu:app/ehu:programas/ehu:programa/ehu:minAlumAdmitidos"/>
		<xsl:variable name="degree_capacity_max" select="ehu:app/ehu:programas/ehu:programa/ehu:maxAlumAdmitidos"/>
		<xsl:variable name="degree_credits" select="ehu:app/ehu:programas/ehu:programa/ehu:numCreditos"/>
		<xsl:variable name="degree_price" select="ehu:app/ehu:programas/ehu:programa/ehu:precioCredito"/>
		<xsl:variable name="degree_init_date" select="ehu:app/ehu:programas/ehu:programa/ehu:fecIniImparticion"/>
		<xsl:variable name="degree_end_date" select="ehu:app/ehu:programas/ehu:programa/ehu:fecFinImparticion"/>		
		
		<!-- Plan de estudios -->
		<xsl:variable name="degree_academic_year" select="ehu:app/ehu:programas/ehu:programa/ehu:descAnyoAcad"/>
		<xsl:variable name="degree_anyoAcad" select="ehu:app/ehu:programas/ehu:programa/ehu:anyoAcad"/>
		<xsl:variable name="degree_study_plan" select="ehu:app/ehu:programas/ehu:programa/ehu:cursos"/>
		
		<!-- Organizacion -->
		<xsl:variable name="degree_organizations" select="ehu:app/ehu:programas/ehu:programa/ehu:proponentes"/>
		<xsl:variable name="degree_responsibles" select="ehu:app/ehu:programas/ehu:programa/ehu:responsables"/>
				
		<!-- Acceso -->
		<xsl:variable name="degree_requirements" select="ehu:app/ehu:programas/ehu:programa/ehu:requisitosAdmision"/>
		
		<!-- Datos de localizacion -->
		<xsl:variable name="degree_location" select="ehu:app/ehu:programas/ehu:programa/ehu:lugarImparticion"/>		
		
		<!-- Datos de contacto -->
		<xsl:variable name="degree_contact_location" select="ehu:app/ehu:programas/ehu:programa/ehu:oficinaInf"/>
		<xsl:variable name="degree_contact" select="ehu:app/ehu:programas/ehu:programa/ehu:oficinaInf/ehu:contacto"/>
		
		<xsl:template match="/">
		
			<div>
				<xsl:attribute name="class">upv-ehu-template xsl-content studies</xsl:attribute>
				
				<xsl:choose>
					<xsl:when test="$p_nav = '1'">
						<xsl:call-template name="header">
							<xsl:with-param name="title" select="$degree_title"/>
						</xsl:call-template>
						<xsl:call-template name="summary">
							<xsl:with-param name="type" select="$degree_type"/>
							<xsl:with-param name="credits" select="$degree_credits"/>
							<xsl:with-param name="price" select="$degree_price"/>							
						</xsl:call-template>	
					</xsl:when>
					<xsl:when test="$p_nav = '2'">
						<xsl:call-template name="header">
							<xsl:with-param name="title" select="languageUtil:get($locale,'ehu.study-plan')"/>							
						</xsl:call-template>
						<xsl:call-template name="study-plan">
							<xsl:with-param name="academic-year" select="$degree_academic_year"/>
							<xsl:with-param name="study-plan" select="$degree_study_plan"/>
							<xsl:with-param name="anyoAcad" select="$degree_anyoAcad"/>
							
						</xsl:call-template>						
					</xsl:when>
					<xsl:when test="$p_nav = '3'">
						<xsl:call-template name="header">
							<xsl:with-param name="title" select="languageUtil:get($locale,'ehu.organization')"/>							
						</xsl:call-template>
						<xsl:call-template name="organization">
							<xsl:with-param name="organizations" select="$degree_organizations"/>
							<xsl:with-param name="responsibles" select="$degree_responsibles"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$p_nav = '4'">
						<xsl:call-template name="header">
							<xsl:with-param name="title" select="languageUtil:get($locale,'ehu.access')"/>							
						</xsl:call-template>
						<xsl:call-template name="access">
							<xsl:with-param name="capacity_min" select="$degree_capacity_min"/>
							<xsl:with-param name="capacity_max" select="$degree_capacity_max"/>
							<xsl:with-param name="requirements" select="$degree_requirements"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$p_nav = '5'">
						<xsl:call-template name="header">
							<xsl:with-param name="title" select="languageUtil:get($locale,'ehu.location-and-dates')"/>							
						</xsl:call-template>
						<xsl:call-template name="place">
							<xsl:with-param name="location" select="$degree_location"/>
						</xsl:call-template>							
						<xsl:call-template name="dates">
							<xsl:with-param name="init_date" select="$degree_init_date"/>
							<xsl:with-param name="end_date" select="$degree_end_date"/>
						</xsl:call-template>	
					</xsl:when>
					<xsl:when test="$p_nav = '6'">
						<xsl:call-template name="header">
							<xsl:with-param name="title" select="languageUtil:get($locale,'ehu.contact-data')"/>							
						</xsl:call-template>
						<xsl:call-template name="place">
							<xsl:with-param name="location" select="$degree_contact_location"/>												
						</xsl:call-template>
						<xsl:call-template name="contact">
							<xsl:with-param name="contact" select="$degree_contact"/>												
						</xsl:call-template>						
					</xsl:when>
					<xsl:otherwise>						
						<xsl:call-template name="xml_error"/>						
					</xsl:otherwise>
				</xsl:choose>												
			</div>
			
		</xsl:template>		

	</xsl:stylesheet>