<#if themeDisplay.getTheme().getContextPath() == "/o/upv-ehu-global-theme">

    <#assign colorSchemeId = themeDisplay.getColorSchemeId() />
    <#if colorSchemeId?has_content && (colorSchemeId=="08" || colorSchemeId=="06")>  
        <div class="alert alert-error"> 
            <@liferay.language key="ehu.error.theme-color" />
        </div>
    <#else>
        <div class="news-horizontal-publisher">
            <div class="news-horizontal-publisher__list">
            
                <#if entries?has_content>
                    <#assign
                        dLFileEntryLocalService = serviceLocator.findService("com.liferay.document.library.kernel.service.DLFileEntryLocalService")
                        journalArticleLocalService = serviceLocator.findService("com.liferay.journal.service.JournalArticleLocalService")
                        ddmStructureLocalService = serviceLocator.findService("com.liferay.dynamic.data.mapping.service.DDMStructureLocalService")
                    />
                    <#list entries as curEntry>
                        <#assign assetRenderer = curEntry.getAssetRenderer()>

                        <#assign 
                            title = ""
                            description = ""
                            date = ""
                            imageText = ""
                            image = ""
                            featuredImg = ""
                            principalImg = ""
                            featuredTitle = ""
                            principalTitle = ""
                            featuredSubtitle = ""
                            principalSubtitle = ""
                        />
                        <#assign 
                            journalArticle = journalArticleLocalService.getLatestArticle(getterUtil.getLong(curEntry.getClassPK()))
                            date = journalArticle.createDate?date
                        />
                        <#assign viewURL = assetPublisherHelper.getAssetViewURL(renderRequest, renderResponse, curEntry) />

                        <#if assetLinkBehavior != "showFullContent">
                            <#if assetRenderer?? && assetRenderer.getURLViewInContext(renderRequest, renderResponse, viewURL)?? && assetRenderer.getURLViewInContext(renderRequest, renderResponse, viewURL)?has_content>
                                <#assign viewURL = assetRenderer.getURLViewInContext(renderRequest, renderResponse, viewURL) />
                            </#if>
                        </#if>

                        <#if assetRenderer.getClassName() == "com.liferay.journal.model.JournalArticle">
                            <#assign journalArticle = assetRenderer.getAssetObject()/>
                            <#assign structure = ddmStructureLocalService.fetchStructure(curEntry.getClassTypeId()) /> 
                            <#assign fields = assetRenderer.getDDMFormValuesReader().getDDMFormValues().getDDMFormFieldValues()/>
                            <#assign structureName = structure.getName("eu_ES") />

                            <#list fields as field>
                                <#list field.getNestedDDMFormFieldValues() as nestedValue>
                                    <#if nestedValue?? && nestedValue.getValue()?? && nestedValue.getValue()?has_content>

                                        <#if structureName == "Albistea">
                                            <#if nestedValue.getName()=="ehunewtitle">
                                                <#assign principalTitle = nestedValue.getValue().getString(locale)/>
                                            </#if>
                                            <#if nestedValue.getName()=="ehuhighlighttitle">
                                                <#assign featuredTitle = nestedValue.getValue().getString(locale)/>
                                            </#if>
                                            <#if nestedValue.getName()=="ehunewentradilla">
                                                <#assign principalSubtitle = nestedValue.getValue().getString(locale)/>
                                            </#if>
                                            <#if nestedValue.getName()=="ehuhighlightsubtitle">
                                                <#assign featuredSubtitle = nestedValue.getValue().getString(locale)/>
                                            </#if>
                                            <#if nestedValue.getName()=="ehuhighlightimage">
                                                <#assign featuredImg = nestedValue.getValue().getString(locale)/>
                                            </#if>
                                            <#list nestedValue.getNestedDDMFormFieldValues() as nestedValue2>
                                                <#if nestedValue2?? && nestedValue2.getValue()?? && nestedValue2.getValue().getString(locale)?has_content>
                                                    <#if nestedValue2.getName()=="ehunewimage">
                                                        <#assign principalImg = nestedValue2.getValue().getString(locale)/>
                                                    </#if>
                                                    <#if nestedValue2.getName()=="ehuhighlightimagealttext">
                                                        <#assign imageText = nestedValue2.getValue().getString(locale)/>
                                                    </#if>
                                                    <#list nestedValue2.getNestedDDMFormFieldValues() as nestedValue3>
                                                        <#if nestedValue3?? && nestedValue3.getValue()?? && nestedValue3.getValue().getString(locale)?has_content>
                                                            <#if nestedValue3.getName()=="ehunewimagealt">
                                                                <#assign imageText = nestedValue3.getValue().getString(locale)/>
                                                            </#if>
                                                        </#if>
                                                    </#list>
                                                </#if>
                                            </#list>
                                        </#if>

                                        <#if structureName == "Ekitaldia">
                                            <#if nestedValue.getName()=="ehutitle">
                                                <#assign principalTitle = nestedValue.getValue().getString(locale)/>
                                            </#if>
                                            <#if nestedValue.getName()=="ehuhighlighttitle">
                                                <#assign featuredTitle = nestedValue.getValue().getString(locale)/>
                                            </#if>
                                            <#if nestedValue.getName()=="ehuhighlightsubtitle">
                                                <#assign featuredSubtitle = nestedValue.getValue().getString(locale)/>
                                            </#if>
                                            <#if nestedValue?? && nestedValue.getValue()?? && nestedValue.getValue().getString(locale)?has_content>
                                                <#if nestedValue.getName()=="ehugeneraldataimage">
                                                    <#assign principalImg = nestedValue.getValue().getString(locale)/>
                                                </#if>
                                                <#if nestedValue.getName()=="ehuhighlightimage">
                                                    <#assign featuredImg = nestedValue.getValue().getString(locale)/>
                                                </#if>
                                                <#list nestedValue.getNestedDDMFormFieldValues() as nestedValue2>
                                                    <#if nestedValue2?? && nestedValue2.getValue()?? && nestedValue2.getValue().getString(locale)?has_content>
                                                        <#if nestedValue2.getName()=="ehuimagedescription">
                                                            <#assign imageText = nestedValue2.getValue().getString(locale)/>
                                                        </#if>
                                                        <#if nestedValue2.getName()=="ehuhighlightimagealttext">
                                                            <#assign imageText = nestedValue2.getValue().getString(locale)/>
                                                        </#if>
                                                    </#if>
                                                </#list>
                                            </#if>

                                        </#if>

                                        <#if structureName == "Informazioa">
                                            <#if nestedValue.getName()=="ehuinfotitle">
                                                <#assign principalTitle = nestedValue.getValue().getString(locale)/>
                                            </#if>
                                            <#if nestedValue.getName()=="ehuhighlighttitle">
                                                <#assign featuredTitle = nestedValue.getValue().getString(locale)/>
                                            </#if>
                                            <#if nestedValue.getName()=="ehuinfointro">
                                                <#assign principalSubtitle = nestedValue.getValue().getString(locale)/>
                                            </#if>
                                            <#if nestedValue.getName()=="ehuhighlightsubtitle">
                                                <#assign featuredSubtitle = nestedValue.getValue().getString(locale)/>
                                            </#if>
                                            <#if nestedValue.getName()=="ehuhighlightimage">
                                                <#assign featuredImg = nestedValue.getValue().getString(locale)/>
                                            </#if>
                
                                            <#list nestedValue.getNestedDDMFormFieldValues() as nestedValue2>
                                                <#if nestedValue2?? && nestedValue2.getValue()?? && nestedValue2.getValue().getString(locale)?has_content>
                                                    <#if nestedValue2.getName()=="Irudiaren_ordezko_testua101328">
                                                        <#assign imageText = nestedValue2.getValue().getString(locale)/>
                                                    </#if>
                                                    <#if nestedValue2.getName()=="ehuinfoimage">
                                                        <#assign principalImg = nestedValue2.getValue().getString(locale)/>
                                                    </#if>
                                                    <#list nestedValue2.getNestedDDMFormFieldValues() as nestedValue3>
                                                        <#if nestedValue3?? && nestedValue3.getValue()?? && nestedValue3.getValue().getString(locale)?has_content>
                                                            <#if nestedValue3.getName()=="ehuinfoimagealt">
                                                                <#assign imageText = nestedValue3.getValue().getString(locale)/>
                                                            </#if>
                                                        </#if>
                                                    </#list>
                                                </#if>
                                            </#list>
                                            
                                        </#if>

                                    </#if>
                                </#list>
                            </#list>                        
                        

                        <#if featuredImg?has_content>
                            <#assign image = featuredImg />
                        <#else>
                            <#assign image = principalImg />
                        </#if>
                        
                        <#if featuredTitle?has_content>
                            <#assign title = featuredTitle />
                        <#else>
                            <#if principalTitle?has_content>
                                <#assign title = principalTitle />
                            <#else>
                                <#assign title = journalArticle.getTitle() />
                            </#if>
                        </#if>
                        
                        <#if featuredSubtitle?has_content>
                            <#assign description = featuredSubtitle />
                        <#else>
                            <#if principalSubtitle?has_content>
                                <#assign description = principalSubtitle />
                            <#else>
                                <#assign description = "" />
                            </#if>
                        </#if>
                        
                        <#if image?has_content>
                            <#assign
                                image = image?eval
                                imgDLFile = dLFileEntryLocalService.getFileEntryByUuidAndGroupId(image.uuid, image.groupId?number)
                                folderId = imgDLFile.getFolderId()
                                fileNameUrl = imgDLFile.title?replace(" ","+")
                                imgURL = "/documents/" + themeDisplay.getScopeGroupId() + "/" + folderId + "/" + fileNameUrl
                            />
                        </#if>
					</#if>
                        <div class="news-horizontal-publisher__list__item">
                        
                            <div class="news-horizontal-publisher__list__item__image">
                                <div class=" aspect-ratio aspect-ratio-4-to-3">
                                    <#if image?has_content>
                                        <img alt="${imageText}" src="${imgURL}">
                                    <#else>
                                        <img alt="" src="${themeDisplay.getPathThemeImages()}/default-assetpublisher-image.jpg" />
                                    </#if>
                                </div>
                            </div>
                            <div>
                                <#if title?has_content>
                                    <a href="${viewURL}"><p class="news-horizontal-publisher__list__item__title u-text-truncate u-text-truncate--2">${title}</p></a>
                                </#if>
                                <p class="news-horizontal-publisher__list__item__date">
                                    <#if date?has_content>
                                        ${date?string["dd.MM.yyyy"]}
                                    </#if>
                                </p>
                                <#if description?has_content>
                                    <p class="news-horizontal-publisher__list__item__description u-text-truncate u-text-truncate--5">${description}</p>
                                </#if>
                            </div>
                            <a href="${viewURL}" class="c-button c-button--tertiary c-button--only-icon my-auto d-none d-md-flex">
                                <i class="icon-angle-right"></i> <span class="sr-only"><@liferay.language key="ehu.publicador-contenido.button-icon-text" /> ${title}</span>
                            </a>
                        </div>

                    </#list>
                </#if>
            
            </div>
        </div>
    </#if>

<#else>
   <div class="alert alert-error"> 
      <@liferay.language key="ehu.error.theme-color" />
   </div>
</#if>