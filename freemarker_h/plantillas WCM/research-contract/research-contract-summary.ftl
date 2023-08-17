<#--
Nombre contenido (ES): Contrato de investigación
Estructura: global > research-contract.json
Plantilla (ES): Resumen
URL: https://dev74.ehu.eus/es/web/pruebas/contrato
Nota: Se usa con global-theme y con ehu-theme
-->

<#--en la 6.2 la gestión de ADTs del publicador se realiza mediante las plantillas summary (vm) y la plantilla resumen global (ftl)
##no se deben recorrer los assets en la vm ya que de eso se encarga el ftl ni tampoco gestionar la viewURL-->
<#if ehuresearchcontractyearfrom?? && ehuresearchcontractyearfrom.getData()?? >
    <#assign yearFrom = ehuresearchcontractyearfrom.getData()>
</#if>
<span class="research-contract">
<#if ehuresearchcontractresearcher?? && ehuresearchcontractresearcher.getData()?has_content >
    <span class="researcher">${ehuresearchcontractresearcher.getData()}</span> 
</#if>    
<span class="template-title">   
    <#if ehuresearchcontracttitle?? && ehuresearchcontracttitle.ehuresearchcontracttitlelang?? && ehuresearchcontracttitle.ehuresearchcontracttitlelang.getData()?? >
        <#assign titleLang = ehuresearchcontracttitle.ehuresearchcontracttitlelang.getData()>
    </#if>
    <#if titleLang?? && "upv-ehu-blank" != titleLang && ehuresearchcontracttitle?? && ehuresearchcontracttitle.getData()?? >
        <span lang="${titleLang}">
            <strong>"${ehuresearchcontracttitle.getData()}"</strong>   
        </span>
    <#elseif ehuresearchcontracttitle?? && ehuresearchcontracttitle.getData()??>
        <strong>"${ehuresearchcontracttitle.getData()}"</strong>
    </#if>
</span>
<span class="company"> <em>${ehuresearchcontractcompany.getData()}</em>.</span>
<span class="year-from"> ${yearFrom}</span>
    <#if ehuresearchcontractyeartoseparator.ehuresearchcontractyearto.getData()?has_content >  
        <#assign yearTo = ehuresearchcontractyeartoseparator.ehuresearchcontractyearto.getData()>
        <span class="year-to"> - ${yearTo}</span>         
    </#if>    
</span>