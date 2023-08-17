<#--
Nombre contenido (ES): Centros - Info + Enlaces / Galería
Estructura: global > centres-info-links-gallery.json 
Plantilla (ES): Info + Enlaces
URL: https://dev74.ehu.eus/es/web/pruebas/centros
Nota: Solo se usa con global-theme > centros
-->

<#assign colorSchemeId = themeDisplay.getColorSchemeId() />
<#if ((themeDisplay.getTheme().getContextPath() == "/o/upv-ehu-global-theme") && (colorSchemeId?has_content && colorSchemeId == "08")) ||  ((themeDisplay.getTheme().getContextPath() == "/o/upv-ehu-theme") && (colorSchemeId?has_content && colorSchemeId == "09"))>
    
		<#-- Se obtiene el path a los iconos, dentro del sitio global Recursos/Iconos -->
		   <#assign path_iconos = ""/>
		    <#assign _dlFolderLocalService = serviceLocator.findService("com.liferay.document.library.kernel.service.DLFolderLocalService")/>
			<#assign _groupLocalService = serviceLocator.findService("com.liferay.portal.kernel.service.GroupLocalService")/>
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
		<div class="row">
		
		    <#assign avisoGeneral = "" />
		    <#assign enlaceGeneral =""/>
		    <#assign externoGeneral = "_self">
		    <#if Logo.UrlGeneral?? && Logo.UrlGeneral.getData()?has_content>
		        <#assign enlaceGeneral ="${Logo.UrlGeneral.getData()}"/>
		        <#if Logo.UrlGeneral.ExternoGeneral?? && Logo.UrlGeneral.ExternoGeneral.getData()== "Si">
		            <#assign externoGeneral ="_blank"/>
		            <#assign avisoGeneral = '<span class="hide-accessible">'+languageUtil.get( locale, "opens-new-window" ) + "</span>" />
		        </#if>  
		    </#if>
		        <div class="card boletin-wrapper col-12 col-md-4">
		        <#if enlaceGeneral?has_content>
		            <a href="${enlaceGeneral}" target="${externoGeneral}">
		                ${avisoGeneral}
		         </#if>
		            <#if Logo??>
		                ${Logo.getData()}
		                <div class="boletin-image">
		                    <#assign tipo = Logo.Tipo.getData()?string/>                
		                    <#if tipo=="1">
		                        <#assign urlIcono = path_iconos+Logo.IconoLogo.getData()+".svg"/>
		                        <#-- <div class="card-img-top" style="background-image: url(${urlIcono})"> -->
		                        <div class="card-icon-top">
		                            <div class="card-icon-top-mask" style="-webkit-mask: url(${urlIcono}) no-repeat center; mask: url(${urlIcono}) no-repeat center;"></div>
		                        </div>
		                    <#else>
		                        <#if Logo.ImagenLogo.getData()?has_content>
		                            <#assign alt_logo = Logo.ImagenLogo.alt_logo.getData()!""/>
		                            <img class="card-img-top" alt="${alt_logo}" src="${Logo.ImagenLogo.getData()}" />
		                        </#if>  
		                    </#if>          
		                    </div>  
		                    <div class="card-body">
		                        <#if Logo.TituloGeneral.getData()?has_content>
		                            <p class="card-title"><strong>${Logo.TituloGeneral.getData()}</strong></p>
		                        </#if>
		                        <#if Logo.DescripcionGeneral.getData()?has_content>
		                            <p>${Logo.DescripcionGeneral.getData()}</p>
		                        </#if>
		                    </div>
		            </#if>
		        <#if enlaceGeneral?has_content>
		              </a>
		        </#if>
		        </div>
		    <#--Bloque enlaces destacados -->
		    <div class="list-group featured_links-wrapper col-12 col-md-8">
		        <#if EnlacesDestacados.TituloDestacado?? && EnlacesDestacados.TituloDestacado.getData()?has_content>
		            <h2 class="list-group-title item-dark">${EnlacesDestacados.TituloDestacado.getData()}</h2>
		        </#if>
		        <#if EnlacesDestacados.Enlace.getSiblings()?has_content>
		            <#assign elements = EnlacesDestacados.Enlace.getSiblings()?size/>
		            <#assign classLi = ""/> 
		            <#if elements?number == 3>
		                <#assign classLi = "tres-items"/>
		            <#else>
		                <#if elements?number gte 4>
		                    <#assign classLi = "cuatro-items"/>
		                </#if>
		            </#if>
		            
		            <#if elements?number gte 3 >
		                <ul>
		                    <#list EnlacesDestacados.Enlace.getSiblings() as cur_Enlace>
		                        <#if cur_Enlace?index < 4>
		                            <li class="list-group-item ${classLi}">
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
		                        </#if>
		                    </#list>
		                </ul>
		            </#if>
		        </#if>
		    </div>
		</div>

<#else>
   <div class="alert alert-error"> 
      <@liferay.language key="ehu.error.theme-color" />
   </div>
</#if>