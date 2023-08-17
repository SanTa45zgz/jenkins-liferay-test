<#--
Nombre contenido (ES): Sellos
Estructura: global > seals.json
Plantilla (ES): Sellos
URL: https://dev74.ehu.eus/es/web/pruebas/centros
Nota: Solo se usa con global-theme
-->

<#assign colorSchemeId = themeDisplay.getColorSchemeId() />
<#if (themeDisplay.getTheme().getContextPath() == "/o/upv-ehu-global-theme")  ||  ((themeDisplay.getTheme().getContextPath() == "/o/upv-ehu-theme") && (colorSchemeId?has_content && colorSchemeId == "09"))>

		<#if logo.getSiblings()?has_content>
		    <div class="menu-lateral-logos">
		        <#list logo.getSiblings() as item>
		            <#if item?has_content >
		                <#assign alt_logo = "" />
		                <#if item.alt_logo?has_content >
		                    <#assign alt_logo = item.alt_logo.getData()!""/>
		                </#if>
		                <#if item.direccionWeb?has_content && item.direccionWeb.getData()?has_content >
		                   <#if item.getData()?has_content >
		                        <a href="${item.direccionWeb.getData()}" class="logo">
		                            <img alt="${alt_logo}" src="${item.getData()}" />
		                        </a>
		                    </#if>
		                <#else>
		                    <#if item.getData()?has_content>
		                        <div class="logo">
		                            <img alt="${alt_logo}" src="${item.getData()}" />
		                        </div>
		                    </#if>
		                </#if>
		            </#if>
		        </#list>
		    </div>
		</#if>

<#else>
   <div class="alert alert-error"> 
      <@liferay.language key="ehu.error.theme-color" />
   </div>
</#if>