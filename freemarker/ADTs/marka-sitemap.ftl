<#--
 # MAPA WEB para el site de MARKA
 #	- siempre se debe seleccionar la pagina inicial
 #	- nivel de profundidad = 2
-->

<#-- Constantes -->
<#assign cScopePublic = "/web" >
<#assign cScopePrivate = "/group" >

<#-- La pagina actual se configura con el tema de marka -->
<#assign isMarcaTheme = getterUtil.getBoolean( themeDisplay.getPathThemeRoot()?ends_with( "/upv-ehu-marka-theme" ) ) />

<#if isMarcaTheme >
	<#assign siteClasses =  [ 'brand', 'expression', 'supports', 'networks', 'downloads', 'help' ] >
<#else>
	<#assign siteClasses = []>
</#if>

<#assign sizeSiteClasses = siteClasses?size >

<#-- El mapa web se presenta dentro de un layout de columna unica con 3 columnas por fila (span4) -->
<#assign columnsPerRow = 3 >
<#assign columnSpan = 4 >

<#-- Indice de recorrido de paginas -->
<#assign index = 0 >
<#-- Si hay paginas hijas para el nivel seleccionado -->
<#if entries?has_content >
	<nav role="navigation" id="sitemap">
		<div class="container-fluid container-margin">
			<#assign columnPerRow = columnsPerRow >
			<#-- Paginas hijas para el nivel seleccionado -->
			<#list entries as layout >
				<#-- Control de INICIO de nueva fila  -->
				<#if columnPerRow % columnsPerRow == 0 >
					<div class="row-fluid">
				</#if>

				<#-- Se utilizan los estilos recogidos de la tabla -->
				<#if index < sizeSiteClasses >
					<#assign siteClass = siteClasses[ index ] >
				<#else>
					<#assign siteClass = "" >
				</#if>

				<div class="span${ columnSpan } ${ siteClass }">
					<hr>
					<#assign url = GetUrlFromLayout( layout, locale ) >
					<#assign layoutName = layout.getName( locale ) >
					<h2> <a href="${ url }">${ layoutName }</a> </h2>

					<#-- Si la pagina hija tiene hijos -->
					<#if layout.hasChildren() >
						<#assign subLayouts = layout.getChildren() >
						<ul>
							<#-- Por cada pagina hija -->
							<#list subLayouts as subLayout >
								<#assign url = GetUrlFromLayout( subLayout, locale ) >
								<#assign layoutName = subLayout.getName( locale ) >
								<li> <a href="${ url }">${ layoutName }</a> </li>
							</#list>
						</ul>
					</#if>
				</div>

				<#assign columnPerRow = columnPerRow - 1 >

				<#-- Control de FIN de fila -->
				<#if columnPerRow == 0 >
					</div>
					<#assign columnPerRow = columnsPerRow >
					<div class="row-fluid">
						<div class="span12">
							<a href="#sitemap" class="pull-right">
								<span><@liferay.language key="up" /></span>
								<i class="icon-chevron-up"></i>
							</a>
						</div>
					</div>
				</#if>

				<#assign index = index + 1 >

			</#list> <#-- Paginas hijas para el nivel seleccionado-->
		</div>
	</nav>
</#if>

<#--
 # ===============================================================================
 # Devuelve una URL partiendo de la pagina "layout" y del locale "__locale".
 # La URL estara formada por: el idioma, el ambito, la friendly URL del site al
 # que pertenece la pagina y el friendly URL de la pagina.
 # Si "layout" es null o no se pasa como parametro, devuelve una cadena vacia.
 # Si "locale" es null o no se pasa como parametro, se tomara el locale asociado a
 # la request.
 # Parametros:
 #	layout			una pagina (segun el modelo "layout")
 #	[__locale]		locale
 # Retorno:			URL formada a partir de la pagina y el locale
 # ===============================================================================
-->
<#function GetUrlFromLayout layout __locale>
	<#if layout == "null" >		<#return "" > </#if>

	<#if layout.isPublicLayout() >
		<#local scope = cScopePublic >
	<#else>
		<#local scope = cScopePrivate >
	</#if>
	<#if layout.isPublicLayout()>
		<#assign scope =  cScopePublic >
	<#else>
		<#assign scope = cScopePrivate>
	</#if>
	<#local groupFrUrl = layout.getGroup().getFriendlyURL() >
	<#local initUrl = "/" + languageUtil.getLanguageId( __locale ) + scope + groupFrUrl >
	<#local layoutFrUrl = layout.getFriendlyURL( __locale ) >
	<#if layoutFrUrl == "null" >
		<#-- Si no se ha podido obtener la friendlyURL internacionalizada, se obtiene la canonica -->
		<#local layoutFrUrl = layout.getFriendlyURL() >
	</#if>
	<#local url = initUrl + layoutFrUrl >
	<#return url >
</#function>
