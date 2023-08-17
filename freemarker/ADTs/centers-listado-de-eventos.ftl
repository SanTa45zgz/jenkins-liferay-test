<#assign groupLocalService = serviceLocator.findService("com.liferay.portal.kernel.service.GroupLocalService")>
<#assign layoutLocalService = serviceLocator.findService("com.liferay.portal.kernel.service.LayoutLocalService")>
<#if themeDisplay.getTheme().getContextPath() == "/o/upv-ehu-global-theme">
<#assign colorSchemeId = themeDisplay.getColorSchemeId() />
<#if colorSchemeId?has_content && colorSchemeId=="08">
	<#if entries?has_content>
    <div class="news_list-wrapper">
        <h2 class="title">${languageUtil.get(locale, "centros.title.events")} </h2>
        <ul class="list-group news_list-list">
            <#list entries as entry>				
                <#assign assetRenderer = entry.getAssetRenderer() />

                <#assign docXml = saxReaderUtil.read(entry.getAssetRenderer().getArticle().getContentByLocale(locale))/>
                <#assign pretitulo = docXml.valueOf("//dynamic-element[@name='ehupretitle']/dynamic-content/text()") />
                <#assign titulo = docXml.valueOf("//dynamic-element[@name='ehutitle']/dynamic-content/text()") />
                <#assign subtitulo = docXml.valueOf("//dynamic-element[@name='ehunewsubtitle']/dynamic-content/text()") />
                
                <#assign viewURL = assetPublisherHelper.getAssetViewURL(renderRequest, renderResponse, entry) />

                <#if assetLinkBehavior != "showFullContent">
                    <#assign viewURL = assetRenderer.getURLViewInContext(renderRequest, renderResponse, viewURL) />
                </#if>
                <li class="list-group-item news_list-item">
                    <a href="${viewURL}" class="news_list-link">
                       
					<span class="metadata-entry metadata-publish-date">
					    
					    <#assign fechaInicio = docXml.valueOf("//dynamic-element[@name='ehustartdatehour']/dynamic-content/text()")!"" />
                        <#assign horaInicio = docXml.valueOf("//dynamic-element[@name='ehustartdatehourhh']/dynamic-content/text()")!""/>
                        <#assign minInicio = docXml.valueOf("//dynamic-element[@name='ehustartdatehourmm']/dynamic-content/text()")!"" />
                        <#assign fechaFin = docXml.valueOf("//dynamic-element[@name='ehuenddatehour']/dynamic-content/text()")!""/>
                        <#assign horaFin = docXml.valueOf("//dynamic-element[@name='ehuenddatehourhh']/dynamic-content/text()")!""/>
						<#assign minFin = docXml.valueOf("//dynamic-element[@name='ehuenddatehourmm']/dynamic-content/text()")!""/>
						<#assign showOnlyYearMonth = docXml.valueOf("//dynamic-element[@name='ehushowonlyyearmonth']/dynamic-content/text()")!""/>
						
												
						<#-- Cuando hay hora de inicio y hora de fin es un caso especial ya que hay que pintar primero los días y luego las horas -->
						<#if (fechaInicio?has_content || fechaFin?has_content) && (horaInicio?has_content || horaFin?has_content) && showOnlyYearMonth == "" >
							<#if fechaInicio?has_content >
								<@getDayAndMonth fecha=fechaInicio />
							</#if>
							<#if (fechaInicio?has_content && fechaFin?has_content) >
							  - 
							</#if>
							<#if fechaFin?has_content >
								<@getDayAndMonth fecha=fechaFin />
							</#if> 
							, <@getHourMin hora=horaInicio minutos=minInicio />
							<#if horaFin?has_content >
							  - <@getHourMin hora=horaFin minutos=minFin />
							</#if>											
						<#else>
							<#--fecha inicio -->																							
							<#if showOnlyYearMonth == "true">
								<@getyearmonth fecha=fechaInicio />
							<#else>
						    	<@getDateField fecha=fechaInicio hora=horaInicio minutos=minInicio />
							</#if>
														
							<#--fecha fin -->				
							<#if fechaFin?has_content >
								<#if showOnlyYearMonth == "true">
									- <@getyearmonth fecha=fechaFin />
								<#else>
									- <@getDateField fecha=fechaFin hora=horaFin minutos=minFin />
								</#if>							
							</#if>
						</#if>	
							 							
							
						
					</span>	 
					
					<#if pretitulo?has_content >
						<p class="pretitle">${pretitulo}</p>
					<#elseif titulo?has_content >
						<p>${titulo}</p>
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
									<#assign FriendlyPageEvents = (sitio.getExpandoBridge().getAttribute("FriendlyPageEvents"))!"">
									<#if FriendlyPageEvents?has_content>	
										<#assign friendlyURL = FriendlyPageEvents?string />
										<#if friendlyURL?has_content >										
											<#if layoutLocalService.fetchLayoutByFriendlyURL(groupId, false, friendlyURL)??>
												<#assign layout = layoutLocalService.fetchLayoutByFriendlyURL(groupId, false, friendlyURL)/>											
												<#if layout?? >																
													<#assign urlLayout>${portalUtil.getLayoutFriendlyURL(layout, themeDisplay)}</#assign>										
													<#if urlLayout?? >
														<a class="btn btn-more" href="${urlLayout}" role="button">
														${languageUtil.get(locale, "ehu-view-more")} <i class="fa fa-chevron-right" aria-hidden="true"></i>																																				
														</a>
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

