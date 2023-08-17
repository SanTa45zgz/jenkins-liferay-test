<#assign anio = "">
<#assign txtYearUnknown = "unknown" >
<#if ehuintellectualpropertyyearseparator?? && ehuintellectualpropertyyearseparator.ehuintellectualpropertyyear?? && ehuintellectualpropertyyearseparator.ehuintellectualpropertyyear.getData()??>
    <#assign anio = ehuintellectualpropertyyearseparator.ehuintellectualpropertyyear.getData()>
</#if>


<span class="intellectual-property">        

    <#if ehuintellectualpropertyresearches?? && ehuintellectualpropertyresearches.getData()?has_content >
        <span class="researcher">${ehuintellectualpropertyresearchers.getData()}.</span> 
    </#if>
        
    <#if ehuintellectualpropertytitle?? >    
        <#if ehuintellectualpropertytitle.ehutitlelang?? && ehuintellectualpropertytitle.ehutitlelang.getData()??>
            <#assign titleLang = ehuintellectualpropertytitle.ehutitlelang.getData()>
        </#if>
        <#if ehuintellectualpropertytitle.getData()?? >
            <#if titleLang?? && "upv-ehu-blank" != titleLang >
                <span lang="${titleLang}">
                    <span class="template-title">
                        <strong>"${ehuintellectualpropertytitle.getData()}"</strong>
                    </span>
                </span>
            <#else>
                <span class="template-title">
                    <strong>"${ehuintellectualpropertytitle.getData()}"</strong>
                </span>             
            </#if>
        </#if>
    </#if>
    <#assign type="">
    <#if ehuintellectualpropertytype?? && ehuintellectualpropertytype.getData()?? >
        <#if ehuintellectualpropertytype.getData() == "patent" >
            <#assign type=languageUtil.get(locale,"upv-ehu-patent")>
        <#elseif ehuintellectualpropertytype.getData() == "brand" >
            <#assign type = languageUtil.get(locale,"upv-ehu-brand")>
        <#elseif ehuintellectualpropertytype.getData() == "utility_model" >
            <#assign type = languageUtil.get(locale, "upv-ehu-model")>
        <#elseif ehuintellectualpropertytype.getData() == "copyright" >
            <#assign type = languageUtil.get(locale,"upv-ehu-copyright")>
        </#if>
    </#if>
    <#if type?? >
        <span class="intellectual-property-type"><em>${type}</em>.</span>
    </#if>
    
   <#if anio != "" && anio != txtYearUnknown >  
       <span class="publication-year">${anio}</span>                             
    </#if>
</span>