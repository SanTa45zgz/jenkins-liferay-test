<#--
Nombre contenido (ES): Proyecto de investigación
Estructura: global > research-project.json
Plantilla (ES): Resumen
URL: https://dev74.ehu.eus/es/web/pruebas/proyecto
Nota: Se usa con global-theme y con ehu-theme
-->

<span class="research-project">
    <#if !ehuresearchprojectresearcher.getData()?? >
        <span class="researcher">${ehuresearchprojectresearcher.getData()} </span> 
    </#if>
    <#assign titleLang = ehuresearchprojecttitle.ehuresearchprojecttitlelang.getData()>
        
    <#if "upv-ehu-blank" != titleLang >
        <span lang="${titleLang}">
            "<span class="template-title"><strong>${ehuresearchprojecttitle.getData()}</strong></span>"   
        </span> 
    <#else>
        "<span class="template-title"><strong>${ehuresearchprojecttitle.getData()}</strong></span>"
    </#if>
    
    <#list ehuresearchprojectfinancial.getSiblings() as entity >
		<span class="financial-entity"> <em>${entity.getData()}</em></span>
		<#if velocityHasNext?? > 
		    ,
		 </#if>
    </#list>
	
	<#assign txtYearUnknown = "unknown" >
	<#assign yearFrom = ""> 
   	<#if ehuresearchprojectdatafrom??>
    	<#assign yearFrom = ehuresearchprojectdatafrom.getData()>
    </#if>
    <#assign yearTo = "">
    <#if ehuresearchprojectdatatoseparator.ehuresearchprojectdatato??>
		<#assign yearTo = ehuresearchprojectdatatoseparator.ehuresearchprojectdatato.getData()>
	</#if>
	<#if yearFrom != "" && yearFrom != txtYearUnknown >
	    <#if yearTo != "" && yearTo != txtYearUnknown>
			 - <span class="data-from">${yearFrom}</span> - <span class="data-to">${yearTo}</span>       
		<#else>
			 - <span class="data-to">${yearTo}</span>       
		</#if>
	</#if>
</span>