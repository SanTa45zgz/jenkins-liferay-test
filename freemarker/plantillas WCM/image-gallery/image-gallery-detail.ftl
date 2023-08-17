<#assign scopeId = themeDisplay.scopeGroupId>
<#assign journalLocalService = serviceLocator.findService("com.liferay.journal.service.JournalArticleLocalService")>
<#if .vars['reserved-article-id']?has_content>
	<#assign articleId = .vars['reserved-article-id'] > 
<#else>
	<#assign articleId = ""> 
</#if>


<h1>${ ehuimagegallerytitle.getData() }</h1>
<@upvlibs.imageGallerySection ehuslide articleId true 4 />
