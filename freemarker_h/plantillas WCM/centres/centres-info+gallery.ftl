<#--
Nombre contenido (ES): Centros - Info + Enlaces / Galería
Estructura: global > centres-info-links-gallery.json 
Plantilla (ES): Info + Galería
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
		    <#--Bloque galeria imagenes -->
		    <div class="card galeria-wrapper col-12 col-md-8">
		        <#if GaleriaImagenes.ImagenRepresentativa?has_content>
		        	<#assign urlGaleria = "" />
		        	<#assign aviso = "" />
		        	<#assign enlace = "_self" />
		        	<#if GaleriaImagenes.UrlGaleria?? && GaleriaImagenes.UrlGaleria.getData()?has_content>
		        	    <#assign urlGaleria = GaleriaImagenes.UrlGaleria.getData() />
		                <#if GaleriaImagenes.UrlGaleria.ExternoGaleria?? && GaleriaImagenes.UrlGaleria.ExternoGaleria.getData() == "Si">
		                	<#assign enlace = "_blank" />
		                	<#assign aviso = '<span class="hide-accessible">'+languageUtil.get( locale, "opens-new-window" ) + "</span>" />
		                </#if>
		            </#if>
		            <#assign altGaleria =""/>
		            <#if GaleriaImagenes.ImagenRepresentativa.alt_galeria?? && GaleriaImagenes.ImagenRepresentativa.alt_galeria.getData()?has_content>
		                <#assign altGaleria = GaleriaImagenes.ImagenRepresentativa.alt_galeria.getData()/>
		            </#if>
		            
		            <#if GaleriaImagenes.ImagenRepresentativa.getData()?has_content>
		            	<#if urlGaleria?has_content> 
						    <a href="${urlGaleria}" target="${enlace}">
						        ${aviso}
						</#if>
		            		<img alt="${altGaleria}" src="${GaleriaImagenes.ImagenRepresentativa.getData()}"/>
		            	                
		                	<#assign images_folder = themeDisplay.getPathThemeImages()/>
		                    <#assign iconoGaleria = images_folder+"/icons/ico-galeria.png"/>
		                    <div class="gallery-card-body">
		                    <p class="pie-de-foto"><img src="${iconoGaleria}" alt="">
		                    <span> <@liferay.language key="centros.galeria.imagenes" /></span></p>
							
							
							 <#if GaleriaImagenes.TituloGaleria?? && GaleriaImagenes.TituloGaleria.getData()?has_content>
								<p class="card-title"><strong>${GaleriaImagenes.TituloGaleria.getData()}</strong></p>
							</#if>
							<#if GaleriaImagenes.DescripcionGaleria?? && GaleriaImagenes.DescripcionGaleria.getData()?has_content>
								<p>${GaleriaImagenes.DescripcionGaleria.getData()}</p>
							</#if>
							</div>
					<#if urlGaleria?has_content> 		
		                </a>
		            </#if>
		            	
		            </#if>
		        </#if>       
		    </div>
		</div>

<#else>
   <div class="alert alert-error"> 
      <@liferay.language key="ehu.error.theme-color" />
   </div>
</#if>