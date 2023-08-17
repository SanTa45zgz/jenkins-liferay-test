<#assign anio = ehuintellectualpropertyyearseparator.ehuintellectualpropertyyear.getData()>

<article class="intellectual-property"> 

    <header class="intellectual-property-title">
        
        <h1>
        	<#assign title = "" >
            <#if ehuintellectualpropertytitle??>
                <#assign title = ehuintellectualpropertytitle.getData()>
            </#if>
        	<#assign titleLang = "" >
            <#if ehuintellectualpropertytitle.ehutitlelang?? >
                <#assign titleLang = ehuintellectualpropertytitle.ehutitlelang.getData()>
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
        
    <dl>
        
        <#if ehuintellectualpropertytype.getData() != "other">
        	<#assign type="">
	        <#if ehuintellectualpropertytype.getData() == "patent" >
	            <#assign type = languageUtil.get(locale,"upv-ehu-patent")>
	        <#elseif  ehuintellectualpropertytype.getData() == "brand" >
	            <#assign type = languageUtil.get(locale,"upv-ehu-brand")>
	        <#elseif ehuintellectualpropertytype.getData() == "utility_model" >
	            <#assign type = languageUtil.get(locale, "upv-ehu-model")>
	        <#elseif ehuintellectualpropertytype.getData() == "copyright" >
	            <#assign type = languageUtil.get(locale,"upv-ehu-copyright") >
	        </#if>
	        <dt><@liferay.language key="ehu.type" />:</dt>
	        <dd>${type}</dd>
	    </#if>
                
        <#if ehuintellectualpropertyresearchers.getData()?has_content >
            <dt><@liferay.language key="ehu.researcher-s" />:</dt>
            <dd>${ehuintellectualpropertyresearchers.getData()}</dd>
        </#if>
                
       <#if ehuintellectualpropertyyearseparator?? && anio!="unknown" >  
            <dt><@liferay.language key="year" />:</dt>
            <dd>${anio}</dd>
        </#if>
                
        <#if ehuintellectualpropertydescription.getData()?has_content >
            <dt class="clear"><@liferay.language key="ehu.description" />:</dt>
            <#assign text_box_data = ehuintellectualpropertydescription.getData()>
            <dd>
            	<p>${(text_box_data?js_string)?replace("\\n", "</p><p>")}</p>
            </dd>
        </#if>
                
        <#if ehuintellectualpropertylink?? >
            <#assign link = ehuintellectualpropertylink >
            <#if ehuintellectualpropertylink.ehuintellectualpropertylinktitle?? && ehuintellectualpropertylink.ehuintellectualpropertylinktitle.getData()?? >
                <#assign link_title = ehuintellectualpropertylink.ehuintellectualpropertylinktitle.getData()>
            </#if>
            <#if ehuintellectualpropertylink.ehunewtab?? && ehuintellectualpropertylink.ehunewtab.getData()?? >
                <#assign link_new_window = getterUtil.getBoolean(ehuintellectualpropertylink.ehunewtab.getData())>
            </#if>
            <#assign formatedURL = "" >
            <#if ehuintellectualpropertylink?is_hash >
				<#assign aux = ehuintellectualpropertylink.getData() >
			<#else>
				<#assign aux = getterUtil.getString(ehuintellectualpropertylink) >
			</#if>
			<#if aux?has_content && aux != "">
				<#assign formatedURL = aux>
			</#if>    
            <#if ehuintellectualpropertylink.getData()?has_content >
                <dt><@liferay.language key="ehu.more-info-link" />:</dt>
                <#if formatedURL?? >
                    <#assign link_title_desc = formatedURL >
                    <#if link_title?? && link_title?has_content >
                        <#assign link_title_desc = link_title >
                    </#if>
                    <#if link_title_desc?? >
                        <dd class="link">
                            <#if link_new_window?? && link_new_window >
                                <a class="bullet bullet-url" href="${formatedURL}" target="_blank"><span class="hide-accessible"><@liferay.language key="opens-new-window" /></span> ${link_title_desc} <span class="icon-external-link"></span></a>
                            <#else>
                                <a class="bullet bullet-url" href="${formatedURL}">${link_title_desc}</a>
                            </#if>
                        </dd>
                    </#if>
                </#if>
            </#if>
        </#if>
    </dl>
</article>
