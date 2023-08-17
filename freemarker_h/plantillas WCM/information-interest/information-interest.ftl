<#--
Nombre contenido (ES): Enlaces de interés
Estructura: global > information-interest.json
Plantilla (ES): Enlaces de interés
URL: https://dev74.ehu.eus/es/web/pruebas/informacion-de-interes
Nota: Solo se usa con global-theme
-->
<#if themeDisplay.getTheme().getContextPath() == "/o/upv-ehu-global-theme">
    <#assign colorSchemeId = themeDisplay.getColorSchemeId() />
    <#if colorSchemeId?has_content && (colorSchemeId=="08" || colorSchemeId=="06")>  
        <div class="alert alert-error"> 
            <@liferay.language key="ehu.error.theme-color" />
        </div>
    <#else>

        <#-- Se obtiene el path a los iconos, dentro del sitio global Recursos/Iconos -->
           <#assign path_iconos = ""/>
            <#assign _dlFolderLocalService = serviceLocator.findService("com.liferay.document.library.kernel.service.DLFolderLocalService")/>
            <#assign _groupLocalService = serviceLocator.findService("com.liferay.portal.kernel.service.GroupLocalService") />           
            <#assign siteGlobal = _groupLocalService.fetchCompanyGroup(themeDisplay.companyId)/>
            <#if siteGlobal?? >
                <#if _dlFolderLocalService.fetchFolder(siteGlobal.groupId,0 , "Recursos" )?? >
                    <#assign folderRecursos = _dlFolderLocalService.fetchFolder(siteGlobal.groupId,0 , "Recursos" ) >
                    <#if _dlFolderLocalService.fetchFolder(siteGlobal.groupId,folderRecursos.folderId , "Iconos" )?? >
                        <#assign folderIconos = _dlFolderLocalService.fetchFolder(siteGlobal.groupId,folderRecursos.folderId , "Iconos" ) >
                                     
                         <#if folderIconos?has_content >
                            <#assign path_iconos = "/documents/"+siteGlobal.groupId+"/"+folderIconos.folderId+"/"/>
                         </#if>
                    </#if>
                </#if>
            </#if>

        <#--Bloque Logo -->
        <div class="information-interest">
            <#--Bloque enlaces destacados -->

            <#if EnlacesDestacados.TituloDestacado?? && EnlacesDestacados.TituloDestacado.getData()?has_content>
                <h2>${EnlacesDestacados.TituloDestacado.getData()}</h2>
            </#if>
            <#if EnlacesDestacados.Enlace.getSiblings()?has_content>
                <ul class="row">
                    <#list EnlacesDestacados.Enlace.getSiblings() as cur_Enlace>
                        <li class="information-interest__item col-12 col-sm-6" >
                            <#if cur_Enlace.NombreEnlace?has_content && cur_Enlace.NombreEnlace.Externo??>
                                <#assign aviso = "" />
                                <#assign enlace = "_self" />
                                <#if cur_Enlace.NombreEnlace.Externo.getData() == "Si">
                                    <#assign enlace = "_blank" />
                                    <#assign aviso = '<span class="hide-accessible">'+languageUtil.get( locale, "opens-new-window" ) + "</span>" />
                                </#if>
                                <a href="${cur_Enlace.NombreEnlace.UrlEnlace.getData()}" target="${enlace}">
                                    ${aviso}
                                    <#if cur_Enlace?? && cur_Enlace.IconoEnlace?? && cur_Enlace.IconoEnlace.getData()?has_content>
                                        <div class="icono-enlace-destacado" style="-webkit-mask: url(${path_iconos}${cur_Enlace.IconoEnlace.getData()}.svg) no-repeat center; mask: url(${path_iconos}${cur_Enlace.IconoEnlace.getData()}.svg) no-repeat center;"></div>
                                    </#if>
                                    ${cur_Enlace.NombreEnlace.getData()}
                                </a>
                            </#if>
                        </li>
                    </#list>
                </ul>
            </#if>
        </div>
    </#if>

<#else>
   <div class="alert alert-error"> 
      <@liferay.language key="ehu.error.theme-color" />
   </div>
</#if>