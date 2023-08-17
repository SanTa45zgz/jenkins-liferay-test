<#--
Nombre contenido (ES): Título y enlace
Estructura: global > title-link.json
Plantilla (ES): Título y enlace
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
		<div class="title-and-link">
			 
		    <#if Izenburua.getData()?? && Izenburua.getData() != "">
		    	<h2>${Izenburua.getData()}</h2>
		    </#if>
		    <#if EstekarenTestua.WebHelbidea.getData()?? && EstekarenTestua.WebHelbidea.getData() != "" && EstekarenTestua.getData()?? && EstekarenTestua.getData() != "" >
		    	<a href="${EstekarenTestua.WebHelbidea.getData()}" class="c-button c-button--tertiary ">${EstekarenTestua.getData()}</a>
		    </#if>
		    
		    
		</div>
    </#if>

<#else>
   <div class="alert alert-error"> 
      <@liferay.language key="ehu.error.theme-color" />
   </div>
</#if>