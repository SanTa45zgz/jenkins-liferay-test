<#--
Nombre contenido (ES): Destacados / Tarjetas
Estructura: global > content-featured-cards.json
Plantilla (ES): Centros - Artículo con trama
URL: https://dev74.ehu.eus/es/web/pruebas/centros
Nota: Solo se usa con global-theme > centros
-->

<#assign colorSchemeId = themeDisplay.getColorSchemeId() />
<#if ((themeDisplay.getTheme().getContextPath() == "/o/upv-ehu-global-theme") && (colorSchemeId?has_content && colorSchemeId == "08")) ||  ((themeDisplay.getTheme().getContextPath() == "/o/upv-ehu-theme") && (colorSchemeId?has_content && colorSchemeId == "09"))>

		<#assign urlImgFondo = ""/>
		<#assign altImgFondo = ""/>
		<div class="row featured_article-wrapper">
		    <#-- Bloque trama -->
		         <#-- Se obtiene el path a las tramas, dentro del sitio global Recursos/Tramas -->
		  	       	<#assign path_tramas = ""/>
		      	   	<#assign _dlFolderLocalService = serviceLocator.findService("com.liferay.document.library.kernel.service.DLFolderLocalService")/>
					<#assign _groupLocalService = serviceLocator.findService("com.liferay.portal.kernel.service.GroupLocalService")/>
		      	    <#assign siteGlobal = _groupLocalService.fetchCompanyGroup(themeDisplay.companyId)/>
		      	    <#if siteGlobal?? >
		      	        <#if _dlFolderLocalService.fetchFolder(siteGlobal.groupId,0 , "Recursos" )?? >
		          	        <#assign folderRecursos = _dlFolderLocalService.fetchFolder(siteGlobal.groupId,0 , "Recursos" ) >
		          	        <#if _dlFolderLocalService.fetchFolder(siteGlobal.groupId,folderRecursos.folderId , "Tramas" )?? >
		              	         <#assign folderTramas = _dlFolderLocalService.fetchFolder(siteGlobal.groupId,folderRecursos.folderId , "Tramas" ) >
		          	         </#if>
		          	    </#if>
		      	    </#if>
		      	    
		      	    <#assign avisoPrincipal = "" />
		            <#assign enlace_principal = "_self" />
		            <#if Enlaces?? && Enlaces.EnlacePrincipal?? && Enlaces.EnlacePrincipal.UrlPrincipal?? && Enlaces.EnlacePrincipal.UrlPrincipal.Externo?? && Enlaces.EnlacePrincipal.UrlPrincipal.Externo.getData() == "Si">
		            	<#assign enlace_principal = "_blank" />
		            	<#assign avisoPrincipal = '<span class="hide-accessible">'+languageUtil.get( locale, "opens-new-window" ) + "</span>" />
		    	    </#if>
		      	 
		      	 <#-- se accede al directorio del tipo de trama seleccionado -->
		      	 <#if folderTramas?has_content && Trama?? && Trama.TipoTrama?has_content && Trama.TipoTrama.getData()?has_content>   
		      	       <#assign tipoTrama = Trama.TipoTrama.getData()?string/>
		      	      <#if _dlFolderLocalService.fetchFolder(siteGlobal.groupId,folderTramas.folderId , tipoTrama)?? >
		          	      <#assign folderTipoTrama = _dlFolderLocalService.fetchFolder(siteGlobal.groupId,folderTramas.folderId , tipoTrama) >
		                <#if folderTipoTrama?has_content >
		                    <#assign path_tramas = "/documents/"+siteGlobal.groupId+"/"+folderTipoTrama.folderId+"/"/>
		                  	<#if Trama?? && Trama.ColorTrama?has_content && Trama.ColorTrama.getData()?has_content >
		                  	    <#assign trama = path_tramas+tipoTrama+" "+Trama.ColorTrama.getData()+".jpg"/>
		                  	   	<div class="col-12 col-md-7 featured_article-image" style="background-image:url('${trama}');">
		            		</#if>
		            		
		            		<#-- Bloque datos generales -->
		            		<#if DatosGenerales.titulo.getData()?has_content>
		                    	<h2>${DatosGenerales.titulo.getData()}</h2>
		            		</#if>
		            		<#if DatosGenerales.subtitulo.getData()?has_content>
		                    	<p>${DatosGenerales.subtitulo.getData()}</p>
		            		</#if>
		                    
		            		<#if Enlaces.EnlacePrincipal?? && Enlaces.EnlacePrincipal.getData()?has_content>
		            			<#assign enlace_principal_txt = Enlaces.EnlacePrincipal.getData() />
		            			<#assign enlace_principal_url = Enlaces.EnlacePrincipal.UrlPrincipal.getData() />
		            			<a href="${enlace_principal_url}" class="btn btn-more" target="${enlace_principal}">
		            				${enlace_principal_txt} <i class="fa fa-chevron-right" aria-hidden="true"></i>
		            				${avisoPrincipal}
		            			</a>
		            		</#if>
		                </div>
		            		
		          	    </#if>
		          	 </#if>
		      	 </#if>
		      	 
		    <#if (DatosGenerales.descripcion?? && DatosGenerales.descripcion.getData()?has_content) || (Enlaces.EnlaceSecundario?? && Enlaces.EnlaceSecundario.UrlSecundaria??)>    	    
		        <div class="col-12 col-md-5 featured_article-text">
		    		<#if DatosGenerales.descripcion.getData()?has_content>
		            	<p>${DatosGenerales.descripcion.getData()}</p>
		    		</#if>
		    		<#-- Bloque enlaces -->
		    		<#if enlace_principal_txt?has_content && enlace_principal_url?has_content>
		    			<a href="${enlace_principal_url}" class="" target="${enlace_principal}">
		    				${enlace_principal_txt}
		    				${avisoPrincipal}
		    			</a>
		    		</#if>
		    		
		    		<#assign avisoSecundario = "" />
		    		<#assign enlace_secundario = "_self" />
		    		<#if Enlaces?? && Enlaces.EnlaceSecundario?? && Enlaces.EnlaceSecundario.UrlSecundaria?? && Enlaces.EnlaceSecundario.UrlSecundaria.ExternoSecundario?? && Enlaces.EnlaceSecundario.UrlSecundaria.ExternoSecundario.getData()?? && Enlaces.EnlaceSecundario.UrlSecundaria.ExternoSecundario.getData() == "Si">
		    			<#assign enlace_secundario = "_blank" />
		    			<#assign avisoSecundario = '<span class="hide-accessible">'+languageUtil.get( locale, "opens-new-window" ) + "</span>" />
		    	    </#if>

		    		<#if Enlaces.EnlaceSecundario.getData()?has_content>
		    			<a href="${Enlaces.EnlaceSecundario.UrlSecundaria.getData()}" class="" target="${enlace_secundario}">
		    				${Enlaces.EnlaceSecundario.getData()}
		    				${avisoSecundario}
		    			</a>
		    		</#if>

		    		<#assign avisoTerciario = "" />
		    		<#assign enlace_terciario = "_self" />
		    		<#if Enlaces?? && Enlaces.EnlaceTerciario?? && Enlaces.EnlaceTerciario.UrlTerciaria?? && Enlaces.EnlaceTerciario.UrlTerciaria.ExternoTerciario?? && Enlaces.EnlaceTerciario.UrlTerciaria.ExternoTerciario.getData()?? && Enlaces.EnlaceTerciario.UrlTerciaria.ExternoTerciario.getData() == "Si">
		    			<#assign enlace_terciario = "_blank" />
		    			<#assign avisoTerciario = '<span class="hide-accessible">'+languageUtil.get( locale, "opens-new-window" ) + "</span>" />
		    	    </#if>
		    	    
		    		<#if Enlaces.EnlaceTerciario?? && Enlaces.EnlaceTerciario.getData()?has_content>
		    			<a href="${Enlaces.EnlaceTerciario.UrlTerciaria.getData()}" class="" target="${enlace_terciario}">
		    				${Enlaces.EnlaceTerciario.getData()}
		    				${avisoTerciario}
		    			</a>
		    		</#if>
		        </div>
		    </#if>
		</div>

<#else>
   <div class="alert alert-error"> 
      <@liferay.language key="ehu.error.theme-color" />
   </div>
</#if>
