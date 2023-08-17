<#--
Destacado
https://dev74.ehu.eus/eu/web/pruebas/persona
Nota:solo se usa con global-theme
-->
<#assign liferay_ui = taglibLiferayHash["/META-INF/liferay-ui.tld"] />

<#-- ---------- UPV/EHU  -------- -->
<#-- UPV/EHU 15 enero no se puede ignorar el parámetro category-id porque las noticias de campusa están filtradas por categoria (noticias, fotonoticias) y por lo tanto no funciona la páginación -->
<#-- por ello se pasa a utilizar la configuración manual selectionStyle = dynamic / manual parámetro que en campusa siempre es false -->
<#-- tras este cambio se elimina toda la lógica relacionada con esto sin que afecte a la propiedad de la categoría category-color -->
<#assign itemNumber = 0 />

<#assign journalArticleLocalService = serviceLocator.findService("com.liferay.journal.service.JournalArticleLocalService") />

<#-- Identifica si es el tema campusa -->
<#assign isCampusaTheme = getterUtil.getBoolean(themeDisplay.getPathThemeRoot()?contains("campusa")) />


<#assign urlcurrent = themeDisplay.getURLCurrent() />
<#assign itemNumber = 0 />
<#assign isnothome = ( 
					 ( ( ( (getterUtil.getBoolean(urlcurrent?contains("campusa/"))) && (!getterUtil.getBoolean(urlcurrent?ends_with("campusa/"))) ) ||
					 ( (getterUtil.getBoolean(urlcurrent?contains("campusa-magazine/"))) && (!getterUtil.getBoolean(urlcurrent?ends_with("campusa-magazine/"))) ) ) &&
					 (!getterUtil.getBoolean(urlcurrent?contains("campusa-magazine/home"))) )||
					 (getterUtil.getBoolean(urlcurrent?contains("/-/")))
					 
					 ) />
<#assign isnotfirstpage = getterUtil.getBoolean(urlcurrent?contains("_cur")) />
<#assign isfirstpage = getterUtil.getBoolean(urlcurrent?contains("_cur=1")) />

<#if ((isnothome || isnotfirstpage) && isCampusaTheme)>
	<#assign itemNumber = 1 />
</#if>
 <#-- para que al volver a la home después de haber paginado se mantenga el item-0-->
<#if ((!isnothome && isfirstpage) && isCampusaTheme)>
	<#assign itemNumber = 0 />
