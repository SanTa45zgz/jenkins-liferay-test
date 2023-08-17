<#if themeDisplay.getTheme().getContextPath() == "/o/upv-ehu-global-theme">
    <#assign colorSchemeId = themeDisplay.getColorSchemeId() />
    <#if colorSchemeId?has_content &&  colorSchemeId=="08" >  
        <div class="alert alert-error"> 
            <@liferay.language key="ehu.error.theme-color" />
        </div>
    <#else>
		<div class="buttons-content">
			<#if ehubuttonstitle.getData()?has_content>
				<h2 class="buttons-content__title">${ehubuttonstitle.getData()}</h2>
		    </#if>
			<div class="buttons-content__documents-links">
				<ul>
					<#if ehuattachments.ehuinfoattachmentdocument.getSiblings()?has_content>
				    	<#list ehuattachments.ehuinfoattachmentdocument.getSiblings() as cur_ehuattachments_ehuinfoattachmentdocument>
				        	<#if cur_ehuattachments_ehuinfoattachmentdocument.getData()?has_content>
				            	<li>
				            		<a href="${cur_ehuattachments_ehuinfoattachmentdocument.getData()}" target="_blank" class="c-button c-button--primary c-button--icon-right ">
				            			<span class="hide-accessible"><@liferay.language key="opens-new-window" /></span>
				    					<span>${cur_ehuattachments_ehuinfoattachmentdocument.ehuinfoattachmentdocumenttitle.getData()}</span>
				    					<span class="icon-external-link"></span>
				            		</a>
				            	</li>
				            </#if>
				    	</#list>
				    </#if>
		
				    <#assign aviso = "" />
					<#assign enlace = "_self" />
				    
				    <#if ehuattachments.ehuinfoattachmenturl.getSiblings()?has_content>
				    	<#list ehuattachments.ehuinfoattachmenturl.getSiblings() as cur_ehuattachments_ehuinfoattachmenturl>
				    		<#if cur_ehuattachments_ehuinfoattachmenturl.getData()?has_content>
				    		    <#if cur_ehuattachments_ehuinfoattachmenturl.ehuinfoattachmenturlnewtab.getData() == 'true' >
									<#assign enlace = "_blank" />
									<#assign aviso = '<span class="hide-accessible">'+languageUtil.get( locale, "opens-new-window" ) + "</span>" />
								</#if>
				        		<li>
				        		    <a href="${cur_ehuattachments_ehuinfoattachmenturl.getData()}" target="${enlace}" class="c-button c-button--primary c-button--icon-right">
				        		    	${aviso}
				        		        ${cur_ehuattachments_ehuinfoattachmenturl.ehuinfoattachmenturltitle.getData()}<i class="icon-angle-right"></i>
				                    </a>
				        		</li>
				    		</#if>
				    	</#list>
				    </#if>
		    	</ul>
			</div>
		</div>
	</#if>
<#else>
   <div class="alert alert-error"> 
      <@liferay.language key="ehu.error.theme-color" />
   </div>
</#if>
