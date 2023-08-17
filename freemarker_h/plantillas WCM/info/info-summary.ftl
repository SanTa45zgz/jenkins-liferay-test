<#--
Nombre contenido (ES): Galería de imágenes
Estructura: global > info.json
Plantilla (ES): Resumen
URL: 
Nota: Se usa con global-theme y con ehu-theme
-->


<#-- TITLE -->

<#if  ehuheader?? &&  ehuheader.ehuinfotitle?? &&  ehuheader.ehuinfotitle.getData()??>
	<#assign title = ehuheader.ehuinfotitle.getData()/>
</#if>

<#if title?has_content>
    <span class="information">
        ${title}                
    </span>
<#else>
    <div class="alert alert-error">
        <@liferay.language key="ehu.error.title-not-filled" />
    </div>
</#if>