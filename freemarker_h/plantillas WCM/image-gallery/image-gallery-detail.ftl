<#--
Nombre contenido (ES): Galería de imágenes
Estructura: global > image-gallery.json
Plantilla (ES): Contenido Completo
URL: https://dev74.ehu.eus/es/web/pruebas/galeria
Nota: Se usa con global-theme y con ehu-theme
-->

<#assign scopeId = themeDisplay.scopeGroupId>
<#assign journalLocalService = serviceLocator.findService("com.liferay.journal.service.JournalArticleLocalService")>
<#if .vars['reserved-article-id']?has_content>
	<#assign articleId = .vars['reserved-article-id'] > 
<#else>
	<#assign articleId = ""> 
</#if>


<h1>${ ehuimagegallerytitle.getData() }</h1>
<@upvlibs.imageGallerySection ehuslide articleId true 4 />
