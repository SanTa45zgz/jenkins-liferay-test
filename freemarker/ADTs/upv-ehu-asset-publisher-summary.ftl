<#assign liferay_ui = taglibLiferayHash["/META-INF/liferay-ui.tld"] />

<#-- ---------- UPV/EHU  -------- -->
<#-- Identificador de contenido dentro del publicador. Por defecto empieza en 0, excepto si hay filtrado por categoria o si se ignora el parametro compartido "categoryId", lo que supone no destacar el primer contenido del listado -->
<#assign itemNumber = 0 />

<#assign journalArticleLocalService = serviceLocator.findService("com.liferay.journal.service.JournalArticleLocalService") />

<ul class="asset-list asset-list-summary">
<#-- ---------- UPV/EHU - UPV/EHU ---------- -->
    <#list entries as entry>

	<#assign entry = entry />
	
	<#assign assetRenderer = entry.getAssetRenderer() />
	
	<#assign entryTitle = htmlUtil.escape(assetRenderer.getTitle(locale)) />
        
	<#assign viewURL = assetPublisherHelper.getAssetViewURL(renderRequest, renderResponse, entry) />
	
	<#--- UPV/EHU - UPV/EHU   --->
	<#--- Si el contenido web tiene página de visualización (página detalle) se hará uso de la friendly URL--->
	<#if assetRenderer?has_content && assetRenderer.getArticle??>
	    <#assign journalArticle = assetRenderer.getArticle() />
	    <#if journalArticle?has_content>
	        <#assign layoutUuid = journalArticle.getLayoutUuid() />
	       	<#if layoutUuid?has_content >
        		<#assign urlViewContext = assetRenderer.getURLViewInContext(renderRequest, renderResponse, viewURL) />
        		<#assign viewURL = urlViewContext />
        	</#if> 
	    </#if>
	</#if>
	
	
	
	<#-- ---------- UPV/EHU  -------- -->
	<#-- Si la URL para mostrar el contenido completo es de la parte publica del sitio web guest se quita de la URL -->
	<#assign guestPublicSiteURL = "/web/guest" />
	<#if viewURL?contains(guestPublicSiteURL) >
            <#assign viewURL = viewURL?replace(guestPublicSiteURL, "") />
	</#if>
	
            <li class="asset-summary item-${itemNumber}">
		<div class="lfr-meta-actions asset-actions">
			<@getEditIcon />
		</div>

		<#-- ---------- UPV/EHU  -------- -->
		<#-- Si el publicador muestra solo contenidos, se muestra cada contenido con la plantilla summary correspondiente al tipo del contenido si existe dicha plantilla, sino aparece mensaje de error -->
		
		<#assign journalArticleClass = "com.liferay.journal.model.JournalArticle" />
		<#assign ddmTemplateKey = 0 />
		
		<#if assetRenderer.getClassName() == journalArticleClass >
                        <#assign journalArticle = assetRenderer.getArticle() />
                        <#assign structureIdStr = journalArticle.getDDMStructureKey() />
                        <#assign globalGroupId = themeDisplay.getCompanyGroupId() />
                        <#assign localGroupId = themeDisplay.getSiteGroupId() />
                        <#assign classNameId = portalUtil.getClassNameId(journalArticleClass)/>
                        <#assign ddmStructureLocalService = serviceLocator.findService("com.liferay.dynamic.data.mapping.service.DDMStructureLocalService") />
                        
                    <#-- se controla la excepcion que puede producirse al intentar recuperar una estructura que no está en global, forzando así, que en este caso, se ejecute la recuperación de la estructura en el site local -->					
                        <#-- Si existe la estructura/tipo de contenido en el ambito Global -->
                        <#if ddmStructureLocalService.fetchStructure(globalGroupId,classNameId,structureIdStr)?? >                            
                            <#assign ddmStructure = ddmStructureLocalService.fetchStructure(globalGroupId,classNameId,structureIdStr) />
                        </#if>
                        
                        <#-- Si existe la estructura/tipo de contenido en el ambito Local -->    
                            <#-- Si existe la estructura/tipo de contenido en el ambito Local -->    
                            <#if !ddmStructure?? && ddmStructureLocalService.fetchStructure(localGroupId,classNameId,structureIdStr)??>
                                <#assign ddmStructure = ddmStructureLocalService.fetchStructure(localGroupId,classNameId,structureIdStr) />
                            </#if>     
                    
                        <#-- Si existe la estructura/tipo de contenido -->
                        <#if ddmStructure?? > 
                            <#assign templateName = "Summary" />
                            <#assign ddmTemplates = ddmStructure.getTemplates() />
                            <#-- ---------- Si la estructura/tipo de contenido tiene asociadas plantillas/visualizaciones -->
                            <#assign isCall = false />
                            <#assign isOutStanding = false />
			    <#assign isHelp = false />
                            <#if (ddmTemplates??)>                               
                                <#list ddmTemplates as ddmTemplate>                                   
                                    <#-- Si la plantilla/visualizacion es de tipo resumen -->
                                    <#if ddmTemplate.getName()?contains("Summary") || ddmTemplate.getName()?contains("Laburpena") || ddmTemplate.getName()?contains("Resumen") >
                                        <#assign ddmTemplateKeyStr = ddmTemplate.getTemplateKey()/>
                                        <#assign ddmTemplateKey = getterUtil.getLongStrict(ddmTemplateKeyStr)/>    
                                    </#if>    
                                    <#if ddmStructure.getName()?contains("Call")>
                                    	 <#assign isCall = true />
			                        <#elseif ddmStructure.getName()?contains("Outstanding")>
	                                    		<#assign isOutStanding = true />										
						<#elseif ddmStructure.getName()?contains("Subvention")>
	                                    	 	<#assign isHelp = true />		
						</#if>   
                                </#list>
                            </#if>
                            
                            <#-- Si existe la plantilla de nombre Summary -->
                            <#if (ddmTemplateKey != 0)>
								<#if isCall>
									<#assign document = saxReaderUtil.read(journalArticle.getContentByLocale(locale)) />
									<#assign phases = document.getRootElement().selectNodes("//dynamic-element[@name='ehuphases']") />
									<#assign infoStateUrl = '' />
									<#assign provisionalStateUrl = '' />
									<#assign finalStateUrl = '' />
									<#assign ref = '' />
									<#list phases as phase>
										<#assign subfields = phase.elements("dynamic-element")>
										<#list subfields as subfield >
											<#if subfield.attributeValue("name") == "ehuinfostate">
												 <#if (subfield.elements("dynamic-element")??)>
													<#assign subfields2 = subfield.elements("dynamic-element")>
													<#list subfields2 as subfield2 >
														<#if subfield2.attributeValue("name") == "ehuinfostateurl">
															<#assign infoStateUrl = subfield2.elementText("dynamic-content") /> 
														</#if>
													</#list><#-- list subfields2 -->
												</#if>
											<#elseif subfield.attributeValue("name") == "ehuprovisionalstate">
												<#if (subfield.elements("dynamic-element")??)>
													<#assign subfields2 = subfield.elements("dynamic-element")>
													<#list subfields2 as subfield2 >	
														<#if subfield2.attributeValue("name") == "ehuprovisionalstateurl">
															<#assign provisionalStateUrl = subfield2.elementText("dynamic-content") /> 
														</#if>
													</#list><#-- list subfields2 -->
												</#if>
											<#elseif subfield.attributeValue("name") == "ehufinalstate">
												 <#if (subfield.elements("dynamic-element")??)>
													<#assign subfields2 = subfield.elements("dynamic-element")>
													<#list subfields2 as subfield2 >
														<#if subfield2.attributeValue("name") == "ehufinalstateurl">
															<#assign finalStateUrl = subfield2.elementText("dynamic-content") /> 
														</#if>
													</#list><#-- list subfields2 -->
												</#if>
											</#if><#-- if subfield -->
										</#list><#-- list subfields -->
									</#list> <#-- list phases -->
									
									<#if infoStateUrl?? && !validator.isBlank(infoStateUrl)>
										<#assign ref = infoStateUrl /> 
									</#if><#--  infoUrl -->
									<#if provisionalStateUrl?? && !validator.isBlank(provisionalStateUrl)>
										<#assign ref = provisionalStateUrl /> 
									</#if><#--  provisionalUrl -->
									<#if finalStateUrl?? && !validator.isBlank(finalStateUrl)>
										<#assign ref = finalStateUrl /> 
									</#if><#--  finalUrl -->

									<#assign protocol = "http">
									<#if request?? && request?contains("https")>
										<#assign protocol = "https">
									</#if>
									<#assign refProtocol = "http">
									<#if ref?? && ref?contains("https")>
										<#assign refProtocol = "https">
									</#if>
									<#if ref?? && !validator.isBlank( ref )>
										<#if refProtocol??>
											<#if ref?contains( refProtocol )>
												<#assign viewURL = ref/>
											<#else>
												<#assign viewURL = refProtocol + "://" + ref/>
											</#if>
										<#else>
											<#assign viewURL =  protocol + "://" + ref/>
										</#if>
									</#if>

								</#if><#-- if call -->
								
								<#assign assetObject = assetRenderer.getAssetObject()/>
								<#if !isOutStanding >
									<a href="${viewURL}">
								</#if>
								
									
										
									<#assign articleContent = journalArticleLocalService.getArticleContent(assetObject, ddmTemplateKeyStr,"VIEW", locale, null, themeDisplay) >
									
									<#-- Se controla que exista el article -->
                                    <#if journalArticleLocalService.fetchDisplayArticle(assetObject.getGroupId(),journalArticle.getArticleId())?? >    
										
										
										<#-- Cambio para que el nombre del link en el publicador no sea demasiado grande y salte error de accesibilidad en informe del ministerio.
										En los contenidos Ayuda pintamos ahora solo el título para no pintar un texto demasiado largo en el link. El resto lo pintamos tras cerrar el link -->
										<#if isHelp>
											<#assign document = saxReaderUtil.read(journalArticle.getContentByLocale(locale)) />											
											<#assign fieldEhutitle = "//dynamic-element[@name='ehutitle']" />
											<#assign ehutitle = document.valueOf( fieldEhutitle + "/dynamic-content/text()" ) />
											${ehutitle}
											
											
										<#else>
											${articleContent}											
										</#if>	 
										 
                                    </#if>
										
								<#if !isOutStanding >
									</a>
									<#if isHelp>
										${articleContent}
									</#if>	
								</#if>
                                   
                           	<#-- Si NO existe la plantilla de nombre Summary mensaje de error -->
                            <#else>    
                                <div class="alert alert-error"> ${ddmStructure.getNameCurrentValue()} <@liferay.language key="ehu.error.structure-has-no-summary-template-select-another-template" /></div>
                            </#if>    
                            
                            <@getMetadataField fieldName="tags" />

                            <@getMetadataField fieldName="create-date" />

                            <@getMetadataField fieldName="view-count" />

                            <@getMetadataField fieldName="author" />

                            <@getRatings />

                            <@getRelatedAssets />

                            <@getDiscussion />
                     </#if>
                 <#assign itemNumber = itemNumber + 1 />     
                
                <#-- ---------- UPV/EHU - UPV/EHU ---------- -->        
                <#else>
                    <h3 class="asset-title">
                        <#if assetRenderer?has_content && assetRenderer.getIconPath?has_content>        
                            <a href="${viewURL}"><img alt="" src="${assetRenderer.getIconPath(renderRequest)}" />${entryTitle}</a>
                        </#if>
                        </h3>

                        <@getMetadataField fieldName="tags" />

                        <@getMetadataField fieldName="create-date" />

                        <@getMetadataField fieldName="view-count" />

                        <div class="asset-content">
                                <@getSocialBookmarks />

                                <div class="asset-summary">
                                        <@getMetadataField fieldName="author" />
                                        
                                       
                                        ${htmlUtil.escape(assetRenderer.getSummary(renderRequest, renderResponse))}
                                        
                                        <a href="${viewURL}"><@liferay.language key="read-more" /><span class="hide-accessible"><@liferay.language key="about" />${entryTitle}</span> &raquo;</a>
                                </div>

                                <@getRatings />

                                <@getRelatedAssets />

                                <@getDiscussion />
                        </div>
                </#if>
		
	</li>
    </#list>
