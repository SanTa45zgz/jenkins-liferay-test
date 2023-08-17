<?xml version="1.0"?>
	
	<xsl:stylesheet 
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
		xmlns:ehu="http://www.ehu.eus"
		xmlns:xalan="http://xml.apache.org/xalan"
		xmlns:languageUtil="xalan://com.liferay.portal.kernel.language.LanguageUtil"
		xmlns:localeUtil="xalan://com.liferay.portal.kernel.util.LocaleUtil"
		exclude-result-prefixes="xalan"
		extension-element-prefixes="languageUtil localeUtil xalan">
	
		<xsl:output method="xml" omit-xml-declaration="yes" />	
	
		<!-- Lenguage por defecto -->
		<xsl:variable name="default_language" select="'eu_ES'"/>
	
		<!-- Generacion de variable locale utilizada en las traducciones a partir del parametro de idioma -->
		<xsl:variable name="idioma" select="ehu:app/ehu:parameters/ehu:parameter[@name='idioma']"/>
		
		<xsl:variable name="localeStr"> 	
			<xsl:choose>
				<xsl:when test="$idioma = 'eu' or $idioma = 'EUS'">
					<xsl:value-of select="localeUtil:fromLanguageId('eu_ES')" />
				</xsl:when>
				<xsl:when test="$idioma = 'es' or $idioma = 'CAS'">
					<xsl:value-of select="localeUtil:fromLanguageId('es_ES')" />					
				</xsl:when>
				<xsl:when test="$idioma = 'en' or $idioma = 'ING'">
					<xsl:value-of select="localeUtil:fromLanguageId('en_GB')" />
				</xsl:when>
				<xsl:when test="$idioma = 'fr'">
					<xsl:value-of select="localeUtil:fromLanguageId('fr_FR')" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="localeUtil:fromLanguageId($default_language)" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="locale" select="localeUtil:fromLanguageId($localeStr)"/>
		
</xsl:stylesheet>