</#if>

 
<div class="asset-list asset-list-highlight thumbnails">
<#-- ---------- UPV/EHU - UPV/EHU ---------- -->
    <#list entries as entry>

	<#assign entry = entry />
	
	<#assign assetRenderer = entry.getAssetRenderer() />
	
	<#assign entryTitle = htmlUtil.escape(assetRenderer.getTitle(locale)) />
        
	<#assign viewURL = assetPublisherHelper.getAssetViewURL(renderRequest, renderResponse, entry) />

	<#-- ---------- UPV/EHU  -------- -->
	<#-- Si la URL para mostrar el contenido completo es de la parte publica del sitio web guest se quita de la URL -->
	<#assign guestPublicSiteURL = "/web/guest" />
	<#if viewURL?contains(guestPublicSiteURL) >
            <#assign viewURL = viewURL?replace(guestPublicSiteURL, "") />
	</#if>
	
	
	<#assign journalArticle = assetRenderer.getArticle() />
	
	<#assign layoutUuid = journalArticle.getLayoutUuid() />
	
	<#if layoutUuid?? && !validator.isBlank(layoutUuid)>
		<#assign urlViewContext = assetRenderer.getURLViewInContext(renderRequest, renderResponse, viewURL) />
		<#assign viewURL = urlViewContext />
	</#if>
	
	<#-- no se puede mantener la condición de arriba porque ahora el de la home se supone que tb es dinámico y empezará siempre por 1. (líneas 13-24)-->
	<#-- se utiliza lo añadido en las líneas 26-39 -->
	<#if isCampusaTheme>
		<#-- Para que la primera noticia que no es destacada no salga con span 12 miramos que no contenga la categoría "Destacadas" -->
		<#assign destacado = false />
		<#assign categories = entry.getCategories() />
		<#list categories as articleCategory>
			<#assign categoryId = articleCategory.getCategoryId()/>
			<#-- <#if (categoryId == 9280519) || (categoryId == 11743613) > --> <#-- Categorías "Destacadas" en INT --> 
			<#-- <#if (categoryId == 363644) || (categoryId == 1379717) > -->  <#-- Categorías "Destacadas" en DEV -->
			<#if (categoryId == 11792428) || (categoryId == 11634291) > <#-- Categorías "Destacadas" en PROD -->
				<#assign destacado = true />
			</#if>
		</#list>
		
		<#if itemNumber == 0 && destacado == true >
			<div class="asset-highlight item-${itemNumber} span12" >			
        <#else> 
        	<div class="asset-highlight item-${itemNumber} span6" >
         </#if>  
    <#else>    
   		<div class="asset-highlight item-${itemNumber}" >
    </#if>
	
    <div class="lfr-meta-actions asset-actions">
		<@getEditIcon />
	</div>

		<#-- Si el publicador muestra solo contenidos, se muestra cada contenido con la plantilla highlight correspondiente al tipo del contenido si existe dicha plantilla, sino aparece mensaje de error -->
		
		<#assign journalArticleClass = "com.liferay.journal.model.JournalArticle" />
		<#assign ddmTemplateKey = 0 />
		
		<#if assetRenderer.getClassName() == journalArticleClass >
                        
                        <#assign structureIdStr = assetRenderer.getArticle().getStructureId() />
                        <#assign globalGroupId = themeDisplay.getCompanyGroupId() />
                        <#assign localGroupId = themeDisplay.getSiteGroupId() />
                        <#assign classNameId = portalUtil.getClassNameId(journalArticleClass)/>
                        <#assign ddmStructureLocalService = serviceLocator.findService("com.liferay.dynamic.data.mapping.service.DDMStructureLocalService") />
                        
                        
                        <#-- Si existe la estructura/tipo de contenido en el ambito Global -->
                        <#if (ddmStructureLocalService.getStructure(globalGroupId,classNameId,structureIdStr)??)>
                            <#assign ddmStructure = ddmStructureLocalService.getStructure(globalGroupId,classNameId,structureIdStr) />
                        <#-- Si existe la estructura/tipo de contenido en el ambito Local -->    
                        <#else>
                            <#-- Si existe la estructura/tipo de contenido en el ambito Local -->    
                            <#if (ddmStructureLocalService.getStructure(localGroupId,classNameId,structureIdStr)??)>
                                <#assign ddmStructure = ddmStructureLocalService.getStructure(localGroupId,classNameId,structureIdStr) />
                            </#if>     
                        </#if>    
                        
                        <#-- Si existe la estructura/tipo de contenido -->
                        <#if ddmStructure?? > 
                            
                            <#assign templateName = "Highlight" />
                            <#assign ddmTemplates = ddmStructure.getTemplates() />
                            <#-- ---------- Si la estructura/tipo de contenido tiene asociadas plantillas/visualizaciones -->
                            <#assign isOutStanding = false />
                            <#if (ddmTemplates??)>
                                <#list ddmTemplates as ddmTemplate>
                                    <#-- Si la plantilla/visualizacion es de tipo destacado -->
                                    <#if ddmTemplate.getName()?contains(templateName)>
                                        <#assign ddmTemplateKeyStr = ddmTemplate.getTemplateKey()/>
                                        <#assign ddmTemplateKey = getterUtil.getLongStrict(ddmTemplateKeyStr)/>    
                                    </#if>    
                                    <#if ddmStructure.getName()?contains("Outstanding")>
                                    	 <#assign isOutStanding = true />
                                     </#if>    
                                </#list>
                            </#if>                        
                            <#if (ddmTemplateKey != 0)>

                                <#if isOutStanding>
                                		<#assign document = saxReaderUtil.read(assetRenderer.getArticle().getContentByLocale(locale)) />
                                		<#assign ref = document.valueOf("//dynamic-element[@name='ehuoutstandinglink']/dynamic-content/text()") />
                                		<#assign protocol = httpUtil.getProtocol(request) />
                                		<#assign refProtocol = httpUtil.getProtocol(ref) />
										<#assign urlTitle = document.valueOf("//dynamic-element[@name='ehuoutstandinglink']/dynamic-element[@name='ehuoutstandinglinktitle']/dynamic-content/text()") />
                                	
                                		<#if (refProtocol??)>
                                			<#if ref?contains(refProtocol)>
                                				<#assign viewURL = ref/>
                                			<#else>
                                				<#assign viewURL = refProtocol + "://" + ref/>
                                			</#if>
                                		<#else>
                                			<#assign viewURL =  protocol + "://" + ref/>
                                		</#if>
	                                	
	                             </#if>    
	                            <#-- Pintamos el article -->	
								<div class="box">	
									<#assign journalArticle = assetRenderer.getAssetObject()/>
									<#-- Si la URL tiene title lo pintamosntamos -->
									<#if !validator.isBlank(urlTitle)>
										<a href="${viewURL}" title="${urlTitle}" class="thumbnail">
									<#else>
										<a href="${viewURL}" class="thumbnail">
									</#if>
									
									<#if journalArticleLocalService.fetchJournalArticle(journalArticle.getId())??>
										${journalArticleLocalService.getArticleContent(journalArticle, ddmTemplateKeyStr,"VIEW", locale, themeDisplay)}	
									</#if>							
	                                </a>
	                            </div>
                            <#else>    
                                <div class="alert alert-error"> ${ddmStructure.getNameCurrentValue()} <@liferay.language key="ehu.error.structure-has-no-highlight-template-select-another-template" /></div>
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
                            <#if assetRenderer?? && assetRenderer.getIconPath??>
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

                                        ${htmlUtil.escape(assetRenderer.getSummary(renderRequest,renderResponse))}

                                        <a href="${viewURL}"><@liferay.language key="read-more" /><span class="hide-accessible"><@liferay.language key="about" />${entryTitle}</span> &raquo;</a>
                                </div>

                                <@getRatings />

                                <@getRelatedAssets />

                                <@getDiscussion />
                        </div>
                </#if>
		
	</div>
    </#list>
