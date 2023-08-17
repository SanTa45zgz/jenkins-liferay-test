<#--
Nombre contenido (ES): Proyecto de investigación
Estructura: global > research-project.json
Plantilla (ES): Contenido Completo
URL: https://dev74.ehu.eus/es/web/pruebas/proyecto
Nota: Se usa con global-theme y con ehu-theme
-->

<#assign formatedURLTitle = languageUtil.get(locale, "opens-new-window")>

<article class="research-project">
	<header class="research-project-title">
		<h1>
		
			<#assign title = "" >
            <#if ehuresearchprojecttitle??>
                <#assign title = ehuresearchprojecttitle.getData()>
            </#if>
        	<#assign titleLang = "" >
            <#if ehuresearchprojecttitle.ehuresearchprojecttitlelang?? >
                <#assign titleLang = ehuresearchprojecttitle.ehuresearchprojecttitlelang.getData()>
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
		<#if ehuresearchprojectresearcher.getData()?has_content >
			<dt><@liferay.language key="ehu.researcher-s" />:</dt>
			<dd>${ehuresearchprojectresearcher.getData()}</dd>
		</#if>
	
		 
		<#assign yearFrom = ""> 
        <#if ehuresearchprojectdatafrom??>
        	<#assign yearFrom = ehuresearchprojectdatafrom.getData()>
        </#if>
        <#assign yearTo = "">
        <#if ehuresearchprojectdatatoseparator.ehuresearchprojectdatato??>
			<#assign yearTo = ehuresearchprojectdatatoseparator.ehuresearchprojectdatato.getData()>
		</#if>
        <#if yearTo != "">
		     <#if 'eu_ES'== themeDisplay.getLocale() >
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
			
		<dt><@liferay.language key="ehu.financing-entity" />:</dt>
		<#list ehuresearchprojectfinancial.getSiblings() as entity >
			<dd>${entity.getData()}
				<#if entity?? && entity.ehuresearchprojectimage?? && entity.ehuresearchprojectimage.getData()?has_content >
					<figure>   
						<#assign image_description = entity.ehuresearchprojectimage.ehuresearchprojectimagealttext.getData()>
						<#if image_description?has_content >
							<img alt='${image_description}' src='${entity.ehuresearchprojectimage.getData()}'/>
						<#else>
							<img alt='' src='${entity.ehuresearchprojectimage.getData()}'/>
						</#if>           
					</figure>
				</#if>
			</dd>
		</#list>
		
		<#if ehuresearchprojectamount.getData()?has_content >
			<dt><@liferay.language key="ehu.total-amount" />:</dt>
			<dd>${ehuresearchprojectamount.getData()}</dd>
		</#if> 
	
		<#if ehuresearchprojectdescription.getData()?has_content >
			<dt class="clear"><@liferay.language key="ehu.description" />:</dt>
			<#assign text_box_data = ehuresearchprojectdescription.getData() >
			<dd>
				<p>${text_box_data?replace("\n", "</p><p>")}</p>
            </dd>                         
		</#if>
			
		<#assign link = ehuresearchprojectlink >
		<#if ehuresearchprojectlink?? && ehuresearchprojectlink.ehuresearchprojectlinktitle?? && ehuresearchprojectlink.ehuresearchprojectlinktitle.getData()??>
		    <#assign link_title= ehuresearchprojectlink.ehuresearchprojectlinktitle.getData()>
		</#if>
		<#if ehuresearchprojectlink?? && ehuresearchprojectlink.ehunewtab?? && ehuresearchprojectlink.ehunewtab.getData()??>
	        <#assign link_new_window= getterUtil.getBoolean(ehuresearchprojectlink.ehunewtab.getData())>
	   </#if>
	    <#assign formatedURL = "" >
	    <#if ehuresearchprojectlink?is_hash >
			<#assign aux = ehuresearchprojectlink.getData() >
		<#else>
			<#assign aux = getterUtil.getString(ehuresearchprojectlink) >
		</#if>
		<#if aux?has_content && aux != "">
			<#assign formatedURL = aux>
		</#if>

			
		<#if ehuresearchprojectlink.getData()?has_content >
			<dt><@liferay.language key="ehu.more-info-link" />:</dt>
			<#assign link_title_desc = formatedURL>
			<#if link_title?has_content >
				<#assign link_title_desc = link_title>
			</#if>
			<dd class="link">
				<#if link_new_window?? && link_new_window >
					<a class="bullet bullet-url" href="${formatedURL}" target="_blank">
					    <span class="hide-accessible"><@liferay.language key="opens-new-window" /></span> 
					    ${link_title_desc}
					    <span class="icon-external-link"></span>
					</a>
				<#else>
					<a class="bullet bullet-url" href="${formatedURL}">${link_title_desc}</a>
				</#if>
			</dd>                   
		</#if>     
			
		<#if ehudocument?? && ehudocument.getData()?has_content >
			<#assign formatedDocument="">
			<#if ehudocument.getData()?contains("/") >
				<dt><@liferay.language key="ehu.related-document" />:</dt>
				<#assign documentTitleField = 'ehudocumenttitle'>
				<@upvlibs.formatAttachment documentField=ehudocument documentTitleField=documentTitleField />
				    <#assign formatedDocument = upvlibs.formatedDocument >
				<dd class="document">${formatedDocument}</dd>   
			</#if>
		</#if>
	</dl>				
</article>