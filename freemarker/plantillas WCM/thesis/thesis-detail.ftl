<#assign formatedURLTitle = languageUtil.get(locale, "opens-new-window")>
<#-- nuevo código para gestionar el año -->
<#assign txtYearUnknown = "unknown" >
<#assign thesisYear = "" >
<#if ehuthesisyearseparator??>
	<#if ehuthesisyearseparator.ehuthesisyear?? >
		<#assign thesisYear = ehuthesisyearseparator.ehuthesisyear.getData() >
	</#if>
</#if>
<#if thesisYear == txtYearUnknown >
	<#assign txtThesisYear = languageUtil.get(  locale , "unknown" )?lower_case>
<#else>
	<#assign txtThesisYear = thesisYear >
</#if>

<#assign showYear =  thesisYear != ""  && thesisYear != txtYearUnknown >
<#-- nuevo código para gestionar el año -->


<article class="thesis">
    <header class="thesis-title">
        <h1>
        
        	<#assign title = "" >
            <#if ehuthesistitle??>
                <#assign title = ehuthesistitle.getData()>
            </#if>
        	<#assign titleLang = "" >
            <#if ehuthesistitle.ehutitlelang?? >
                <#assign titleLang = ehuthesistitle.ehutitlelang.getData()>
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
            <#if ehuthesisphd?? && ehuthesisphd.getData()?has_content >
                <dt><@liferay.language key="ehu.doctoral-student" />:</dt>
                <dd>${ehuthesisphd.getData()}</dd>
            </#if>
            <#if showYear >
				<dt><@liferay.language key="year" />:</dt>
				<dd>${txtThesisYear}</dd>
			</#if>	
            <#if ehuthesisuniversity?? && ehuthesisuniversity.getData()?has_content >
                <dt><@liferay.language key="ehu.university" />:</dt>
                <dd>${ehuthesisuniversity.getData()}</dd>
            </#if>    

            <#if ehuthesisdirector?? && ehuthesisdirector.getData()?has_content >
                <dt><@liferay.language key="ehu.director-s" />:</dt>
                <dd>${ehuthesisdirector.getData()}</dd>
            </#if>    
            
            <#if ehuthesisdescription?? && ehuthesisdescription.getData()?has_content >
                <dt class="clear"><@liferay.language key="ehu.description" />:</dt>
                    <#assign text_box_data = ehuthesisdescription.getData()>
                    <#if text_box_data?? >
                        <dd><p>${(text_box_data?js_string)?replace("\\n", "</p><p>")}</p></dd>
                    </#if>
                </#if>
                <#if ehuthesislink?? >
                    <#assign link = ehuthesislink >
                    <#if ehuthesislink.ehuthesislinktitle?? && ehuthesislink.ehuthesislinktitle.getData()?? >
                        <#assign link_title= ehuthesislink.ehuthesislinktitle.getData()>
                    </#if>
                    <#if ehuthesislink.ehunewtab?? && ehuthesislink.ehunewtab.getData()?has_content >
                        <#assign link_new_window= getterUtil.getBoolean(ehuthesislink.ehunewtab.getData())>
                    </#if>
                    
                    <#assign formatedURL = "" >
                    <#if ehuthesislink?is_hash >
						<#assign aux = ehuthesislink.getData() >
					<#else>
						<#assign aux = getterUtil.getString(ehuthesislink) >
					</#if>
					<#if aux?has_content && aux != "">
						<#assign formatedURL = aux>
					</#if>
                    
                    <#if ehuthesislink.getData()?has_content >
                        <dt><@liferay.language key="ehu.more-info-link" />:</dt>
                            <#if formatedURL?? >
                                <#assign link_title_desc = formatedURL >
                                <#if link_title?has_content >
                                    <#assign link_title_desc = link_title >
                                </#if>
                                <#if link_title_desc?? >
                                    <dd class="link">
                                        <#if link_new_window?? && link_new_window >
                                            <a class="bullet bullet-url" href="${formatedURL}" target="_blank">
                                                <span class="hide-accessible"><@liferay.language key="opens-new-window" />
                                                </span> ${link_title_desc} <span class="icon-external-link"></span></a>
                                        <#else>
                                            <a class="bullet bullet-url" href="${formatedURL}">${link_title_desc}</a>
                                        </#if>
                                    </dd>   
                                </#if>
                            </#if>
                    </#if>     
                </#if>
                <#if ehuthesisdocument?? && ehuthesisdocument.getData()?has_content >
                    <#assign formatedDocument="" >
                    <#if ehuthesisdocument.getData()?contains("/")>
                        <dt><@liferay.language key="ehu.related-document" />:</dt>
                        <#assign documentTitleField = 'ehuthesisdocumenttitle'>
                        <@upvlibs.formatAttachment documentField=ehuthesisdocument documentTitleField=documentTitleField />
                            <#assign formatedDocument = upvlibs.formatedDocument >
                            <#if formatedDocument?? >
                                <dd class="document">${formatedDocument}</dd>   
                            </#if>
                    </#if>
                </#if>
                
                <#if ehumention?? && ehumention.getData()?? && ehumention.getData()!= "upv-ehu-blank" && !validator.isBlank(ehumention.getData())>
                    <dt><@liferay.language key="ehu.mention" />:</dt>
                    <dd><@liferay.language key="${ehumention.getData()}" /></dd>
                </#if>                    
                <#if ehuphdextraaward?? && ehuphdextraaward.getData()?? >
                    <#assign isExtraAward = getterUtil.getBoolean(ehuphdextraaward.getData())>
                </#if>
                <#if isExtraAward?? && isExtraAward >
                    <dt><@liferay.language key="ehu.merits" />:</dt>
                    <dd><@liferay.language key="ehu.phd-extra-award" /></dd>
                </#if>
        </dl>
</article>
