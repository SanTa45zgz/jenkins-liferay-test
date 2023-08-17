<#--
Nombre contenido (ES): Persona
Estructura: global > person.json
Plantilla (ES): Resumen
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

<#assign globalGroupId =  company.getGroupId()>

<#assign personName = ehucontactdata.ehuname.getData()>

<#assign personJob="">

<div class="person">

	<strong>${personName}</strong>
	<#list articleCategories as category >
        <#assign vocabulary = vocLocalService.getVocabulary(getterUtil.getLong(category.getVocabularyId()))>
        <#if vocabulary.getName() == "Hartzaileak" && vocabulary.getGroupId() == globalGroupId >
            <small><span class="receiver-level-1">${category.getTitle(locale)}</span></small>
        </#if>
    </#list> 
                
    <#if ehucontactdata.ehuotherinformation.getData()?has_content >
        <small>(${ehucontactdata.ehuotherinformation.getData()})</small>
    </#if>    
</div>