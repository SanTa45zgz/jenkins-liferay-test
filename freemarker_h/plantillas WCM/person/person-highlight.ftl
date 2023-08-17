<#--
Nombre contenido (ES): Persona
Estructura: global > person.json
Plantilla (ES): Destacado
URL: https://dev74.ehu.eus/es/web/pruebas/persona
Nota: Se usa con global-theme y con ehu-theme
-->

<#assign journalLocalService = serviceLocator.findService("com.liferay.journal.service.JournalArticleLocalService")>
<#assign scopeId = themeDisplay.scopeGroupId>

<#if journalLocalService.fetchArticle(scopeId, .vars['reserved-article-id'].data)??>
    <#assign articlePrimKey = journalLocalService.getArticle(scopeId, .vars['reserved-article-id'].data).resourcePrimKey >
</#if>

<#assign catLocalService = serviceLocator.findService("com.liferay.asset.kernel.service.AssetCategoryLocalService")>
<#assign articleCategories = catLocalService.getCategories("com.liferay.journal.model.JournalArticle", getterUtil.getLong(articlePrimKey))>
<#assign vocLocalService = serviceLocator.findService("com.liferay.asset.kernel.service.AssetVocabularyLocalService")>
<#assign globalGroupId = company.getGroupId()>

<#assign personName = ehucontactdata.ehuname.getData()>
<#assign personImage= ehucontactdata.ehuimage.getData()>
<#assign personJob="">

<div class="person">
    <#if !personImage?? || "" == personImage >
        <#assign personImage="/image/user_male_portrait">
    </#if>
    <figure>
        <img class="person_photo" src="${personImage}" alt="">
            <figcaption>
                <h2><span class="highlight-title">${personName}</span></h2>
                <#list articleCategories as category >
                    <#assign vocabulary = vocLocalService.getVocabulary(getterUtil.getLong(category.getVocabularyId()))>
                    <#if vocabulary.getName() == "Hartzaileak" && vocabulary.getGroupId() == globalGroupId >
                        <h3><span class="receiver-level-1">${category.getTitle(locale)}</span></h3>
                    </#if>
                </#list> 
                <#if ehucontactdata.ehuotherinformation.getData()?has_content >
                    <p>(${ehucontactdata.ehuotherinformation.getData()})</p>
                </#if>    
            </figcaption>
        </figure>
</div>