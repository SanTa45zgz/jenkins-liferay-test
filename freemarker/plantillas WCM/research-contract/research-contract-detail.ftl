<article class="research-contract">
    <header class="research-contract-title">
        <h1>   
        	<#assign title = "" >
            <#if ehuresearchcontracttitle??>
                <#assign title = ehuresearchcontracttitle.getData()>
            </#if>
        	<#assign titleLang = "" >
            <#if ehuresearchcontracttitle.ehuresearchcontracttitlelang?? >
                <#assign titleLang = ehuresearchcontracttitle.ehuresearchcontracttitlelang.getData()>
            </#if>
            <#if titleLang != "" && title != "">
            	<span lang="${titleLang}">
            </#if>
            <#if title != "">
            	${title}
            </#if>
            <#if titleLang != "" && title != "">
            	</span>
            </#if>
        </h1>   
    </header>       
      
    <#assign company = "" >
    <#if ehuresearchcontractcompany??>
   		<#assign company = ehuresearchcontractcompany.getData()>
    </#if>
                
    <dl>
        <#if ehuresearchcontractresearcher?? && ehuresearchcontractresearcher.getData()?has_content >
            <dt><@liferay.language key="ehu.researcher-s" />:</dt>
            <dd>${ehuresearchcontractresearcher.getData()}</dd>
        </#if>
        <dt><@liferay.language key="company" /> / <@liferay.language key="ehu.center" />:</dt>
        <dd>${company}</dd>
        
        <#assign yearFrom = ""> 
        <#if ehuresearchcontractyearfrom??>
        	<#assign yearFrom = ehuresearchcontractyearfrom.getData()>
        </#if>
        <#assign yearTo = "">
        <#if ehuresearchcontractyeartoseparator.ehuresearchcontractyearto??>
			<#assign yearTo = ehuresearchcontractyeartoseparator.ehuresearchcontractyearto.getData()>
		</#if>
        <#if yearTo != "">
        
            <#if 'eu_ES' == themeDisplay.getLocale()>
				<dt><@liferay.language key="ehu.period" />:</dt> 
				<dd> ${yearFrom}<@liferay.language key="ehu.from" /> ${yearTo} <@liferay.language key="ehu.to" /></dd>      
			<#else>
				<dt><@liferay.language key="ehu.period" />:</dt> 
				<dd><@liferay.language key="ehu.from" /> ${yearFrom} <@liferay.language key="ehu.to" /> ${yearTo}</dd>    
			</#if>        
        <#else>
            <dt><@liferay.language key="year" />:</dt>
            <dd>${yearFrom}</dd>
        </#if>
        <#if ehuresearchcontractdescription?? && ehuresearchcontractdescription.getData()?has_content >
            <dt class="clear"><@liferay.language key="ehu.description" />:</dt>
            <#assign text_box_data = ehuresearchcontractdescription.getData()>
            <dd>
            	<p>${(text_box_data?js_string)?replace("\\n", "</p><p>")}</p>
			</dd>
        </#if>
    </dl>
</article>


