<#--
Nombre contenido (ES): Destacados / Tarjetas
Estructura: global > content-featured-cards.json
Plantilla (ES): Centros - Artículo con vídeo
URL: https://dev74.ehu.eus/es/web/pruebas/centros
Nota: Solo se usa con global-theme > centros
-->

<#assign colorSchemeId = themeDisplay.getColorSchemeId() />
<#if ((themeDisplay.getTheme().getContextPath() == "/o/upv-ehu-global-theme") && (colorSchemeId?has_content && colorSchemeId == "08")) ||  ((themeDisplay.getTheme().getContextPath() == "/o/upv-ehu-theme") && (colorSchemeId?has_content && colorSchemeId == "09"))>

		<#assign fecha_Data = getterUtil.getString(DatosGenerales.fecha.getData())>
		<div class="row featured_article-wrapper">
		    <#-- Bloque video -->
		    <div class="col-12 col-md-7 feature_article-video p-0">
		       <#if Video?? && Video.UrlVideo?? && Video.UrlVideo.getData()?has_content>
		          <#assign titleIFrame = languageUtil.get( locale, "video" )/>
		          <iframe title="${titleIFrame}" width="535" height="300" src="${Video.UrlVideo.getData()}" allowfullscreen style="border:none;"></iframe>
		        </#if>
		    </div>
		    <#-- Bloque datos generales -->
		    <div class="col-12 col-md-5 featured_article-text date feature_article-video-text">
		        <#if DatosGenerales.titulo.getData()?has_content>
		        	<h2>${DatosGenerales.titulo.getData()}</h2>
				</#if>
		
		        <#if validator.isNotNull(fecha_Data)>
			        <#assign fecha_DateObj = dateUtil.parseDate("yyyy-mm-dd", fecha_Data, locale)>
		
			        <p>${dateUtil.getDate(fecha_DateObj, "dd/mm/yyyy", locale)}</p>
		        </#if>
		
				<#if DatosGenerales.subtitulo.getData()?has_content>
		        	<p>${DatosGenerales.subtitulo.getData()}</p>
				</#if>
		
				<#if DatosGenerales.descripcion.getData()?has_content>
		        	<p>${DatosGenerales.descripcion.getData()}</p>
				</#if>
		
		        <#-- Bloque enlaces -->

		        <#assign avisoTerciario = "" />            
		        <#assign enlace_terciario = "_self" />
				<#if Enlaces.EnlaceTerciario?? && Enlaces.EnlaceTerciario.UrlTerciaria.ExternoTerciario.getData() == "Si" >
					<#assign enlace_terciario = "_blank" />
					<#assign avisoTerciario = '<span class="hide-accessible">'+languageUtil.get( locale, "opens-new-window" ) + "</span>" />
			    </#if>


		        <#assign avisoSecundario = "" />            
		        <#assign enlace_secundario = "_self" />
				<#if Enlaces.EnlaceSecundario.UrlSecundaria.ExternoSecundario.getData() == "Si">
					<#assign enlace_secundario = "_blank" />
					<#assign avisoSecundario = '<span class="hide-accessible">'+languageUtil.get( locale, "opens-new-window" ) + "</span>" />
			    </#if>
		
		        <#assign avisoPrincipal = "" />
			    <#assign enlace_principal = "_self" />
		        <#if Enlaces.EnlacePrincipal.UrlPrincipal.Externo.getData() == "Si">
					<#assign enlace_principal = "_blank" />
					<#assign avisoPrincipal = '<span class="hide-accessible">'+languageUtil.get( locale, "opens-new-window" ) + "</span>" />
			    </#if>
		
				<#if Enlaces.EnlacePrincipal.getData()?has_content>
					<a href="${Enlaces.EnlacePrincipal.UrlPrincipal.getData()}" target="${enlace_principal}">
						${Enlaces.EnlacePrincipal.getData()}
						${avisoPrincipal}
					</a>
				</#if>
		
				<#if Enlaces.EnlaceSecundario.getData()?has_content>
					<a href="${Enlaces.EnlaceSecundario.UrlSecundaria.getData()}" class="" target="${enlace_secundario}">
						${Enlaces.EnlaceSecundario.getData()}
						${avisoSecundario}
					</a>
				</#if>

				<#if Enlaces.EnlaceTerciario?? && Enlaces.EnlaceTerciario.getData()?has_content>
					<a href="${Enlaces.EnlaceTerciario.UrlTerciaria.getData()}" class="" target="${enlace_terciario}">
						${Enlaces.EnlaceTerciario.getData()}
						${avisoTerciario}
					</a>
				</#if>
		    </div>
		</div>

<#else>
   <div class="alert alert-error"> 
      <@liferay.language key="ehu.error.theme-color" />
   </div>
</#if>