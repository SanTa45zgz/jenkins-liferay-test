<#--
Nombre contenido (ES): Noticia
Estructura: global > news.json
Plantilla (ES): Resumen
URL: https://dev74.ehu.eus/es/web/pruebas/noticia
Nota: Se usa con global-theme y con ehu-theme
-->

<#-- TITLE-->
<#if ehugeneraldata ?has_content >   
    <#assign title = getterUtil.getString(ehugeneraldata.ehunewtitle.getData())>
<#else>
    <#assign title = "" >
</#if>

<#-- HIGHLIGHT TITLE-->
<#if ehu_images?has_content >
    <#assign highlight_title = ehuimages.ehuhighlighttitle.getData()>
<#else>
    <#assign highlight_title = "" >
</#if>

<#-- Para diferenciar campusa se mira unicamente si el tema es el de campusa-->
<#assign theme_image_path = (themeDisplay.getPathThemeImages())!"">


<#if theme_image_path?contains('/upv-ehu-campusa-theme/images')>
    <#assign image = ehuimages.ehuhighlightimage.getData()>
    
	<#if highlight_title?has_content >
	    <#assign title =  highlight_title>
	</#if>
	
	<div class='news'> 
        <#if image?has_content >
            <figure>
			    <img alt=' ' src='${image}'> 
			    <figcaption>
    			    <p class="card-title"><strong>${title}</strong></p>               
	    		</figcaption>
		    </figure>              
		<#else>
		    <p class="card-title"><strong>${title}</strong></p> 			
	    </#if>
    </div>

<#else>

	<#if (validator.isBlank(title) || validator.isNull(title)) && validator.isNotNull(highlight_title)&& !validator.isBlank(highlight_title)>
	    <#assign title =  highlight_title>
	</#if>

    <span class='news'> 
        ${title}
    </span>
</#if>