</ul>

<#macro getDiscussion >
	<#if assetRenderer?? &&  assetRenderer.getDiscussionPath()?? && (enableComments == "true")>
		<br />

		<#assign discussionURL = renderResponse.createActionURL() />

		${discussionURL.setParameter("struts_action", "/asset_publisher/" + assetRenderer.getDiscussionPath())}

		<@liferay_ui["discussion"]
			className=entry.getClassName()
			classPK=entry.getClassPK()
			formAction=discussionURL?string
			formName="fm" + entry.getClassPK()
			ratingsEnabled=enableCommentRatings == "true"
			redirect=portalUtil.getCurrentURL(request)
			userId=assetRenderer.getUserId()
		/>
	</#if>
</#macro>

<#macro getEditIcon>
	<#if assetRenderer.hasEditPermission(themeDisplay.getPermissionChecker())>
		<#assign editPortletURL = assetRenderer.getURLEdit(renderRequest, renderResponse, windowStateFactory.getWindowState("NORMAL"), themeDisplay.getURLCurrent())!"" />

		<#if validator.isNotNull(editPortletURL)>
			<#assign title = languageUtil.format(locale, "edit-x", entryTitle) />

			<@liferay_ui["icon"]
				image="edit"
				message=title
				url=editPortletURL.toString()
			/>
		</#if>
	</#if>
