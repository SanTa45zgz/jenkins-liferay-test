<#assign colorSchemeId = themeDisplay.getColorSchemeId() />
<#if ((themeDisplay.getTheme().getContextPath() == "/o/upv-ehu-global-theme") && (colorSchemeId?has_content && colorSchemeId == "08")) ||  ((themeDisplay.getTheme().getContextPath() == "/o/upv-ehu-theme") && (colorSchemeId?has_content && colorSchemeId == "09"))>
    
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

		<a class="articulo-enlace-global" href="${url_Principal}" target="${enlace_principal}"> 
		 ${avisoPrincipal}
			<#-- Bloque Imagen -->
			<#if Imagen?? && Imagen.ImagenDelFondo?? && Imagen.ImagenDelFondo.getData()?has_content >
				<#assign urlImgFondo = Imagen.ImagenDelFondo.getData()/>
				<#if Imagen.ImagenDelFondo.alt_fondo?? && Imagen.ImagenDelFondo.alt_fondo.getData()?has_content>
					<#assign altImgFondo = Imagen.ImagenDelFondo.alt_fondo.getData()!""/>
				</#if>
			</#if>
		
		
			<#-- Bloque Datos generales y enlaces -->
		
			<#if DatosGenerales?? && DatosGenerales.subtitulo?? && DatosGenerales.subtitulo.getData()?has_content>
			  <div class="card-head">
				<p>${DatosGenerales.subtitulo.getData()}</p>
			  </div>
			</#if>
		
			<div class="card"> 
				<#if urlImgFondo != "" >				  
				  <div class="card-img">
					<img class="card-img-top" src="${urlImgFondo}" alt="${altImgFondo}">
				  </div>
				</#if>
				  <div class="card-body">
					<#if fecha_Data?has_content >
						<#assign fecha_DateObj = dateUtil.parseDate("yyyy-mm-dd", fecha_Data, locale)>
						<p>${dateUtil.getDate(fecha_DateObj, "dd/mm/yyyy", locale)}</p>
					</#if>
					<#if DatosGenerales?? && DatosGenerales.titulo?? && DatosGenerales.titulo.getData()?has_content>
					  <p class="card-title"><strong>${DatosGenerales.titulo.getData()}</strong></p>
					</#if>
					<#if DatosGenerales?? && DatosGenerales.descripcion?? && DatosGenerales.descripcion.getData()?has_content>
					  <p class="card-text">${DatosGenerales.descripcion.getData()}</p>
					</#if>
				  </div>  
			</div>
		</a>

<#else>
   <div class="alert alert-error"> 
      <@liferay.language key="ehu.error.theme-color" />
   </div>
</#if>
