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