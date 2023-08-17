<#if themeDisplay.getTheme().getContextPath() == "/o/upv-ehu-global-theme">
    <#assign colorSchemeId = themeDisplay.getColorSchemeId() />
    <#if colorSchemeId?has_content && (colorSchemeId=="08" || colorSchemeId=="06")>  
        <div class="alert alert-error"> 
            <@liferay.language key="ehu.error.theme-color" />
        </div>
    <#else>
        <div class="content-featured-publisher">
            <div class="row">
                <#if entries?has_content>
                    <#assign
                        dLFileEntryLocalService = serviceLocator.findService("com.liferay.document.library.kernel.service.DLFileEntryLocalService")
                        ddmTemplateLocalService = serviceLocator.findService("com.liferay.dynamic.data.mapping.service.DDMTemplateLocalService")
                        journalArticleLocalService = serviceLocator.findService("com.liferay.journal.service.JournalArticleLocalService")
                    />
                    <#list entries as curEntry>
                   		<#assign assetRenderer = curEntry.getAssetRenderer()>
                    	<#assign journalArticle = assetRenderer.getAssetObject()/>
                    	<#assign templatekey = journalArticle.getDDMTemplateKey() />

                    	<#-- desarrollo -->
           				<#--assign videoTemplayKey = "25735368" /-->
           				<#--assign imageTemplateKey = "25735364" /-->
           				<#--assign videoHTemplayKey = "25735378" /-->
           				<#--assign imageHTemplateKey = "25735374" /-->
           				
           				<#-- integracion -->
           				<#--assign videoTemplayKey = "40500070" /-->
           				<#--assign imageTemplateKey = "40500074" /-->
           				<#--assign videoHTemplayKey = "40500100" /-->
           				<#--assign imageHTemplateKey = "40500125" /-->
           				 
 						<#-- prod -->
           				<#assign videoTemplayKey = "40500070" />
           				<#assign imageTemplateKey = "40500074" />
           				<#assign videoHTemplayKey = "40500100" />
           				<#assign imageHTemplateKey = "40500125" />
           				
                        <#assign fields = assetRenderer.getDDMFormValuesReader().getDDMFormValues().getDDMFormFieldValues()/>
                        <#assign 
                            title = ""
                            description = ""
                            link = ""
                            linkText = ""
                            linkTarget = ""
                            link2 = ""
                            linkText2 = ""
                            linkTarget2 = ""
                            link3 = ""
                            linkText3 = ""
                            linkTarget3 = ""
                            urlVideo = ""
                            imageText = ""
                            image = ""
                        />
                        
                        <#list fields as field>
            
                            <#list field.getNestedDDMFormFieldValues() as nestedValue>
                            
                                <#if nestedValue?? && nestedValue.getValue()?? && nestedValue.getValue().getString(locale)?has_content>
                               
                                    <#if nestedValue.getName()=="titulo">
                                        <#assign title = nestedValue.getValue().getString(locale)/>
                                    </#if>

                                    <#if nestedValue.getName()=="descripcion">
                                        <#assign description = nestedValue.getValue().getString(locale)/>
                                    </#if>

                                    <#if nestedValue.getName()=="EnlacePrincipal">
                                        <#assign linkText = nestedValue.getValue().getString(locale)/>
                                    </#if>

                                    <#if nestedValue.getName()=="EnlaceSecundario">
                                        <#assign linkText2 = nestedValue.getValue().getString(locale)/>
                                    </#if>

                                    <#if nestedValue.getName()=="EnlaceTerciario">
                                        <#assign linkText3 = nestedValue.getValue().getString(locale)/>
                                    </#if>

                                    <#if nestedValue.getName()=="UrlVideo" && (videoTemplayKey == templatekey || videoHTemplayKey == templatekey)>
                                        <#assign urlVideo = nestedValue.getValue().getString(locale)/>
                                    </#if>
                                    <#if nestedValue.getName()=="ImagenDelFondo" && (imageTemplateKey == templatekey || imageHTemplateKey == templatekey)>

                                        <#assign image = nestedValue.getValue().getString(locale)?eval />
                                            <#if image?has_content>
                                                <#assign
                                                    imgDLFile = dLFileEntryLocalService.getFileEntryByUuidAndGroupId(image.uuid, image.groupId?number)
                                                    folderId = imgDLFile.getFolderId()
                                                    fileNameUrl = imgDLFile.title?replace(" ","+")
                                                    imgURL = "/documents/" + themeDisplay.getScopeGroupId() + "/" + folderId + "/" + fileNameUrl
                                                />
                                            </#if>
                                    </#if>
                                    <#list nestedValue.getNestedDDMFormFieldValues() as nestedValue2>
                                        <#if nestedValue2?? && nestedValue2.getValue()?? && nestedValue2.getValue().getString(locale)?has_content>
                                            <#if nestedValue2.getName()=="UrlPrincipal">
                                                <#assign link = nestedValue2.getValue().getString(locale)/>
                                            </#if>

                                            <#if nestedValue2.getName()=="UrlSecundaria">
                                                <#assign link2 = nestedValue2.getValue().getString(locale)/>
                                            </#if>

                                            <#if nestedValue2.getName()=="UrlTerciaria">
                                                <#assign link3 = nestedValue2.getValue().getString(locale)/>
                                            </#if>

                                            <#if nestedValue2.getName()=="alt_fondo">
                                                <#assign imageText = nestedValue2.getValue().getString(locale)/>
                                            </#if>
                                            <#list nestedValue2.getNestedDDMFormFieldValues() as nestedValue3>
                                                <#if nestedValue3?? && nestedValue3.getValue()?? && nestedValue3.getValue().getString(locale)?has_content>
                                                    <#if nestedValue3.getName()=="Externo">
                                                        <#if nestedValue3.getValue().getString(locale)=="Si" >
                                                            <#assign linkTarget = "_blank"/>
                                                        <#else>
                                                            <#assign linkTarget = "_self"/>
                                                        </#if>
                                                    </#if>
                                                    <#if nestedValue3.getName()=="ExternoSecundario">
                                                        <#if nestedValue3.getValue().getString(locale)=="Si" >
                                                            <#assign linkTarget2 = "_blank"/>
                                                        <#else>
                                                            <#assign linkTarget2 = "_self"/>
                                                        </#if>
                                                    </#if>
                                                    <#if nestedValue3.getName()=="ExternoTerciario">
                                                        <#if nestedValue3.getValue().getString(locale)=="Si" >
                                                            <#assign linkTarget3 = "_blank"/>
                                                        <#else>
                                                            <#assign linkTarget3 = "_self"/>
                                                        </#if>
                                                    </#if>
                                                </#if>
                                            </#list>
                                        </#if>
                                    </#list>
                                </#if>
                            </#list>
                        </#list>
                        <#if entries?size gt 1>
                            <div class="content-featured-publisher__item col-12 col-lg-6">
                        <#else>
                             <div class="content-featured-publisher__item col">
                        </#if>
                            <#if image?has_content>
                                <div class="content-featured-publisher__item__image aspect-ratio aspect-ratio-16-to-9">
                                    <img alt="${imageText}" src="${imgURL}">
                                </div>
                            <#elseif urlVideo?has_content>
                                <div class="content-featured-publisher__item__video embed-responsive embed-responsive-16by9">
                                	<#assign titleIFrame = languageUtil.get( locale, "video" )/>
                                    <iframe title="${titleIFrame}" class="embed-responsive-item" src="${urlVideo}" allowfullscreen></iframe>

                                </div>
                            <#else>
                                <div class="content-featured-publisher__item__image aspect-ratio aspect-ratio-16-to-9">
                                    <img alt="" src="${themeDisplay.getPathThemeImages()}/default-assetpublisher-image.jpg" />
                                </div>
                            </#if>

                            <#if title?has_content>
                                <h2 class="content-featured-publisher__item__title u-text-truncate u-text-truncate--3">${title}</h2>
                            </#if>
                            <div >
                                <#if description?has_content>
                                     <p class="content-featured-publisher__item__description u-text-truncate u-text-truncate--3">${description}</p>
                                </#if>
                                <#if link?has_content>
                                    <a href="${link}" target="${linkTarget}" class="content-featured-publisher__item__link">
                                        ${linkText}
                                        <#if linkTarget == "_blank">
                                            <span class="hide-accessible">(Abre una nueva ventana)</span>
                                        </#if>
                                    </a>
                                </#if>
                                <#if link2?has_content>
                                    <a href="${link2}" target="${linkTarget2}" class="content-featured-publisher__item__link">
                                        ${linkText2}
                                        <#if linkTarget2 == "_blank">
                                            <span class="hide-accessible">(Abre una nueva ventana)</span>
                                        </#if>
                                    </a>
                                </#if>
                                <#if link3?has_content>
                                    <a href="${link3}" target="${linkTarget3}" class="content-featured-publisher__item__link">
                                        ${linkText3}
                                        <#if linkTarget3 == "_blank">
                                            <span class="hide-accessible">(Abre una nueva ventana)</span>
                                        </#if>
                                    </a>
                                </#if>
                            </div>
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