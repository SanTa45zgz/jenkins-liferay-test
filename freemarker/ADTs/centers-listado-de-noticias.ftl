<#assign groupLocalService = serviceLocator.findService("com.liferay.portal.kernel.service.GroupLocalService")>
<#assign layoutLocalService = serviceLocator.findService("com.liferay.portal.kernel.service.LayoutLocalService")>
<#if themeDisplay.getTheme().getContextPath() == "/o/upv-ehu-global-theme">
<#assign colorSchemeId = themeDisplay.getColorSchemeId() />
<#if colorSchemeId?has_content && colorSchemeId=="08">
	<#if entries?has_content>
    <div class="news_list-wrapper">
        <h2 class="title">${languageUtil.get(locale, "category.news")}</h2>
        <ul class="list-group news_list-list">
            <#list entries as entry>
                <#assign assetRenderer = entry.getAssetRenderer() />

                <#assign docXml = saxReaderUtil.read(entry.getAssetRenderer().getArticle().getContentByLocale(locale))/>
                <#assign pretitulo = docXml.valueOf("//dynamic-element[@name='ehupretitle']/dynamic-content/text()") />
                <#assign titulo = docXml.valueOf("//dynamic-element[@name='ehunewtitle']/dynamic-content/text()") />
                <#assign subtitulo = docXml.valueOf("//dynamic-element[@name='ehunewsubtitle']/dynamic-content/text()") />
                

                <#assign viewURL = assetPublisherHelper.getAssetViewURL(renderRequest, renderResponse, entry) />

                <#if assetLinkBehavior != "showFullContent">
                    <#assign viewURL = assetRenderer.getURLViewInContext(renderRequest, renderResponse, viewURL) />
                </#if>

                <li class="list-group-item news_list-item">
                    <a href="${viewURL}" class="news_list-link">
                        <@getMetadataField fieldName="publish-date" currentEntry=entry />

                        <#if titulo?has_content >
                             <p>${titulo}</p>
                        <#elseif titulo?has_content >
                            <p class="pretitle">${pretitulo}</p>
                        <#elseif subtitulo?has_content >
                            <p class="subtitle">${subtitulo}</p>
                        </#if>    
                    </a>
                </li>
            </#list>
            <#list portletPreferences?keys as key>
                <#assign values = portletPreferences[key] />
                
                <#if values?has_content>
                    <#if key == "paginationType">
                        <#list values as value>
                            <#if value == "none">
                                                                  
                                <li class="list-group-item news_list-item">                                       
									<#-- Se recupera la página de visualización del campo personalizado correspondiente del site -->										
									<#assign groupId = themeDisplay.getScopeGroupId()/>
									<#assign sitio = groupLocalService.fetchGroup(groupId)/>
									<#assign FriendlyPageNews = (sitio.getExpandoBridge().getAttribute("FriendlyPageNews"))!"">
									<#if FriendlyPageNews?has_content>																		
										<#assign friendlyURL = FriendlyPageNews?string />
										<#if friendlyURL?has_content >
											<#if layoutLocalService.fetchLayoutByFriendlyURL(groupId, false, friendlyURL)??>
												<#assign layout = layoutLocalService.fetchLayoutByFriendlyURL(groupId, false, friendlyURL)/>	
												<#if layout?? >																											
													<#assign urlLayout>${portalUtil.getLayoutFriendlyURL(layout, themeDisplay)}</#assign>																												
													<#if urlLayout?? >
														<a class="btn btn-more" href="${urlLayout}" role="button">${languageUtil.get(locale, "ehu-view-more")} <i class="fa fa-chevron-right" aria-hidden="true"></i></a>											
													</#if>							
												</#if>
											</#if>							
										</#if>
									</#if>
                                </li>																		
                            </#if>
                        </#list>
                    </#if>
                </#if>
            </#list>
        </ul>
    </div>
    </#if>
<#else>
   <div class="alert alert-error"> 
      <@liferay.language key="ehu.error.theme-color" />
   </div>
</#if>
<#else>
   <div class="alert alert-error"> 
      <@liferay.language key="ehu.error.theme-color" />
   </div>
</#if>

<#macro getMetadataField
                	fieldName currentEntry
                >
    	<span class="metadata-entry metadata-${fieldName}">
    	        <#assign localeStr = themeDisplay.getLocale() />  
    		    <#assign dateFormat = "dd MMMM" />
    		    <#if localeStr=='eu_ES'>
    		        <#assign dateFormat = "MMMM@ dd" />  
    		    <#elseif localeStr=='en_GB'>
    		        <#assign dateFormat = "MMMM dd" />                
    		    </#if>
    		
    		
    		<#if fieldName == "publish-date">
    		    <#assign fechaNoticia = dateUtil.getDate(currentEntry.publishDate?date, dateFormat, locale) />  
    			
    			<#if localeStr=='eu_ES'>
    		        <#assign dateFormat = "MMMM@ dd" />  
    		    <#elseif localeStr=='en_GB'>
    		        <#assign dateFormat = "MMMM dd" />                
    		    </#if>
    		    
    		    <#if localeStr=='eu_ES'>
                    ${fechaNoticia?replace("@", "K")}
                <#else>
                    ${fechaNoticia}
                </#if>
    			
    		</#if>
    	</span>
</#macro>

<#macro getEditIcon>
	<#if assetRenderer.hasEditPermission(themeDisplay.getPermissionChecker())>
		<#assign editPortletURL = assetRenderer.getURLEdit(renderRequest, renderResponse, windowStateFactory.getWindowState("NORMAL"), themeDisplay.getURLCurrent())!"" />

		<#if validator.isNotNull(editPortletURL)>
			<#assign title = languageUtil.format(locale, "edit-x", entryTitle, false) />

			<@liferay_ui["icon"]
				cssClass="icon-monospaced visible-interaction"
				icon="pencil"
				markupView="lexicon"
				message=title
				url=editPortletURL.toString()
			/>
		</#if>
	</#if>
</#macro>