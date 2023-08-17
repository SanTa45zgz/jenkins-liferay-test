<#--
Nombre contenido (ES): Destacados / Tarjetas
Estructura: global > content-featured-cards.json
Plantilla (ES): Destacado Horizontal - Vídeo
URL: https://dev74.ehu.eus/es/web/pruebas/nuevos-componentes
Nota: Solo se usa con global-theme
-->

<#if themeDisplay.getTheme().getContextPath() == "/o/upv-ehu-global-theme">
    <#assign colorSchemeId = themeDisplay.getColorSchemeId() />
    <#if colorSchemeId?has_content && (colorSchemeId=="08" || colorSchemeId=="06")>  
        <div class="alert alert-error"> 
            <@liferay.language key="ehu.error.theme-color" />
        </div>
    <#else>
		<div class="content-featured content-featured--horizontal-video">
			<div class="row">
				<div class="col-md-12 col-lg-7">
					<div class="content-featured__video embed-responsive embed-responsive-16by9">
				        <#if Video?? && Video.UrlVideo?? && Video.UrlVideo.getData()?has_content>
				          <#assign titleIFrame = languageUtil.get( locale, "video" )/>
				          <iframe title="${titleIFrame}" class="embed-responsive-item"  src="${Video.UrlVideo.getData()}" allowfullscreen></iframe>
				        </#if>
				    </div>
				</div>
				<div class="col-md-12 col-lg-5">
				    <#if DatosGenerales.titulo.getData()?has_content>
				    	<h2 class="content-featured__title u-text-truncate u-text-truncate--2">${DatosGenerales.titulo.getData()}</h2>
					</#if>

					<#if DatosGenerales.descripcion.getData()?has_content>
				    	<p class="content-featured__description u-text-truncate u-text-truncate--7">${DatosGenerales.descripcion.getData()}</p>
					</#if>

					<#assign txt_Principal = ""/>
					<#assign url_Principal = ""/>
					<#if Enlaces.EnlacePrincipal.getData()?has_content>
						<#assign txt_Principal = Enlaces.EnlacePrincipal.getData()/>
						<#assign url_Principal = Enlaces.EnlacePrincipal.UrlPrincipal.getData()/>
					</#if>

					<#assign avisoPrincipal = "" />
					<#assign enlace_principal = "_self" />

				    <#if Enlaces.EnlacePrincipal.UrlPrincipal.Externo.getData() == "Si" >
						<#assign enlace_principal = "_blank" />
						<#assign avisoPrincipal = '<span class="hide-accessible">'+languageUtil.get( locale, "opens-new-window" ) + "</span>" />
				    </#if>

				    <#assign avisoSecundario = "" />
					<#assign enlace_secundario = "_self" />

				    <#if Enlaces.EnlaceSecundario.UrlSecundaria.ExternoSecundario.getData() == "Si" >
						<#assign enlace_secundario = "_blank" />
						<#assign avisoSecundario = '<span class="hide-accessible">'+languageUtil.get( locale, "opens-new-window" ) + "</span>" />
				    </#if>

				    <#assign avisoTerciario = "" />
					<#assign enlace_terciario = "_self" />

				    <#if Enlaces.EnlaceTerciario?? && Enlaces.EnlaceTerciario.UrlTerciaria.ExternoTerciario.getData() == "Si" >
						<#assign enlace_terciario = "_blank" />
						<#assign avisoTerciario = '<span class="hide-accessible">'+languageUtil.get( locale, "opens-new-window" ) + "</span>" />
				    </#if>

					<#if Enlaces.EnlacePrincipal.getData()?has_content>
						<a href="${Enlaces.EnlacePrincipal.UrlPrincipal.getData()}" target="${enlace_principal}" class="content-featured__link">
							${Enlaces.EnlacePrincipal.getData()}
							${avisoPrincipal}
						</a>
					</#if>
					<#if Enlaces.EnlaceSecundario.getData()?has_content>
						<a href="${Enlaces.EnlaceSecundario.UrlSecundaria.getData()}" target="${enlace_secundario}" class="content-featured__link">
							${Enlaces.EnlaceSecundario.getData()}
							${avisoSecundario}
						</a>
					</#if>

					<#if Enlaces.EnlaceTerciario?? && Enlaces.EnlaceTerciario.getData()?has_content>
						<a href="${Enlaces.EnlaceTerciario.UrlTerciaria.getData()}" target="${enlace_terciario}" class="content-featured__link">
							${Enlaces.EnlaceTerciario.getData()}
							${avisoTerciario}
						</a>
					</#if>
				</div>
			</div>
		</div>
    </#if>
<#else>
   <div class="alert alert-error"> 
      <@liferay.language key="ehu.error.theme-color" />
   </div>
</#if>