<#macro getDateField fecha hora minutos >
    
		<#assign localeStr = themeDisplay.getLocale() />  
    	<#setting locale = localeStr>	
			<#-- Cuando la hora o el minuto es "00" Liferay devuelve "0" así que hay que arreglarlo -->
			<#if hora?has_content && hora == "0">
				<assign hora = "00">
			</#if>
			<#if minutos?has_content && minutos == "0">
				<assign minutos = "00">
			</#if>
    	
    		<#-- <#if fecha?has_content && (hora?has_content && minutos?has_content) && (hora!="0" || minutos!="0") > -->    	
			<#if fecha?has_content && (hora?has_content && minutos?has_content)>    	
    		    <#assign dateFull =   fecha+" "+hora+":"+minutos />
    		    <#assign dateFormat = "dd MMMM, HH:mm" />
        		<#if localeStr=='eu_ES'>
        		     <#assign dateFormat = "MMMM@ dd, HH:mm" />  
        		<#elseif localeStr=='en_GB'>
        		     <#assign dateFormat = "MMMM dd, HH:mm" />                
        		</#if>
        		<#setting date_format=dateFormat>
        		<#if dateFull?has_content>
                    <#assign dateFull = (dateFull?datetime("yyyy-MM-dd HH:mm"))?date>
                </#if>
    		    <#else>  
    		        <#assign dateFormat = "dd MMMM" />
                	<#if localeStr=='eu_ES'>
                	    <#assign dateFormat = "MMMM@ dd" />  
                	<#elseif localeStr=='en_GB'>
                	     <#assign dateFormat = "MMMM dd" />                
                	</#if>	
                	<#setting date_format=dateFormat>		
                	<#if fecha?has_content >
                        <#assign dateFull = (fecha?datetime("yyyy-MM-dd"))?date>
                    </#if>
    		    </#if>    		                    
    		
			<#if dateFull?has_content >
        		<#assign modifiedStr = dateFull?string>
                <#if localeStr=='eu_ES'>
                    ${modifiedStr?replace("@", "K")}
                <#else>
                    ${modifiedStr}
                </#if>			
            </#if>
</#macro>

<#macro getyearmonth fecha >    
		<#assign localeStr = themeDisplay.getLocale() />  
    	<#setting locale = localeStr>
    	
			<#if fecha?has_content >    	
    		    <#assign dateFull =   fecha />
    		    <#assign dateFormat = "MMMM" />        		
        		<#setting date_format=dateFormat>
        		<#if dateFull?has_content>
                    <#assign dateFull = (dateFull?datetime("yyyy-MM-dd"))?date>
                </#if>
			<#else>  
				<#assign dateFormat = "MMMM" />				
				<#setting date_format=dateFormat>		
				<#if fecha?has_content >
					<#assign dateFull = (fecha?datetime("yyyy-MM-dd"))?date>
				</#if>
			</#if>    		                    
    		
			<#if dateFull?has_content >
        		<#assign modifiedStr = dateFull?string>
                	${modifiedStr}                			
            </#if>
</#macro>

<#macro getHourMin hora minutos >
    
		<#assign localeStr = themeDisplay.getLocale() />  
    	<#setting locale = localeStr>	
			<#-- Cuando la hora o el minuto es "00" Liferay devuelve "0" así que hay que arreglarlo -->
			<#if hora?has_content && hora == "0">
				<assign hora = "00">
			</#if>
			<#if minutos?has_content && minutos == "0">
				<assign minutos = "00">
			</#if>
    	    		    	
			<#if hora?has_content && minutos?has_content>    	
    		    <#assign dateFull = hora+":"+minutos />
    		    <#assign dateFormat = "HH:mm" />
        		<#setting date_format=dateFormat>
        		<#if dateFull?has_content>
                    <#assign dateFull = (dateFull?datetime("HH:mm"))?date>
                </#if>
    		    <#else>  
    		        <#assign dateFormat = "HH:mm" />
                	<#setting date_format=dateFormat>		
                	<#if fecha?has_content >
                        <#assign dateFull = (fecha?datetime("HH:mm"))?date>
                    </#if>
    		    </#if>    		                    
    		
			<#if dateFull?has_content >
        		<#assign modifiedStr = dateFull?string>
                <#if localeStr=='eu_ES'>
                    ${modifiedStr?replace("@", "K")}
                <#else>
                    ${modifiedStr}
                </#if>			
            </#if>
</#macro>

<#macro getDayAndMonth fecha >    
		<#assign localeStr = themeDisplay.getLocale() />  
    	<#setting locale = localeStr>	
    		    	
			<#if fecha?has_content>    	
    		    <#assign dateFull =   fecha />
    		    <#assign dateFormat = "dd MMMM" />
        		<#if localeStr=='eu_ES'>
        		     <#assign dateFormat = "MMMM@ dd" />  
        		<#elseif localeStr=='en_GB'>
        		     <#assign dateFormat = "MMMM dd" />                
        		</#if>
        		<#setting date_format=dateFormat>
        		<#if dateFull?has_content>
                    <#assign dateFull = (dateFull?datetime("yyyy-MM-dd"))?date>
                </#if>
    		    <#else>  
    		        <#assign dateFormat = "dd MMMM" />
                	<#if localeStr=='eu_ES'>
                	    <#assign dateFormat = "MMMM@ dd" />  
                	<#elseif localeStr=='en_GB'>
                	     <#assign dateFormat = "MMMM dd" />                
                	</#if>	
                	<#setting date_format=dateFormat>		
                	<#if fecha?has_content >
                        <#assign dateFull = (fecha?datetime("yyyy-MM-dd"))?date>
                    </#if>
    		    </#if>    		                    
    		
			<#if dateFull?has_content >
        		<#assign modifiedStr = dateFull?string>
                <#if localeStr=='eu_ES'>
                    ${modifiedStr?replace("@", "K")}
                <#else>
                    ${modifiedStr}
                </#if>			
            </#if>
</#macro>