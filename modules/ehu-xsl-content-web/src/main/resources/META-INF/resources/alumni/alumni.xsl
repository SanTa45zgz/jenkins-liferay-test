<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xalan="http://xml.apache.org/xalan"
	xmlns:languageUtil="xalan://com.liferay.portal.kernel.language.LanguageUtil"
	xmlns:localeUtil="xalan://com.liferay.portal.kernel.util.LocaleUtil"
	exclude-result-prefixes="xalan"
	extension-element-prefixes="languageUtil localeUtil xalan">
	
	<xsl:output method="html" omit-xml-declaration="yes" />

	

	<xsl:variable name="localeStr" select="$localeAux"/>
	<xsl:variable name="locale" select="localeUtil:fromLanguageId($localeStr)"/>
	
	<xsl:variable name="cCodeOk"          >0</xsl:variable>
	<xsl:variable name="cCodeErrorNoInfo" >1</xsl:variable>
	<xsl:variable name="cCodeErrorCredits">2</xsl:variable>
	<xsl:variable name="cCodeErrorNoMatri">3</xsl:variable>

	<xsl:variable name="codeError"><xsl:value-of select="//resultCode"/></xsl:variable>
	<xsl:variable name="nCodeError"><xsl:value-of select="number($codeError)"/></xsl:variable>

	<xsl:template match="/">
		<div id="paginaXSL" class="alumni upv-ehu-template">
			<xsl:choose>
				<xsl:when test="$nCodeError != $cCodeOk">
					<xsl:call-template name="error"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="titulo"/>
					<xsl:apply-templates select="//datosPersonales"/>
					<xsl:call-template name="datosAcademicos"/>
				</xsl:otherwise>
			</xsl:choose>
		</div>	
	</xsl:template>
	
	<xsl:template name="datoAcademico">
		<xsl:variable name="datoAcad"><xsl:value-of select="."/></xsl:variable>
		<xsl:if test="$datoAcad != ''">
			<xsl:variable name="titulo">
				<xsl:choose>
					<xsl:when test="$localeStr = 'eu_ES'"><xsl:value-of select="tituloEus"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="tituloEs"/></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="tipo">
				<xsl:choose>
					<xsl:when test="$localeStr = 'eu_ES'"><xsl:value-of select="tipoEus"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="tipoEs"/></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="añoIniAux"><xsl:value-of select="substring(anyoInicio,1,4)"/></xsl:variable>
			<xsl:variable name="añoIni">
				<xsl:choose>
					<xsl:when test="number($añoIniAux) = 0">--</xsl:when>
					<xsl:otherwise><xsl:value-of select="$añoIniAux"/></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="añoFinAux"><xsl:value-of select="substring(anyoFin,1,4)"/></xsl:variable>
			<xsl:variable name="añoFin">
				<xsl:choose>
					<xsl:when test="number($añoFinAux) = 0">--</xsl:when>
					<xsl:otherwise><xsl:value-of select="$añoFinAux"/></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="descriCentro">
				<xsl:choose>
					<xsl:when test="$localeStr = 'eu_ES'"><xsl:value-of select="descripcionCentroEus"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="descripcionCentroEs"/></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<tr>
				<td><xsl:value-of select="$titulo"/></td>
				<td><xsl:value-of select="$tipo"/></td>
				<td><xsl:value-of select="$añoIni"/></td>
				<td><xsl:value-of select="$añoFin"/></td>
				<td><xsl:value-of select="$descriCentro"/></td>
			</tr>
		</xsl:if>
	</xsl:template>

	<xsl:template name="datosAcademicos">
		<section id="datos_academicos">
			<header class="info-section">
				<h2><xsl:value-of select="languageUtil:get( $locale, 'ehu.academic-data' )"/></h2>
			</header>
			<div class="content-section">
				<table class="tabla" id="t_datos_academicos">
					<xsl:attribute name="summary">
				 		<xsl:value-of select="languageUtil:get( $locale, 'ehu.table-with-academic-data' )"/>
				 	</xsl:attribute>
					<thead>
						<tr>
							<th><xsl:value-of select="languageUtil:get( $locale, 'ehu.title' )"/></th>
							<th><xsl:value-of select="languageUtil:get( $locale, 'ehu.type' )"/></th>
							<th><xsl:value-of select="languageUtil:get( $locale, 'ehu.init-year' )"/></th>
							<th><xsl:value-of select="languageUtil:get( $locale, 'ehu.end-year' )"/></th>
							<th><xsl:value-of select="languageUtil:get( $locale, 'ehu.teaching-center' )"/></th>
						</tr>
					</thead>
					<tbody>
						<xsl:for-each select="//datosAcademicos">
							<xsl:sort data-type='number' select="anyoInicio"/>
							<xsl:call-template name="datoAcademico"/>
						</xsl:for-each>
					</tbody>
				</table>
			</div>
		</section>
	</xsl:template>

	<xsl:template match="datosPersonales">
		<xsl:variable name="fechaNaciAux"><xsl:value-of select="fechaNacimiento"/></xsl:variable>
		<xsl:variable name="añoNaci"><xsl:value-of select="substring($fechaNaciAux,1,4)"/></xsl:variable>
		<xsl:variable name="mesNaci"><xsl:value-of select="substring($fechaNaciAux,6,2)"/></xsl:variable>
		<xsl:variable name="diaNaci"><xsl:value-of select="substring($fechaNaciAux,9,2)"/></xsl:variable>
		<xsl:variable name="fechaNaci">
			<xsl:choose>
				<xsl:when test="$localeStr = 'eu_ES'"><xsl:value-of select="$añoNaci"/>-<xsl:value-of select="$mesNaci"/>-<xsl:value-of select="$diaNaci"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$diaNaci"/>-<xsl:value-of select="$mesNaci"/>-<xsl:value-of select="$añoNaci"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<section id="datos_personales">
			<header class="info-section">
				<h2><xsl:value-of select="languageUtil:get( $locale, 'ehu.personal-data' )"/></h2>
			</header>
			<div class="content-section">
				<dl>
					<dt><xsl:value-of select="languageUtil:get( $locale, 'ehu.nombre' )"/>:</dt>
					<dd><xsl:value-of select="nombre"/><xsl:text> </xsl:text>
						<xsl:value-of select="apellido1"/><xsl:text> </xsl:text>
						<xsl:value-of select="apellido2"/>
					</dd>
					<dt><xsl:value-of select="languageUtil:get( $locale, 'ehu.date-birth' )"/>:</dt>
					<dd><xsl:value-of select="$fechaNaci"/></dd>
				</dl>
			</div>
		</section>
	</xsl:template>

	<xsl:template name="error">	
		<xsl:variable name="txtError">
			<xsl:value-of select="languageUtil:get( $locale, 'ehu.error' )"/>. <xsl:value-of select="languageUtil:get( $locale, 'ehu.problem-trying-get-data' )"/>: </xsl:variable>		
		<xsl:variable name="txtDescError">
			<xsl:choose>
				<xsl:when test="$nCodeError = $cCodeErrorNoInfo"><xsl:value-of select="languageUtil:get( $locale, 'ehu.no-info-found-in-gaur-about-user' )"/></xsl:when>
				<xsl:when test="$nCodeError = $cCodeErrorCredits">
					<xsl:value-of select="languageUtil:get( $locale, 'ehu.user-outstanding-credits-excessive' )"/> (<xsl:value-of select="languageUtil:format( $locale, 'ehu.more-than-x', '60' )"/>)
				</xsl:when>
				<xsl:when test="$nCodeError = $cCodeErrorNoMatri"><xsl:value-of select="languageUtil:get( $locale, 'ehu.user-is-not-matriculated' )"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="languageUtil:get( $locale, 'ehu.error-info-not-available' )"/> (<xsl:value-of select="$codeError"/>)</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>		
		<div class="portlet-msg-error">
			<xsl:value-of select="$txtError"/>
			<xsl:value-of select="$txtDescError"/>
		</div>
	</xsl:template>
	
	<xsl:template name="titulo">
		<header id="info-title">
			<h1><xsl:value-of select="languageUtil:get( $locale, 'ehu.my-profile' )"/></h1>
		</header>
	</xsl:template>

</xsl:stylesheet>