</div>
    
<#-- ---------- UPV/EHU ---------- -->  
<#-- ---------- UPV/EHU - UPV/EHU ---------- -->  

<#macro getDiscussion>
	<#if assetRenderer?? && assetRenderer.getDiscussionPath()?? && (enableComments == "true")>
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
		<span class="metadata-entry metadata-"${fieldName}">
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
	<#if enableRelatedAssets == "true">
		<liferay-asset:asset-links
		assetEntryId="<%= (entry != null) ? entry.getEntryId() : 0 %>"
		className="<%= entry.getClassName() %>"
		classPK="<%= entry.getClassPK() %>"
		/>		
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

<#-- ---------- UPV/EHU  -------- -->

<#-- Mostrar la categoria campusa de nivel mas profundo (si es categoria hija de otra categoria se muestra el color y el titulo de la categoria hija) con el color de fondo indicado en la propiedad "category-color" -->
<#macro getCampusaCategory>
    <#if serviceLocator??>
        <#assign assetCategoryLocalService = serviceLocator.findService("com.liferay.asset.kernel.service.AssetCategoryLocalService")/>
        <#assign articleResourcePrimKey = assetRenderer.getArticle().getResourcePrimKey()/> 
        <#assign articleCategories = assetCategoryLocalService.getCategories("com.liferay.portlet.journal.model.JournalArticle",articleResourcePrimKey)/>
        <#assign assetCategoryPropertiesLocalService = serviceLocator.findService("com.liferay.portlet.asset.service.AssetCategoryPropertyLocalService")>
        <#list articleCategories as articleCategory>
            <#assign articleCategory = articleCategory />
            <#assign categoryTitle = articleCategory.getTitle(locale,false)/>
            <#assign categoryId = articleCategory.getCategoryId()/>
            <#assign parentCategoryId = articleCategory.getParentCategoryId()/>
            <#assign childCategoriesCount = assetCategoryLocalService.getChildCategoriesCount(categoryId)/>
            <#-- Se muestra la categoria si:
                - la categoria no tiene categoria padre ni categorias hija
                - la categoria tiene categoria padre (independientemente de si esta chequeada o no) -->
            <#if ( (parentCategoryId == 0) && (childCategoriesCount == 0) || (parentCategoryId != 0) ) >
                <#-- Si la categoria tiene propiedad category-color -->
                <#if (validator.isNotNull(assetCategoryPropertiesLocalService.getCategoryProperty(categoryId,"category-color"))) >
                    <#assign categoryColorProperty = assetCategoryPropertiesLocalService.getCategoryProperty(categoryId,"category-color")>
                    <#assign categoryColor = categoryColorProperty.getValue()/>
                    <#-- Si la propiedad tiene valor distinto de vacio-->    
                    <#if (categoryColor != '')>
                        <span style="background-color:#${categoryColor};">${categoryTitle}</span>
                    </#if>     
                </#if>    
            <#-- Se muestra la categoria si tiene categorias hija y ninguna esta asociada al contenido --> 
            <#elseif (childCategoriesCount != 0) >
                <#assign childCategorySelected = getterUtil.getBoolean("false") />
                <#assign childCategories = assetCategoryLocalService.getChildCategories(categoryId) />
                <#-- Se recorren las categorias hija -->
                <#list childCategories as childCategory > 
                    <#assign childCategoryId = childCategory.getCategoryId() />
                    <#-- Se recorren las categorias asociadas al contenido -->
                    <#list articleCategories as articleCategory>               
                        <#assign contentCategoryId = articleCategory.getCategoryId() />
                        <#-- Si alguna de las categorias hija es alguna de las asociadas al contenido, se muestra la categoria  -->
                        <#if (childCategoryId == contentCategoryId)>
                            <#assign childCategorySelected = getterUtil.getBoolean("true") />
                        </#if>
                    </#list>
                 </#list>
                 <#-- Si ninguna de las categorias hija esta asociada al contenido se muestra la categoria padre asociada al contenido -->
                 <#if (!childCategorySelected)>
                    <#-- Si la categoria tiene propiedad category-color -->
                    <#if (validator.isNotNull(assetCategoryPropertiesLocalService.getCategoryProperty(categoryId,"category-color"))) >
                        <#assign categoryColorProperty = assetCategoryPropertiesLocalService.getCategoryProperty(categoryId,"category-color")>
                        <#assign categoryColor = categoryColorProperty.getValue()/>
                        <#-- Si la propiedad tiene valor distinto de vacio-->    
                        <#if (categoryColor != '')>
                            <span style="background-color:#${categoryColor};">${categoryTitle}</span>
                        </#if>     
                    </#if>
                 </#if>        
            </#if>                              
        </#list>
    </#if>
</#macro>
<#-- ---------- UPV/EHU - UPV/EHU -------- -->