</#macro>

<#macro getFlagsIcon>
	<#if enableFlags == "true">
		<@liferay_ui["flags"]
			className=entry.getClassName()
			classPK=entry.getClassPK()
			contentTitle=entry.getTitle(locale)
			label=false
			reportedUserId=entry.getUserId()
		/>
	</#if>
</#macro>

<#macro getMetadataField
	fieldName
>
	<#if stringUtil.split(metadataFields)?seq_contains(fieldName)>
		<span class="metadata-entry metadata-${fieldName}">
			<#assign dateFormat = "dd MMM yyyy - HH:mm:ss" />

			<#if fieldName == "author">
				<@liferay.language key="by" /> ${portalUtil.getUserName(assetRenderer.getUserId(), assetRenderer.getUserName())}
			<#elseif fieldName == "categories">
				<@liferay_ui["asset-categories-summary"]
					className=entry.getClassName()
					classPK=entry.getClassPK()
					portletURL=renderResponse.createRenderURL()
				/>
			<#elseif fieldName == "create-date">
				${dateUtil.getDate(entry.getCreateDate(), dateFormat, locale)}
			<#elseif fieldName == "expiration-date">
				${dateUtil.getDate(entry.getExpirationDate(), dateFormat, locale)}
			<#elseif fieldName == "modified-date">
				${dateUtil.getDate(entry.getModifiedDate(), dateFormat, locale)}
			<#elseif fieldName == "priority">
				${entry.getPriority()}
			<#elseif fieldName == "publish-date">
				${dateUtil.getDate(entry.getPublishDate(), dateFormat, locale)}
			<#elseif fieldName == "tags">
				<@liferay_ui["asset-tags-summary"]
					className=entry.getClassName()
					classPK=entry.getClassPK()
					portletURL=renderResponse.createRenderURL()
				/>
			<#elseif fieldName == "view-count">
				<@liferay_ui["icon"]
					image="history"
				/>

				${entry.getViewCount()} <@liferay.language key="views" />
			</#if>
		</span>
	</#if>
