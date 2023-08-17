<#if themeDisplay.getTheme().getContextPath() == "/o/upv-ehu-global-theme">
    <#assign colorSchemeId = themeDisplay.getColorSchemeId() />
    <#if colorSchemeId?has_content && (colorSchemeId=="08" || colorSchemeId=="06")>  
        <div class="alert alert-error"> 
            <@liferay.language key="ehu.error.theme-color" />
        </div>
    <#else>

		<#if DatosGenerales?? >
		    <#assign fecha_Data = getterUtil.getString(DatosGenerales.fecha.getData())>
		</#if>
		<#assign urlImgFondo = ""/>
		<#assign altImgFondo = ""/>

		<#assign avisoPrincipal = "" />
		<#assign enlace_principal = "_self" />
		<#assign url_Principal = ""/>
		<#if Enlaces?? && Enlaces.EnlacePrincipal?? && Enlaces.EnlacePrincipal.UrlPrincipal?? >
			<#assign url_Principal = Enlaces.EnlacePrincipal.UrlPrincipal.getData()!""/>
			<#if Enlaces.EnlacePrincipal.UrlPrincipal.Externo.getData() == "Si">
				<#assign enlace_principal = "_blank" />
				<#assign avisoPrincipal = '<span class="hide-accessible">'+languageUtil.get( locale, "opens-new-window" ) + "</span>" />
			</#if>
		</#if>

		<a class="c-cards" href="${url_Principal}" target="${enlace_principal}"> 
		 ${avisoPrincipal}
			<#-- Bloque Imagen -->
			<#if Imagen?? && Imagen.ImagenDelFondo?? && Imagen.ImagenDelFondo.getData()?has_content >
				<#assign urlImgFondo = Imagen.ImagenDelFondo.getData()/>
				<#if Imagen.ImagenDelFondo.alt_fondo?? && Imagen.ImagenDelFondo.alt_fondo.getData()?has_content>
					<#assign altImgFondo = Imagen.ImagenDelFondo.alt_fondo.getData()!""/>
				</#if>
			</#if>
			
			<#if Imagen?? && Imagen.ImagenDelFondo?? && Imagen.ImagenDelFondo.getData()?has_content >
				<div class="c-cards__img">
                    <img  src="${urlImgFondo}" alt="${altImgFondo}">
                </div>
            </#if>
			
			<div class="c-cards__body">
			<#if DatosGenerales?? && DatosGenerales.titulo?? && DatosGenerales.titulo.getData()?has_content>
			  <p class="c-cards__body__title"><strong>${DatosGenerales.titulo.getData()}</strong></p>
			</#if>
			</div>  
		</a>

    </#if>

<#else>
   <div class="alert alert-error"> 
      <@liferay.language key="ehu.error.theme-color" />
   </div>
</#if>