</#macro>

<#macro getPrintIcon>
	<#if enablePrint == "true" >
		<#assign printURL = renderResponse.createRenderURL() />

		${printURL.setParameter("struts_action", "/asset_publisher/view_content")}
		${printURL.setParameter("assetEntryId", entry.getEntryId()?string)}
		${printURL.setParameter("viewMode", "print")}
		${printURL.setParameter("type", entry.getAssetRendererFactory().getType())}

		<#if (validator.isNotNull(assetRenderer.getUrlTitle()))>
			<#if (assetRenderer.getGroupId() != themeDisplay.getScopeGroupId())>
				${printURL.setParameter("groupId", assetRenderer.getGroupId()?string)}
			</#if>

			${printURL.setParameter("urlTitle", assetRenderer.getUrlTitle())}
		</#if>

		${printURL.setWindowState("pop_up")}

		<@liferay_ui["icon"]
			image="print"
			message="print"
			url="javascript:Liferay.Util.openWindow({id:'" + renderResponse.getNamespace() + "printAsset', title: '" + languageUtil.format(locale, "print-x-x", ["hide-accessible", entryTitle]) + "', uri: '" + htmlUtil.escapeURL(printURL.toString()) + "'});"
		/>
	</#if>
</#macro>

<#macro getRatings>
	<#if (enableRatings == "true")>
		<div class="asset-ratings">
			<@liferay_ui["ratings"]
				className=entry.getClassName()
				classPK=entry.getClassPK()
			/>
		</div>
	</#if>
</#macro>

<#macro getRelatedAssets>
	<#if assetEntry?? && enableRelatedAssets == "true">
		    <@liferay_ui["asset-links"]
			    assetEntryId=entry.getEntryId()/>
	</#if>
</#macro>

<#macro getSocialBookmarks>
	<#if enableSocialBookmarks?has_content && enableSocialBookmarks == "true">
		<@liferay_ui["social-bookmarks"]
			displayStyle="${socialBookmarksDisplayStyle}"
			target="_blank"
			title=entry.getTitle(locale)
			url=viewURL
		/>
	</#if>
</#macro>